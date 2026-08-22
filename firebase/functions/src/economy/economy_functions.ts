import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { EconomyConfig, EconomyResult } from "./economy_config";
import {
  atomicWalletMutation,
  getExistingReceipt,
  walletPath,
} from "./wallet_service";

function requireAuth(request: CallableRequest): string {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Auth required");
  }
  return request.auth.uid;
}

function existingReceiptToResult(
  idempotencyKey: string,
  d: FirebaseFirestore.DocumentData
): EconomyResult {
  return {
    success: true,
    operationId: idempotencyKey,
    coinBalanceAfter: d["coinBalanceAfter"],
    hintBalanceAfter: d["hintBalanceAfter"],
    walletRevision: d["walletRevision"],
    transactionIds: d["transactionIds"],
    isDuplicate: true,
    economyConfigVersion: EconomyConfig.economyConfigVersion,
  };
}

function insufficientFundsResult(
  idempotencyKey: string,
  resource: "coins" | "hints"
): EconomyResult {
  return {
    success: false,
    operationId: idempotencyKey,
    errorCode: resource === "coins" ? "insufficientFunds" : "insufficientHints",
    economyConfigVersion: EconomyConfig.economyConfigVersion,
  };
}

// ── initializeWallet ──────────────────────────────────────────────────────────

export const initializeWallet = onCall(async (request) => {
  const uid = requireAuth(request);
  const idempotencyKey = `initial_grant:${uid}:v1`;

  const existing = await getExistingReceipt(uid, idempotencyKey);
  if (existing) return existingReceiptToResult(idempotencyKey, existing.data()!);

  const result = await atomicWalletMutation(
    uid,
    idempotencyKey,
    "initialGrant",
    "initial",
    [
      {
        type: "initialGrant",
        resource: "coins",
        amount: EconomyConfig.startingCoins,
        referenceType: "system",
        referenceId: "initial",
        idempotencyKey,
      },
      {
        type: "initialGrant",
        resource: "hints",
        amount: EconomyConfig.startingHints,
        referenceType: "system",
        referenceId: "initial",
        idempotencyKey,
      },
    ]
  );

  return { success: true, operationId: idempotencyKey, ...result, isDuplicate: false, economyConfigVersion: EconomyConfig.economyConfigVersion } satisfies EconomyResult;
});

// ── grantLevelReward ──────────────────────────────────────────────────────────

export const grantLevelReward = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data as Record<string, unknown>;

  const levelId = String(data["levelId"] ?? "");
  const completionId = String(data["completionId"] ?? "");
  const remainingMoves = Math.max(0, Number(data["remainingMoves"]) || 0);
  const streakCoins = Math.min(
    Math.max(0, Number(data["streakCoins"]) || 0),
    EconomyConfig.maxStreakCoinsPerLevel
  );

  if (!levelId || !completionId) {
    throw new HttpsError("invalid-argument", "levelId and completionId required");
  }
  if (remainingMoves > EconomyConfig.maxRemainingMoves) {
    throw new HttpsError("invalid-argument", "remainingMoves out of range");
  }

  const idempotencyKey = `level_reward:${uid}:${levelId}:${completionId}`;
  const existing = await getExistingReceipt(uid, idempotencyKey);
  if (existing) return existingReceiptToResult(idempotencyKey, existing.data()!);

  const reward =
    EconomyConfig.levelRewardBase +
    EconomyConfig.levelRewardPerRemainingMove * remainingMoves +
    streakCoins;

  const result = await atomicWalletMutation(uid, idempotencyKey, "levelReward", levelId, [
    {
      type: "levelReward",
      resource: "coins",
      amount: reward,
      referenceType: "level",
      referenceId: levelId,
      idempotencyKey,
      metadata: { remainingMoves, streakCoins, completionId },
    },
  ]);

  return { success: true, operationId: idempotencyKey, ...result, isDuplicate: false, economyConfigVersion: EconomyConfig.economyConfigVersion } satisfies EconomyResult;
});

// ── grantChapterReward ────────────────────────────────────────────────────────

export const grantChapterReward = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data as Record<string, unknown>;
  const chapterId = String(data["chapterId"] ?? "");
  if (!chapterId) throw new HttpsError("invalid-argument", "chapterId required");

  const idempotencyKey = `chapter_reward:${uid}:${chapterId}:v1`;
  const existing = await getExistingReceipt(uid, idempotencyKey);
  if (existing) return existingReceiptToResult(idempotencyKey, existing.data()!);

  const result = await atomicWalletMutation(uid, idempotencyKey, "chapterReward", chapterId, [
    {
      type: "chapterReward",
      resource: "coins",
      amount: EconomyConfig.chapterRewardCoins,
      referenceType: "chapter",
      referenceId: chapterId,
      idempotencyKey,
    },
    {
      type: "chapterReward",
      resource: "hints",
      amount: EconomyConfig.chapterRewardHints,
      referenceType: "chapter",
      referenceId: chapterId,
      idempotencyKey,
    },
  ]);

  return { success: true, operationId: idempotencyKey, ...result, isDuplicate: false, economyConfigVersion: EconomyConfig.economyConfigVersion } satisfies EconomyResult;
});

// ── purchaseHint ──────────────────────────────────────────────────────────────

export const purchaseHint = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data as Record<string, unknown>;
  const operationId = String(data["operationId"] ?? "");
  if (!operationId) throw new HttpsError("invalid-argument", "operationId required");

  const idempotencyKey = `hint_purchase:${uid}:${operationId}`;
  const existing = await getExistingReceipt(uid, idempotencyKey);
  if (existing) return existingReceiptToResult(idempotencyKey, existing.data()!);

  try {
    const result = await atomicWalletMutation(uid, idempotencyKey, "hintPurchase", operationId, [
      { type: "hintPurchase", resource: "coins", amount: -EconomyConfig.hintCostCoins, referenceType: "hint_purchase", referenceId: operationId, idempotencyKey },
      { type: "hintPurchase", resource: "hints", amount: 1, referenceType: "hint_purchase", referenceId: operationId, idempotencyKey },
    ]);
    return { success: true, operationId: idempotencyKey, ...result, isDuplicate: false, economyConfigVersion: EconomyConfig.economyConfigVersion } satisfies EconomyResult;
  } catch (e) {
    if (String(e).includes("insufficientFunds")) return insufficientFundsResult(idempotencyKey, "coins");
    throw e;
  }
});

// ── consumeHint ───────────────────────────────────────────────────────────────

export const consumeHint = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data as Record<string, unknown>;
  const operationId = String(data["operationId"] ?? "");
  if (!operationId) throw new HttpsError("invalid-argument", "operationId required");

  const idempotencyKey = `hint_consume:${uid}:${operationId}`;
  const existing = await getExistingReceipt(uid, idempotencyKey);
  if (existing) return existingReceiptToResult(idempotencyKey, existing.data()!);

  try {
    const result = await atomicWalletMutation(uid, idempotencyKey, "hintConsume", operationId, [
      { type: "hintConsume", resource: "hints", amount: -1, referenceType: "hint_consume", referenceId: operationId, idempotencyKey },
    ]);
    return { success: true, operationId: idempotencyKey, ...result, isDuplicate: false, economyConfigVersion: EconomyConfig.economyConfigVersion } satisfies EconomyResult;
  } catch (e) {
    if (String(e).includes("insufficientFunds")) return insufficientFundsResult(idempotencyKey, "hints");
    throw e;
  }
});

// ── purchaseExtraMoves ────────────────────────────────────────────────────────

export const purchaseExtraMoves = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data as Record<string, unknown>;
  const attemptId = String(data["attemptId"] ?? "");
  const rescueIndex = Number(data["rescueIndex"]);

  if (!attemptId) throw new HttpsError("invalid-argument", "attemptId required");

  if (rescueIndex < 1 || rescueIndex > EconomyConfig.extraMovesMaxPerAttempt) {
    return {
      success: false,
      operationId: `extra_moves:${uid}:${attemptId}:${rescueIndex}`,
      errorCode: "limitReached",
      errorMessage: `max ${EconomyConfig.extraMovesMaxPerAttempt} extra move rescues per attempt`,
      economyConfigVersion: EconomyConfig.economyConfigVersion,
    } satisfies EconomyResult;
  }

  const cost = rescueIndex === 1 ? EconomyConfig.extraMovesCostFirst : EconomyConfig.extraMovesCostSecond;
  const idempotencyKey = `extra_moves:${uid}:${attemptId}:${rescueIndex}`;
  const existing = await getExistingReceipt(uid, idempotencyKey);
  if (existing) return existingReceiptToResult(idempotencyKey, existing.data()!);

  try {
    const result = await atomicWalletMutation(uid, idempotencyKey, "extraMovesPurchase", attemptId, [
      { type: "extraMovesPurchase", resource: "coins", amount: -cost, referenceType: "attempt", referenceId: attemptId, idempotencyKey, metadata: { rescueIndex, movesGranted: EconomyConfig.extraMovesGrant } },
    ]);
    return { success: true, operationId: idempotencyKey, ...result, isDuplicate: false, economyConfigVersion: EconomyConfig.economyConfigVersion } satisfies EconomyResult;
  } catch (e) {
    if (String(e).includes("insufficientFunds")) return insufficientFundsResult(idempotencyKey, "coins");
    throw e;
  }
});

// ── purchaseDeadEndRescue ─────────────────────────────────────────────────────

export const purchaseDeadEndRescue = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data as Record<string, unknown>;
  const attemptId = String(data["attemptId"] ?? "");
  if (!attemptId) throw new HttpsError("invalid-argument", "attemptId required");

  const idempotencyKey = `dead_end_rescue:${uid}:${attemptId}`;
  const existing = await getExistingReceipt(uid, idempotencyKey);
  if (existing) return existingReceiptToResult(idempotencyKey, existing.data()!);

  try {
    const result = await atomicWalletMutation(uid, idempotencyKey, "deadEndRescuePurchase", attemptId, [
      { type: "deadEndRescuePurchase", resource: "coins", amount: -EconomyConfig.deadEndRescueCostCoins, referenceType: "attempt", referenceId: attemptId, idempotencyKey },
    ]);
    return { success: true, operationId: idempotencyKey, ...result, isDuplicate: false, economyConfigVersion: EconomyConfig.economyConfigVersion } satisfies EconomyResult;
  } catch (e) {
    if (String(e).includes("insufficientFunds")) return insufficientFundsResult(idempotencyKey, "coins");
    throw e;
  }
});

// ── getWalletSnapshot ─────────────────────────────────────────────────────────

export const getWalletSnapshot = onCall(async (request) => {
  const uid = requireAuth(request);
  const snap = await getFirestore().doc(walletPath(uid)).get();
  if (!snap.exists) return { exists: false, coinBalance: 0, hintBalance: 0, walletRevision: 0 };
  const d = snap.data()!;
  return { exists: true, coinBalance: d["coinBalance"] ?? 0, hintBalance: d["hintBalance"] ?? 0, walletRevision: d["walletRevision"] ?? 0, economyConfigVersion: EconomyConfig.economyConfigVersion };
});
