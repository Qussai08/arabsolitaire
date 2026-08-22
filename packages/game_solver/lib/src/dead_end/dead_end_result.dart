import 'package:game_solver/src/metrics/solver_metrics.dart';
import 'package:game_solver/src/search/solver_options.dart';

sealed class DeadEndResult {
  const DeadEndResult({required this.metrics});
  final SolverMetrics metrics;
}

final class NotDeadEnd extends DeadEndResult {
  const NotDeadEnd({required super.metrics});
}

final class ConfirmedDeadEnd extends DeadEndResult {
  const ConfirmedDeadEnd({required super.metrics});
}

final class DeadEndInconclusive extends DeadEndResult {
  const DeadEndInconclusive({required this.reason, required super.metrics});

  final InconclusiveReason reason;
}

final class DeadEndAlreadyWon extends DeadEndResult {
  const DeadEndAlreadyWon({required super.metrics});
}

final class DeadEndOutOfMoves extends DeadEndResult {
  const DeadEndOutOfMoves({required super.metrics});
}
