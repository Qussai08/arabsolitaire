import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:test/test.dart';

void main() {
  test('game_solver package resolves and links game_engine', () {
    expect(gameSolverPackageVersion, isNotEmpty);
    final solver = PlaceholderSolver();
    expect(solver.enginePackageVersion, gameEnginePackageVersion);
  });
}
