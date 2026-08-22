import 'package:game_engine/game_engine.dart';
import 'package:game_solver/src/metrics/solver_metrics.dart';
import 'package:game_solver/src/search/solver_options.dart';

sealed class SolveResult {
  const SolveResult({required this.metrics});

  final SolverMetrics metrics;
}

final class Solved extends SolveResult {
  const Solved({required this.actions, required super.metrics});

  final List<GameAction> actions;

  int get solutionLength => actions.length;
}

final class Unsolvable extends SolveResult {
  const Unsolvable({required super.metrics, this.conclusive = true});

  final bool conclusive;
}

final class SolveInconclusive extends SolveResult {
  const SolveInconclusive({required this.reason, required super.metrics});

  final InconclusiveReason reason;
}
