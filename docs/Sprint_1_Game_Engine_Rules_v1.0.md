# Sprint 1 — Game Engine Rules v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Core Domain / Authoritative Gameplay Rules  
**Depends On:** Sprint 0 — Project Bootstrap & Engineering Foundation  
**Primary Package:** `packages/game_engine`  
**Secondary Consumers:** `game_solver`, `level_generator`, Flutter gameplay UI  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 1 Objective

Implement the authoritative, deterministic, framework-independent Game Engine for **سوليتير العرب: أسطورة المعاني**.

Sprint 1 must establish one canonical source of gameplay truth for:

- cards;
- association identity;
- Tableau;
- Stock;
- Association Slots;
- movable units;
- atomic stacks;
- move validation;
- state transitions;
- Move accounting;
- automatic reveal;
- Association completion;
- streak tracking;
- Undo;
- Out-of-Moves state;
- Win state;
- serialization;
- deterministic replay;
- domain events;
- invariant enforcement.

The Game Engine must be usable without:

- Flutter;
- Riverpod;
- Firebase;
- Drift;
- analytics;
- UI;
- ads;
- IAP.

The final output of this sprint should be a pure Dart package that can be tested from the command line and later consumed by the Solver and Flutter UI.

---

# 2. Sprint 1 Success Criteria

Sprint 1 is complete only when:

1. `game_engine` compiles independently as pure Dart.
2. All approved gameplay rules are modeled explicitly.
3. Illegal moves are rejected deterministically.
4. Every accepted gameplay action applies exactly the approved Move cost.
5. Atomic stack rules are enforced.
6. Stock behavior is implemented exactly as approved.
7. Association Slot behavior is implemented exactly as approved.
8. Automatic reveal works correctly.
9. Association completion removes the full group and frees the Slot.
10. Correct Move Streak logic is implemented exactly.
11. Undo restores the prior eligible state and Move count.
12. Undo is blocked after Association completion/removal.
13. Out-of-Moves state is exposed correctly.
14. Win occurs only when all Cards are cleared.
15. Engine supports deterministic serialization/deserialization.
16. Engine supports action replay from initial state.
17. Invalid actions have stable rejection reasons.
18. Domain events are emitted for important transitions.
19. No UI/network/database dependency exists inside engine.
20. Critical rule paths have automated tests.

---

# 3. Non-Goals

Do NOT implement in Sprint 1:

- Solver search algorithm;
- Level Generator algorithm;
- Hint selection logic;
- Dead-End detection;
- Dead-End rescue state generation;
- Extra Moves purchase flow;
- Coin wallet;
- ads;
- IAP;
- Daily systems;
- Firebase sync;
- Flutter drag/drop;
- animations;
- final gameplay screen;
- story;
- CMS;
- semantic Arabic inference.

The Game Engine may expose hooks/state needed by later systems, but must not implement those systems.

---

# 4. Core Design Principle

The engine should follow:

```text
GameState + GameAction -> GameTransition
```

Where:

```text
GameTransition
├── accepted / rejected
├── previousState
├── nextState
├── moveCost
├── domainEvents
├── rejectionReason
└── metadata
```

The transition function must be deterministic.

The same:

```text
state + action
```

must always produce the same result.

No hidden randomness is allowed inside state transition logic.

---

# 5. Recommended Package Structure

```text
packages/game_engine/
├── lib/
│   ├── game_engine.dart
│   └── src/
│       ├── model/
│       │   ├── identifiers.dart
│       │   ├── card.dart
│       │   ├── association_definition.dart
│       │   ├── movable_unit.dart
│       │   ├── tableau_column.dart
│       │   ├── stock.dart
│       │   ├── association_slot.dart
│       │   ├── streak_state.dart
│       │   ├── undo_state.dart
│       │   ├── attempt_status.dart
│       │   └── game_state.dart
│       │
│       ├── action/
│       │   ├── game_action.dart
│       │   ├── move_tableau_unit.dart
│       │   ├── move_stock_card.dart
│       │   ├── advance_stock.dart
│       │   ├── restore_stock.dart
│       │   ├── move_to_slot.dart
│       │   ├── move_to_active_association.dart
│       │   └── undo_action.dart
│       │
│       ├── rules/
│       │   ├── move_validator.dart
│       │   ├── tableau_rules.dart
│       │   ├── stock_rules.dart
│       │   ├── slot_rules.dart
│       │   ├── completion_rules.dart
│       │   ├── streak_rules.dart
│       │   ├── undo_rules.dart
│       │   └── win_rules.dart
│       │
│       ├── transition/
│       │   ├── game_transition.dart
│       │   ├── rejection_reason.dart
│       │   ├── transition_metadata.dart
│       │   └── game_engine.dart
│       │
│       ├── event/
│       │   └── game_event.dart
│       │
│       ├── serialization/
│       │   ├── game_state_codec.dart
│       │   └── action_codec.dart
│       │
│       └── replay/
│           └── game_replay.dart
│
└── test/
    ├── fixtures/
    ├── model/
    ├── rules/
    ├── transition/
    ├── serialization/
    └── replay/
```

Keep implementation smaller if some files are unnecessary.  
Do not create abstractions only to match this structure.

---

# 6. Domain Identifiers

Use stable typed IDs.

Recommended:

```dart
typedef CardId = String;
typedef AssociationId = String;
typedef AttemptId = String;
typedef LevelDefinitionId = String;
```

or lightweight value classes if useful.

Important:

- compatibility must use `associationId`;
- display text must never determine compatibility;
- Card IDs must be unique inside an Attempt.

---

# 7. Card Model

Approved card categories:

```text
AssociationCard
MemberCard
```

Suggested model:

```dart
sealed class GameCard {
  CardId id;
  AssociationId associationId;
}
```

Subtypes:

```dart
AssociationCard
MemberCard
```

Display/content metadata should remain minimal in Game Engine.

Do not put:

- Arabic text;
- images;
- localization;
- UI color;
- font;
- animation

into rule logic.

If needed, Engine stores only stable content reference IDs.

---

# 8. Association Definition

Each Association Definition should expose enough information for completion.

Minimum:

```text
associationId
associationCardId
requiredMemberCardIds
```

or:

```text
associationId
requiredMemberCount
```

Preferred for strict correctness:

```text
requiredMemberCardIds
```

because it guarantees exact completion membership.

The engine must know when all required Members are attached.

---

# 9. Movable Unit

A movable unit is exactly one of:

```text
Single Member Card
Single Association Card
Member Stack
Association Stack
```

## Member Stack

Contains:
- 2+ Member Cards;
- same `associationId`.

## Association Stack

Contains:
- exactly one Association Card;
- zero or more matching Member Cards;
- same `associationId`.

Important:

- Association Stack may exist with attached Members.
- In Tableau it is inactive.
- In Slot it becomes active.

---

# 10. Atomic Stack Invariant

Once Cards form a stack:

- stack is moved as one unit;
- stack cannot split;
- no substack movement;
- no individual removal from middle;
- move cost is 1 regardless of stack size.

Engine must prevent accidental partial movement by API design.

Recommended:

Do not expose arbitrary stack slicing operations publicly.

---

# 11. Tableau Model

A Tableau column contains:

```text
hiddenCards
exposedUnit?
```

Possible representation:

```dart
class TableauColumn {
  List<GameCard> hiddenCards;
  MovableUnit? exposedUnit;
}
```

Important:

- hidden Cards are not directly movable;
- exactly one exposed movable unit at top;
- after exposed unit leaves, next hidden Card auto-reveals as a single unit.

---

# 12. Initial Tableau Invariants

At Attempt start:

- each non-empty column has exactly one exposed Card;
- Cards below are hidden;
- exposed Card can be Association or Member;
- column sizes may differ;
- empty columns may or may not exist depending on generated board configuration.

Engine validates state consistency but does not generate the deal in Sprint 1.

---

# 13. Tableau Move Rules

## 13.1 Any Unit → Empty Tableau

Valid.

Costs:
- 1 Move.

Streak:
- neutral.

---

## 13.2 Member → Member

Valid only when:

```text
same associationId
```

Result:
- Member Stack.

Streak:
- correct action.

---

## 13.3 Member → Member Stack

Valid only when same `associationId`.

Result:
- merged Member Stack.

Streak:
- correct action.

---

## 13.4 Member Stack → Member

Valid only when same `associationId`.

Result:
- merged Member Stack.

Streak:
- correct action.

---

## 13.5 Member Stack → Member Stack

Valid only when same `associationId`.

Result:
- one atomic Member Stack.

Streak:
- correct action.

---

## 13.6 Association Card → Matching Member

Valid.

Result:
- Association Stack.

Streak:
- correct action.

---

## 13.7 Association Card → Matching Member Stack

Valid.

Result:
- Association Stack containing all Members.

Streak:
- correct action.

---

## 13.8 Member / Member Stack → Association Card in Tableau

Invalid.

---

## 13.9 Member / Member Stack → Association Stack in Tableau

Invalid.

---

## 13.10 Association Stack → Non-Empty Tableau

Invalid unless a later explicit approved rule says otherwise.

Current approved behavior only permits Association Stack to:

- move to empty Tableau;
- move to empty Association Slot.

---

# 14. Source Removal & Auto-Reveal

After an exposed Tableau unit successfully moves away:

If hidden Cards remain:

1. remove last/next top hidden Card;
2. convert it into exposed single-card movable unit;
3. emit `tableauCardRevealed`.

If no hidden Cards remain:

- column becomes empty.

Auto-reveal:
- costs 0 additional Moves;
- does not affect streak.

---

# 15. Stock Model

The Stock must preserve enough state to reproduce:

- remaining Cards;
- current visible window;
- advancement state;
- restore state.

Do not derive behavior from UI only.

Engine is authoritative for which Stock Card is playable.

---

# 16. Stock Visible Window

Approved:

- display up to 3 visible Cards;
- only final/top visible Card is playable;
- as Cards are removed, visible count naturally becomes:
  - 3
  - 2
  - 1
- UI reads this from Engine state.

Engine should expose:

```text
visibleCards
playableCard
```

without requiring UI to reimplement Stock rules.

---

# 17. Advance Stock

Action:

```text
AdvanceStock
```

Approved:

- valid when Stock has an advance operation available;
- costs 1 Move;
- streak-neutral.

Exact internal cursor/index representation is implementation detail.

Important:
- deterministic;
- restore must reproduce approved same remaining order.

---

# 18. Restore Stock

Action:

```text
RestoreStock
```

Approved:

- unlimited;
- costs 1 Move;
- same remaining order;
- no reshuffle;
- streak-neutral.

Restore applies only to remaining Stock Cards.

Cards already legally moved out of Stock do not return.

---

# 19. Moving Playable Stock Card

Only `playableCard` may move from Stock.

It may move to any destination legal for that Card/unit type.

Examples:

- Member → matching Member/Member Stack.
- Association Card → matching Member/Member Stack.
- Association Card → empty Slot.
- valid Card → empty Tableau.

Stock source removal must update visible/playable state correctly.

---

# 20. Association Slot Model

Association Slots:

- fixed count for Attempt;
- start empty;
- may be fewer than total Associations;
- only one active Association per Slot.

Suggested model:

```dart
class AssociationSlot {
  int index;
  AssociationStack? activeAssociation;
}
```

---

# 21. Association Card → Empty Slot

Valid.

Result:

```text
Active Association
```

Streak:
- correct action.

Move cost:
- 1.

---

# 22. Association Stack → Empty Slot

Valid.

All attached Members remain attached.

Result:
- active Association with existing progress.

Move cost:
- 1.

Streak:
- correct action.

Immediately run completion check.

---

# 23. Member / Member Stack → Active Association

Valid only if:

```text
source.associationId == activeAssociation.associationId
```

Entire Member Stack transfers atomically.

Move cost:
- 1.

Streak:
- correct action.

After transfer:
- run completion check.

---

# 24. Wrong Association Attempt

If Member/Stack targets wrong active Association:

- reject;
- Move cost 0;
- current streak counter resets;
- tier does not downgrade;
- state otherwise remains unchanged.

Emit rejection reason suitable for UI feedback.

---

# 25. Association Completion

When active Association contains all required Member Cards:

Engine must automatically:

1. mark Association complete;
2. remove Association Card;
3. remove attached Members;
4. clear Slot;
5. record completed Association ID;
6. emit completion event;
7. evaluate Win state.

Completion itself:
- costs no extra Move.

---

# 26. Completed Associations

GameState should track completion.

Example:

```text
completedAssociationIds
```

This supports:
- Win calculation;
- analytics later;
- replay/debug;
- progression integration later.

---

# 27. Move Limit

GameState contains:

```text
moveLimit
movesRemaining
```

At Attempt start:

```text
movesRemaining == moveLimit
```

Every valid gameplay action costs:

```text
1 Move
```

Invalid action:

```text
0 Moves
```

No action in Sprint 1 may cost >1.

---

# 28. Valid Move Cost Table

| Action | Move Cost |
|---|---:|
| Tableau → Tableau | 1 |
| Stack → Tableau | 1 |
| Stock Advance | 1 |
| Restore Stock | 1 |
| Stock playable Card → valid destination | 1 |
| Association Card → Slot | 1 |
| Association Stack → Slot | 1 |
| Member / Member Stack → Active Association | 1 |
| Auto-reveal | 0 |
| Association auto-completion | 0 |
| Invalid attempt | 0 |
| Undo | restores previous spent Move |

---

# 29. Out-of-Moves Status

When a valid action reduces Moves to 0:

- transition completes;
- completion/Win check runs first where relevant;
- if not Win:
  - Attempt enters `outOfMoves`.

Suggested status:

```text
inProgress
won
outOfMoves
```

Dead-End is not determined by Game Engine alone in Sprint 1.

---

# 30. Win Condition

Win only when all Cards are cleared.

Equivalent:

- all Associations completed;
- Tableau empty;
- Stock empty;
- all Association Slots empty.

Engine should verify actual state rather than trust only one counter.

If last valid Move consumes final Move and also clears all Cards:

```text
status = won
```

not:

```text
outOfMoves
```

Win takes precedence.

---

# 31. Correct Move Streak Model

State should include:

```text
currentCounter
targetTier
earnedStreakCoins
```

Initial:

```text
currentCounter = 0
targetTier = 3
earnedStreakCoins = 0
```

---

# 32. Streak-Correct Actions

Increment current counter:

- same-group Member stacking;
- same-group Stack merging;
- Association Card → matching Member/Member Stack;
- Association Card → Slot;
- Member/Stack → matching Active Association;
- Association Stack → Slot.

One action:
- increments by exactly 1;
- regardless of number of Cards moved.

---

# 33. Streak-Neutral Actions

Do not increment and do not reset:

- Stock Advance;
- Restore Stock;
- move any unit to empty Tableau.

---

# 34. Invalid Action Streak Rule

Any invalid/rejected gameplay action:

- resets `currentCounter` to 0;
- does not reduce `targetTier`;
- does not remove already earned streak Coins.

This happens even though:
- Move cost = 0.

---

# 35. Streak Reward Progression

Approved:

## Tier 3

When counter reaches 3:

```text
earnedStreakCoins += 3
targetTier = 4
currentCounter = 0
```

## Tier 4

When counter reaches 4:

```text
earnedStreakCoins += 4
targetTier = 5
currentCounter = 0
```

## Tier 5

When counter reaches 5:

```text
earnedStreakCoins += 5
targetTier = 5
currentCounter = 0
```

Repeat forever at Tier 5.

---

# 36. Undo Rules

Action:

```text
Undo
```

Approved:

- only last eligible Move;
- cannot Undo twice consecutively;
- new valid Move required before another Undo;
- restores the Move spent;
- unavailable if last Move caused Association completion/removal.

Undo does not consume a Move.

---

# 37. Undo State Design

Recommended:

```text
UndoState {
  previousEligibleStateSnapshot
  lastMoveWasUndone
  available
}
```

or a compact inverse-operation model if fully safe.

For v1, state snapshot is acceptable if deterministic and memory cost is reasonable.

Important:

Undo must restore:

- Tableau;
- hidden/exposed state;
- Stock;
- Slots;
- Moves;
- Streak;
- completion state;
- Attempt status;
- all rule-relevant state.

---

# 38. Undo Eligibility

Undo is eligible only when the last accepted Move:

- did not complete/remove an Association;
- was not itself Undo;
- has a restorable previous state.

Invalid actions:
- do not create Undo entry;
- do reset streak.

Neutral actions:
- may be undone if otherwise eligible.

---

# 39. Undo After Auto-Reveal

If a Move caused auto-reveal:

Undo must restore:

- moved unit to source;
- revealed Card back to hidden state;
- destination to previous state;
- Moves;
- Streak.

Auto-reveal is part of the same atomic transition.

---

# 40. Undo After Stock Action

Undo should support eligible Stock actions where feasible under the general last eligible Move rule.

Examples:

- Undo Stock Advance;
- Undo Restore Stock;
- Undo moving playable Stock Card.

If implementation complexity reveals ambiguity not covered by approved rules, stop and request approval rather than silently excluding them.

---

# 41. Game Actions

Recommended sealed hierarchy:

```dart
sealed class GameAction {}
```

Possible actions:

```text
MoveTableauUnitToTableau
MoveStockCardToTableau
MoveAssociationToSlot
MoveTableauAssociationStackToSlot
MoveStockAssociationToSlot
MoveMemberToActiveAssociation
AdvanceStock
RestoreStock
UndoLastMove
```

Implementation may use a more generic source/destination model if it remains type-safe and clear.

Avoid one huge action with loosely typed maps.

---

# 42. Source / Destination References

Use stable references.

Examples:

```text
TableauSource(columnIndex)
StockSource
AssociationSlotSource(slotIndex)
```

Destinations:

```text
TableauDestination(columnIndex)
AssociationSlotDestination(slotIndex)
```

Do not let UI mutate state collections directly.

---

# 43. Rejection Reasons

Provide stable machine-readable reasons.

Suggested enum:

```text
attemptNotInProgress
sourceEmpty
sourceNotMovable
invalidDestination
destinationOccupied
associationMismatch
memberCannotMoveOntoAssociationInTableau
associationStackCannotReceiveInTableau
stockCardNotPlayable
slotOccupied
associationMismatchWithActiveSlot
noStockAdvanceAvailable
noStockRestoreAvailable
noMovesRemaining
undoUnavailable
undoBlockedByCompletion
consecutiveUndoNotAllowed
stateInvariantViolation
```

UI may map these to localized messages later.

---

# 44. Domain Events

Recommended events:

```text
MoveAccepted
MoveRejected
CardRevealed
StackCreated
StacksMerged
AssociationActivated
MembersAttached
AssociationCompleted
StockAdvanced
StockRestored
StreakRewardEarned
UndoPerformed
OutOfMovesReached
GameWon
```

Events should be data objects, not UI callbacks.

---

# 45. Transition Ordering

For an accepted Move, recommended order:

1. Validate Attempt status.
2. Validate source.
3. Validate destination.
4. Validate rule compatibility.
5. Snapshot Undo state if eligible.
6. Apply source removal.
7. Apply destination update.
8. Auto-reveal source Tableau if needed.
9. Deduct 1 Move.
10. Update streak.
11. Check Association completion.
12. Update completion state.
13. Check Win.
14. If not Win and Moves == 0 → Out of Moves.
15. Emit events.
16. Validate resulting invariants.
17. Return GameTransition.

The exact implementation may differ, but behavior must match.

---

# 46. Invalid Transition Ordering

For invalid action:

1. preserve board state;
2. preserve Moves;
3. reset current streak counter;
4. preserve streak tier;
5. preserve earned streak Coins;
6. emit rejection event;
7. do not alter Undo history.

This is an important rule.

---

# 47. Game State Invariants

Every valid GameState must satisfy:

1. Every Card ID exists in only one place.
2. Every Card belongs to known Association.
3. Member Stack contains only Members.
4. All Members in Member Stack share Association ID.
5. Association Stack contains exactly one Association Card.
6. Association Stack Members match Association ID.
7. Active Slot contains Association Stack only.
8. Completed Association Cards/Members are absent from board.
9. Hidden Cards are only in Tableau hidden collections.
10. Stock playable Card belongs to Stock.
11. Move counts are never negative.
12. Streak tier is one of 3/4/5.
13. Won state has no remaining Cards.
14. Out-of-Moves state has zero Moves and is not won.
15. Association completion state is consistent with removed Cards.

Add invariant checker usable in tests/debug builds.

---

# 48. State Immutability

Prefer immutable GameState.

A transition should create:

```text
nextState
```

rather than mutate globally shared state.

This supports:

- deterministic replay;
- Solver integration;
- Undo;
- testing;
- debugging;
- state comparison.

---

# 49. Serialization

Sprint 1 must support deterministic serialization for:

- GameState;
- GameAction;
- IDs;
- Attempt status;
- streak;
- Stock;
- Tableau;
- Slots;
- completed associations;
- Undo metadata if persisted.

Use version metadata.

Suggested:

```text
rulesVersion
saveSchemaVersion
```

---

# 50. Serialization Requirements

Round-trip:

```text
state -> JSON -> state
```

must preserve rule-relevant equality.

Same for actions.

Do not serialize Flutter objects.

Do not serialize functions/callbacks.

---

# 51. Replay

Implement a basic replay utility:

```text
initialState
+ List<GameAction>
-> finalState / failure
```

Replay should use the same authoritative engine transition API.

No separate replay rules.

This is required for:

- debugging;
- Solver validation later;
- QA reproduction;
- Golden Boards.

---

# 52. Deterministic Equality

Provide robust equality for:

- GameState;
- Cards;
- stacks;
- Stock;
- Tableau;
- slots;
- streak.

Do not compare only object identity.

---

# 53. Test Fixture Strategy

Create reusable fixtures:

```text
association A
association B
simple tableau
stock of N cards
empty slot
active slot
near-complete association
one-move-to-win board
out-of-moves board
```

Fixtures must use stable IDs.

---

# 54. Required Unit Test Matrix — Cards & Stacks

Test at minimum:

- create Member Stack from matching Members;
- reject mixed Association Member Stack;
- create Association Stack from matching Member(s);
- reject mismatched Association Stack;
- stack moves atomically;
- no partial stack operation exposed.

---

# 55. Required Unit Test Matrix — Tableau

Test:

- Member → matching Member valid;
- Member → non-matching Member invalid;
- Member Stack → matching Member valid;
- Member Stack → non-matching Member invalid;
- Association Card → matching Member valid;
- Association Card → matching Member Stack valid;
- Association Card → non-matching Member invalid;
- Member → Association Card invalid;
- Member Stack → Association Card invalid;
- Member → Association Stack invalid;
- Member Stack → Association Stack invalid;
- any movable unit → empty Tableau valid;
- auto-reveal after source move;
- empty source column after final exposed unit moves.

---

# 56. Required Unit Test Matrix — Stock

Test:

- up-to-3 visible window;
- only top/final visible Card playable;
- non-playable visible Stock Card rejected;
- removing playable Card updates window;
- advance costs 1;
- restore costs 1;
- restore same remaining order;
- restore unlimited;
- removed Cards do not reappear after restore;
- neutral streak behavior.

---

# 57. Required Unit Test Matrix — Slots

Test:

- Association Card → empty Slot valid;
- Association Card → occupied Slot invalid;
- Association Stack → empty Slot valid;
- Member → matching active Association valid;
- Member Stack → matching active Association valid;
- wrong Member → active Association invalid;
- wrong Member Stack → active Association invalid;
- completion auto-removes cards;
- completion frees slot;
- completion triggers Win when last Association.

---

# 58. Required Unit Test Matrix — Move Accounting

Test:

- every valid action decrements Moves by 1;
- invalid action decrements by 0;
- auto-reveal decrements by 0;
- completion decrements by 0;
- final winning Move can reduce Moves to 0 and still Win;
- non-winning Move reaching 0 produces Out-of-Moves.

---

# 59. Required Unit Test Matrix — Streak

Test:

- correct action increments counter;
- neutral action preserves counter;
- invalid action resets counter;
- invalid action preserves tier;
- 3-correct grants +3 and advances to 4;
- 4-correct grants +4 and advances to 5;
- 5-correct grants +5 and stays at 5;
- subsequent 5-correct cycles repeat +5;
- moving multi-card stack counts as one correct action.

---

# 60. Required Unit Test Matrix — Undo

Test:

- Undo last eligible Move;
- Move restored;
- board restored;
- streak restored;
- auto-reveal restored;
- Stock state restored;
- second consecutive Undo rejected;
- new valid Move re-enables future Undo;
- Undo after Association completion blocked;
- invalid action does not replace Undo history.

---

# 61. Required Unit Test Matrix — Win

Test:

- all Cards cleared -> won;
- empty Tableau but Stock not empty -> not won;
- empty Stock but Tableau not empty -> not won;
- active incomplete Slot -> not won;
- final Association completion -> won.

---

# 62. Required Unit Test Matrix — Serialization / Replay

Test:

- GameState round-trip equality;
- GameAction round-trip equality;
- replay deterministic;
- replay reaches expected final state;
- replay rejected action handling is stable;
- version metadata preserved.

---

# 63. Property / Invariant Tests

Strongly recommended:

Generate legal states/actions and verify:

- Card uniqueness;
- no negative Moves;
- stack association consistency;
- no completed Cards remain on board;
- same action from same state gives same result.

Do not require full random Level Generator yet.

---

# 64. Golden Engine Scenarios

Create a small fixed scenario suite.

Minimum:

### GE-001
Simple Member merge.

### GE-002
Association Stack formation.

### GE-003
Association activation in Slot.

### GE-004
Association completion.

### GE-005
Stock Advance/Restore.

### GE-006
Auto-reveal.

### GE-007
Undo normal Move.

### GE-008
Undo blocked after completion.

### GE-009
Streak 3→4→5 progression.

### GE-010
Final Move Win at 0 Moves.

These will later become the first Solver parity fixtures.

---

# 65. Engine Public API

Recommended simple public surface:

```dart
GameTransition applyAction(
  GameState state,
  GameAction action,
);
```

Additional allowed APIs:

```dart
List<GameAction> enumerateLegalActions(GameState state);
bool validateState(GameState state);
bool isWin(GameState state);
```

Important:

`enumerateLegalActions` is useful for Solver, but if implementing it in Sprint 1 materially expands scope, it may be added at end of Sprint 1 or beginning of Sprint 2.

Do not create UI-specific methods.

---

# 66. Legal Action Enumeration

Preferred to include if practical.

It should enumerate only actions accepted by Engine.

This gives Solver a canonical legal move source.

If implemented:

- deterministic order;
- stable ordering for tests;
- no UI heuristics;
- no Hint ranking.

---

# 67. Move Classification

Each accepted Move should classify streak effect:

```text
correct
neutral
```

Invalid actions are rejected and trigger streak reset.

Do not infer streak classification in UI.

---

# 68. Attempt Status

Recommended enum:

```dart
enum AttemptStatus {
  inProgress,
  won,
  outOfMoves,
}
```

Dead-End is external/Solver-derived and should not be permanently embedded as authoritative Engine outcome unless later approved.

---

# 69. Completed Progress

Track at least:

```text
completedAssociationIds
```

Optionally track:

```text
completedAssociationCount
```

if derived efficiently.

Do not duplicate state unless necessary.

---

# 70. Time Independence

Game Engine must not read:

- system clock;
- timezone;
- network time.

Daily systems and analytics timestamps belong outside Engine.

---

# 71. Randomness Independence

Game Engine must not shuffle.

Randomness belongs to:

- Level Generator;
- attempt generation.

Engine consumes a fully initialized GameState.

---

# 72. Economy Independence

Game Engine may expose:

```text
earnedStreakCoins
remainingMoves
```

because those are gameplay-derived values.

It must not:

- mutate Wallet;
- deduct Hint Coins;
- charge Dead-End rescue;
- grant Chapter reward.

Economy layer consumes Engine outcomes later.

---

# 73. Hint Independence

Hint is not implemented as Game Engine action in Sprint 1.

Reason:

- Hint does not alter board state;
- Hint selection belongs to Solver/application layer;
- Hint resource consumption belongs economy/application layer.

Engine only needs legal actions and deterministic transitions.

---

# 74. Extra Moves Boundary

Game Engine may expose a controlled method/action later to extend Moves after trusted application/economy approval.

Sprint 1 should not implement monetization.

If a minimal domain operation is needed, keep it separate from normal gameplay moves and do not call it a gameplay Move.

Do not allow arbitrary client mutation of `movesRemaining`.

---

# 75. Dead-End Boundary

Game Engine must not declare Dead-End by itself.

Solver later determines:

```text
solvable
unsolvable
inconclusive
```

Engine only exposes state.

---

# 76. Debugging Support

Recommended debug helpers:

```text
state summary
card location lookup
invariant report
transition trace
```

Do not include sensitive data.

Useful for:

- test failures;
- future Solver mismatch;
- QA reproduction.

---

# 77. Performance Baseline

Sprint 1 is correctness-first.

Still:

- avoid O(n²) scans where simple indexing prevents them;
- keep state clone cost reasonable;
- benchmark representative states;
- avoid premature native optimization.

Exact performance budget remains TBD.

---

# 78. Documentation Requirements

Add package README covering:

- Engine purpose;
- dependency rules;
- public API;
- state model;
- action model;
- transition model;
- invariants;
- approved gameplay rules;
- how to run tests;
- how Solver should consume Engine.

---

# 79. API Documentation

Public types should have concise DartDoc.

Especially:

- `GameState`;
- `GameAction`;
- `GameTransition`;
- `GameEngine`;
- `RejectionReason`;
- `GameEvent`.

Avoid over-documenting obvious getters.

---

# 80. Suggested Implementation Order

## Step 1
IDs + Cards + Association definitions.

## Step 2
Movable units + stack invariants.

## Step 3
Tableau + Stock + Slots state.

## Step 4
GameState + AttemptStatus + Move count.

## Step 5
GameAction model.

## Step 6
Validation/rejection reasons.

## Step 7
Tableau transitions.

## Step 8
Stock transitions.

## Step 9
Slot activation/attachment.

## Step 10
Auto-reveal.

## Step 11
Association completion.

## Step 12
Streak.

## Step 13
Win / Out-of-Moves.

## Step 14
Undo.

## Step 15
Domain events.

## Step 16
Serialization.

## Step 17
Replay.

## Step 18
Legal action enumeration if practical.

## Step 19
Golden scenarios + invariant tests.

---

# 81. Suggested Commit Sequence

### Commit 1
```text
feat(engine): add card association and identifier domain models
```

### Commit 2
```text
feat(engine): add movable units and atomic stack invariants
```

### Commit 3
```text
feat(engine): add tableau stock and association slot state
```

### Commit 4
```text
feat(engine): add game state actions and transition model
```

### Commit 5
```text
feat(engine): implement tableau move validation and transitions
```

### Commit 6
```text
feat(engine): implement stock advance restore and stock moves
```

### Commit 7
```text
feat(engine): implement association slot activation and completion
```

### Commit 8
```text
feat(engine): implement move accounting and streak rules
```

### Commit 9
```text
feat(engine): implement win out-of-moves and undo
```

### Commit 10
```text
feat(engine): add domain events serialization and replay
```

### Commit 11
```text
test(engine): add golden gameplay and invariant coverage
```

### Commit 12
```text
docs(engine): document authoritative game engine contracts
```

---

# 82. Sprint 1 Definition of Done

Sprint 1 is DONE only when:

- [ ] Pure Dart package compiles.
- [ ] No Flutter dependency exists.
- [ ] No Firebase dependency exists.
- [ ] Stable Card/Association IDs implemented.
- [ ] Association Card model implemented.
- [ ] Member Card model implemented.
- [ ] Member Stack implemented.
- [ ] Association Stack implemented.
- [ ] Atomic stack invariant enforced.
- [ ] Tableau implemented.
- [ ] Stock implemented.
- [ ] Association Slots implemented.
- [ ] GameState implemented.
- [ ] GameAction hierarchy implemented.
- [ ] GameTransition implemented.
- [ ] Stable rejection reasons implemented.
- [ ] Tableau movement rules implemented.
- [ ] Stock visible/playable rules implemented.
- [ ] Stock Advance implemented.
- [ ] Restore Stock implemented.
- [ ] Association activation implemented.
- [ ] Member attachment implemented.
- [ ] Association completion implemented.
- [ ] Auto-reveal implemented.
- [ ] Every valid gameplay action costs 1 Move.
- [ ] Invalid actions cost 0 Moves.
- [ ] Streak neutral/correct/reset behavior implemented.
- [ ] 3/4/5 streak rewards implemented.
- [ ] Win condition implemented.
- [ ] Out-of-Moves status implemented.
- [ ] Undo implemented.
- [ ] Consecutive Undo blocked.
- [ ] Undo after completion blocked.
- [ ] Serialization round-trip passes.
- [ ] Replay passes.
- [ ] GameState invariant checker exists.
- [ ] Golden Engine scenarios exist.
- [ ] Critical rule tests pass.
- [ ] README/DartDoc updated.
- [ ] `dart analyze` passes.
- [ ] `dart test` passes.

---

# 83. Sprint 1 Exit Gate Before Solver

Do not start full Solver implementation until:

1. Engine tests are green.
2. Rule ambiguities are resolved.
3. Golden Engine scenarios are stable.
4. GameState serialization is stable enough for Solver fixtures.
5. Engine public API is reviewed.
6. Solver can consume state without depending on UI.
7. Legal move generation strategy is agreed.

Any Engine/Solver disagreement after this gate must be treated as a release-critical defect.

---

# 84. Cursor Execution Prompt — Sprint 1

Use this after Sprint 0 is complete:

> Implement **Sprint 1 — Game Engine Rules v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_1_Game_Engine_Rules_v1.0.md`
> - latest Game Engine Technical Design
> - latest Solver Specification where Engine/Solver boundaries are relevant
>
> Work only inside the approved Game Engine scope unless a small supporting repository/test change is necessary.
>
> The Engine must remain pure Dart and independent from Flutter, Riverpod, Firebase, Drift, analytics, ads, IAP, and UI.
>
> Implement the authoritative deterministic state transition model:
>
> `GameState + GameAction -> GameTransition`
>
> Implement:
>
> - stable IDs;
> - Association/Member cards;
> - Member Stack;
> - Association Stack;
> - atomic stack behavior;
> - Tableau;
> - Stock;
> - Stock visible/playable state;
> - Stock Advance;
> - Restore Stock;
> - Association Slots;
> - move validation;
> - valid/invalid transition behavior;
> - automatic Tableau reveal;
> - Move accounting;
> - correct/neutral/invalid streak behavior;
> - 3/4/5 streak reward progression;
> - Association completion;
> - Win;
> - Out-of-Moves;
> - Undo;
> - domain events;
> - rejection reasons;
> - state invariants;
> - JSON serialization;
> - deterministic replay;
> - legal-action enumeration if it can be included cleanly without weakening correctness.
>
> Critical rules:
>
> - all stacks are atomic;
> - no substack splitting;
> - Association Card is inactive in Tableau;
> - Association Card may move onto matching Member/Member Stack;
> - Member/Member Stack cannot move onto Association Card or Association Stack in Tableau;
> - Association Stack in Tableau cannot receive Members;
> - any movable unit may move to empty Tableau;
> - auto-reveal costs 0 Moves;
> - Stock shows up to 3 visible Cards, only final/top visible Card playable;
> - Restore Stock is unlimited, same remaining order, costs 1 Move;
> - every valid gameplay action costs 1 Move;
> - invalid attempt costs 0 Moves and resets current streak counter only;
> - Undo restores the spent Move;
> - no consecutive Undo;
> - Undo is blocked if last Move caused Association completion/removal;
> - Win only when all Cards are cleared;
> - a final Move that reaches zero Moves but wins must result in Win, not Out-of-Moves.
>
> Add comprehensive tests for all critical rule paths and the Golden Engine scenarios.
>
> Do not implement Solver search, Hint logic, Dead-End detection, economy, monetization, Firebase sync, or gameplay UI in this sprint.
>
> If an approved rule is ambiguous, stop and report the ambiguity instead of inventing a behavior.
>
> At completion report:
>
> 1. files created/changed;
> 2. public Engine API;
> 3. rules implemented;
> 4. tests added;
> 5. commands run;
> 6. test/analyze results;
> 7. unresolved decisions;
> 8. any deviations from this Sprint document and why.

---

# 85. Next Sprint

After Sprint 1 passes its exit gate:

# **Sprint 2 — Solver Core v1**

Expected focus:

- canonical Solver state;
- legal move enumeration;
- Engine parity;
- canonicalization;
- memoization/transposition;
- bounded search;
- move-bounded solvability;
- Hint winning continuation;
- Dead-End result model;
- Golden Boards;
- solution replay through Engine;
- Solver performance benchmark harness.

---

**End of Sprint 1 — Game Engine Rules v1**
