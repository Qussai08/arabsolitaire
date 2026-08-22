import 'package:game_engine/game_engine.dart';
import 'package:game_solver/src/dead_end/dead_end_result.dart';
import 'package:game_solver/src/hint/hint_result.dart';
import 'package:game_solver/src/search/iterative_deepening_solver.dart';
import 'package:game_solver/src/search/solve_result.dart';
import 'package:game_solver/src/search/solver_options.dart';

/// Public Solver facade. Engine remains authoritative for legality and win.
final class GameSolver {
  GameSolver({GameEngine? engine})
    : _engine = engine ?? const GameEngine(),
      _search = IterativeDeepeningSolver(engine: engine ?? const GameEngine());

  final GameEngine _engine;
  final IterativeDeepeningSolver _search;

  SolveResult solve({
    required GameState state,
    SolverOptions options = SolverOptions.testDefaults,
  }) {
    return _search.solve(state: state, options: options);
  }

  HintResult findHint({
    required GameState state,
    SolverOptions options = SolverOptions.testDefaults,
  }) {
    if (state.status == AttemptStatus.won || !state.hasRemainingCards) {
      return HintAlreadyWon(
        metrics: solve(state: state, options: options).metrics,
      );
    }

    final result = solve(state: state, options: options);
    return switch (result) {
      Solved(:final actions, :final metrics) =>
        actions.isEmpty
            ? HintAlreadyWon(metrics: metrics)
            : HintAvailable(
                action: actions.first,
                solutionLength: actions.length,
                metrics: metrics,
              ),
      Unsolvable(:final metrics) => HintNoWinningContinuation(metrics: metrics),
      SolveInconclusive(:final reason, :final metrics) => HintInconclusive(
        reason: reason,
        metrics: metrics,
      ),
    };
  }

  DeadEndResult evaluateDeadEnd({
    required GameState state,
    SolverOptions options = SolverOptions.testDefaults,
  }) {
    if (state.status == AttemptStatus.won || !state.hasRemainingCards) {
      return DeadEndAlreadyWon(
        metrics: solve(state: state, options: options).metrics,
      );
    }
    if (state.status == AttemptStatus.outOfMoves) {
      return DeadEndOutOfMoves(
        metrics: solve(state: state, options: options).metrics,
      );
    }

    final result = solve(state: state, options: options);
    return switch (result) {
      Solved(:final metrics) => NotDeadEnd(metrics: metrics),
      Unsolvable(:final metrics) => ConfirmedDeadEnd(metrics: metrics),
      SolveInconclusive(:final reason, :final metrics) => DeadEndInconclusive(
        reason: reason,
        metrics: metrics,
      ),
    };
  }

  /// Forward legal actions only (excludes Undo).
  List<GameAction> legalActions(GameState state) {
    return [
      for (final a in _engine.enumerateLegalActions(state))
        if (a is! UndoLastMove) a,
    ];
  }
}
