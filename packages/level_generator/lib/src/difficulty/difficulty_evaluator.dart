import 'dart:math' as math;

import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/src/difficulty/difficulty_models.dart';
import 'package:level_generator/src/version/package_version.dart';

/// Versioned Board Difficulty scoring (weights are engineering defaults).
abstract final class DifficultyEvaluator {
  static DifficultyEvaluation evaluate({
    required GameState initialState,
    required Solved solved,
    required DifficultyTarget target,
    String modelVersion = difficultyModelVersion,
  }) {
    final metrics = collectMetrics(initialState: initialState, solved: solved);
    final score = scoreFromMetrics(metrics, modelVersion: modelVersion);
    final verdict = verdictFor(score.value, target);
    return DifficultyEvaluation(
      metrics: metrics,
      score: score,
      verdict: verdict,
    );
  }

  static DifficultyMetrics collectMetrics({
    required GameState initialState,
    required Solved solved,
  }) {
    var advances = 0;
    var restores = 0;
    var stockPlays = 0;
    for (final action in solved.actions) {
      if (action is AdvanceStock) advances++;
      if (action is RestoreStock) restores++;
      if (action is MoveStockToTableau || action is MoveStockToSlot) {
        stockPlays++;
      }
    }

    var hidden = 0;
    var total = 0;
    for (final col in initialState.tableau) {
      hidden += col.hiddenCards.length;
      total += col.hiddenCards.length;
      if (col.exposedUnit != null) {
        total += col.exposedUnit!.cards.length;
      }
    }
    total += initialState.stock.allRemainingCards.length;

    return DifficultyMetrics(
      solutionLength: solved.solutionLength,
      moveLimit: initialState.moveLimit,
      nodesExpanded: solved.metrics.nodesExpanded,
      maxDepthReached: solved.metrics.maxDepthReached,
      stockAdvancesInSolution: advances,
      stockRestoresInSolution: restores,
      stockPlaysInSolution: stockPlays,
      hiddenCardCount: hidden,
      totalCardCount: total,
      transpositionHits: solved.metrics.transpositionHits,
    );
  }

  static DifficultyScore scoreFromMetrics(
    DifficultyMetrics m, {
    String modelVersion = difficultyModelVersion,
  }) {
    final lengthTerm = _clamp(m.solutionLengthRatio / 1.2, 0, 1);
    final nodesTerm = _clamp(math.log(1 + m.nodesExpanded) / math.ln10 / 5, 0, 1);
    final advanceTerm = m.solutionLength == 0
        ? 0.0
        : _clamp(m.stockAdvancesInSolution / m.solutionLength, 0, 1);
    final restoreTerm = _clamp(m.stockRestoresInSolution / 3.0, 0, 1);
    final hiddenTerm = _clamp(m.hiddenRatio, 0, 1);

    final value = 100 *
        (0.55 * lengthTerm +
            0.25 * nodesTerm +
            0.10 * advanceTerm +
            0.05 * restoreTerm +
            0.05 * hiddenTerm);

    return DifficultyScore(
      value: value,
      band: bandFor(value),
      modelVersion: modelVersion,
    );
  }

  static DifficultyBand bandFor(double score) {
    if (score < 20) return DifficultyBand.veryEasy;
    if (score < 40) return DifficultyBand.easy;
    if (score < 60) return DifficultyBand.medium;
    if (score < 80) return DifficultyBand.hard;
    return DifficultyBand.veryHard;
  }

  static DifficultyVerdict verdictFor(double score, DifficultyTarget target) {
    if (score < target.minScore) return DifficultyVerdict.tooEasy;
    if (score > target.maxScore) return DifficultyVerdict.tooHard;
    return DifficultyVerdict.accepted;
  }

  static double _clamp(double v, double min, double max) {
    if (v < min) return min;
    if (v > max) return max;
    return v;
  }
}
