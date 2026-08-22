import { getFirestore, FieldValue, Transaction } from "firebase-admin/firestore";
import { EconomyConfig, WalletDoc, TransactionDoc, TransactionType } from "./economy_config";

const db = () => getFirestore();

// ── Firestore paths ────────────────────────────────────────────────────────────

export const walletPath = (uid: string) =>
  `players/${uid}/economy/wallet`;
export const transactionsPath = (uid: string) =>
  `players/${uid}/economy/transactions`;
export const operationReceiptsPath = (uid: string) =>
  `players/${uid}/economy/operations`;

// ── Idempotency ────────────────────────────────────────────────────────────────

/**
 * Returns existing receipt if idempotencyKey already processed, else null.
 */
export async function getExistingReceipt(
  uid: string,
  idempotencyKey: string
): Promise<FirebaseFirestore.DocumentSnapshot | null> {
  const safeKey = idempotencyKey.replace(/[/]/g, "_");
  const ref = db()
    .collection(operationReceiptsPath(uid))
    .doc(safeKey);
  const snap = await ref.get();
  return snap.exists ? snap : null;
}

// ── Atomic wallet mutation ─────────────────────────────────────────────────────

export interface MutationEntry {
  type: TransactionType;
  resource: "coins" | "hints";
  amount: number; // positive = earn, negative = spend
  referenceType: string;
  referenceId: string;
  idempotencyKey: string;
  metadata?: Record<string, unknown>;
}

export interface MutationResult {
  coinBalanceAfter: number;
  hintBalanceAfter: number;
  walletRevision: number;
  transactionIds: string[];
}

/**
 * Atomically mutates wallet + writes ledger entries + idempotency receipt.
 * Throws on negative balance or constraint violation.
 */
export async function atomicWalletMutation(
  uid: string,
  idempotencyKey: string,
  operationType: TransactionType,
  referenceId: string,
  mutations: MutationEntry[]
): Promise<MutationResult> {
  const walletRef = db().doc(walletPath(uid));
  const safeKey = idempotencyKey.replace(/[/]/g, "_");
  const receiptRef = db()
    .collection(operationReceiptsPath(uid))
    .doc(safeKey);

  const txnIds: string[] = [];

  const result = await db().runTransaction(async (t: Transaction) => {
    // Read wallet
    const walletSnap = await t.get(walletRef);
    let wallet: WalletDoc;
    if (!walletSnap.exists) {
      // Bootstrap — should only happen on initializeWallet call
      wallet = {
        coinBalance: 0,
        hintBalance: 0,
        walletRevision: 0,
        lifetimeEarnedCoins: 0,
        lifetimeSpentCoins: 0,
        walletSchemaVersion: 1,
        updatedAt: FieldValue.serverTimestamp(),
      };
    } else {
      wallet = walletSnap.data() as WalletDoc;
    }

    let coinBalance = wallet.coinBalance;
    let hintBalance = wallet.hintBalance;
    let lifetimeEarned = wallet.lifetimeEarnedCoins;
    let lifetimeSpent = wallet.lifetimeSpentCoins;

    // Apply mutations
    for (const m of mutations) {
      const txnId = `${idempotencyKey}_${m.resource}`;
      txnIds.push(txnId);

      const balanceBefore =
        m.resource === "coins" ? coinBalance : hintBalance;
      const balanceAfter = balanceBefore + m.amount;

      // Guard: never go negative
      if (balanceAfter < 0) {
        throw new Error(
          `insufficientFunds:${m.resource}:balance=${balanceBefore}:cost=${Math.abs(m.amount)}`
        );
      }

      if (m.resource === "coins") {
        coinBalance = balanceAfter;
        if (m.amount > 0) lifetimeEarned += m.amount;
        else lifetimeSpent += Math.abs(m.amount);
      } else {
        hintBalance = balanceAfter;
        if (m.amount > 0) lifetimeEarned += m.amount;
        else lifetimeSpent += Math.abs(m.amount);
      }

      const txnRef = db()
        .collection(transactionsPath(uid))
        .doc(txnId);
      const txnDoc: TransactionDoc = {
        transactionId: txnId,
        uid,
        type: m.type,
        resource: m.resource,
        amount: m.amount,
        balanceBefore,
        balanceAfter,
        idempotencyKey: m.idempotencyKey,
        referenceType: m.referenceType,
        referenceId: m.referenceId,
        createdAt: FieldValue.serverTimestamp(),
        economyConfigVersion: EconomyConfig.economyConfigVersion,
        metadata: m.metadata,
      };
      t.set(txnRef, txnDoc);
    }

    const newRevision = wallet.walletRevision + 1;

    // Update wallet
    t.set(walletRef, {
      coinBalance,
      hintBalance,
      walletRevision: newRevision,
      lifetimeEarnedCoins: lifetimeEarned,
      lifetimeSpentCoins: lifetimeSpent,
      walletSchemaVersion: 1,
      updatedAt: FieldValue.serverTimestamp(),
    } satisfies WalletDoc);

    // Write receipt
    t.set(receiptRef, {
      status: "completed",
      operationType,
      coinBalanceAfter: coinBalance,
      hintBalanceAfter: hintBalance,
      walletRevision: newRevision,
      transactionIds: txnIds,
      createdAt: FieldValue.serverTimestamp(),
      uid,
      referenceId,
    });

    return {
      coinBalanceAfter: coinBalance,
      hintBalanceAfter: hintBalance,
      walletRevision: newRevision,
      transactionIds: txnIds,
    };
  });

  return result;
}
