import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/src/difficulty/difficulty_models.dart';
import 'package:level_generator/src/random/generation_seed.dart';
import 'package:level_generator/src/version/package_version.dart';

enum GenerationFailureReason {
  invalidConfiguration,
  invalidContent,
  engineInvariantFailure,
  noCandidateWithinRetryBudget,
  solverInconclusiveBudget,
  difficultyTargetNotReached,
  unsupportedRulesVersion,
  cancelled,
}

/// Aggregated counters for one generate() call.
final class GenerationMetrics {
  GenerationMetrics();

  int generationAttempts = 0;
  int unsolvableRejects = 0;
  int tooEasyRejects = 0;
  int tooHardRejects = 0;
  int solverInconclusiveCount = 0;
  int engineInvariantRejects = 0;
  int solutionOverLimitRejects = 0;
  Duration elapsed = Duration.zero;
  GenerationSeed? acceptedSeed;

  Map<String, Object?> toJson() => {
        'generationAttempts': generationAttempts,
        'unsolvableRejects': unsolvableRejects,
        'tooEasyRejects': tooEasyRejects,
        'tooHardRejects': tooHardRejects,
        'solverInconclusiveCount': solverInconclusiveCount,
        'engineInvariantRejects': engineInvariantRejects,
        'solutionOverLimitRejects': solutionOverLimitRejects,
        'elapsedMs': elapsed.inMilliseconds,
        'acceptedSeed': acceptedSeed?.value,
      };
}

final class GeneratedLevel {
  const GeneratedLevel({
    required this.levelDefinitionId,
    required this.seed,
    required this.initialGameState,
    required this.selectedAssociationVariantIds,
    required this.solutionLength,
    required this.solverMetrics,
    required this.difficultyMetrics,
    required this.difficultyScore,
    required this.generationAttempts,
    required this.rulesVersion,
    required this.solverVersion,
    required this.generatorVersion,
    required this.difficultyModelVersion,
    this.solutionActions,
  });

  final String levelDefinitionId;
  final GenerationSeed seed;
  final GameState initialGameState;
  final List<String> selectedAssociationVariantIds;
  final int solutionLength;
  final SolverMetrics solverMetrics;
  final DifficultyMetrics difficultyMetrics;
  final DifficultyScore difficultyScore;
  final int generationAttempts;
  final String rulesVersion;
  final String solverVersion;
  final String generatorVersion;
  final String difficultyModelVersion;
  final List<GameAction>? solutionActions;

  Map<String, Object?> toJson({bool includeState = false}) => {
        'levelDefinitionId': levelDefinitionId,
        'seed': seed.value,
        'selectedAssociationVariantIds': selectedAssociationVariantIds,
        'solutionLength': solutionLength,
        'solverMetrics': {
          'nodesExpanded': solverMetrics.nodesExpanded,
          'nodesGenerated': solverMetrics.nodesGenerated,
          'maxDepthReached': solverMetrics.maxDepthReached,
          'elapsedMs': solverMetrics.elapsed.inMilliseconds,
        },
        'difficultyMetrics': difficultyMetrics.toJson(),
        'difficultyScore': difficultyScore.toJson(),
        'generationAttempts': generationAttempts,
        'rulesVersion': rulesVersion,
        'solverVersion': solverVersion,
        'generatorVersion': generatorVersion,
        'difficultyModelVersion': difficultyModelVersion,
        if (includeState)
          'initialGameState': GameStateCodec.encode(initialGameState),
      };
}

sealed class GenerationResult {
  const GenerationResult({required this.metrics});

  final GenerationMetrics metrics;
}

final class GenerationSucceeded extends GenerationResult {
  const GenerationSucceeded({
    required this.level,
    required super.metrics,
  });

  final GeneratedLevel level;
}

final class GenerationFailed extends GenerationResult {
  const GenerationFailed({
    required this.reason,
    required super.metrics,
    this.detail,
  });

  final GenerationFailureReason reason;
  final String? detail;
}

/// Clean non-acceptance when budgets prevent a conclusive accept.
final class GenerationInconclusive extends GenerationResult {
  const GenerationInconclusive({
    required this.reason,
    required super.metrics,
    this.detail,
  });

  final GenerationFailureReason reason;
  final String? detail;
}

// Keep package version constants referenced from result metadata helpers.
String get defaultGeneratorVersion => levelGeneratorVersion;
String get defaultDifficultyModelVersion => difficultyModelVersion;
