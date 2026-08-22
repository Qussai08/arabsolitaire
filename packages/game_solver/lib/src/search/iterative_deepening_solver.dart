import 'package:game_engine/game_engine.dart';
import 'package:game_solver/src/canonical/canonical_state_key.dart';
import 'package:game_solver/src/metrics/solver_metrics.dart';
import 'package:game_solver/src/ordering/move_ordering.dart';
import 'package:game_solver/src/search/solve_result.dart';
import 'package:game_solver/src/search/solver_options.dart';
import 'package:game_solver/src/version/package_version.dart';

/// Bounded iterative-deepening DFS with transposition table.
final class IterativeDeepeningSolver {
  IterativeDeepeningSolver({this.engine = const GameEngine()});

  final GameEngine engine;

  SolveResult solve({
    required GameState state,
    required SolverOptions options,
  }) {
    final started = DateTime.now().toUtc();
    final metrics = _Metrics();

    if (!gameSolverSupportedRulesVersions.contains(state.rulesVersion)) {
      return SolveInconclusive(
        reason: InconclusiveReason.unsupportedRulesVersion,
        metrics: metrics.snapshot(started),
      );
    }

    if (state.status == AttemptStatus.won || !state.hasRemainingCards) {
      return Solved(actions: const [], metrics: metrics.snapshot(started));
    }

    if (state.status == AttemptStatus.outOfMoves) {
      return Unsolvable(metrics: metrics.snapshot(started));
    }

    final moveBudget = options.moveBudget ?? state.movesRemaining;
    if (moveBudget < 0) {
      return SolveInconclusive(
        reason: InconclusiveReason.invalidInput,
        metrics: metrics.snapshot(started),
      );
    }
    if (moveBudget == 0) {
      return Unsolvable(metrics: metrics.snapshot(started));
    }

    final maxDepth = options.maxDepth ?? moveBudget;
    final deadline = options.timeout == null
        ? null
        : started.add(options.timeout!);

    final transposition = <String, int>{};
    List<GameAction>? solution;

    for (var depthLimit = 0; depthLimit <= maxDepth; depthLimit++) {
      // Clear TT each iteration — depth-limited failures must not poison later depths.
      transposition.clear();

      final abort = _AbortCheck(
        options: options,
        deadline: deadline,
        metrics: metrics,
      );
      if (abort.reason != null) {
        return SolveInconclusive(
          reason: abort.reason!,
          metrics: metrics.snapshot(started),
        );
      }

      final path = <GameAction>[];
      final result = _dfs(
        state: state,
        depth: 0,
        depthLimit: depthLimit,
        path: path,
        transposition: transposition,
        options: options,
        metrics: metrics,
        abort: abort,
      );

      if (result == _DfsOutcome.solved) {
        solution = List<GameAction>.from(path);
        break;
      }
      if (result == _DfsOutcome.aborted) {
        return SolveInconclusive(
          reason: abort.reason!,
          metrics: metrics.snapshot(started),
        );
      }
    }

    if (solution == null) {
      return Unsolvable(metrics: metrics.snapshot(started));
    }

    final replay = GameReplay.run(initialState: state, actions: solution);
    if (!replay.succeeded || replay.finalState.status != AttemptStatus.won) {
      return SolveInconclusive(
        reason: InconclusiveReason.internalParityError,
        metrics: metrics.snapshot(started, solutionDepth: solution.length),
      );
    }
    for (final t in replay.transitions) {
      if (!t.accepted) {
        return SolveInconclusive(
          reason: InconclusiveReason.internalParityError,
          metrics: metrics.snapshot(started, solutionDepth: solution.length),
        );
      }
    }

    return Solved(
      actions: solution,
      metrics: metrics.snapshot(started, solutionDepth: solution.length),
    );
  }

  _DfsOutcome _dfs({
    required GameState state,
    required int depth,
    required int depthLimit,
    required List<GameAction> path,
    required Map<String, int> transposition,
    required SolverOptions options,
    required _Metrics metrics,
    required _AbortCheck abort,
  }) {
    if (abort.hit()) return _DfsOutcome.aborted;

    metrics.nodesExpanded++;
    if (depth > metrics.maxDepthReached) {
      metrics.maxDepthReached = depth;
    }

    if (state.status == AttemptStatus.won || !state.hasRemainingCards) {
      return _DfsOutcome.solved;
    }
    if (state.status == AttemptStatus.outOfMoves || state.movesRemaining <= 0) {
      metrics.terminalPrunes++;
      return _DfsOutcome.failed;
    }
    if (depth >= depthLimit) {
      return _DfsOutcome.failed;
    }

    final key = options.enableCanonicalization
        ? CanonicalStateKey.of(state)
        : 'd$depth-${identityHashCode(state)}';

    if (options.enableTranspositionTable) {
      final seenBudget = transposition[key];
      if (seenBudget != null && seenBudget >= state.movesRemaining) {
        metrics.transpositionHits++;
        return _DfsOutcome.failed;
      }
      if (transposition.length >= options.maxTranspositionEntries) {
        abort.reason = InconclusiveReason.memoryBudgetExceeded;
        return _DfsOutcome.aborted;
      }
      transposition[key] = state.movesRemaining;
    }

    var actions = _legalForwardActions(state, options, metrics);
    metrics.nodesGenerated += actions.length;

    if (options.enableMoveOrdering) {
      actions = MoveOrdering.order(
        state: state,
        actions: actions,
        engine: engine,
      );
    }

    var anyChild = false;
    for (final action in actions) {
      if (abort.hit()) return _DfsOutcome.aborted;
      anyChild = true;
      final transition = engine.applyAction(state, action);
      if (!transition.accepted) {
        continue;
      }

      path.add(action);
      final child = _dfs(
        state: transition.nextState,
        depth: depth + 1,
        depthLimit: depthLimit,
        path: path,
        transposition: transposition,
        options: options,
        metrics: metrics,
        abort: abort,
      );
      if (child == _DfsOutcome.solved) {
        return _DfsOutcome.solved;
      }
      path.removeLast();
      if (child == _DfsOutcome.aborted) {
        return _DfsOutcome.aborted;
      }
    }

    if (!anyChild) {
      metrics.terminalPrunes++;
    }
    return _DfsOutcome.failed;
  }

  List<GameAction> _legalForwardActions(
    GameState state,
    SolverOptions options,
    _Metrics metrics,
  ) {
    final filtered = <GameAction>[
      for (final a in engine.enumerateLegalActions(state))
        if (a is! UndoLastMove) a,
    ];

    if (!options.enableSymmetryReduction) {
      return filtered;
    }

    return _applySymmetry(state, filtered, metrics);
  }

  List<GameAction> _applySymmetry(
    GameState state,
    List<GameAction> actions,
    _Metrics metrics,
  ) {
    final result = <GameAction>[];
    var usedEmptyTableau = false;
    var usedEmptySlot = false;

    for (final action in actions) {
      if (action is MoveTableauToTableau) {
        if (state.tableau[action.toColumn].isEmpty) {
          if (usedEmptyTableau) {
            metrics.symmetryPrunes++;
            continue;
          }
          usedEmptyTableau = true;
        }
      } else if (action is MoveStockToTableau) {
        if (state.tableau[action.toColumn].isEmpty) {
          if (usedEmptyTableau) {
            metrics.symmetryPrunes++;
            continue;
          }
          usedEmptyTableau = true;
        }
      } else if (action is MoveTableauToSlot) {
        if (state.slots[action.slotIndex].isEmpty) {
          if (usedEmptySlot) {
            metrics.symmetryPrunes++;
            continue;
          }
          usedEmptySlot = true;
        }
      } else if (action is MoveStockToSlot) {
        if (state.slots[action.slotIndex].isEmpty) {
          if (usedEmptySlot) {
            metrics.symmetryPrunes++;
            continue;
          }
          usedEmptySlot = true;
        }
      }
      result.add(action);
    }
    return result;
  }
}

enum _DfsOutcome { solved, failed, aborted }

final class _Metrics {
  int nodesExpanded = 0;
  int nodesGenerated = 0;
  int maxDepthReached = 0;
  int transpositionHits = 0;
  int cyclePrunes = 0;
  int symmetryPrunes = 0;
  int budgetPrunes = 0;
  int terminalPrunes = 0;

  SolverMetrics snapshot(DateTime started, {int? solutionDepth}) {
    return SolverMetrics(
      elapsed: DateTime.now().toUtc().difference(started),
      nodesExpanded: nodesExpanded,
      nodesGenerated: nodesGenerated,
      maxDepthReached: maxDepthReached,
      solutionDepth: solutionDepth,
      transpositionHits: transpositionHits,
      cyclePrunes: cyclePrunes,
      symmetryPrunes: symmetryPrunes,
      budgetPrunes: budgetPrunes,
      terminalPrunes: terminalPrunes,
    );
  }
}

final class _AbortCheck {
  _AbortCheck({
    required this.options,
    required this.deadline,
    required this.metrics,
  });

  final SolverOptions options;
  final DateTime? deadline;
  final _Metrics metrics;
  InconclusiveReason? reason;

  bool hit() {
    if (options.cancellationToken?.isCancelled ?? false) {
      reason = InconclusiveReason.cancelled;
      return true;
    }
    if (deadline != null && DateTime.now().toUtc().isAfter(deadline!)) {
      reason = InconclusiveReason.timeout;
      return true;
    }
    if (metrics.nodesExpanded >= options.maxExpandedNodes) {
      reason = InconclusiveReason.nodeBudgetExceeded;
      return true;
    }
    return reason != null;
  }
}
