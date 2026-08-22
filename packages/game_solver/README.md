# game_solver

Pure Dart Solver for **سوليتير العرب**. Depends only on `game_engine`.

## API

```dart
final solver = GameSolver();
final result = solver.solve(state: state, options: SolverOptions.testDefaults);
final hint = solver.findHint(state: state);
final deadEnd = solver.evaluateDeadEnd(state: state);
```

## Guarantees

- Every returned solution replays through `GameEngine` to `won`.
- Timeout / node budget → `Inconclusive` (never false `Unsolvable`).
- Hint only from a proven winning continuation.
- Confirmed Dead-End only after exhaustive `Unsolvable`.
- Undo is excluded from search.

## Search

Iterative deepening DFS + canonical keys + transposition table + heuristic ordering.
