/// Crash recovery and lifecycle reliability tests — Sprint 11 §50.
///
/// Verifies that generation, solver, and replay are idempotent —
/// i.e., repeating the same operation after a simulated interruption
/// produces the same valid result.
///
/// These are unit-level recovery invariants. End-to-end app lifecycle
/// scenarios (kill during purchase, kill during bundle activation, etc.)
/// require device / integration test runs against the STAGING environment.
library;

import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/level_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Generator idempotency (crash-recovery invariant)', () {
    test('same seed always produces same accepted board after interruption', () {
      // Simulates: app killed between generation calls — next launch
      // regenerates with the same seed and must get the same board.
      const seed = GenerationSeed(42);
      final config = LevelTemplates.early3x1(includeSolutionActions: true);
      final contentSelector = FixedContentSelector(
        SyntheticContent.forProfile(config.groupSizeProfile),
      );

      final first = LevelGenerator().generate(
        config: config,
        contentSelector: contentSelector,
        baseSeed: seed,
      );
      final second = LevelGenerator().generate(
        config: config,
        contentSelector: contentSelector,
        baseSeed: seed,
      );

      expect(first, isA<GenerationSucceeded>());
      expect(second, isA<GenerationSucceeded>());
      final a = (first as GenerationSucceeded).level;
      final b = (second as GenerationSucceeded).level;
      expect(a.initialGameState, b.initialGameState,
          reason: 'Same seed must produce identical board on retry');
      expect(a.seed, b.seed);
      expect(a.generationAttempts, b.generationAttempts);
    });

    test('replay idempotency: same solution replays to Win every time', () {
      // Simulates: solution was persisted before crash; must replay safely.
      const seed = GenerationSeed(77);
      final config = LevelTemplates.early3x1(includeSolutionActions: true);
      final contentSelector = FixedContentSelector(
        SyntheticContent.forProfile(config.groupSizeProfile),
      );

      final result = LevelGenerator().generate(
        config: config,
        contentSelector: contentSelector,
        baseSeed: seed,
      );
      expect(result, isA<GenerationSucceeded>());
      final level = (result as GenerationSucceeded).level;
      final actions = level.solutionActions!;

      // Replay three times (simulating retry-after-crash).
      for (var i = 0; i < 3; i++) {
        final replay = GameReplay.run(
          initialState: level.initialGameState,
          actions: actions,
        );
        expect(
          replay.succeeded,
          isTrue,
          reason: 'Replay attempt $i must succeed',
        );
        expect(
          replay.finalState.status,
          AttemptStatus.won,
          reason: 'Replay attempt $i must reach Won',
        );
      }
    });

    test('generation failure is conclusive — no infinite retry', () {
      // Verify that a generator configured with minimal attempts returns
      // a definitive result (Inconclusive or Failed) rather than hanging.
      final config = LevelConfiguration(
        levelDefinitionId: 'reliability_minimal',
        groupSizeProfile: const [1, 1, 1],
        tableauColumnSizes: const [2, 2, 1],
        stockCardCount: 1,
        associationSlotCount: 1,
        moveLimit: 1, // deliberately too tight to solve
        difficultyTarget: DifficultyTarget.any,
        maxGenerationAttempts: 5,
        solverOptions: SolverOptions.testDefaults,
      );
      final contentSelector = FixedContentSelector(
        SyntheticContent.forProfile(config.groupSizeProfile),
      );

      final sw = Stopwatch()..start();
      final result = LevelGenerator().generate(
        config: config,
        contentSelector: contentSelector,
        baseSeed: const GenerationSeed(99),
      );
      sw.stop();

      // Must return a definitive non-success result, not hang.
      expect(result, isNot(isA<GenerationSucceeded>()));
      // Must return within a reasonable time (not an infinite loop).
      expect(
        sw.elapsedSeconds,
        lessThan(30),
        reason: 'Generator must return within 30s on constrained config',
      );
    });

    test('Engine invariant holds after each accepted generation', () {
      // Verify no generation produces an invalid initial state.
      final engine = const GameEngine();
      final config = LevelTemplates.stockHeavy();
      final contentSelector = FixedContentSelector(
        SyntheticContent.forProfile(config.groupSizeProfile),
      );

      for (var seed = 1; seed <= 50; seed++) {
        final result = LevelGenerator().generate(
          config: config,
          contentSelector: contentSelector,
          baseSeed: GenerationSeed(seed),
        );
        if (result is GenerationSucceeded) {
          expect(
            engine.validate(result.level.initialGameState),
            isTrue,
            reason: 'Engine invariant failed for seed $seed',
          );
        }
      }
    });
  });
}

extension on Stopwatch {
  double get elapsedSeconds => elapsedMilliseconds / 1000.0;
}
