/// Tunable search bounds. Defaults are for tests/dev, not permanent product tuning.
final class SolverOptions {
  const SolverOptions({
    this.maxDepth,
    this.moveBudget,
    this.timeout,
    this.maxExpandedNodes = 200000,
    this.maxTranspositionEntries = 200000,
    this.enableCanonicalization = true,
    this.enableTranspositionTable = true,
    this.enableSymmetryReduction = true,
    this.enableMoveOrdering = true,
    this.cancellationToken,
  });

  /// Optional hard depth cap (defaults to moveBudget).
  final int? maxDepth;

  /// Override moves remaining for generation validation. Defaults to state.movesRemaining.
  final int? moveBudget;

  final Duration? timeout;
  final int maxExpandedNodes;
  final int maxTranspositionEntries;
  final bool enableCanonicalization;
  final bool enableTranspositionTable;
  final bool enableSymmetryReduction;
  final bool enableMoveOrdering;
  final SolverCancellationToken? cancellationToken;

  /// Safe defaults for unit tests / small golden boards.
  static const SolverOptions testDefaults = SolverOptions(
    timeout: Duration(seconds: 5),
    maxExpandedNodes: 50000,
  );
}

final class SolverCancellationToken {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() => _cancelled = true;
}

enum InconclusiveReason {
  timeout,
  nodeBudgetExceeded,
  memoryBudgetExceeded,
  cancelled,
  unsupportedRulesVersion,
  invalidInput,
  internalParityError,
}
