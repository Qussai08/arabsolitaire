/// Monetization domain models for Sprint 8.
///
/// Pure Dart — no SDK dependencies.
library;

// ── Monetization config ───────────────────────────────────────────────────────

abstract final class MonetizationConfig {
  static const int rewardedCoinGrant = 100;
  static const int rewardedCoinDailyMax = 3;
  static const int rewardedHintGrant = 1;
  static const int rewardedExtraMovesGrant = 5;

  // Interstitial baseline (configurable via Remote Config).
  static const int interstitialMinLevels = 3;
  static const int interstitialMaxLevels = 5;
  static const int interstitialSessionCap = 3;

  // Product IDs (store-configured).
  static const String productRemoveAds = 'remove_ads';
  static const String productCoins1000 = 'coins_1000';
  static const String productCoins3000 = 'coins_3000';
  static const String productCoins7000 = 'coins_7000';
  static const String productCoins15000 = 'coins_15000';

  // Coin pack grants — server-authoritative.
  static const Map<String, int> coinPackGrants = {
    productCoins1000: 1000,
    productCoins3000: 3000,
    productCoins7000: 7000,
    productCoins15000: 15000,
  };

  static const monetizationConfigVersion = 1;
}

// ── Rewarded Ad types ─────────────────────────────────────────────────────────

enum RewardedRewardType { coins, hint, extraMoves, deadEndRescue }

// ── Rewarded Ad placement ─────────────────────────────────────────────────────

enum AdPlacement {
  rewardedCoins,
  rewardedHint,
  rewardedExtraMoves,
  rewardedDeadEndRescue,
  interstitialPostLevel,
}

// ── Rewarded Ad result ────────────────────────────────────────────────────────

enum AdResultStatus {
  completed,
  notAvailable,
  cancelled,
  failed,
  alreadyProcessing,
}

final class AdResult {
  const AdResult({required this.status, this.operationId, this.errorMessage});

  final AdResultStatus status;
  final String? operationId;
  final String? errorMessage;

  bool get isCompleted => status == AdResultStatus.completed;

  static const notAvailable = AdResult(status: AdResultStatus.notAvailable);
  static const cancelled = AdResult(status: AdResultStatus.cancelled);
}

// ── Interstitial policy ───────────────────────────────────────────────────────

enum InterstitialDecision {
  eligible,
  notEnoughLevels,
  sessionCapReached,
  guardrailBlocked,
  removeAdsEntitled,
  adUnavailable,
}

final class MonetizationContext {
  const MonetizationContext({
    this.levelsSinceLastInterstitial = 0,
    this.sessionInterstitialCount = 0,
    this.lastMonetizationEventType,
    this.lastRewardedAdAt,
    this.lastPurchaseAt,
    this.lastTutorialCompletedAt,
    this.lastFailureAt,
    this.lastDeadEndAt,
    this.lastOutOfMovesDeclineAt,
    this.hasRemoveAdsEntitlement = false,
    this.interstitialMinLevels = MonetizationConfig.interstitialMinLevels,
    this.interstitialSessionCap = MonetizationConfig.interstitialSessionCap,
    this.interstitialEnabled = true,
  });

  final int levelsSinceLastInterstitial;
  final int sessionInterstitialCount;
  final String? lastMonetizationEventType;
  final DateTime? lastRewardedAdAt;
  final DateTime? lastPurchaseAt;
  final DateTime? lastTutorialCompletedAt;
  final DateTime? lastFailureAt;
  final DateTime? lastDeadEndAt;
  final DateTime? lastOutOfMovesDeclineAt;
  final bool hasRemoveAdsEntitlement;
  final int interstitialMinLevels;
  final int interstitialSessionCap;
  final bool interstitialEnabled;

  MonetizationContext copyWith({
    int? levelsSinceLastInterstitial,
    int? sessionInterstitialCount,
    String? lastMonetizationEventType,
    DateTime? lastRewardedAdAt,
    DateTime? lastPurchaseAt,
    DateTime? lastTutorialCompletedAt,
    DateTime? lastFailureAt,
    DateTime? lastDeadEndAt,
    DateTime? lastOutOfMovesDeclineAt,
    bool? hasRemoveAdsEntitlement,
    bool? interstitialEnabled,
  }) => MonetizationContext(
    levelsSinceLastInterstitial:
        levelsSinceLastInterstitial ?? this.levelsSinceLastInterstitial,
    sessionInterstitialCount:
        sessionInterstitialCount ?? this.sessionInterstitialCount,
    lastMonetizationEventType:
        lastMonetizationEventType ?? this.lastMonetizationEventType,
    lastRewardedAdAt: lastRewardedAdAt ?? this.lastRewardedAdAt,
    lastPurchaseAt: lastPurchaseAt ?? this.lastPurchaseAt,
    lastTutorialCompletedAt:
        lastTutorialCompletedAt ?? this.lastTutorialCompletedAt,
    lastFailureAt: lastFailureAt ?? this.lastFailureAt,
    lastDeadEndAt: lastDeadEndAt ?? this.lastDeadEndAt,
    lastOutOfMovesDeclineAt:
        lastOutOfMovesDeclineAt ?? this.lastOutOfMovesDeclineAt,
    hasRemoveAdsEntitlement:
        hasRemoveAdsEntitlement ?? this.hasRemoveAdsEntitlement,
    interstitialEnabled: interstitialEnabled ?? this.interstitialEnabled,
  );
}

// ── Entitlement ───────────────────────────────────────────────────────────────

enum EntitlementType { removeInterstitialAds }

final class Entitlement {
  const Entitlement({
    required this.type,
    required this.active,
    required this.source,
    this.storeProductId,
    this.purchaseId,
    this.validatedAt,
    this.revision = 0,
  });

  final EntitlementType type;
  final bool active;
  final String source;
  final String? storeProductId;
  final String? purchaseId;
  final DateTime? validatedAt;
  final int revision;

  static const noEntitlement = Entitlement(
    type: EntitlementType.removeInterstitialAds,
    active: false,
    source: 'none',
  );
}

// ── IAP Product ───────────────────────────────────────────────────────────────

enum PurchaseProductType { consumable, nonConsumable }

final class PurchaseProduct {
  const PurchaseProduct({
    required this.productId,
    required this.type,
    this.title,
    this.description,
    this.price,
    this.localizedPrice,
  });

  final String productId;
  final PurchaseProductType type;
  final String? title;
  final String? description;
  final double? price;
  final String? localizedPrice;

  bool get isConsumable => type == PurchaseProductType.consumable;
}

// ── Purchase state ────────────────────────────────────────────────────────────

enum PurchaseStatus { pending, purchased, restored, error, cancelled }

final class PurchaseState {
  const PurchaseState({
    required this.productId,
    required this.status,
    this.purchaseId,
    this.receipt,
    this.error,
  });

  final String productId;
  final PurchaseStatus status;
  final String? purchaseId;
  final String? receipt;
  final String? error;
}

// ── Rewarded ad pending receipt ───────────────────────────────────────────────

final class RewardedAdReceipt {
  const RewardedAdReceipt({
    required this.operationId,
    required this.rewardType,
    required this.adCompleted,
    this.attemptId,
    this.backendGranted = false,
    this.localEffectApplied = false,
    required this.createdAt,
  });

  final String operationId;
  final RewardedRewardType rewardType;
  final bool adCompleted;
  final String? attemptId;
  final bool backendGranted;
  final bool localEffectApplied;
  final DateTime createdAt;

  RewardedAdReceipt copyWith({
    bool? backendGranted,
    bool? localEffectApplied,
  }) => RewardedAdReceipt(
    operationId: operationId,
    rewardType: rewardType,
    adCompleted: adCompleted,
    attemptId: attemptId,
    backendGranted: backendGranted ?? this.backendGranted,
    localEffectApplied: localEffectApplied ?? this.localEffectApplied,
    createdAt: createdAt,
  );
}

// ── Monetization feature flags ────────────────────────────────────────────────

final class MonetizationFlags {
  const MonetizationFlags({
    this.rewardedCoinsEnabled = true,
    this.rewardedHintEnabled = true,
    this.rewardedExtraMovesEnabled = true,
    this.rewardedDeadEndRescueEnabled = true,
    this.interstitialEnabled = true,
    this.shopEnabled = true,
    this.removeAdsEnabled = true,
  });

  final bool rewardedCoinsEnabled;
  final bool rewardedHintEnabled;
  final bool rewardedExtraMovesEnabled;
  final bool rewardedDeadEndRescueEnabled;
  final bool interstitialEnabled;
  final bool shopEnabled;
  final bool removeAdsEnabled;

  static const defaults = MonetizationFlags();
}
