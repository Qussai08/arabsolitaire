/**
 * Approved economy configuration values — server source of truth.
 * These must match Sprint 7 specification. Do not change without product approval.
 */
export const EconomyConfig = {
  startingCoins: 300,
  startingHints: 3,
  hintCostCoins: 75,
  extraMovesCostFirst: 150,
  extraMovesCostSecond: 250,
  extraMovesGrant: 5,
  extraMovesMaxPerAttempt: 2,
  deadEndRescueCostCoins: 200,
  deadEndRescueMaxPerAttempt: 1,
  levelRewardBase: 50,
  levelRewardPerRemainingMove: 2,
  chapterRewardCoins: 500,
  chapterRewardHints: 2,
  economyConfigVersion: 1,
  // Sane sanity ranges
  maxStreakCoinsPerLevel: 200,
  maxRemainingMoves: 500,
} as const;

export type TransactionType =
  | "initialGrant"
  | "levelReward"
  | "chapterReward"
  | "hintPurchase"
  | "hintConsume"
  | "extraMovesPurchase"
  | "deadEndRescuePurchase"
  | "offlineSpendReconciliation"
  | "adminAdjustmentFuture"
  | "iapGrantFuture"
  | "coinPackPurchase"
  | "rewardedAdGrantFuture"
  | "dailyReward"
  | "dailyChallenge";

export interface WalletDoc {
  coinBalance: number;
  hintBalance: number;
  walletRevision: number;
  lifetimeEarnedCoins: number;
  lifetimeSpentCoins: number;
  walletSchemaVersion: number;
  updatedAt: FirebaseFirestore.FieldValue | Date;
}

export interface TransactionDoc {
  transactionId: string;
  uid: string;
  type: TransactionType;
  resource: "coins" | "hints";
  amount: number;
  balanceBefore: number;
  balanceAfter: number;
  idempotencyKey: string;
  referenceType: string;
  referenceId: string;
  createdAt: FirebaseFirestore.FieldValue;
  economyConfigVersion: number;
  metadata?: Record<string, unknown>;
}

export interface OperationReceiptDoc {
  status: "completed" | "failed";
  operationType: TransactionType;
  coinBalanceAfter: number;
  hintBalanceAfter: number;
  walletRevision: number;
  transactionIds: string[];
  createdAt: FirebaseFirestore.FieldValue;
  uid: string;
  referenceId: string;
}

export interface EconomyResult {
  success: boolean;
  operationId: string;
  coinBalanceAfter?: number;
  hintBalanceAfter?: number;
  walletRevision?: number;
  transactionIds?: string[];
  isDuplicate?: boolean;
  errorCode?: string;
  errorMessage?: string;
  economyConfigVersion: number;
}
