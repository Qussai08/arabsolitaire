import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/core/analytics/analytics_events.dart';

/// Analytics abstraction covering all Sprint 11 critical event families.
abstract interface class AnalyticsService {
  // ── Bootstrap ─────────────────────────────────────────────────────────────
  Future<void> logAppStarted();
  Future<void> logBootstrapCompleted({required bool firebaseReady});
  Future<void> logBootstrapFailed({required String reason});

  // ── Gameplay ──────────────────────────────────────────────────────────────
  Future<void> logAttemptStarted({
    required String levelDefinitionId,
    required int attemptNumber,
    required String solverVersion,
    required String generatorVersion,
    required String rulesVersion,
    required double difficultyScore,
  });
  Future<void> logMoveAccepted({
    required String actionType,
    required int movesRemaining,
  });
  Future<void> logMoveRejected({required String actionType});
  Future<void> logHintRequested({
    required int hintsRemaining,
    required int movesRemaining,
  });
  Future<void> logHintUsed({required int hintsRemaining});
  Future<void> logDeadEndConfirmed({
    required int movesRemaining,
    required bool rescueAvailable,
  });
  Future<void> logOutOfMoves({
    required int rescueRemaining,
    required int coins,
  });
  Future<void> logLevelWon({
    required String levelDefinitionId,
    required int solutionLength,
    required int movesRemaining,
    required int streakCoins,
    required int totalCoinsEarned,
  });
  Future<void> logRestartRequested({required int movesRemaining});

  // ── Progression ───────────────────────────────────────────────────────────
  Future<void> logLevelStarted({
    required String levelDefinitionId,
    required String chapterId,
  });
  Future<void> logLevelCompleted({
    required String levelDefinitionId,
    required String chapterId,
    required int coinsEarned,
  });
  Future<void> logChapterCompleted({
    required String chapterId,
    required int coinsEarned,
    required int hintsEarned,
  });
  Future<void> logStoryBeatViewed({
    required String beatId,
    required String chapterId,
    required int beatIndex,
    required bool skipped,
  });
  Future<void> logTutorialCompleted();

  // ── Economy ───────────────────────────────────────────────────────────────
  Future<void> logWalletInitialized({
    required int coinsGranted,
    required int hintsGranted,
  });
  Future<void> logRewardClaimed({
    required String rewardType,
    required int coins,
    required int hints,
  });
  Future<void> logHintPurchased({
    required int coinsSpent,
    required int hintsAfter,
  });
  Future<void> logExtraMovesPurchased({
    required int coinsSpent,
    required int rescueIndex,
  });
  Future<void> logDeadEndRescuePurchased({required int coinsSpent});

  // ── Monetization ──────────────────────────────────────────────────────────
  Future<void> logRewardedAdCompleted({
    required String rewardType,
    required int coinsGranted,
  });
  Future<void> logInterstitialShown({
    required int sessionCount,
    required int levelCount,
  });
  Future<void> logPurchaseStarted({required String productId});
  Future<void> logPurchaseValidated({
    required String productId,
    required String platform,
  });
  Future<void> logRestoreCompleted({required int entitlementsCount});

  // ── Daily ─────────────────────────────────────────────────────────────────
  Future<void> logDailyRewardClaimed({
    required int dayIndex,
    required int coins,
    required int hints,
  });
  Future<void> logDailyStreakIncremented({
    required int streakDays,
    required bool milestoneHit,
  });
  Future<void> logDailyChallengeCompleted({
    required String challengeKey,
    required int coinsEarned,
  });

  // ── Content ───────────────────────────────────────────────────────────────
  Future<void> logContentBundleActivated({
    required String bundleVersion,
    required int schemaVersion,
    required String rulesVersion,
  });
  Future<void> logContentBundleValidationFailed({
    required String failureReason,
    required String bundleVersion,
  });
  Future<void> logContentBundleRollback({
    required String fromVersion,
    required String toVersion,
  });
}

// ─────────────────────────────────────────────────────────────────────────────

final class NoOpAnalyticsService implements AnalyticsService {
  @override
  Future<void> logAppStarted() async {}
  @override
  Future<void> logBootstrapCompleted({required bool firebaseReady}) async {}
  @override
  Future<void> logBootstrapFailed({required String reason}) async {}
  @override
  Future<void> logAttemptStarted({
    required String levelDefinitionId,
    required int attemptNumber,
    required String solverVersion,
    required String generatorVersion,
    required String rulesVersion,
    required double difficultyScore,
  }) async {}
  @override
  Future<void> logMoveAccepted({
    required String actionType,
    required int movesRemaining,
  }) async {}
  @override
  Future<void> logMoveRejected({required String actionType}) async {}
  @override
  Future<void> logHintRequested({
    required int hintsRemaining,
    required int movesRemaining,
  }) async {}
  @override
  Future<void> logHintUsed({required int hintsRemaining}) async {}
  @override
  Future<void> logDeadEndConfirmed({
    required int movesRemaining,
    required bool rescueAvailable,
  }) async {}
  @override
  Future<void> logOutOfMoves({
    required int rescueRemaining,
    required int coins,
  }) async {}
  @override
  Future<void> logLevelWon({
    required String levelDefinitionId,
    required int solutionLength,
    required int movesRemaining,
    required int streakCoins,
    required int totalCoinsEarned,
  }) async {}
  @override
  Future<void> logRestartRequested({required int movesRemaining}) async {}
  @override
  Future<void> logLevelStarted({
    required String levelDefinitionId,
    required String chapterId,
  }) async {}
  @override
  Future<void> logLevelCompleted({
    required String levelDefinitionId,
    required String chapterId,
    required int coinsEarned,
  }) async {}
  @override
  Future<void> logChapterCompleted({
    required String chapterId,
    required int coinsEarned,
    required int hintsEarned,
  }) async {}
  @override
  Future<void> logStoryBeatViewed({
    required String beatId,
    required String chapterId,
    required int beatIndex,
    required bool skipped,
  }) async {}
  @override
  Future<void> logTutorialCompleted() async {}
  @override
  Future<void> logWalletInitialized({
    required int coinsGranted,
    required int hintsGranted,
  }) async {}
  @override
  Future<void> logRewardClaimed({
    required String rewardType,
    required int coins,
    required int hints,
  }) async {}
  @override
  Future<void> logHintPurchased({
    required int coinsSpent,
    required int hintsAfter,
  }) async {}
  @override
  Future<void> logExtraMovesPurchased({
    required int coinsSpent,
    required int rescueIndex,
  }) async {}
  @override
  Future<void> logDeadEndRescuePurchased({required int coinsSpent}) async {}
  @override
  Future<void> logRewardedAdCompleted({
    required String rewardType,
    required int coinsGranted,
  }) async {}
  @override
  Future<void> logInterstitialShown({
    required int sessionCount,
    required int levelCount,
  }) async {}
  @override
  Future<void> logPurchaseStarted({required String productId}) async {}
  @override
  Future<void> logPurchaseValidated({
    required String productId,
    required String platform,
  }) async {}
  @override
  Future<void> logRestoreCompleted({required int entitlementsCount}) async {}
  @override
  Future<void> logDailyRewardClaimed({
    required int dayIndex,
    required int coins,
    required int hints,
  }) async {}
  @override
  Future<void> logDailyStreakIncremented({
    required int streakDays,
    required bool milestoneHit,
  }) async {}
  @override
  Future<void> logDailyChallengeCompleted({
    required String challengeKey,
    required int coinsEarned,
  }) async {}
  @override
  Future<void> logContentBundleActivated({
    required String bundleVersion,
    required int schemaVersion,
    required String rulesVersion,
  }) async {}
  @override
  Future<void> logContentBundleValidationFailed({
    required String failureReason,
    required String bundleVersion,
  }) async {}
  @override
  Future<void> logContentBundleRollback({
    required String fromVersion,
    required String toVersion,
  }) async {}
}

// ─────────────────────────────────────────────────────────────────────────────

final class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> _log(String name, [Map<String, Object>? params]) =>
      _analytics.logEvent(name: name, parameters: params);

  @override
  Future<void> logAppStarted() => _log('app_started');

  @override
  Future<void> logBootstrapCompleted({required bool firebaseReady}) =>
      _log('bootstrap_completed', {'firebase_ready': firebaseReady ? 1 : 0});

  @override
  Future<void> logBootstrapFailed({required String reason}) => _log(
    'bootstrap_failed',
    {'reason': reason.length > 100 ? reason.substring(0, 100) : reason},
  );

  @override
  Future<void> logAttemptStarted({
    required String levelDefinitionId,
    required int attemptNumber,
    required String solverVersion,
    required String generatorVersion,
    required String rulesVersion,
    required double difficultyScore,
  }) => _log(AnalyticsEvents.attemptStarted, {
    'level_definition_id': levelDefinitionId,
    'attempt_number': attemptNumber,
    'solver_version': solverVersion,
    'generator_version': generatorVersion,
    'rules_version': rulesVersion,
    'difficulty_score': difficultyScore,
  });

  @override
  Future<void> logMoveAccepted({
    required String actionType,
    required int movesRemaining,
  }) => _log(AnalyticsEvents.moveAccepted, {
    'action_type': actionType,
    'moves_remaining': movesRemaining,
  });

  @override
  Future<void> logMoveRejected({required String actionType}) =>
      _log(AnalyticsEvents.moveRejected, {'action_type': actionType});

  @override
  Future<void> logHintRequested({
    required int hintsRemaining,
    required int movesRemaining,
  }) => _log(AnalyticsEvents.hintRequested, {
    'hints_remaining': hintsRemaining,
    'moves_remaining': movesRemaining,
  });

  @override
  Future<void> logHintUsed({required int hintsRemaining}) =>
      _log(AnalyticsEvents.hintUsed, {'hints_remaining': hintsRemaining});

  @override
  Future<void> logDeadEndConfirmed({
    required int movesRemaining,
    required bool rescueAvailable,
  }) => _log(AnalyticsEvents.deadEndConfirmed, {
    'moves_remaining': movesRemaining,
    'rescue_available': rescueAvailable ? 1 : 0,
  });

  @override
  Future<void> logOutOfMoves({
    required int rescueRemaining,
    required int coins,
  }) => _log(AnalyticsEvents.outOfMoves, {
    'rescue_remaining': rescueRemaining,
    'coins': coins,
  });

  @override
  Future<void> logLevelWon({
    required String levelDefinitionId,
    required int solutionLength,
    required int movesRemaining,
    required int streakCoins,
    required int totalCoinsEarned,
  }) => _log(AnalyticsEvents.levelWon, {
    'level_definition_id': levelDefinitionId,
    'solution_length': solutionLength,
    'moves_remaining': movesRemaining,
    'streak_coins': streakCoins,
    'total_coins_earned': totalCoinsEarned,
  });

  @override
  Future<void> logRestartRequested({required int movesRemaining}) => _log(
    AnalyticsEvents.restartRequested,
    {'moves_remaining': movesRemaining},
  );

  @override
  Future<void> logLevelStarted({
    required String levelDefinitionId,
    required String chapterId,
  }) => _log(AnalyticsEvents.levelStarted, {
    'level_definition_id': levelDefinitionId,
    'chapter_id': chapterId,
  });

  @override
  Future<void> logLevelCompleted({
    required String levelDefinitionId,
    required String chapterId,
    required int coinsEarned,
  }) => _log(AnalyticsEvents.levelCompleted, {
    'level_definition_id': levelDefinitionId,
    'chapter_id': chapterId,
    'coins_earned': coinsEarned,
  });

  @override
  Future<void> logChapterCompleted({
    required String chapterId,
    required int coinsEarned,
    required int hintsEarned,
  }) => _log(AnalyticsEvents.chapterCompleted, {
    'chapter_id': chapterId,
    'coins_earned': coinsEarned,
    'hints_earned': hintsEarned,
  });

  @override
  Future<void> logStoryBeatViewed({
    required String beatId,
    required String chapterId,
    required int beatIndex,
    required bool skipped,
  }) => _log(AnalyticsEvents.storyBeatViewed, {
    'beat_id': beatId,
    'chapter_id': chapterId,
    'beat_index': beatIndex,
    'skipped': skipped ? 1 : 0,
  });

  @override
  Future<void> logTutorialCompleted() =>
      _log(AnalyticsEvents.tutorialCompleted);

  @override
  Future<void> logWalletInitialized({
    required int coinsGranted,
    required int hintsGranted,
  }) => _log(AnalyticsEvents.walletInitialized, {
    'coins_granted': coinsGranted,
    'hints_granted': hintsGranted,
  });

  @override
  Future<void> logRewardClaimed({
    required String rewardType,
    required int coins,
    required int hints,
  }) => _log(AnalyticsEvents.rewardClaimed, {
    'reward_type': rewardType,
    'coins': coins,
    'hints': hints,
  });

  @override
  Future<void> logHintPurchased({
    required int coinsSpent,
    required int hintsAfter,
  }) => _log(AnalyticsEvents.hintPurchased, {
    'coins_spent': coinsSpent,
    'hints_after': hintsAfter,
  });

  @override
  Future<void> logExtraMovesPurchased({
    required int coinsSpent,
    required int rescueIndex,
  }) => _log(AnalyticsEvents.extraMovesPurchased, {
    'coins_spent': coinsSpent,
    'rescue_index': rescueIndex,
  });

  @override
  Future<void> logDeadEndRescuePurchased({required int coinsSpent}) =>
      _log(AnalyticsEvents.deadEndRescuePurchased, {'coins_spent': coinsSpent});

  @override
  Future<void> logRewardedAdCompleted({
    required String rewardType,
    required int coinsGranted,
  }) => _log(AnalyticsEvents.rewardedAdCompleted, {
    'reward_type': rewardType,
    'coins_granted': coinsGranted,
  });

  @override
  Future<void> logInterstitialShown({
    required int sessionCount,
    required int levelCount,
  }) => _log(AnalyticsEvents.interstitialShown, {
    'session_count': sessionCount,
    'level_count': levelCount,
  });

  @override
  Future<void> logPurchaseStarted({required String productId}) =>
      _log(AnalyticsEvents.purchaseStarted, {'product_id': productId});

  @override
  Future<void> logPurchaseValidated({
    required String productId,
    required String platform,
  }) => _log(AnalyticsEvents.purchaseValidated, {
    'product_id': productId,
    'platform': platform,
  });

  @override
  Future<void> logRestoreCompleted({required int entitlementsCount}) => _log(
    AnalyticsEvents.restoreCompleted,
    {'entitlements_count': entitlementsCount},
  );

  @override
  Future<void> logDailyRewardClaimed({
    required int dayIndex,
    required int coins,
    required int hints,
  }) => _log(AnalyticsEvents.dailyRewardClaimed, {
    'day_index': dayIndex,
    'coins': coins,
    'hints': hints,
  });

  @override
  Future<void> logDailyStreakIncremented({
    required int streakDays,
    required bool milestoneHit,
  }) => _log(AnalyticsEvents.dailyStreakIncremented, {
    'streak_days': streakDays,
    'milestone_hit': milestoneHit ? 1 : 0,
  });

  @override
  Future<void> logDailyChallengeCompleted({
    required String challengeKey,
    required int coinsEarned,
  }) => _log(AnalyticsEvents.dailyChallengeCompleted, {
    'challenge_key': challengeKey,
    'coins_earned': coinsEarned,
  });

  @override
  Future<void> logContentBundleActivated({
    required String bundleVersion,
    required int schemaVersion,
    required String rulesVersion,
  }) => _log(AnalyticsEvents.contentBundleActivated, {
    'bundle_version': bundleVersion,
    'schema_version': schemaVersion,
    'rules_version': rulesVersion,
  });

  @override
  Future<void> logContentBundleValidationFailed({
    required String failureReason,
    required String bundleVersion,
  }) => _log(AnalyticsEvents.contentBundleValidationFailed, {
    'failure_reason': failureReason,
    'bundle_version': bundleVersion,
  });

  @override
  Future<void> logContentBundleRollback({
    required String fromVersion,
    required String toVersion,
  }) => _log(AnalyticsEvents.contentBundleRollback, {
    'from_version': fromVersion,
    'to_version': toVersion,
  });
}

// ─────────────────────────────────────────────────────────────────────────────

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  if (!config.enableAnalytics || !config.firebaseConfigured) {
    logger.debug('Using NoOp analytics');
    return NoOpAnalyticsService();
  }

  try {
    return FirebaseAnalyticsService(FirebaseAnalytics.instance);
  } catch (error, stackTrace) {
    logger.warning(
      'Analytics unavailable — using NoOp',
      error: error,
      stackTrace: stackTrace,
    );
    return NoOpAnalyticsService();
  }
});
