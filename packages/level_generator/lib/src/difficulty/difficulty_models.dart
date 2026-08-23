/// Broad Board Difficulty bands (calibration TBD).
enum DifficultyBand { veryEasy, easy, medium, hard, veryHard }

/// Configurable acceptance window for Board Difficulty score.
final class DifficultyTarget {
  const DifficultyTarget({
    this.minScore = 0,
    this.maxScore = 100,
    this.preferredBand,
  });

  /// Accept any solvable board (Sprint 3 default for small templates).
  static const DifficultyTarget any = DifficultyTarget();

  final double minScore;
  final double maxScore;
  final DifficultyBand? preferredBand;

  bool contains(double score) => score >= minScore && score <= maxScore;
}

/// Raw signals retained for tuning (Board Difficulty only).
final class DifficultyMetrics {
  const DifficultyMetrics({
    required this.solutionLength,
    required this.moveLimit,
    required this.nodesExpanded,
    required this.maxDepthReached,
    required this.stockAdvancesInSolution,
    required this.stockRestoresInSolution,
    required this.stockPlaysInSolution,
    required this.hiddenCardCount,
    required this.totalCardCount,
    required this.transpositionHits,
  });

  final int solutionLength;
  final int moveLimit;
  final int nodesExpanded;
  final int maxDepthReached;
  final int stockAdvancesInSolution;
  final int stockRestoresInSolution;
  final int stockPlaysInSolution;
  final int hiddenCardCount;
  final int totalCardCount;
  final int transpositionHits;

  double get solutionLengthRatio =>
      moveLimit <= 0 ? 0 : solutionLength / moveLimit;

  double get hiddenRatio =>
      totalCardCount <= 0 ? 0 : hiddenCardCount / totalCardCount;

  Map<String, Object?> toJson() => {
    'solutionLength': solutionLength,
    'moveLimit': moveLimit,
    'solutionLengthRatio': solutionLengthRatio,
    'nodesExpanded': nodesExpanded,
    'maxDepthReached': maxDepthReached,
    'stockAdvancesInSolution': stockAdvancesInSolution,
    'stockRestoresInSolution': stockRestoresInSolution,
    'stockPlaysInSolution': stockPlaysInSolution,
    'hiddenCardCount': hiddenCardCount,
    'totalCardCount': totalCardCount,
    'hiddenRatio': hiddenRatio,
    'transpositionHits': transpositionHits,
  };
}

final class DifficultyScore {
  const DifficultyScore({
    required this.value,
    required this.band,
    required this.modelVersion,
  });

  final double value;
  final DifficultyBand band;
  final String modelVersion;

  Map<String, Object?> toJson() => {
    'value': value,
    'band': band.name,
    'modelVersion': modelVersion,
  };
}

enum DifficultyVerdict { accepted, tooEasy, tooHard }

final class DifficultyEvaluation {
  const DifficultyEvaluation({
    required this.metrics,
    required this.score,
    required this.verdict,
  });

  final DifficultyMetrics metrics;
  final DifficultyScore score;
  final DifficultyVerdict verdict;
}
