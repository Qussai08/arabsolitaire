import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';

/// Placeholder generator boundary for Sprint 0.
abstract interface class LevelGeneratorContract {
  String get enginePackageVersion;
  String get solverPackageVersion;
}

/// Minimal Sprint 0 stub proving Engine + Solver wiring.
final class PlaceholderLevelGenerator implements LevelGeneratorContract {
  PlaceholderLevelGenerator({SolverContract? solver})
    : _solver = solver ?? PlaceholderSolver();

  final SolverContract _solver;

  @override
  String get enginePackageVersion => gameEnginePackageVersion;

  @override
  String get solverPackageVersion =>
      '${gameSolverPackageVersion}+${_solver.enginePackageVersion}';
}
