# CURSOR_PROJECT_CONTEXT.md
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** MASTER IMPLEMENTATION CONTEXT  
**Audience:** Cursor / AI coding agents / Engineers / Technical Leads  
**Purpose:** Provide a single implementation context so coding work follows the approved product, gameplay, narrative, architecture, quality, and scope decisions without inventing new behavior.

---

# 0. NON-NEGOTIABLE AI / CURSOR INSTRUCTIONS

Cursor must follow these rules before producing or modifying code:

1. **Do not invent product decisions.**
   - If a behavior is not explicitly approved in this context or an approved source document, treat it as `TBD`.
   - Do not silently choose a permanent product behavior.

2. **Approved decisions override older proposals.**
   - Older documents may still contain `PROPOSED`, `TBD`, Azure, ASP.NET Core, PostgreSQL, or other superseded recommendations.
   - The approved Firebase-first baseline in this file and the latest Final Decision Register wins.

3. **Gameplay rules are authoritative.**
   - UI convenience must never change game rules.
   - Solver convenience must never change game rules.
   - Analytics, Ads, IAP, narrative, or backend requirements must never change game rules.

4. **Game Engine is framework-independent.**
   - No Flutter widgets.
   - No Firebase SDK.
   - No AdMob SDK.
   - No IAP SDK.
   - No Riverpod dependency inside core Game Engine rules.

5. **Solver and Game Engine must agree.**
   - The Solver must use the same authoritative rule primitives or equivalent shared logic.
   - Engine ↔ Solver parity is release-critical.

6. **Main Journey gameplay must not depend on a network roundtrip.**
   - Engine, Solver, and Main Journey generation are primarily on-device.
   - Active gameplay should continue offline when required content is available.

7. **Do not over-engineer MVP.**
   - No Kubernetes.
   - No Redis by default.
   - No dedicated message broker by default.
   - No always-on backend infrastructure without demonstrated need.
   - No microservices for architectural fashion.

8. **Testing is part of implementation, not a later phase.**
   - Critical Game Engine rule paths require automated coverage.
   - Solver solution replay through Game Engine is mandatory.
   - Economy and purchase flows require idempotency tests.

9. **Arabic-first UX.**
   - RTL is a first-class requirement.
   - Do not design English-first screens and “flip them later”.

10. **Security-sensitive state is server-authoritative.**
    - Wallet/economy grants.
    - IAP validation.
    - purchase entitlements.
    - Daily Reward/Streak eligibility.
    - privileged Admin mutations.

11. **Do not hard-code tuning values that are expected to be configurable.**
    - Economy parameters.
    - ad frequency.
    - Daily rewards.
    - content manifests.
    - feature flags.
    - notification configuration.

12. **Ask for approval before changing any canon or approved behavior.**

---

# 1. PRODUCT IDENTITY

## Official Current Title

# **سوليتير العرب: أسطورة المعاني**

English working translation:

**Solitaire Al-Arab: The Legend of Meanings**

## Product Direction

The game is inspired by the Association Solitaire puzzle concept but must use:

- original Arabic-first product identity;
- original UI;
- original art;
- original content;
- original progression;
- original narrative;
- original features.

Do not reproduce copyrighted proprietary levels, assets, UI layouts, dialogue, or content from another game.

## Audience

- General audience.
- 13+.

## Market

- Arab world from launch direction.
- Initial rollout is staged/limited production before broader Arab-market expansion.

## Language

- Arabic-first.
- Simplified Modern Standard Arabic for main product/story copy.
- Light broadly understandable colloquial touches are allowed for Shiboub.
- Full RTL support required.

---

# 2. OFFICIAL NARRATIVE CANON

## Core Thesis

> **اللغة لا تعيش بالكلمات وحدها؛ تعيش بالمعاني والروابط التي نصنعها بينها.**

## Dar Al-Rawabit

**دار الروابط** is the living memory/network of the Arabic language.

It preserves relationships between:

- words;
- meanings;
- ideas;
- places;
- symbols;
- culture;
- memories;
- expressions;
- knowledge.

Each Chapter is a location-based Node/manifestation of the same network.

## The Distortion

**التشويش** is a conscious/intelligent force created from forgotten, weakened, abandoned, or disconnected meanings.

It can:

- sever relationships;
- create false semantic relationships;
- corrupt meaning;
- reshape Dar Al-Rawabit;
- react to the player;
- spread between Nodes.

## Main Villain

The evil sorcerer has two canonical titles:

### **عدو العرب**
The title he chose for himself.

### **المُبدِّد**
The name Arabs gave him because he scatters and destroys meanings and relationships.

His hatred is rooted in his own linguistic poverty and insecurity when confronted with the richness, depth, vocabulary, rhetoric, cultural memory, and expressive power of Arabic.

He awakened and directs The Distortion but did not create it completely.

He is a fictional individual villain.  
Never generalize his evil to real peoples, nationalities, ethnicities, or foreigners.

## Player Ability

The player has:

### **بصيرة المعنى**

The ability to perceive and restore semantic connections others cannot see.

The player earns the title:

### **أسطورة المعاني**

at the end of Chapter 5.

## Shiboub

**شيبوب** is the companion character.

Approved characteristics:

- short-statured man;
- dark-skinned;
- thick curly black hair;
- expressive;
- original fantasy/adventure interpretation;
- stylized 3D / painterly cartoon visual direction;
- strongly comedic;
- last remaining guide from the old generation of Dar Al-Rawabit guardians.

Shiboub’s guilt:

- he trusted the sorcerer;
- hosted him because he had no shelter;
- was manipulated;
- unknowingly allowed him access to Dar Al-Rawabit;
- this enabled the attack.

## Arc 1

### **صحوة الروابط**

First five Chapters:

1. **القاهرة: أول خيط**
2. **الإسكندرية: أصداء الغياب**
3. **بيروت: ما بين السطور**
4. **مراكش: متاهة المعنى**
5. **دبي: ما بعد الذاكرة**

Arc ending:
- first five Nodes repaired;
- hundreds of additional Nodes revealed;
- Dar Al-Rawabit itself is collapsing;
- Shiboub first calls the player: **يا أسطورة المعاني**.

## Chapter Narrative Settings

Location defines:
- environment;
- visual identity;
- music flavor;
- story;
- local Dar Al-Rawabit manifestation.

Location does **not** constrain every puzzle to that country/city topic.

Gameplay content remains mixed.

## Story Presentation

- Short animated story moments.
- Dialogue bubbles.
- Typical story beat: 10–20 seconds.
- Main beats: Chapter Start / Midpoint / Ending.
- Immediately skippable.
- Story Archive for replay.
- Full voice acting is not required in MVP.
- Short vocal reactions/exclamations only.

---

# 3. CORE GAMEPLAY MODEL

The game is an Association-based solitaire puzzle.

The deck contains:

- **Association Cards**
- **Member Cards**

Every card belongs to an `association_id`.

The engine must use stable IDs, not display text, to determine compatibility.

---

# 4. BOARD STRUCTURE

A Level Attempt includes:

- Tableau columns;
- hidden Tableau cards;
- one exposed top-level unit per non-empty Tableau column;
- Stock;
- Association Slots;
- fixed Move Limit;
- Association definitions;
- member cards;
- progression/economy metadata outside core rules.

Association Slots always start empty.

All Association and Member Cards start in:

- Tableau;
- Stock.

---

# 5. INITIAL DEAL RULES

Approved:

- Tableau column count varies by Level.
- Column sizes vary by Level.
- Each Tableau column begins with exactly one face-up card.
- Cards beneath are face-down.
- Initial face-up card can be any card type.
- Stock card count varies by Level Configuration.
- All cards are randomized across Tableau and Stock.
- First attempt is randomized.
- Restart generates a new shuffle.
- No player-facing seed-history feature.

---

# 6. MOVABLE UNITS

Valid movable units:

- single Member Card;
- single Association Card;
- Member Stack;
- Association Stack.

Stacks are **atomic**.

Once stacked:
- they cannot split;
- no substack movement;
- full stack move costs exactly 1 Move.

Internal Stack order is not semantically relevant.

---

# 7. TABLEAU RULES

## Empty Column

Any valid movable unit may move to an empty Tableau column.

This move:
- costs 1 Move;
- is neutral for streak.

## Member → Member / Member Stack

Valid only when same `association_id`.

## Member Stack → Member / Member Stack

Valid only when same `association_id`.

The two stacks merge atomically.

## Association Card → Matching Member / Member Stack

Valid.

Result becomes an **Association Stack**.

## Member / Member Stack → Association Card in Tableau

Invalid.

## Member / Member Stack → Association Stack in Tableau

Invalid.

## Association Stack

While in Tableau:
- inactive;
- cannot accept new Members;
- moves atomically;
- can move to empty Tableau;
- can move to empty Association Slot.

---

# 8. ASSOCIATION SLOT RULES

An Association becomes active only when:

- its Association Card;
or
- an Association Stack

is moved into an empty Association Slot.

## Association Card → Slot

Valid if slot empty.

## Association Stack → Slot

Valid if slot empty.

Attached Members immediately count toward completion.

## Member / Member Stack → Active Association

Valid only if matching `association_id`.

Entire Member Stack transfers in one Move.

---

# 9. ASSOCIATION COMPLETION

When the active Association contains all required Members:

1. Association completes automatically.
2. Association Card and Members are removed from play.
3. Slot frees immediately.
4. No confirmation.
5. No extra Move cost.
6. Win check runs.

Undo is unavailable if the last Move caused Association completion/removal.

---

# 10. TABLEAU REVEAL

When the exposed movable unit leaves a Tableau column:

- if hidden cards remain, reveal the next card automatically;
- otherwise column becomes empty.

Automatic reveal does not cost an extra Move.

---

# 11. STOCK RULES

Approved observable behavior:

- Stock displays up to the last 3 visible cards.
- Only the final/top visible card is playable.
- Removing the playable card exposes the one behind.
- Visible window shrinks naturally 3 → 2 → 1 as needed.
- Stock Advance costs 1 Move.
- Restore Stock costs 1 Move.
- Restore Stock is unlimited.
- Restore preserves the same remaining-card order.
- Restore never reshuffles.

Stock Advance and Restore are neutral for streak.

---

# 12. MOVE ACCOUNTING

Each valid gameplay action costs exactly **1 Move**:

- Stock Advance.
- Restore Stock.
- Tableau → Tableau.
- Stack → Tableau.
- Association Card → Slot.
- Member / Stack → Active Association.
- Association Stack → Slot.
- Stock playable card → valid destination.

Invalid attempt:
- costs 0 Moves;
- resets current correct-action streak counter.

---

# 13. CORRECT MOVE STREAK

Approved streak behavior:

## Correct actions

Increment streak counter:

- same-group Member stacking;
- same-group Stack merging;
- Association Card → matching Member Stack;
- Association Card → Slot;
- Member / Stack → matching Active Association;
- Association Stack → Slot.

Each action increments by 1 regardless of number of Cards moved.

## Neutral actions

Do not increment or reset streak:

- Stock Advance;
- Restore Stock;
- move to empty Tableau column.

## Invalid/rejected action

- costs 0 Moves;
- resets current streak counter.

## Reward tiers

- 3 correct → +3 Coins; tier advances to 4.
- 4 correct → +4 Coins; tier advances to 5.
- At tier 5, each subsequent set of 5 correct actions → +5 Coins and counter resets to 0/5.
- Tier never downgrades.

---

# 14. UNDO

Approved:

- only last eligible Move;
- cannot Undo twice consecutively;
- a new Move is required before another Undo;
- restores the Move spent;
- unavailable if last Move completed/removed an Association.

Undo implementation must restore all relevant gameplay state necessary for correctness.

---

# 15. HINT

Approved:

- Hint does not cost a Move.
- Hint does not execute automatically.
- Hint suggests what to do.
- Performing the suggested action costs normal Move cost.
- Hint uses Solver / safe winning continuation logic.
- Hint consumes Hint resource.

Starting Hints: **3**.

Hint Coin price: **75 Coins**.

Additional Hints may be acquired through:
- Coins;
- Rewarded Ad.

---

# 16. OUT OF MOVES / EXTRA MOVES

If Moves reach zero without winning:

- gameplay stops;
- show Out-of-Moves recovery UI.

Extra Moves:

- grant: **+5 Moves**;
- first Coin rescue: **150 Coins**;
- second Coin rescue: **250 Coins**;
- maximum **2** Extra-Move rescues per Attempt;
- Rewarded Ad may also provide Extra Moves;
- accepted rescue continues same board;
- declining ends the Attempt / leads to restart flow.

---

# 17. DEAD-END DETECTION & RESCUE

Dead-End detection is Solver-driven.

Important:

- timeout/inconclusive Solver result must not be shown as a confirmed Dead-End;
- false-positive Dead-End is critical.

Approved rescue:

## Solver-Guided Recovery State

Requirements:

- preserve completed progress as much as possible;
- create a valid recoverable state;
- guarantee a winning continuation;
- cost: **200 Coins**;
- maximum **1** per Attempt;
- Rewarded Ad option may be available.

No separate generic Mid-Level Reshuffle utility exists in MVP.

---

# 18. WIN CONDITION

Win only when **all Cards are cleared**.

Equivalent outcome:
- all Associations completed;
- Tableau empty;
- Stock empty.

---

# 19. LEVEL REWARD

Approved formula:

`Win Reward = 50 + (2 × Remaining Moves) + Streak Coins`

Base reward:
- **50 Coins**.

Remaining Move reward:
- **2 Coins per remaining Move**.

Chapter completion:
- **500 Coins + 2 Hints**.

---

# 20. LEVEL GENERATION

Main Journey generation is randomized.

Per Attempt:

1. select approved Level Configuration;
2. select valid content;
3. create card pool;
4. randomize all Association/Member cards;
5. distribute across Tableau + Stock;
6. run Solver;
7. accept only if solvable within fixed visible Move Limit;
8. validate target difficulty range;
9. otherwise regenerate/retry.

Important:
- Solver must not dynamically modify the visible Move Limit per Attempt.
- Level has a fixed visible Move Limit.
- Restart creates another random valid Attempt using the same Level definition/config/content constraints.

---

# 21. DIFFICULTY MODEL

Two independent axes:

## Board Difficulty
Mechanical/search difficulty.

## Semantic Difficulty
Difficulty of recognizing intended relationships.

Difficulty should use local waves, not monotonically rise every Level.

Launch structure:
- 5 Chapters.
- 50 Levels each.
- 250 Level Definitions.
- 10-Level Wave × 5 per Chapter.

Group-size progression:
- groups of 3 first;
- groups of 4 standard;
- groups of 5/mixed later.

Semantic ambiguity:
- only in advanced content;
- must remain fair and inferable;
- each card has one intended target within that Level.

---

# 22. CONTENT RULES

Main Journey:
- primarily evergreen;
- mixed topics;
- Arabic-first.

Time-sensitive content:
- Events / future Packs.

Association rules:
- same Association Clue reuse cooldown: minimum 20 Levels;
- exact same Variant cannot repeat in same Chapter;
- visible clue may represent different relations in different Levels;
- a Level must not contain identical word cards targeting different relations.

Content types:
- Text;
- Numbers;
- Symbols;
- Emoji;
- Image/Icon.

Within one Association:
- member content type must be homogeneous.

Across a Level:
- content types may mix;
- Text remains dominant.

Early/mid Levels:
- max one visual Association.

Illustrations:
- introduced gradually after tutorial/early Levels;
- illustration/icon only;
- no real-photo dependency.

Association Card:
- always text clue.

AI content:
- Draft only;
- human Arabic + semantic approval mandatory;
- AI never auto-publishes.

---

# 23. MAIN JOURNEY / PROGRESSION

Approved:

- Endless numerical Levels.
- Chapters.
- Standard Chapter = 50 Levels.
- Sequential unlocking.
- Complete Level N → unlock Level N+1.
- Launch = 5 Chapters / 250 Level Definitions.

Post-MVP:
- Player XP/Level.
- Achievements.
- Badges.
- Collections.
- Leaderboards.
- Permanent Special Packs.

---

# 24. DAILY SYSTEMS — INCLUDED IN INITIAL LAUNCH

## Daily Reward

7-day repeating calendar:

1. 100 Coins
2. 125 Coins
3. 150 Coins
4. 1 Hint
5. 175 Coins
6. 200 Coins
7. 300 Coins + 1 Hint

Missing a day:
- does not reset Daily Reward calendar.

## Daily Streak

Missing a day:
- breaks streak.

Milestones:
- 3 days → 100 Coins
- 7 days → 250 Coins
- 14 days → 400 Coins
- 30 days → 750 Coins

## Daily Challenge

- one Daily Puzzle;
- fixed deterministic board per challenge cohort;
- unlimited retries while active;
- 150 Coin reward;
- auto-grant on first completion;
- reset at 00:00 validated player-local timezone;
- backend authority for eligibility/time.

---

# 25. NOTIFICATIONS

Infrastructure included at launch.

Initially active notification types:
- Daily Challenge.
- Streak Risk.

Quiet hours:
- 22:00–09:00 player-local time.

Provider:
- Firebase Cloud Messaging.

---

# 26. MONETIZATION

## Rewarded Ads

Provider:
- Google AdMob + Mediation.

Rewarded use cases:
- Hint.
- Extra Moves.
- Dead-End Rescue.
- Coins.

Rewarded Coin grant:
- 100 Coins.

Rewarded Coin cap:
- 3/day.

## Interstitials

- adaptive cadence;
- baseline around every 3–5 completed Levels;
- max 3/session.

Do not show immediately after:
- Rewarded Ad;
- purchase;
- Tutorial;
- failure;
- Dead-End;
- Out-of-Moves decline.

## Remove Ads

Removes:
- Interstitial Ads only.

Does not remove:
- optional Rewarded Ads.

## IAP

Client:
- Flutter `in_app_purchase`.

Server validation required.

Coin Packs:
- 1,000
- 3,000
- 7,000
- 15,000 Coins

Exact real-money pricing:
- `TBD`.

No:
- Subscription.
- Premium Currency.
- Starter Pack in MVP.

---

# 27. CLIENT TECHNOLOGY — APPROVED

## Flutter

Primary application shell and client framework:
- bootstrap, auth, Firebase;
- content bundles;
- home / journey / settings and non-gameplay screens;
- progression, economy, monetization;
- navigation into and out of gameplay;
- persistence and analytics orchestration.

## Flame (presentation runtime — APPROVED 2.5D MVP)

Flame is the default **presentation-only** gameplay runtime for the mobile MVP:
- fixed-camera 2.5D board, cards, shadows, interaction feedback, animation, and VFX;
- lightweight chapter atmosphere behind the gameplay surface.

Flame must never implement or validate gameplay rules. Authoritative flow:

`Flame pointer intent → Dart GameplayController/GameEngine → GameTransition → authoritative GameState + events → Flame presentation`

The previous Flutter widget board remains behind `FORCE_FLUTTER2D`. Unity is a
paused future-3D experiment and is not in the current MVP runtime path. See
`docs/architecture/ADR_FLAME_2_5D_FIRST_v1.0.md`.

## Riverpod

Application/UI state management.

Core Game Engine rules must not depend on Riverpod.

## Drift / SQLite

Local persistence.

Use for:
- Active Attempt;
- content cache metadata;
- progression cache;
- sync metadata;
- settings;
- offline transaction queue;
- local versioning/migrations.

## Platform Support

- iOS 15+.
- Android 8 / API 26+.
- Portrait only.
- responsive tablet support from same application.

---

# 28. RECOMMENDED CLIENT ARCHITECTURE

Use:

- feature-first organization;
- Clean Architecture internally where it adds value;
- pure domain packages for Game Engine/Solver;
- repositories around local/cloud data;
- explicit application use cases for side-effect-heavy workflows.

Recommended high-level structure:

```text
lib/
  app/
    bootstrap/
    navigation/
    config/

  core/
    error/
    result/
    logging/
    localization/
    analytics/
    storage/
    feature_flags/

  features/
    onboarding/
    home/
    journey/
    gameplay/
    shop/
    account/
    settings/
    daily_reward/
    daily_challenge/
    story/

  content/
  economy/
  integrations/
```

Framework-independent Dart packages:

```text
packages/
  game_engine/
  game_solver/
  level_generator/
```

Do not create extra packages until a real boundary justifies them.

---

# 29. GAME ENGINE ARCHITECTURE

Preferred implementation baseline:

```text
GameState + GameAction -> GameTransition
```

`GameTransition` should expose:

- accepted/rejected result;
- new state;
- Move cost;
- domain events;
- optional Solver-check requirement;
- reason code for rejection where useful.

Recommended properties:

- deterministic;
- serializable;
- testable;
- replayable;
- UI-independent;
- side-effect-free for core transitions where practical.

Authoritative domain objects should include:

- GameState;
- GameAction;
- Card;
- MovableUnit;
- Tableau;
- Stock;
- AssociationSlot;
- StreakState;
- UndoState;
- AttemptStatus;
- GameEvent.

---

# 30. SOLVER ARCHITECTURE

Implementation:
- Pure Dart.

Execution:
- primarily on-device;
- reusable in CI/admin/backend contexts when useful.

Search direction:
- hybrid bounded search;
- canonicalization;
- memoization/transposition;
- pruning;
- benchmark algorithm variants before freezing exact algorithm.

Solver responsibilities:
- validate solvability;
- find winning continuation;
- move-bounded validation;
- Hint;
- Dead-End;
- difficulty/search metrics;
- generation acceptance.

Solver must not:
- infer semantic meaning from Arabic text;
- change gameplay rules;
- change Move Limit dynamically;
- depend on Flutter UI.

---

# 31. SOLVER / ENGINE PARITY

Release-critical invariant:

- every move returned by Solver must be accepted by Engine;
- Solver representation must faithfully represent Engine state;
- Solver solution must replay to Win through authoritative Engine;
- Game Engine rule changes require Solver parity tests.

Golden Boards should cover:
- solvable;
- unsolvable;
- exact Move Limit boundary;
- Stock/Restore loops;
- stack behavior;
- Association Stack;
- completion;
- Dead-End;
- final-Move Win.

---

# 32. FIREBASE-FIRST BACKEND — APPROVED

The MVP is intentionally:

## **Firebase-first / serverless-first / cost-conscious**

Do not reintroduce Azure-heavy or always-on backend architecture unless explicitly re-approved.

## Firebase Authentication

Use:
- Anonymous Auth first.
- Apple linking.
- Google linking.

If a provider is already linked to another player:
- explicit conflict flow;
- no silent merge.

## Cloud Firestore

Use for suitable cloud state such as:
- Player profile.
- Journey progression.
- Daily Reward state.
- Daily Streak state.
- Daily Challenge completion.
- Sync metadata.
- content manifest references.
- remote support metadata.
- wallet transaction/ledger records where designed safely.

Avoid:
- per-Move writes;
- chatty high-frequency gameplay persistence.

## Firebase Storage

Use for:
- remote versioned content bundles;
- illustration assets;
- static content artifacts where appropriate.

## Cloud Functions / Cloud Run

Trusted server-authoritative operations:

- Wallet mutations.
- Reward grants.
- IAP validation.
- purchase grants.
- entitlement reconciliation.
- Daily eligibility/claim.
- Streak updates.
- privileged Admin mutations.
- anti-abuse checks.
- notification jobs.
- scheduled server tasks.

Choose Functions vs Cloud Run based on actual runtime requirements.  
Do not create a permanent always-on service without need.

---

# 33. CLOUD SAVE / OFFLINE

Active Attempt:
- local-first in Drift;
- not synced per Move.

Cloud policies:

## Progression
Merge to highest valid progression.

## Wallet
Server-authoritative transaction/ledger logic.

## Purchases / Entitlements
Store + trusted backend authority.

## Settings
Latest valid revision.

## Active Attempt
Local/device-specific for MVP baseline.

Main Journey:
- fully playable offline after content is available.

Offline Coin spending:
- permitted against locally reconciled balance;
- write local pending idempotent transaction;
- reconcile later.

Purchases / Rewarded Ads:
- network required.

---

# 34. CONTENT DELIVERY

Hybrid:

- base content bundled with application;
- remote versioned content bundles.

Activation flow:

1. download;
2. validate checksum/hash;
3. validate schema version;
4. validate rules/content compatibility;
5. atomically activate;
6. retain previous last-known-valid version for rollback.

Do not partially activate a bundle.

---

# 35. ANALYTICS / CRASH / REMOTE CONFIG

## Firebase Analytics
Approved.

## BigQuery Export
Approved.

Raw analytics retention baseline:
- 14 months;
- review cost.

## Firebase Crashlytics
Approved.

## Firebase Remote Config
Approved for client-facing tunables.

Sensitive/authoritative configuration remains server-controlled where required.

## Backend Observability
Use Firebase / Google Cloud native logging/monitoring for serverless components.

Enable cost/budget alerts before production rollout.

---

# 36. ADMIN / CMS

Frontend:
- Angular.

Admin authentication:
- Microsoft Entra ID.
- MFA for privileged access.

Important:
- Admin frontend must not have unrestricted direct production mutation access.
- Privileged writes go through approved trusted backend boundaries.

Required CMS capabilities:

- Associations/Members/Variants CRUD.
- Arabic review.
- Semantic review.
- Level configuration.
- Solver validation.
- sample generation/playtest.
- content bundle build/publish.
- rollback.
- economy/Remote Config management.
- audit.
- essential player support.
- immediate content disable.

Production approval:
- content approval separated from Publisher action.

Broad Economy/Notification changes:
- re-authentication;
- explicit confirmation.

Audit retention:
- 2 years.

---

# 37. CONTENT AUTHORING / QA

AI:
- produces Draft only.

Human review mandatory for:
- Arabic language;
- semantic correctness;
- cultural appropriateness;
- ambiguity fairness;
- image clarity.

Player-facing Main Journey includes:
- “Report a problem” action.

---

# 38. QA SEVERITY

- S0 = Blocker.
- S1 = Critical.
- S2 = Major.
- S3 = Minor.
- S4 = Trivial.

Release blocked by:
- any S0;
- unresolved S1 affecting a core path.

---

# 39. AUTOMATED QUALITY GATES

Required:

## Game Engine
- full critical rule-path coverage;
- invariant tests;
- serialization/replay tests.

## Solver
- Golden Boards;
- solution replay;
- Engine parity;
- timeout/inconclusive safety.

## Generator
- generated board must solve;
- must fit Move Limit;
- target difficulty validation.

## Economy
- idempotency;
- duplicate grant protection;
- offline reconciliation.

## Purchases
- validation;
- restore;
- duplicate callback protection;
- entitlement correctness.

## Content
- schema;
- duplicates;
- Arabic checks;
- semantic review;
- version compatibility.

## Release Simulation

For critical templates/configs:
- 10,000+ generated boards.

Simpler configs may use lower volumes.

Do not use one vanity project-wide coverage percentage.

---

# 40. SECURITY

Before launch:

- automated security checks;
- focused external/manual penetration test for:
  - backend/serverless APIs;
  - Admin/CMS;
  - purchase/economy flows.

Protect against:

- forged Wallet grants;
- replayed purchase validation;
- duplicate reward callbacks;
- unauthorized Admin actions;
- IDOR-like player access;
- unsafe content/admin mutations;
- client-trusted economic balance;
- local clock manipulation for Daily systems.

---

# 41. DAILY TIME AUTHORITY

Player-local timezone is used for Daily UX.

Backend remains authoritative.

Reset:
- 00:00 validated player-local timezone.

Protect against:
- device clock manipulation;
- abusive timezone switching.

---

# 42. ENVIRONMENTS / CI

Required logical environments:

- DEV
- TEST
- STAGING
- PROD

CI/CD:
- GitHub Actions.

Recommended pipeline gates:

- format/lint;
- static analysis;
- unit tests;
- Game Engine tests;
- Solver Golden Boards;
- integration tests;
- generated-board smoke simulation;
- build;
- security checks;
- deployment gates.

Do not deploy directly to PROD from unreviewed branch work.

---

# 43. APP BOOTSTRAP ORDER

Recommended:

1. Flutter bindings/bootstrap.
2. load environment.
3. initialize logging.
4. initialize Firebase.
5. initialize Crashlytics.
6. initialize local Drift DB.
7. load local config/content manifest.
8. initialize Remote Config safely.
9. initialize anonymous/auth state.
10. initialize repositories.
11. initialize analytics.
12. enter app shell.

Gameplay Engine initialization should remain independent from cloud availability.

---

# 44. FIRST DEVELOPMENT ORDER

Do not start by building all screens.

Recommended execution:

## Phase 0 — Foundation
- Flutter app.
- workspace/packages.
- Riverpod.
- Drift.
- environments.
- Firebase setup.
- lint/static analysis.
- CI.
- test harness.

## Phase 1 — Game Engine
- domain models.
- authoritative rules.
- Move accounting.
- Stock.
- Tableau.
- Stacks.
- Slots.
- Streak.
- Undo.
- completion.
- Win.
- serialization/replay tests.

## Phase 2 — Solver
- state adapter.
- legal move enumeration.
- canonicalization.
- search.
- move-bounded solve.
- Hint.
- Dead-End.
- Golden Boards.
- Engine replay parity.

## Phase 3 — Level Generator
- Level Configuration.
- content selection hooks.
- random deal.
- Solver acceptance.
- difficulty metrics.
- retry/fallback.

## Phase 4 — Playable Vertical Slice
- Gameplay screen.
- drag/drop.
- animation adapter.
- one real Level flow.
- Hint.
- Undo.
- Stock.
- Out-of-Moves.
- Dead-End.
- Win.

## Phase 5 — Product Loop
- onboarding/tutorial.
- Home.
- Journey.
- Chapter map.
- local progression.
- reward presentation.
- narrative beats.

## Phase 6 — Cloud / Economy
- Firebase Auth.
- Firestore progression.
- wallet server functions.
- offline queue.
- sync.
- Daily systems.

## Phase 7 — Monetization
- AdMob.
- Rewarded.
- Interstitial.
- IAP.
- Restore.
- server validation.

## Phase 8 — CMS / Content Operations
- Angular CMS.
- review.
- publishing.
- bundle rollout.
- support.

---

# 45. REPOSITORY / WORKSPACE SHAPE

Recommended starting shape:

```text
/
  apps/
    mobile/
    admin/

  packages/
    game_engine/
    game_solver/
    level_generator/

  firebase/
    functions/
    firestore/
    storage/
    rules/
    indexes/

  docs/
    product/
    gameplay/
    architecture/
    narrative/
    qa/

  .github/
    workflows/
```

If the project begins mobile-only, `apps/mobile` may initially be root Flutter app, but package boundaries should remain clear.

Do not split every small utility into a package.

---

# 46. GAME ENGINE PACKAGE DEPENDENCY RULES

`game_engine` may depend on:
- Dart core.
- minimal pure-Dart utility/model packages if justified.

`game_engine` must not depend on:
- Flutter UI.
- Riverpod.
- Firebase.
- AdMob.
- IAP.
- Drift implementation.
- HTTP client.
- analytics SDK.

`game_solver` may depend on:
- `game_engine` public rule/domain contracts.

`level_generator` may depend on:
- `game_engine`;
- `game_solver`;
- pure content/config contracts.

---

# 47. DATA / ID RULES

Use stable IDs for:

- Player.
- Level Definition.
- Attempt.
- Association.
- Association Variant.
- Member.
- Card instance.
- Content Bundle.
- Wallet transaction.
- Purchase transaction.
- Reward grant.
- Daily Challenge definition.

Never use Arabic display string as primary identity.

---

# 48. IDEMPOTENCY RULE

Every server-authoritative economic mutation should have:

- unique operation ID / idempotency key;
- deterministic result;
- duplicate request protection;
- auditable transaction record where relevant.

Applies to:

- purchase grants;
- Coin grants;
- Hint grants;
- Daily Reward;
- Daily Challenge reward;
- Streak milestone reward;
- Rewarded Ad grant;
- utility spend reconciliation.

---

# 49. CONFIGURATION RULE

Configurable without app release where safe:

- Coin prices.
- grants.
- Daily reward table.
- ad caps/cooldowns.
- feature flags.
- notification enablement.
- content manifest.
- emergency content disable.
- non-rule tuning values.

Core gameplay rules must be versioned and should not be changed casually through Remote Config.

---

# 50. VERSIONING

At minimum version:

- app version;
- rules version;
- content schema version;
- content bundle version;
- economy config version;
- solver version if behavior affects generation metrics;
- saved-state schema version.

Persist version metadata with Attempts where needed for replay/debug/migration.

---

# 51. ANALYTICS PRINCIPLE

Analytics must not control gameplay correctness.

Track useful events for:

- onboarding;
- tutorial;
- level lifecycle;
- attempt summary;
- association completion;
- Hint;
- Undo;
- Dead-End;
- Out-of-Moves;
- Extra Moves;
- ads;
- IAP;
- economy;
- Daily systems;
- content issues;
- generation/solver performance;
- crashes.

Prefer aggregated Attempt summary over excessive per-frame/per-drag telemetry.

---

# 52. PERFORMANCE PRINCIPLE

Exact numeric budgets remain TBD until device benchmarking.

However:

- UI must remain responsive during Solver work.
- heavy Solver/generation work should not block Flutter UI isolate.
- use isolates/background computation where useful.
- avoid unnecessary Firestore traffic.
- avoid rebuilding large board trees in UI.
- benchmark on minimum supported devices.

Do not lock native C++/Rust optimization unless Dart benchmarks prove need.

---

# 53. ACCESSIBILITY

Required from launch baseline:

- RTL correctness;
- readable Arabic typography;
- text scaling tolerance;
- adequate touch targets;
- contrast;
- semantic labels where practical;
- feedback not dependent only on color.

Portrait layout must still adapt to tablet dimensions.

---

# 54. STORY / GAMEPLAY INTEGRATION RULE

Narrative must not change puzzle rules.

Story moments can:
- introduce mechanics;
- contextualize progression;
- react to Chapter milestones.

Story moments must:
- be skippable;
- avoid blocking quick play;
- not force country-specific puzzle topics.

---

# 55. POST-MVP FEATURES — DO NOT IMPLEMENT UNLESS EXPLICITLY REQUESTED

- Player XP/Level.
- Achievements.
- Badges.
- Collections.
- Permanent Special Packs.
- Leaderboards.
- major temporary Events beyond first post-launch planning.
- paid Cosmetics.
- advanced LiveOps economy.
- Lore Collectibles.
- full voice acting.
- Subscription.
- Premium Currency.
- Starter Pack.

---

# 56. STILL TBD — DO NOT GUESS

The following remain intentionally open:

## Commercial
- Remove Ads real-money price.
- 1k/3k/7k/15k Coin Pack real-money prices.

## Solver Tuning
- exact final search algorithm composition;
- exact timeout;
- exact performance thresholds;
- exact backend fallback trigger;
- whether native optimization is ever needed.

## Production Operations
- exact Firebase/GCP quotas/budgets;
- Cloud Functions/Cloud Run resource limits;
- exact autoscaling settings;
- exact DR RPO/RTO;
- final ad mediation network mix;
- final penetration-test vendor.

## Delivery
- final staffing;
- final role allocation;
- final dates;
- final commercial budget.

If code requires one of these values:
- create configuration/placeholder;
- mark clearly;
- do not silently choose a permanent value.

---

# 57. SOURCE OF TRUTH HIERARCHY

When documents conflict, use this precedence:

1. **Latest explicit user-approved decision.**
2. **Final Decision Register v1.1 or later.**
3. **Narrative Canon & Story Bible v1.1 or later** for narrative.
4. **Latest approved gameplay / engine / solver specifications.**
5. **Latest Full Product Scope / MVP Scope.**
6. **Architecture documents.**
7. **Backlog / Estimation documents.**
8. Older proposals.

Special rule:

Any older Azure / ASP.NET Core / PostgreSQL MVP recommendation is superseded by the Firebase-first serverless MVP decision.

Any older “Proposed” economy number that now matches an approved number should be treated as approved according to the Final Decision Register.

---

# 58. CODE REVIEW CHECKLIST FOR CURSOR

Before presenting a coding change, verify:

- Does it change a product rule?
- Does it add a new feature not approved?
- Does Game Engine remain UI-independent?
- Does Solver remain compatible with Engine?
- Is new economic logic server-authoritative?
- Does it work offline where required?
- Is Arabic/RTL considered?
- Are tests included?
- Are failure states handled?
- Are idempotency requirements respected?
- Did the change introduce unnecessary always-on infrastructure?
- Did it hard-code a value that should be configurable?
- Did it reintroduce a superseded Azure/.NET/PostgreSQL MVP assumption?
- Does it preserve narrative canon where story is involved?

If uncertain:
**stop and request a decision instead of guessing.**

---

# 59. FIRST CURSOR TASK

After this context is added to the repository, Cursor should **not** immediately build every product feature.

The first implementation task should be:

## Sprint 0 / Project Bootstrap

Deliver:

1. Flutter project bootstrap.
2. Workspace/package structure.
3. `game_engine`, `game_solver`, `level_generator` pure-Dart package shells.
4. Riverpod baseline.
5. Drift baseline.
6. Firebase environment/bootstrap skeleton.
7. DEV/TEST/STAGING/PROD configuration structure.
8. static analysis/lints.
9. test setup.
10. GitHub Actions CI.
11. architecture dependency test or clear dependency rules.
12. README with local setup.
13. no real gameplay behavior until package boundaries/tests are ready.

After Sprint 0:

## Implement Game Engine Rules v1 before building the full UI.

---

# 60. FINAL CURSOR DIRECTIVE

Build **سوليتير العرب: أسطورة المعاني** as a robust Arabic-first puzzle game with:

- deterministic testable gameplay;
- shared Solver correctness;
- local-first play;
- Firebase-first low-cost backend;
- safe economy;
- data-driven content;
- lightweight epic narrative;
- strict respect for approved decisions.

**Do not optimize for code generation speed at the expense of architecture or rule correctness.**

**Do not invent missing product decisions.**

**When a requirement is ambiguous, preserve extensibility and ask for approval.**

---

**End of CURSOR_PROJECT_CONTEXT v1.0**
