import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/src/api/generation_result.dart';
import 'package:level_generator/src/content/card_pool_builder.dart';
import 'package:level_generator/src/content/content_selector.dart';
import 'package:level_generator/src/deal/board_dealer.dart';
import 'package:level_generator/src/model/association_variant.dart';
import 'package:level_generator/src/model/level_configuration.dart';
import 'package:level_generator/src/random/generation_seed.dart';
import 'package:level_generator/src/validation/candidate_validator.dart';
import 'package:level_generator/src/version/package_version.dart';

/// Production Level Generator: config → content → pool → deal → Solver → difficulty.
final class LevelGenerator {
  LevelGenerator({GameSolver? solver, this.engine = const GameEngine()})
    : solver = solver ?? GameSolver();

  final GameSolver solver;
  final GameEngine engine;

  String get enginePackageVersion => gameEnginePackageVersion;
  String get solverPackageVersion => gameSolverPackageVersion;
  String get packageVersion => levelGeneratorPackageVersion;
  String get generatorVersion => levelGeneratorVersion;

  /// Generate an accepted Attempt for [config] using [contentSelector].
  GenerationResult generate({
    required LevelConfiguration config,
    required ContentSelector contentSelector,
    required GenerationSeed baseSeed,
  }) {
    final metrics = GenerationMetrics();
    final started = DateTime.now().toUtc();

    if (config.rulesVersion != gameEngineRulesVersion) {
      metrics.elapsed = DateTime.now().toUtc().difference(started);
      return GenerationFailed(
        reason: GenerationFailureReason.unsupportedRulesVersion,
        metrics: metrics,
        detail:
            'config ${config.rulesVersion} != engine $gameEngineRulesVersion',
      );
    }

    late final List<AssociationVariant> variants;
    try {
      variants = contentSelector.select(config: config, seed: baseSeed);
    } catch (e) {
      metrics.elapsed = DateTime.now().toUtc().difference(started);
      return GenerationFailed(
        reason: GenerationFailureReason.invalidContent,
        metrics: metrics,
        detail: e.toString(),
      );
    }

    final contentError = CardPoolBuilder.validateContent(
      config: config,
      variants: variants,
    );
    if (contentError != null) {
      metrics.elapsed = DateTime.now().toUtc().difference(started);
      return GenerationFailed(
        reason: GenerationFailureReason.invalidContent,
        metrics: metrics,
        detail: contentError,
      );
    }

    late final CardPool pool;
    try {
      pool = CardPoolBuilder.build(config: config, variants: variants);
    } catch (e) {
      metrics.elapsed = DateTime.now().toUtc().difference(started);
      return GenerationFailed(
        reason: GenerationFailureReason.invalidContent,
        metrics: metrics,
        detail: e.toString(),
      );
    }

    var inconclusiveOnly = true;
    var difficultyMisses = 0;

    for (var attempt = 1; attempt <= config.maxGenerationAttempts; attempt++) {
      metrics.generationAttempts = attempt;
      final candidateSeed = baseSeed.deriveCandidate(attempt);
      final candidate = BoardDealer.deal(
        config: config,
        pool: pool,
        candidateSeed: candidateSeed,
        generationAttemptIndex: attempt,
      );

      final validation = CandidateValidator.validate(
        candidate: candidate,
        config: config,
        solver: solver,
        engine: engine,
      );

      switch (validation) {
        case CandidateAccepted(:final solved, :final difficulty):
          metrics.acceptedSeed = candidateSeed;
          metrics.elapsed = DateTime.now().toUtc().difference(started);
          inconclusiveOnly = false;
          return GenerationSucceeded(
            metrics: metrics,
            level: GeneratedLevel(
              levelDefinitionId: config.levelDefinitionId,
              seed: candidateSeed,
              initialGameState: candidate.initialGameState,
              selectedAssociationVariantIds: candidate.contentIds,
              solutionLength: solved.solutionLength,
              solverMetrics: solved.metrics,
              difficultyMetrics: difficulty.metrics,
              difficultyScore: difficulty.score,
              generationAttempts: attempt,
              rulesVersion: config.rulesVersion,
              solverVersion: gameSolverPackageVersion,
              generatorVersion: levelGeneratorVersion,
              difficultyModelVersion: difficulty.score.modelVersion,
              solutionActions: config.includeSolutionActions
                  ? List.unmodifiable(solved.actions)
                  : null,
            ),
          );
        case CandidateRejected(:final reason):
          switch (reason) {
            case CandidateRejectReason.engineInvariantFailure:
              metrics.engineInvariantRejects++;
              inconclusiveOnly = false;
            case CandidateRejectReason.unsolvable:
              metrics.unsolvableRejects++;
              inconclusiveOnly = false;
            case CandidateRejectReason.solutionOverMoveLimit:
              metrics.solutionOverLimitRejects++;
              inconclusiveOnly = false;
            case CandidateRejectReason.solverInconclusive:
              metrics.solverInconclusiveCount++;
            case CandidateRejectReason.tooEasy:
              metrics.tooEasyRejects++;
              difficultyMisses++;
              inconclusiveOnly = false;
            case CandidateRejectReason.tooHard:
              metrics.tooHardRejects++;
              difficultyMisses++;
              inconclusiveOnly = false;
          }
      }
    }

    metrics.elapsed = DateTime.now().toUtc().difference(started);

    if (inconclusiveOnly && metrics.solverInconclusiveCount > 0) {
      return GenerationInconclusive(
        reason: GenerationFailureReason.solverInconclusiveBudget,
        metrics: metrics,
        detail: 'all candidates inconclusive within retry budget',
      );
    }

    if (difficultyMisses > 0 &&
        metrics.unsolvableRejects == 0 &&
        metrics.solutionOverLimitRejects == 0 &&
        metrics.engineInvariantRejects == 0) {
      return GenerationFailed(
        reason: GenerationFailureReason.difficultyTargetNotReached,
        metrics: metrics,
        detail: 'no candidate matched difficulty target',
      );
    }

    return GenerationFailed(
      reason: GenerationFailureReason.noCandidateWithinRetryBudget,
      metrics: metrics,
      detail: 'exhausted ${config.maxGenerationAttempts} attempts',
    );
  }

  /// Deal a single candidate (QA / tests) without Solver validation.
  GeneratedCandidate dealOnly({
    required LevelConfiguration config,
    required List<AssociationVariant> variants,
    required GenerationSeed candidateSeed,
    int generationAttemptIndex = 1,
  }) {
    final pool = CardPoolBuilder.build(config: config, variants: variants);
    return BoardDealer.deal(
      config: config,
      pool: pool,
      candidateSeed: candidateSeed,
      generationAttemptIndex: generationAttemptIndex,
    );
  }
}
