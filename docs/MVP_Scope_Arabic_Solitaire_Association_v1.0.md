# MVP Scope

## Arabic Solitaire Association Game

**Version:** 1.0\
**Status:** MVP Scope Baseline — Decision-Aligned / Approved\
**Derived From:** Final Decision Register v1.1 + GDD v1.0 + Full Product
Scope v1.0\
**Release Goal:** A production-ready, commercially viable first release
that proves the Core Gameplay, Arabic content proposition, randomized
solvable level system, retention fundamentals, and monetization
fundamentals without building the entire Full Product.

------------------------------------------------------------------------

# 1. MVP Objective

The MVP must answer five product questions:

1.  Is the Solitaire + Association core loop genuinely fun and
    understandable?
2.  Can randomized boards be generated quickly and reliably while
    remaining solvable within the Move Limit?
3.  Does Arabic-first association content create sufficient
    differentiation and retention?
4.  Can players progress through enough content without the experience
    becoming repetitive?
5.  Can the game support a basic sustainable economy and monetization
    model without Lives/Energy gating?

The MVP is not a prototype. It should be suitable for public App Store /
Play Store release after production QA and content review.

------------------------------------------------------------------------

# 2. MVP Product Principles

The MVP shall preserve the parts that define the game:

-   Full Solitaire Association rules.
-   Randomized board generation.
-   Solver validation.
-   Board and Semantic Difficulty.
-   Arabic-first content.
-   Endless Main Journey architecture.
-   Chapters.
-   Move limits.
-   Streak rewards.
-   Hints.
-   Undo.
-   Dead-end detection.
-   Basic rescue.
-   Coins.
-   Ads and approved IAP fundamentals.
-   Cloud-safe player progression.
-   Analytics required to evaluate the game.

The MVP shall defer systems that add breadth but are not required to
prove the product.

**Client stack baseline:** Flutter (Riverpod; Drift/SQLite).
**Cloud/backend baseline:** Firebase-first (Auth anonymous-first;
Firestore; Storage; Cloud Functions/Cloud Run for privileged ops;
GitHub Actions; DEV/TEST/STAGING/PROD). Detailed architecture remains in
Software Architecture / Backend documents.

------------------------------------------------------------------------

# 3. MVP Scope Classification

Capabilities are classified as:

**P0 --- Launch Critical**\
Required for the first production release.

**P1 --- MVP Enhancement**\
Included in MVP if delivery risk remains acceptable. Can be disabled
behind a feature flag at launch.

**Post-MVP**\
Designed for compatibility but not required for the first release.

------------------------------------------------------------------------

# 4. P0 --- Core Game Engine

The complete approved core rules are P0.

The engine shall support:

-   Association Cards.
-   Member Cards.
-   Tableau Columns.
-   Face-up / face-down cards.
-   Automatic card reveal.
-   Empty Tableau Columns.
-   Same-Association stacking.
-   Stack-to-Stack merging.
-   Atomic non-splittable Stacks.
-   Association Card → compatible Member Stack.
-   Association Stack movement.
-   Association Slots.
-   Active Associations.
-   Single Card → Active Association.
-   Stack → Active Association.
-   Association completion.
-   Automatic removal of completed Associations.
-   Variable group sizes.
-   Variable number of Associations.
-   Variable Tableau layouts.
-   Variable Association Slot counts.
-   Stock.
-   Stock Restore.
-   Move Limit.
-   Valid/invalid move detection.
-   Win detection.
-   Failure / Out-of-Moves state.

No simplified gameplay variant should replace these rules in MVP.

------------------------------------------------------------------------

# 5. P0 --- Card Interaction

The primary interaction is:

**Drag & Drop**

MVP shall provide:

-   Responsive dragging.
-   Clear drop targets.
-   Valid placement feedback.
-   Invalid placement rejection.
-   Stack dragging.
-   Smooth return animation after invalid placement.
-   Automatic face-down card reveal.
-   Association completion animation.
-   Coin/reward feedback.

Tap-to-auto-place is not required.

------------------------------------------------------------------------

# 6. P0 --- Tableau

Each Level Configuration shall support:

-   Variable column count.
-   Variable number of cards per column.
-   One initial face-up card per column.
-   Remaining initial cards face-down.
-   Automatic reveal after exposed cards are removed.
-   Empty columns accepting any valid movable unit.

Initial face-up card type remains fully randomized.

------------------------------------------------------------------------

# 7. P0 --- Stock

MVP Stock behavior shall match the approved rules:

-   Variable Stock size.
-   Association and Member Cards may both appear in Stock.
-   Up to the last 3 Stock cards remain visible.
-   Only the final/top visible card is playable.
-   Removing it exposes the previous visible card.
-   Stock may be cycled.
-   Restore Stock is unlimited.
-   Restore preserves order.
-   Restore does not shuffle.
-   Stock cycle consumes 1 Move.
-   Restore consumes 1 Move.
-   Both actions are neutral for the correct-action streak.

------------------------------------------------------------------------

# 8. P0 --- Association Slots

MVP shall support:

-   Variable Association Slot count.
-   All Slots empty at level start.
-   Association Card activation in an empty Slot.
-   Progress count for active Associations.
-   Compatible single Member Card placement.
-   Compatible Stack placement.
-   Combined Association Stack placement.
-   Automatic completion and removal.
-   Immediate Slot reuse after completion.

------------------------------------------------------------------------

# 9. P0 --- Move System

Each level has a fixed Move Limit.

MVP shall correctly count all approved Move-consuming actions.

A complete Stack always consumes one Move.

Invalid actions consume no Move.

Restarting the same level retains the configured Move Limit but
generates a new board.

------------------------------------------------------------------------

# 10. P0 --- Correct-Move Streak Economy

MVP shall include the approved in-level streak:

-   3 correct actions → 3 Coins.
-   4 correct actions → 4 Coins.
-   5 correct actions → 5 Coins.
-   Thereafter, each 5-action streak → 5 Coins.

The unlocked tier persists after mistakes.

Wrong actions reset the current streak counter.

Neutral actions neither increase nor reset the streak.

The MVP must visually communicate:

-   Current streak progress.
-   Reward earned.
-   Current required streak length.

------------------------------------------------------------------------

# 11. P0 --- Undo

MVP Undo behavior:

-   Reverts the last eligible Move only.
-   Restores the consumed Move.
-   Cannot be used twice consecutively.
-   Requires a new Move before another Undo.
-   Cannot undo a Move that completed and removed an Association.

No expanded Undo history is required.

------------------------------------------------------------------------

# 12. P0 --- Hint

MVP shall include Solver-powered Hints.

A Hint:

-   Does not perform the Move.
-   Displays the recommended action.
-   Does not consume a Move.
-   Consumes one Hint resource.
-   May recommend a Tableau move, Association move, Stack move, or Stock
    action.

Hints may be replenished using Coins and/or Rewarded Ads.

Exact starting Hint quantity and price are balancing values and may be
remotely configured.

------------------------------------------------------------------------

# 13. P0 --- Dead-End Detection

MVP shall automatically detect an unsolvable current state.

When detected:

-   Normal play is interrupted with a clear dead-end state.
-   Undo is offered when eligible.
-   At least one rescue path is available.
-   Restart is always available.

The Solver must not knowingly recommend a Move that immediately leaves
the player with no valid completion path unless no solvable path exists.

------------------------------------------------------------------------

# 14. P0 --- Rescue

MVP shall implement a minimal commercially viable rescue system.

Required rescue categories:

-   Undo when eligible.
-   Extra Moves when Moves reach zero.
-   Dead-End Rescue / Reshuffle capability.
-   Rewarded-Ad option for at least one rescue path.
-   Coin-funded option for at least one rescue path.

The exact board transformation used by Dead-End Rescue is a
technical/game-design sub-specification and must be solver-validated
before implementation.

------------------------------------------------------------------------

# 15. P0 --- Win and Rewards

A level is complete only when every card has been cleared.

MVP reward formula:

**50 Coins Base Reward**

plus:

**2 Coins × Remaining Moves**

plus:

**Coins already earned through correct-action streaks**

Reward calculation must be deterministic and analytics-instrumented.

------------------------------------------------------------------------

# 16. P0 --- Restart

Restart shall:

-   Keep the same Level Configuration.
-   Keep the same Level Content/Associations.
-   Perform a completely new random shuffle.
-   Redeal Tableau and Stock.
-   Start with empty Association Slots.
-   Run Solver validation before play.
-   Preserve the configured Move Limit.

Restart is unlimited because the game has no Lives/Energy system.

------------------------------------------------------------------------

# 17. P0 --- Random Level Generation

Every normal Main Journey attempt is randomized, including the first
attempt.

Pipeline:

`Level Configuration` → `Content Set` → `Card Pool` → `Full Shuffle` →
`Tableau Deal` → `Stock Deal` → `Empty Association Slots` →
`Solver Validation` → `Difficulty Validation` → `Accept / Regenerate`

MVP does not require Seed History or duplicate-board prevention.

------------------------------------------------------------------------

# 18. P0 --- Solver

The Solver is launch-critical.

MVP Solver responsibilities:

1.  Validate that a generated board is solvable.
2.  Validate that it can be solved within the Move Limit.
3.  Produce at least one valid reference solution/path.
4.  Support Hint generation.
5.  Detect current-state dead ends.
6.  Supply basic Board Difficulty metrics.
7.  Reject unsuitable generated boards.

Solver correctness must be covered by automated tests and simulation.

A board may never be intentionally shipped simply because generation
succeeded syntactically.

------------------------------------------------------------------------

# 19. P0 --- Generation Performance Safeguards

MVP shall define operational safeguards for board generation:

-   Maximum generation attempts.
-   Maximum Solver time per attempt.
-   Fallback behavior when generation cannot find an accepted board
    quickly.
-   Logging/analytics for generation failures.
-   Deterministic reproduction data for debugging may be stored
    internally even though duplicate prevention is not a player feature.

Exact performance thresholds are to be defined during technical design.

------------------------------------------------------------------------

# 20. P0 --- Difficulty System

MVP shall preserve two difficulty dimensions:

### Board Difficulty

Derived from board structure and Solver metrics.

### Semantic Difficulty

Derived from the selected Associations and Members.

MVP shall support Difficulty Waves rather than strict linear
progression.

A production level definition must therefore be able to request
combinations such as:

-   Easy Board / Easy Semantic.
-   Medium Board / Easy Semantic.
-   Easy Board / Medium Semantic.
-   Medium / Medium.
-   Hard Board / easier Semantic.
-   Hard Semantic / easier Board.
-   Peak combinations.

Exact numeric scoring models remain a balancing task.

------------------------------------------------------------------------

# 21. P0 --- Main Journey

MVP shall launch with the Endless Main Journey architecture.

Requirements:

-   Continuous Level Number.
-   No final-level assumption in the data model.
-   Chapter grouping.
-   Standard Chapter size of 50 levels.
-   Mixed content within Chapters.
-   Progress persistence.
-   Current level resume/continue.

The amount of launch-ready content is a release-planning value, not a
change to the Endless architecture.

------------------------------------------------------------------------

# 22. Confirmed MVP Launch Content Target

**CONFIRMED** (Final Decision Register v1.1):

**5 Chapters / 250 progression levels** (Level Definitions and curated
content coverage).

Because each attempt is randomized, these are not 250 fixed boards.

They are progression definitions/content selections from which valid
boards are generated.

Difficulty structure: **10-Level Wave × 5** per Chapter; group-size
progression **3 → 4 → 5/mixed**; sequential unlock; clue reuse ≥20
Levels; no exact Variant repeat in a Chapter; text dominant; early/mid
max one visual Association; illustration gradual after tutorial.

The content system must be capable of adding further Chapters without an
app redesign.

------------------------------------------------------------------------

# 23. P0 --- Arabic Text Content

Text is the primary MVP content type.

MVP shall support:

-   Arabic words.
-   Arabic phrases.
-   Concise Association clues.
-   Numbers.
-   Symbols.
-   Individual letters.
-   Selective Arabic diacritics.
-   Foreign names/terms using the form familiar to Arabic users.
-   Multi-type relation logic.
-   Same clue reused for different relations.
-   Same word participating in multiple global relations.

The player sees the concise clue, not the internal full relation.

------------------------------------------------------------------------

# 24. P0 --- Relation Types for Launch

The launch content library should prioritize relation types that can be
reviewed and balanced reliably:

-   Semantic categories.
-   Shared properties.
-   Common contexts.
-   Common phrases.
-   Letter-based relations.
-   Simple linguistic patterns.
-   Basic prefix/suffix relationships.
-   Numerical/symbol relationships where clear.
-   Carefully reviewed wordplay.

Very obscure or highly subjective wordplay should not be required to
meet launch content volume.

------------------------------------------------------------------------

# 25. P0 --- Semantic Ambiguity

MVP supports controlled ambiguity in later/harder progression.

Requirements:

-   One target Association per card instance.
-   Human validation.
-   Fairness review.
-   No arbitrary interpretation.
-   Semantic difficulty metadata.

Early onboarding and early progression should use clearer Associations.

------------------------------------------------------------------------

# 26. P1 --- Illustration/Icon Cards

Illustration/Icon Member Cards are part of the approved Full Product and
should be supported by the data model from day one.

For MVP release:

**P1 Enhancement**

If included, they must:

-   Use illustrations/icons only.
-   Use no label on the Member Card.
-   Be visually clear.
-   Keep the Association Card textual.
-   Keep each Association homogeneous in content type.

If visual-asset production threatens the launch schedule, the first
public release may be predominantly Text/Number/Symbol/Emoji while the
engine remains compatible with Illustration Cards.

------------------------------------------------------------------------

# 27. P1 --- Emoji Associations

Emoji Associations are low-cost compared with illustration production
and are suitable for MVP enhancement.

They shall follow the same homogeneous-Association rule.

Text remains the majority content.

------------------------------------------------------------------------

# 28. P0 --- Content Library

MVP requires a structured Content Library rather than hard-coded level
text.

At minimum it must model:

-   Association clue.
-   Full internal relation.
-   Member item.
-   Content type.
-   Display value.
-   Optional aliases.
-   Optional diacritics.
-   Relation type.
-   Semantic difficulty.
-   Evergreen/contemporary classification.
-   Review/approval state.
-   Active/inactive state.
-   Reuse/usage metadata sufficient for generation.

------------------------------------------------------------------------

# 29. P0 --- Content Review Workflow

AI-assisted content is allowed, but production content requires human
approval.

Minimum MVP workflow:

`Generate/Author` → `Language Review` → `Semantic Review` →
`Duplicate Check` → `Difficulty Review` → `Approve` → `Publish`

The first version may use a lightweight internal admin workflow rather
than a sophisticated enterprise editorial suite.

------------------------------------------------------------------------

# 30. P1 --- AI-Assisted Content Generation Tooling

A fully integrated AI Content Studio is not launch-critical.

For MVP:

-   AI may be used operationally to generate candidate content.
-   Generated candidates must enter the review workflow.
-   Automated direct production publishing is prohibited.

A richer AI-assisted CMS workflow is Post-MVP unless it materially
reduces launch content production time.

------------------------------------------------------------------------

# 31. P0 --- Tutorial / Onboarding

MVP shall include:

1.  A concise explanation of the game concept.
2.  Interactive tutorial gameplay.

Tutorial shall progressively introduce mechanics.

It should not attempt to teach advanced ambiguity or every content
relation type immediately.

Tutorial progression must be analytics-instrumented.

------------------------------------------------------------------------

# 32. P0 --- No Lives / Energy

MVP shall not include:

-   Lives.
-   Energy.
-   Wait timers blocking play.

Players may retry indefinitely.

This is a fixed product decision.

------------------------------------------------------------------------

# 33. P0 --- Coins

Coins are the MVP soft currency.

MVP Coin sources:

-   Level win.
-   Remaining Moves.
-   Correct-move streak.
-   Daily Reward (launch P0).
-   Daily Challenge (launch P0).
-   Daily Streak milestones (launch P0).
-   Rewarded Ads.
-   IAP Coin Packs.

MVP Coin sinks:

-   Hints (75 Coins).
-   Extra Moves (+5 at 150 then 250; max 2/Attempt).
-   Dead-End Rescue / Solver-Guided Recovery (200 Coins; max 1/Attempt).

**No Mid-Level Reshuffle in MVP.**

Starting balance: **300 Coins**, **3 Hints**.

Cosmetic spending is Post-MVP / DEFERRED.

------------------------------------------------------------------------

# 34. P0 --- Economy Configuration

Economy values must not be deeply hard-coded.

At minimum the following should be remotely/configurably tunable:

-   Hint Coin cost.
-   Extra Moves Coin cost.
-   Number of Extra Moves granted.
-   Rescue Coin cost.
-   Rewarded-Ad reward values.
-   Starting Coin balance.
-   Starting Hint balance.
-   Daily Reward values if enabled.

The fixed core reward rules already approved remain part of the game
design unless deliberately revised.

------------------------------------------------------------------------

# 35. P0 --- Rewarded Ads

MVP shall include optional Rewarded Ads.

At launch they may be used for:

-   Extra Moves.
-   Hint acquisition.
-   Dead-End Rescue.
-   Optional Coin grant.

All Rewarded Ads require explicit player choice and clear reward
disclosure.

**CONFIRMED** Rewarded Coin Ad: **100 Coins**; cap **3/day**.

Reward delivery must handle ad failure and duplicate callback
protection.

------------------------------------------------------------------------

# 36. P0 --- Interstitial Ads

MVP shall include adaptive Interstitial Ads as a monetization
capability.

**CONFIRMED** (Final Decision Register v1.1):

-   Adaptive; baseline around every **3–5** completed Levels.
-   Max **3** Interstitials per session.
-   Suppressions after Rewarded Ad, purchase, tutorial, failure,
    Dead-End, or Out-of-Moves decline.
-   Remove Ads entitlement removes Interstitials only.
-   Analytics and Remote Config.

------------------------------------------------------------------------

# 37. P0 --- IAP

MVP IAP scope:

-   Remove Ads.
-   Coin Packs.

Required capabilities:

-   Product loading.
-   Purchase flow.
-   Restore purchase where applicable.
-   Transaction validation.
-   Entitlement persistence.
-   Purchase failure/pending handling.
-   Analytics.

Starter Bundles are not MVP scope.

------------------------------------------------------------------------

# 38. P0 --- Remove Ads

Remove Ads is an MVP entitlement.

**CONFIRMED:** It removes **Interstitials only**.

Rewarded Ads remain optional utility/reward opportunities.

Real-money price is **TBD**.

------------------------------------------------------------------------

# 39. P0 --- Minimal Shop

MVP requires a simple Shop supporting:

-   Coin Packs (amounts **1,000 / 3,000 / 7,000 / 15,000**; prices
    **TBD**).
-   Remove Ads (price **TBD**).

**No Starter Pack / Subscription / Premium Currency.**

Coin-based Hint/Extra-Move/Rescue purchases may be offered contextually
inside gameplay rather than requiring a large standalone utility
catalogue.

Cosmetic merchandising is Post-MVP / DEFERRED.

------------------------------------------------------------------------

# 40. P0 --- Daily Reward

**CONFIRMED launch P0** (Final Decision Register v1.1).

7-day repeating calendar:

-   Day 1: 100 Coins; Day 2: 125; Day 3: 150; Day 4: 1 Hint; Day 5: 175;
    Day 6: 200; Day 7: 300 Coins + 1 Hint.
-   Missing a day does **not** reset calendar progression.
-   Backend authoritative for Daily time/eligibility.

Minimal implementation supports claim, current-day state, and analytics.

Complex recovery/grace mechanics remain Post-MVP / DEFERRED.

------------------------------------------------------------------------

# 41. P0 --- Daily Challenge

**CONFIRMED launch P0** (Final Decision Register v1.1).

-   Reward: **150 Coins** auto-granted on first completion.
-   Unlimited retries during the valid day.
-   Fixed deterministic board per challenge cohort.
-   Reset: **00:00** validated player-local timezone.
-   Backend authoritative.
-   Leaderboard Post-MVP / DEFERRED.

------------------------------------------------------------------------

# 42. P0 --- Daily Streak

**CONFIRMED launch P0** (Final Decision Register v1.1).

-   Streak breaks after a missed day.
-   Milestones: 3 → 100; 7 → 250; 14 → 400; 30 → 750 Coins.
-   Streak Risk notifications at launch.

Complex streak freezes/recovery are Post-MVP / DEFERRED.

------------------------------------------------------------------------

# 43. Post-MVP --- XP / Player Level

Player XP and meta Player Level are part of the Full Product but are not
required to validate the first-release core loop.

They are deferred to Post-MVP unless product planning identifies a
strong launch need.

The data architecture should avoid blocking their later addition.

------------------------------------------------------------------------

# 44. Post-MVP --- Achievements

Achievements are deferred from the minimum first release.

Platform-native/basic internal achievements may be added later without
changing Core Gameplay.

------------------------------------------------------------------------

# 45. Post-MVP --- Collections

Collections are deferred.

Their eventual design should be treated as a dedicated
retention/meta-progression feature rather than a launch dependency.

------------------------------------------------------------------------

# 46. Post-MVP --- Badges

Badges are deferred with the broader meta-progression system.

------------------------------------------------------------------------

# 47. Post-MVP --- Cosmetics / Themes

Cosmetics and Themes are approved Full Product Coin sinks but are not
required for first-release validation.

The UI architecture should leave room for them.

------------------------------------------------------------------------

# 48. Post-MVP --- Temporary Events

The full Event platform is deferred from the minimum release.

The backend/content model should nevertheless distinguish evergreen
content from contemporary/event content so Events can be added without
restructuring the Content Library.

------------------------------------------------------------------------

# 49. Post-MVP --- Permanent Special Packs

Dialect Packs and other Permanent Packs are deferred from the minimum
launch.

Main Journey Arabic should remain broadly understandable across markets.

------------------------------------------------------------------------

# 50. Post-MVP --- Leaderboards

Leaderboards are deferred from the minimum MVP because they introduce:

-   Server-authoritative score concerns.
-   Anti-cheat requirements.
-   Ranking/reset logic.
-   Additional backend operations.

Daily Challenge can launch without a leaderboard.

Leaderboard compatibility should be considered in analytics/data design.

------------------------------------------------------------------------

# 51. P0 --- Anonymous Player Identity

MVP shall not require registration before play.

The player receives an anonymous identity/profile (anonymous-first;
local anonymous ID first; cloud anonymous profile at first connection —
Final Decision Register v1.1).

The system must preserve a path for optional account linking.

------------------------------------------------------------------------


# 52. P0 --- Cloud Save

Because progression and purchases are valuable player state, MVP should
include Cloud Save.

Minimum cloud state:

-   Current Main Journey Level.
-   Chapter progress.
-   Coin balance.
-   Hint/resource balance.
-   Purchase entitlements.
-   Daily state (Daily Reward / Challenge / Streak).
-   Settings where appropriate.

Active Attempt persistence is local-first (Final Decision Register
v1.1). Cloud synchronization must minimize Firestore reads/writes and
avoid per-Move cloud traffic.

------------------------------------------------------------------------

# 53. P0 --- Optional Account Linking

MVP account model shall support optional:

-   Sign in with Apple.
-   Google Sign-In.

The player must be able to begin anonymously.

Linking should preserve existing anonymous progress.

Mandatory login is prohibited by current product decisions.

------------------------------------------------------------------------

# 54. P0 --- Purchase and Economy Integrity

The MVP backend/client design must prevent trivial duplication of:

-   Paid Coin grants.
-   Remove Ads entitlement.
-   Rewarded-Ad grants where verification is available.
-   Daily rewards.
-   Cloud-save currency.

Wallet/purchases are server-authoritative (Final Decision Register
v1.1). IAP client: Flutter `in_app_purchase`; server-side validation.

------------------------------------------------------------------------


# 55. P0 --- Notifications

Smart Notification infrastructure is **launch P0** (Final Decision
Register v1.1).

Initially active types only:

-   Daily Challenge.
-   Streak Risk.

Quiet hours: **22:00–09:00** player-local time.

Richer types (Daily Reward available, Events, New Content) are
**Post-MVP / DEFERRED**.

Notification permission must be requested contextually rather than
immediately on first launch unless UX research supports otherwise.

------------------------------------------------------------------------

# 56. P0 --- Analytics

Analytics are launch-critical.

The MVP cannot be evaluated without them.

Required MVP measurement includes:

-   First open.
-   Tutorial funnel.
-   Level start.
-   Level complete.
-   Level fail.
-   Restart.
-   Board generation metrics.
-   Solver acceptance/rejection.
-   Actual Moves.
-   Remaining Moves.
-   Invalid moves.
-   Stock cycles/restores.
-   Stack formation.
-   Association completion.
-   Hint use.
-   Undo use.
-   Dead-end detection.
-   Rescue use.
-   Out-of-Moves.
-   Coin earned/spent.
-   Rewarded Ads.
-   Interstitials.
-   Shop views.
-   IAP funnel.
-   Daily feature engagement.
-   Retention/session metrics.

------------------------------------------------------------------------

# 57. P0 --- Crash and Diagnostics

MVP shall include production diagnostics for:

-   Crashes.
-   Non-fatal errors.
-   Solver failures/timeouts.
-   Board generation failures.
-   Invalid game-state assertions.
-   Purchase failures.
-   Cloud-save failures.
-   Content/asset loading failures.

Logs must avoid unnecessary personal data.

------------------------------------------------------------------------

# 58. P0 --- Remote Config / Feature Flags

A minimal remote configuration capability is P0.

It should support tuning or disabling:

-   Ads.
-   Rewarded-Ad grants.
-   Economy prices.
-   Starting resources.
-   Daily features.
-   Selected content.
-   Problematic level configurations.
-   New optional features.

A full experimentation platform is not required for MVP.

------------------------------------------------------------------------

# 59. P0 --- Content Delivery / Versioning

MVP must be able to update or disable problematic content without
requiring a full redesign.

At minimum:

-   Content has version/status.
-   Level configurations have version/status.
-   Problematic Associations can be deactivated.
-   Client handles compatible content updates safely.

Whether content is bundled, remote, or hybrid is an architecture
decision.

------------------------------------------------------------------------

# 60. P0 --- Minimal Admin / CMS

MVP requires an internal content-management capability.

Minimum functions:

-   Create/edit Association clue.
-   Create/edit full relation.
-   Create/edit Members.
-   Set content type.
-   Set semantic difficulty.
-   Set relation type.
-   Approve/reject.
-   Activate/deactivate.
-   Search/filter.
-   Manage level configuration.
-   Validate level configuration.
-   Publish content/configuration.

A polished enterprise-grade CMS is not required for launch.

------------------------------------------------------------------------

# 61. P1 --- Illustration Asset Management

If Illustration Cards launch in MVP, the CMS/content pipeline must
support:

-   Illustration upload/reference.
-   Preview.
-   Association assignment.
-   Active/inactive status.
-   Asset versioning.
-   Basic quality review.

AI image-generation integration is not required.

------------------------------------------------------------------------

# 62. P0 --- RTL-First UX

MVP is Arabic-first and shall be designed RTL-first.

Requirements:

-   Correct Arabic shaping.
-   Correct RTL navigation/layout.
-   Mixed Arabic/Latin handling.
-   Card text fitting.
-   Selective diacritics.
-   Clear numeral/symbol rendering.
-   Responsive text sizes.
-   No reliance on English-first mirrored layouts that break Arabic
    interaction.

------------------------------------------------------------------------

# 63. P0 --- Core Screen Inventory

The MVP requires at minimum:

1.  Splash / Initialization.
2.  First-time Onboarding.
3.  Home / Continue Journey.
4.  Chapter / Level progression presentation.
5.  Gameplay.
6.  Pause / Exit / Restart controls.
7.  Hint feedback.
8.  Dead-End Rescue.
9.  Out-of-Moves / Extra Moves.
10. Level Complete / Rewards.
11. Shop.
12. Daily Reward.
13. Daily Challenge.
14. Account / Cloud Save.
15. Settings.
16. Privacy / Legal.
17. Restore Purchases.
18. Basic Help / How to Play.
19. Report a problem (Main Journey).

A large social/profile hub is not required.

------------------------------------------------------------------------

# 64. P0 --- Settings

Minimum settings:

-   Sound on/off.
-   Music on/off if music is included.
-   Haptics on/off.
-   Notification settings if notifications launch.
-   Account/cloud state.
-   Restore Purchases.
-   Privacy/Legal.
-   Help/Support.

------------------------------------------------------------------------

# 65. P0 --- Audio / Haptics Minimum

MVP should include basic polished feedback:

-   Drag/drop.
-   Correct placement.
-   Invalid placement.
-   Card flip.
-   Stack merge.
-   Association completion.
-   Coin reward.
-   Level win.
-   Basic haptics.

A large soundtrack/music system is not required for MVP.

------------------------------------------------------------------------

# 66. P0 --- Visual Design Minimum

MVP requires a production-quality coherent visual identity for:

-   Logo/name treatment.
-   App icon.
-   Board.
-   Cards.
-   Association Cards.
-   Association Slots.
-   Stock.
-   Buttons.
-   Reward feedback.
-   Chapter/progression presentation.
-   Shop.
-   Dialogs.

A large cosmetic theme catalogue is not required.

------------------------------------------------------------------------

# 67. P0 --- Accessibility Baseline

Minimum MVP accessibility:

-   Readable Arabic font sizing.
-   Strong contrast.
-   Valid/invalid states not communicated by color alone.
-   Appropriate touch targets.
-   Sound/haptic controls.
-   Reduced-motion consideration for essential interactions.
-   Clear content scaling within cards.

Advanced accessibility certification remains a later specification.

------------------------------------------------------------------------

# 68. P0 --- App Lifecycle Reliability

MVP must safely handle:

-   Background/resume.
-   App termination.
-   Network loss.
-   Failed ad load.
-   Failed/pending purchase.
-   Cloud sync failure.
-   Content update.
-   Solver timeout.
-   Board-generation retry.

The player must not lose paid entitlements or corrupt progression
because of ordinary app lifecycle events.

------------------------------------------------------------------------

# 69. P0 --- Basic Offline Play

**CONFIRMED** (Final Decision Register v1.1):

-   Main Journey fully playable offline once required content is
    downloaded.
-   Offline Coin spending allowed against locally reconciled balance
    with queued idempotent reconciliation.
-   Ads, purchases, and Rewarded Ads require network.
-   Daily eligibility remains backend-authoritative when online;
    offline edge cases must reconcile safely.

Full offline parity for all LiveOps surfaces is not required.

------------------------------------------------------------------------

# 70. P0 --- Privacy / Store Compliance

Before public release MVP must include:

-   Privacy Policy access.
-   Terms where required.
-   Consent flows required by analytics/ads jurisdictions.
-   Account/data deletion path where applicable.
-   Apple/Google purchase requirements.
-   Sign in with Apple requirements if third-party sign-in is offered on
    iOS.
-   Advertising privacy configuration.
-   Age-rating/content declarations.

Legal review is outside game design but release compliance is P0.

------------------------------------------------------------------------

# 71. P0 --- QA

MVP QA shall cover:

-   Core rule correctness.
-   Tableau.
-   Stock.
-   Stack atomicity.
-   Association activation/completion.
-   Move counting.
-   Streak counting.
-   Rewards.
-   Undo.
-   Hint.
-   Solver.
-   Dead-end detection.
-   Restart randomization.
-   Difficulty validation.
-   Economy.
-   Ads.
-   IAP.
-   Cloud save.
-   Account linking.
-   Content publishing.
-   RTL.
-   Device compatibility.
-   App lifecycle.

------------------------------------------------------------------------

# 72. P0 --- Automated Solver / Board Simulation

A large automated simulation suite is mandatory before launch.

It shall repeatedly generate and solve boards to measure:

-   Solvability.
-   Move-limit compliance.
-   Generation rejection rate.
-   Generation latency.
-   Difficulty distribution.
-   Dead-end paths.
-   Hint correctness.
-   Rule invariants.
-   Regression after engine changes.

This is part of MVP engineering scope.

------------------------------------------------------------------------

# 73. P0 --- Content QA

Every production Association must be reviewed for:

-   Correct Arabic.
-   Correct intended relation.
-   Fair clue.
-   Semantic difficulty.
-   Unintended ambiguity.
-   Duplicate/near-duplicate issues.
-   Broad Arabic-market comprehensibility.
-   Cultural appropriateness.
-   Diacritics when necessary.
-   Foreign-term display.
-   Visual clarity if visual content is used.

------------------------------------------------------------------------

# 74. P0 --- Performance

MVP must target:

-   Responsive drag interactions.
-   Smooth board animation.
-   Fast level start.
-   Solver/generation that does not create unacceptable waiting.
-   Stable memory usage.
-   Efficient content loading.
-   Reliable lower/mid-range supported-device performance.

Exact measurable budgets belong to Technical Design.

------------------------------------------------------------------------

# 75. P0 --- Security Baseline

MVP security scope includes reasonable protection for:

-   Purchase validation.
-   Entitlements.
-   Currency/cloud state.
-   API authentication.
-   Admin/CMS access.
-   Content publishing.
-   Secrets/configuration.
-   Basic abuse protection.

Sophisticated competitive anti-cheat is not required until competitive
systems such as Leaderboards become material.

------------------------------------------------------------------------

# 76. MVP Backend Capability

**CONFIRMED** MVP cloud baseline (Final Decision Register v1.1 §§6–10):
Firebase-first / serverless-first. No Azure, no always-on relational
DB, no Kubernetes/Redis/message broker in MVP by default. ASP.NET Core +
PostgreSQL is **DEFERRED** unless Firebase proves insufficient.

The minimum backend/cloud capability shall support:

-   Anonymous player identity (Firebase Auth).
-   Optional account linking.
-   Cloud save (Firestore for suitable docs; minimize R/W).
-   Purchase entitlements (IAP validation via Cloud Functions/Cloud Run).
-   Economy integrity (server-authoritative wallet ledger via trusted
    functions).
-   Remote configuration (Firebase Remote Config + server-controlled
    sensitive config where required).
-   Content/config delivery (Firebase Storage for remote bundles).
-   Daily systems (backend-authoritative eligibility).
-   Notification targeting (FCM).
-   Admin/CMS (Angular + Entra ID; Firebase/GCP only through approved
    security boundaries).
-   Operational logging (Firebase/GCP native logs/monitoring; not Azure
    App Insights/Monitor).

Exact service decomposition and quotas remain operational design /
**TBD** tuning.


------------------------------------------------------------------------

# 77. MVP Scope Summary --- P0

Launch-critical capabilities:

-   Full Core Game Engine.
-   Tableau and Stock.
-   Association Slots.
-   Atomic Stacks.
-   Move Limit.
-   Streak rewards.
-   Undo.
-   Solver-powered Hints.
-   Dead-End Detection.
-   Rescue / Extra Moves.
-   Win/reward system.
-   Full randomization per attempt/restart.
-   Solver validation.
-   Difficulty validation.
-   Endless Journey architecture.
-   50-level Chapters.
-   Arabic-first text content.
-   Structured Content Library.
-   Human content approval.
-   Tutorial.
-   No Lives/Energy.
-   Coins.
-   Rewarded Ads.
-   Adaptive Interstitial Ads.
-   Remove Ads.
-   Coin Packs.
-   Minimal Shop.
-   Anonymous identity.
-   Cloud Save.
-   Optional Apple/Google linking.
-   Analytics.
-   Crash/diagnostics.
-   Remote Config / Feature Flags.
-   Minimal CMS.
-   RTL-first UI.
-   Core screens.
-   Basic audio/haptics.
-   Production visual identity.
-   Accessibility baseline.
-   Lifecycle/network reliability.
-   Privacy/store compliance.
-   Automated board simulation.
-   Content QA.
-   Production QA.
-   Daily Reward.
-   Daily Challenge.
-   Daily Streak.
-   Smart Notifications (Daily Challenge + Streak Risk; quiet hours
    22:00–09:00).
-   Report a problem.
-   Offline Main Journey + offline Coin spend reconciliation.

------------------------------------------------------------------------

# 78. MVP Scope Summary --- P1

Optional MVP enhancements if delivery risk allows (feature-flaggable):

-   Emoji Associations.
-   Illustration/Icon Associations if asset production is ready.
-   Lightweight richer content tooling.

P1 items may be feature-flagged if they are implemented but not ready
for launch.

------------------------------------------------------------------------

# 79. Post-MVP Scope

**DEFERRED** from the first release (Final Decision Register v1.1):

-   Player XP / Player Level.
-   Achievements.
-   Collections.
-   Badges.
-   Cosmetics/Themes catalogue (paid Cosmetics unless later approved).
-   Temporary Event platform (until post-launch stability).
-   Permanent Dialect/Special Packs.
-   Leaderboards.
-   Richer Smart Notification types beyond Daily Challenge / Streak Risk.
-   Mid-Level Reshuffle.
-   Friends.
-   PvP.
-   Large AI-integrated Content Studio.
-   Advanced experimentation platform.
-   Complex Daily Streak recovery.
-   Daily Challenge Leaderboards.
-   Large cosmetic Shop.
-   Contemporary celebrity/brand content.
-   Advanced support tooling.
-   Redis / Message Broker / Kubernetes unless later justified.
-   ASP.NET Core + PostgreSQL / always-on relational DB unless
    Firebase-first proves insufficient.
-   Dedicated always-on backend infrastructure unless justified.

Friends and PvP are not currently approved Full Product requirements and
remain outside scope unless a future decision adds them.

Azure-heavy MVP baseline items listed in Final Decision Register v1.1
§13A are **SUPERSEDED** and must not be treated as MVP requirements.

------------------------------------------------------------------------

# 80. MVP Release Gates

The MVP should not be considered release-ready until all of the
following are true:

### Gameplay Gate

Core rules match the approved GDD with no known progression-blocking
defects.

### Solver Gate

Randomized boards are reliably solvable within configured Move Limits
and automated simulation passes agreed thresholds.

### Performance Gate

Board generation and gameplay interaction meet defined performance
budgets.

### Content Gate

Launch content volume is approved and has completed human QA.

### Economy Gate

Coin sources/sinks and rescue values pass internal balancing and do not
trivially break progression.

### Monetization Gate

Ads and IAP work reliably, purchases restore correctly, and Remove Ads
entitlement persists.

### Persistence Gate

Anonymous/cloud progress and purchases survive reinstall/device/account
scenarios according to the final architecture.

### Analytics Gate

Critical product funnels and Solver metrics are observable before public
traffic begins.

### Compliance Gate

Store, privacy, advertising, and legal requirements are complete.

### QA Gate

Critical/Blocker defects are closed and release regression is passed.

------------------------------------------------------------------------

# 81. MVP Success Metrics

Exact numeric targets are TBD, but launch evaluation must measure at
least:

-   Tutorial completion rate.
-   First-level completion.
-   Early progression completion.
-   Attempts per level.
-   Restart rate.
-   Dead-end rate.
-   Hint usage.
-   Rescue usage.
-   Remaining Moves distribution.
-   Solver generation acceptance rate.
-   Board generation latency.
-   Session duration.
-   Levels per session.
-   D1 / D7 / D30 retention.
-   Coin earn/spend ratio.
-   Rewarded-Ad engagement.
-   Interstitial exposure.
-   Remove Ads conversion.
-   Coin Pack conversion.
-   Daily feature engagement.
-   Content error/report rate.

------------------------------------------------------------------------

# 82. Recommended MVP Delivery Boundary

The MVP should be treated as three internal delivery layers while
remaining one release program:

### Layer 1 --- Core Playable

Game rules + board + Stock + Associations + randomization + Solver +
Hint + Undo + win/fail.

### Layer 2 --- Production Game

Journey + Chapters + content system + tutorial + economy + persistence +
CMS + analytics + QA automation.

### Layer 3 --- Commercial Release

Ads + IAP + Shop + cloud/account + remote config + release compliance +
launch balancing + selected P1 retention features.

This layering is an implementation planning aid, not separate consumer
products.

------------------------------------------------------------------------

# 83. Decisions Required Before WBS Estimation

Still intentionally open (Final Decision Register v1.1 STILL TBD):

1.  Exact real-money prices (Remove Ads + Coin Packs).
2.  Future Pack monetization model (when Packs are introduced).
3.  Solver algorithm composition / timeout budgets after benchmarking.
4.  Final team size, roles, rates, calendar dates, commercial budget.
5.  Exact DR RPO/RTO; Firebase/GCP quotas, billing budgets, Cloud
    Functions/Cloud Run resource limits and scaling thresholds.
6.  Final ad mediation network mix; pen-test vendor; analytics cost
    thresholds.
7.  Whether Illustration Cards are launch P1 or Post-MVP (asset
    readiness).

Already decided and must not be re-opened as TBD:

-   Client: Flutter (+ Riverpod, Drift/SQLite).
-   Cloud/backend: Firebase-first MVP baseline (Auth, Firestore,
    Storage, Functions/Cloud Run, Analytics/BigQuery, Crashlytics, FCM,
    Remote Config; no Azure in MVP).
-   Launch content: 5 Chapters / 250 Levels.
-   Economy soft-currency values.
-   Daily Reward + Challenge + Streak at launch.
-   Smart Notifications: Daily Challenge + Streak Risk; quiet hours
    22:00–09:00.
-   Offline Main Journey + offline Coin spend reconciliation.
-   Remove Ads = Interstitials only; Coin Pack amounts confirmed.

------------------------------------------------------------------------

# 84. Recommended First Release Cut

**CONFIRMED** first release cut (Final Decision Register v1.1):

**P0 + Daily Reward + Daily Challenge + Daily Streak + Smart
Notifications (Daily Challenge + Streak Risk)**

with:

**Illustration/Icon Associations included only if the asset pipeline and
content production can meet quality without delaying the Core release.**

This preserves strong day-one retention while avoiding the largest
Post-MVP systems.

------------------------------------------------------------------------

# 85. Definition of MVP

For this project, MVP means:

> A polished Arabic-first Solitaire Association game that can be
> publicly released, generates fresh solver-validated boards, provides
> enough curated progression to establish retention, supports basic
> economy and monetization, preserves player progress, and produces the
> analytics needed to decide what to build next.

It does **not** mean:

-   A throwaway prototype.
-   A single fixed level pack.
-   A version without the Solver.
-   A version with incomplete game rules.
-   A version that hard-codes content in a way that prevents expansion.
-   A version containing every Full Product meta-feature.

------------------------------------------------------------------------

# 86. Next Deliverables

After approving this MVP Scope, the recommended sequence is:

1.  **Screen Inventory & User Flows**
2.  **Content Design System**
3.  **Level Design Framework**
4.  **Difficulty Model**
5.  **Solver Specification**
6.  **Game Economy Design**
7.  **Software Architecture**
8.  **Backend & Cloud Architecture**
9.  **Data Model**
10. **Analytics & KPI Specification**
11. **CMS Specification**
12. **QA & Automated Validation Strategy**
13. **MVP WBS / Product Backlog**
14. **Estimation & Delivery Roadmap**

------------------------------------------------------------------------

# 87. Baseline Status

This document is the **MVP Scope v1.0**, aligned with **Final Decision
Register v1.1**.

The scope distinguishes between:

-   Launch-critical P0 (including Daily systems and Smart Notifications
    as approved).
-   Optional P1 enhancements.
-   Post-MVP / DEFERRED (decided deferrals, not open TBD).

Progression Design detail beyond the approved launch baseline will be
created separately as
`Progression_Design_Arabic_Solitaire_Association_v1.0.md`.

**End of MVP Scope v1.0**
