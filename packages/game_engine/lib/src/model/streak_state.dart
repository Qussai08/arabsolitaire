/// Correct-move streak progression (tiers 3 → 4 → 5 forever).
final class StreakState {
  const StreakState({
    this.currentCounter = 0,
    this.targetTier = 3,
    this.earnedStreakCoins = 0,
  });

  final int currentCounter;
  final int targetTier;
  final int earnedStreakCoins;

  StreakState resetCounter() => StreakState(
    currentCounter: 0,
    targetTier: targetTier,
    earnedStreakCoins: earnedStreakCoins,
  );

  /// Returns updated streak and coins granted this action (0 if none).
  (StreakState state, int coinsGranted) afterCorrectAction() {
    final nextCounter = currentCounter + 1;
    if (nextCounter < targetTier) {
      return (
        StreakState(
          currentCounter: nextCounter,
          targetTier: targetTier,
          earnedStreakCoins: earnedStreakCoins,
        ),
        0,
      );
    }

    final granted = targetTier;
    final nextTier = targetTier >= 5 ? 5 : targetTier + 1;
    return (
      StreakState(
        currentCounter: 0,
        targetTier: nextTier,
        earnedStreakCoins: earnedStreakCoins + granted,
      ),
      granted,
    );
  }

  Map<String, Object?> toJson() => {
    'currentCounter': currentCounter,
    'targetTier': targetTier,
    'earnedStreakCoins': earnedStreakCoins,
  };

  factory StreakState.fromJson(Map<String, Object?> json) {
    return StreakState(
      currentCounter: json['currentCounter'] as int? ?? 0,
      targetTier: json['targetTier'] as int? ?? 3,
      earnedStreakCoins: json['earnedStreakCoins'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is StreakState &&
      other.currentCounter == currentCounter &&
      other.targetTier == targetTier &&
      other.earnedStreakCoins == earnedStreakCoins;

  @override
  int get hashCode =>
      Object.hash(currentCounter, targetTier, earnedStreakCoins);
}
