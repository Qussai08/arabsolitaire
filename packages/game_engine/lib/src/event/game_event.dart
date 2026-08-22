import 'package:game_engine/src/model/identifiers.dart';

sealed class GameEvent {
  const GameEvent();

  String get type;
  Map<String, Object?> toJson();
}

final class MoveAccepted extends GameEvent {
  const MoveAccepted({required this.actionType, required this.moveCost});
  final String actionType;
  final int moveCost;
  @override
  String get type => 'MoveAccepted';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'actionType': actionType,
    'moveCost': moveCost,
  };
}

final class MoveRejected extends GameEvent {
  const MoveRejected({required this.actionType, required this.reason});
  final String actionType;
  final String reason;
  @override
  String get type => 'MoveRejected';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'actionType': actionType,
    'reason': reason,
  };
}

final class CardRevealed extends GameEvent {
  const CardRevealed({required this.columnIndex, required this.cardId});
  final int columnIndex;
  final CardId cardId;
  @override
  String get type => 'CardRevealed';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'columnIndex': columnIndex,
    'cardId': cardId,
  };
}

final class StackCreated extends GameEvent {
  const StackCreated({required this.associationId});
  final AssociationId associationId;
  @override
  String get type => 'StackCreated';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'associationId': associationId,
  };
}

final class StacksMerged extends GameEvent {
  const StacksMerged({required this.associationId});
  final AssociationId associationId;
  @override
  String get type => 'StacksMerged';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'associationId': associationId,
  };
}

final class AssociationActivated extends GameEvent {
  const AssociationActivated({
    required this.associationId,
    required this.slotIndex,
  });
  final AssociationId associationId;
  final int slotIndex;
  @override
  String get type => 'AssociationActivated';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'associationId': associationId,
    'slotIndex': slotIndex,
  };
}

final class MembersAttached extends GameEvent {
  const MembersAttached({
    required this.associationId,
    required this.memberCount,
  });
  final AssociationId associationId;
  final int memberCount;
  @override
  String get type => 'MembersAttached';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'associationId': associationId,
    'memberCount': memberCount,
  };
}

final class AssociationCompleted extends GameEvent {
  const AssociationCompleted({
    required this.associationId,
    required this.slotIndex,
  });
  final AssociationId associationId;
  final int slotIndex;
  @override
  String get type => 'AssociationCompleted';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'associationId': associationId,
    'slotIndex': slotIndex,
  };
}

final class StockAdvanced extends GameEvent {
  const StockAdvanced();
  @override
  String get type => 'StockAdvanced';
  @override
  Map<String, Object?> toJson() => {'type': type};
}

final class StockRestored extends GameEvent {
  const StockRestored();
  @override
  String get type => 'StockRestored';
  @override
  Map<String, Object?> toJson() => {'type': type};
}

final class StreakRewardEarned extends GameEvent {
  const StreakRewardEarned({required this.coins, required this.tierReached});
  final int coins;
  final int tierReached;
  @override
  String get type => 'StreakRewardEarned';
  @override
  Map<String, Object?> toJson() => {
    'type': type,
    'coins': coins,
    'tierReached': tierReached,
  };
}

final class UndoPerformed extends GameEvent {
  const UndoPerformed();
  @override
  String get type => 'UndoPerformed';
  @override
  Map<String, Object?> toJson() => {'type': type};
}

final class OutOfMovesReached extends GameEvent {
  const OutOfMovesReached();
  @override
  String get type => 'OutOfMovesReached';
  @override
  Map<String, Object?> toJson() => {'type': type};
}

final class GameWon extends GameEvent {
  const GameWon();
  @override
  String get type => 'GameWon';
  @override
  Map<String, Object?> toJson() => {'type': type};
}
