final class SolverMetrics {
  const SolverMetrics({
    this.elapsed = Duration.zero,
    this.nodesExpanded = 0,
    this.nodesGenerated = 0,
    this.maxDepthReached = 0,
    this.solutionDepth,
    this.transpositionHits = 0,
    this.cyclePrunes = 0,
    this.symmetryPrunes = 0,
    this.budgetPrunes = 0,
    this.terminalPrunes = 0,
  });

  final Duration elapsed;
  final int nodesExpanded;
  final int nodesGenerated;
  final int maxDepthReached;
  final int? solutionDepth;
  final int transpositionHits;
  final int cyclePrunes;
  final int symmetryPrunes;
  final int budgetPrunes;
  final int terminalPrunes;

  SolverMetrics copyWith({
    Duration? elapsed,
    int? nodesExpanded,
    int? nodesGenerated,
    int? maxDepthReached,
    int? solutionDepth,
    int? transpositionHits,
    int? cyclePrunes,
    int? symmetryPrunes,
    int? budgetPrunes,
    int? terminalPrunes,
  }) {
    return SolverMetrics(
      elapsed: elapsed ?? this.elapsed,
      nodesExpanded: nodesExpanded ?? this.nodesExpanded,
      nodesGenerated: nodesGenerated ?? this.nodesGenerated,
      maxDepthReached: maxDepthReached ?? this.maxDepthReached,
      solutionDepth: solutionDepth ?? this.solutionDepth,
      transpositionHits: transpositionHits ?? this.transpositionHits,
      cyclePrunes: cyclePrunes ?? this.cyclePrunes,
      symmetryPrunes: symmetryPrunes ?? this.symmetryPrunes,
      budgetPrunes: budgetPrunes ?? this.budgetPrunes,
      terminalPrunes: terminalPrunes ?? this.terminalPrunes,
    );
  }
}
