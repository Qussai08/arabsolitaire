import 'package:game_engine/game_engine.dart';
import 'package:game_solver/src/metrics/solver_metrics.dart';
import 'package:game_solver/src/search/solver_options.dart';

sealed class HintResult {
  const HintResult({required this.metrics});
  final SolverMetrics metrics;
}

final class HintAvailable extends HintResult {
  const HintAvailable({
    required this.action,
    required this.solutionLength,
    required super.metrics,
  });

  final GameAction action;
  final int solutionLength;
}

final class HintNoWinningContinuation extends HintResult {
  const HintNoWinningContinuation({required super.metrics});
}

final class HintInconclusive extends HintResult {
  const HintInconclusive({required this.reason, required super.metrics});

  final InconclusiveReason reason;
}

final class HintAlreadyWon extends HintResult {
  const HintAlreadyWon({required super.metrics});
}
