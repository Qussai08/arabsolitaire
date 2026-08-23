import 'package:level_generator/src/difficulty/difficulty_models.dart';
import 'package:level_generator/src/model/association_variant.dart';
import 'package:level_generator/src/model/level_configuration.dart';

/// Engineering templates (not final launch content).
abstract final class LevelTemplates {
  /// Small easy: 3 Associations × 1 member, open Tableau.
  static LevelConfiguration early3x1({
    DifficultyTarget difficulty = DifficultyTarget.any,
    int moveLimit = 30,
    int maxGenerationAttempts = 40,
    bool includeSolutionActions = false,
  }) {
    // Cards: 3*(1+1)=6; tableau [2,2,1]=5; stock=1
    return LevelConfiguration(
      levelDefinitionId: 'template_early_3x1',
      groupSizeProfile: const [1, 1, 1],
      tableauColumnSizes: const [2, 2, 1],
      stockCardCount: 1,
      associationSlotCount: 1,
      moveLimit: moveLimit,
      difficultyTarget: difficulty,
      maxGenerationAttempts: maxGenerationAttempts,
      includeSolutionActions: includeSolutionActions,
    );
  }

  /// Doc-shaped GG-001: 3 Associations × 3 members.
  static LevelConfiguration early3x3({
    DifficultyTarget difficulty = DifficultyTarget.any,
    int moveLimit = 60,
    int maxGenerationAttempts = 30,
  }) {
    // Cards: 3*(1+3)=12; tableau [3,3,3]=9; stock=3
    return LevelConfiguration(
      levelDefinitionId: 'template_early_3x3',
      groupSizeProfile: const [3, 3, 3],
      tableauColumnSizes: const [3, 3, 3],
      stockCardCount: 3,
      associationSlotCount: 2,
      moveLimit: moveLimit,
      difficultyTarget: difficulty,
      maxGenerationAttempts: maxGenerationAttempts,
    );
  }

  /// Stock-heavier layout.
  static LevelConfiguration stockHeavy({
    DifficultyTarget difficulty = DifficultyTarget.any,
    int moveLimit = 40,
  }) {
    // Cards: 2*(1+1)=4; tableau [1,1]=2; stock=2
    return LevelConfiguration(
      levelDefinitionId: 'template_stock_heavy',
      groupSizeProfile: const [1, 1],
      tableauColumnSizes: const [1, 1],
      stockCardCount: 2,
      associationSlotCount: 1,
      moveLimit: moveLimit,
      difficultyTarget: difficulty,
      maxGenerationAttempts: 50,
    );
  }

  /// Reveal-heavy: deeper columns.
  static LevelConfiguration revealHeavy({
    DifficultyTarget difficulty = DifficultyTarget.any,
    int moveLimit = 40,
  }) {
    // Cards: 2*(1+2)=6; tableau [3,2]=5; stock=1
    return LevelConfiguration(
      levelDefinitionId: 'template_reveal_heavy',
      groupSizeProfile: const [2, 2],
      tableauColumnSizes: const [3, 2],
      stockCardCount: 1,
      associationSlotCount: 1,
      moveLimit: moveLimit,
      difficultyTarget: difficulty,
      maxGenerationAttempts: 50,
    );
  }

  /// Mixed group sizes.
  static LevelConfiguration mixedGroups({
    DifficultyTarget difficulty = DifficultyTarget.any,
    int moveLimit = 50,
  }) {
    // Cards: (1+1)+(1+2)+(1+3)=9; tableau [2,2,2,2]=8; stock=1
    return LevelConfiguration(
      levelDefinitionId: 'template_mixed',
      groupSizeProfile: const [1, 2, 3],
      tableauColumnSizes: const [2, 2, 2, 2],
      stockCardCount: 1,
      associationSlotCount: 2,
      moveLimit: moveLimit,
      difficultyTarget: difficulty,
      maxGenerationAttempts: 40,
    );
  }
}

/// Deterministic synthetic content for tests / simulation (IDs only).
abstract final class SyntheticContent {
  static AssociationVariant association({
    required String id,
    required int memberCount,
    String contentType = 'generic',
  }) {
    return AssociationVariant(
      associationId: id,
      associationCardId: '${id}_card',
      memberCardIds: [for (var i = 1; i <= memberCount; i++) '${id}_m$i'],
      contentType: contentType,
      variantId: '${id}_v1',
    );
  }

  static List<AssociationVariant> forProfile(List<int> profile) {
    return [
      for (var i = 0; i < profile.length; i++)
        association(id: 'assoc_${i + 1}', memberCount: profile[i]),
    ];
  }
}
