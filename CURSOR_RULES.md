# CURSOR_RULES.md
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** IMPLEMENTATION RULES  
**Applies To:** Cursor, AI coding agents, engineers, reviewers  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`

---

# 1. Source of Truth

Cursor must read `CURSOR_PROJECT_CONTEXT.md` before implementation.

When documents conflict, use this priority:

1. Latest explicit approved user decision.
2. Latest Final Decision Register.
3. Latest Narrative Canon / Story Bible for narrative.
4. Latest gameplay / engine / solver specifications.
5. Latest Full Product Scope / MVP Scope.
6. Architecture documents.
7. Backlog / Estimation documents.
8. Older proposals.

Never revive superseded Azure / ASP.NET Core / PostgreSQL MVP assumptions.

---

# 2. Never Invent Product Behavior

If a requirement is not approved:

- mark it `TBD`;
- keep implementation extensible;
- ask for a decision;
- do not silently choose permanent behavior.

Do not add:
- unapproved mechanics;
- new currencies;
- subscriptions;
- XP;
- badges;
- leaderboards;
- permanent Packs;
- extra rescue mechanics;
- new ad placements;
- new story canon.

---

# 3. Architecture Boundaries

## Game Engine

Must be:
- pure Dart;
- deterministic;
- framework-independent;
- Firebase-independent;
- Riverpod-independent;
- UI-independent;
- replayable;
- serializable;
- testable.

Must not import:
- Flutter UI;
- Firebase;
- AdMob;
- IAP SDK;
- Drift implementation;
- HTTP client;
- analytics SDK.

## Solver

Must:
- use authoritative Engine-compatible rules;
- represent Engine states faithfully;
- return only actions Engine accepts;
- replay solutions through Engine;
- remain UI-independent.

## Level Generator

May depend on:
- Game Engine;
- Solver;
- pure content/config contracts.

Must not bypass Solver acceptance.

## Flutter + Flame 2.5D

- Flutter owns the application shell, Firebase, progression, economy, monetization, and non-gameplay UI.
- Flame owns the current 2.5D gameplay presentation only: board drawing, animation, VFX, and pointer intent.
- Pure Dart packages remain authoritative for rules (`game_engine`, `game_solver`, `level_generator`).
- Never implement rules or legality checks inside Flame rendering code.
- Keep the Flutter widget board available behind `FORCE_FLUTTER2D` as a diagnostic fallback.
- Unity and its bridge are paused legacy experiments, not the MVP default path.
- A future 3D renderer must consume the same `GameState` / `GameAction` boundary.

---

# 4. Gameplay Rule Integrity

Do not modify approved rules for implementation convenience.

Key invariants include:

- stacks are atomic;
- no substack splitting;
- Association Card is inactive in Tableau;
- Association Card may move onto matching Member Stack;
- Member Stack may not move onto inactive Association Card;
- Association Stack cannot receive new Members in Tableau;
- empty Tableau accepts any movable unit;
- automatic reveal costs no Move;
- Stock shows up to 3 visible cards;
- only top/final visible Stock card is playable;
- Restore Stock preserves remaining order;
- Restore Stock is unlimited and costs 1 Move;
- every valid move costs 1 Move;
- invalid move costs 0 Moves;
- invalid move resets current streak counter;
- Hint does not execute;
- Undo cannot reverse a completed Association;
- Win requires all cards cleared;
- visible Move Limit is fixed per Level;
- Restart creates a new valid shuffle;
- accepted generated boards must be solvable within Move Limit.

If code conflicts with one of these, code is wrong.

---

# 5. State Transition Pattern

Preferred core model:

```text
GameState + GameAction -> GameTransition
```

`GameTransition` should expose:

- accepted/rejected;
- new state;
- move cost;
- domain events;
- rejection reason where useful;
- optional post-transition Solver validation requirement.

Avoid hidden mutations.

---

# 6. Testing Rules

No critical gameplay feature is complete without tests.

Required:

## Game Engine
- rule-path tests;
- invariant tests;
- boundary tests;
- serialization tests;
- deterministic replay tests.

## Solver
- Golden Boards;
- Engine parity;
- solution replay;
- solvable/unsolvable cases;
- Move Limit boundary;
- timeout/inconclusive handling.

## Generator
- every accepted board solvable;
- Move Limit satisfied;
- difficulty acceptance checked;
- failed candidate rejected.

## Economy
- idempotency;
- duplicate grant protection;
- offline reconciliation.

## Purchases
- duplicate callback protection;
- restore;
- entitlement correctness;
- server validation.

Do not chase a vanity total coverage percentage.

---

# 7. Firebase-First Cost Rule

MVP is Firebase-first and serverless-first.

Use:
- Firebase Auth;
- Cloud Firestore;
- Firebase Storage;
- Cloud Functions / Cloud Run;
- FCM;
- Remote Config;
- Analytics;
- Crashlytics.

Do not introduce:
- Azure;
- always-on .NET backend;
- PostgreSQL;
- Kubernetes;
- Redis;
- dedicated broker;
- always-on compute

unless explicitly re-approved.

Avoid unnecessary Firestore reads/writes.

Never write gameplay state per Move to cloud.

---

# 8. Offline-First Gameplay

Main Journey must continue offline after required content is available.

Active Attempt:
- local-first in Drift / SQLite.

Cloud sync:
- not per Move.

Offline Coin spend:
- use locally reconciled balance;
- create queued idempotent transaction;
- reconcile later.

Purchases / Rewarded Ads:
- require network.

---

# 9. Server-Authoritative Operations

Never trust the client for:

- Wallet grant;
- Wallet authoritative balance mutation;
- purchase validation;
- entitlement grant;
- Daily Reward eligibility;
- Daily Streak eligibility;
- Daily Challenge reward;
- privileged Admin actions.

All sensitive operations require:
- idempotency key;
- duplicate protection;
- auditable result;
- validation.

---

# 10. Riverpod Rule

Riverpod is for application/UI state.

Do not:
- place core rules inside providers;
- make providers authoritative for gameplay legality;
- make Solver depend on provider state.

Providers orchestrate:
- use cases;
- repositories;
- UI state;
- side effects.

Game Engine remains the authority.

---

# 11. Drift / SQLite Rule

Use Drift for:

- active Attempt;
- local content metadata/cache;
- local progression cache;
- settings;
- sync metadata;
- pending offline transactions;
- schema migrations.

Do not store unversioned opaque blobs when structured/versioned data is practical.

Persist schema/rules/content versions when needed for replay or migration.

---

# 12. UI Rules

Arabic-first.

Required:
- RTL from first implementation;
- readable Arabic typography;
- portrait orientation;
- responsive tablets;
- touch-friendly drag/drop;
- no business logic in widgets;
- visual feedback for accepted/rejected drops;
- failure feedback must not rely only on color.

Do not build English-first then retrofit RTL.

---

# 13. Story Rules

Narrative canon is locked unless explicitly revised.

Do not rewrite:
- Dar Al-Rawabit;
- The Distortion;
- Shiboub;
- عدو العرب / المُبدِّد;
- بصيرة المعنى;
- Arc 1;
- first five Chapter cities;
- player title progression.

Story moments:
- 10–20 seconds typically;
- skippable immediately;
- Chapter Start / Midpoint / Ending;
- gameplay-first.

Chapter location affects visuals/story, not all puzzle topics.

---

# 14. Content Rules

AI-generated content is Draft only.

Production requires human:
- Arabic review;
- semantic review;
- cultural review.

Main Journey:
- evergreen-first;
- mixed topics;
- Text dominant.

Do not auto-publish AI content.

---

# 15. Economy Rules

Approved MVP values:

- Starting Coins: 300.
- Starting Hints: 3.
- Hint: 75 Coins.
- Extra Moves: +5.
- Extra Moves Coin pricing: 150 then 250.
- Max Extra-Move rescues: 2 / Attempt.
- Dead-End Rescue: 200 Coins.
- Max Dead-End Rescue: 1 / Attempt.
- Rewarded Coins: 100.
- Rewarded Coin cap: 3/day.
- Base Level reward: 50.
- Remaining Move reward: 2 Coins each.
- Chapter reward: 500 Coins + 2 Hints.

Do not change these values in code without explicit decision.

Prefer configurable constants / Remote Config where safe.

---

# 16. Ads / IAP Rules

Interstitial:
- adaptive;
- baseline 3–5 completed Levels;
- max 3/session;
- never immediately after approved restricted contexts.

Remove Ads:
- removes Interstitials only.

Rewarded Ads remain optional.

Coin packs:
- 1k;
- 3k;
- 7k;
- 15k.

Real-money pricing remains TBD.

Do not invent store prices.

---

# 17. Daily Rules

Daily Reward:
- 7-day repeating;
- missed day does not reset reward calendar.

Daily Streak:
- missed day breaks streak.

Daily Challenge:
- deterministic board per cohort;
- unlimited retries during day;
- 150 Coins;
- reward first completion only;
- backend-authoritative;
- reset 00:00 validated player-local timezone.

Protect against local clock manipulation.

---

# 18. Error Handling

Use explicit typed failures where practical.

Never:
- swallow errors silently;
- convert Solver timeout into Dead-End;
- grant currency after uncertain operation;
- mark purchase complete before validation.

Prefer:
- Result/Either-like domain result;
- structured logs;
- stable error codes;
- user-safe messages.

---

# 19. Logging / Analytics

Log enough for diagnosis without leaking sensitive data.

Analytics must not alter gameplay behavior.

Prefer:
- aggregated Attempt summary;
- lifecycle events;
- Solver/generator performance;
- economy events;
- purchase funnel;
- Daily systems;
- content issue reports.

Avoid excessive drag/frame telemetry.

---

# 20. Performance

Exact budgets remain TBD.

Rules:

- Solver must not block UI isolate.
- Use isolate/background computation where needed.
- Minimize Firestore traffic.
- Avoid unnecessary widget rebuilds.
- Benchmark on minimum supported devices.
- Do not introduce native C++/Rust optimization until Dart benchmarks justify it.

---

# 21. Security

Never:
- trust client Coin balance;
- trust client purchase status;
- expose Admin privileged mutations directly;
- use insecure wildcard Firestore rules;
- place secrets in client code;
- bypass entitlement validation.

Before launch:
- automated security checks;
- focused manual/external penetration test.

---

# 22. Configuration

Use configuration for tunable values.

Version:
- app;
- rules;
- content schema;
- content bundle;
- economy config;
- save schema.

Core gameplay rules must not be casually changed by Remote Config.

---

# 23. CI Rules

Every PR touching core code should run:

- format;
- lint;
- static analysis;
- unit tests;
- Game Engine tests;
- Solver tests where affected;
- integration tests where affected.

Production deployment:
- never from unreviewed branch;
- must pass release gates.

---

# 24. Definition of Done for Gameplay Changes

A gameplay change is done only when:

- implementation matches approved rule;
- tests cover happy path;
- boundary/error cases covered;
- Solver parity checked if relevant;
- serialization/replay remains valid;
- analytics events added if required;
- docs updated if contract changed.

---

# 25. Code Quality

Prefer:
- explicit names;
- small focused classes/functions;
- immutable domain state where practical;
- dependency inversion at external boundaries;
- typed IDs where useful;
- deterministic logic;
- pure functions for rules.

Avoid:
- god classes;
- service locators inside domain code;
- global mutable state;
- premature abstraction;
- speculative microservices;
- copy/pasted business rules.

---

# 26. Naming

Code identifiers:
- English.

Player-facing content:
- Arabic-first.

Use stable domain names:
- Association
- Member
- Attempt
- Tableau
- Stock
- AssociationSlot
- GameAction
- GameState
- GameTransition
- StreakState
- WalletTransaction
- ContentBundle

Do not use display text as identity.

---

# 27. File / Package Discipline

Before creating a new package:
- prove a real boundary exists.

Before adding dependency:
- justify why standard Dart/Flutter/Firebase stack cannot handle it.

Keep package graph simple.

---

# 28. Cursor Response Rule

When implementing, Cursor should state briefly:

1. What changed.
2. Which approved rule/spec it implements.
3. Tests added/updated.
4. Any unresolved decision discovered.
5. Any migration/config action required.

Do not hide assumptions.

---

# 29. Stop Conditions

Stop and request approval when:

- requirement conflicts with approved canon;
- product behavior is missing;
- economy value is undefined;
- real-money price is required;
- Solver rule would change gameplay;
- cloud choice would introduce meaningful recurring cost;
- data migration could destroy player state;
- new permission/privacy behavior is required;
- narrative canon must change.

---

# 30. First Implementation Rule

Before building broad UI:

1. Bootstrap project.
2. Create pure-Dart package boundaries.
3. Set up tests.
4. Implement Game Engine.
5. Implement Solver.
6. Implement Generator.
7. Build playable vertical slice.

Do not reverse this order without a concrete reason.

---

**End of CURSOR_RULES v1.0**
