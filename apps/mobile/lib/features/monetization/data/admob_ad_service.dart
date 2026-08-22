import 'package:mobile/features/monetization/data/ad_service.dart';
import 'package:mobile/features/monetization/domain/monetization_models.dart';

/// AdMob-backed ad service.
/// SDK calls are stubbed at architecture level; wired at platform integration.
///
/// To activate:
/// 1. Add `google_mobile_ads` to pubspec.
/// 2. Set ad unit IDs in environment config.
/// 3. Replace stubs with real AdMob load/show calls.
final class AdMobAdService implements AdService {
  AdMobAdService({required this.testMode});

  final bool testMode;
  final Map<AdPlacement, bool> _loaded = {};
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    // TODO: await MobileAds.instance.initialize();
    _initialized = true;
  }

  @override
  bool isAdReady(AdPlacement placement) => _loaded[placement] ?? false;

  @override
  Future<void> loadRewardedAd(AdPlacement placement) async {
    if (!_initialized) return;
    // TODO: wire AdMob RewardedAd.load(adUnitId, request, callback);
    // Stub: mark as not ready until real SDK integrated.
    _loaded[placement] = false;
  }

  @override
  Future<AdResult> showRewardedAd({
    required AdPlacement placement,
    required String operationId,
  }) async {
    if (!(_loaded[placement] ?? false)) {
      return AdResult.notAvailable;
    }
    // TODO: call RewardedAd.show with onUserEarnedReward callback.
    return AdResult.notAvailable;
  }

  @override
  Future<void> loadInterstitial() async {
    if (!_initialized) return;
    // TODO: wire AdMob InterstitialAd.load(adUnitId, request, callback);
  }

  @override
  Future<bool> showInterstitial() async {
    // TODO: call _interstitialAd?.show();
    return false;
  }
}
