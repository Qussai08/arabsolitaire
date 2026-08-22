import 'package:game_engine/src/model/association_definition.dart';
import 'package:game_engine/src/model/association_slot.dart';
import 'package:game_engine/src/model/attempt_status.dart';
import 'package:game_engine/src/model/card.dart';
import 'package:game_engine/src/model/identifiers.dart';
import 'package:game_engine/src/model/movable_unit.dart';
import 'package:game_engine/src/model/stock.dart';
import 'package:game_engine/src/model/streak_state.dart';
import 'package:game_engine/src/model/tableau_column.dart';
import 'package:game_engine/src/model/undo_state.dart';
import 'package:game_engine/src/version/package_version.dart';

/// Immutable authoritative attempt state.
final class GameState {
  GameState({
    required this.attemptId,
    required this.levelDefinitionId,
    required this.associations,
    required this.tableau,
    required this.stock,
    required this.slots,
    required this.moveLimit,
    required this.movesRemaining,
    this.status = AttemptStatus.inProgress,
    this.streak = const StreakState(),
    this.undo = const UndoState(),
    Set<AssociationId>? completedAssociationIds,
    this.rulesVersion = gameEngineRulesVersion,
    this.saveSchemaVersion = gameEngineSaveSchemaVersion,
  }) : completedAssociationIds = Set.unmodifiable(
         completedAssociationIds ?? const <AssociationId>{},
       );

  final AttemptId attemptId;
  final LevelDefinitionId levelDefinitionId;
  final Map<AssociationId, AssociationDefinition> associations;
  final List<TableauColumn> tableau;
  final StockState stock;
  final List<AssociationSlot> slots;
  final int moveLimit;
  final int movesRemaining;
  final AttemptStatus status;
  final StreakState streak;
  final UndoState undo;
  final Set<AssociationId> completedAssociationIds;
  final String rulesVersion;
  final int saveSchemaVersion;

  GameState copyWith({
    List<TableauColumn>? tableau,
    StockState? stock,
    List<AssociationSlot>? slots,
    int? movesRemaining,
    AttemptStatus? status,
    StreakState? streak,
    UndoState? undo,
    Set<AssociationId>? completedAssociationIds,
  }) {
    return GameState(
      attemptId: attemptId,
      levelDefinitionId: levelDefinitionId,
      associations: associations,
      tableau: tableau ?? this.tableau,
      stock: stock ?? this.stock,
      slots: slots ?? this.slots,
      moveLimit: moveLimit,
      movesRemaining: movesRemaining ?? this.movesRemaining,
      status: status ?? this.status,
      streak: streak ?? this.streak,
      undo: undo ?? this.undo,
      completedAssociationIds:
          completedAssociationIds ?? this.completedAssociationIds,
      rulesVersion: rulesVersion,
      saveSchemaVersion: saveSchemaVersion,
    );
  }

  bool get hasRemainingCards {
    for (final col in tableau) {
      if (!col.isEmpty) return true;
    }
    if (!stock.isEmpty) return true;
    for (final slot in slots) {
      if (!slot.isEmpty) return true;
    }
    return false;
  }

  Iterable<GameCard> get allCardsOnBoard sync* {
    for (final col in tableau) {
      yield* col.hiddenCards;
      if (col.exposedUnit != null) {
        yield* col.exposedUnit!.cards;
      }
    }
    yield* stock.allRemainingCards;
    for (final slot in slots) {
      if (slot.activeAssociation != null) {
        yield* slot.activeAssociation!.cards;
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! GameState) return false;
    if (attemptId != other.attemptId ||
        levelDefinitionId != other.levelDefinitionId ||
        moveLimit != other.moveLimit ||
        movesRemaining != other.movesRemaining ||
        status != other.status ||
        streak != other.streak ||
        undo != other.undo ||
        stock != other.stock ||
        rulesVersion != other.rulesVersion ||
        saveSchemaVersion != other.saveSchemaVersion) {
      return false;
    }
    if (tableau.length != other.tableau.length ||
        slots.length != other.slots.length ||
        associations.length != other.associations.length ||
        completedAssociationIds.length !=
            other.completedAssociationIds.length) {
      return false;
    }
    for (var i = 0; i < tableau.length; i++) {
      if (tableau[i] != other.tableau[i]) return false;
    }
    for (var i = 0; i < slots.length; i++) {
      if (slots[i] != other.slots[i]) return false;
    }
    for (final id in completedAssociationIds) {
      if (!other.completedAssociationIds.contains(id)) return false;
    }
    for (final entry in associations.entries) {
      if (other.associations[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    attemptId,
    movesRemaining,
    status,
    streak,
    stock,
    Object.hashAll(tableau),
    Object.hashAll(slots),
  );
}

/// Build an exposed single-card column with optional hidden cards beneath.
TableauColumn columnWithTop(GameCard top, {List<GameCard> hidden = const []}) {
  return TableauColumn(
    hiddenCards: hidden,
    exposedUnit: MovableUnit.single(top),
  );
}
