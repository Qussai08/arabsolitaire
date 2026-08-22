import 'package:level_generator/level_generator.dart';
import 'package:test/test.dart';

void main() {
  test('level_generator package resolves and links engine + solver', () {
    expect(levelGeneratorPackageVersion, '0.1.0');
    final generator = LevelGenerator();
    expect(generator.enginePackageVersion, isNotEmpty);
    expect(generator.solverPackageVersion, isNotEmpty);
    expect(generator.generatorVersion, levelGeneratorVersion);
  });
}
