# Data Model
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned  
**Source Documents:** Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 + Screen Inventory & User Flows v1.0 + Content Design System v1.0 + Arabic Content Guidelines v1.0 + Level Design Framework v1.0 + Difficulty Model v1.0 + Solver Specification v1.0 + Game Engine Technical Design v1.0 + Final Decision Register v1.1  
**Important:** Register-approved items are **APPROVED/CONFIRMED**. Intentional TBD remains for Stock persistence representation, ID types, exact DR RPO/RTO, and exact rescue transform. Other schemas and persistence mechanics stay **PROPOSED/TBD** until explicitly approved.

---

# 1. Purpose

This document defines the conceptual and logical Data Model for the Arabic Solitaire Association game.

It covers data required for:

- Runtime gameplay.
- Main Journey.
- Chapters.
- Level definitions.
- Randomized Attempts.
- Content Library.
- Arabic clues and Members.
- Association relationships.
- Solver.
- Difficulty metrics.
- Player progression.
- Coins and Hint balances.
- Ads/IAP entitlements.
- Cloud Save.
- Daily systems.
- Notifications.
- Analytics.
- CMS/Admin.
- Versioning.
- QA/Simulation.
- Future Events, Packs, Achievements, Collections, Badges, Cosmetics, and Leaderboards.

This document defines **what data exists and how it relates**.

**CONFIRMED** conceptually:

- Local database: Drift / SQLite.
- Primary cloud store (MVP): **Cloud Firestore** documents for suitable
  player/progression/Daily/sync/config and lightweight operational data.
- Remote content bundles/assets: **Firebase Storage**.
- Sensitive/server-authoritative mutations: **Cloud Functions and/or
  Cloud Run** (wallet, IAP validation, Daily eligibility, Admin
  privileged ops, anti-abuse).
- Always-on relational DB / PostgreSQL / ASP.NET Core: **DEFERRED**
  (Register §13); Azure-heavy primary-DB baseline is **SUPERSEDED**
  (§13A).
- Exact Firestore document shapes and any future relational schemas
  remain design work.

---

# 2. Data Modeling Principles

The Data Model should follow these principles:

1. Stable IDs over display text.
2. Explicit versioning.
3. Separation of content from runtime state.
4. Separation of player state from product configuration.
5. Idempotent economy transactions.
6. Replay/debug reproducibility where practical.
7. Arabic display text stored independently from semantic IDs.
8. Solver-readable state without UI dependencies.
9. Backward-compatible schema evolution where practical.
10. Remote configuration values separated from hard-coded gameplay rules.
11. No personally identifying information required for anonymous gameplay.
12. Auditability for content and economy changes.

---

# 3. High-Level Data Domains

The full data model is divided into:

1. **Identity Domain**
2. **Player Profile Domain**
3. **Journey & Progression Domain**
4. **Content Domain**
5. **Level Design Domain**
6. **Attempt & Runtime Domain**
7. **Solver & Difficulty Domain**
8. **Economy Domain**
9. **Monetization Domain**
10. **Daily Engagement Domain**
11. **Notification Domain**
12. **Analytics Domain**
13. **CMS/Admin Domain**
14. **Configuration Domain**
15. **QA/Simulation Domain**
16. **Future Meta-Progression Domain**

---

# 4. ID Strategy

**PROPOSED**

Every persistent entity should use a stable opaque ID.

Examples:

- `player_id`
- `content_id`
- `association_id`
- `member_id`
- `level_id`
- `attempt_id`
- `transaction_id`

IDs must not depend on:

- Arabic display text.
- Level number.
- Sort position.
- User-visible labels.

Recommended implementation:

- UUID/ULID or equivalent stable identifier.

Exact ID type remains TBD.

---

# 5. Version Strategy

Entities/configurations that can evolve should support versioning.

Examples:

- `rules_version`
- `engine_schema_version`
- `solver_version`
- `difficulty_model_version`
- `content_version`
- `level_config_version`
- `economy_config_version`

Historical analytics must remain interpretable after version changes.

---

# 6. Identity Domain Overview

The game supports:

**CONFIRMED**

- Anonymous first-use identity.
- Optional Apple linking.
- Optional Google linking.
- No mandatory registration.

Primary entities:

- PlayerIdentity
- LinkedIdentity
- DeviceRegistration
- PlayerProfile

---

# 7. PlayerIdentity Entity

**PROPOSED**

Fields:

- `player_id`
- `identity_type`
- `created_at`
- `status`
- `last_active_at`
- `primary_locale`
- `country_code?`
- `cloud_sync_enabled`
- `created_app_version`

`identity_type` may begin as:

- ANONYMOUS
- LINKED

---

# 8. LinkedIdentity Entity

Represents external sign-in link.

Potential fields:

- `linked_identity_id`
- `player_id`
- `provider`
- `provider_subject_id`
- `linked_at`
- `status`

Providers:

- APPLE
- GOOGLE

Do not store unnecessary provider profile data.

---

# 9. DeviceRegistration Entity

**PROPOSED**

Fields:

- `device_registration_id`
- `player_id`
- `platform`
- `app_version`
- `os_version`
- `device_locale`
- `push_token?`
- `notifications_enabled`
- `last_seen_at`

Use only data required for product operation.

---

# 10. PlayerProfile Entity

Fields may include:

- `player_id`
- `display_name?`
- `created_at`
- `current_journey_level`
- `current_chapter`
- `player_level?`
- `xp?`
- `selected_theme_id?`
- `selected_badge_id?`

MVP may keep profile minimal.

---

# 11. Anonymous Account Lifecycle

**CONFIRMED concept**

On first launch:

1. Generate/obtain anonymous `player_id`.
2. Create local player record.
3. Optionally sync to cloud.
4. Allow later provider linking.

Linking should preserve current progress.

---

# 12. Account Linking Data Rule

When anonymous profile links to Apple/Google:

- Preserve existing `player_id` where possible.
- Attach provider identity to the same `player_id`.
- Do not create a new progression identity unless merge rules require it.

**CONFIRMED** conflict policy:

- If provider is already linked elsewhere, use explicit conflict flow; no automatic merge.

---

# 13. Journey Domain Overview

Core entities:

- JourneyProgress
- ChapterDefinition
- ChapterProgress
- LevelDefinition
- LevelProgress

---

# 14. JourneyProgress Entity

**CONFIRMED product data**

Fields:

- `player_id`
- `current_level_number`
- `current_level_id`
- `current_chapter_id`
- `highest_completed_level_number`
- `updated_at`

Future optional:

- total levels completed
- total chapters completed

---

# 15. ChapterDefinition Entity

**CONFIRMED**

Standard chapter size = 50 Levels.

Suggested fields:

- `chapter_id`
- `chapter_number`
- `start_level_number`
- `end_level_number`
- `chapter_type`
- `active`
- `version`

Special chapters may have non-standard size later.

---

# 16. ChapterProgress Entity

Potential fields:

- `player_id`
- `chapter_id`
- `completed_level_count`
- `status`
- `started_at`
- `completed_at?`

Status:

- LOCKED
- ACTIVE
- COMPLETED

Exact state names are proposed.

---

# 17. LevelDefinition Entity

A Level is not a fixed board.

**CONFIRMED concept**

Suggested fields:

- `level_id`
- `journey_level_number`
- `chapter_id`
- `level_type`
- `level_config_id`
- `content_selection_policy_id`
- `move_limit`
- `board_difficulty_target`
- `semantic_difficulty_target`
- `active`
- `version`
- `published_at`

---

# 18. LevelProgress Entity

Potential fields:

- `player_id`
- `level_id`
- `status`
- `first_started_at`
- `completed_at?`
- `attempt_count`
- `best_remaining_moves?`
- `best_move_count?`
- `last_attempt_id?`

Core required:

- current/completed status.

Optional mastery fields may be added later.

---

# 19. Level Status

**PROPOSED**

Possible values:

- LOCKED
- AVAILABLE
- IN_PROGRESS
- COMPLETED

Avoid storing derived state if it can be computed cheaply, unless useful operationally.

---

# 20. Content Domain Overview

Primary entities:

- ContentItem
- AssociationDefinition
- AssociationClue
- RelationDefinition
- MemberDefinition
- AssociationMemberLink
- AssociationVariant
- ContentAlias
- ContentReview
- ContentVersion
- ContentTag

---

# 21. AssociationDefinition Entity

Represents one reusable semantic relation.

Suggested fields:

- `association_id`
- `full_relation`
- `primary_clue_id`
- `content_type`
- `relation_type`
- `semantic_difficulty`
- `topic`
- `evergreen_classification`
- `dialect_scope`
- `status`
- `version`
- `created_at`
- `updated_at`

---

# 22. AssociationClue Entity

**CONFIRMED concept**

Separate concise visible clue from full relation.

Fields:

- `clue_id`
- `association_id`
- `display_text`
- `language`
- `script`
- `is_primary`
- `difficulty_modifier?`
- `status`
- `version`

Same visible clue text may appear for different Associations.

---

# 23. RelationDefinition Entity

Optional normalized entity if relation metadata becomes complex.

Potential fields:

- `relation_id`
- `association_id`
- `full_relation`
- `relation_type`
- `relation_complexity`
- `editorial_notes`

Could be merged into AssociationDefinition in MVP.

This separation is **PROPOSED**.

---

# 24. MemberDefinition Entity

Suggested fields:

- `member_id`
- `canonical_display_value`
- `content_type`
- `language`
- `asset_id?`
- `familiarity_score?`
- `region_scope`
- `evergreen_classification`
- `status`
- `version`

For non-text cards:

- canonical semantic name remains stored internally.

---

# 25. AssociationMemberLink Entity

Many-to-many global relationship.

**CONFIRMED**

The same Member concept may belong to multiple Associations globally.

Fields:

- `association_id`
- `member_id`
- `membership_status`
- `member_difficulty`
- `review_notes`
- `approved_at`

For any specific Level card instance, one target Association is selected.

---

# 26. AssociationVariant Entity

Represents a curated/selected subset of Members.

Fields:

- `association_variant_id`
- `association_id`
- `group_size`
- `semantic_difficulty`
- `status`
- `version`

Variant members:

- stored via AssociationVariantMember.

---

# 27. AssociationVariantMember Entity

Fields:

- `association_variant_id`
- `member_id`
- `position?`
- `difficulty_override?`

Position is not gameplay ordering; it may exist only for editorial tooling.

---

# 28. ContentAlias Entity

**PROPOSED**

Fields:

- `alias_id`
- `entity_type`
- `entity_id`
- `alias_text`
- `language`
- `region`
- `alias_type`

Alias types:

- spelling variant
- transliteration
- original-language name
- dialect form

---

# 29. ContentType Enumeration

**CONFIRMED**

Values:

- TEXT
- NUMBER
- SYMBOL
- EMOJI
- ILLUSTRATION

Association Card remains TEXT regardless of Member content type.

---

# 30. RelationType Enumeration

**PROPOSED**

Possible values:

- SEMANTIC_CATEGORY
- SHARED_PROPERTY
- CONTEXT
- GEOGRAPHY
- LANGUAGE_PATTERN
- PREFIX
- SUFFIX
- COMMON_PHRASE
- SYNONYM
- ANTONYM
- ROOT_WORD_FAMILY
- SINGULAR_PLURAL
- NUMERIC
- SYMBOLIC
- VISUAL
- CULTURAL
- HISTORICAL
- SCIENTIFIC
- WORDPLAY

Final taxonomy requires approval.

---

# 31. Semantic Difficulty Metadata

**PROPOSED**

Fields may include:

- `semantic_band`
- `semantic_score`
- `clue_directness`
- `member_familiarity_avg`
- `member_familiarity_max`
- `relation_complexity`
- `knowledge_level`
- `ambiguity_score`
- `linguistic_complexity`
- `regional_comprehensibility`

Exact fields depend on Difficulty Model approval.

---

# 32. Ambiguity Metadata

Suggested fields:

- `ambiguity_allowed`
- `ambiguity_level`
- `ambiguity_type`
- `competing_association_ids?`
- `editorial_notes`

Main Journey early content should not use intentional ambiguity.

---

# 33. Dialect Metadata

Suggested fields:

- `dialect_family`
- `country_code?`
- `region_code?`
- `msa_equivalent?`
- `cross_region_comprehensibility`
- `regional_reviewer_id?`

---

# 34. Evergreen Classification

**PROPOSED**

Values:

- EVERGREEN
- SEMI_EVERGREEN
- CONTEMPORARY
- SEASONAL

Main Journey should primarily select EVERGREEN content.

---

# 35. Content Status Lifecycle

**PROPOSED**

Possible values:

- DRAFT
- NEEDS_REVIEW
- LANGUAGE_APPROVED
- SEMANTIC_APPROVED
- GAME_APPROVED
- PRODUCTION_APPROVED
- ACTIVE
- DISABLED
- DEPRECATED
- ARCHIVED

MVP may simplify these states.

---

# 36. ContentReview Entity

Fields:

- `review_id`
- `entity_type`
- `entity_id`
- `review_type`
- `reviewer_id`
- `status`
- `notes`
- `created_at`

Review types:

- LANGUAGE
- SEMANTIC
- DUPLICATE
- DIFFICULTY
- CULTURAL
- VISUAL
- FINAL

---

# 37. ContentTag Entity

Potential tags:

- topic
- region
- relation family
- advanced linguistic
- tutorial-safe
- event-only
- pack-only
- visual-ready

A flexible tag system is **PROPOSED**.

---

# 38. Content Versioning

A published Association/Member/Variant edit should create a new version or auditable revision.

Fields:

- `version`
- `previous_version_id?`
- `change_reason`
- `published_at`
- `published_by`

---

# 39. Asset Domain

For Illustration content:

- Asset
- AssetVersion
- AssetMetadata

---

# 40. Asset Entity

Potential fields:

- `asset_id`
- `asset_type`
- `storage_reference`
- `content_hash`
- `width`
- `height`
- `status`
- `version`

Do not store image binary inside gameplay relational records.

---

# 41. AssetMetadata

Potential:

- canonical concept name
- alt/internal description
- content owner/license metadata
- generation source
- review status

---

# 42. Level Design Domain Overview

Entities:

- LevelConfiguration
- LevelTemplate
- GroupSizeProfile
- TableauProfile
- ContentSelectionPolicy
- SolverAcceptanceProfile
- DifficultyProfile

---

# 43. LevelConfiguration Entity

Suggested fields:

- `level_config_id`
- `level_id`
- `association_count`
- `group_size_profile_id`
- `tableau_column_count`
- `tableau_profile_id`
- `stock_size`
- `association_slot_count`
- `move_limit`
- `board_difficulty_profile_id`
- `semantic_difficulty_profile_id`
- `content_selection_policy_id`
- `solver_acceptance_profile_id`
- `rules_version`
- `version`
- `active`

---

# 44. LevelTemplate Entity

**PROPOSED**

Reusable structural template.

Fields:

- `level_template_id`
- `name`
- `association_count`
- `group_size_profile`
- `tableau_profile`
- `stock_profile`
- `slot_profile`
- `expected_board_band`
- `status`
- `version`

LevelDefinition may reference template + overrides.

---

# 45. GroupSizeProfile Entity

Potential fields:

- `group_size_profile_id`
- `profile_type`
- `allowed_group_sizes`
- `group_size_distribution`
- `fixed_group_sizes?`

Examples:

- G3
- G4
- G34
- G45
- G345

Labels are proposed.

---

# 46. TableauProfile Entity

Fields:

- `tableau_profile_id`
- `column_count`
- `column_sizes`
- `profile_type`
- `max_depth`
- `min_depth`

Can represent:

- balanced
- asymmetric
- deep-center
- etc.

Profile taxonomy is proposed.

---

# 47. ContentSelectionPolicy Entity

Fields may include:

- `content_selection_policy_id`
- `allowed_content_types`
- `allowed_relation_types`
- `topic_weights`
- `semantic_min`
- `semantic_max`
- `ambiguity_max`
- `dialect_scope`
- `evergreen_requirement`
- `reuse_cooldown`
- `variant_policy`

---

# 48. SolverAcceptanceProfile Entity

Suggested fields:

- `solver_acceptance_profile_id`
- `board_score_min`
- `board_score_max`
- `max_generation_attempts`
- `max_required_restores`
- `max_completion_delay`
- `timeout_policy_id`
- `quality_thresholds`

Exact numeric fields remain TBD.

---

# 49. DifficultyProfile Entity

Fields:

- `difficulty_profile_id`
- `board_band`
- `semantic_band`
- `board_target_score?`
- `semantic_target_score?`
- `profile_name?`
- `difficulty_model_version`

---

# 50. Attempt Domain Overview

Primary entities:

- GameAttempt
- AttemptAssociation
- AttemptCard
- AttemptTableauColumn
- AttemptStack
- AttemptStock
- AttemptAssociationSlot
- AttemptAction
- AttemptSnapshot

---

# 51. GameAttempt Entity

Represents one randomized playable instance.

Fields:

- `attempt_id`
- `player_id`
- `level_id`
- `level_config_version`
- `attempt_number`
- `attempt_type`
- `status`
- `move_limit`
- `moves_remaining`
- `random_seed?`
- `created_at`
- `started_at`
- `ended_at?`
- `solver_validation_id`
- `state_revision`
- `rules_version`
- `engine_version`

---

# 52. Attempt Type

**PROPOSED**

Values:

- MAIN_JOURNEY
- TUTORIAL
- DAILY_CHALLENGE
- EVENT
- PACK

---

# 53. Attempt Status

Suggested values:

- GENERATED
- READY
- ACTIVE
- PAUSED
- DEAD_END
- OUT_OF_MOVES
- WON
- FAILED
- RESTARTED
- ABANDONED
- INVALID

Exact lifecycle names may differ from runtime engine state.

---

# 54. AttemptAssociation Entity

Binds one content Association to the Attempt.

Fields:

- `attempt_association_id`
- `attempt_id`
- `association_id`
- `association_variant_id`
- `target_group_size`
- `content_type`
- `clue_snapshot`
- `semantic_score_snapshot`

Snapshot fields preserve historical reproduction even if content later changes.

---

# 55. Content Snapshot Principle

**PROPOSED**

For active/persisted Attempts, store enough content/version references to reproduce the board even if source content changes later.

Options:

- Store immutable content version IDs.
- Or snapshot critical display fields.

Preferred architecture should avoid duplicating large content unnecessarily.

---

# 56. AttemptCard Entity

Fields:

- `attempt_card_id`
- `attempt_id`
- `base_member_id?`
- `association_id`
- `card_kind`
- `content_snapshot_id?`
- `runtime_status`

`card_kind`:

- ASSOCIATION
- MEMBER

---

# 57. AttemptTableauColumn Entity

Fields:

- `attempt_id`
- `column_id`
- `column_index`
- `hidden_card_ids`
- `exposed_unit_id?`

For persisted runtime state, ordered hidden sequence is required.

---

# 58. AttemptStack Entity

Fields:

- `stack_id`
- `attempt_id`
- `association_id`
- `member_card_ids`
- `association_card_id?`
- `contains_association_card`
- `location_type`
- `location_id`

Internal member order is not required for rule logic.

---

# 59. AttemptStock Entity

Must preserve exact future Stock behavior.

Potential fields:

- `attempt_id`
- `ordered_card_ids`
- `current_index`
- `exposed_card_ids`
- `playable_card_id?`
- `restore_count`
- `cycle_state`

Exact representation is TBD and must match final Stock engine semantics.

---

# 60. AttemptAssociationSlot Entity

Fields:

- `attempt_id`
- `slot_id`
- `slot_index`
- `active_association_id?`
- `association_card_id?`
- `member_card_ids`
- `required_member_count`

Empty Slot has null active Association.

---

# 61. CompletedAssociation Record

Potential fields:

- `attempt_id`
- `association_id`
- `completed_at_move`
- `completed_at`
- `member_count`

May be stored in runtime history/analytics rather than core persisted state.

---

# 62. AttemptAction Entity

**PROPOSED**

For replay/debugging.

Fields:

- `action_id`
- `attempt_id`
- `sequence_number`
- `action_type`
- `source_type`
- `source_id`
- `target_type`
- `target_id`
- `movable_unit_id`
- `move_cost`
- `state_revision_before`
- `state_revision_after`
- `created_at`

Not all actions need long-term server persistence in MVP.

---

# 63. AttemptSnapshot Entity

Potential fields:

- `snapshot_id`
- `attempt_id`
- `state_revision`
- `serialized_state`
- `schema_version`
- `created_at`

Used for:

- local save
- crash recovery
- debugging
- cloud sync where appropriate

---

# 64. Undo Data

Undo requires only one prior eligible snapshot.

Potential runtime fields:

- `undo_available`
- `undo_snapshot`
- `last_action_was_undo`
- `last_action_caused_completion`

Persistence policy remains TBD.

---

# 65. Streak Runtime Data

Fields:

- `current_streak_count`
- `streak_tier_requirement`
- `streak_coins_earned`

**CONFIRMED**

Tier requirements progress 3→4→5 and remain 5 thereafter.

---

# 66. Runtime Reward Breakdown

On Level Win, Engine produces:

- `base_reward = 50`
- `remaining_move_reward = remaining_moves × 2`
- `streak_reward`
- `total_level_reward`

These are gameplay outputs, not Wallet balance fields.

---

# 67. Solver Domain Overview

Entities/records:

- SolverValidation
- SolverSolution
- SolverMetric
- SolverRejection
- SolverRun

---

# 68. SolverRun Entity

Suggested fields:

- `solver_run_id`
- `attempt_id`
- `solver_version`
- `rules_version`
- `mode`
- `started_at`
- `duration_ms`
- `result`
- `termination_reason`
- `states_explored`
- `branches_explored`

---

# 69. SolverValidation Entity

Fields:

- `solver_validation_id`
- `attempt_id`
- `solvable`
- `within_move_limit`
- `reference_move_count`
- `minimum_move_count?`
- `optimality_proven`
- `confidence`
- `validated_at`

---

# 70. SolverSolution Entity

Potential fields:

- `solver_solution_id`
- `solver_validation_id`
- `solution_length`
- `encoded_actions`
- `solution_hash`
- `is_reference`
- `is_minimum_proven`

Full solution may not require permanent storage for every production Attempt.

---

# 71. Solver Rejection Entity

Fields:

- `solver_run_id`
- `rejection_reason`
- `details`
- `board_score?`
- `required_moves?`

Potential reasons:

- UNSOLVABLE
- MOVE_LIMIT_EXCEEDED
- TOO_EASY
- TOO_HARD
- TIMEOUT
- QUALITY_REJECT

Exact enum remains proposed.

---

# 72. Difficulty Metric Data

Per Attempt fields may include:

- `board_score`
- `semantic_score`
- `move_slack`
- `move_slack_ratio`
- `slot_pressure`
- `stock_ratio`
- `required_stock_advances`
- `required_restores`
- `initial_valid_move_count`
- `safe_branch_ratio`
- `dead_end_branch_count`
- `forced_state_ratio`
- `moves_to_first_completion`

Exact metric set depends on final Difficulty Model.

---

# 73. Difficulty Metric Versioning

Store:

- `difficulty_model_version`

with calculated scores.

Historical attempts must not be silently rescored without version context.

---

# 74. Economy Domain Overview

Entities:

- Wallet
- WalletTransaction
- HintBalance
- UtilityPurchase
- RewardGrant
- EconomyConfig

---

# 75. Wallet Entity

**CONFIRMED**

Coins are the primary soft currency.

Fields:

- `player_id`
- `coin_balance`
- `updated_at`
- `version`

Recommend deriving balance from ledger + cached current balance where practical.

---

# 76. WalletTransaction Entity

**PROPOSED**

Append-only ledger.

Fields:

- `transaction_id`
- `player_id`
- `currency_type`
- `amount`
- `direction`
- `reason`
- `source_reference`
- `balance_before`
- `balance_after`
- `created_at`
- `idempotency_key`

---

# 77. Currency Type

Current approved soft currency:

- COIN

No premium currency is approved.

Design should not assume Gems.

---

# 78. Wallet Transaction Reasons

Potential values:

- LEVEL_BASE_REWARD
- REMAINING_MOVES_REWARD
- STREAK_REWARD
- DAILY_REWARD
- DAILY_CHALLENGE_REWARD
- REWARDED_AD
- COIN_PACK_PURCHASE
- HINT_PURCHASE
- EXTRA_MOVES_PURCHASE
- DEAD_END_RESCUE
- COSMETIC_PURCHASE

`RESHUFFLE` is **out of MVP** (no separate Mid-Level Reshuffle). Cosmetics are **DEFERRED Post-MVP**.

---

# 79. Idempotency

Every economy grant/spend triggered by asynchronous or external systems should use a unique idempotency key.

Protects against:

- duplicate ad callbacks
- purchase retries
- cloud retries
- duplicate win events

---

# 80. HintBalance Entity

Fields:

- `player_id`
- `hint_balance`
- `updated_at`

Hint resource is distinct from Coins.

---

# 81. HintTransaction

Optional ledger:

- `hint_transaction_id`
- `player_id`
- `amount`
- `reason`
- `source_reference`
- `balance_before`
- `balance_after`
- `idempotency_key`

---

# 82. UtilityPurchase Entity

Records Coin-funded utility.

Fields:

- `utility_purchase_id`
- `player_id`
- `attempt_id?`
- `utility_type`
- `coin_cost`
- `granted_amount`
- `created_at`
- `idempotency_key`

---

# 83. Utility Types

**CONFIRMED** MVP utilities:

- HINT
- EXTRA_MOVES
- DEAD_END_RESCUE

`RESHUFFLE` is **out of MVP** (no separate Mid-Level Reshuffle). Cosmetics later (**DEFERRED Post-MVP**).

---

# 84. RewardGrant Entity

Generic reward record.

Fields:

- `reward_grant_id`
- `player_id`
- `reward_type`
- `amount`
- `source_type`
- `source_id`
- `granted_at`
- `idempotency_key`

---

# 85. EconomyConfig Entity

**CONFIRMED** register values (configurable, versioned):

- starting_coins = 300
- starting_hints = 3
- hint_coin_cost = 75
- extra_moves_amount = 5
- extra_moves_costs = [150, 250] (max 2 per Attempt)
- rescue_cost = 200 (max 1 per Attempt)
- rewarded_ad_coin_grant = 100; cap 3/day
- daily_reward_values = Day1 100c, Day2 125c, Day3 150c, Day4 1 Hint, Day5 175c, Day6 200c, Day7 300c + 1 Hint
- daily_streak_milestones = 3→100c, 7→250c, 14→400c, 30→750c
- daily_challenge_reward = 150 Coins
- chapter_completion_reward = 500 Coins + 2 Hints
- level_base_reward = 50; remaining_moves = 2 Coins each
- streak coins = 3→+3, 4→+4, 5-tier→+5 thereafter

No `reshuffle_cost` in MVP.

---

# 86. Monetization Domain Overview

Entities:

- StoreProduct
- PurchaseTransaction
- PlayerEntitlement
- RewardedAdGrant
- AdExposure

---

# 87. StoreProduct Entity

Fields:

- `store_product_id`
- `product_type`
- `platform_product_id`
- `platform`
- `active`
- `coin_amount?`
- `entitlement_type?`
- `sort_order`

Product types:

- REMOVE_ADS
- COIN_PACK

---

# 88. PurchaseTransaction Entity

Fields:

- `purchase_transaction_id`
- `player_id`
- `store_product_id`
- `platform`
- `platform_transaction_id`
- `purchase_status`
- `purchased_at`
- `validated_at?`
- `grant_status`
- `idempotency_key`

---

# 89. Purchase Status

**PROPOSED**

- PENDING
- VALIDATED
- FAILED
- CANCELLED
- REFUNDED
- REVOKED

Final mapping must match Apple/Google lifecycle.

---

# 90. PlayerEntitlement Entity

For Remove Ads.

Fields:

- `player_id`
- `entitlement_type`
- `status`
- `granted_at`
- `source_purchase_id`
- `expires_at?`

Remove Ads expected to be non-expiring unless product changes.

---

# 91. RewardedAdGrant Entity

Fields:

- `rewarded_ad_grant_id`
- `player_id`
- `placement`
- `reward_type`
- `reward_amount`
- `attempt_id?`
- `ad_network_reference?`
- `granted_at`
- `idempotency_key`

---

# 92. Ad Placement Types

Examples:

- HINT
- EXTRA_MOVES
- DEAD_END_RESCUE
- COINS

---

# 93. AdExposure Entity

Potential analytics record:

- `player_id`
- `ad_type`
- `placement`
- `attempt_id?`
- `shown_at`
- `completed`
- `reward_granted`

May live only in analytics rather than transactional DB.

---

# 94. Cloud Save Domain

Potential entities:

- CloudSaveState
- CloudSyncRevision
- SyncConflict

---

# 95. CloudSaveState Entity

Suggested persistent player state:

- player_id
- journey progress
- wallet balances
- hint balance
- entitlements
- daily state
- settings
- future meta progression

**CONFIRMED:** Active Attempt persistence is local-first / device-specific; not durable cloud board state.

---

# 96. Cloud Revision

**PROPOSED**

Fields:

- `player_id`
- `revision`
- `updated_at`
- `device_registration_id`
- `state_hash`

Useful for conflict detection.

---

# 97. SyncConflict Entity

Potential diagnostics:

- `conflict_id`
- `player_id`
- `local_revision`
- `remote_revision`
- `detected_at`
- `resolution_type`
- `resolved_at`

May not require permanent storage unless useful operationally.

---

# 98. Progress Merge Rules

**CONFIRMED** domain-specific cloud conflict policy:

- Progression → merge to highest valid progression.
- Wallet → server-authoritative ledger.
- Purchases/Entitlements → store/backend authoritative.
- Settings → latest revision.
- Active Attempt → local/device-specific.

Sensitive values such as Coins, Purchases, and Entitlements must not use naive "take highest local value" logic.

---

# 99. Daily Engagement Domain Overview

Entities:

- DailyRewardCalendar
- DailyRewardState
- DailyStreakState
- DailyChallengeDefinition
- DailyChallengeProgress

---

# 100. DailyRewardCalendar Entity

**CONFIRMED at launch**

Fields:

- `calendar_id`
- `version`
- `day_sequence`
- `active_from`
- `active_to?`

**CONFIRMED** 7-day repeating calendar reward values (see EconomyConfig).

---

# 101. DailyRewardState Entity

**CONFIRMED at launch** (with Daily Reward / Daily Streak / Daily Challenge).

Fields:

- `player_id`
- `calendar_id`
- `current_day_index`
- `last_claimed_date`
- `next_claim_date`
- `claim_count`

**CONFIRMED** missed-day behavior:

- Missing a day does not reset Daily Reward progression.
- Daily Streak breaks after a missed day.

---

# 102. DailyStreakState Entity

**CONFIRMED at launch**

Fields:

- `player_id`
- `current_streak_days`
- `best_streak_days`
- `last_qualifying_date`
- `next_milestone`

**CONFIRMED** milestone rewards:

- 3 days: 100 Coins.
- 7 days: 250 Coins.
- 14 days: 400 Coins.
- 30 days: 750 Coins.

---

# 103. DailyChallengeDefinition Entity

**CONFIRMED at launch**

Fields:

- `daily_challenge_id`
- `challenge_date`
- `level_config_id`
- `association_variant_ids`
- `board_seed`
- `move_limit`
- `reward_config_id`
- `solver_validation_id`
- `status`

**CONFIRMED:**

- Fixed deterministic board per challenge cohort.
- Reward: 150 Coins, auto-granted on first completion.
- Reset: 00:00 validated player-local timezone; backend authoritative for Daily time/eligibility.

---

# 104. DailyChallengeProgress Entity

**CONFIRMED at launch**

Fields:

- `player_id`
- `daily_challenge_id`
- `status`
- `attempt_count`
- `completed_at?`
- `best_moves_used?`
- `reward_claimed`

**CONFIRMED:** unlimited retries during the valid day; reward auto-granted on first completion.

---

# 105. Notification Domain Overview

Entities:

- NotificationPreference
- PushDevice
- NotificationEvent
- NotificationDelivery

---

# 106. NotificationPreference Entity

Fields:

- `player_id`
- `daily_reward_enabled`
- `daily_challenge_enabled`
- `streak_risk_enabled`
- `event_notifications_enabled`
- `new_content_enabled`

**CONFIRMED at launch:** Smart Notification infrastructure included; initially active types are Daily Challenge and Streak Risk. Quiet hours 22:00–09:00 player-local. Richer notification types are **DEFERRED Post-MVP**.

---

# 107. NotificationEvent Entity

Potential fields:

- `notification_event_id`
- `player_id`
- `category`
- `scheduled_for`
- `payload_reference`
- `status`

May be generated dynamically rather than persisted.

---

# 108. Player Settings Domain

Settings fields may include:

- sound_enabled
- music_enabled
- haptics_enabled
- notification preferences
- locale
- analytics/privacy choices

Do not store UI-only temporary preferences unnecessarily on server.

---

# 109. Analytics Domain Overview

Product analytics should be event-based.

Core schema:

- AnalyticsEvent
- EventProperties
- Session
- Attribution metadata if later required

---

# 110. AnalyticsEvent Concept

Each event should contain:

- `event_name`
- `event_timestamp`
- `player_id/anonymous_id`
- `session_id`
- `app_version`
- `platform`
- `level_id?`
- `attempt_id?`
- `event_properties`
- `rules_version?`
- `solver_version?`

Exact implementation depends on analytics platform.

---

# 111. Gameplay Analytics Properties

Useful common fields:

- move number
- moves remaining
- board difficulty
- semantic difficulty
- association count
- group profile
- slot pressure
- stock size
- hint usage
- rescue usage

---

# 112. Content Analytics Keys

Always use stable IDs:

- association_id
- variant_id
- member_id
- relation_type
- content_type
- semantic score

Do not rely only on Arabic text values.

---

# 113. Attempt Analytics Snapshot

At Level Start, record:

- Level ID
- Attempt ID
- Level Config Version
- Solver Version
- Difficulty Model Version
- Board Score
- Semantic Score
- Move Limit
- Reference Moves
- Content IDs

This enables reproducible analysis.

---

# 114. CMS/Admin Domain Overview

Entities:

- AdminUser
- AdminRole
- AdminPermission
- EditorialTask
- Publication
- AuditLog

---

# 115. AdminUser Entity

Fields:

- `admin_user_id`
- `status`
- `display_name`
- `auth_reference`
- `created_at`

Authentication implementation belongs to Backend Architecture.

---

# 116. AdminRole Entity

Potential roles:

- Content Author
- Arabic Reviewer
- Semantic Reviewer
- Game Designer
- Publisher
- Admin

Exact RBAC structure is proposed.

---

# 117. AdminPermission Entity

Potential permissions:

- content.read
- content.write
- content.review
- level.write
- solver.validate
- publish
- deactivate
- economy.config
- analytics.view

---

# 118. EditorialTask Entity

Potential fields:

- `task_id`
- `entity_type`
- `entity_id`
- `review_stage`
- `assigned_to`
- `status`
- `due_at?`
- `created_at`

MVP may use simpler workflow.

---

# 119. Publication Entity

Tracks publish action.

Fields:

- `publication_id`
- `entity_type`
- `entity_id`
- `version`
- `published_by`
- `published_at`
- `environment`

---

# 120. AuditLog Entity

Recommended for:

- Content changes.
- Level config changes.
- Economy config changes.
- Admin permission changes.
- Publication/deactivation.

Fields:

- actor
- action
- entity
- before/after references
- timestamp

**CONFIRMED:** Audit log retention = 2 years.
---

# 121. Configuration Domain Overview

Entities/config groups:

- RemoteConfig
- FeatureFlag
- EconomyConfig
- AdsConfig
- NotificationConfig
- ContentDeliveryConfig

---

# 122. RemoteConfig Entity

Potential structure:

- `config_key`
- `config_value`
- `environment`
- `version`
- `effective_from`
- `updated_by`

Could be delegated to external Remote Config service.

---

# 123. FeatureFlag Entity

Suggested fields:

- `feature_key`
- `enabled`
- `audience`
- `platform`
- `min_app_version`
- `rollout_percentage`
- `version`

Do not use feature flags to silently alter core game rules without Rules versioning.

---

# 124. AdsConfig

Possible fields:

- interstitial_enabled
- min_levels_between
- session_cap
- rewarded_placements_enabled
- cooldowns
- remove_ads_entitlement_behavior

Exact values TBD.

---

# 125. Economy Config Versioning

Every economy parameter set should have a version.

Gameplay analytics should reference config version where relevant.

This allows post-launch balancing analysis.

---

# 126. QA & Simulation Domain Overview

Entities:

- SimulationRun
- SimulationResult
- GoldenBoard
- RegressionCase
- EngineReplay

---

# 127. SimulationRun Entity

Fields:

- `simulation_run_id`
- `level_template_id`
- `level_config_id`
- `solver_version`
- `difficulty_model_version`
- `sample_size`
- `started_at`
- `completed_at`
- `environment`

---

# 128. SimulationResult Entity

Potential metrics:

- generated_count
- accepted_count
- rejected_count
- acceptance_rate
- avg_solver_duration
- p95_solver_duration
- avg_reference_moves
- move_slack_distribution
- restore_distribution
- board_score_distribution
- timeout_count

---

# 129. GoldenBoard Entity

**PROPOSED**

Fields:

- `golden_board_id`
- `name`
- `rules_version`
- `serialized_initial_state`
- `expected_solvable`
- `expected_min_moves?`
- `expected_key_actions`
- `expected_hint?`
- `tags`

Used for Solver/Engine regression.

---

# 130. RegressionCase Entity

Fields:

- `regression_case_id`
- `case_type`
- `input_state`
- `expected_result`
- `created_from_bug_id?`
- `rules_version`

---

# 131. EngineReplay Entity

Potential fields:

- `replay_id`
- `attempt_id`
- `initial_state`
- `action_sequence`
- `final_state_hash`
- `result`
- `engine_version`

May be test/debug only.

---

# 132. Future Meta-Progression Domain

**DEFERRED Post-MVP** systems (modelable without forcing MVP implementation):

- Player XP/Level
- Achievements
- Badges
- Collections
- Cosmetics
- Events
- Packs
- Leaderboards
- Mid-Level Reshuffle

---

# 133. PlayerXP Entity

Potential fields:

- `player_id`
- `xp`
- `player_level`
- `updated_at`

Exact XP formula is TBD.

---

# 134. AchievementDefinition Entity

Fields:

- achievement_id
- achievement_type
- target
- reward_config_id
- active
- version

---

# 135. PlayerAchievement Entity

Fields:

- player_id
- achievement_id
- progress
- status
- completed_at
- reward_claimed

---

# 136. BadgeDefinition / PlayerBadge

Potential:

BadgeDefinition:
- badge_id
- name
- source_type
- rarity?
- asset_id

PlayerBadge:
- player_id
- badge_id
- earned_at
- selected

---

# 137. CollectionDefinition / PlayerCollection

Potential:

CollectionDefinition:
- collection_id
- theme
- item definitions
- reward

PlayerCollection:
- player_id
- collection_id
- owned_item_ids
- completion_percent

Exact collectible model TBD.

---

# 138. CosmeticDefinition Entity

Fields:

- cosmetic_id
- cosmetic_type
- asset_reference
- coin_price?
- unlock_condition?
- status

No gameplay power.

---

# 139. PlayerCosmetic Entity

Fields:

- player_id
- cosmetic_id
- acquired_at
- acquisition_source
- equipped

---

# 140. EventDefinition Entity

Potential fields:

- event_id
- title
- start_at
- end_at
- content_policy
- reward_config
- status
- version

---

# 141. EventProgress Entity

Fields:

- player_id
- event_id
- progress
- milestones_claimed
- completed_at?

---

# 142. PackDefinition Entity

Fields:

- pack_id
- pack_type
- dialect_scope
- content_scope
- unlock_policy
- level_count
- status

---

# 143. PackProgress Entity

Fields:

- player_id
- pack_id
- current_level
- completed_levels
- completed_at?

---

# 144. LeaderboardDefinition Entity

Potential fields:

- leaderboard_id
- leaderboard_type
- scoring_rule
- period
- reset_policy
- status

Scoring logic remains TBD.

---

# 145. LeaderboardEntry Entity

Fields:

- leaderboard_id
- player_id
- score
- rank
- updated_at

Server-authoritative validation likely required for competitive integrity.

---

# 146. Entity Relationship Summary

Core relationships:

- Player → JourneyProgress
- Player → Wallet
- Player → HintBalance
- Player → LevelProgress
- Player → GameAttempts
- Chapter → Levels
- Level → LevelConfiguration
- Level → ContentSelectionPolicy
- Attempt → AttemptAssociations
- AttemptAssociation → AssociationDefinition/Variant
- AssociationDefinition ↔ MemberDefinition through AssociationMemberLink
- Attempt → AttemptCards
- Attempt → SolverValidation
- Player → Purchases/Entitlements
- Player → DailyState
- Content/Admin → AuditLog

---

# 147. Data Ownership Boundaries

**CONFIRMED** conceptually (aligned with Drift/SQLite local + Cloud Firestore cloud docs; relational DB deferred):

## Client-Owned / Local First
- Active gameplay Attempt state
- UI settings
- transient caches

## Server/Cloud Authoritative or Reconciled
- purchases
- entitlements
- wallet (server-authoritative ledger via trusted Cloud Functions/Cloud Run)
- cloud progression (highest valid progression merge)
- daily claims (backend authoritative for time/eligibility)
- CMS content/config (via approved security boundaries into Firebase/GCP)
- settings (latest revision)

Active Attempt remains local/device-specific. Cloud sync must minimize Firestore reads/writes and avoid per-Move cloud traffic.

---

# 148. Local Persistence Boundary

Local storage likely needs:

- anonymous identity token/reference
- cached profile
- Journey progress
- Wallet display cache
- Hint balance cache
- active Attempt snapshot
- content/config cache
- settings
- entitlements cache

Do not assume local cache is authoritative for paid values.

---

# 149. Cloud Persistence Boundary

Cloud likely stores:

- Player identity
- linked providers
- Journey progress
- Wallet
- Hint balance
- entitlements
- daily state
- future meta progression
- optionally active-session backup

Final scope depends on Backend Architecture.

---

# 150. Static/Bundled Data

Likely bundled or cacheable:

- base content
- UI localization
- tutorial config
- fallback Level configurations
- core rules metadata

**CONFIRMED** hybrid content delivery:

- bundled base content
- remote versioned content bundles hosted via **Firebase Storage** (or
  another Firebase/GCP-native static delivery mechanism when justified)
- no separate paid CDN layer for MVP unless measurements demonstrate a need

---

# 151. Content Delivery Strategy

**CONFIRMED**

Hybrid model:

- essential launch content bundled
- remotely updateable versioned content bundles
- download → validate hash → validate schema → validate rules compatibility → atomic activation
- keep last-known-valid bundle for rollback
- versioned cache on device

Benefits:

- startup resilience
- live content correction
- lower dependence on app releases

---

# 152. Data Normalization

CMS/editorial tooling may use normalized structures internally, but the
MVP cloud primary store is document-oriented (**Firestore**). A
dedicated always-on relational database is **DEFERRED** unless
Firebase-first proves insufficient.

Runtime client should use efficient denormalized/read-optimized models
(Drift/SQLite).

Do not force mobile runtime to join complex editorial tables.

---

# 153. Read Models

**PROPOSED**

Create compact read models for:

- playable Level
- content bundle
- player profile
- shop products
- daily state

These can be generated from normalized backend entities.

---

# 154. Immutable Published Content

**PROPOSED**

Once a published content version is used in production, edits should create a new version rather than mutate history in-place.

This protects:

- analytics
- saved attempts
- debugging
- reproducibility

---

# 155. Soft Delete vs Hard Delete

Recommended:

- Soft-disable published content.
- Hard-delete only unpublished drafts or legally required data.

Historical gameplay references should remain resolvable.

---

# 156. Indexing — Content

Potential indexes:

- clue normalized text
- member normalized text
- relation type
- semantic difficulty
- topic
- status
- dialect
- evergreen classification

Exact DB indexing depends on chosen technology.

---

# 157. Indexing — Player

Potential indexes:

- player_id
- external provider subject
- current level
- last active
- entitlement status

Avoid unnecessary indexing of low-use fields.

---

# 158. Indexing — Analytics/Operational

Potential:

- attempt_id
- level_id
- solver_version
- rejection_reason
- event timestamp
- player_id

Analytics platform may manage separately.

---

# 159. Time Handling

**CONFIRMED** Daily timezone policy:

- Use UTC timestamps for backend persistence.
- Daily Challenge reset: 00:00 validated player-local timezone.
- Backend is authoritative for Daily time/eligibility.
- Notification quiet hours: 22:00–09:00 player-local time.

---

# 160. Date vs Timestamp

Use date-only fields for:

- Daily Challenge date
- Daily Reward eligibility day

Use timestamps for:

- purchases
- completions
- syncs
- publications
- notifications

---

# 161. Locale Handling

Fields may include:

- UI locale
- content locale
- device locale

Main Journey launch content is Arabic-first.

Do not bind Player identity to one permanent locale.

---

# 162. Arabic Text Storage

Store Unicode text exactly as approved for display.

Do not permanently normalize away:

- Hamza
- diacritics
- Ya/Alif Maqsura distinctions

Use separate normalized search fields if required.

---

# 163. Search Normalized Fields

**PROPOSED**

Could store derived fields:

- `normalized_clue`
- `normalized_member_text`

for CMS search/deduplication.

Display text remains untouched.

---

# 164. Content Hashing

**PROPOSED**

Use content hashes for:

- asset cache
- bundle versioning
- content integrity
- duplicate detection support

---

# 165. Data Integrity Constraints

Examples:

- one Association Card per AttemptAssociation
- Member Card target Association must exist
- no Card may belong to two active locations
- completed Association cannot still exist in Stock/Tableau
- Wallet balance must not go below zero unless explicitly allowed
- Remove Ads entitlement grants must be idempotent

---

# 166. Referential Integrity

Use foreign-key-like integrity where supported.

Examples:

- LevelDefinition → Chapter
- Attempt → Level
- AttemptAssociation → AssociationVariant
- Purchase → StoreProduct
- Review → Content Entity

---

# 167. Transaction Boundaries

Important atomic operations:

- Level Win reward grant
- Coin spend + utility grant
- Purchase validation + entitlement/Coins
- Daily Reward claim
- Daily Challenge reward
- Account linking/merge
- Admin publication

Exact implementation depends on backend.

---

# 168. Level Win Transaction

Recommended logical transaction:

1. Mark Attempt Won.
2. Mark Level complete.
3. Calculate reward.
4. Grant Coins idempotently.
5. Unlock next Level.
6. Update Chapter progress.
7. Persist analytics/event.

Failures should be recoverable without double grants.

---

# 169. Extra Moves Transaction

Logical transaction:

1. Verify Attempt status.
2. Verify payment/ad grant.
3. Deduct Coins if Coin-funded.
4. Grant Moves.
5. Return Attempt to Active.
6. Record transaction.

---

# 170. Hint Transaction

Logical transaction:

1. Verify Hint balance or Coin/ad source.
2. Deduct/grant resource as applicable.
3. Request Solver Hint.
4. Persist resource transaction.
5. Show Hint.

Failure policy if Solver cannot produce a Hint requires careful handling and may require refund.

---

# 171. Purchase Transaction

Logical:

1. Receive platform transaction.
2. Validate.
3. Check idempotency.
4. Grant entitlement/Coins.
5. Persist receipt reference/status.
6. Return success.

---

# 172. Daily Reward Claim Transaction

Logical:

1. Validate date eligibility.
2. Check not already claimed.
3. Determine reward.
4. Grant idempotently.
5. Update calendar/streak state.
6. Persist claim.

---

# 173. Audit Requirements

Audit at least:

- content publish/deactivate
- economy config changes
- entitlement corrections
- manual wallet adjustments
- admin role changes
- level config edits

---

# 174. Privacy Data Minimization

Anonymous play should require minimal personal data.

Avoid storing:

- unnecessary names
- contacts
- precise location
- sensitive demographics

unless a future approved feature requires them.

---

# 175. Account Deletion

Data Model should support account deletion/anonymization according to applicable privacy requirements.

Operational records required for fraud/purchase/legal retention may need separate policy.

Exact retention rules are TBD.

---

# 176. Data Retention

**CONFIRMED** baselines:

- Raw analytics retention baseline: 14 months, then cost review.
- Audit log retention: 2 years.

Other retention classes (guidance):

- core player progression → until account deletion
- purchase/entitlement records → legal/store requirements
- debug snapshots → short-lived
- Solver diagnostics → short-lived/aggregated

Exact analytics cost thresholds that trigger retention-policy review remain intentional **TBD**.

---

# 177. Data Backup

Cloud persistence should support backups for:

- Player progression
- Wallet/entitlements
- Content/CMS
- Level configs
- Economy config

**CONFIRMED:** Cloud data protection uses Firebase/GCP managed backup /
export / restore practices appropriate to Firestore, Storage, and
serverless operational data, plus regular restore drills.

Exact DR RPO/RTO values remain intentional **TBD**. Managed always-on
relational (PostgreSQL) backups/PITR are **not** part of the MVP
baseline (relational DB **DEFERRED**).

---

# 178. Schema Migration

Every persistent client/server schema should have version migration strategy.

Migration must protect:

- purchases
- Wallet
- progression
- active Attempt where feasible

---

# 179. Active Attempt Compatibility

If a Rules or Engine update makes old Attempt state incompatible:

Possible policies:

- migrate
- replay into new model
- restart current Level safely

Exact behavior remains TBD.

---

# 180. Conflict Resolution

**CONFIRMED** domain-specific policy (see §98):

- progression conflict → highest valid progression
- wallet conflict → server-authoritative ledger
- entitlement conflict → store/backend authoritative
- settings conflict → latest revision
- active-session conflict → local/device-specific

These must not use one generic merge strategy.

---

# 181. Wallet Conflict

**CONFIRMED**

Wallet should be ledger/server-authoritative rather than merged from arbitrary client balances.

---

# 182. Progression Conflict

**CONFIRMED**

Merge to highest valid progression.

---

# 183. Entitlement Conflict

**CONFIRMED**

Entitlements should derive from validated purchase records, not local booleans. Store/backend authoritative.

---

# 184. Active Session Conflict

**CONFIRMED**

Active Attempt is local/device-specific (local-first persistence).

---

# 185. Data Security

Sensitive operational data should be protected through:

- transport encryption
- at-rest controls
- secure credential handling
- least-privilege admin access
- audit logs

Exact security architecture comes later.

---

# 186. Environment Separation

Data should be separated between:

- DEV
- TEST
- STAGING
- PROD

Content publication should support environment targeting.

---

# 187. Seed/Test Data

Non-production environments should support seeded:

- sample content
- Level configs
- known Solver boards
- mock products
- Daily Challenge data

Never mix production Wallet/purchase data into dev environments.

---

# 188. Data Export

Potential admin/support exports:

- content library
- level definitions
- Solver metrics
- analytics aggregates

Player personal data export may be needed for privacy compliance.

---

# 189. CMS Search Model

CMS should search:

- clue text
- full relation
- Member text
- aliases
- tags
- relation type
- semantic difficulty
- content status
- dialect
- topic

---

# 190. Duplicate Detection Data

Useful features:

- normalized Arabic
- aliases
- semantic embedding/vector reference
- Member-set overlap
- content hashes

Embedding/vector search is **PROPOSED**, not required for MVP.

---

# 191. Data Model — MVP / Launch P0

MVP/launch data must support:

- Anonymous identity.
- Optional account linking (explicit conflict flow; no automatic merge).
- Journey/Chapter/Level progress.
- Level Definitions (250 launch Level Definitions).
- Level Configurations.
- Content Library.
- Association/Member relationships.
- Attempt runtime state (local-first Active Attempt).
- Solver validation.
- Difficulty metrics.
- Wallet Coins (register economy values).
- Hint balance.
- Reward grants.
- Rewarded Ads.
- Coin Pack IAP.
- Remove Ads entitlement.
- Cloud Save (domain-specific conflict policy).
- Settings.
- Analytics identifiers (14-month raw retention baseline).
- CMS/Admin (audit retention 2 years).
- Remote Config.
- QA/Simulation (10,000+ for critical Templates/Configs).
- Daily Reward state.
- Daily Streak.
- Daily Challenge.
- Notification preferences (Daily Challenge + Streak Risk initially).
- Hybrid content delivery (bundled + remote versioned bundles).

`RESHUFFLE` utility is out of MVP.

---

# 192. Data Model — Deferred / Post-MVP Additions

Post-MVP / deferred systems:

- richer Smart Notification types beyond Daily Challenge/Streak Risk.
- Emoji/Illustration asset workflow expansion as content ops mature.
- XP/Player Level.
- Achievements.
- Badges.
- Collections.
- Cosmetics.
- Events.
- Packs.
- Leaderboards.
- Mid-Level Reshuffle utility.

---

# 194. Proposed Logical ERD — Core

```text
PlayerIdentity
  ├── PlayerProfile
  ├── JourneyProgress
  │     ├── ChapterProgress
  │     └── LevelProgress
  ├── Wallet
  │     └── WalletTransaction
  ├── HintBalance
  ├── PurchaseTransaction
  │     └── PlayerEntitlement
  └── GameAttempt
        ├── AttemptAssociation
        │      └── AssociationVariant
        │             └── AssociationDefinition
        │                    └── AssociationMemberLink
        │                           └── MemberDefinition
        ├── AttemptCard
        ├── AttemptTableauColumn
        ├── AttemptStock
        ├── AttemptAssociationSlot
        ├── AttemptAction
        └── SolverValidation

ChapterDefinition
  └── LevelDefinition
        └── LevelConfiguration
              ├── GroupSizeProfile
              ├── TableauProfile
              ├── ContentSelectionPolicy
              ├── DifficultyProfile
              └── SolverAcceptanceProfile
```

This is conceptual, not a final database schema.

---

# 195. Proposed Runtime Read Model

A compact playable Attempt payload may contain:

```text
AttemptPayload
- attemptId
- levelId
- rulesVersion
- moveLimit
- associations[]
- cards[]
- tableauColumns[]
- stock
- associationSlots[]
- solverMetadata
```

This should be optimized for the client Game Engine rather than mirroring normalized CMS tables.

---

# 196. Proposed Player Cloud Read Model

```text
PlayerCloudState
- playerId
- identity
- journey
- wallet
- hints
- entitlements
- dailyState?
- settings
- metaProgression?
- revision
```

Exact transport/API model is TBD.

---

# 197. Proposed Content Bundle Read Model

```text
ContentBundle
- bundleVersion
- associations[]
- members[]
- variants[]
- assets[]
- levelDefinitions[]
- levelConfigurations[]
```

Can support bundled/remote hybrid content.

---

# 197. Data Model Decision Register — Confirmed

The following data requirements are **CONFIRMED**:

1. Anonymous player identity exists.
2. Optional Apple/Google linking exists; explicit conflict flow; no automatic merge.
3. Main Journey is Endless.
4. Standard Chapter = 50 Levels.
5. Launch content = 5 Chapters = 250 Level Definitions.
6. Levels use configurations rather than one fixed board.
7. Restart keeps Level content/config and generates a new shuffle.
8. Association Card and Member Cards must have stable runtime identity.
9. Members map to one target Association per Level card instance.
10. Same Member concept can belong to multiple global Relations.
11. Same visible clue can represent multiple Relations.
12. Full relation and visible clue are separate concepts.
13. Text/Number/Symbol/Emoji/Illustration content types exist.
14. Solver validation is stored/observable.
15. Move Limit is fixed per Level.
16. Board and Semantic Difficulty are separate.
17. Coins exist; economy config values from Final Decision Register.
18. Hint balance exists.
19. Rewarded Ads exist.
20. Remove Ads entitlement exists.
21. Coin Pack IAP exists.
22. Cloud progression exists with domain-specific conflict policy.
23. Active Attempt persistence is local-first / device-specific.
24. Daily Reward / Daily Challenge / Daily Streak at launch/MVP.
25. Daily Challenge reset 00:00 player-local; backend authoritative.
26. Hybrid content delivery (bundled + remote versioned bundles).
27. Local DB Drift/SQLite + primary cloud store Cloud Firestore (conceptual mapping); relational DB deferred.
28. Analytics raw retention baseline 14 months.
29. Audit log retention 2 years.
30. RESHUFFLE utility out of MVP.
31. Content requires human approval.
32. Content/Level systems require versioning and activation/deactivation.
33. XP/Achievements/Badges/Collections/Cosmetics/Events/Packs/Leaderboards are **DEFERRED Post-MVP**.

---

# 198. Data Model Decision Register — Proposed / Requires Approval

The following remain **PROPOSED/TBD** or intentional **TBD**:

1. Exact ID type (intentional TBD).
2. Exact Firestore document/collection normalization beyond Drift↔Firestore conceptual mapping; any future relational schema if deferred ASP.NET+PostgreSQL is re-approved.
3. AssociationDefinition vs RelationDefinition split.
4. Full content status lifecycle.
5. Alias schema.
6. Exact difficulty metadata fields.
7. LevelTemplate entity.
8. Exact runtime Stock persistence representation (intentional TBD).
9. AttemptAction persistence scope.
10. Wallet ledger architecture details.
11. Hint ledger.
12. Soft-delete policy details.
13. Admin RBAC structure.
14. Analytics storage separation.
15. Simulation result schema.
16. Debug seed retention.
17. Exact DR RPO/RTO (intentional TBD).
18. Vector/semantic duplicate search.
19. Client/server read model shapes.
20. Exact rescue transform (intentional TBD; constraints CONFIRMED).

---

# 199. Recommended Approval Order

Before database/API implementation is frozen:

1. Approve entity boundaries.
2. Approve content schema.
3. Approve Level/Attempt schema.
4. Finalize Stock state representation (intentional TBD until then).
5. Approve player/cloud state model (conflict policy CONFIRMED).
6. Approve Wallet/Hint ledger approach.
7. Approve purchase/entitlement model.
8. Approve content/versioning model (hybrid delivery CONFIRMED).
9. Approve admin/audit model (2-year retention CONFIRMED).
10. Approve daily-state model (launch inclusion CONFIRMED).
11. Approve analytics identifiers (14-month baseline CONFIRMED).
12. Implement Drift/SQLite + Firestore document models (and Storage bundle manifests).
13. Define API/read models.
14. Define migration policies; leave exact DR RPO/RTO intentional TBD.

---

# 200. Recommended MVP Baseline

A safe MVP data baseline is:

- Stable opaque IDs (exact type intentional TBD).
- Versioned content/configuration with hybrid delivery (Firebase Storage for remote bundles).
- CMS/content domain persisted in Firebase/GCP through approved boundaries; Drift/SQLite on client.
- Compact runtime Attempt model; Active Attempt local-first.
- Anonymous player identity (Firebase Auth) with domain-specific conflict policy.
- Journey/Chapter/Level progress; 250 launch Level Definitions.
- Wallet with Coin ledger or equivalent idempotent transaction history (register economy values; server-authoritative via Cloud Functions/Cloud Run).
- Hint balance with transaction-safe updates.
- Validated purchase/entitlement records.
- Daily Reward / Challenge / Streak at launch.
- Solver validation metadata.
- Difficulty metrics tied to model version.
- Audit logs retained 2 years; analytics raw retention 14 months (Firebase Analytics + BigQuery).
- No RESHUFFLE utility; no schema assumptions for deferred Post-MVP mechanics.
- No always-on PostgreSQL/relational primary store in MVP baseline.

---

# 201. Dependencies

This Data Model directly feeds:

1. **Software Architecture**
2. **Backend & Cloud Architecture**
3. **API Specification**
4. **CMS Specification**
5. **Analytics & KPI Specification**
6. **QA & Automated Validation Strategy**
7. **Cloud Save & Sync Specification**
8. **MVP WBS / Product Backlog**

The next highest-value architecture document is **Software Architecture**, because it will decide how these data domains map into modules, repositories, services, client storage, and backend boundaries.

---

# 202. Baseline Status

This document is **Data Model v1.0** (Decision-Aligned to Final Decision Register v1.1).

It defines the complete conceptual data structure for the Arabic Solitaire Association game across gameplay, content, player progression, economy, Solver, CMS, Cloud Save, analytics, and deferred Full Product systems.

Register-approved Drift/SQLite + Cloud Firestore (relational DB deferred), conflict policy, hybrid delivery via Firebase Storage, Daily systems, economy values, retention, and RESHUFFLE-out-of-MVP decisions are **CONFIRMED**. Stock persistence representation, ID types, exact DR RPO/RTO, and exact rescue transform remain intentional **TBD**.

**End of Data Model v1.0**
