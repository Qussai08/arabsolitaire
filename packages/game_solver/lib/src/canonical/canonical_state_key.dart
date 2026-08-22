import 'package:game_engine/game_engine.dart';

/// Canonical solvability key.
///
/// Excludes streak / undo / attempt id — they do not affect forward legality
/// or win under current rules. Includes movesRemaining for budget-aware search.
abstract final class CanonicalStateKey {
  static String of(GameState state) {
    final buffer = StringBuffer();
    buffer.write('m${state.movesRemaining}|');
    buffer.write('c${_sortedIds(state.completedAssociationIds)}|');

    for (var i = 0; i < state.tableau.length; i++) {
      final col = state.tableau[i];
      buffer.write('T$i:');
      buffer.write(_cards(col.hiddenCards));
      buffer.write('/');
      buffer.write(_unit(col.exposedUnit));
      buffer.write(';');
    }

    buffer.write('S:');
    buffer.write(_cards(state.stock.undealt));
    buffer.write('/');
    buffer.write(_cards(state.stock.waste));
    buffer.write('|');

    for (final slot in state.slots) {
      buffer.write('L${slot.index}:');
      buffer.write(_unit(slot.activeAssociation));
      buffer.write(';');
    }

    return buffer.toString();
  }

  static String _sortedIds(Set<String> ids) {
    final list = ids.toList()..sort();
    return list.join(',');
  }

  static String _cards(List<GameCard> cards) {
    return cards.map((c) => c.id).join(',');
  }

  static String _unit(MovableUnit? unit) {
    if (unit == null) return '-';
    return switch (unit) {
      SingleMember(:final card) => 'SM:${card.id}',
      SingleAssociation(:final card) => 'SA:${card.id}',
      MemberStack(:final members) =>
        'MS:${(members.map((m) => m.id).toList()..sort()).join(',')}',
      AssociationStack(:final associationCard, :final members) =>
        'AS:${associationCard.id}+${(members.map((m) => m.id).toList()..sort()).join(',')}',
    };
  }
}
