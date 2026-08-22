# Sprint 4 — Playable Gameplay Vertical Slice v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** End-to-End Gameplay Integration / Flutter Vertical Slice  
**Depends On:** Sprint 3 — Level Generator & Difficulty Validation v1  
**Primary App:** `apps/mobile`  
**Consumes:** `packages/game_engine`, `packages/game_solver`, `packages/level_generator`  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 4 Objective

Build the first fully playable end-to-end vertical slice of **سوليتير العرب: أسطورة المعاني** in Flutter.

Sprint 4 must integrate:

- generated Level Attempt;
- Game Engine;
- Solver;
- Flutter board rendering;
- drag & drop;
- Tableau;
- Stock;
- Association Slots;
- Move counter;
- Correct Move Streak feedback;
- Undo;
- Hint;
- Out-of-Moves;
- Dead-End detection;
- Win;
- local Attempt persistence;
- resume flow;
- minimal animations;
- Arabic-first RTL UX.

This sprint is the first time the game should feel like an actual playable product rather than a collection of technical components.

The goal is not final polish.

The goal is:

> **A complete, correct, testable gameplay loop from generated board to win/failure/restart.**

---

# 2. Sprint 4 Success Criteria

Sprint 4 is complete only when:

1. Flutter can request/generate a valid Level Attempt.
2. Generated board is rendered correctly.
3. Tableau hidden/exposed state is visible correctly.
4. Stock UI matches authoritative Engine state.
5. Association Slots render and activate correctly.
6. Drag/drop maps to Engine actions.
7. Invalid drops are rejected without Move deduction.
8. Valid actions update board state correctly.
9. Auto-reveal animates correctly.
10. Move counter is correct.
11. Correct Move Streak feedback is correct.
12. Undo works according to Engine rules.
13. Hint requests Solver continuation and highlights/suggests a move without executing it.
14. Dead-End detection is conservative.
15. Out-of-Moves flow appears correctly.
16. Win flow appears only when all Cards clear.
17. Restart generates a new valid Attempt.
18. Active Attempt is saved locally.
19. App restart can restore same active Attempt.
20. Gameplay remains functional without Firebase connectivity.
21. Solver/generation work does not block UI.
22. RTL gameplay layout works on supported phone/tablet sizes.
23. Critical gameplay interaction tests pass.

---

# 3. Non-Goals

Do NOT implement in Sprint 4:

- final Home/Journey polish;
- full Chapter map;
- final Tutorial;
- full Economy Wallet;
- paid Extra Moves;
- paid Dead-End rescue;
- Rewarded Ads;
- Interstitial Ads;
- IAP;
- Daily Reward;
- Daily Streak;
- Daily Challenge production flow;
- story scenes;
- final art;
- final sound/music;
- CMS;
- cloud save;
- Firebase progression;
- 250 production Levels;
- final accessibility polish;
- final animation polish.

Temporary placeholders are allowed where necessary to complete the gameplay loop.

---

# 4. Vertical Slice Entry Flow

Recommended temporary flow:

```text
App Launch
  ↓
Bootstrap
  ↓
Temporary Play Screen
  ↓
Generate Level Attempt
  ↓
Render Board
  ↓
Play
  ↓
Win / Out of Moves / Dead-End
  ↓
Restart / Exit
```

Do not build the entire app navigation in this sprint.

---

# 5. Gameplay Architecture

Recommended layering:

```text
Flutter UI
   ↓
Gameplay Controller / Notifier
   ↓
Application Use Cases
   ↓
Game Engine
   ↓
Solver / Generator
```

UI must never decide legality.

UI sends intent.

Game Engine decides outcome.

---

# 6. Gameplay State Controller

Use Riverpod for application/gameplay orchestration.

Recommended responsibilities:

- hold current `GameState`;
- submit `GameAction`;
- expose latest `GameTransition`;
- coordinate animation state;
- request Hint from Solver;
- request Dead-End evaluation;
- persist active Attempt;
- generate/restart Attempt;
- expose async loading/error state.

Do not reimplement Game Engine rules in providers.

---

# 7. Suggested Gameplay Feature Structure

```text
apps/mobile/lib/features/gameplay/
├── application/
│   ├── gameplay_controller.dart
│   ├── gameplay_state.dart
│   ├── generate_attempt_use_case.dart
│   ├── apply_game_action_use_case.dart
│   ├── request_hint_use_case.dart
│   ├── evaluate_dead_end_use_case.dart
│   └── persist_attempt_use_case.dart
│
├── presentation/
│   ├── screens/
│   │   └── gameplay_screen.dart
│   │
│   ├── widgets/
│   │   ├── game_board.dart
│   │   ├── tableau_view.dart
│   │   ├── tableau_column_view.dart
│   │   ├── stock_view.dart
│   │   ├── association_slots_view.dart
│   │   ├── association_slot_view.dart
│   │   ├── game_card_view.dart
│   │   ├── move_counter.dart
│   │   ├── streak_indicator.dart
│   │   ├── gameplay_toolbar.dart
│   │   └── gameplay_overlay.dart
│   │
│   └── interaction/
│       ├── drag_payload.dart
│       ├── drop_target_mapper.dart
│       └── gameplay_animation_coordinator.dart
│
└── data/
    └── active_attempt_repository.dart
```

Keep actual structure proportionate.

---

# 8. Gameplay UI Source of Truth

Flutter widgets render from authoritative `GameState`.

Widgets must not maintain separate truth for:

- card positions;
- stack contents;
- Move count;
- completed Associations;
- Stock playable card;
- active Association progress.

Temporary animation state may exist separately, but after animation settles:

```text
UI == GameState
```

---

# 9. Card Rendering Model

UI card component should support:

```text
Association Card
Member Card
Face-down Card
```

Association Card:
- visually distinct.

Member Card:
- content reference rendered.

Face-down Card:
- hidden content.

Sprint 4 can use placeholder visual design.

Do not lock final art direction here.

---

# 10. Arabic Card Rendering

If fixture content is Arabic:

- use RTL-safe text;
- centered/readable layout;
- handle multi-line content;
- avoid clipping;
- support text scaling.

No semantic logic in UI.

---

# 11. Tableau Rendering

Each column renders:

```text
hiddenCards
+
exposedUnit
```

Hidden Cards:
- visible as card backs/stack depth.

Exposed unit:
- draggable if Engine source is movable.

Atomic stack:
- rendered as one draggable unit;
- internal cards may visually fan/stack;
- drag payload references whole movable unit.

---

# 12. Tableau Layout

Portrait-first.

Recommended:

- columns distributed horizontally;
- responsive width;
- controlled overlap for vertical stacks;
- adaptive card scale for small screens;
- tablet uses wider spacing, not a separate gameplay implementation.

Avoid horizontal scrolling unless absolutely required.

---

# 13. RTL Gameplay Layout

RTL must be intentional.

Decide visual order consistently.

Recommended:
- first logical Tableau column may render on right side.

If logical order and visual order differ:
- mapping must be explicit;
- Engine indices must remain stable.

Do not reverse data collections ad hoc in multiple widgets.

---

# 14. Drag Payload

Drag payload should contain only stable references.

Example:

```text
sourceType
sourceIndex
movableUnitId/reference
gameStateRevision
```

Do not put mutable UI objects in payload.

Use revision/version to reject stale drop attempts if state changed mid-drag.

---

# 15. Drop Targets

Supported drop targets:

- Tableau column;
- Association Slot.

Target behavior depends on dragged unit type.

UI may visually indicate possible targets, but final validation always comes from Engine.

---

# 16. Drag Start

On drag start:

- snapshot source reference;
- optionally ask Engine/application for legal destinations;
- show drag feedback;
- keep original board state unchanged until drop accepted.

Do not optimistically mutate gameplay state.

---

# 17. Valid Drop

On drop:

1. map source + destination to `GameAction`;
2. call Game Engine through controller;
3. if accepted:
   - update GameState;
   - run transition animations;
   - persist Attempt;
   - schedule Dead-End evaluation if needed;
4. return UI to stable state.

---

# 18. Invalid Drop

If Engine rejects:

- board remains unchanged;
- Move count unchanged;
- streak counter reset per Engine;
- show subtle invalid feedback;
- animate card back to source;
- optionally vibrate lightly if approved by platform UX later.

Do not invent product penalties.

---

# 19. Drag Target Preview

Optional but recommended:

- highlight candidate target;
- avoid claiming validity before Engine result unless using authoritative prevalidation.

Preferred:
- controller exposes Engine-valid legal targets.

No UI-only rule duplication.

---

# 20. Stock UI

Render:

- up to 3 visible Stock Cards;
- only final/top visible Card is draggable/playable;
- prior visible cards are not draggable.

UI reads:

```text
stock.visibleCards
stock.playableCard
```

from Engine state.

---

# 21. Stock Advance Interaction

Provide explicit Stock interaction area/control.

Action:

```text
AdvanceStock
```

Requirements:
- costs 1 Move;
- updates Stock;
- streak-neutral;
- animation reflects card/window movement.

Do not fake Stock movement entirely in UI.

---

# 22. Restore Stock Interaction

When Restore is available:

- show clear Restore interaction;
- calls `RestoreStock`;
- costs 1 Move;
- does not reshuffle;
- same remaining order;
- unlimited.

UI must never reorder Stock independently.

---

# 23. Association Slots UI

Render configured slot count.

Empty Slot:
- clear drop target.

Active Slot:
- render Association Card;
- show attached Members/progress;
- allow matching Member/Member Stack drop.

Completed Association:
- disappears/frees Slot after completion animation.

---

# 24. Association Activation Animation

When Association Card/Stack moves to Slot:

Suggested minimal animation:
- drag/drop settle;
- slot glow;
- active state reveal.

Keep animation short.

No final VFX required.

---

# 25. Member Attachment Animation

When Member/Stack joins active Association:

- animate to Slot;
- update progress;
- if completion follows, continue directly into completion animation.

Do not introduce extra confirmation.

---

# 26. Association Completion Animation

Required functional animation:

1. group confirms completion;
2. brief highlight;
3. cards disappear/fade/collect;
4. Slot becomes empty.

Animation should not delay Engine state correctness.

If app backgrounded mid-animation:
- restored state must remain correct.

---

# 27. Automatic Tableau Reveal Animation

When exposed unit leaves and hidden card reveals:

- animate flip/reveal;
- no extra Move;
- animation driven from Engine transition event.

Do not infer reveal from widget diff alone if Engine event is available.

---

# 28. Move Counter

Display:

```text
movesRemaining
```

Prominent enough for gameplay.

Update only from Engine state.

Do not animate invalid moves as Move loss.

---

# 29. Correct Move Streak UI

Display:

```text
currentCounter / targetTier
```

and earned reward feedback when Engine emits:

```text
StreakRewardEarned
```

Example:
- `2/3`
- then +3 Coins feedback;
- next tier `0/4`.

Wallet integration is deferred.

For Sprint 4:
- Engine-derived `earnedStreakCoins` may be displayed in debug/temporary UI.

Do not mutate real wallet yet.

---

# 30. Undo UI

Provide Undo button.

Button state:
- enabled only when Engine says Undo available.

On tap:
- submit Undo action;
- animate/refresh board to restored state.

No consecutive Undo.

No Undo after completion/removal.

---

# 31. Undo Animation

Sprint 4 may use simple state restoration animation.

Correctness > cinematic reverse animation.

Minimum acceptable:
- short fade/position transition;
- restored board visually matches restored Engine state.

---

# 32. Hint UI

Provide Hint button.

Sprint 4 does not implement Hint economy charge yet.

For vertical slice:
- invoke Solver Hint directly;
- do not execute action.

Hint result:

```text
HintAvailable
NoWinningContinuation
Inconclusive
AlreadyWon
```

---

# 33. Hint Presentation

When Hint available:

Highlight:

- source;
- destination.

Possible:
- pulse source card;
- pulse target;
- draw subtle arrow/path.

Do not move card automatically.

Hint remains visible briefly or until next action.

---

# 34. Hint Inconclusive UX

If Solver cannot prove continuation within budget:

Show temporary neutral message such as:

```text
تعذر إيجاد تلميح الآن
```

Do not say:
- Dead-End;
- impossible;
- unsolvable.

---

# 35. Dead-End Evaluation

After impactful accepted moves, controller may request Solver evaluation.

Do not evaluate after every animation frame.

Potential trigger:
- after board-changing move settles.

Dead-End check must be cancelable.

---

# 36. Dead-End Result Handling

## NotDeadEnd
No UI interruption.

## ConfirmedDeadEnd
Show Dead-End state/overlay.

## Inconclusive
Do nothing destructive.
May retry later.

## AlreadyWon
Win flow wins.

Never convert Inconclusive to Dead-End.

---

# 37. Dead-End UX — Sprint 4

Since paid rescue is deferred:

Provide temporary options:

- Restart;
- Continue only if product still allows legal play after confirmed dead-end? No: a confirmed dead-end means no winning continuation.

Recommended Sprint 4:
- show `لا يوجد مسار للفوز من الوضع الحالي`;
- offer Restart.

Do not implement Coin/Rewarded rescue yet.

---

# 38. Out-of-Moves UX

When Engine status becomes:

```text
outOfMoves
```

Show overlay.

Sprint 4 options:
- Restart;
- Exit.

Paid Extra Moves UI is deferred.

Do not invent free Extra Moves.

---

# 39. Win Flow

When Engine emits Win/status:

- block further interactions;
- show win overlay;
- show:
  - base reward preview;
  - remaining Moves;
  - streak Coins;
  - total formula preview.

Since Wallet is deferred:
- label as gameplay result only;
- no persistent Coin grant yet unless local temporary mock is explicit.

---

# 40. Win Reward Preview

Use approved formula:

```text
50 + (2 × remainingMoves) + earnedStreakCoins
```

Sprint 4 can calculate display value from Engine outcome.

Do not persist to authoritative Wallet yet.

---

# 41. Restart

Restart:

- discard current active Attempt;
- request Generator for same Level Definition with new seed;
- Solver validates;
- show new board.

Restart must not reuse same exact board unless seed happens to collide.

No anti-repeat history system required.

---

# 42. Generate Attempt Loading State

While generating:

- show lightweight loading indicator;
- do not freeze UI;
- allow cancel/exit.

Generation should run off UI isolate if potentially expensive.

---

# 43. Isolate Integration

Solver/Generator work should run away from UI isolate where needed.

Requirements:

- serializable inputs;
- cancelable work;
- errors returned safely;
- no BuildContext crossing isolate boundary.

Possible implementation:
- `Isolate.run`;
- custom worker abstraction.

Choose simplest robust approach.

---

# 44. Solver Request Debouncing

Avoid launching multiple overlapping Dead-End/Hint solves unnecessarily.

Controller should:

- cancel stale Solver request when state revision changes;
- ensure result applies only to state it was requested for.

---

# 45. State Revision

Recommended add application-level revision counter:

```text
gameplayRevision
```

Each accepted board state update increments revision.

Async Solver result must include/request revision.

If result revision != current:
- discard result.

This prevents stale Hint/Dead-End UI.

---

# 46. Active Attempt Persistence

Use Drift.

Persist enough to restore:

- Level Definition ID;
- seed;
- GameState;
- rules version;
- save schema version;
- generator version;
- current state revision;
- Attempt metadata.

---

# 47. Persistence Timing

Persist after:

- accepted Move;
- Undo;
- Restart new Attempt;
- app lifecycle pause/background where possible.

Do not persist invalid drag attempts unless streak state changed.

Important:
Invalid action resets streak, therefore updated Engine state should be persisted.

---

# 48. Invalid Action Persistence

Because invalid action changes streak counter:

- persist updated state after rejected gameplay action if Engine returns changed state for streak reset.

If Engine currently returns unchanged `nextState` on rejection, Sprint 1 contract must support the approved streak-reset behavior.

Do not silently lose streak reset on app restart.

---

# 49. Resume Flow

At app launch/gameplay entry:

1. check active Attempt;
2. validate schema/rules compatibility;
3. restore GameState;
4. validate Engine invariants;
5. render board.

If incompatible:
- do not crash;
- handle migration/fallback explicitly.

---

# 50. Corrupt Save Handling

If local Attempt fails validation:

- log;
- preserve diagnostic info if possible;
- clear only corrupt Attempt record;
- allow new Attempt.

Do not wipe whole local DB.

---

# 51. Attempt Persistence Repository

Recommended interface:

```dart
abstract interface class ActiveAttemptRepository {
  Future<ActiveAttempt?> load();
  Future<void> save(ActiveAttempt attempt);
  Future<void> clear();
}
```

Application layer depends on interface.

Drift implementation lives outside domain.

---

# 52. Gameplay Screen States

Recommended:

```text
loadingAttempt
playing
hintLoading
deadEndChecking
won
outOfMoves
confirmedDeadEnd
recoverableError
fatalError
```

Avoid giant nested booleans.

---

# 53. Interaction Locking

Temporarily lock gameplay interactions during:

- critical transition animation;
- win overlay;
- out-of-moves overlay;
- confirmed dead-end overlay;
- attempt loading.

Hint/Dead-End Solver request should not necessarily lock board unless product UX requires it.

---

# 54. Animation Principle

Animations must follow Engine result.

Do not:
- mutate Engine state at animation end only;
- let animation define legality.

Preferred:
- Engine commits transition;
- UI animates from previous to next visual state.

---

# 55. Transition Animation Coordinator

Use Engine `domainEvents` to determine:

- moved unit;
- reveal;
- stack merge;
- Association activation;
- member attachment;
- completion;
- win.

Avoid large fragile widget-diff inference.

---

# 56. Minimum Animation Set

Sprint 4 requires functional versions of:

- drag return on invalid;
- valid drop settle;
- auto-reveal flip;
- Association activation;
- Member attachment;
- Association completion;
- Hint highlight;
- Win overlay.

No elaborate VFX.

---

# 57. Input Safety

During drag:

If state changes externally:
- stale payload drop must be rejected.

Use:
- state revision;
- source identity validation.

---

# 58. Accessibility Baseline

Gameplay controls should expose semantic labels:

- Stock;
- Restore;
- Undo;
- Hint;
- Moves remaining;
- Association Slots.

Drag-only gameplay remains product rule, but accessibility alternatives may require future explicit product design.

Do not invent tap-to-auto-move in this sprint because it is currently disallowed.

---

# 59. Haptics

Optional.

If implemented:
- subtle success/error haptics;
- configurable;
- no gameplay meaning dependent on haptic.

Can be deferred without blocking Sprint 4.

---

# 60. Audio

Optional placeholder only.

Do not block Sprint 4 on final audio.

Potential:
- move;
- invalid;
- completion;
- win.

No full music integration required.

---

# 61. Debug Gameplay Panel

Highly recommended in DEV only.

Expose:

- seed;
- Level Definition ID;
- rules version;
- generator version;
- Solver version;
- board fingerprint;
- Moves;
- state revision;
- last action;
- last rejection reason;
- Hint solve metrics;
- Dead-End solve metrics.

Must not appear in PROD.

---

# 62. Copy Reproduction Info

DEV-only action:

```text
Copy Board Reproduction Info
```

Include:
- level ID;
- seed;
- versions;
- fingerprint.

Useful for QA.

---

# 63. Generated Level Fixture

Sprint 4 should use one or more approved technical Level Configurations.

Not final production content.

Example:
- 3 Associations;
- group size 3;
- 4–5 Tableau columns;
- suitable Stock size;
- fixed Move Limit.

Exact fixture values should come from Sprint 3 Golden configs where possible.

---

# 64. Local Content Fixture

Use approved/test Arabic Association content fixture.

Keep clearly labeled:

```text
DEV / TEST CONTENT
```

Do not accidentally ship placeholder strings as production content.

---

# 65. Gameplay Error Handling

Potential errors:

- generation failed;
- Solver inconclusive;
- save failed;
- corrupt Attempt;
- unsupported rules version.

UI should distinguish:
- recoverable;
- fatal.

Avoid raw exception text.

---

# 66. Generation Failure UX

If Generator exhausts retry budget:

- show retry action;
- log diagnostics;
- do not create invalid board.

Suggested message:

```text
تعذر تجهيز المستوى. حاول مرة أخرى.
```

---

# 67. Save Failure UX

If local save fails:
- gameplay may continue in memory;
- show non-blocking error if appropriate;
- retry persistence.

Do not destroy playable state.

---

# 68. Offline Validation

Sprint 4 must be tested with:
- airplane/offline mode;
- no Firebase access.

Expected:
- app boots local gameplay foundation;
- existing content fixture available;
- Generator/Solver work;
- gameplay works;
- active Attempt saves locally.

---

# 69. Firebase Independence

Gameplay vertical slice must not require:

- authenticated cloud account;
- Firestore;
- Storage;
- Remote Config fetch.

Remote Config defaults may exist.

Core play must function locally.

---

# 70. Performance Baseline

Measure:

- board first render;
- drag responsiveness;
- Engine transition time;
- Hint latency;
- Dead-End check latency;
- generation latency;
- persistence latency.

Exact budgets remain TBD.

Record results.

---

# 71. Frame Performance

Avoid:
- rebuilding full app tree on drag update;
- expensive Solver work on UI isolate;
- large synchronous JSON serialization per pointer move.

Use:
- focused providers/selectors;
- RepaintBoundary if helpful;
- animations scoped to affected widgets.

---

# 72. Tablet Validation

Test at least:
- common phone portrait;
- large phone;
- tablet portrait.

No landscape.

---

# 73. Small-Screen Validation

Cards must remain:
- readable;
- draggable;
- distinguishable.

If full text cannot fit:
- use allowed adaptive typography/line wrapping;
- do not hide semantic content incorrectly.

---

# 74. Gameplay Analytics Hook Boundary

Create event interface if not already present.

Sprint 4 may emit local/app analytics events:

- attempt_started;
- move_accepted;
- move_rejected;
- hint_requested;
- hint_available;
- hint_inconclusive;
- dead_end_confirmed;
- out_of_moves;
- attempt_won;
- restart_requested.

Do not overinstrument pointer events.

---

# 75. No Economy Mutation

Even if Win reward preview exists:

- do not mutate cloud/local Wallet as authoritative economy;
- Wallet comes later.

Keep `earnedStreakCoins` as gameplay result.

---

# 76. No Paid Rescue

Sprint 4 Out-of-Moves and Dead-End overlays must not implement:

- 150/250 Coin Extra Moves;
- 200 Coin Dead-End Rescue;
- Rewarded Ad rescue.

Those belong to later Economy/Monetization integration.

---

# 77. Hint Resource Boundary

Sprint 4 may use:
- free DEV Hint button;
or
- mocked resource guard.

Do not decrement final Hint inventory unless Economy/Product Loop sprint owns it.

Document temporary behavior clearly.

---

# 78. Win Overlay Content

Minimum:

```text
أحسنت!
تم حل المستوى
الحركات المتبقية: X
مكافأة الحركات: Y
مكافأة السلسلة: Z
الإجمالي: T
```

Placeholder copy can be polished later.

---

# 79. Failure Overlay Content

Out-of-Moves:

```text
نفدت الحركات
```

Confirmed Dead-End:

```text
لا يوجد مسار للفوز من الوضع الحالي
```

Buttons:
- إعادة المحاولة
- خروج / رجوع

Final copy remains polishable.

---

# 80. Restart Confirmation

Whether Restart needs confirmation is not a locked product decision.

For Sprint 4:
- if confirmation is needed to avoid accidental reset, keep it as temporary UX and mark it configurable/TBD;
- do not treat it as permanent canon.

---

# 81. Gameplay Controller API

Recommended conceptual API:

```dart
Future<void> startLevel(LevelDefinitionId id);
Future<void> applyAction(GameAction action);
Future<void> undo();
Future<void> requestHint();
Future<void> restart();
Future<void> resume();
```

Dead-End checks can remain internal.

---

# 82. Gameplay View State

Separate domain state from UI state.

Example:

```text
GameplayViewState
├── gameState
├── animationState
├── hintState
├── deadEndState
├── asyncStatus
├── error
└── revision
```

Do not duplicate rule values unnecessarily.

---

# 83. Engine Transition Consumption

Controller should consume:

```text
GameTransition
```

and map:

- next state;
- domain events;
- rejection reason;
- move cost.

Do not parse internal Engine collections manually.

---

# 84. Legal Target Precomputation

Optional:

On drag start:
- request legal destinations from Engine/legal-action enumeration.

This allows:
- authoritative target highlighting;
- fewer invalid drop calls.

Still validate on drop.

---

# 85. Solver Hint Integration

Workflow:

```text
current GameState
  ↓
background Solver
  ↓
HintResult
  ↓
revision check
  ↓
highlight action
```

No auto-execution.

---

# 86. Dead-End Integration

Workflow:

```text
accepted impactful transition
  ↓
cancel previous check
  ↓
background Solver dead-end evaluation
  ↓
revision check
  ↓
ConfirmedDeadEnd / NotDeadEnd / Inconclusive
```

Do not block rapid play unnecessarily.

---

# 87. Dead-End Check Optimization

Can skip check when:
- state won;
- out of moves;
- board currently animating and state about to change;
- previous request stale.

May debounce slightly.

Do not add heuristic dead-end claims.

---

# 88. Persistence Serialization

Prefer Engine-provided `GameState` codec.

Do not create second incompatible JSON model.

Persist wrapper metadata around Engine serialization.

---

# 89. Save Schema

Include:

```text
saveSchemaVersion
```

Migration support required.

Sprint 4 may start at v1.

---

# 90. Resume Validation

On loaded save:

1. decode;
2. validate versions;
3. validate Engine invariants;
4. restore.

If validation fails:
- report recoverable corrupt save;
- clear only active Attempt.

---

# 91. Widget Tests

Required:

- Arabic RTL gameplay shell;
- Stock up-to-3 display;
- only playable Stock Card draggable;
- empty Slot rendering;
- active Slot rendering;
- Move counter updates;
- Undo enabled/disabled;
- Hint highlight;
- Win overlay;
- Out-of-Moves overlay;
- Dead-End overlay.

---

# 92. Interaction Tests

Required:

- valid Member merge via drag/drop;
- invalid mismatch drop;
- Association Card → matching Member Stack;
- Association Card → Slot;
- Member → active Association;
- auto-reveal after drag;
- Stock Card move;
- Advance Stock;
- Restore Stock;
- Undo;
- completion animation state;
- final Win.

---

# 93. Persistence Tests

Test:

- save active Attempt;
- reload same board;
- restore Moves;
- restore Stock;
- restore Tableau hidden/exposed;
- restore Slots;
- restore streak;
- restore completed Associations;
- invalid action streak reset survives reload;
- corrupt save handled.

---

# 94. Async Solver Tests

Test:

- stale Hint result discarded;
- stale Dead-End result discarded;
- cancellation on restart;
- cancellation on state change;
- Inconclusive Hint handled;
- Inconclusive Dead-End does not show dead-end UI.

---

# 95. Offline Test

Automated/integration where practical:

- Firebase unavailable;
- gameplay still starts from local fixture/config;
- generator works;
- solver works;
- persistence works.

---

# 96. Golden Vertical Slice Scenario

Create one deterministic E2E scenario.

Example:

### VS-001

1. Start technical Level.
2. Generate deterministic board from fixed seed.
3. Perform known action sequence.
4. Verify Move count after each action.
5. Trigger auto-reveal.
6. Use Hint and confirm suggested action is correct.
7. Undo eligible Move.
8. Continue.
9. Complete all Associations.
10. Reach Win.
11. Verify reward preview formula.
12. Save/reload during sequence and continue successfully.

This becomes foundational regression coverage.

---

# 97. Secondary Scenario — Invalid/Dead-End

### VS-002

1. Start deterministic board.
2. Make legal but strategically losing sequence.
3. Solver confirms Dead-End.
4. Dead-End overlay appears.
5. Restart.
6. New generated board loaded.

---

# 98. Secondary Scenario — Out of Moves

### VS-003

1. Start tight board.
2. Consume Moves without clearing all Cards.
3. Reach zero.
4. Engine returns Out-of-Moves.
5. Overlay appears.
6. Restart works.

---

# 99. Accessibility Tests

At minimum:
- semantic labels on controls;
- text scale 1.3–1.5 does not destroy layout;
- high contrast readable;
- RTL semantics sensible.

Do not add tap-to-move because current gameplay is drag-only.

---

# 100. Visual Snapshot Testing

Optional but useful:
- gameplay board baseline;
- Stock states;
- Slot states;
- overlays.

Avoid brittle pixel tests for animations.

---

# 101. Error Logging

Log structured info for:

- generation failure;
- Solver parity issue;
- stale async result;
- persistence failure;
- corrupt save;
- unsupported version.

Do not log full personal data.

---

# 102. Crashlytics Context

In non-sensitive form attach:

- rulesVersion;
- generatorVersion;
- solverVersion;
- levelDefinitionId;
- board fingerprint;
- app environment.

Do not attach full user content unnecessarily.

---

# 103. DEV Cheats

Optional DEV-only:
- regenerate board;
- set seed;
- copy fingerprint;
- force one-move-win fixture;
- force out-of-moves;
- force dead-end fixture.

Must never ship visible in PROD.

---

# 104. Architecture Dependency Rules

`apps/mobile` may depend on:
- game_engine;
- game_solver;
- level_generator;
- Riverpod;
- Drift;
- Flutter.

Pure Dart packages remain unchanged.

No UI imports into packages.

---

# 105. Suggested Implementation Order

## Step 1
Gameplay controller/view state.

## Step 2
Generated Attempt loading.

## Step 3
Board renderer.

## Step 4
Tableau + Cards.

## Step 5
Stock.

## Step 6
Association Slots.

## Step 7
Drag/drop mapping.

## Step 8
Engine transition integration.

## Step 9
Move counter + streak.

## Step 10
Undo.

## Step 11
Animations.

## Step 12
Hint Solver integration.

## Step 13
Dead-End Solver integration.

## Step 14
Win/Out-of-Moves/Dead-End overlays.

## Step 15
Restart.

## Step 16
Drift persistence.

## Step 17
Resume.

## Step 18
Async cancellation/revision safety.

## Step 19
Widget/integration tests.

## Step 20
Performance/offline validation.

---

# 106. Suggested Commit Sequence

### Commit 1
```text
feat(gameplay): add gameplay controller and generated attempt loading
```

### Commit 2
```text
feat(gameplay): render tableau cards stock and association slots
```

### Commit 3
```text
feat(gameplay): integrate drag drop with authoritative game engine
```

### Commit 4
```text
feat(gameplay): add move counter streak feedback and undo
```

### Commit 5
```text
feat(gameplay): add transition reveal completion and invalid animations
```

### Commit 6
```text
feat(gameplay): integrate solver-backed hint
```

### Commit 7
```text
feat(gameplay): integrate conservative dead-end detection
```

### Commit 8
```text
feat(gameplay): add win out-of-moves and dead-end flows
```

### Commit 9
```text
feat(gameplay): persist and resume active attempts with drift
```

### Commit 10
```text
test(gameplay): add vertical slice interaction persistence and rtl coverage
```

### Commit 11
```text
perf(gameplay): move solver generator work off ui isolate and measure latency
```

### Commit 12
```text
docs(gameplay): document playable vertical slice architecture
```

---

# 107. Sprint 4 Definition of Done

Sprint 4 is DONE only when:

- [ ] Generated Level Attempt loads in Flutter.
- [ ] Board renders from authoritative GameState.
- [ ] Arabic-first RTL gameplay works.
- [ ] phone portrait layout works.
- [ ] tablet portrait layout works.
- [ ] hidden/exposed Tableau rendering works.
- [ ] atomic stacks render/move as one unit.
- [ ] Stock up-to-3 visible rendering works.
- [ ] only playable Stock Card can drag.
- [ ] Stock Advance works.
- [ ] Restore Stock works.
- [ ] Association Slots render.
- [ ] Association activation works.
- [ ] Member attachment works.
- [ ] Association completion works.
- [ ] auto-reveal animation works.
- [ ] valid drag/drop maps to Engine.
- [ ] invalid drag/drop rejected with 0 Move cost.
- [ ] invalid action streak reset reflected.
- [ ] Move counter correct.
- [ ] streak indicator correct.
- [ ] Undo works.
- [ ] consecutive Undo blocked.
- [ ] Undo after completion blocked.
- [ ] Hint uses Solver.
- [ ] Hint never auto-executes.
- [ ] Hint Inconclusive handled safely.
- [ ] Dead-End uses Solver.
- [ ] Inconclusive never becomes Dead-End.
- [ ] Out-of-Moves overlay works.
- [ ] Win overlay works.
- [ ] Win reward preview formula correct.
- [ ] Restart creates a new generated Attempt.
- [ ] active Attempt persists with Drift.
- [ ] app restart restores Attempt.
- [ ] corrupt Attempt handled safely.
- [ ] stale Solver results discarded.
- [ ] Solver/Generator do not block UI.
- [ ] offline gameplay works.
- [ ] core widget tests pass.
- [ ] interaction tests pass.
- [ ] persistence tests pass.
- [ ] VS-001 passes.
- [ ] VS-002 passes.
- [ ] VS-003 passes.
- [ ] Flutter analyze passes.
- [ ] Flutter tests pass.
- [ ] no unapproved economy/monetization behavior added.

---

# 108. Sprint 4 Exit Gate Before Product Loop

Do not start Sprint 5 until:

1. Gameplay vertical slice is genuinely playable end-to-end.
2. All moves are Engine-authoritative.
3. Solver Hint integration is stable.
4. Dead-End behavior is conservative.
5. local persistence works.
6. restart works.
7. no Firebase/network requirement exists for gameplay.
8. RTL layout is usable.
9. representative phone/tablet performance is acceptable.
10. VS-001/002/003 regression tests pass.
11. major gameplay UX blockers are documented.
12. no duplicated gameplay rules exist in Flutter UI.

---

# 109. Cursor Execution Prompt — Sprint 4

Use this after Sprint 3 passes its exit gate:

> Implement **Sprint 4 — Playable Gameplay Vertical Slice v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_4_Playable_Gameplay_Vertical_Slice_v1.0.md`
> - latest Game Engine specification
> - latest Solver specification
> - latest Level Generator specification
> - latest Screen Inventory/User Flows where relevant
>
> Work primarily inside the Flutter mobile gameplay feature while consuming the pure-Dart Engine/Solver/Generator packages.
>
> Build one complete playable gameplay loop:
>
> - load/generate a valid Attempt;
> - render Tableau;
> - render Stock;
> - render Association Slots;
> - support drag/drop;
> - map user intent to authoritative `GameAction`;
> - consume `GameTransition`;
> - animate accepted/rejected transitions;
> - auto-reveal;
> - Move counter;
> - streak feedback;
> - Undo;
> - Solver-backed Hint;
> - conservative Dead-End detection;
> - Out-of-Moves;
> - Win;
> - Restart;
> - local Drift persistence;
> - resume;
> - async Solver/Generator cancellation and stale-result protection;
> - Arabic-first RTL layout;
> - tests.
>
> Critical constraints:
>
> - UI must not implement gameplay legality;
> - Game Engine remains the only authority;
> - do not mutate board state optimistically before Engine acceptance;
> - all stacks move atomically;
> - only top/final visible Stock Card is playable;
> - Hint suggests only and never executes;
> - Inconclusive Solver result must never be treated as Dead-End;
> - Win only when Engine says won;
> - gameplay must work offline;
> - Solver/Generator work must not block UI;
> - active Attempt is local-first;
> - no Coin Wallet mutation;
> - no paid Extra Moves;
> - no paid Dead-End rescue;
> - no Rewarded Ads;
> - no Interstitial Ads;
> - no IAP;
> - no cloud save in this sprint.
>
> Use Engine domain events to coordinate gameplay animations where available.
>
> Add deterministic vertical-slice regression scenarios for:
>
> - successful full win;
> - confirmed dead-end;
> - out-of-moves.
>
> At completion report:
>
> 1. files created/changed;
> 2. gameplay architecture implemented;
> 3. Engine integration points;
> 4. Solver/Generator isolate approach;
> 5. persistence/resume behavior;
> 6. interaction and animation behavior;
> 7. tests added;
> 8. performance measurements;
> 9. offline test result;
> 10. analyze/test/build results;
> 11. unresolved UX or technical decisions;
> 12. any deviations from this Sprint document and why.

---

# 110. Next Sprint

After Sprint 4 passes the exit gate:

# **Sprint 5 — Product Loop, Tutorial & Journey v1**

Expected focus:

- app shell;
- Home;
- Main Journey;
- Chapter/Level progression;
- Chapter map baseline;
- Level start/restart/resume flows;
- first-time onboarding;
- interactive Tutorial;
- Chapter unlock;
- local progression;
- reward presentation;
- basic narrative beat integration;
- Story Archive baseline;
- first five Chapter structure;
- content-driven Level Definitions;
- pre-cloud product loop.

---

**End of Sprint 4 — Playable Gameplay Vertical Slice v1**
