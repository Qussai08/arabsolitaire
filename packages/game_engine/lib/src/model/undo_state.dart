/// Undo metadata. Snapshot is a full rule-relevant GameState JSON map
/// without nested undo history (cleared at capture time).
final class UndoState {
  const UndoState({
    this.previousStateJson,
    this.lastMoveWasUndone = false,
    this.blockedByCompletion = false,
  });

  /// Encoded prior state for the last eligible accepted Move.
  final Map<String, Object?>? previousStateJson;
  final bool lastMoveWasUndone;
  final bool blockedByCompletion;

  bool get available =>
      previousStateJson != null && !lastMoveWasUndone && !blockedByCompletion;

  UndoState clearHistory() => const UndoState();

  UndoState afterUndoPerformed() => const UndoState(
    previousStateJson: null,
    lastMoveWasUndone: true,
    blockedByCompletion: false,
  );

  UndoState afterEligibleMove(Map<String, Object?> snapshot) => UndoState(
    previousStateJson: snapshot,
    lastMoveWasUndone: false,
    blockedByCompletion: false,
  );

  UndoState afterCompletionMove() => const UndoState(
    previousStateJson: null,
    lastMoveWasUndone: false,
    blockedByCompletion: true,
  );

  Map<String, Object?> toJson() => {
    'previousStateJson': previousStateJson,
    'lastMoveWasUndone': lastMoveWasUndone,
    'blockedByCompletion': blockedByCompletion,
  };

  factory UndoState.fromJson(Map<String, Object?> json) {
    final raw = json['previousStateJson'];
    return UndoState(
      previousStateJson: raw == null
          ? null
          : Map<String, Object?>.from(raw as Map),
      lastMoveWasUndone: json['lastMoveWasUndone'] as bool? ?? false,
      blockedByCompletion: json['blockedByCompletion'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! UndoState) return false;
    if (other.lastMoveWasUndone != lastMoveWasUndone ||
        other.blockedByCompletion != blockedByCompletion) {
      return false;
    }
    if (previousStateJson == null && other.previousStateJson == null) {
      return true;
    }
    if (previousStateJson == null || other.previousStateJson == null) {
      return false;
    }
    // Deep equality of JSON maps is sufficient for undo metadata tests.
    return _mapEquals(previousStateJson!, other.previousStateJson!);
  }

  @override
  int get hashCode => Object.hash(
    lastMoveWasUndone,
    blockedByCompletion,
    previousStateJson?.length,
  );
}

bool _mapEquals(Map<String, Object?> a, Map<String, Object?> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (b[entry.key] != entry.value) {
      // Nested maps/lists compared by toString for simplicity in UndoState.
      if ('${b[entry.key]}' != '${entry.value}') return false;
    }
  }
  return true;
}
