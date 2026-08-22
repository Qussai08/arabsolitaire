# Sprint 2 — Solver Core v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Core Search / Solvability / Hint / Dead-End Foundation  
**Depends On:** Sprint 1 — Game Engine Rules v1  
**Primary Package:** `packages/game_solver`  
**Consumes:** `packages/game_engine`  
**Future Consumer:** `packages/level_generator`, Flutter gameplay application, QA simulation tooling  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 2 Objective

Implement the first production-capable Solver core for **سوليتير العرب: أسطورة المعاني**.

The Solver must:

- consume authoritative Game Engine state;
- enumerate only legal Engine-compatible actions;
- search for winning continuations;
- respect the Level Move Limit;
- distinguish solvable / unsolvable / inconclusive;
- provide a safe winning continuation for Hint;
- support Dead-End detection without false certainty;
- replay returned solutions through the Game Engine;
- expose deterministic metrics for future difficulty calibration;
- support benchmark-driven refinement.

The Solver is not allowed to redefine gameplay rules.

---

# 2. Sprint 2 Success Criteria

Sprint 2 is complete only when:

1. `game_solver` remains pure Dart.
2. Solver depends on `game_engine` only through approved public contracts.
3. Every Solver action is accepted by Game Engine.
4. Winning solutions replay through Game Engine to `won`.
5. Solver respects remaining Move budget.
6. Solver returns `inconclusive` on timeout/budget exhaustion rather than false `unsolvable`.
7. Hint returns a move belonging to a known winning continuation.
8. Dead-End detection reports confirmed Dead-End only after a conclusive no-solution result.
9. State canonicalization exists.
10. Memoization/transposition table exists.
11. Search is bounded.
12. Search metrics are exposed.
13. Golden Boards pass.
14. Performance benchmark harness exists.
15. Solver does not depend on Flutter, Firebase, Drift, Riverpod, analytics, or UI.
16. Solver API is usable by Level Generator in Sprint 3.

---

# 3. Non-Goals

Do NOT implement in Sprint 2:

- Level randomization/dealing.
- full Level Generator.
- semantic Arabic clue understanding.
- AI content selection.
- Firebase fallback solving.
- cloud compute orchestration.
- Dead-End rescue board reconstruction.
- economy charging.
- Hint resource consumption.
- UI hint animation.
- dynamic Move Limit modification.
- native C++/Rust optimization.
- distributed Solver infrastructure.

---

# 4. Core Solver Principle

The Solver must treat Game Engine as authoritative.

Conceptually:

```text
SolverState
   ↓
enumerate candidate GameActions
   ↓
Game Engine validation / shared rule primitives
   ↓
next GameState
   ↓
search
```

Never duplicate a slightly different version of gameplay legality.

Preferred implementation:

```text
GameState
   ↓ adapter/canonicalization
SolverNode
   ↓ search
GameAction sequence
   ↓ replay through GameEngine
Winning GameState
```

---

# 5. Solver Result Model

Recommended result type:

```dart
sealed class SolveResult {}
```

Variants:

```text
Solved
Unsolvable
Inconclusive
```

Suggested fields:

## Solved
- solution actions;
- solution length;
- nodes expanded;
- max depth;
- elapsed time;
- transposition hits;
- pruning counters;
- optional score/metrics.

## Unsolvable
- conclusive = true;
- nodes expanded;
- elapsed time;
- search bounds exhausted exhaustively.

## Inconclusive
- reason:
  - timeout;
  - node budget;
  - memory budget;
  - cancellation;
  - unsupported state;
- nodes expanded;
- elapsed time.

Important:

`Inconclusive != Unsolvable`.

---

# 6. Solver Public API

Recommended initial API:

```dart
SolveResult solve({
  required GameState state,
  required SolverOptions options,
});
```

Optional helpers:

```dart
HintResult findHint({
  required GameState state,
  required SolverOptions options,
});

DeadEndResult evaluateDeadEnd({
  required GameState state,
  required SolverOptions options,
});
```

Do not expose internal search structures publicly.

---

# 7. Solver Options

Create a typed configuration object.

Suggested:

```text
maxDepth
moveBudget
timeout
maxExpandedNodes
enableCanonicalization
enableTranspositionTable
enablePruning
searchStrategy
```

Exact production defaults are TBD and should not be hard-coded as permanent tuning decisions.

Provide safe dev/test defaults.

---

# 8. Move Budget Rule

Solver must respect:

```text
state.movesRemaining
```

for player continuation.

For generation validation later, Solver may receive:

```text
moveBudget = level.moveLimit
```

or an equivalent explicit bound.

A solution is valid only if:

```text
solution.length <= moveBudget
```

Each Engine-valid gameplay action costs exactly one Move, so solution depth maps directly to move usage in current rules.

---

# 9. Legal Action Enumeration

Preferred:

Use authoritative Engine-provided legal action enumeration if Sprint 1 exposes it.

If not, implement Solver-side enumeration by constructing candidates and validating them through Engine/shared rules.

Requirements:

- deterministic ordering;
- no invalid actions in returned legal-action list;
- same state → same action ordering;
- stable enough for reproducible tests.

Do not rank actions by UI preference.

---

# 10. Legal Action Categories

Enumerate as applicable:

- Tableau unit → Tableau.
- Stock playable Card → Tableau.
- Association Card → Slot.
- Association Stack → Slot.
- Member / Member Stack → active Association.
- Stock Advance.
- Restore Stock.

Do not include:

- Hint.
- Undo.
- Extra Moves.
- Dead-End rescue.
- economy actions.

### Undo exclusion

Solver should search forward game progression.

Undo is a player convenience mechanic and should not be part of solution search.

---

# 11. Neutral Move Cycles

The game includes actions that may create cycles:

- move to empty Tableau;
- Stock Advance;
- Restore Stock.

Solver must prevent infinite loops.

Use:

- canonical state keys;
- transposition table;
- visited-depth tracking;
- cycle detection.

---

# 12. Canonical State

Canonicalization is required.

Equivalent gameplay states should ideally map to the same key when safe.

Canonical state should include all rule-relevant information:

- Tableau structure;
- hidden Card order;
- exposed units;
- Stock remaining order;
- Stock cursor/window state;
- Association Slots;
- completed Associations;
- Moves remaining where relevant to bounded search;
- streak state only if it affects future legal/winning behavior.

### Important

Streak does **not** affect solvability.

For pure solvability search, streak can be excluded from canonical key if:
- future legal moves are unaffected;
- Win/Out-of-Moves behavior is unaffected.

However, the Solver must still replay actions through full Engine state.

Document any state component intentionally excluded from canonicalization.

---

# 13. Tableau Symmetry Reduction

Optional but strongly recommended after correctness.

If two empty Tableau columns are equivalent, avoid exploring identical permutations.

Potential safe reduction:

- treat identical empty columns as symmetric;
- explore one representative destination.

Do not canonicalize columns that differ in:
- hidden order;
- exposed unit;
- future reveal implications.

---

# 14. Association Slot Symmetry

If multiple Association Slots are empty and functionally identical:

- selecting any one may be equivalent.

Safe optimization:
- canonicalize empty slot permutations;
or
- only generate the first equivalent empty Slot destination.

Do not apply if slot identity later gains gameplay meaning.

Current MVP Slots are functionally equivalent.

---

# 15. Stack Canonicalization

Stacks are atomic.

Canonical representation must preserve:

- stack type;
- association ID;
- contained Card IDs;
- Association Card identity for Association Stack.

Internal Member order is semantically irrelevant under approved rules.

Therefore, Member IDs may be sorted in canonical key if doing so does not affect serialization/replay.

Actual Engine state may preserve original list order.

---

# 16. Search Strategy

Approved direction is hybrid bounded search.

Sprint 2 should implement a pragmatic baseline and benchmark it.

Recommended initial strategy:

## Depth-first iterative deepening / IDA*-style or bounded DFS

Benefits:
- low memory;
- natural Move bound;
- usable for puzzle solving.

Potential enhancement:
- heuristic ordering;
- transposition pruning;
- dead-state pruning.

Exact final algorithm is not canonically fixed yet.

Cursor must not declare one strategy permanent without benchmark evidence.

---

# 17. Suggested v1 Search Architecture

A practical v1:

```text
Iterative Deepening
  +
Depth-Bounded DFS
  +
Canonical State Key
  +
Transposition Table
  +
Move Ordering
  +
Pruning
```

Search depth:

```text
0 .. moveBudget
```

Stop on first valid winning continuation.

For generation difficulty metrics later, optionally support finding:

- first solution;
- shortest solution;
- search effort metrics.

Sprint 2 only needs reliable bounded solving.

---

# 18. Search Node

Internal structure may include:

```text
state
depth
remainingBudget
parent
actionFromParent
canonicalKey
```

Avoid storing full parent chains if action stack is enough.

Memory usage should be measured.

---

# 19. Goal Test

Use Game Engine authoritative outcome.

A state is solved when:

```text
state.status == AttemptStatus.won
```

Do not create a separate Solver-only Win rule.

---

# 20. Out-of-Moves Handling

If:

```text
state.status == outOfMoves
```

and not won:

- branch is terminal failure.

Solver must never simulate Extra Moves in base solvability validation.

Main Journey board must be solvable without paid/rescue mechanics.

---

# 21. Branch Ordering

Correctness does not depend on branch order, but performance does.

Recommended ordering heuristics:

1. Association completion moves.
2. Member → active Association.
3. Association Stack → Slot.
4. Association Card → Slot.
5. same-group merges.
6. Association Card → matching Member Stack.
7. moves that reveal hidden Tableau Cards.
8. productive Stock plays.
9. Stock Advance.
10. empty-column rearrangements.
11. Restore Stock.

This is a heuristic proposal, not a gameplay rule.

Benchmark and refine.

---

# 22. Progress Heuristics

Potential search heuristics:

- fewer remaining Cards;
- more completed Associations;
- more exposed Tableau Cards;
- more active Association progress;
- fewer hidden Cards;
- lower Stock blockage;
- avoid reversible neutral cycles.

Do not use semantic text.

---

# 23. Pruning — Safe Rules

Safe pruning candidates:

- repeated canonical state at same or worse remaining Move budget;
- exact cycle to ancestor state;
- symmetric empty Tableau destinations;
- symmetric empty Slot destinations;
- branches exceeding Move budget;
- terminal out-of-moves states;
- invariant-invalid states.

---

# 24. Transposition Table

Required.

Recommended key-value:

```text
CanonicalStateKey -> bestRemainingMoveBudgetSeen
```

If same canonical state is reached with:

```text
remainingBudget <= previouslySeenBudget
```

prune.

If reached with more remaining budget:
- may need exploration.

Document exact semantics.

---

# 25. Memoization Scope

Default:
- per solve call.

Do not maintain unbounded global transposition cache across unrelated boards.

Future cache reuse can be considered later.

---

# 26. Search Cancellation

Support cancellation.

Required for:

- user navigation;
- app lifecycle;
- generation retries;
- future batch simulation.

Use pure Dart-safe cancellation mechanism.

Do not rely on Flutter-specific types.

---

# 27. Timeout

Solver must support a time budget.

On timeout:

```text
Inconclusive(reason: timeout)
```

Never:

```text
Unsolvable
```

unless the bounded state space was conclusively exhausted.

---

# 28. Node Budget

Support:

```text
maxExpandedNodes
```

If exceeded:

```text
Inconclusive(reason: nodeBudgetExceeded)
```

This protects mobile performance.

---

# 29. Memory Guard

If practical, expose transposition table size and allow a budget.

On inability to continue safely:

```text
Inconclusive(reason: memoryBudgetExceeded)
```

Do not crash or claim Dead-End.

---

# 30. Hint Contract

Hint must suggest a move from a known winning continuation.

Suggested result:

```dart
sealed class HintResult {}
```

Variants:

```text
HintAvailable
NoWinningContinuation
Inconclusive
AlreadyWon
```

`HintAvailable` contains:

- first GameAction;
- optional remaining solution length;
- Solver metrics.

The Hint does not execute the action.

---

# 31. Hint Safety

Do not return:

- a legal-but-losing move;
- heuristic guess without proof;
- invalid Engine move.

If Solver cannot prove a winning continuation within limits:

```text
HintResult.inconclusive
```

Application may then decide UX fallback later.

---

# 32. Dead-End Contract

Recommended:

```dart
sealed class DeadEndResult {}
```

Variants:

```text
NotDeadEnd
ConfirmedDeadEnd
Inconclusive
AlreadyWon
OutOfMoves
```

Meaning:

## NotDeadEnd
A winning continuation was found.

## ConfirmedDeadEnd
Search conclusively proves no winning continuation within remaining Moves.

## Inconclusive
Search budget expired.

Important:
- Inconclusive must never trigger confirmed Dead-End rescue UI.

---

# 33. Dead-End Semantics

Current product rule:

Dead-End means no winning continuation exists from current state under:

- current rules;
- current Moves remaining;
- no Extra Moves;
- no paid rescue;
- no Undo exploration.

Solver must evaluate the forward state only.

---

# 34. Solver Metrics

Expose metrics:

```text
elapsedTime
nodesExpanded
nodesGenerated
maxDepthReached
solutionDepth
transpositionHits
cyclePrunes
symmetryPrunes
budgetPrunes
terminalPrunes
branchingFactor estimate
```

These metrics will later support Difficulty Model calibration.

---

# 35. Difficulty Signals

Do not assign final difficulty labels yet.

Collect raw signals:

- solution length;
- search effort;
- node expansions;
- branching;
- forced-move ratio;
- hidden-card exposure depth;
- Stock dependency;
- number of reversals/neutral moves needed.

Sprint 3/analytics can calibrate these.

---

# 36. Engine Parity Gate

Every solution must be replayed through:

```text
GameEngine.applyAction
```

before returning `Solved`.

If replay fails:

- Solver result is invalid;
- treat as internal Solver defect;
- surface a structured error in debug/test;
- never return solution to UI.

---

# 37. Legal Move Enumeration Parity Test

For sampled states:

1. Solver enumerates legal actions.
2. Apply each action through Engine.
3. Assert every action is accepted.

If Engine exposes legal enumeration:

- compare sets for parity.

This is release-critical.

---

# 38. Golden Boards

Create deterministic fixed boards.

Minimum suite:

### GB-001 — One Move Win
Simple final Association completion.

### GB-002 — Exact Move Limit
Only solution uses exactly all remaining Moves.

### GB-003 — One Move Over Budget
Board solvable in N+1 but state has N Moves.
Expected: Unsolvable within budget.

### GB-004 — Stock Required
Winning line requires Stock Advance.

### GB-005 — Restore Required
Winning line requires Restore Stock.

### GB-006 — Tableau Reveal Required
Must move exposed unit to reveal hidden Card.

### GB-007 — Association Stack Required
Must form Association Stack before Slot.

### GB-008 — Empty Column Rearrangement
Requires neutral empty-column move.

### GB-009 — Symmetric Empty Columns
Tests symmetry reduction.

### GB-010 — Confirmed Dead-End
No winning continuation.

### GB-011 — Cycle Trap
Stock/empty-column cycles exist but Solver terminates.

### GB-012 — Multi-Association Win
Multiple groups with interacting ordering.

### GB-013 — Inconclusive Budget
Artificially tiny node/time budget returns Inconclusive.

### GB-014 — Final Move at Zero
Solution reaches Win with 0 Moves remaining.

---

# 39. Additional Solver Test Matrix

Test:

- solved state returns Solved with zero actions;
- out-of-moves non-win returns Unsolvable/terminal as appropriate;
- invalid Engine state rejected as unsupported/internal error;
- solution length never exceeds move budget;
- same state/options yields deterministic result;
- transposition table reduces repeated exploration;
- cancellation produces Inconclusive/cancelled;
- timeout produces Inconclusive;
- node budget produces Inconclusive;
- first Hint action replay is accepted;
- Hint solution remainder reaches Win;
- confirmed Dead-End only on exhaustive result.

---

# 40. Canonicalization Tests

Test equivalence:

- identical state objects produce same key;
- Member Stack internal ordering produces same key if order is irrelevant;
- equivalent empty Slot choices canonicalize consistently;
- symmetric empty columns handled safely;
- non-equivalent hidden orders produce different keys;
- different Stock remaining order produces different keys;
- different Moves remaining produces appropriate search-key behavior.

---

# 41. Search Determinism

Given:

```text
same state
same options
same code version
```

Solver should produce stable:

- result category;
- action sequence where deterministic ordering is enabled;
- key metrics within expected deterministic bounds.

Elapsed time may vary and should not be asserted exactly.

---

# 42. Search Trace

Optional debug mode:

```text
SolverTrace
```

May record:

- node depth;
- canonical key hash;
- chosen action;
- prune reason.

Disabled by default in production due cost.

Useful for Golden Board failures.

---

# 43. Solver Error Model

Differentiate:

```text
InvalidInput
InternalParityError
UnsupportedRulesVersion
Cancelled
Timeout
NodeBudgetExceeded
MemoryBudgetExceeded
```

Do not collapse all failure modes into `false`.

---

# 44. Rules Version Compatibility

Solver must know which rules version it supports.

GameState serialization should expose:

```text
rulesVersion
```

If unsupported:

```text
Inconclusive / UnsupportedRulesVersion
```

or a dedicated error result.

Do not silently solve under wrong assumptions.

---

# 45. Isolate Compatibility

Design Solver API so it can run in a Dart isolate.

Requirements:

- inputs serializable/transferable;
- no BuildContext;
- no Riverpod refs;
- no platform channel dependencies;
- no Firebase handles.

Actual Flutter isolate integration can be done in Sprint 4.

---

# 46. Mobile Performance Philosophy

Correctness first, but design for mobile.

Avoid:

- recursive structures likely to overflow for modest depth;
- unnecessary deep object clones if safe compact representation exists;
- huge debug logs;
- unbounded transposition growth.

Benchmark representative boards.

---

# 47. Solver State Adapter

Recommended to separate:

```text
GameState
  ↓
SolverState / canonical projection
```

SolverState may omit non-solvability fields such as:
- analytics metadata;
- narrative metadata;
- economy;
- streak Coins if irrelevant to legality.

But replay always uses full GameState.

---

# 48. Compact Representation

Consider compact immutable representation for search:

- Card-location arrays;
- integer IDs;
- bitsets where beneficial;
- compact slot/tableau descriptors.

Do not prematurely optimize before baseline correctness.

Start clean, benchmark, then optimize hot paths.

---

# 49. Search Strategy Interface

Recommended internal abstraction:

```dart
abstract interface class SearchStrategy {
  SolveResult solve(...);
}
```

Possible implementation:

```text
IterativeDeepeningDfsStrategy
```

Keep ability to benchmark alternative algorithms later without changing public Solver API.

Do not build a plugin architecture with unnecessary complexity.

---

# 50. Move Ordering Interface

Optional internal:

```dart
abstract interface class MoveOrdering {
  List<GameAction> order(...);
}
```

Initial heuristic can be deterministic static scoring.

Metrics should allow comparing ordering effectiveness.

---

# 51. Heuristic Scoring — Suggested Baseline

Potential priority score:

```text
+1000 completes Association
+500 attaches Member to active Association
+350 activates Association Stack
+300 activates Association Card
+250 reveals hidden Tableau Card
+200 merges Members
+150 forms Association Stack
+100 productive Stock Card play
+20 Stock Advance
+5 empty Tableau rearrangement
+1 Restore Stock
```

These numbers are implementation heuristics, not product constants.

Keep local to Solver and benchmark them.

---

# 52. Avoiding Harmful Pruning

Never prune solely because a move:

- looks strategically weak;
- moves to empty Tableau;
- uses Restore;
- temporarily increases apparent disorder.

If not mathematically safe, prefer move ordering over pruning.

False pruning can make solvable boards appear unsolvable.

---

# 53. Confirmed Unsolvable Standard

Return `Unsolvable` only when:

- search has exhaustively explored all distinct reachable states within Move budget;
- all legal branches are exhausted;
- no timeout;
- no node budget exceeded;
- no cancellation;
- no unsupported state;
- no memory abort.

Otherwise return `Inconclusive`.

---

# 54. Generation Solver Mode

Prepare Solver options for future Generator use.

Example:

```text
mode = validation
```

Validation may prioritize:
- conclusive result;
- metrics;
- no UI latency concerns;
- larger budget in CI/server tooling.

Do not implement Generator in this sprint.

---

# 55. Player Hint Solver Mode

Example:

```text
mode = hint
```

May prioritize:
- quick first proven winning action;
- lower latency;
- early exit on first solution.

If unable to prove quickly:
- Inconclusive.

---

# 56. Dead-End Solver Mode

Example:

```text
mode = deadEndCheck
```

Must be conservative.

A quick solution proves `NotDeadEnd`.

A confirmed `DeadEnd` may require exhaustive search.

If budget expires:
- Inconclusive.

---

# 57. Benchmark Harness

Create a command-line benchmark utility.

Suggested:

```text
tool/solver_benchmark.dart
```

Inputs:
- Golden Board set;
- Solver options;
- iterations.

Outputs:
- result;
- solution length;
- elapsed ms;
- nodes expanded;
- transposition hits;
- pruning metrics;
- peak table size if tracked.

---

# 58. Benchmark Output

Support:

- console summary;
- machine-readable JSON/CSV output if easy.

Do not require Flutter.

Example fields:

```text
boardId
result
solutionDepth
nodesExpanded
elapsedMs
transpositionHits
maxDepth
```

---

# 59. CI Integration

Add Solver checks to CI.

Required:

- `dart analyze`;
- `dart test`;
- Golden Boards.

Do not run extremely large performance benchmarks on every PR if expensive.

Use:
- small correctness suite on PR;
- heavier benchmark/simulation as manual/nightly/future workflow.

---

# 60. Solver Documentation

Package README must explain:

- Solver purpose;
- authoritative Engine relationship;
- result semantics;
- Inconclusive vs Unsolvable;
- options;
- Hint contract;
- Dead-End contract;
- canonicalization;
- transposition table;
- benchmark command;
- Golden Boards;
- limitations.

---

# 61. Logging

Core Solver should not depend on app logger.

Options:

- optional callback/interface;
- structured trace collector;
- no-op default.

No `print()` in production Solver code.

---

# 62. Serialization

Solver results should be serializable where practical.

Useful for:
- isolate communication;
- QA logs;
- CI artifacts;
- future backend fallback.

Do not serialize internal transposition table.

---

# 63. Solver Version

Expose:

```text
solverVersion
```

This helps future:
- generation reproducibility;
- difficulty metrics;
- bug diagnosis.

Version bump policy can be documented later.

---

# 64. Thread / Isolate Safety

No global mutable search state.

Each solve invocation owns:
- search context;
- transposition table;
- metrics;
- cancellation state.

This allows concurrent solves later.

---

# 65. Cancellation Semantics

If cancelled:

```text
Inconclusive(reason: cancelled)
```

Return cleanly.

Do not throw uncontrolled cancellation exceptions to callers unless API intentionally models them.

---

# 66. Solution Verification

Before returning `Solved`:

1. clone/use original GameState.
2. replay every action through Game Engine.
3. assert accepted.
4. assert final state won.
5. assert action count <= budget.

If any step fails:
- internal parity failure.

---

# 67. Hint Verification

Before returning Hint:

1. obtain solved continuation.
2. take first action.
3. replay entire continuation through Engine.
4. return first action only after validation.

---

# 68. Dead-End Verification

Before returning ConfirmedDeadEnd:

- ensure search ended exhaustively;
- ensure no budget/timeout/cancel flag;
- record conclusive reason.

---

# 69. Search Metrics Accuracy

Counters should be defined consistently.

Example:

- `nodesGenerated`: child candidates created.
- `nodesExpanded`: states whose legal actions were enumerated.
- `transpositionHits`: repeated state prunes.
- `cyclePrunes`: ancestor cycle prunes.

Document definitions.

---

# 70. Solver-Specific Invariants

At runtime/debug:

- remaining budget never negative;
- action depth == path length;
- returned actions all accepted;
- solved result ends won;
- unsolvable result only if exhaustive flag true;
- inconclusive never masquerades as dead-end.

---

# 71. Suggested Package Structure

```text
packages/game_solver/
├── lib/
│   ├── game_solver.dart
│   └── src/
│       ├── api/
│       │   ├── solver.dart
│       │   ├── solver_options.dart
│       │   ├── solve_result.dart
│       │   ├── hint_result.dart
│       │   └── dead_end_result.dart
│       │
│       ├── state/
│       │   ├── solver_state.dart
│       │   ├── state_adapter.dart
│       │   ├── canonical_state_key.dart
│       │   └── canonicalizer.dart
│       │
│       ├── moves/
│       │   ├── legal_action_enumerator.dart
│       │   ├── move_ordering.dart
│       │   └── move_score.dart
│       │
│       ├── search/
│       │   ├── search_strategy.dart
│       │   ├── iterative_deepening_dfs.dart
│       │   ├── search_context.dart
│       │   ├── transposition_table.dart
│       │   ├── search_budget.dart
│       │   └── cancellation_token.dart
│       │
│       ├── metrics/
│       │   └── solver_metrics.dart
│       │
│       ├── verification/
│       │   └── solution_verifier.dart
│       │
│       └── version/
│           └── solver_version.dart
│
├── test/
│   ├── golden_boards/
│   ├── canonicalization/
│   ├── search/
│   ├── hint/
│   ├── dead_end/
│   └── parity/
│
└── tool/
    └── solver_benchmark.dart
```

Keep only abstractions justified by implementation.

---

# 72. Suggested Implementation Order

## Step 1
Solver API + result types + options.

## Step 2
GameState adapter.

## Step 3
Canonical state key.

## Step 4
Legal action enumeration.

## Step 5
Deterministic move ordering.

## Step 6
Search context + budgets + cancellation.

## Step 7
Transposition table.

## Step 8
Bounded DFS baseline.

## Step 9
Iterative deepening wrapper.

## Step 10
Solution verification through Engine.

## Step 11
Hint API.

## Step 12
Dead-End API.

## Step 13
Metrics.

## Step 14
Golden Boards.

## Step 15
Benchmark harness.

## Step 16
Safe symmetry/pruning optimizations.

---

# 73. Suggested Commit Sequence

### Commit 1
```text
feat(solver): add solver api options and result contracts
```

### Commit 2
```text
feat(solver): add engine state adapter and canonical keys
```

### Commit 3
```text
feat(solver): add legal action enumeration and deterministic ordering
```

### Commit 4
```text
feat(solver): add search budgets cancellation and metrics
```

### Commit 5
```text
feat(solver): implement bounded dfs and transposition pruning
```

### Commit 6
```text
feat(solver): add iterative deepening solve strategy
```

### Commit 7
```text
feat(solver): verify winning solutions through game engine
```

### Commit 8
```text
feat(solver): add hint and dead-end evaluation APIs
```

### Commit 9
```text
test(solver): add golden boards engine parity and canonicalization tests
```

### Commit 10
```text
perf(solver): add benchmark harness and safe symmetry reductions
```

### Commit 11
```text
docs(solver): document solver contracts and result semantics
```

---

# 74. Sprint 2 Definition of Done

Sprint 2 is DONE only when:

- [ ] `game_solver` is pure Dart.
- [ ] No Flutter dependency.
- [ ] No Firebase dependency.
- [ ] Solver API implemented.
- [ ] `Solved / Unsolvable / Inconclusive` implemented.
- [ ] typed Solver options implemented.
- [ ] move budget enforced.
- [ ] GameState adapter implemented.
- [ ] canonical state key implemented.
- [ ] deterministic legal action enumeration implemented.
- [ ] every enumerated action accepted by Engine.
- [ ] bounded search implemented.
- [ ] iterative deepening/hybrid baseline implemented.
- [ ] transposition table implemented.
- [ ] cycle detection implemented.
- [ ] safe symmetry reduction implemented or explicitly documented as deferred.
- [ ] timeout support implemented.
- [ ] node budget implemented.
- [ ] cancellation implemented.
- [ ] Solver metrics implemented.
- [ ] solution verification through Engine implemented.
- [ ] Hint returns first action from proven winning continuation.
- [ ] Dead-End returns Confirmed only after exhaustive failure.
- [ ] Inconclusive never shown as Unsolvable.
- [ ] Golden Boards implemented.
- [ ] exact-Move-Limit board passes.
- [ ] Stock-required board passes.
- [ ] Restore-required board passes.
- [ ] cycle-trap board terminates.
- [ ] confirmed Dead-End board passes.
- [ ] canonicalization tests pass.
- [ ] Engine parity tests pass.
- [ ] benchmark CLI exists.
- [ ] package README updated.
- [ ] `dart analyze` passes.
- [ ] `dart test` passes.

---

# 75. Sprint 2 Exit Gate Before Level Generator

Do not start Sprint 3 until:

1. Engine parity suite is green.
2. Golden Boards are green.
3. Solver returns no false `Unsolvable` under budget-abort scenarios.
4. Solution replay is mandatory and passing.
5. benchmark harness produces stable output.
6. baseline performance is measured on representative boards.
7. canonicalization key has been reviewed.
8. transposition behavior is verified.
9. Hint contract is stable.
10. Dead-End contract is stable.

---

# 76. Cursor Execution Prompt — Sprint 2

Use this after Sprint 1 passes its exit gate:

> Implement **Sprint 2 — Solver Core v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_2_Solver_Core_v1.0.md`
> - latest Game Engine specification
> - latest Solver Specification
>
> Work primarily inside `packages/game_solver`.
>
> The Solver must remain pure Dart and must use the Game Engine as the authoritative rules source.
>
> Implement:
>
> - Solver API;
> - `Solved / Unsolvable / Inconclusive`;
> - typed Solver options;
> - GameState → SolverState adapter;
> - canonical state keys;
> - deterministic legal action enumeration;
> - bounded search;
> - iterative deepening / bounded DFS baseline;
> - transposition table;
> - cycle detection;
> - safe symmetry reduction where mathematically valid;
> - timeout;
> - node budget;
> - cancellation;
> - Solver metrics;
> - solution verification by replaying through Game Engine;
> - Hint from a proven winning continuation;
> - conservative Dead-End detection;
> - Golden Boards;
> - Engine parity tests;
> - benchmark CLI.
>
> Critical constraints:
>
> - never duplicate gameplay rules inconsistently;
> - every Solver action must be Engine-valid;
> - Undo is not part of Solver search;
> - Extra Moves and paid rescue are not part of base solvability;
> - solution length must fit the Move budget;
> - timeout/node-budget/cancellation must return `Inconclusive`;
> - only exhaustive search may return `Unsolvable`;
> - `Inconclusive` must never trigger confirmed Dead-End;
> - Hint must never be a heuristic-only guess;
> - Solver must not inspect Arabic display text to determine associations;
> - no Flutter/Firebase/Riverpod/Drift/UI dependencies.
>
> Start with correctness over micro-optimization.
>
> Benchmark before locking final heuristic/search tuning.
>
> If Sprint 1 does not expose legal action enumeration, generate candidate GameActions and validate them through the authoritative Engine rather than creating a competing rule system.
>
> At completion report:
>
> 1. files created/changed;
> 2. Solver public API;
> 3. search strategy implemented;
> 4. canonicalization approach;
> 5. pruning/symmetry rules;
> 6. Golden Boards and parity tests;
> 7. benchmark results;
> 8. analyze/test commands and results;
> 9. unresolved performance or architecture decisions;
> 10. any deviations from this Sprint document and why.

---

# 77. Next Sprint

After Sprint 2 passes the exit gate:

# **Sprint 3 — Level Generator & Difficulty Validation v1**

Expected focus:

- Level Configuration;
- content input contracts;
- deterministic/random seed support;
- card-pool construction;
- Tableau/Stock dealing;
- randomization;
- Solver validation loop;
- fixed Move Limit acceptance;
- Board Difficulty metrics;
- retry/fallback policy;
- generated-board reproducibility;
- batch simulation;
- generator QA;
- first launch Level Configuration templates.

---

**End of Sprint 2 — Solver Core v1**
