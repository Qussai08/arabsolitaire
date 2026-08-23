import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/src/difficulty/difficulty_models.dart';

/// Validated Level Definition configuration for generation.
final class LevelConfiguration {
  LevelConfiguration({
    required this.levelDefinitionId,
    required this.groupSizeProfile,
    required this.tableauColumnSizes,
    required this.stockCardCount,
    required this.associationSlotCount,
    required this.moveLimit,
    required this.difficultyTarget,
    this.chapterId = 'chapter_1',
    this.levelNumber = 1,
    this.rulesVersion = gameEngineRulesVersion,
    this.maxGenerationAttempts = 40,
    this.solverOptions = SolverOptions.testDefaults,
    this.includeSolutionActions = false,
    this.semanticDifficultyTier,
    this.maxVisualAssociations,
  }) {
    final error = validate();
    if (error != null) {
      throw ArgumentError.value(this, 'LevelConfiguration', error);
    }
  }

  /// Non-throwing factory for invalid-config tests.
  static LevelConfiguration? tryCreate({
    required String levelDefinitionId,
    required List<int> groupSizeProfile,
    required List<int> tableauColumnSizes,
    required int stockCardCount,
    required int associationSlotCount,
    required int moveLimit,
    required DifficultyTarget difficultyTarget,
    String chapterId = 'chapter_1',
    int levelNumber = 1,
    String rulesVersion = gameEngineRulesVersion,
    int maxGenerationAttempts = 40,
    SolverOptions solverOptions = SolverOptions.testDefaults,
    bool includeSolutionActions = false,
    String? semanticDifficultyTier,
    int? maxVisualAssociations,
  }) {
    final draft = _Draft(
      levelDefinitionId: levelDefinitionId,
      groupSizeProfile: groupSizeProfile,
      tableauColumnSizes: tableauColumnSizes,
      stockCardCount: stockCardCount,
      associationSlotCount: associationSlotCount,
      moveLimit: moveLimit,
      difficultyTarget: difficultyTarget,
      chapterId: chapterId,
      levelNumber: levelNumber,
      rulesVersion: rulesVersion,
      maxGenerationAttempts: maxGenerationAttempts,
      solverOptions: solverOptions,
      includeSolutionActions: includeSolutionActions,
      semanticDifficultyTier: semanticDifficultyTier,
      maxVisualAssociations: maxVisualAssociations,
    );
    if (draft.validate() != null) return null;
    return LevelConfiguration(
      levelDefinitionId: levelDefinitionId,
      groupSizeProfile: groupSizeProfile,
      tableauColumnSizes: tableauColumnSizes,
      stockCardCount: stockCardCount,
      associationSlotCount: associationSlotCount,
      moveLimit: moveLimit,
      difficultyTarget: difficultyTarget,
      chapterId: chapterId,
      levelNumber: levelNumber,
      rulesVersion: rulesVersion,
      maxGenerationAttempts: maxGenerationAttempts,
      solverOptions: solverOptions,
      includeSolutionActions: includeSolutionActions,
      semanticDifficultyTier: semanticDifficultyTier,
      maxVisualAssociations: maxVisualAssociations,
    );
  }

  final String levelDefinitionId;
  final String chapterId;
  final int levelNumber;
  final String rulesVersion;

  /// Member counts per Association, e.g. `[3, 3, 3]`.
  final List<int> groupSizeProfile;
  final List<int> tableauColumnSizes;
  final int stockCardCount;
  final int associationSlotCount;
  final int moveLimit;
  final DifficultyTarget difficultyTarget;
  final int maxGenerationAttempts;
  final SolverOptions solverOptions;
  final bool includeSolutionActions;

  /// Metadata only — Generator does not infer semantics.
  final String? semanticDifficultyTier;
  final int? maxVisualAssociations;

  int get associationCount => groupSizeProfile.length;

  int get tableauCardCount => tableauColumnSizes.fold<int>(0, (a, b) => a + b);

  int get totalCardCount =>
      groupSizeProfile.fold<int>(0, (sum, members) => sum + 1 + members);

  String? validate() => _Draft.from(this).validate();
}

final class _Draft {
  _Draft({
    required this.levelDefinitionId,
    required this.groupSizeProfile,
    required this.tableauColumnSizes,
    required this.stockCardCount,
    required this.associationSlotCount,
    required this.moveLimit,
    required this.difficultyTarget,
    required this.chapterId,
    required this.levelNumber,
    required this.rulesVersion,
    required this.maxGenerationAttempts,
    required this.solverOptions,
    required this.includeSolutionActions,
    required this.semanticDifficultyTier,
    required this.maxVisualAssociations,
  });

  factory _Draft.from(LevelConfiguration c) => _Draft(
    levelDefinitionId: c.levelDefinitionId,
    groupSizeProfile: c.groupSizeProfile,
    tableauColumnSizes: c.tableauColumnSizes,
    stockCardCount: c.stockCardCount,
    associationSlotCount: c.associationSlotCount,
    moveLimit: c.moveLimit,
    difficultyTarget: c.difficultyTarget,
    chapterId: c.chapterId,
    levelNumber: c.levelNumber,
    rulesVersion: c.rulesVersion,
    maxGenerationAttempts: c.maxGenerationAttempts,
    solverOptions: c.solverOptions,
    includeSolutionActions: c.includeSolutionActions,
    semanticDifficultyTier: c.semanticDifficultyTier,
    maxVisualAssociations: c.maxVisualAssociations,
  );

  final String levelDefinitionId;
  final List<int> groupSizeProfile;
  final List<int> tableauColumnSizes;
  final int stockCardCount;
  final int associationSlotCount;
  final int moveLimit;
  final DifficultyTarget difficultyTarget;
  final String chapterId;
  final int levelNumber;
  final String rulesVersion;
  final int maxGenerationAttempts;
  final SolverOptions solverOptions;
  final bool includeSolutionActions;
  final String? semanticDifficultyTier;
  final int? maxVisualAssociations;

  int get associationCount => groupSizeProfile.length;

  int get tableauCardCount => tableauColumnSizes.fold<int>(0, (a, b) => a + b);

  int get totalCardCount =>
      groupSizeProfile.fold<int>(0, (sum, members) => sum + 1 + members);

  String? validate() {
    if (associationCount <= 0) return 'associationCount must be > 0';
    if (associationSlotCount <= 0) return 'associationSlotCount must be > 0';
    if (tableauColumnSizes.isEmpty) return 'tableau columns required';
    if (tableauColumnSizes.any((s) => s <= 0)) {
      return 'tableau column sizes must be > 0';
    }
    if (moveLimit <= 0) return 'moveLimit must be > 0';
    if (stockCardCount < 0) return 'stockCardCount invalid';
    if (groupSizeProfile.any((s) => s < 1 || s > 5)) {
      return 'unsupported group size (supported 1..5 members)';
    }
    if (tableauCardCount + stockCardCount != totalCardCount) {
      return 'capacity mismatch: tableau+stock != total cards';
    }
    if (difficultyTarget.minScore > difficultyTarget.maxScore) {
      return 'difficulty target min > max';
    }
    if (maxGenerationAttempts <= 0) return 'maxGenerationAttempts must be > 0';
    if (maxVisualAssociations != null && maxVisualAssociations! < 0) {
      return 'maxVisualAssociations invalid';
    }
    return null;
  }
}
