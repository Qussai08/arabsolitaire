import 'package:mobile/features/monetization/domain/monetization_models.dart';

/// Pure stateless interstitial eligibility evaluator.
/// Session and context state is maintained by the caller (MonetizationController).
abstract final class InterstitialPolicy {
  /// Evaluates whether an interstitial should be shown given current context.
  static InterstitialDecision evaluate(MonetizationContext ctx) {
    if (!ctx.interstitialEnabled) {
      return InterstitialDecision.guardrailBlocked;
    }

    if (ctx.hasRemoveAdsEntitlement) {
      return InterstitialDecision.removeAdsEntitled;
    }

    if (ctx.sessionInterstitialCount >= ctx.interstitialSessionCap) {
      return InterstitialDecision.sessionCapReached;
    }

    if (ctx.levelsSinceLastInterstitial < ctx.interstitialMinLevels) {
      return InterstitialDecision.notEnoughLevels;
    }

    // Guardrail checks — block if a sensitive event occurred recently.
    final now = DateTime.now();
    const guardrailWindow = Duration(seconds: 30);

    bool recentGuardrail(DateTime? dt) =>
        dt != null && now.difference(dt) < guardrailWindow;

    if (recentGuardrail(ctx.lastRewardedAdAt) ||
        recentGuardrail(ctx.lastPurchaseAt) ||
        recentGuardrail(ctx.lastTutorialCompletedAt) ||
        recentGuardrail(ctx.lastFailureAt) ||
        recentGuardrail(ctx.lastDeadEndAt) ||
        recentGuardrail(ctx.lastOutOfMovesDeclineAt)) {
      return InterstitialDecision.guardrailBlocked;
    }

    return InterstitialDecision.eligible;
  }
}
