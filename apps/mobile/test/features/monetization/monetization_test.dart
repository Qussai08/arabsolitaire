import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/monetization/application/interstitial_policy.dart';
import 'package:mobile/features/monetization/domain/monetization_models.dart';

void main() {
  group('MonetizationConfig', () {
    test('coin pack grants match product IDs', () {
      expect(
        MonetizationConfig.coinPackGrants[MonetizationConfig.productCoins1000],
        1000,
      );
      expect(
        MonetizationConfig.coinPackGrants[MonetizationConfig.productCoins3000],
        3000,
      );
      expect(
        MonetizationConfig.coinPackGrants[MonetizationConfig.productCoins7000],
        7000,
      );
      expect(
        MonetizationConfig.coinPackGrants[MonetizationConfig.productCoins15000],
        15000,
      );
    });

    test('rewarded coin grant is 100', () {
      expect(MonetizationConfig.rewardedCoinGrant, 100);
    });
  });

  group('InterstitialPolicy', () {
    test('eligible after enough levels', () {
      const ctx = MonetizationContext(
        levelsSinceLastInterstitial: MonetizationConfig.interstitialMinLevels,
        sessionInterstitialCount: 0,
      );
      expect(InterstitialPolicy.evaluate(ctx), InterstitialDecision.eligible);
    });

    test('notEnoughLevels when below threshold', () {
      const ctx = MonetizationContext(levelsSinceLastInterstitial: 1);
      expect(
        InterstitialPolicy.evaluate(ctx),
        InterstitialDecision.notEnoughLevels,
      );
    });

    test('sessionCapReached when at cap', () {
      const ctx = MonetizationContext(
        levelsSinceLastInterstitial: MonetizationConfig.interstitialMinLevels,
        sessionInterstitialCount: MonetizationConfig.interstitialSessionCap,
      );
      expect(
        InterstitialPolicy.evaluate(ctx),
        InterstitialDecision.sessionCapReached,
      );
    });

    test('removeAdsEntitled blocks interstitial', () {
      const ctx = MonetizationContext(
        levelsSinceLastInterstitial: MonetizationConfig.interstitialMinLevels,
        hasRemoveAdsEntitlement: true,
      );
      expect(
        InterstitialPolicy.evaluate(ctx),
        InterstitialDecision.removeAdsEntitled,
      );
    });

    test('guardrailBlocked during tutorial', () {
      final ctx = MonetizationContext(
        levelsSinceLastInterstitial: MonetizationConfig.interstitialMinLevels,
        lastTutorialCompletedAt: DateTime.now().subtract(
          const Duration(seconds: 1),
        ),
      );
      expect(
        InterstitialPolicy.evaluate(ctx),
        InterstitialDecision.guardrailBlocked,
      );
    });

    test('guardrailBlocked after dead-end', () {
      final ctx = MonetizationContext(
        levelsSinceLastInterstitial: MonetizationConfig.interstitialMinLevels,
        lastDeadEndAt: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      expect(
        InterstitialPolicy.evaluate(ctx),
        InterstitialDecision.guardrailBlocked,
      );
    });

    test('guardrailBlocked after rewarded ad', () {
      final ctx = MonetizationContext(
        levelsSinceLastInterstitial: MonetizationConfig.interstitialMinLevels,
        lastRewardedAdAt: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      expect(
        InterstitialPolicy.evaluate(ctx),
        InterstitialDecision.guardrailBlocked,
      );
    });

    test('interstitialEnabled=false blocks', () {
      const ctx = MonetizationContext(
        levelsSinceLastInterstitial: MonetizationConfig.interstitialMinLevels,
        interstitialEnabled: false,
      );
      expect(
        InterstitialPolicy.evaluate(ctx),
        InterstitialDecision.guardrailBlocked,
      );
    });
  });

  group('Entitlement', () {
    test('noEntitlement is inactive', () {
      expect(Entitlement.noEntitlement.active, isFalse);
      expect(Entitlement.noEntitlement.source, 'none');
    });

    test('active entitlement from IAP', () {
      const e = Entitlement(
        type: EntitlementType.removeInterstitialAds,
        active: true,
        source: 'iap',
        storeProductId: MonetizationConfig.productRemoveAds,
      );
      expect(e.active, isTrue);
      expect(e.source, 'iap');
      expect(e.storeProductId, MonetizationConfig.productRemoveAds);
    });
  });

  group('MonetizationContext.copyWith', () {
    test('preserves unchanged fields', () {
      const ctx = MonetizationContext(levelsSinceLastInterstitial: 5);
      final updated = ctx.copyWith(sessionInterstitialCount: 2);
      expect(updated.levelsSinceLastInterstitial, 5);
      expect(updated.sessionInterstitialCount, 2);
    });
  });

  group('MonetizationFlags', () {
    test('defaults all true', () {
      expect(MonetizationFlags.defaults.rewardedCoinsEnabled, isTrue);
      expect(MonetizationFlags.defaults.interstitialEnabled, isTrue);
      expect(MonetizationFlags.defaults.shopEnabled, isTrue);
    });
  });
}
