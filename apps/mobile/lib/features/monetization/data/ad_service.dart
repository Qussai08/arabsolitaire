import 'package:mobile/features/monetization/domain/monetization_models.dart';

/// Abstract ad service — decouples SDK from application logic.
abstract interface class AdService {
  /// Initialize AdMob/mediation. Must not throw; log any error safely.
  Future<void> initialize();

  /// True if ad for given placement is loaded and ready.
  bool isAdReady(AdPlacement placement);

  /// Load/prefetch a rewarded ad for the given placement.
  Future<void> loadRewardedAd(AdPlacement placement);

  /// Show a rewarded ad. Returns result without throwing.
  Future<AdResult> showRewardedAd({
    required AdPlacement placement,
    required String operationId,
  });

  /// Load an interstitial.
  Future<void> loadInterstitial();

  /// Show a preloaded interstitial. Returns whether it was shown.
  Future<bool> showInterstitial();
}

/// No-op offline/test ad service.
final class NoOpAdService implements AdService {
  const NoOpAdService();

  @override
  Future<void> initialize() async {}

  @override
  bool isAdReady(AdPlacement placement) => false;

  @override
  Future<void> loadRewardedAd(AdPlacement placement) async {}

  @override
  Future<AdResult> showRewardedAd({
    required AdPlacement placement,
    required String operationId,
  }) async => AdResult.notAvailable;

  @override
  Future<void> loadInterstitial() async {}

  @override
  Future<bool> showInterstitial() async => false;
}
