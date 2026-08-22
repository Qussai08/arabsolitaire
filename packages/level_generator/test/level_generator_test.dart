import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/level_generator.dart';
import 'package:test/test.dart';

void main() {
  test('level_generator package resolves and links engine + solver', () {
    expect(levelGeneratorPackageVersion, isNotEmpty);
    final generator = PlaceholderLevelGenerator();
    expect(generator.enginePackageVersion, gameEnginePackageVersion);
    expect(generator.solverPackageVersion, gameSolverPackageVersion);
  });
}
