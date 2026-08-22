# Analytics & KPI Specification
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 + related product/architecture specs  
**Important:** Platform, economy, Daily, monetization, and observability decisions listed as **APPROVED** in Final Decision Register v1.1 are **CONFIRMED**. Numeric product KPI targets, experiment platforms, and alert thresholds remain **PROPOSED/TBD** until calibrated from live data. Firebase/GCP quotas and billing budgets remain **TBD**. Azure Application Insights / Azure Monitor are **SUPERSEDED** for MVP.

---

# 1. Purpose

This document defines the analytics framework, event taxonomy, KPI model, dashboards, measurement rules, and data-quality requirements for the Arabic Solitaire Association game.

It covers:

- Product analytics.
- Gameplay analytics.
- Level analytics.
- Solver analytics.
- Difficulty analytics.
- Content analytics.
- Economy analytics.
- Monetization analytics.
- Progression analytics.
- Daily engagement analytics.
- Retention.
- Sessions.
- Funnel analytics.
- Cloud Save.
- Account linking.
- Notifications.
- Ads.
- IAP.
- CMS/content operations.
- Quality and reliability.
- Experiments.
- Business dashboards.
- Operational alerts.

The objective is to make the game measurable from the first production release without contaminating the Game Engine with analytics-provider-specific logic.

---

# 2. Analytics Principles

The analytics system should follow these principles:

1. Stable IDs over display text.
2. Event contracts must be versioned.
3. Gameplay analytics must not change gameplay behavior.
4. Analytics failures must never block play.
5. Sensitive/personal data collection must be minimized.
6. Board and Semantic Difficulty must remain separate dimensions.
7. Randomized Attempt data must preserve enough metadata for reproducibility.
8. Economy metrics must be auditable.
9. Monetization metrics must be separated from game-quality metrics.
10. Content quality must be measurable independently from board difficulty.
11. Dashboards should answer specific product questions, not collect vanity metrics.
12. KPI targets should be calibrated from real data rather than guessed and frozen prematurely.

---

# 3. Analytics Architecture

**PROPOSED**

Recommended logical flow:

```text
Game Engine / App Domain Events
        |
        v
Application Analytics Mapper
        |
        v
Analytics Event Contract
        |
        +--------------------+
        |                    |
        v                    v
Client Analytics SDK     Backend Operational Events
        |                    |
        v                    v
Analytics Platform       Logs / Metrics / Warehouse
        \____________________/
                 |
                 v
        Dashboards / BI / KPI
```

The Game Engine should emit domain events but not call Firebase/Amplitude/Mixpanel/etc. directly.

---

# 4. Analytics Provider

**CONFIRMED — Final Decision Register v1.1**

MVP product analytics stack:

- **Firebase Analytics** (client product analytics).
- **BigQuery export** enabled.
- Raw analytics retention baseline: **14 months**, then cost review.
- **Firebase Crashlytics** for mobile crash reporting.
- Backend/serverless observability: **Firebase / Google Cloud native logs and monitoring** for Cloud Functions / Cloud Run.
- **No separate Azure observability stack** (Azure Application Insights / Azure Monitor are **SUPERSEDED** for MVP).

Cost monitoring/budget alerts should be enabled before production rollout. Exact Firebase/GCP quotas, billing budgets, and analytics cost thresholds that trigger retention-policy review remain **TBD**.

---

# 5. Event Naming Convention

**PROPOSED**

Use lowercase snake_case.

Examples:

- `app_opened`
- `level_started`
- `move_committed`
- `association_completed`
- `hint_used`
- `level_completed`

Guidelines:

- event name describes completed fact or clear user action.
- avoid provider-specific prefixes.
- avoid names such as `click1`, `event2`, `misc`.

---

# 6. Event Schema Versioning

Each event should include:

- `event_schema_version`

Example:

`event_schema_version = 1`

When the semantic meaning of an event changes, increment version or create a new event.

---

# 7. Common Event Properties

Recommended common properties:

- `event_timestamp`
- `event_schema_version`
- `player_id` or anonymous analytics ID
- `session_id`
- `device_id?`
- `platform`
- `app_version`
- `build_number`
- `locale`
- `country_code?`
- `rules_version`
- `engine_version`
- `content_bundle_version`
- `economy_config_version`
- `experiment_assignments?`

Only include fields relevant and privacy-safe.

---

# 8. Gameplay Context Properties

For gameplay events, include where relevant:

- `level_id`
- `journey_level_number`
- `chapter_id`
- `chapter_number`
- `attempt_id`
- `attempt_number`
- `level_type`
- `level_config_version`
- `solver_version`
- `difficulty_model_version`
- `board_difficulty_band`
- `board_difficulty_score`
- `semantic_difficulty_band`
- `semantic_difficulty_score`
- `move_limit`
- `reference_moves`
- `association_count`
- `association_slot_count`
- `group_size_profile`
- `tableau_column_count`
- `stock_size`

---

# 9. Content Context Properties

Where relevant:

- `association_id`
- `association_variant_id`
- `relation_type`
- `content_type`
- `topic`
- `semantic_score`
- `ambiguity_level`
- `dialect_scope`
- `evergreen_classification`

Never depend solely on Arabic display text for aggregation.

---

# 10. Session Definition

**PROPOSED**

A session starts when:

- App opens into active use.
- Or returns after an inactivity timeout.

A session ends after:

- background/termination plus inactivity threshold.

Exact timeout is provider/product dependent and should be standardized.

---

# 11. Session KPIs

Track:

- Sessions per DAU.
- Median session length.
- P75/P90 session length.
- Levels started per session.
- Levels completed per session.
- Main Journey levels completed/session.
- Rewarded Ads/session.
- Interstitials/session.
- Hints/session.
- Restarts/session.

No target values are approved.

---

# 12. Core Product KPI Framework

Top-level KPI groups:

1. Acquisition.
2. Activation.
3. Engagement.
4. Retention.
5. Progression.
6. Gameplay Health.
7. Content Quality.
8. Economy Health.
9. Monetization.
10. Reliability.
11. LiveOps/Daily.
12. Operational Content Production.

---

# 13. North Star Metric

No North Star Metric is approved.

**PROPOSED candidate:**

`Weekly Meaningful Puzzle Completions`

Definition:
Number of completed puzzle levels by active users, excluding tutorial/internal/test completions.

Why useful:

- reflects actual play.
- rewards retention and engagement.
- does not directly optimize Ads.
- scales with content quality.

Alternative:

`Weekly Active Solvers Completing ≥ N Levels`

Exact North Star should be approved after initial live data.

---

# 14. Acquisition KPIs

If acquisition campaigns are used:

- Installs.
- First opens.
- Install-to-first-open rate.
- Cost per install.
- Organic vs paid installs.
- Store conversion rate.
- Country/market mix.

These may rely on store/ad attribution tools.

---

# 15. Activation Definition

**PROPOSED**

A player may be considered activated when they:

1. complete onboarding/tutorial,
2. and complete at least one real Main Journey Level.

Alternative stronger activation:
Complete first 3 Main Journey Levels.

Exact definition requires approval.

---

# 16. Activation KPIs

Track:

- First launch → Tutorial start.
- Tutorial start → Tutorial complete.
- Tutorial complete → First real Level start.
- First real Level start → First Level complete.
- Time to first Level complete.
- First-session Level completions.

---

# 17. Onboarding Funnel Events

Recommended:

- `onboarding_started`
- `onboarding_completed`
- `tutorial_started`
- `tutorial_step_started`
- `tutorial_step_completed`
- `tutorial_skipped`
- `tutorial_completed`
- `first_journey_level_started`
- `first_journey_level_completed`

Exact tutorial step IDs should be data-driven.

---

# 18. Onboarding Funnel KPIs

Track:

- Onboarding completion rate.
- Tutorial completion rate.
- Drop-off by tutorial step.
- Median tutorial duration.
- Number of invalid actions in tutorial.
- Hint use in tutorial if allowed.
- First-level completion after tutorial.

---

# 19. Engagement KPIs

Core:

- DAU.
- WAU.
- MAU.
- DAU/MAU.
- Sessions/user/day.
- Levels started/user/day.
- Levels completed/user/day.
- Average active days/week.
- Median playtime/day.

These require enough user volume before interpretation.

---

# 20. Retention KPIs

Track cohort retention:

- D1.
- D3.
- D7.
- D14.
- D30.
- W1.
- W4.

No target percentage is approved.

Segment by:

- acquisition source.
- country.
- device/platform.
- onboarding completion.
- early difficulty experience.
- ad exposure.
- payer/non-payer.

---

# 21. Return-to-Play KPI

**PROPOSED**

Track:

`Return After First Failure`

Percentage of players who encounter:

- Out-of-Moves.
- Dead End.
- Level restart.

and then start another Attempt within the same or next session.

Useful for frustration analysis.

---

# 22. Main Journey KPIs

Track:

- Current Level distribution.
- Levels completed/day.
- Chapter completion rate.
- Time to Chapter completion.
- Attempts per Level.
- First-attempt win rate.
- Restart rate by Level.
- Abandonment by Level.
- Progression velocity.

---

# 23. Level Started Event

`level_started`

Recommended properties:

- level_id
- level_number
- chapter_id
- attempt_id
- attempt_number
- level_type
- move_limit
- board_score
- semantic_score
- association_count
- slots
- stock_size
- group_profile
- reference_moves
- solver_version

---

# 24. Level Completed Event

`level_completed`

Properties:

- level_id
- attempt_id
- attempts_on_level
- moves_used
- moves_remaining
- completion_time_ms
- base_coins
- remaining_move_coins
- streak_coins
- total_coins
- hints_used
- undo_count
- stock_advances
- restores
- dead_end_rescues
- extra_moves_used
- rewarded_ads_used
- board_score
- semantic_score

---

# 25. Level Failed Event

Possible:

`level_attempt_ended`

with reason:

- restart
- abandon
- out_of_moves_declined
- dead_end_restart
- app_terminated_without_resume
- invalidated_attempt

This may be cleaner than many separate failure events.

---

# 26. Attempt KPIs

Track per Level:

- Attempts to completion.
- Median attempts.
- First-attempt completion rate.
- 2nd-attempt recovery rate.
- 3+ attempt rate.
- Attempt abandonment.

---

# 27. Move Event Strategy

Do not necessarily send one high-volume analytics event for every drag in production if cost/noise becomes excessive.

**PROPOSED**

Options:

### Full Move Telemetry
Useful during beta.

### Aggregated Attempt Telemetry
Store counters and only emit summary on Attempt end.

### Sampled Move Telemetry
Detailed events for a percentage of sessions.

Recommendation:
Use detailed Move telemetry in QA/beta and evaluate production cost.

---

# 28. Move Committed Event

If enabled:

`move_committed`

Properties:

- action_type
- move_number
- moves_remaining
- source_type
- target_type
- stack_size
- streak_effect
- association_id?
- revealed_card
- completed_association
- state_hash? only for debug sampling

---

# 29. Invalid Move Event

`move_rejected`

Properties:

- rejection_reason
- attempted_source_type
- attempted_target_type
- association_id?
- streak_before
- level_id
- move_number

This is important for:

- UX issues.
- semantic confusion.
- tutorial gaps.

---

# 30. Invalid Move KPIs

Track:

- Invalid attempts/Level.
- Invalid attempts/player.
- Wrong Association attempts.
- Invalid drag target rate.
- Invalid attempts before Hint.
- Invalid attempts by content type.

High values may indicate:

- unclear rules.
- poor UI affordance.
- semantic ambiguity.

---

# 31. Stack Analytics

Events/counters:

- stack_created
- stack_merged
- association_stack_created
- stack_to_slot
- stack_to_active_association

KPIs:

- Stack merges per Level.
- Average max Stack size.
- Frequency of Association Stack use.
- Empty-column Stack usage.

Useful for understanding whether players use intended mechanics.

---

# 32. Association Analytics

Events:

- `association_activated`
- `association_progressed`
- `association_completed`

Properties:

- association_id
- variant_id
- completion_order
- members_attached_on_activation
- moves_to_completion
- semantic_score

---

# 33. Association Completion KPIs

Track:

- Average moves to first Association completion.
- Completion order patterns.
- Association-specific completion time.
- Hint rate per Association.
- Wrong-placement rate per Association.
- Restart correlation.

---

# 34. Stock Analytics

Events/counters:

- stock_advanced
- stock_card_played
- stock_restored

KPIs:

- Stock Advances/Attempt.
- Restores/Attempt.
- Required vs actual Restores.
- Players with ≥1 Restore.
- Excessive Restore rate.
- Stock-heavy Level completion rate.

---

# 35. Stock Quality Signals

Potential warning conditions:

- Very high Restore usage.
- High Stock Advance count without progress.
- Large difference between Solver-required and player actual Stock cycles.

Exact thresholds are **PROPOSED/TBD**.

---

# 36. Undo Event

`undo_used`

Properties:

- previous_action_type
- move_restored
- level_id
- attempt_id
- board_score

Also track:

`undo_unavailable_attempted`

if UI allows interaction/tooltip.

---

# 37. Undo KPIs

Track:

- Undo use per Attempt.
- % Attempts with Undo.
- Undo use before win.
- Undo use before restart.
- Undo use by difficulty band.

High Undo rate may indicate healthy strategy or excessive trap pressure; interpret with Dead-End data.

---

# 38. Hint Events

Recommended:

- `hint_requested`
- `hint_granted`
- `hint_unavailable`
- `hint_acquired_with_coins`
- `hint_acquired_with_rewarded_ad`
- `hint_shown`
- `hint_followed`

`hint_followed` means the next committed action matches the recommended action within a defined window.

---

# 39. Hint Properties

Include:

- hint_source
- hint_balance_before
- hint_balance_after
- coin_cost?
- solver_confidence
- solver_duration_ms
- hinted_action_type
- board_score
- semantic_score
- association_id?

---

# 40. Hint KPIs

Track:

- Hints/DAU.
- Hints/Level.
- Hint usage by Level.
- Hint usage by Semantic band.
- Hint follow rate.
- Coin vs rewarded-ad Hint acquisition.
- Level completion after Hint.
- Time from Hint to action.

---

# 41. Hint Quality KPI

**PROPOSED**

`Hint Followed Success Rate`

Percentage of Hint-following Attempts that still complete successfully.

Also:

`Hint Immediate Follow Rate`

High rate may indicate clear Hint wording.

Low rate may indicate:

- confusing UI.
- poor text.
- recommendation not useful to player.

---

# 42. Dead-End Events

Recommended:

- `dead_end_detected`
- `dead_end_type`
- `dead_end_undo_selected`
- `dead_end_rescue_selected`
- `dead_end_restart_selected`
- `dead_end_rescue_completed`

---

# 43. Dead-End Properties

Include:

- structural_vs_move_budget
- move_number
- moves_remaining
- board_score
- safe_branch_ratio
- previous_action_type
- undo_available
- rescue_type
- solver_duration

---

# 44. Dead-End KPIs

Track:

- Dead-End rate/Attempt.
- Dead-End rate/Level.
- Dead-End rate by Board Difficulty.
- First Dead-End Move position.
- Undo recovery rate.
- Rescue conversion.
- Restart after Dead End.
- Completion after rescue.

---

# 45. Dead-End Quality Signal

Excessive Dead-End rate at low Board Difficulty may indicate:

- acceptance model too loose.
- bad board generation.
- poor Hint/learning.
- excessive trap density.

Thresholds remain TBD.

---

# 46. Out-of-Moves Events

Recommended:

- `out_of_moves_reached`
- `extra_moves_offer_shown`
- `extra_moves_purchased_coins`
- `extra_moves_rewarded_ad`
- `extra_moves_declined`
- `extra_moves_granted`

---

# 47. Out-of-Moves KPIs

Track:

- % Attempts reaching 0 Moves.
- Extra Moves take rate.
- Coin vs Ad choice.
- Completion after Extra Moves.
- Average extra rescues/Attempt.
- Out-of-Moves rate by Move Slack band.

---

# 48. Move Limit Health

Compare:

- reference_moves
- move_limit
- actual_moves_used
- extra_moves_used
- win/fail

Key KPI:

`Human Efficiency Ratio = actual_moves_used / reference_moves`

for completed Attempts.

---

# 49. Move Efficiency KPI

**PROPOSED**

Track distribution of:

`actual_moves_used / reference_moves`

Interpretation:

- near 1.0 → highly efficient.
- larger → more exploratory/inefficient.

Do not make it player-facing unless later desired.

---

# 50. Remaining Moves KPI

Track:

- Average remaining Moves on win.
- Median remaining Moves.
- Distribution by Board band.
- Distribution by Level.

Important because Remaining Moves directly affect Coin generation.

---

# 51. Streak Analytics

Events:

- `streak_progressed`
- `streak_reset`
- `streak_reward_earned`
- `streak_tier_advanced`

Properties:

- tier_requirement
- current_count
- reward_amount
- trigger_action_type

---

# 52. Streak KPIs

Track:

- Average streak Coins/Level.
- % Levels with any streak reward.
- Average highest streak tier.
- Invalid move reset frequency.
- Streak contribution to total Level reward.

---

# 53. Win Reward Analytics

At Level completion capture:

- base reward.
- remaining-move reward.
- streak reward.
- total reward.

KPIs:

- Average Coin income/Level.
- Average reward by difficulty.
- Reward component percentage.
- Coin inflation trend.

---

# 54. Gameplay Funnel

Core funnel:

`Level Start`
→ `First Valid Move`
→ `First Association Completion`
→ `Level Win`

Measure drop between each stage.

Segment by:

- Board Difficulty.
- Semantic Difficulty.
- Level range.
- attempt number.
- content type.

---

# 55. Time-to-First-Action

Track:

- time from board rendered to first valid Move.
- time to first invalid action.
- time to first Hint.

High time may indicate:

- semantic confusion.
- overwhelming board.
- UI uncertainty.

---

# 56. Time-to-First-Association

Track:

`level_started → first association_completed`

Compare to Solver reference metric `moves_to_first_completion`.

Useful for pacing calibration.

---

# 57. Completion Time

Track:

- median completion time.
- p75/p90.
- by Level.
- by difficulty.
- by content type.

Avoid using mean alone because long idle sessions distort it.

---

# 58. Level Health Score

No formula approved.

**PROPOSED**

A Level Health composite may combine:

- completion rate.
- restart rate.
- Hint use.
- Dead-End rate.
- Out-of-Moves rate.
- completion time.
- content complaints.

Use as internal triage, not a source of truth.

---

# 59. Level Health Alert

Possible alert:

"Level significantly deviates from neighboring Levels or target B/S band."

Exact statistical rule should be data-driven.

---

# 60. Board Difficulty Analytics

Track predicted Board Score against:

- completion rate.
- first-attempt win.
- restarts.
- Dead Ends.
- Extra Moves.
- actual/reference Move ratio.
- completion time.

---

# 61. Board Difficulty Calibration KPI

**PROPOSED**

`Difficulty Calibration Error`

Difference between predicted Board Difficulty and observed player difficulty proxy.

Observed proxy may use a regression/model rather than one raw metric.

This is an advanced analytics feature.

---

# 62. Semantic Difficulty Analytics

Track predicted Semantic Score against:

- Hint rate.
- invalid wrong-association attempts.
- time to first grouping.
- completion time.
- restart rate.
- player content reports.

---

# 63. Semantic Calibration KPI

Compare editorial semantic rating with observed behavior.

Flag:

- "S2 behaves like S4."
- "S4 behaves like S1."

This improves Content Design over time.

---

# 64. B × S Heatmap

Maintain matrix:

| Board \ Semantic | S1 | S2 | S3 | S4 | S5 |
|---|---|---|---|---|---|
| B1 | | | | | |
| B2 | | | | | |
| B3 | | | | | |
| B4 | | | | | |
| B5 | | | | | |

For each cell track:

- Level completion rate.
- first-attempt completion.
- Hint rate.
- Dead-End rate.
- Extra Moves rate.
- session exits.

---

# 65. Difficulty Wave Analytics

For each proposed wave:

Track:

- completion rate by wave position.
- drop-off after peak.
- retention after relief Level.
- attempts per Level.

Goal:
Determine whether wave pacing feels healthy.

---

# 66. Chapter Analytics

Track:

- Chapter start.
- Chapter completion.
- Chapter completion time.
- drop-off position.
- peak Level difficulty.
- % players reaching next Chapter.

Standard Chapter = 50 Levels.

---

# 67. Progression Velocity

**PROPOSED**

Track:

- Levels/day.
- Levels/active day.
- Levels/week.
- Days to Chapter completion.

Segment by:

- skill proxy.
- payer/non-payer.
- ads/no-ads entitlement.

---

# 68. Content Analytics Overview

Content analytics should answer:

- Which Associations confuse players?
- Which clues are too vague?
- Which Members are obscure?
- Which relation types are fun vs frustrating?
- Which content types perform well?
- Which dialect/local content creates regional problems?

---

# 69. Association-Level KPIs

Per Association/Variant:

- exposures.
- completion count.
- Hint usage.
- wrong placement attempts.
- time to completion.
- abandon/restart correlation.
- content-report rate.
- difficulty prediction error.

---

# 70. Member-Level KPIs

For sampled/detailed telemetry:

- wrong target attempts.
- time before first correct use.
- frequency of being involved in Hint.
- ambiguity conflicts.

Avoid over-collecting if event volume is too high.

---

# 71. Relation Type KPIs

Compare:

- Direct Category.
- Context.
- Shared Property.
- Linguistic.
- Wordplay.
- etc.

Metrics:

- completion.
- Hint.
- invalid attempts.
- satisfaction proxy.
- retention after exposure.

---

# 72. Content Type KPIs

Compare:

- Text.
- Number.
- Symbol.
- Emoji.
- Illustration.

Metrics:

- completion rate.
- engagement.
- Hint rate.
- recognition errors.
- session length.

---

# 73. Arabic Content KPIs

Potential metrics:

- Hint rate by clue type.
- wrong-placement rate by ambiguity level.
- dialect-region mismatch complaints.
- rare-word failure rate.
- diacritic-related content reports.

---

# 74. Content QA KPI

Operational:

- production content disabled after publication.
- spelling issue rate.
- semantic error rate.
- duplicate issue rate.
- average review rounds.

---

# 75. AI Content Production KPIs

If AI-assisted content creation is used:

- AI candidates generated.
- AI candidate approval rate.
- edits per approved candidate.
- rejection reason.
- time from generation to approval.
- live performance vs human-authored content.

Do not auto-assume AI content quality from approval rate alone.

---

# 76. Content Production Velocity

Track:

- Associations approved/week.
- Variants approved/week.
- Levels content-ready/week.
- review turnaround.
- backlog size.

Useful for Endless-content capacity planning.

---

# 77. Content Reuse KPIs

Track:

- reuse count per Association.
- average spacing between reuse.
- exact variant repetition rate.
- player exposure repetition.

Goal:
Measure perceived repetition risk.

---

# 78. Economy Analytics Overview

Economy questions:

- Are Coins accumulating too fast?
- Are players running out too often?
- Are sinks used?
- Are Hints priced reasonably?
- Do utility purchases correlate with frustration?
- Are paid Coin Packs necessary/valuable?

---

# 79. Coin Source Events

Sources include:

- Level base reward.
- Remaining Moves.
- Streak.
- Daily Reward.
- Daily Challenge.
- Rewarded Ads.
- Coin Pack IAP.
- future events.

Each Wallet transaction must contain source reason.

---

# 80. Coin Sink Events

Sinks include:

- Hint.
- Extra Moves.
- Dead-End Rescue.
- Cosmetics later (Post-MVP / DEFERRED).
- Mid-Level Reshuffle is **not in MVP**.

Each sink needs:

- cost.
- balance before/after.
- source context.

---

# 81. Economy KPIs

Track:

- Coins earned/DAU.
- Coins spent/DAU.
- net Coin flow.
- median Wallet balance.
- Wallet balance distribution.
- zero-balance rate.
- sink utilization.
- source mix.
- sink mix.

---

# 82. Economy Inflation KPI

**PROPOSED**

`Net Coin Creation = Coins Earned - Coins Spent`

Track by:

- day.
- player cohort.
- player progression.

Persistent positive imbalance may create inflation.

No acceptable threshold is approved.

---

# 83. Wallet Balance Distribution

Track percentile distribution:

- P10
- P25
- P50
- P75
- P90
- P99

Averages alone can hide whales/high-balance outliers.

---

# 84. Hint Economy KPIs

Track:

- Hint balance distribution.
- Hints earned.
- Hints consumed.
- Coin-funded Hint rate.
- rewarded-ad Hint rate.
- zero-Hint encounters.

---

# 85. Extra Moves Economy KPIs

Track:

- Coin spend on Extra Moves.
- rewarded-ad Extra Moves.
- completion after grant.
- repeat Extra Moves within same Attempt.
- percentage of Coins spent on Extra Moves.

---

# 86. Rescue Economy KPIs

Track:

- Rescue offers.
- Rescue acceptance.
- Coin vs Ad.
- completion after Rescue.
- Rescue cost recovery behavior.
- later restart rate.

---

# 87. Monetization Overview

Approved monetization categories:

- Rewarded Ads.
- Adaptive Interstitial Ads.
- Remove Ads IAP.
- Coin Pack IAP.

No other IAP category is currently approved.

---

# 88. Rewarded Ad Events

Recommended:

- `rewarded_ad_offer_shown`
- `rewarded_ad_started`
- `rewarded_ad_completed`
- `rewarded_ad_failed`
- `rewarded_ad_reward_granted`

Properties:

- placement.
- reward type.
- reward amount.
- level/attempt context.
- provider.
- network availability result.

---

# 89. Rewarded Ad KPIs

Track:

- Offer rate.
- Start rate.
- Completion rate.
- Reward grant success.
- Ads/DAU.
- Ads/session.
- placement mix.
- Level completion after rescue ad.

---

# 90. Interstitial Events

Recommended:

- `interstitial_eligible`
- `interstitial_shown`
- `interstitial_failed`
- `interstitial_dismissed`

Properties:

- levels_since_last.
- session_count.
- prior rewarded ad elapsed time.
- placement context.

---

# 91. Interstitial KPIs

Track:

- Interstitials/DAU.
- Interstitials/session.
- level interval.
- session exits after Interstitial.
- next-Level start after Interstitial.
- retention by ad-exposure band.

Goal:
detect overexposure.

---

# 92. Remove Ads KPIs

Track:

- Store impression.
- Product view.
- purchase start.
- success.
- failure.
- restore.
- conversion rate.
- purchases by ad exposure.

---

# 93. Coin Pack KPIs

Track:

- product impressions.
- pack views.
- purchase conversion.
- revenue/pack.
- repeat purchase.
- Coin balance before purchase.
- sink usage after purchase.

Coin Pack ladder is **CONFIRMED**: 1,000 / 3,000 / 7,000 / 15,000 Coins. Exact real-money prices remain **TBD**.

---

# 94. Revenue KPIs

When monetization launches:

- Gross revenue.
- Net revenue estimate.
- ARPDAU.
- ARPU.
- ARPPU.
- payer conversion.
- ad revenue/DAU.
- IAP revenue/DAU.
- revenue split ads vs IAP.

No numeric targets approved.

---

# 95. LTV

**PROPOSED**

Calculate cohort LTV after enough history.

Segment by:

- country.
- acquisition source.
- platform.
- payer type.

Do not rely on immature early LTV estimates.

---

# 96. Monetization Guardrail KPIs

Always pair revenue with:

- retention.
- session exits.
- level completion.
- restart.
- rating/review sentiment.
- ad frequency.

Never optimize monetization in isolation.

---

# 97. Daily Reward Events

Recommended:

- `daily_reward_available`
- `daily_reward_opened`
- `daily_reward_claimed`
- `daily_reward_missed`

Properties:

- calendar day.
- reward type.
- reward amount.
- streak day.

---

# 98. Daily Reward KPIs

Track:

- Eligible users.
- Open rate.
- Claim rate.
- Claim-to-play rate.
- next-session continuation.
- reward inflation contribution.

---

# 99. Daily Streak Events

Recommended:

- `daily_streak_incremented`
- `daily_streak_broken`
- `daily_streak_milestone_reached`

---

# 100. Daily Streak KPIs

Track:

- Median current streak.
- **CONFIRMED** milestone rates: 3 / 7 / 14 / 30 days (100 / 250 / 400 / 750 Coins).
- Streak break rate.
- return rate after streak break.
- notification effect (Daily Challenge + Streak Risk at launch; quiet hours 22:00–09:00 player-local).

---

# 101. Daily Challenge Events

Recommended:

- `daily_challenge_viewed`
- `daily_challenge_started`
- `daily_challenge_completed`
- `daily_challenge_failed`
- `daily_challenge_reward_claimed`

---

# 102. Daily Challenge KPIs

Track:

- Eligible users.
- participation rate.
- completion rate.
- attempts/challenge.
- completion time.
- reward claim rate.
- return to Main Journey after challenge.

---

# 103. Daily Challenge Fairness

Because Daily Challenge may use shared board:

Track:

- board version.
- challenge date.
- solver reference moves.
- completion distribution.

If Leaderboards launch later, this data becomes critical.

---

# 104. Notification Events

Recommended:

- `notification_permission_prompted`
- `notification_permission_granted`
- `notification_permission_denied`
- `notification_sent`
- `notification_delivered`
- `notification_opened`
- `notification_deep_link_completed`

---

# 105. Notification KPIs

Track by category:

- permission opt-in.
- delivery rate.
- open rate.
- session conversion.
- opt-out rate.
- uninstall/retention guardrails where available.

---

# 106. Smart Notification KPI

**PROPOSED**

Measure incremental behavior:

- challenge completion after Daily Challenge push.
- streak preservation after streak-risk push.
- Daily claim after reward push.

Avoid judging notifications only by open rate.

---

# 107. Account/Cloud Analytics

Events:

- anonymous profile created.
- link flow started.
- link success.
- link failure.
- cloud sync started.
- sync success.
- sync failure.
- sync conflict.
- restore purchases.

---

# 108. Account Linking KPIs

Track:

- link rate.
- provider split.
- failure rate.
- conflict rate.
- link timing by progression.

No requirement to maximize account linking because anonymous play is intentional.

---

# 109. Cloud Save KPIs

Track:

- sync success.
- median sync latency.
- pending sync count.
- conflict rate.
- recovery after offline.
- data-loss incidents.

---

# 110. Cloud Reliability KPI

**PROPOSED**

`Successful Cloud Reconciliation Rate`

Percentage of queued local changes eventually synced without manual intervention.

---

# 111. Purchase Reliability KPIs

Track:

- purchase starts.
- platform success.
- backend validation success.
- grant success.
- pending duration.
- duplicate transaction prevention.
- restore success.
- refund/revocation processing.

---

# 112. Solver Analytics Overview

The Solver is a production-critical subsystem.

Track:

- solve duration.
- states explored.
- branches.
- timeouts.
- solvability.
- rejection reason.
- reference moves.
- Hint latency.
- Dead-End latency.

---

# 113. Generation Solver Events

Recommended:

- `board_generation_started`
- `board_generation_candidate_rejected`
- `board_generation_completed`
- `board_generation_failed`

These may be operational events rather than user analytics events.

---

# 114. Solver Generation KPIs

Track:

- candidate attempts per accepted board.
- acceptance rate.
- p50/p95 solve time.
- timeout rate.
- fallback rate.
- memory/CPU where available.

---

# 115. Board Rejection Reasons

Aggregate:

- UNSOLVABLE.
- MOVE_LIMIT_EXCEEDED.
- TOO_EASY.
- TOO_HARD.
- TOO_MANY_RESTORES.
- COMPLETION_DELAY.
- TIMEOUT.
- INVALID_STATE.

Exact enum is proposed.

---

# 116. Solver Hint KPIs

Track:

- Hint solve p50/p95.
- Hint failure/inconclusive rate.
- stale-result discard rate.
- verified-winning Hint rate.

---

# 117. Dead-End Solver KPIs

Track:

- detection latency.
- structural vs Move-Budget cases.
- inconclusive/timeout.
- false positive bugs.
- false negative bug reports.

False-positive Dead-End should be treated as critical quality issue.

---

# 118. Solver Quality KPI

**PROPOSED**

`Solution Replay Success Rate`

Every Solver solution used in validation should replay through Game Engine.

Target conceptually should be effectively 100%; any mismatch is a defect.

---

# 119. Generation Quality KPI

Track:

`Accepted Board Rate = accepted candidate boards / generated candidate boards`

Very low rate signals poorly tuned Level Config or Solver performance.

No threshold approved.

---

# 120. Difficulty Variance KPI

For each Level:

- mean Board Score.
- min/max.
- standard deviation.

High variance across Restarts means inconsistent Level identity.

---

# 121. Reliability Analytics

Client:

- crash-free users.
- crash-free sessions.
- ANR/freeze where platform provides.
- startup failures.
- content bundle load failure.
- active-state restore failure.

Backend / serverless (GCP-native, not Azure App Insights):

- Cloud Functions / Cloud Run availability.
- error rate.
- p95 latency.
- Firestore/operation errors.
- purchase validation failures.

---

# 122. Crash-Free KPI

**PROPOSED**

Track:

- Crash-Free Users.
- Crash-Free Sessions.

No numeric launch target is approved.

---

# 123. App Startup KPI

Track:

- cold start duration.
- warm start duration.
- time to Home.
- time to resumed gameplay.

Segment by device class/platform.

---

# 124. Gameplay Performance KPI

Track:

- frame drops if instrumentation exists.
- long frame rate.
- drag latency.
- animation jank.
- Solver CPU blocking incidents.

Exact platform tooling depends on client stack.

---

# 125. Content Delivery KPIs

Track:

- manifest fetch success.
- bundle download success.
- download size.
- activation success.
- rollback count.
- old-version adoption.

---

# 126. Content Bundle Adoption

For every active bundle:

- % DAU on latest.
- % on previous.
- incompatible client count.
- failed activation count.

---

# 127. Remote Config KPIs

Track:

- fetch success.
- config version adoption.
- fallback-to-cache rate.
- fallback-to-bundled-default rate.

---

# 128. CMS Operational KPIs

Track:

- Drafts created.
- Items reviewed.
- Approval rate.
- Rejection rate.
- Time to approval.
- Publication frequency.
- emergency deactivation count.
- reviewer workload.

---

# 129. Content Review Turnaround

**PROPOSED**

Measure median and p90:

`Draft Created → Production Approved`

Break down by review stage.

---

# 130. Level Production KPIs

Track:

- Level Configs created.
- simulation pass rate.
- Solver rejection rate.
- human playtest pass rate.
- publish lead time.

---

# 131. QA KPI

Track:

- defects by severity.
- regression escape rate.
- solver/game-engine parity failures.
- content defect rate.
- crash regressions.
- automation coverage.

Coverage percentage targets are TBD.

---

# 132. Funnel Dashboard

Recommended funnel:

```text
Install
→ First Open
→ Tutorial Start
→ Tutorial Complete
→ First Level Start
→ First Level Win
→ Level 5
→ Level 10
→ Chapter 1 Complete
→ D1 Return
→ D7 Return
```

Exact milestone checkpoints can be adjusted.

---

# 133. First Session Dashboard

Track:

- session length.
- tutorial completion.
- levels completed.
- first failure.
- first Hint.
- first ad.
- first Shop open.
- exit point.

---

# 134. Retention Dashboard

Cohorts:

- install date.
- country.
- platform.
- acquisition source.
- first-session levels completed.
- first-day difficulty exposure.

Metrics:

- D1/D3/D7/D14/D30.

---

# 135. Gameplay Health Dashboard

Widgets:

- level completion heatmap.
- restart rate.
- Dead-End rate.
- Out-of-Moves rate.
- Hint rate.
- actual/reference Moves.
- remaining Moves.
- level completion time.

---

# 136. Difficulty Dashboard

Views:

- Board band performance.
- Semantic band performance.
- B×S heatmap.
- predicted vs actual.
- Restart variance.
- wave performance.

---

# 137. Content Quality Dashboard

Views:

- Association Hint rate.
- wrong-target rate.
- content reports.
- semantic difficulty mismatch.
- relation type performance.
- content type performance.
- dialect/regional issues.

---

# 138. Economy Dashboard

Views:

- Coins earned/spent.
- source/sink breakdown.
- Wallet distribution.
- Hint balance.
- Extra Moves spend.
- Rescue spend.
- reward inflation.

---

# 139. Monetization Dashboard

Views:

- rewarded ad funnel.
- interstitial exposure.
- Remove Ads conversion.
- Coin Pack conversion.
- revenue split.
- retention guardrails.

---

# 140. Daily Engagement Dashboard

Views:

- Daily Reward claim.
- Daily Challenge participation.
- Daily Streak distribution.
- notification conversion.

---

# 141. Reliability Dashboard

Views:

- crash-free rate.
- startup success.
- API p95.
- cloud sync.
- purchase validation.
- content update.
- Solver latency/failure.

---

# 142. Executive KPI Dashboard

Recommended top-level cards:

- DAU / WAU / MAU.
- D1 / D7 / D30.
- Levels completed/DAU.
- Main Journey completion health.
- average session duration.
- payer conversion.
- ad revenue/DAU.
- crash-free users.
- content defect rate.

Exact list can evolve after launch.

---

# 143. KPI Segmentation

Key dimensions:

- platform.
- country.
- app version.
- content bundle.
- chapter.
- level range.
- Board band.
- Semantic band.
- player skill proxy.
- payer/non-payer.
- Remove Ads entitlement.
- new/returning player.

---

# 144. Player Skill Proxy

No player skill system is approved.

**PROPOSED analytics-only score**

May infer from:

- actual/reference Move ratio.
- Hint use.
- restart rate.
- Dead-End rate.
- progression speed.

Used only for analytics segmentation unless future product decision says otherwise.

---

# 145. Cohort Definitions

Possible cohorts:

- install cohort.
- first-purchase cohort.
- Chapter-completion cohort.
- Daily Challenge participant cohort.
- high-Hint cohort.
- no-Hint skilled cohort.

---

# 146. Experimentation

Full Product allows experimentation conceptually.

No experiment platform is approved.

Possible experiment types:

- onboarding presentation.
- Shop layout.
- notification timing.
- ad frequency.
- Daily Reward presentation.
- Home layout.

---

# 147. Experiment Guardrails

Do not A/B test core rules casually.

Core rule experiments such as:

- Move cost.
- Stack legality.
- Association completion behavior.

would require Rules versioning and explicit product approval.

---

# 148. Experiment Event Requirements

Each exposure should include:

- experiment_id.
- variant_id.
- exposure_time.
- eligibility criteria/version.

Only analyze users actually exposed to variant.

---

# 149. Experiment Success Metrics

Every experiment should define:

- primary metric.
- guardrail metrics.
- minimum sample.
- duration.
- decision rule.

No post-hoc metric shopping.

---

# 150. Analytics Data Quality

Analytics is only useful if event integrity is monitored.

Track:

- duplicate event rate.
- missing required property rate.
- event delivery failure.
- schema-version drift.
- timestamp anomalies.
- impossible sequences.

---

# 151. Event Deduplication

Critical events should have stable unique IDs where appropriate:

- Level completion.
- Wallet transaction.
- purchase success.
- Daily Reward claim.

Analytics pipeline should avoid double counting retries.

---

# 152. Event Ordering

Client event timestamps may arrive out of order.

Use:

- event timestamp.
- sequence number where useful.
- state revision for gameplay.

Do not depend purely on ingestion order.

---

# 153. Attempt Sequence

Include:

- `attempt_number_for_level`
- `move_sequence_number`

where useful.

This enables accurate funnels within one Level.

---

# 154. Test/Bot Traffic

Mark:

- internal test users.
- QA builds.
- automation/bots.
- simulation traffic.

Exclude from product KPIs.

---

# 155. Development Environment Separation

Analytics should separate:

- DEV.
- STAGING.
- PROD.

Do not pollute production dashboards with test events.

---

# 156. Privacy

Avoid analytics properties containing:

- real names.
- email.
- phone.
- exact location.
- contact lists.
- free-text user input.

Puzzle content should generally use IDs rather than sending full Arabic text.

---

# 157. User Deletion

If user requests deletion:

- analytics linkage should be deleted/anonymized where legally required and technically supported.

Exact compliance policy belongs to Privacy specification.

---

# 158. Analytics Retention

**CONFIRMED baseline (Register v1.1):**

- Raw analytics retention: **14 months**, then cost review.
- Aggregated KPIs → longer operational retention as needed.
- Purchase/economy audit → governed by transaction/legal policy.
- Debug traces → short-lived.
- Exact cost thresholds that trigger retention-policy review remain **TBD**.

---

# 159. Sampling

**PROPOSED**

High-volume events such as every Move may be sampled in production.

Never sample away:

- purchase success.
- Wallet transaction.
- Level completion.
- fatal crashes.
- content publication.

---

# 160. Move Telemetry Sampling Strategy

Possible:

- 100% beta.
- 10–20% production detailed move traces.
- 100% Attempt summary.

Exact rate TBD.

---

# 161. Attempt Summary Event

Recommended high-value event:

`attempt_summary`

Emitted when Attempt ends or wins.

Contains counters:

- total moves.
- valid moves.
- invalid attempts.
- stack merges.
- stock advances.
- restores.
- hints.
- undo.
- dead ends.
- extra moves.
- associations completed.
- duration.
- outcome.

This reduces high-volume telemetry dependence.

---

# 162. Level Summary Event

At Level completion:

- attempts count.
- total time across attempts.
- total hints.
- total restarts.
- total ads.
- total Coin spend.
- reward earned.

Useful for progression analysis.

---

# 163. User-Day Aggregate

**PROPOSED**

Warehouse/BI may build daily aggregate:

- sessions.
- levels.
- playtime.
- coins earned.
- coins spent.
- ads.
- IAP.
- Daily actions.

Useful for cohort queries.

---

# 164. KPI Alerting

Automated alerts should focus on sharp regressions.

Examples:

- crash-free users drops.
- purchase validation drops.
- Solver generation timeout spike.
- Level completion collapses after content update.
- content bundle activation fails.

---

# 165. Statistical Baselines

**PROPOSED**

Use rolling historical baselines rather than hard-coded alert thresholds where possible.

Example:

Alert if metric deviates significantly from previous 7-day same-weekday baseline.

Exact alert statistics TBD.

---

# 166. Launch Analytics Checklist

Before production:

- [ ] Event taxonomy implemented.
- [ ] Event schema versioned.
- [ ] DEV/STAGING/PROD separated.
- [ ] Level/Attempt IDs present.
- [ ] Solver/Difficulty versions present.
- [ ] Purchase events verified.
- [ ] Wallet events verified.
- [ ] Crash reporting verified.
- [ ] Content bundle events verified.
- [ ] Analytics consent/privacy behavior verified.
- [ ] Test traffic excluded.
- [ ] Core dashboards ready.

---

# 167. MVP P0 Event Set

Recommended P0 events:

- app_opened
- session_started
- onboarding_started
- onboarding_completed
- tutorial_started
- tutorial_step_completed
- tutorial_completed
- home_viewed
- level_started
- move_rejected
- association_activated
- association_completed
- stock_restored
- hint_requested
- hint_shown
- undo_used
- dead_end_detected
- out_of_moves_reached
- extra_moves_granted
- attempt_summary
- level_completed
- level_restarted
- shop_viewed
- purchase_started
- purchase_completed
- purchase_failed
- rewarded_ad_completed
- rewarded_ad_reward_granted
- account_linked
- cloud_sync_failed
- content_bundle_activated

Detailed Move event can be beta/debug or sampled.

---

# 168. Daily Launch Event Set (P0 at launch)

**CONFIRMED:** Daily Reward, Daily Challenge, Daily Streak, and Smart Notification infrastructure launch with P0. Include:

- daily_reward_opened
- daily_reward_claimed
- daily_streak_incremented
- daily_streak_broken
- daily_challenge_started
- daily_challenge_completed
- notification_permission_prompted
- notification_opened

---

# 169. Post-MVP Events

Add for:

- XP.
- achievements.
- badges.
- collections.
- cosmetics.
- events.
- packs.
- leaderboards.
- experiments.

---

# 170. KPI Ownership

**PROPOSED**

Assign logical owner:

- Product → retention, engagement, monetization.
- Game Design → Level/difficulty health.
- Content → semantic/content KPIs.
- Engineering → reliability/Solver performance.
- Growth → acquisition/attribution.
- Operations → CMS/content pipeline.

One metric may have multiple stakeholders but one primary owner.

---

# 171. KPI Review Cadence

**PROPOSED**

- Daily operational health.
- Weekly product/game review.
- Monthly economy/content review.
- Per-release quality review.

Exact cadence depends on team size.

---

# 172. Pre-Launch KPI Philosophy

Before enough real users:

Use KPIs primarily to:

- catch defects.
- calibrate difficulty.
- validate funnels.

Do not over-optimize retention/revenue based on tiny samples.

---

# 173. Soft Launch Measurement

**PROPOSED**

If soft launch is used, evaluate:

- tutorial completion.
- D1/D7 retention.
- first-session progression.
- Level completion distribution.
- crash-free rate.
- Solver stability.
- content defect rate.
- economy flow.
- ad impact.

No soft-launch market is approved.

---

# 174. KPI Targets

No numeric product KPI targets are currently approved.

This document intentionally does not lock:

- D1 retention target.
- D7 retention target.
- ARPDAU target.
- payer conversion target.
- ad impressions/session.
- completion-rate threshold.

These should be established after:

- prototype playtests.
- beta.
- soft launch.
- benchmark research if requested.

---

# 175. Proposed Guardrail Philosophy

Even after targets are set:

A change should not be called successful if it improves one metric while materially damaging:

- retention.
- crash rate.
- completion health.
- content quality.
- player frustration.

---

# 176. Level Difficulty Alert Examples

**PROPOSED**

Flag a Level for review if it shows statistically abnormal:

- restart rate.
- Dead-End rate.
- Hint use.
- Out-of-Moves rate.
- completion time.

relative to:

- nearby Levels.
- same Board band.
- same Semantic band.

No hard threshold yet.

---

# 177. Content Alert Examples

Flag Association if:

- wrong-target rate spikes.
- Hint rate significantly exceeds same semantic tier.
- content reports occur.
- completion latency is anomalous.

---

# 178. Economy Alert Examples

Flag if:

- Wallet median rapidly increases.
- large percentage of players hit zero Coins.
- one sink becomes unused.
- reward source unexpectedly doubles.
- duplicate grant rate > expected.

---

# 179. Monetization Alert Examples

Flag if:

- rewarded ad completion collapses.
- purchase validation fails.
- session exits after interstitial spike.
- Remove Ads entitlement mismatch appears.

---

# 180. Solver Alert Examples

Critical:

- accepted board later proven unsolvable.
- Solver/Game Engine replay mismatch.
- Dead-End false positive.
- generation timeout spike.
- Hint illegal move.

These are technical defects, not ordinary KPI fluctuations.

---

# 181. Analytics Decision Register — Confirmed

The analytics system must preserve these **CONFIRMED** realities:

1. Main Journey is Endless.
2. Chapters exist with 50 standard Levels.
3. Every Level may create randomized Attempts.
4. Attempt IDs and Level IDs must be separate.
5. Board and Semantic Difficulty are separate.
6. Solver validates boards.
7. Move Limit is fixed per Level.
8. Hint exists.
9. Undo exists.
10. Dead-End exists.
11. Extra Moves exist.
12. Coins exist.
13. Streak rewards exist.
14. Rewarded Ads exist.
15. Interstitial Ads exist.
16. Remove Ads exists.
17. Coin Pack IAP exists.
18. Anonymous identity exists.
19. Cloud Save exists.
20. Daily Reward/Challenge/Streak are P0 at initial launch (Register v1.1).
21. Content is AI-assisted + human-reviewed.
22. CMS/Admin is required.
23. Content/Level/Difficulty versions matter.

---

# 182. Analytics Decision Register — Proposed / Requires Approval

The following remain **PROPOSED/TBD**:

1. North Star Metric.
2. Activation definition.
3. Event naming convention details.
4. Move telemetry sampling rates.
5. Level Health Score formula.
6. Difficulty Calibration Error method.
7. Player Skill Proxy.
8. KPI ownership model.
9. Review cadence.
10. Soft-launch market strategy.
11. Numeric product KPI targets.
12. Alert thresholds.
13. Experiment platform.
14. Exact dashboard/BI tooling beyond Firebase + BigQuery.
15. Notification attribution window.
16. Cohort definitions.
17. Anomaly detection method.
18. Firebase/GCP analytics cost thresholds for retention review.
19. Exact Firebase quotas/billing budgets.

**CONFIRMED (no longer open):** Firebase Analytics + BigQuery export; Crashlytics; GCP-native serverless observability; 14-month raw retention baseline; Daily systems P0 event coverage.

---

# 183. Recommended Approval Order

Provider/platform baseline is already **CONFIRMED** (Firebase Analytics + BigQuery + Crashlytics + GCP-native logs). Remaining freeze order:

1. Approve P0 event taxonomy details.
2. Approve common event properties.
3. Approve Level/Attempt summary schema.
4. Approve economy transaction analytics.
5. Approve content analytics keys.
6. Approve Solver operational metrics.
7. Approve dashboard structure on BigQuery/BI.
8. Approve privacy/sampling rules.
9. Instrument beta.
10. Validate data quality.
11. Set KPI targets only after real baseline data.
12. Tune Firebase/GCP quotas and billing alerts before PROD.

---

# 184. Recommended MVP Analytics Baseline

**CONFIRMED MVP baseline (Register v1.1):**

- Firebase Analytics + BigQuery export.
- Firebase Crashlytics.
- GCP-native logs/monitoring for Cloud Functions / Cloud Run (not Azure App Insights).
- Stable Player/Level/Attempt/Content IDs.
- Attempt summary for every Attempt.
- Level completion summary.
- Core funnel + Daily P0 events.
- Solver performance metrics.
- Difficulty metadata on every Level/Attempt.
- Wallet transaction reasons.
- Ads/IAP funnel events.
- Content bundle versioning.
- Cloud sync reliability metrics.
- Detailed Move telemetry only in beta/sample if cost is high.
- No arbitrary product KPI targets before real data.
- Firebase quotas/billing budgets remain operational **TBD**.

---

# 185. Dependencies

This Analytics & KPI Specification feeds:

1. **API Specification**
2. **QA & Automated Validation Strategy**
3. **CMS Specification**
4. **Cloud Save & Sync Specification**
5. **Game Economy balancing**
6. **Difficulty calibration**
7. **Content Production Plan**
8. **LiveOps/Remote Config**
9. **MVP Product Backlog / WBS**
10. **Launch Readiness Checklist**

---

# 186. Baseline Status

This document is **Analytics & KPI Specification v1.0** — **Decision-Aligned** to **Final Decision Register v1.1** (Firebase-first).

It defines the event model, KPI families, gameplay analytics, difficulty/content/economy/monetization measurement, dashboards, operational alerts, and data-quality requirements for the game.

Firebase Analytics + BigQuery, Crashlytics, GCP-native observability, and the 14-month raw retention baseline are **CONFIRMED**. Numeric product KPI targets, experiment frameworks, sampling rates, and Firebase/GCP billing/quota tuning remain **TBD**.

**End of Analytics & KPI Specification v1.0**
