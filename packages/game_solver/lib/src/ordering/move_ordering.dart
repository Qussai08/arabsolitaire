import 'package:game_engine/game_engine.dart';

/// Deterministic heuristic move ordering (not a gameplay rule).
abstract final class MoveOrdering {
  static List<GameAction> order({
    required GameState state,
    required List<GameAction> actions,
    required GameEngine engine,
  }) {
    final scored = <({GameAction action, int score})>[];
    for (final action in actions) {
      scored.add((action: action, score: _score(state, action, engine)));
    }
    scored.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return _stableLabel(a.action).compareTo(_stableLabel(b.action));
    });
    return [for (final s in scored) s.action];
  }

  static int _score(GameState state, GameAction action, GameEngine engine) {
    // Peek acceptance cheaply via engine (already known legal).
    final transition = engine.applyAction(state, action);
    if (!transition.accepted) return -10000;

    var score = 0;
    final events = transition.events;
    if (events.any((e) => e is AssociationCompleted)) score += 1000;
    if (events.any((e) => e is MembersAttached)) score += 500;
    if (events.any((e) => e is AssociationActivated)) {
      final moving = _movingUnit(state, action);
      score += moving is AssociationStack ? 350 : 300;
    }
    if (events.any((e) => e is CardRevealed)) score += 250;
    if (events.any((e) => e is StacksMerged) ||
        events.any((e) => e is StackCreated)) {
      score += 200;
    }

    score += switch (action) {
      AdvanceStock() => 20,
      RestoreStock() => 1,
      MoveTableauToTableau(:final toColumn) =>
        state.tableau[toColumn].isEmpty ? 5 : 150,
      MoveStockToTableau(:final toColumn) =>
        state.tableau[toColumn].isEmpty ? 80 : 100,
      MoveTableauToSlot() => 280,
      MoveStockToSlot() => 280,
      _ => 0,
    };

    // Prefer fewer remaining cards after move.
    score += (countCards(state) - countCards(transition.nextState)) * 10;
    return score;
  }

  static MovableUnit? _movingUnit(GameState state, GameAction action) {
    return switch (action) {
      MoveTableauToTableau(:final fromColumn) ||
      MoveTableauToSlot(
        :final fromColumn,
      ) => state.tableau[fromColumn].exposedUnit,
      MoveStockToTableau() || MoveStockToSlot() =>
        state.stock.playableCard == null
            ? null
            : MovableUnit.single(state.stock.playableCard!),
      _ => null,
    };
  }

  static int countCards(GameState state) {
    var n = 0;
    for (final _ in state.allCardsOnBoard) {
      n++;
    }
    return n;
  }

  static String _stableLabel(GameAction action) => action.toJson().toString();
}
