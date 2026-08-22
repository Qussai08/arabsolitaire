// Solver micro-benchmark harness (Sprint 2).
//
// Run: dart run benchmark/solver_benchmark.dart

import 'package:game_solver/game_solver.dart';

import '../test/fixtures/solver_fixtures.dart';

void main() {
  final solver = GameSolver();
  const options = SolverOptions(
    timeout: Duration(seconds: 10),
    maxExpandedNodes: 200000,
  );

  final boards = <String, dynamic>{
    'GB-001': SolverFixtures.oneMoveWin(),
    'GB-002': SolverFixtures.exactTwoMoves(),
    'GB-004': SolverFixtures.stockRequired(),
    'GB-012': SolverFixtures.multiAssociation(),
  };

  for (final entry in boards.entries) {
    final result = solver.solve(
      state: entry.value as dynamic,
      options: options,
    );
    final label = switch (result) {
      Solved(:final solutionLength, :final metrics) =>
        'Solved len=$solutionLength nodes=${metrics.nodesExpanded} '
            'ms=${metrics.elapsed.inMilliseconds}',
      Unsolvable(:final metrics) =>
        'Unsolvable nodes=${metrics.nodesExpanded} '
            'ms=${metrics.elapsed.inMilliseconds}',
      SolveInconclusive(:final reason, :final metrics) =>
        'Inconclusive $reason nodes=${metrics.nodesExpanded} '
            'ms=${metrics.elapsed.inMilliseconds}',
    };
    // ignore: avoid_print
    print('${entry.key}: $label');
  }
}
