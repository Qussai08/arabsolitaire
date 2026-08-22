/// Typed authoritative actions. UI must not mutate collections directly.
sealed class GameAction {
  const GameAction();

  String get typeName;

  Map<String, Object?> toJson();

  static GameAction fromJson(Map<String, Object?> json) {
    final type = json['type'] as String?;
    return switch (type) {
      'MoveTableauToTableau' => MoveTableauToTableau.fromJson(json),
      'MoveTableauToSlot' => MoveTableauToSlot.fromJson(json),
      'MoveStockToTableau' => MoveStockToTableau.fromJson(json),
      'MoveStockToSlot' => MoveStockToSlot.fromJson(json),
      'AdvanceStock' => const AdvanceStock(),
      'RestoreStock' => const RestoreStock(),
      'UndoLastMove' => const UndoLastMove(),
      _ => throw FormatException('Unknown GameAction type: $type'),
    };
  }
}

final class MoveTableauToTableau extends GameAction {
  const MoveTableauToTableau({
    required this.fromColumn,
    required this.toColumn,
  });

  final int fromColumn;
  final int toColumn;

  @override
  String get typeName => 'MoveTableauToTableau';

  @override
  Map<String, Object?> toJson() => {
    'type': typeName,
    'fromColumn': fromColumn,
    'toColumn': toColumn,
  };

  factory MoveTableauToTableau.fromJson(Map<String, Object?> json) {
    return MoveTableauToTableau(
      fromColumn: json['fromColumn']! as int,
      toColumn: json['toColumn']! as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MoveTableauToTableau &&
      other.fromColumn == fromColumn &&
      other.toColumn == toColumn;

  @override
  int get hashCode => Object.hash(typeName, fromColumn, toColumn);
}

final class MoveTableauToSlot extends GameAction {
  const MoveTableauToSlot({required this.fromColumn, required this.slotIndex});

  final int fromColumn;
  final int slotIndex;

  @override
  String get typeName => 'MoveTableauToSlot';

  @override
  Map<String, Object?> toJson() => {
    'type': typeName,
    'fromColumn': fromColumn,
    'slotIndex': slotIndex,
  };

  factory MoveTableauToSlot.fromJson(Map<String, Object?> json) {
    return MoveTableauToSlot(
      fromColumn: json['fromColumn']! as int,
      slotIndex: json['slotIndex']! as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MoveTableauToSlot &&
      other.fromColumn == fromColumn &&
      other.slotIndex == slotIndex;

  @override
  int get hashCode => Object.hash(typeName, fromColumn, slotIndex);
}

final class MoveStockToTableau extends GameAction {
  const MoveStockToTableau({required this.toColumn});

  final int toColumn;

  @override
  String get typeName => 'MoveStockToTableau';

  @override
  Map<String, Object?> toJson() => {'type': typeName, 'toColumn': toColumn};

  factory MoveStockToTableau.fromJson(Map<String, Object?> json) {
    return MoveStockToTableau(toColumn: json['toColumn']! as int);
  }

  @override
  bool operator ==(Object other) =>
      other is MoveStockToTableau && other.toColumn == toColumn;

  @override
  int get hashCode => Object.hash(typeName, toColumn);
}

final class MoveStockToSlot extends GameAction {
  const MoveStockToSlot({required this.slotIndex});

  final int slotIndex;

  @override
  String get typeName => 'MoveStockToSlot';

  @override
  Map<String, Object?> toJson() => {'type': typeName, 'slotIndex': slotIndex};

  factory MoveStockToSlot.fromJson(Map<String, Object?> json) {
    return MoveStockToSlot(slotIndex: json['slotIndex']! as int);
  }

  @override
  bool operator ==(Object other) =>
      other is MoveStockToSlot && other.slotIndex == slotIndex;

  @override
  int get hashCode => Object.hash(typeName, slotIndex);
}

final class AdvanceStock extends GameAction {
  const AdvanceStock();

  @override
  String get typeName => 'AdvanceStock';

  @override
  Map<String, Object?> toJson() => {'type': typeName};

  @override
  bool operator ==(Object other) => other is AdvanceStock;

  @override
  int get hashCode => typeName.hashCode;
}

final class RestoreStock extends GameAction {
  const RestoreStock();

  @override
  String get typeName => 'RestoreStock';

  @override
  Map<String, Object?> toJson() => {'type': typeName};

  @override
  bool operator ==(Object other) => other is RestoreStock;

  @override
  int get hashCode => typeName.hashCode;
}

final class UndoLastMove extends GameAction {
  const UndoLastMove();

  @override
  String get typeName => 'UndoLastMove';

  @override
  Map<String, Object?> toJson() => {'type': typeName};

  @override
  bool operator ==(Object other) => other is UndoLastMove;

  @override
  int get hashCode => typeName.hashCode;
}
