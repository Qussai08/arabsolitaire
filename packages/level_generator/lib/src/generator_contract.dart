import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';

/// Placeholder generator boundary until Sprint 3.
abstract interface class LevelGeneratorContract {
  String get enginePackageVersion;
  String get solverPackageVersion;
}

/// Minimal stub proving Engine + Solver package wiring.
final class PlaceholderLevelGenerator implements LevelGeneratorContract {
  PlaceholderLevelGenerator();

  @override
  String get enginePackageVersion => gameEnginePackageVersion;

  @override
  String get solverPackageVersion => gameSolverPackageVersion;
}
