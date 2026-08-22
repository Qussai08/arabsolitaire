import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/level_generator.dart';

/// Shared helpers for GG golden / unit tests.
abstract final class GeneratorFixtures {
  static LevelGenerator get generator => LevelGenerator();

  static FixedContentSelector contentFor(LevelConfiguration config) {
    return FixedContentSelector(
      SyntheticContent.forProfile(config.groupSizeProfile),
    );
  }

  static GenerationResult generateEarly3x1({
    int seed = 7,
    DifficultyTarget difficulty = DifficultyTarget.any,
    int moveLimit = 30,
    int maxAttempts = 40,
    SolverOptions? solverOptions,
    bool includeSolution = true,
  }) {
    final config = LevelConfiguration(
      levelDefinitionId: 'gg_early_3x1',
      groupSizeProfile: const [1, 1, 1],
      tableauColumnSizes: const [2, 2, 1],
      stockCardCount: 1,
      associationSlotCount: 1,
      moveLimit: moveLimit,
      difficultyTarget: difficulty,
      maxGenerationAttempts: maxAttempts,
      solverOptions: solverOptions ?? SolverOptions.testDefaults,
      includeSolutionActions: includeSolution,
    );
    return generator.generate(
      config: config,
      contentSelector: contentFor(config),
      baseSeed: GenerationSeed(seed),
    );
  }

  /// Minimal one-move-to-win board for difficulty unit tests.
  static GameState oneMoveWin({int moveLimit = 5}) {
    const assoc = 'assoc_a';
    final aCard = AssociationCard(id: 'a_card', associationId: assoc);
    final a1 = MemberCard(id: 'a1', associationId: assoc);
    return GameState(
      attemptId: 'fixture',
      levelDefinitionId: 'fixture',
      associations: {
        assoc: AssociationDefinition(
          associationId: assoc,
          associationCardId: 'a_card',
          requiredMemberCardIds: const {'a1'},
        ),
      },
      tableau: [columnWithTop(a1)],
      stock: const StockState(),
      slots: [
        AssociationSlot(
          index: 0,
          activeAssociation: AssociationStack(associationCard: aCard),
        ),
      ],
      moveLimit: moveLimit,
      movesRemaining: moveLimit,
    );
  }

  /// Restore-required board (from Solver golden pattern).
  static GameState restoreRequired({int moveLimit = 20}) {
    const a = 'assoc_a';
    const b = 'assoc_b';
    return GameState(
      attemptId: 'restore_gg',
      levelDefinitionId: 'restore_gg',
      associations: {
        a: AssociationDefinition(
          associationId: a,
          associationCardId: 'a_card',
          requiredMemberCardIds: const {'a1'},
        ),
        b: AssociationDefinition(
          associationId: b,
          associationCardId: 'b_card',
          requiredMemberCardIds: const {'b1'},
        ),
      },
      tableau: [
        columnWithTop(AssociationCard(id: 'a_card', associationId: a)),
        columnWithTop(AssociationCard(id: 'b_card', associationId: b)),
      ],
      stock: StockState(
        undealt: const [],
        waste: [
          MemberCard(id: 'a1', associationId: a),
          MemberCard(id: 'b1', associationId: b),
        ],
      ),
      slots: [const AssociationSlot(index: 0)],
      moveLimit: moveLimit,
      movesRemaining: moveLimit,
    );
  }

  static GameState unsolvableOverBudget() {
    const assoc = 'assoc_a';
    return GameState(
      attemptId: 'unsolvable',
      levelDefinitionId: 'unsolvable',
      associations: {
        assoc: AssociationDefinition(
          associationId: assoc,
          associationCardId: 'a_card',
          requiredMemberCardIds: const {'a1'},
        ),
      },
      tableau: [
        columnWithTop(AssociationCard(id: 'a_card', associationId: assoc)),
        columnWithTop(MemberCard(id: 'a1', associationId: assoc)),
      ],
      stock: const StockState(),
      slots: [const AssociationSlot(index: 0)],
      moveLimit: 1,
      movesRemaining: 1,
    );
  }
}
