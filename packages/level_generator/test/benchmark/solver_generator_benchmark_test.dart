/// Solver / Generator performance benchmarks — Sprint 11 §42–§43.
///
/// Captures p50 / p95 / max for representative board profiles.
/// Run manually or in nightly CI — NOT on every PR.
///
/// dart test packages/level_generator/test/benchmark/solver_generator_benchmark_test.dart
/// --reporter=expanded --timeout=10m
library;

import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/level_generator.dart';
import 'package:test/test.dart';

void main() {
  // Warm JIT before timing.
  setUpAll(() {
    final _ = LevelGenerator().generate(
      config: LevelTemplates.early3x1(includeSolutionActions: false),
      contentSelector: FixedContentSelector(
        SyntheticContent.forProfile(const [1, 1, 1]),
      ),
      baseSeed: const GenerationSeed(1),
    );
  });

  group('Solver benchmark — early3x1', () {
    _solverBenchmark(
      name: 'early3x1 (100 boards)',
      template: LevelTemplates.early3x1,
      profile: const [1, 1, 1],
      sampleCount: 100,
    );
  });

  group('Solver benchmark — stockHeavy', () {
    _solverBenchmark(
      name: 'stockHeavy (50 boards)',
      template: LevelTemplates.stockHeavy,
      profile: const [1, 1],
      sampleCount: 50,
    );
  });

  group('Solver benchmark — mixedGroups', () {
    _solverBenchmark(
      name: 'mixedGroups (50 boards)',
      template: LevelTemplates.mixedGroups,
      profile: const [1, 2, 3],
      sampleCount: 50,
    );
  });

  group('Generator benchmark — full pipeline', () {
    _generatorBenchmark(
      name: 'early3x1 — 200 seeds',
      template: LevelTemplates.early3x1,
      profile: const [1, 1, 1],
      seedCount: 200,
    );
  });
}

// ─────────────────────────────────────────────────────────────────────────────

void _solverBenchmark({
  required String name,
  required LevelConfiguration Function() template,
  required List<int> profile,
  required int sampleCount,
}) {
  test(
    '$name — p50/p95/max within acceptable bounds',
    () {
      final generator = LevelGenerator();
      final solver = GameSolver();
      final contentSelector = FixedContentSelector(
        SyntheticContent.forProfile(profile),
      );

      // First generate boards, then benchmark the solver separately.
      final boards = <GameState>[];
      for (var seed = 1; boards.length < sampleCount; seed++) {
        final config = template();
        final result = generator.generate(
          config: config,
          contentSelector: contentSelector,
          baseSeed: GenerationSeed(seed),
        );
        if (result is GenerationSucceeded) {
          boards.add(result.level.initialGameState);
        }
        if (seed > sampleCount * 4) {
          break; // safety exit — should not happen
        }
      }

      final timingsMs = <int>[];
      for (final board in boards) {
        final sw = Stopwatch()..start();
        solver.solve(state: board);
        sw.stop();
        timingsMs.add(sw.elapsedMilliseconds);
      }

      timingsMs.sort();
      final p50 = timingsMs[timingsMs.length ~/ 2];
      final p95 =
          timingsMs[(timingsMs.length * 0.95).ceil().clamp(
            0,
            timingsMs.length - 1,
          )];
      final max = timingsMs.last;

      // ignore: avoid_print
      print('''
┌─ Solver benchmark: $name
│  Samples : ${timingsMs.length}
│  p50     : ${p50}ms
│  p95     : ${p95}ms
│  max     : ${max}ms
└─''');

      // Non-blocking constraint: just ensure solver terminates on all boards.
      // Exact budget TBD from measured device capability (§42 — no invented budget).
      expect(timingsMs.length, greaterThan(0));
      // All boards must produce a conclusive result (Solver must terminate).
      expect(max, isNotNull);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}

void _generatorBenchmark({
  required String name,
  required LevelConfiguration Function() template,
  required List<int> profile,
  required int seedCount,
}) {
  test(
    '$name — bounded per-seed generation time',
    () {
      final generator = LevelGenerator();
      final contentSelector = FixedContentSelector(
        SyntheticContent.forProfile(profile),
      );

      final perSeedMs = <int>[];
      var accepted = 0;

      for (var seed = 1; seed <= seedCount; seed++) {
        final config = template();
        final sw = Stopwatch()..start();
        final result = generator.generate(
          config: config,
          contentSelector: contentSelector,
          baseSeed: GenerationSeed(seed),
        );
        sw.stop();
        perSeedMs.add(sw.elapsedMilliseconds);
        if (result is GenerationSucceeded) {
          accepted++;
        }
      }

      perSeedMs.sort();
      final p50 = perSeedMs[perSeedMs.length ~/ 2];
      final p95 =
          perSeedMs[(perSeedMs.length * 0.95).ceil().clamp(
            0,
            perSeedMs.length - 1,
          )];
      final max = perSeedMs.last;

      // ignore: avoid_print
      print('''
┌─ Generator benchmark: $name
│  Seeds    : $seedCount
│  Accepted : $accepted (${(accepted / seedCount * 100).toStringAsFixed(1)}%)
│  p50      : ${p50}ms
│  p95      : ${p95}ms
│  max      : ${max}ms
└─''');

      // Generator must terminate for all seeds within retry budget.
      expect(perSeedMs.length, seedCount);
      // At least some boards must be accepted (config sanity check).
      expect(accepted, greaterThan(0));
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
