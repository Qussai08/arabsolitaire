# Full Product Scope

## Arabic Solitaire Association Game

**Version:** 1.0\
**Status:** Full Product Scope Baseline — Decision-Aligned / Approved\
**Source:** Final Decision Register v1.1 + Approved GDD v1.0 and confirmed
product/game-design decisions\
**Product Type:** Endless Arabic Solitaire + Association Puzzle Game\
**Primary Language:** Arabic\
**Scope Principle:** This document defines the intended **full
product**. It is not the MVP cut.
**Note:** Detailed progression formulas and wave presentation beyond the
approved baseline belong to Progression Design
(`Progression_Design_Arabic_Solitaire_Association_v1.0.md`) when created.

------------------------------------------------------------------------

# 1. Purpose

This document translates the approved Game Design Document into the
complete product scope required to build, operate, monetize, expand, and
maintain the game as a live product.

The full product combines:

-   Solitaire card-management gameplay.
-   Arabic association and semantic puzzles.
-   Endless randomized levels.
-   Solver-validated boards.
-   Progression and chapters.
-   Economy and rewards.
-   Daily engagement systems.
-   Events and permanent content packs.
-   Achievements, collections, badges, XP, and player levels.
-   Leaderboards.
-   Ads and in-app purchases.
-   Anonymous cloud save and optional account linking.
-   Content generation, moderation, and publishing tools.
-   Analytics, LiveOps, remote configuration, and operational tooling.

Any item explicitly marked **TBD** remains undecided and must not be
treated as an approved product rule.

------------------------------------------------------------------------

# 2. Product Goals

The full product shall:

1.  Deliver a fast, understandable Solitaire loop with strategic depth.
2.  Make Arabic association discovery a first-class game mechanic rather
    than a translated content layer.
3.  Support effectively endless progression without requiring a
    handcrafted fixed board for every attempt.
4.  Keep randomized boards fair through solver validation.
5.  support both Board Difficulty and Semantic Difficulty independently.
6.  Maintain a predominantly text-based experience while supporting
    illustration/icon, emoji, number, and symbol associations.
7.  Provide sustainable retention through progression, daily systems,
    events, and content expansion.
8.  Monetize without introducing a mandatory Lives/Energy gate.
9.  Support continuous content production through AI-assisted generation
    plus human validation.
10. Provide the operational tooling required to run the game as a
    long-lived product.

------------------------------------------------------------------------

# 3. Product Surfaces

The full product consists of the following major surfaces:

-   Player game client.
-   Core game engine.
-   Level generation and randomization engine.
-   Solver and hint engine.
-   Content library and content selection engine.
-   Player progression system.
-   Economy and wallet.
-   Daily systems.
-   Events and permanent packs.
-   Achievements, badges, and collections.
-   Leaderboards.
-   Ads and IAP layer.
-   Authentication and cloud-save layer.
-   Notification system.
-   Analytics and experimentation layer.
-   LiveOps / Remote Config.
-   Content Management System / Admin Portal.
-   Backend services and data storage.
-   Asset delivery pipeline.
-   Customer-support and operational tooling.

The approved client/backend baseline (Final Decision Register v1.1):

-   Mobile client: **Flutter** (Riverpod; Drift/SQLite; portrait; iOS 15+;
    Android 8 / API 26+; responsive tablet support).
-   Cloud/backend: **Firebase-first / serverless-first** — Firebase Auth
    (anonymous-first); Cloud Firestore for suitable player/progression/
    Daily/sync/config docs; Firebase Storage for remote content bundles;
    Cloud Functions and/or Cloud Run for wallet, IAP validation, Daily
    eligibility, Admin privileged ops, and anti-abuse; GitHub Actions;
    DEV/TEST/STAGING/PROD.
-   Game Engine / Solver / Main Journey generation primarily **on-device**.
-   No Kubernetes, Redis, message broker, always-on relational DB, or
    Azure infrastructure in the MVP baseline.
-   ASP.NET Core + PostgreSQL is **DEFERRED** unless Firebase-first
    proves insufficient (Register §13 / §13A SUPERSEDED).

Exact Firebase/GCP quotas, billing budgets, Cloud Functions/Cloud Run
resource settings, and DR RPO/RTO remain **TBD** operational tuning.
Solver algorithm composition/timeouts remain **TBD** tuning.

------------------------------------------------------------------------

# 4. Core Game Experience

## 4.1 Level Session

A normal Main Journey session shall support:

1.  Player selects/continues the next level.
2.  Level configuration and content are loaded.
3.  All Association and Member Cards are assembled.
4.  Cards are fully randomized.
5.  Tableau and Stock are dealt.
6.  Association Slots start empty.
7.  Solver validates solvability and difficulty.
8.  Invalid generated boards are rejected and reshuffled.
9.  Player plays until:
    -   all cards are cleared and the level is won;
    -   Moves reach zero and a rescue flow is offered;
    -   a dead end is detected and a rescue flow is offered;
    -   the player restarts or exits.
10. Rewards and progression are processed on successful completion.

## 4.2 Board Components

The playable board shall include:

-   Variable number of Tableau Columns.
-   Variable cards per Tableau Column.
-   One initial face-up card per column.
-   Remaining initial Tableau cards face-down.
-   Stock with variable size.
-   A three-card visible Stock window.
-   Variable number of Association Slots.
-   Move counter.
-   Coin/streak feedback.
-   Hint control.
-   Undo control.
-   Restart and session controls.
-   Level/progression information.

Locked Association Slots, keys, crowns, or similar mechanics are **not
part of the approved core scope at this stage**.

------------------------------------------------------------------------

# 5. Card and Association Model

## 5.1 Functional Card Types

The game shall support:

### Association Card

A text-only semantic clue representing the relationship the player must
discover.

### Member Card

A card belonging to one target relation for the current level.

## 5.2 Member Content Types

Member Cards may be:

-   Text.
-   Number.
-   Symbol.
-   Emoji.
-   Illustration/Icon.

Text shall remain the dominant content type across the Main Journey.

## 5.3 Association Homogeneity

Every individual Association shall use a single Member content type.

A level may contain multiple Associations of different content types.

## 5.4 Association Clues

Association Cards shall always be textual, even when their Member Cards
are visual.

The visible clue should normally be a concise semantic clue, often one
or two words.

Examples:

-   `أجنحة` instead of `أشياء لها أجنحة`.
-   `البحر الأحمر` instead of `دول تطل على البحر الأحمر`.
-   `ض` instead of `كلمات تبدأ بحرف الضاد`.
-   `مطار` instead of `أشياء تجدها في المطار`.

The full intended relation shall be stored internally for validation and
content management but shall not normally be shown during play.

## 5.5 Relation Flexibility

The same visible clue may represent different relations in different
puzzles.

The same word may belong to different relations within the global
Content Library, but each card instance in a level shall have one target
Association.

Identical word cards shall not currently be intentionally duplicated
within the same level with different target Associations.

------------------------------------------------------------------------

# 6. Tableau Rules

The full product shall implement the approved Tableau behavior:

-   Each column begins with one face-up card.
-   Removing the exposed movable unit automatically flips the next
    face-down card.
-   An empty column is a free Tableau space.
-   Any valid movable unit may be placed in an empty column.
-   A Member Card may be stacked on another Member Card only when both
    belong to the same Association.
-   Same-Association Word Stacks may merge.
-   A formed Stack is atomic and cannot be split.
-   Internal card order within a Stack has no gameplay significance.
-   A complete Stack moves as one unit and consumes one Move.
-   Association Cards in the Tableau are not active Associations.
-   An Association Card may be placed on a Member Card/Stack belonging
    to its relation.
-   A Member Card/Stack may not be placed on an Association Card while
    that Association Card remains in the Tableau.
-   Once an Association Card joins a Stack in the Tableau, no additional
    cards may be added to that Stack while it remains there.
-   That Association Stack remains movable as one atomic unit.

------------------------------------------------------------------------

# 7. Association Slot Rules

Association Slots shall:

-   Start empty.
-   Accept an Association Card when a slot is available.
-   Convert that Association Card into an Active Association.
-   Accept a compatible single Member Card or compatible Member Stack.
-   Accept a combined Association Stack moved from the Tableau.
-   Count all compatible Member Cards transferred within a Stack
    immediately.
-   Treat the entire Stack transfer as one Move and one correct streak
    action.
-   Automatically complete when the required Members are present.
-   Remove the completed Association and its Members.
-   Immediately free the slot for another Association.

Completion shall occur only in an Association Slot, never merely because
all Member Cards have been assembled in the Tableau.

------------------------------------------------------------------------

# 8. Player Choice and Move Validation

The game shall not force an optimal move.

If several valid moves exist, the player may choose any of them.

The Game Engine is responsible for determining whether an attempted
action is valid under the game rules.

The Solver is responsible for determining whether game states and move
paths can lead to completion.

Invalid actions shall:

-   Be rejected.
-   Return the card/unit to its prior state.
-   Consume no Move.
-   Reset the current correct-move streak counter.
-   Never reduce the unlocked streak tier.

------------------------------------------------------------------------

# 9. Stock System

The Stock shall:

-   Contain both Association Cards and Member Cards.
-   Have a size configured per level.
-   Display the last three currently exposed Stock cards.
-   Allow only the final/top playable card in that visible sequence to
    move.
-   Expose the preceding visible card when the playable card is removed.
-   Support cycling through the Stock.
-   Support unlimited Restore Stock operations.
-   Preserve the order of remaining Stock cards when restored.
-   Never reshuffle merely because the Stock is restored.

Stock cycling and Restore Stock each consume a Move.

Both are neutral for the correct-move streak.

------------------------------------------------------------------------

# 10. Move System

Each Main Journey level shall have a fixed Move Limit.

The Move Limit shall remain unchanged when the player restarts the same
level.

Actions consuming one Move include:

-   Cycling the Stock.
-   Restoring the Stock.
-   Moving a card between Tableau locations.
-   Moving a Stack.
-   Moving an Association Card to an Association Slot.
-   Moving a Member Card/Stack to an Active Association.
-   Moving an Association Stack to an Association Slot.

A Stack always costs one Move regardless of the number of cards
contained within it.

Rejected invalid actions consume no Move.

------------------------------------------------------------------------

# 11. Undo System

Undo shall:

-   Revert only the most recent eligible Move.
-   Restore the Move consumed by that action.
-   Be usable only once consecutively.
-   Require a new Move before Undo can become available again.
-   Be unavailable if the most recent Move completed and removed an
    Association.

The exact economy/access model for Undo beyond the base behavior: Undo
is free (no Coin cost). No additional paid Undo model is approved.

------------------------------------------------------------------------

# 12. Hint System

Hints shall:

-   Not execute moves automatically.
-   Return a clear textual instruction describing a recommended action.
-   Support suggestions involving Tableau moves, Association moves,
    Stack moves, and Stock cycling.
-   Be powered by the Solver rather than by random valid-move selection.
-   Consume no Move.
-   Consume one Hint resource from the player's available Hint balance.

When Hint resources are unavailable, additional Hints may be obtained
using:

-   Coins.
-   Rewarded Ads.

**CONFIRMED** economy values (Final Decision Register v1.1):

-   Starting Hints: 3.
-   Hint Coin price: 75.
-   Rewarded Ad → 1 Hint.

------------------------------------------------------------------------

# 13. Dead-End Detection and Rescue

The game shall automatically detect when the current state is no longer
solvable.

When a dead end is detected, the game shall stop wasting the player's
remaining Moves and present rescue options.

Supported full-product rescue capabilities:

-   Undo when the last action is eligible.
-   Dead-End Rescue: **Solver-Guided Recovery State** (preserve completed
    progress as much as possible; guarantee a winning continuation).
-   Coin-funded rescue: **200 Coins**; max **1** per Attempt.
-   Rewarded-Ad rescue.

**No separate Mid-Level Reshuffle in MVP** (Post-MVP / DEFERRED).

Any rescue implementation must preserve game fairness and must not
silently create an invalid board.

------------------------------------------------------------------------

# 14. Out-of-Moves Flow

When the Move counter reaches zero before completion:

-   Gameplay pauses.
-   The player receives an Extra Moves offer.
-   Extra Moves may be obtained through Coins and/or Rewarded Ads.
-   Accepting the rescue continues the current board.
-   Declining the rescue allows the failed attempt to end/restart.

**CONFIRMED** Extra Moves (Final Decision Register v1.1):

-   Grant: **+5 Moves**.
-   First rescue: **150 Coins**; second: **250 Coins**.
-   Max **2** Extra-Move rescues per Attempt.
-   Rewarded Ads supported for Extra Moves.

------------------------------------------------------------------------

# 15. Win Condition

A level is won only when all cards have been cleared:

-   No unresolved Tableau cards.
-   No remaining Stock cards.
-   No incomplete Associations.

Completing an individual Association does not complete the level unless
all other cards are also cleared.

------------------------------------------------------------------------

# 16. In-Level Streak Reward System

The product shall implement the approved correct-move streak:

-   3 consecutive correct actions → 3 Coins.
-   Unlock Tier 4.
-   4 consecutive correct actions → 4 Coins.
-   Unlock Tier 5.
-   5 consecutive correct actions → 5 Coins.
-   Remain at Tier 5.
-   Every subsequent set of 5 consecutive correct actions → 5 Coins.

A wrong action resets only the current counter, not the unlocked tier.

Correct streak actions include:

-   Member Card → compatible Member Card.
-   Member Stack → compatible Member Card/Stack.
-   Association Card → compatible Member Stack.
-   Association Card → Association Slot.
-   Member Card/Stack → compatible Active Association.
-   Association Stack → Association Slot.

Neutral actions include:

-   Stock cycling.
-   Restore Stock.
-   Moving a card/Stack to an empty Tableau column.

An invalid rejected action is a wrong streak action.

------------------------------------------------------------------------

# 17. Level Completion Rewards

Successful Main Journey completion shall award:

### Base Reward

`50 Coins`

### Remaining Move Reward

`2 Coins × Remaining Moves`

### In-Level Streak Rewards

Coins already earned through the correct-move streak.

The full reward formula may later incorporate explicitly approved event,
achievement, or progression bonuses without changing the core reward
rules above.

------------------------------------------------------------------------

# 18. Level Generation

## 18.1 Level Configuration

Each level definition shall be capable of specifying at least:

-   Number of Associations.
-   Required Member count per Association.
-   Group-size mix.
-   Number of Tableau Columns.
-   Cards per Tableau Column.
-   Stock size.
-   Number of Association Slots.
-   Fixed Move Limit.
-   Board Difficulty target/range.
-   Semantic Difficulty target/range.
-   Eligible content.
-   Additional generation constraints where later approved.

## 18.2 Full Randomization

For each attempt:

-   All Association and Member Cards are included in the randomization
    pool.
-   Cards are redistributed across Tableau and Stock.
-   Initial face-up cards are not type-constrained.
-   Association Slots begin empty.
-   The first attempt is randomized.
-   Every Restart performs a new full randomization.
-   Random duplicate boards are not explicitly prevented.

## 18.3 Validation Pipeline

A generated board shall not be shown until it passes:

`Configuration → Content Selection → Card Pool → Shuffle → Deal → Solver → Difficulty Validation → Accept`

Boards failing validation shall be reshuffled/regenerated.

------------------------------------------------------------------------

# 19. Solver Scope

The Solver is a core product subsystem.

It shall support:

## 19.1 Solvability Validation

Determine whether a generated board can be completed.

## 19.2 Move-Bounded Validation

Determine whether completion is possible within the level's fixed Move
Limit.

## 19.3 Difficulty Evaluation

Provide metrics that can be used to reject boards that are too easy or
too difficult for the intended level.

## 19.4 Hint Generation

Return a safe/useful next action from the current game state.

## 19.5 Dead-End Detection

Determine whether the current player state still has any completion
path.

## 19.6 Generation Support

Enable repeated generation until an acceptable board is found.

Solver implementation, algorithms, state representation, pruning,
caching, performance targets, and optimality requirements belong to the
dedicated Solver Specification and are **TBD**.

------------------------------------------------------------------------

# 20. Difficulty System

Difficulty shall have two independently controlled dimensions.

## 20.1 Board Difficulty

Potential inputs include:

-   Number of Associations.
-   Group sizes.
-   Tableau column count.
-   Tableau depths.
-   Stock size.
-   Association Slot pressure.
-   Move Limit.
-   Solver-required move count.
-   Required Stock cycles.
-   Branching factor.
-   Dead-end risk.
-   Hidden-card accessibility.

## 20.2 Semantic Difficulty

Potential inputs include:

-   Directness of the relation.
-   Familiarity of Member Cards.
-   Ambiguity.
-   Required general knowledge.
-   Clue abstraction.
-   Linguistic manipulation.
-   Wordplay.
-   Similarity to competing Associations.

## 20.3 Difficulty Waves

Progression shall use difficulty waves rather than strict linear
increase.

**CONFIRMED** structure (Final Decision Register v1.1):

-   Standard Chapter size: 50 Levels.
-   Difficulty structure: **10-Level Wave × 5** per Chapter.
-   Long-term difficulty rises while local waves provide relief.
-   Group-size progression: groups of **3** first → **4** become
    standard → **5**/mixed introduced later.
-   Sequential unlocking: complete Level N to unlock Level N+1.

The system shall support combinations such as:

-   Easy Board + Easy Semantics.
-   Easy Board + Hard Semantics.
-   Hard Board + Easy Semantics.
-   Hard Board + Hard Semantics.

Exact numeric scoring formulas remain balancing work; detailed wave
templates belong to Progression Design / Difficulty Model documents.

------------------------------------------------------------------------

# 21. Semantic Ambiguity

Advanced levels may intentionally include Member Cards that appear
plausible for more than one Association present on the board.

Requirements:

-   Every card instance still has one correct target.
-   The intended solution must remain fair and inferable.
-   Ambiguity must be deliberate, reviewed, and difficulty-rated.
-   Ambiguity must not rely on an arbitrary hidden interpretation with
    no reasonable player signal.

------------------------------------------------------------------------

# 22. Endless Main Journey

The Main Journey shall be endless in progression design.

Level numbering shall continue without a designed final level.

**CONFIRMED** launch content baseline (Final Decision Register v1.1):

-   Launch: **5 Chapters = 250** Level Definitions.
-   Standard Chapter size: **50** Levels.
-   Main Journey includes a simple **“Report a problem”** action from
    launch.

The product shall support ongoing addition/generation of content and
levels without changing the core progression model.

------------------------------------------------------------------------

# 23. Chapters

The Main Journey shall be organized into Chapters.

Standard Chapter size:

`50 Levels`

Special Chapters may use different sizes when deliberately configured.

Chapters shall contain mixed subject matter rather than a single
mandatory theme.

Their primary role is:

-   Progress organization.
-   Milestones.
-   Presentation.
-   Reward opportunities.
-   Long-term journey structure.

Chapter completion reward (**CONFIRMED**):

`500 Coins + 2 Hints`

------------------------------------------------------------------------

# 24. Content Philosophy

Main Journey content shall be:

-   Arabic-first.
-   Broadly understandable across Arabic-speaking markets.
-   Primarily evergreen.
-   Mixed in subject matter.
-   Progressive in semantic difficulty.
-   Culturally appropriate.
-   Reviewed for fairness.
-   Capable of supporting both linguistic and general-knowledge
    associations.

Contemporary/time-sensitive content shall primarily live in Events and
Special Packs.

------------------------------------------------------------------------

# 25. Arabic Content System

The product shall support Arabic-specific puzzle opportunities
including:

-   Multiple meanings.
-   Roots.
-   Letters.
-   Selective diacritics.
-   Common phrases.
-   Prefix/suffix relationships.
-   Synonyms.
-   Antonyms.
-   Singular/plural relationships.
-   Loanwords.
-   Linguistic patterns.
-   Dialect-specific content in appropriate Packs/Events.

Arabic diacritics shall be omitted by default and used only where
required to disambiguate meaning.

Foreign terms shall use the display form most familiar to Arabic users
rather than enforcing universal transliteration or original-language
spelling.

------------------------------------------------------------------------

# 26. Relation Types

The Content System shall not be limited to simple categories.

It shall support relations such as:

-   Semantic categories.
-   Shared characteristics.
-   Common contexts.
-   Common phrases.
-   Prefix relations.
-   Suffix relations.
-   Letter-based relations.
-   Wordplay.
-   Linguistic patterns.
-   Numeric relationships.
-   Symbol relationships.
-   Visual associations.

The extensible relation taxonomy shall be defined in the Content Design
System.

------------------------------------------------------------------------

# 27. Visual Content

Visual Member Cards shall:

-   Use illustrations/icons rather than real photographs.
-   Contain no text label on the card.
-   Be immediately recognizable.
-   Not intentionally derive difficulty from poor or ambiguous artwork.
-   Follow a consistent art direction.

Association Cards remain text clues.

**CONFIRMED** content presentation (Final Decision Register v1.1):

-   Text remains the dominant content type.
-   Early/mid Levels: max one visual Association per Level.
-   Illustration content introduced gradually after tutorial/early
    Levels.

Main Journey may include evergreen historical/scientific/educational
figures where appropriate.

Contemporary celebrities and brands shall remain outside the standard
Main Journey and may be considered for Events/Packs subject to content
and rights review.

------------------------------------------------------------------------

# 28. Content Generation Pipeline

Content production shall use:

**AI-assisted generation + human validation.**

AI-generated content shall never be automatically published to
production without validation.

The full content workflow shall support:

1.  Idea/relation generation.
2.  Candidate clue generation.
3.  Member-set generation.
4.  Arabic language validation.
5.  Semantic validation.
6.  Duplicate and near-duplicate detection.
7.  Ambiguity analysis.
8.  Difficulty estimation.
9.  Cultural/content review.
10. Human approval/rejection/editing.
11. Versioning.
12. Publication to the Content Library.
13. Retirement/deprecation when required.

------------------------------------------------------------------------

# 29. Content Library

The Content Library shall support structured entities for at least:

-   Clues.
-   Full relations.
-   Member concepts.
-   Display variants.
-   Content type.
-   Arabic display text.
-   Optional aliases.
-   Optional diacritics.
-   Illustration/icon references.
-   Semantic difficulty.
-   Relation type.
-   Regional/dialect applicability.
-   Evergreen/contemporary classification.
-   Review status.
-   Approval history.
-   Reuse metadata.
-   Usage history.
-   Content version.
-   Active/inactive status.

The exact data model belongs to the Content/Data Model specifications.

------------------------------------------------------------------------

# 30. Association and Word Reuse

The same Association concept may reappear in later levels using
different Member sets.

The system should support large Member pools and difficulty-tiered
variants.

The same Member word/concept may participate in multiple global
relations.

**CONFIRMED** reuse rules (Final Decision Register v1.1):

-   Same Association Clue reuse cooldown: at least **20 Levels**.
-   Exact same Variant cannot repeat inside the same Chapter.

------------------------------------------------------------------------

# 31. Tutorial and Onboarding

The full product shall use both:

-   Concise explanatory onboarding.
-   Interactive tutorial gameplay.

Tutorial content shall progressively teach the core mechanics rather
than present all rules in a single information dump.

Tutorial coverage should include at least:

-   Goal of Associations.
-   Tableau movement.
-   Same-group stacking.
-   Atomic Stack behavior.
-   Association Cards.
-   Association Slots.
-   Stock behavior.
-   Move Limit.
-   Correct streak rewards.
-   Undo.
-   Hints.
-   Completion.

Exact tutorial level count and sequencing are **TBD**.

------------------------------------------------------------------------

# 32. No Lives / Energy Gate

The game shall not use a Lives or Energy system that prevents continued
play after failure.

Players may restart and continue playing without waiting for a timer.

Monetization shall therefore rely on optional utility, convenience,
cosmetics, ads, and purchases rather than mandatory play-time gating.

------------------------------------------------------------------------

# 33. Player Economy

## 33.1 Currency

The approved core soft currency is:

**Coins**

## 33.2 Coin Sources

Coin sources may include:

-   Base level completion reward.
-   Remaining Moves conversion.
-   Correct-move streak rewards.
-   Daily Rewards.
-   Daily Challenge.
-   Daily Streak.
-   Achievements.
-   Events.
-   Collections/milestones.
-   Rewarded Ads.
-   Purchases where applicable.

## 33.3 Coin Sinks

Coins shall be usable for:

-   Hints.
-   Extra Moves.
-   Dead-End Rescue (Solver-Guided Recovery).
-   Cosmetics / Themes (**Post-MVP / DEFERRED** unless later approved).

**No Mid-Level Reshuffle sink in MVP.**

**CONFIRMED** soft-currency values (Final Decision Register v1.1):

-   Starting Coins: 300; Starting Hints: 3.
-   Hint: 75 Coins.
-   Extra Moves +5: 150 then 250; max 2/Attempt.
-   Dead-End Rescue: 200; max 1/Attempt.
-   Rewarded Coin Ad: 100; cap 3/day.
-   Chapter completion: 500 Coins + 2 Hints.
-   Daily Reward / Streak / Challenge values as in Sections 34–36.
-   Coin Pack amounts: 1,000 / 3,000 / 7,000 / 15,000.
-   No Starter Pack / Subscription / Premium Currency.

Real-money prices for Remove Ads and Coin Packs remain **TBD**.

------------------------------------------------------------------------

# 34. Daily Reward Calendar

The product shall contain a Daily Reward Calendar.

**CONFIRMED** (Final Decision Register v1.1):

-   7-day repeating calendar.
-   Day 1: 100 Coins; Day 2: 125; Day 3: 150; Day 4: 1 Hint; Day 5: 175;
    Day 6: 200; Day 7: 300 Coins + 1 Hint.
-   Missing a day does **not** reset Daily Reward progression.
-   Backend authoritative for Daily time/eligibility.

It shall support:

-   Daily claim eligibility.
-   Reward sequencing.
-   Claim state.
-   Analytics.
-   Remote configuration.

------------------------------------------------------------------------

# 35. Daily Streak

The product shall reward consecutive-day engagement.

**CONFIRMED** (Final Decision Register v1.1):

-   Daily Streak breaks after a missed day.
-   Milestones: 3 → 100 Coins; 7 → 250; 14 → 400; 30 → 750.
-   Streak-at-risk notifications are an approved launch notification
    type.

The system shall support:

-   Current daily streak.
-   Best streak.
-   Streak rewards.
-   Streak milestones.
-   Streak-at-risk notifications.
-   Configurable grace/recovery rules only if later approved
    (**Post-MVP / DEFERRED** by default).

------------------------------------------------------------------------

# 36. Daily Challenge

The product shall contain one Daily Puzzle.

**CONFIRMED** (Final Decision Register v1.1):

-   Reward: **150 Coins** auto-granted on **first completion**.
-   Unlimited retries during the valid day.
-   Fixed deterministic board per challenge cohort.
-   Reset: **00:00** validated player-local timezone.
-   Backend authoritative for Daily time/eligibility.
-   Leaderboard integration is **Post-MVP / DEFERRED**.

The intended capability includes:

-   A defined daily board/challenge.
-   A shared challenge configuration for players.
-   Special completion reward.
-   Daily reset.
-   Completion history.
-   Analytics.

------------------------------------------------------------------------

# 37. Player XP and Player Level

**Post-MVP / DEFERRED**

Player XP/Level is part of the long-term full-product vision but is
**not** required for launch and is explicitly deferred.

Exact XP formula and rewards remain open if/when the feature is
scheduled.

Player Level (meta) is separate from Main Journey Level Number.

------------------------------------------------------------------------

# 38. Achievements

**Post-MVP / DEFERRED**

Achievements are deferred from launch. Exact catalogue, tiers, rewards,
and platform integration remain open when scheduled.

------------------------------------------------------------------------

# 39. Badges

**Post-MVP / DEFERRED**

Badges are deferred with meta-progression. Presentation, rarity, profile
display, and rewards remain open when scheduled.

------------------------------------------------------------------------

# 40. Collections

**Post-MVP / DEFERRED**

Collections are deferred. Exact collectible object, album structure,
completion reward, and relationship to content remain open when
scheduled.

------------------------------------------------------------------------

# 41. Cosmetics and Themes

**Post-MVP / DEFERRED** (paid Cosmetics unless later approved)

The full product may later support cosmetic/theme spending as a Coin
sink. Potential surfaces include card backs, board backgrounds, Slot
presentation, UI themes, and non-gameplay visual customization.

No cosmetic shall alter core game rules unless explicitly approved.

Catalogue and unlock model remain open when scheduled.

------------------------------------------------------------------------

# 42. Events

**Post-MVP / DEFERRED** for major temporary Event system until
post-launch (Final Decision Register v1.1).

When introduced:

-   First Event only after Daily systems and core metrics are stable.
-   Initially max one major Event active at a time.
-   First Event: 10 Levels; core rules only; no new currency; no
    leaderboard.

Exact later cadence/formats remain open when scheduled.

------------------------------------------------------------------------

# 43. Permanent Special Packs

**Post-MVP / DEFERRED** for permanent Special Packs at initial
introduction.

Future Pack monetization model remains **TBD** (free / Coin unlock /
real-money). No paid Pack at initial introduction.

------------------------------------------------------------------------

# 44. Leaderboards

**Post-MVP / DEFERRED**

Leaderboards are deferred from launch. No Friends system or PvP mode is
approved.

------------------------------------------------------------------------

# 45. Account and Identity

The game shall allow immediate play without mandatory registration.

**CONFIRMED** identity model (Final Decision Register v1.1):

-   Anonymous-first via **Firebase Authentication**; anonymous Firebase
    user created first; cloud anonymous profile at first connection.
-   Optional Apple/Google provider linking to the same logical player
    identity whenever valid.
-   If provider already linked elsewhere: explicit conflict flow; no
    silent automatic merge.

------------------------------------------------------------------------

# 46. Cloud Save

Cloud Save shall preserve durable player state, including at minimum:

-   Main Journey progress.
-   Chapter progress.
-   Currency / wallet.
-   Hints/resources.
-   Daily-system state.
-   Purchase entitlements.
-   Settings where appropriate.
-   Post-MVP meta state when those systems exist.

**CONFIRMED** policies (Final Decision Register v1.1):

-   Active Attempt persistence: local-first.
-   Domain-specific conflict: Progression → highest valid; Wallet →
    server-authoritative ledger; Purchases → store/backend
    authoritative; Settings → latest revision; Active Attempt →
    local/device-specific.

------------------------------------------------------------------------

# 47. Offline Capability

**CONFIRMED** (Final Decision Register v1.1):

-   Main Journey fully playable offline once required content is
    downloaded.
-   Offline Coin spending allowed against locally reconciled balance
    via queued idempotent transactions for later reconciliation.
-   Purchases and Rewarded Ads require network.

Offline behavior must not create exploitable duplicate rewards or
corrupted progression.

------------------------------------------------------------------------

# 48. Notifications

**CONFIRMED** launch Smart Notifications (Final Decision Register
v1.1):

-   Infrastructure included at launch.
-   Initially active types: **Daily Challenge** and **Streak Risk**
    only.
-   Quiet hours: **22:00–09:00** player-local time.
-   Richer notification types beyond these are **Post-MVP / DEFERRED**.

Requirements include opt-in/permission handling, localization, deep
linking, frequency controls, and analytics.

Exact notification copy remains a UX/localization task.

------------------------------------------------------------------------

# 49. Rewarded Advertising

Rewarded Ads shall be optional and may provide:

-   Extra Moves.
-   Hints.
-   Dead-End Rescue.
-   Coins.

**CONFIRMED** values:

-   Rewarded Coin Ad: **100 Coins**; cap **3/day**.
-   Ads stack: Google AdMob + Mediation (mediation network mix **TBD**).

Requirements include clear reward disclosure, verification, failure
handling, and analytics.

------------------------------------------------------------------------

# 50. Interstitial Advertising

The product shall use adaptive Interstitial Ads.

**CONFIRMED** (Final Decision Register v1.1):

-   Adaptive; baseline around every **3–5** completed Levels.
-   Max **3** Interstitials per session.
-   Suppress immediately after Rewarded Ad, purchase, tutorial,
    failure, Dead-End, or Out-of-Moves decline.
-   Suppress for Remove Ads entitlement.

------------------------------------------------------------------------

# 51. In-App Purchases

Approved IAP categories are:

-   Remove Ads.
-   Coin Packs (amounts **1,000 / 3,000 / 7,000 / 15,000**; real-money
    prices **TBD**).

**CONFIRMED:** No Starter Pack; No Subscription; No Premium Currency; No
paid randomized reward system.

IAP client: Flutter `in_app_purchase`; server-side validation via
trusted Cloud Functions / Cloud Run.

------------------------------------------------------------------------

# 52. Remove Ads Entitlement

**CONFIRMED:** Remove Ads removes **Interstitials only**.

Rewarded Ads remain available as optional reward mechanisms.

Real-money price is **TBD**.

------------------------------------------------------------------------

# 53. Shop

The full product requires a Shop surface capable of presenting approved
monetized and earnable items, including:

-   Coin Packs.
-   Remove Ads.
-   Hints/utility purchases using Coins.
-   Extra Moves/rescue options where relevant.
-   Cosmetics/Themes.

The exact information architecture and merchandising layout are **TBD**.

------------------------------------------------------------------------

# 54. Main Navigation and Screen Scope

The final UX architecture is **TBD**, but the full product requires
screens/surfaces covering at least:

-   Splash/initialization.
-   First-time onboarding.
-   Home/Main Journey.
-   Chapter/progression presentation.
-   Gameplay.
-   Level complete.
-   Failure/out-of-moves.
-   Dead-end rescue.
-   Tutorial.
-   Daily Reward.
-   Daily Challenge.
-   Events.
-   Permanent Packs.
-   Achievements.
-   Collections.
-   Badges/profile progression.
-   Leaderboards.
-   Shop.
-   Cosmetics/Themes.
-   Account/cloud-save.
-   Settings.
-   Notification preferences.
-   Language/content preferences where approved.
-   Privacy/legal.
-   Purchase restore.
-   Support/help.

Detailed Screen Inventory and User Flows shall define exact navigation
and states.

------------------------------------------------------------------------

# 55. UX Requirements

The player-facing experience shall prioritize:

-   Fast entry into gameplay.
-   RTL-first Arabic layout.
-   Clear card readability.
-   Large enough drag targets.
-   Clear valid/invalid feedback.
-   Smooth Stack movement.
-   Clear Association progress.
-   Minimal interruption on Association completion.
-   Immediate Move feedback.
-   Clear streak/reward feedback without obscuring play.
-   Accessible rescue choices.
-   Clear monetization disclosure.
-   Consistent handling of text, emoji, numbers, symbols, and
    illustrations.

Exact accessibility standard and supported device classes are **TBD**.

------------------------------------------------------------------------

# 56. Animation and Feedback

The full product requires a coherent feedback system for at least:

-   Card drag/drop.
-   Valid placement.
-   Invalid placement/rejection.
-   Card flip.
-   Stack merge.
-   Association activation.
-   Association progress.
-   Association completion/removal.
-   Coin gain.
-   Streak progress.
-   Streak reward.
-   Move decrement.
-   Undo.
-   Hint presentation.
-   Dead-end detection.
-   Level win.
-   Reward presentation.
-   Chapter milestone.
-   Achievement/badge unlock.

Exact animation style, duration, particles, haptics, and audio are
**TBD**.

------------------------------------------------------------------------

# 57. Audio and Haptics

The product shall include an audio/haptic design phase covering:

-   UI SFX.
-   Card movement.
-   Flip.
-   Correct placement.
-   Invalid placement.
-   Association completion.
-   Coin/reward feedback.
-   Win.
-   Background music if approved.
-   Haptic feedback.
-   Independent sound/music/haptic settings.

Exact implementation remains **TBD**.

------------------------------------------------------------------------

# 58. Visual Identity

Branding remains **TBD** and shall include:

-   Game name.
-   Logo.
-   App icon.
-   Color system.
-   Typography.
-   Arabic font strategy.
-   Card visual language.
-   Illustration/icon art direction.
-   Board/table presentation.
-   Chapter presentation.
-   Cosmetic theme system.
-   Marketing art direction.

The visual design must support RTL and Arabic readability from the
outset.

------------------------------------------------------------------------

# 59. Accessibility

The detailed accessibility scope is **TBD**, but the full product should
be designed to support:

-   Scalable/readable Arabic text.
-   Clear contrast.
-   Non-color-only state communication.
-   Reduced-motion consideration.
-   Sound/haptic toggles.
-   Touch-target sizing.
-   Screen-reader semantics where technically appropriate.
-   Clear visual differentiation of card states.

Accessibility decisions shall be finalized in UX/UI specifications.

------------------------------------------------------------------------

# 60. Settings

The full product shall provide settings for appropriate categories such
as:

-   Sound.
-   Music.
-   Haptics.
-   Notifications.
-   Account/cloud save.
-   Privacy.
-   Legal.
-   Restore purchases.
-   Support/help.

Additional settings are **TBD**.

------------------------------------------------------------------------

# 61. Content Management System

A CMS/Admin Portal is part of the full product scope.

**CONFIRMED** CMS baseline (Final Decision Register v1.1 §10):

-   CMS frontend: **Angular**.
-   Admin authentication: **Microsoft Entra ID** with MFA for privileged
    access.
-   Production publish permission separated from ordinary content
    editing.
-   Broad Economy / Notification changes require re-authentication and
    explicit confirmation.
-   Audit log retention: 2 years.
-   CMS accesses Firebase/GCP data and privileged operations only through
    approved security boundaries; no unrestricted client-side production
    mutation.

It shall support authorized operators in managing:

-   Clues.
-   Relations.
-   Member Cards.
-   Arabic text.
-   Aliases.
-   Diacritics.
-   Illustrations/icons.
-   Relation types.
-   Difficulty metadata.
-   Dialect/region metadata.
-   Evergreen/contemporary classification.
-   Content review workflow.
-   Approval/rejection.
-   Content versions.
-   Publication state.
-   Deactivation/retirement.
-   Packs.
-   Events.
-   Content search/filtering.
-   Duplicate review.
-   Usage visibility.

Role and permission design is **TBD**.

------------------------------------------------------------------------

# 62. AI-Assisted Content Tools

The operational content tooling should support AI-assisted workflows
for:

-   Relation ideation.
-   Clue shortening.
-   Member suggestions.
-   Difficulty suggestions.
-   Ambiguity detection assistance.
-   Duplicate/near-duplicate suggestions.
-   Language-quality checks.
-   Potential illustration prompt/asset workflows if approved.

Human approval remains mandatory before production publication.

Model/provider selection is **TBD**.

------------------------------------------------------------------------

# 63. Level Management

Admin tooling shall support management of:

-   Level configurations.
-   Difficulty profiles.
-   Move Limits.
-   Association counts.
-   Group sizes.
-   Tableau layouts.
-   Stock sizes.
-   Association Slot counts.
-   Chapter assignment.
-   Tutorial levels.
-   Special levels.
-   Generation rules.
-   Solver validation status.
-   Publishing state.

For generated Main Journey attempts, operators manage the level
template/configuration and content eligibility rather than a single
permanent board.

------------------------------------------------------------------------

# 64. LiveOps and Remote Configuration

The full product shall support remotely configurable product values
where appropriate, including:

-   Reward values.
-   Ad eligibility/frequency.
-   Rewarded-Ad grants.
-   Economy prices.
-   Daily Reward configuration.
-   Daily Challenge configuration.
-   Event activation.
-   Pack activation.
-   Notification rules.
-   Difficulty tuning parameters.
-   Feature flags.
-   Emergency feature disablement.

Changes affecting core game rules require controlled compatibility and
must not invalidate active sessions.

------------------------------------------------------------------------

# 65. Feature Flags

The product should support feature flags for safe rollout of:

-   New content types.
-   New Events.
-   Economy changes.
-   New Shop features.
-   Experimental UI.
-   New Solver/generation strategies.
-   New meta-progression features.

Exact experimentation platform is **TBD**.

------------------------------------------------------------------------

# 66. Analytics

**CONFIRMED** analytics/observability stack (Final Decision Register
v1.1):

-   Product analytics: **Firebase Analytics** with **BigQuery** export.
-   Mobile crash reporting: **Firebase Crashlytics**.
-   Backend/serverless observability: Firebase / Google Cloud native
    logs and monitoring (not Azure Application Insights / Monitor).
-   Push: **Firebase Cloud Messaging**; client Remote Config: **Firebase
    Remote Config** (authoritative sensitive configuration remains
    server-controlled where required).
-   Raw analytics retention baseline: 14 months, then cost review.

The product shall instrument the complete funnel.

Key event families shall include:

### Acquisition/Activation

-   Install/first open.
-   Tutorial start/steps/completion.
-   First level start/completion.

### Gameplay

-   Level start.
-   Generated-board metrics.
-   Move.
-   Invalid move.
-   Stack formation.
-   Association activation.
-   Association completion.
-   Stock cycle.
-   Restore Stock.
-   Undo.
-   Hint.
-   Dead end.
-   Restart.
-   Out of Moves.
-   Rescue.
-   Level complete/fail/exit.

### Difficulty

-   Solver move estimate.
-   Actual moves.
-   Remaining moves.
-   Board difficulty.
-   Semantic difficulty.
-   Restart count.
-   Hint dependency.
-   Rescue dependency.

### Economy

-   Coin source.
-   Coin sink.
-   Balance.
-   Reward claim.
-   Streak reward.

### Retention

-   Daily Reward.
-   Daily Streak.
-   Daily Challenge.
-   Chapter progression.
-   XP/Player Level.

### Monetization

-   Ad impression.
-   Rewarded-ad start/completion/reward.
-   Interstitial impression.
-   Shop view.
-   Purchase attempt/success/failure.
-   Remove Ads entitlement.

### Content

-   Association exposure.
-   Wrong association attempts.
-   Content difficulty performance.
-   Content complaints/reporting if implemented.
-   Pack/Event engagement.

A dedicated Analytics & KPI Specification shall define schemas,
properties, privacy rules, and dashboards.

------------------------------------------------------------------------

# 67. Product KPIs

Exact targets are **TBD**, but the full product shall be measurable
against categories including:

-   Tutorial completion.
-   Level completion rate.
-   Attempts per level.
-   Restart rate.
-   Dead-end rate.
-   Hint usage.
-   Extra Moves usage.
-   Average remaining Moves.
-   Session length.
-   Levels per session.
-   D1/D7/D30 retention.
-   Daily Challenge participation.
-   Daily Streak retention.
-   Event participation.
-   Coin earn/spend balance.
-   Rewarded-Ad engagement.
-   Interstitial exposure.
-   IAP conversion.
-   ARPDAU/ARPU where applicable.
-   Content error/report rate.
-   Solver rejection rate.
-   Board generation latency.

------------------------------------------------------------------------

# 68. Experimentation

The full product should be capable of controlled experiments on
non-core-rule variables such as:

-   Onboarding presentation.
-   Reward values.
-   Daily Reward structures.
-   Ad frequency.
-   Shop presentation.
-   Notification timing.
-   Cosmetic offers.
-   Difficulty-wave tuning.

Experiments must not create unfair leaderboard comparisons without
segmentation/control.

------------------------------------------------------------------------

# 69. Backend Scope

**CONFIRMED** baseline (Final Decision Register v1.1 §§6–10):

-   Firebase-first / serverless-first on Firebase / Google Cloud managed
    services; GitHub Actions; DEV/TEST/STAGING/PROD.
-   Cloud Firestore for suitable document-oriented player/progression/
    Daily/sync/config state; Firebase Storage for remote content
    bundles; Cloud Functions and/or Cloud Run for wallet, IAP
    validation, Daily eligibility, Admin privileged ops, and anti-abuse.
-   Prefer Firebase/GCP managed scaling/quotas over pre-provisioned
    always-on compute.
-   No Kubernetes / Redis / Message Broker / always-on relational DB in
    MVP by default.
-   No Azure infrastructure in the MVP baseline (Register §13A
    SUPERSEDED).
-   ASP.NET Core + PostgreSQL **DEFERRED** unless Firebase-first proves
    insufficient.
-   Exact Firebase/GCP quotas, billing budgets, Cloud Functions/Cloud Run
    resource settings, and DR RPO/RTO remain **TBD**.

Server-side capabilities include identity, cloud save, economy
integrity, purchase entitlements, Daily systems, content delivery,
remote configuration, notifications, Admin/CMS, and operational
moderation. Cloud synchronization must minimize Firestore reads/writes
and avoid per-Move cloud traffic.

------------------------------------------------------------------------

# 70. Data and State Integrity

The product shall protect integrity of:

-   Coin balances.
-   Paid entitlements.
-   Daily rewards.
-   Event rewards.
-   Leaderboard scores.
-   Cloud progress.
-   Achievement grants.
-   Rescue grants.

The exact anti-cheat/security strategy is **TBD** but shall be
proportional to business risk.

------------------------------------------------------------------------

# 71. Privacy and Compliance

The full product requires privacy/compliance design covering:

-   Anonymous identifiers.
-   Account linking.
-   Analytics consent requirements.
-   Advertising consent requirements.
-   Notification permissions.
-   Account deletion.
-   Data deletion/retention.
-   Children's/age-related requirements based on final distribution
    policy.
-   Apple/Google platform requirements.
-   Privacy policy and terms.
-   Regional requirements applicable to launch markets.

Legal interpretation and exact compliance implementation are **TBD**.

------------------------------------------------------------------------

# 72. Localization Architecture

Arabic is the primary product language.

The product architecture should avoid hard-coding content/UI in a way
that blocks future localization.

Arabic requirements include:

-   RTL layouts.
-   Arabic pluralization.
-   Arabic numeral/display policy where applicable.
-   Mixed Arabic/Latin rendering.
-   Diacritic support.
-   Correct text shaping.
-   Long-text handling.
-   Foreign-name display variants.

Whether English UI is included at launch is **TBD**.

------------------------------------------------------------------------

# 73. Asset Management

The full product requires an asset pipeline for:

-   Illustration/Icon Member Cards.
-   UI assets.
-   Cosmetics.
-   Themes.
-   Event assets.
-   Badges.
-   Collection assets.
-   Chapter presentation assets.

The system should support versioning and remote delivery where
appropriate.

**CONFIRMED** remote delivery baseline (Final Decision Register v1.1):
hybrid bundled base content + remote versioned content bundles via
**Firebase Storage** (or another Firebase/GCP-native static delivery
mechanism when justified); no separate paid CDN layer for MVP unless
measurements demonstrate a need; download → hash validate → schema
validate → rules compatibility → atomic activation; keep
last-known-valid bundle for rollback.

------------------------------------------------------------------------

# 74. Performance Requirements

Exact numeric targets are **TBD**, but the product shall be designed
for:

-   Responsive card dragging.
-   Smooth animation.
-   Fast board initialization.
-   Solver execution without blocking gameplay UX.
-   Controlled memory usage with illustration-heavy levels.
-   Reliable resume/background behavior.
-   Efficient asset caching.
-   Reasonable network use.
-   Graceful behavior on supported lower-end devices.

Solver performance shall receive dedicated benchmarking.

------------------------------------------------------------------------

# 75. Reliability

The product shall safely handle:

-   App termination during a level.
-   Background/resume.
-   Network loss.
-   Ad failure.
-   Purchase interruption.
-   Cloud-save conflict.
-   Content update during active sessions.
-   Remote-config failure.
-   Asset download failure.
-   Solver/generation timeout.
-   Corrupted/incompatible saved session.

Recovery policies are **TBD** and shall be documented before release.

------------------------------------------------------------------------

# 76. QA Scope

The full QA strategy shall cover:

-   Unit tests.
-   Game-rule tests.
-   Stack-rule tests.
-   Stock-rule tests.
-   Move accounting.
-   Streak accounting.
-   Reward calculations.
-   Undo rules.
-   Association completion.
-   Randomization.
-   Solver correctness.
-   Solver performance.
-   Generated-board validation.
-   Dead-end detection.
-   Hint correctness.
-   Economy.
-   Ads.
-   IAP.
-   Cloud save.
-   Daily systems.
-   Events.
-   Leaderboards.
-   CMS/content publishing.
-   RTL/UI.
-   Device compatibility.
-   Regression testing.

------------------------------------------------------------------------

# 77. Automated Board Validation

Because randomized solvable gameplay is foundational, automated testing
shall include large-scale generated-board simulations.

The validation framework should measure:

-   Solvability percentage before filtering.
-   Solver acceptance/rejection.
-   Minimum/reference move distribution.
-   Difficulty distribution.
-   Generation attempts per accepted board.
-   Generation time.
-   Dead-end branches.
-   Hint validity.
-   Rule invariants.
-   Move-limit compliance.

This capability is considered part of the production engineering scope,
not merely a development convenience.

------------------------------------------------------------------------

# 78. Content QA

Content QA shall validate:

-   Arabic spelling.
-   Meaning.
-   Relation correctness.
-   Clue fairness.
-   Ambiguity level.
-   Duplicate content.
-   Regional comprehensibility.
-   Cultural appropriateness.
-   Diacritics where required.
-   Foreign-term presentation.
-   Illustration correctness.
-   Illustration recognizability.
-   Difficulty classification.

Human approval remains required.

------------------------------------------------------------------------

# 79. Operational Support

The full product should provide operational visibility for:

-   Player/account lookup subject to privacy controls.
-   Purchase entitlement issues.
-   Cloud-save issues.
-   Content issue investigation (including in-game **Report a problem**
    from Main Journey at launch).
-   Event configuration (when Events exist).
-   Economy/reward incidents.
-   Version/feature-flag status.

Exact support tooling and workflows beyond the launch Report-a-problem
path remain open.

------------------------------------------------------------------------

# 80. Versioning and Compatibility

The product shall version relevant structures including:

-   Game rules where necessary.
-   Level configuration schema.
-   Content schema.
-   Content releases.
-   Save data.
-   Solver/generator version where required.
-   Remote configuration.
-   Events/Packs.

Existing active sessions and cloud saves must be handled safely across
application updates.

------------------------------------------------------------------------

# 81. Full Product Scope Modules

For planning purposes, the full product can be decomposed into the
following major modules:

1.  Core Game Engine.
2.  Card/Stack State Machine.
3.  Tableau System.
4.  Stock System.
5.  Association System.
6.  Move/Undo System.
7.  Streak Reward System.
8.  Solver.
9.  Level Generator.
10. Difficulty Engine.
11. Hint Engine.
12. Dead-End/Rescue System.
13. Main Journey.
14. Chapters.
15. Tutorial/Onboarding.
16. Arabic Content Engine.
17. Visual Content System.
18. Content Library.
19. AI-Assisted Content Pipeline.
20. Player Economy.
21. Shop.
22. Ads.
23. IAP.
24. Daily Reward.
25. Daily Streak.
26. Daily Challenge.
27. XP/Player Level.
28. Achievements.
29. Collections.
30. Badges.
31. Cosmetics/Themes.
32. Events.
33. Permanent Packs.
34. Leaderboards.
35. Identity/Account Linking.
36. Cloud Save.
37. Notifications.
38. Analytics.
39. Experimentation/Feature Flags.
40. Remote Config/LiveOps.
41. CMS/Admin Portal.
42. Backend Services.
43. Asset Delivery.
44. Settings.
45. Privacy/Legal.
46. Support/Operations.
47. QA/Automation.
48. Monitoring/Diagnostics.

------------------------------------------------------------------------

# 82. Explicitly Deferred / Not Yet Approved

The following shall not be silently added to implementation scope
without a new decision:

-   Locked Association Slots.
-   Keys.
-   Crowns.
-   Lives.
-   Energy.
-   PvP.
-   Friends system.
-   Real-photo Member Cards.
-   Mixed media within a single Association.
-   Contemporary celebrities/brands in standard Main Journey.
-   Starter IAP Bundles / Subscription / Premium Currency.
-   Mid-Level Reshuffle in MVP.
-   Mandatory login.
-   Fixed first-attempt boards.
-   Seed-history duplicate prevention.
-   Auto-play Hint behavior.
-   Split Stacks.
-   Undoing completed Associations.

**Post-MVP / DEFERRED** (Final Decision Register v1.1 §13) — not open TBD:

-   Player XP / Player Level.
-   Achievements.
-   Badges.
-   Collections.
-   Permanent Special Packs.
-   Leaderboards.
-   Richer Smart Notification types beyond Daily Challenge / Streak Risk.
-   Major temporary Event system until post-launch.
-   Paid Cosmetics unless later approved.
-   Advanced LiveOps/event economy.
-   Dedicated Redis / Message Broker / Kubernetes unless later justified.
-   ASP.NET Core + PostgreSQL / always-on relational DB unless
    Firebase-first proves insufficient.
-   Dedicated always-on backend infrastructure unless product scale or
    operational requirements justify it.

**SUPERSEDED for MVP** (Final Decision Register v1.1 §13A) — must not be
implemented as MVP baseline: Azure-heavy stack (ASP.NET Core Modular
Monolith as mandatory MVP backend; PostgreSQL as mandatory primary DB;
Azure Container Apps / Blob / Front Door/CDN / ACR / Key Vault /
Application Insights/Monitor; Bicep as mandatory IaC; DB-backed
background jobs as default).

------------------------------------------------------------------------

# 83. Product Decisions Still TBD

Intentionally left open (Final Decision Register v1.1):

### Commercial
-   Exact real-money prices for Remove Ads and Coin Packs
    (1,000 / 3,000 / 7,000 / 15,000).

### Packs
-   Future Pack monetization model (free / Coin unlock / real-money).

### Solver / Technical Tuning
-   Exact Solver algorithm composition after benchmarking.
-   Exact timeout/performance budgets.
-   Whether native optimization is ever necessary.
-   Exact backend Solver fallback rules.

### Delivery / Staffing
-   Final team size, roles, rates, calendar dates, commercial budget,
    P0/P1 delivery dates.

### Production Operations
-   Exact DR RPO/RTO values.
-   Exact Firebase / Google Cloud quotas, billing budgets, Cloud
    Functions / Cloud Run resource limits and scaling thresholds.
-   Final ad mediation network mix.
-   Final penetration-test vendor.
-   Exact analytics cost thresholds that trigger retention-policy review.

### Still open product/UX (not economy baseline)
-   Game name and brand / visual identity details.
-   Exact tutorial level count and sequencing.
-   Exact accessibility certification target.
-   Whether English UI is included at launch.

Approved economy, Daily, progression baseline, Flutter + Firebase-first
cloud stack, and offline policies above are **not** TBD.

Progression Design detail beyond the approved baseline will be created
separately as
`Progression_Design_Arabic_Solitaire_Association_v1.0.md`.

------------------------------------------------------------------------

# 84. Scope Boundaries

This document defines **what the complete product should be capable
of**.

It does not yet define:

-   What ships in MVP (see MVP Scope).
-   Implementation sequence.
-   Team size / schedule / cost (staffing TBD).
-   Story Points.
-   Detailed database schema / API contracts.
-   UI designs.
-   Real-money SKU prices (TBD).

Those belong to subsequent planning and technical documents.

------------------------------------------------------------------------

# 85. Recommended Next Deliverable

The next product deliverable should be:

**MVP Scope** (already produced) plus Progression Design when scheduled:

`Progression_Design_Arabic_Solitaire_Association_v1.0.md`

------------------------------------------------------------------------

# 86. Baseline

This document is the **Full Product Scope v1.0**, aligned with **Final
Decision Register v1.1**.

Items marked **TBD** are intentionally unresolved.

Items marked **Post-MVP / DEFERRED** are decided deferrals, not open
TBDs.

No TBD item should be interpreted as permission for engineering, design,
or product teams to choose a permanent behavior without approval.

**End of Full Product Scope v1.0**
