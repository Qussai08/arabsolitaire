import 'package:game_engine/src/model/attempt_status.dart';
import 'package:game_engine/src/model/card.dart';
import 'package:game_engine/src/model/game_state.dart';
import 'package:game_engine/src/model/identifiers.dart';
import 'package:game_engine/src/model/movable_unit.dart';

/// Returns null when valid; otherwise a human-readable invariant failure.
String? findInvariantViolation(GameState state) {
  if (state.movesRemaining < 0) return 'negative moves';
  if (state.streak.targetTier != 3 &&
      state.streak.targetTier != 4 &&
      state.streak.targetTier != 5) {
    return 'invalid streak tier';
  }

  final seen = <CardId>{};
  void take(GameCard card) {
    if (!seen.add(card.id)) {
      throw StateError('duplicate card ${card.id}');
    }
    if (!state.associations.containsKey(card.associationId) &&
        !state.completedAssociationIds.contains(card.associationId)) {
      // Completed associations may be absent from active defs if removed —
      // cards of completed associations must not remain on board.
    }
    if (state.completedAssociationIds.contains(card.associationId)) {
      throw StateError('completed association card still on board');
    }
  }

  try {
    for (final card in state.allCardsOnBoard) {
      take(card);
    }
  } on StateError catch (e) {
    return e.message;
  }

  for (final col in state.tableau) {
    final unit = col.exposedUnit;
    if (unit is MemberStack) {
      if (unit.members.length < 2) return 'invalid member stack size';
      final id = unit.associationId;
      for (final m in unit.members) {
        if (m.associationId != id) return 'mixed member stack';
      }
    }
    if (unit is AssociationStack) {
      for (final m in unit.members) {
        if (m.associationId != unit.associationId) {
          return 'association stack mismatch';
        }
      }
    }
  }

  for (final slot in state.slots) {
    final active = slot.activeAssociation;
    if (active == null) continue;
    for (final m in active.members) {
      if (m.associationId != active.associationId) {
        return 'active slot mismatch';
      }
    }
  }

  if (state.status == AttemptStatus.won && state.hasRemainingCards) {
    return 'won but cards remain';
  }
  if (state.status == AttemptStatus.outOfMoves &&
      (state.movesRemaining != 0 || !state.hasRemainingCards)) {
    // outOfMoves requires 0 moves and not won (cards remain)
    if (state.movesRemaining != 0) return 'outOfMoves with moves left';
  }

  return null;
}

bool validateState(GameState state) => findInvariantViolation(state) == null;
