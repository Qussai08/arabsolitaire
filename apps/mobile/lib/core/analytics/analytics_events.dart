/// Stable analytics event names for سوليتير العرب.
///
/// All names are snake_case, ≤ 40 chars (Firebase limit).
/// Properties are documented inline. No PII allowed.
abstract final class AnalyticsEvents {
  // ── Gameplay ──────────────────────────────────────────────────────────────

  /// Board generated and presented to the player.
  /// Properties: level_definition_id, attempt_number, solver_version,
  ///             generator_version, rules_version, difficulty_score (double).
  static const String attemptStarted = 'attempt_started';

  /// A valid gameplay action was processed by the engine.
  /// Properties: action_type (string), moves_remaining (int).
  static const String moveAccepted = 'move_accepted';

  /// An invalid action was attempted (streak reset).
  /// Properties: action_type (string).
  static const String moveRejected = 'move_rejected';

  /// Player tapped Hint button.
  /// Properties: hints_remaining (int), moves_remaining (int).
  static const String hintRequested = 'hint_requested';

  /// Hint suggestion was shown.
  /// Properties: hints_remaining (int).
  static const String hintUsed = 'hint_used';

  /// Solver confirmed a Dead-End (not inconclusive).
  /// Properties: moves_remaining (int), rescue_available (bool).
  static const String deadEndConfirmed = 'dead_end_confirmed';

  /// Move counter reached zero.
  /// Properties: rescue_remaining (int), coins (int).
  static const String outOfMoves = 'out_of_moves';

  /// Player won the level.
  /// Properties: level_definition_id, solution_length (int),
  ///             moves_remaining (int), streak_coins (int), total_coins_earned (int).
  static const String levelWon = 'level_won';

  /// Player chose to restart the attempt.
  /// Properties: moves_remaining (int).
  static const String restartRequested = 'restart_requested';

  // ── Progression ───────────────────────────────────────────────────────────

  /// Journey screen opened a level attempt flow.
  /// Properties: level_definition_id, chapter_id.
  static const String levelStarted = 'level_started';

  /// Level fully completed (reward granted).
  /// Properties: level_definition_id, chapter_id, coins_earned (int).
  static const String levelCompleted = 'level_completed';

  /// All 50 levels in a chapter completed.
  /// Properties: chapter_id, coins_earned (int), hints_earned (int).
  static const String chapterCompleted = 'chapter_completed';

  /// Story beat modal displayed.
  /// Properties: beat_id, chapter_id, beat_index (int), skipped (bool).
  static const String storyBeatViewed = 'story_beat_viewed';

  /// Tutorial flow fully completed.
  static const String tutorialCompleted = 'tutorial_completed';

  // ── Economy ───────────────────────────────────────────────────────────────

  /// Initial wallet grant completed for a new player.
  /// Properties: coins_granted (int), hints_granted (int).
  static const String walletInitialized = 'wallet_initialized';

  /// Any reward claimed (level / chapter / streak / daily).
  /// Properties: reward_type (string), coins (int), hints (int).
  static const String rewardClaimed = 'reward_claimed';

  /// Player spent Coins to buy a Hint.
  /// Properties: coins_spent (int), hints_after (int).
  static const String hintPurchased = 'hint_purchased';

  /// Player spent Coins for Extra Moves.
  /// Properties: coins_spent (int), rescue_index (int 1 or 2).
  static const String extraMovesPurchased = 'extra_moves_purchased';

  /// Player spent Coins for Dead-End Rescue.
  /// Properties: coins_spent (int).
  static const String deadEndRescuePurchased = 'dead_end_rescue_purchased';

  // ── Monetization ──────────────────────────────────────────────────────────

  /// Rewarded ad watched to completion.
  /// Properties: reward_type (hint | extra_moves | dead_end | coins), coins_granted (int).
  static const String rewardedAdCompleted = 'rewarded_ad_completed';

  /// Interstitial ad displayed.
  /// Properties: session_count (int), level_count (int).
  static const String interstitialShown = 'interstitial_shown';

  /// IAP flow initiated.
  /// Properties: product_id.
  static const String purchaseStarted = 'purchase_started';

  /// IAP server validation succeeded.
  /// Properties: product_id, platform (android | ios).
  static const String purchaseValidated = 'purchase_validated';

  /// IAP restore completed.
  /// Properties: entitlements_count (int).
  static const String restoreCompleted = 'restore_completed';

  // ── Daily ─────────────────────────────────────────────────────────────────

  /// Daily login reward claimed.
  /// Properties: day_index (int 1–7), coins (int), hints (int).
  static const String dailyRewardClaimed = 'daily_reward_claimed';

  /// Daily streak incremented.
  /// Properties: streak_days (int), milestone_hit (bool).
  static const String dailyStreakIncremented = 'daily_streak_incremented';

  /// Daily challenge completed for the first time today.
  /// Properties: challenge_key, coins_earned (int).
  static const String dailyChallengeCompleted = 'daily_challenge_completed';

  // ── Content ───────────────────────────────────────────────────────────────

  /// Remote content bundle activated atomically.
  /// Properties: bundle_version, schema_version (int), rules_version (int).
  static const String contentBundleActivated = 'content_bundle_activated';

  /// Bundle validation failed (hash / schema / rules mismatch).
  /// Properties: failure_reason (string), bundle_version.
  static const String contentBundleValidationFailed =
      'content_bundle_validation_failed';

  /// Bundle rollback triggered.
  /// Properties: from_version, to_version.
  static const String contentBundleRollback = 'content_bundle_rollback';
}
