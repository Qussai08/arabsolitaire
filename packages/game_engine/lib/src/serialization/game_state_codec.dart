import 'package:game_engine/src/model/association_definition.dart';
import 'package:game_engine/src/model/association_slot.dart';
import 'package:game_engine/src/model/attempt_status.dart';
import 'package:game_engine/src/model/game_state.dart';
import 'package:game_engine/src/model/identifiers.dart';
import 'package:game_engine/src/model/stock.dart';
import 'package:game_engine/src/model/streak_state.dart';
import 'package:game_engine/src/model/tableau_column.dart';
import 'package:game_engine/src/model/undo_state.dart';

abstract final class GameStateCodec {
  static Map<String, Object?> encode(GameState state) {
    return {
      'rulesVersion': state.rulesVersion,
      'saveSchemaVersion': state.saveSchemaVersion,
      'attemptId': state.attemptId,
      'levelDefinitionId': state.levelDefinitionId,
      'associations': {
        for (final e in state.associations.entries) e.key: e.value.toJson(),
      },
      'tableau': state.tableau.map((c) => c.toJson()).toList(),
      'stock': state.stock.toJson(),
      'slots': state.slots.map((s) => s.toJson()).toList(),
      'moveLimit': state.moveLimit,
      'movesRemaining': state.movesRemaining,
      'status': state.status.name,
      'streak': state.streak.toJson(),
      'undo': state.undo.toJson(),
      'completedAssociationIds': (state.completedAssociationIds.toList()
        ..sort()),
    };
  }

  static GameState decode(Map<String, Object?> json) {
    final assocRaw = Map<String, dynamic>.from(json['associations']! as Map);
    final associations = <AssociationId, AssociationDefinition>{
      for (final e in assocRaw.entries)
        e.key: AssociationDefinition.fromJson(
          Map<String, Object?>.from(e.value as Map),
        ),
    };

    final completed =
        (json['completedAssociationIds'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toSet();

    return GameState(
      attemptId: json['attemptId']! as String,
      levelDefinitionId: json['levelDefinitionId']! as String,
      associations: associations,
      tableau: [
        for (final item in json['tableau'] as List<dynamic>)
          TableauColumn.fromJson(Map<String, Object?>.from(item as Map)),
      ],
      stock: StockState.fromJson(
        Map<String, Object?>.from(json['stock']! as Map),
      ),
      slots: [
        for (final item in json['slots'] as List<dynamic>)
          AssociationSlot.fromJson(Map<String, Object?>.from(item as Map)),
      ],
      moveLimit: json['moveLimit']! as int,
      movesRemaining: json['movesRemaining']! as int,
      status: AttemptStatus.fromName(json['status']! as String),
      streak: StreakState.fromJson(
        Map<String, Object?>.from(json['streak']! as Map),
      ),
      undo: UndoState.fromJson(Map<String, Object?>.from(json['undo']! as Map)),
      completedAssociationIds: completed,
      rulesVersion: json['rulesVersion'] as String? ?? '1.0.0',
      saveSchemaVersion: json['saveSchemaVersion'] as int? ?? 1,
    );
  }
}
