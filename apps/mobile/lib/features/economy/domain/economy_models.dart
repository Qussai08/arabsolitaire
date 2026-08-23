/// Economy domain models for Sprint 7.
///
/// Pure Dart — no Firebase, Flutter, or Riverpod dependencies.
library;

// ── Approved economy constants ────────────────────────────────────────────────

abstract final class EconomyConfig {
  static const int startingCoins = 300;
  static const int startingHints = 3;

  static const int hintCostCoins = 75;

  static const int extraMovesCostFirst = 150;
  static const int extraMovesCostSecond = 250;
  static const int extraMovesGrant = 5;
  static const int extraMovesMaxPerAttempt = 2;

  static const int deadEndRescueCostCoins = 200;
  static const int deadEndRescueMaxPerAttempt = 1;

  static const int levelRewardBase = 50;
  static const int levelRewardPerRemainingMove = 2;

  static const int chapterRewardCoins = 500;
  static const int chapterRewardHints = 2;

  static const int economyConfigVersion = 1;
}

// ── Wallet Snapshot ───────────────────────────────────────────────────────────

/// Local view of the player's wallet — reconciled server balance + pending.
final class WalletSnapshot {
  const WalletSnapshot({
    this.coinBalance = 0,
    this.hintBalance = 0,
    this.pendingCoinDelta = 0,
    this.pendingHintDelta = 0,
    this.walletRevision = 0,
    this.lastReconciledAt,
    this.isStale = false,
  });

  /// Last authoritative coin balance from server.
  final int coinBalance;

  /// Last authoritative hint balance from server.
  final int hintBalance;

  /// Local pending delta (negative = spend, positive = earn).
  final int pendingCoinDelta;
  final int pendingHintDelta;

  final int walletRevision;
  final DateTime? lastReconciledAt;

  /// True if not yet reconciled since app launch.
  final bool isStale;

  /// Display balance including pending optimistic delta.
  int get effectiveCoinBalance =>
      (coinBalance + pendingCoinDelta).clamp(0, double.maxFinite.toInt());
  int get effectiveHintBalance =>
      (hintBalance + pendingHintDelta).clamp(0, double.maxFinite.toInt());

  bool get hasPendingOperations =>
      pendingCoinDelta != 0 || pendingHintDelta != 0;

  WalletSnapshot copyWith({
    int? coinBalance,
    int? hintBalance,
    int? pendingCoinDelta,
    int? pendingHintDelta,
    int? walletRevision,
    DateTime? lastReconciledAt,
    bool? isStale,
  }) => WalletSnapshot(
    coinBalance: coinBalance ?? this.coinBalance,
    hintBalance: hintBalance ?? this.hintBalance,
    pendingCoinDelta: pendingCoinDelta ?? this.pendingCoinDelta,
    pendingHintDelta: pendingHintDelta ?? this.pendingHintDelta,
    walletRevision: walletRevision ?? this.walletRevision,
    lastReconciledAt: lastReconciledAt ?? this.lastReconciledAt,
    isStale: isStale ?? this.isStale,
  );

  static const empty = WalletSnapshot(isStale: true);
}

// ── Economy Operation Types ───────────────────────────────────────────────────

enum EconomyOperationType {
  initialGrant,
  levelReward,
  chapterReward,
  hintPurchase,
  hintConsume,
  extraMovesPurchase,
  deadEndRescuePurchase,
  offlineSpendReconciliation,
  // Future stubs — not active until their sprints.
  adminAdjustmentFuture,
  iapGrantFuture,
  rewardedAdGrantFuture,
  dailyRewardFuture,
  dailyChallengeRewardFuture,
}

// ── Economy Error ─────────────────────────────────────────────────────────────

enum EconomyErrorCode {
  insufficientFunds,
  insufficientHints,
  limitReached,
  duplicate,
  invalidOperation,
  notEligible,
  offlineQueued,
  serverUnavailable,
  authRequired,
  schemaMismatch,
  internalError,
}

final class EconomyError {
  const EconomyError({required this.code, this.message});

  final EconomyErrorCode code;
  final String? message;

  @override
  String toString() => 'EconomyError(${code.name}: $message)';
}

// ── Economy Result ────────────────────────────────────────────────────────────

sealed class EconomyResult {
  const EconomyResult();
}

final class EconomySuccess extends EconomyResult {
  const EconomySuccess({
    required this.operationId,
    required this.walletSnapshot,
    this.transactionId,
    this.isPending = false,
    this.coinDelta = 0,
    this.hintDelta = 0,
    this.extraMovesGranted = 0,
  });

  final String operationId;
  final String? transactionId;
  final WalletSnapshot walletSnapshot;
  final bool isPending;
  final int coinDelta;
  final int hintDelta;
  final int extraMovesGranted;
}

final class EconomyFailure extends EconomyResult {
  const EconomyFailure({required this.error, this.operationId});

  final EconomyError error;
  final String? operationId;
}

// ── Economy Operation (local pending queue) ───────────────────────────────────

final class EconomyOperation {
  const EconomyOperation({
    required this.operationId,
    required this.type,
    required this.idempotencyKey,
    required this.payload,
    required this.createdAt,
    this.status = EconomyOperationStatus.pending,
    this.coinDelta = 0,
    this.hintDelta = 0,
    this.attemptCount = 0,
    this.nextRetryAt,
    this.serverTransactionId,
  });

  final String operationId;
  final EconomyOperationType type;
  final String idempotencyKey;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final EconomyOperationStatus status;
  final int coinDelta;
  final int hintDelta;
  final int attemptCount;
  final DateTime? nextRetryAt;
  final String? serverTransactionId;
}

enum EconomyOperationStatus { pending, inFlight, completed, failed, retryable }

// ── Economy Receipt ───────────────────────────────────────────────────────────

/// Server-confirmed receipt for an economy operation.
final class EconomyReceipt {
  const EconomyReceipt({
    required this.operationId,
    required this.idempotencyKey,
    required this.type,
    required this.coinBalanceAfter,
    required this.hintBalanceAfter,
    required this.walletRevision,
    required this.serverTransactionId,
    required this.reconciledAt,
  });

  final String operationId;
  final String idempotencyKey;
  final EconomyOperationType type;
  final int coinBalanceAfter;
  final int hintBalanceAfter;
  final int walletRevision;
  final String serverTransactionId;
  final DateTime reconciledAt;
}

// ── Level Reward Preview ──────────────────────────────────────────────────────

/// Client-side preview only — not authoritative.
final class LevelRewardPreview {
  const LevelRewardPreview({
    required this.levelId,
    required this.remainingMoves,
    required this.streakCoins,
  });

  final String levelId;
  final int remainingMoves;
  final int streakCoins;

  /// Client preview only: 50 + 2 * moves + streak
  int get previewCoins =>
      EconomyConfig.levelRewardBase +
      (EconomyConfig.levelRewardPerRemainingMove * remainingMoves) +
      streakCoins;
}

// ── Attempt Economy Metadata ──────────────────────────────────────────────────

/// Tracks attempt-scoped economy usage limits.
final class AttemptEconomyMetadata {
  const AttemptEconomyMetadata({
    this.extraMovesPurchasesUsed = 0,
    this.deadEndRescueUsed = false,
    this.appliedEconomyOperationIds = const {},
  });

  final int extraMovesPurchasesUsed;
  final bool deadEndRescueUsed;

  /// Operation IDs for which the local gameplay effect has been applied.
  /// Prevents double-application after crash recovery.
  final Set<String> appliedEconomyOperationIds;

  bool get canBuyExtraMoves =>
      extraMovesPurchasesUsed < EconomyConfig.extraMovesMaxPerAttempt;

  bool get canBuyDeadEndRescue => !deadEndRescueUsed;

  int get nextExtraMovesCost {
    return switch (extraMovesPurchasesUsed) {
      0 => EconomyConfig.extraMovesCostFirst,
      1 => EconomyConfig.extraMovesCostSecond,
      _ => -1, // limit exceeded
    };
  }

  AttemptEconomyMetadata copyWith({
    int? extraMovesPurchasesUsed,
    bool? deadEndRescueUsed,
    Set<String>? appliedEconomyOperationIds,
  }) => AttemptEconomyMetadata(
    extraMovesPurchasesUsed:
        extraMovesPurchasesUsed ?? this.extraMovesPurchasesUsed,
    deadEndRescueUsed: deadEndRescueUsed ?? this.deadEndRescueUsed,
    appliedEconomyOperationIds:
        appliedEconomyOperationIds ?? this.appliedEconomyOperationIds,
  );
}
