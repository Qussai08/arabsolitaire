import 'package:game_engine/src/action/game_action.dart';
import 'package:game_engine/src/event/game_event.dart';
import 'package:game_engine/src/model/association_slot.dart';
import 'package:game_engine/src/model/attempt_status.dart';
import 'package:game_engine/src/model/game_state.dart';
import 'package:game_engine/src/model/movable_unit.dart';
import 'package:game_engine/src/model/tableau_column.dart';
import 'package:game_engine/src/model/undo_state.dart';
import 'package:game_engine/src/rules/completion_rules.dart';
import 'package:game_engine/src/rules/invariants.dart';
import 'package:game_engine/src/rules/tableau_rules.dart';
import 'package:game_engine/src/serialization/game_state_codec.dart';
import 'package:game_engine/src/transition/game_transition.dart';
import 'package:game_engine/src/transition/rejection_reason.dart';
import 'package:game_engine/src/transition/streak_effect.dart';

/// Authoritative transition: `GameState + GameAction → GameTransition`.
final class GameEngine {
  const GameEngine();

  GameTransition applyAction(GameState state, GameAction action) {
    if (action is UndoLastMove) {
      return _undo(state);
    }

    if (state.status != AttemptStatus.inProgress) {
      return _reject(state, action, RejectionReason.attemptNotInProgress);
    }

    if (state.movesRemaining <= 0) {
      return _reject(state, action, RejectionReason.noMovesRemaining);
    }

    return switch (action) {
      MoveTableauToTableau() => _moveTableauToTableau(state, action),
      MoveTableauToSlot() => _moveTableauToSlot(state, action),
      MoveStockToTableau() => _moveStockToTableau(state, action),
      MoveStockToSlot() => _moveStockToSlot(state, action),
      AdvanceStock() => _advanceStock(state),
      RestoreStock() => _restoreStock(state),
      UndoLastMove() => _undo(state),
    };
  }

  bool isWin(GameState state) =>
      state.status == AttemptStatus.won || !state.hasRemainingCards;

  bool validate(GameState state) => validateState(state);

  /// Deterministic legal-action enumeration for Solver consumers.
  List<GameAction> enumerateLegalActions(GameState state) {
    if (state.status != AttemptStatus.inProgress || state.movesRemaining <= 0) {
      return const [];
    }

    final actions = <GameAction>[];

    if (state.stock.canAdvance) actions.add(const AdvanceStock());
    if (state.stock.canRestore) actions.add(const RestoreStock());

    final playable = state.stock.playableCard;
    if (playable != null) {
      final unit = MovableUnit.single(playable);
      for (var c = 0; c < state.tableau.length; c++) {
        final probe = applyAction(state, MoveStockToTableau(toColumn: c));
        if (probe.accepted) actions.add(MoveStockToTableau(toColumn: c));
      }
      for (var s = 0; s < state.slots.length; s++) {
        final probe = applyAction(state, MoveStockToSlot(slotIndex: s));
        if (probe.accepted) actions.add(MoveStockToSlot(slotIndex: s));
      }
      // silence unused when unit only used for type
      assert(unit.cards.isNotEmpty);
    }

    for (var from = 0; from < state.tableau.length; from++) {
      if (state.tableau[from].exposedUnit == null) continue;
      for (var to = 0; to < state.tableau.length; to++) {
        if (from == to) continue;
        final action = MoveTableauToTableau(fromColumn: from, toColumn: to);
        if (applyAction(state, action).accepted) actions.add(action);
      }
      for (var s = 0; s < state.slots.length; s++) {
        final action = MoveTableauToSlot(fromColumn: from, slotIndex: s);
        if (applyAction(state, action).accepted) actions.add(action);
      }
    }

    if (state.undo.available) {
      actions.add(const UndoLastMove());
    }

    return actions;
  }

  GameTransition _reject(
    GameState state,
    GameAction action,
    RejectionReason reason,
  ) {
    final next = state.copyWith(streak: state.streak.resetCounter());
    return GameTransition.rejected(
      previousState: state,
      nextState: next,
      reason: reason,
      events: [MoveRejected(actionType: action.typeName, reason: reason.name)],
    );
  }

  GameTransition _undo(GameState state) {
    if (state.undo.blockedByCompletion) {
      return _reject(
        state,
        const UndoLastMove(),
        RejectionReason.undoBlockedByCompletion,
      );
    }
    if (state.undo.lastMoveWasUndone) {
      return _reject(
        state,
        const UndoLastMove(),
        RejectionReason.consecutiveUndoNotAllowed,
      );
    }
    if (state.undo.previousStateJson == null) {
      return _reject(
        state,
        const UndoLastMove(),
        RejectionReason.undoUnavailable,
      );
    }

    final restored = GameStateCodec.decode(state.undo.previousStateJson!);
    final next = restored.copyWith(undo: restored.undo.afterUndoPerformed());
    return GameTransition.accepted(
      previousState: state,
      nextState: next,
      moveCost: 0,
      streakEffect: StreakEffect.neutral,
      events: const [UndoPerformed()],
    );
  }

  GameTransition _advanceStock(GameState state) {
    if (!state.stock.canAdvance) {
      return _reject(
        state,
        const AdvanceStock(),
        RejectionReason.noStockAdvanceAvailable,
      );
    }
    return _commit(
      state: state,
      action: const AdvanceStock(),
      streakEffect: StreakEffect.neutral,
      apply: (s, events) {
        events.add(const StockAdvanced());
        return s.copyWith(stock: s.stock.advance());
      },
    );
  }

  GameTransition _restoreStock(GameState state) {
    if (!state.stock.canRestore) {
      return _reject(
        state,
        const RestoreStock(),
        RejectionReason.noStockRestoreAvailable,
      );
    }
    return _commit(
      state: state,
      action: const RestoreStock(),
      streakEffect: StreakEffect.neutral,
      apply: (s, events) {
        events.add(const StockRestored());
        return s.copyWith(stock: s.stock.restore());
      },
    );
  }

  GameTransition _moveTableauToTableau(
    GameState state,
    MoveTableauToTableau action,
  ) {
    if (action.fromColumn == action.toColumn) {
      return _reject(state, action, RejectionReason.sameColumnMove);
    }
    if (!_validColumn(state, action.fromColumn) ||
        !_validColumn(state, action.toColumn)) {
      return _reject(state, action, RejectionReason.invalidDestination);
    }

    final moving = state.tableau[action.fromColumn].exposedUnit;
    if (moving == null) {
      return _reject(state, action, RejectionReason.sourceEmpty);
    }

    final target = state.tableau[action.toColumn].exposedUnit;
    final check = validateTableauPlacement(moving: moving, target: target);
    if (!check.ok) {
      return _reject(state, action, check.reason!);
    }

    return _commit(
      state: state,
      action: action,
      streakEffect: check.streak!,
      apply: (s, events) {
        var tableau = List<TableauColumn>.from(s.tableau);
        tableau[action.toColumn] = tableau[action.toColumn].copyWith(
          exposedUnit: check.result,
        );
        // clear source exposed then reveal
        tableau[action.fromColumn] = tableau[action.fromColumn].copyWith(
          clearExposed: true,
        );
        final reveal = revealAfterRemoval(tableau, action.fromColumn);
        tableau = reveal.tableau;
        if (reveal.revealed != null) {
          events.add(
            CardRevealed(
              columnIndex: action.fromColumn,
              cardId: reveal.revealed!.id,
            ),
          );
        }
        _emitStackEvents(events, moving, target, check.result!);
        return s.copyWith(tableau: tableau);
      },
    );
  }

  GameTransition _moveStockToTableau(
    GameState state,
    MoveStockToTableau action,
  ) {
    final playable = state.stock.playableCard;
    if (playable == null) {
      return _reject(state, action, RejectionReason.stockCardNotPlayable);
    }
    if (!_validColumn(state, action.toColumn)) {
      return _reject(state, action, RejectionReason.invalidDestination);
    }

    final moving = MovableUnit.single(playable);
    final target = state.tableau[action.toColumn].exposedUnit;
    final check = validateTableauPlacement(moving: moving, target: target);
    if (!check.ok) {
      return _reject(state, action, check.reason!);
    }

    return _commit(
      state: state,
      action: action,
      streakEffect: check.streak!,
      apply: (s, events) {
        final tableau = List<TableauColumn>.from(s.tableau);
        tableau[action.toColumn] = tableau[action.toColumn].copyWith(
          exposedUnit: check.result,
        );
        _emitStackEvents(events, moving, target, check.result!);
        return s.copyWith(tableau: tableau, stock: s.stock.removePlayable());
      },
    );
  }

  GameTransition _moveTableauToSlot(GameState state, MoveTableauToSlot action) {
    if (!_validColumn(state, action.fromColumn) ||
        !_validSlot(state, action.slotIndex)) {
      return _reject(state, action, RejectionReason.invalidDestination);
    }
    final moving = state.tableau[action.fromColumn].exposedUnit;
    if (moving == null) {
      return _reject(state, action, RejectionReason.sourceEmpty);
    }

    return _placeUnitOnSlot(
      state: state,
      action: action,
      moving: moving,
      slotIndex: action.slotIndex,
      removeSource: (s, events) {
        var tableau = List<TableauColumn>.from(s.tableau);
        tableau[action.fromColumn] = tableau[action.fromColumn].copyWith(
          clearExposed: true,
        );
        final reveal = revealAfterRemoval(tableau, action.fromColumn);
        if (reveal.revealed != null) {
          events.add(
            CardRevealed(
              columnIndex: action.fromColumn,
              cardId: reveal.revealed!.id,
            ),
          );
        }
        return s.copyWith(tableau: reveal.tableau);
      },
    );
  }

  GameTransition _moveStockToSlot(GameState state, MoveStockToSlot action) {
    final playable = state.stock.playableCard;
    if (playable == null) {
      return _reject(state, action, RejectionReason.stockCardNotPlayable);
    }
    if (!_validSlot(state, action.slotIndex)) {
      return _reject(state, action, RejectionReason.invalidDestination);
    }
    final moving = MovableUnit.single(playable);
    return _placeUnitOnSlot(
      state: state,
      action: action,
      moving: moving,
      slotIndex: action.slotIndex,
      removeSource: (s, events) => s.copyWith(stock: s.stock.removePlayable()),
    );
  }

  GameTransition _placeUnitOnSlot({
    required GameState state,
    required GameAction action,
    required MovableUnit moving,
    required int slotIndex,
    required GameState Function(GameState s, List<GameEvent> events)
    removeSource,
  }) {
    final slot = state.slots[slotIndex];

    // Activate Association Card / Stack onto empty slot
    if (slot.isEmpty) {
      if (!isAssociationActivator(moving)) {
        return _reject(state, action, RejectionReason.invalidDestination);
      }
      final stack = switch (moving) {
        SingleAssociation(:final card) => AssociationStack(
          associationCard: card,
        ),
        AssociationStack() => moving,
        _ => throw StateError('unreachable'),
      };

      return _commit(
        state: state,
        action: action,
        streakEffect: StreakEffect.correct,
        apply: (s, events) {
          var next = removeSource(s, events);
          final slots = List<AssociationSlot>.from(next.slots);
          slots[slotIndex] = slots[slotIndex].copyWith(
            activeAssociation: stack,
          );
          events.add(
            AssociationActivated(
              associationId: stack.associationId,
              slotIndex: slotIndex,
            ),
          );
          next = next.copyWith(slots: slots);
          return _maybeComplete(next, slotIndex, events);
        },
      );
    }

    // Attach members to active association
    final members = membersOnly(moving);
    if (members == null) {
      return _reject(state, action, RejectionReason.slotOccupied);
    }
    final active = slot.activeAssociation!;
    if (moving.associationId != active.associationId) {
      return _reject(
        state,
        action,
        RejectionReason.associationMismatchWithActiveSlot,
      );
    }

    return _commit(
      state: state,
      action: action,
      streakEffect: StreakEffect.correct,
      apply: (s, events) {
        var next = removeSource(s, events);
        final slots = List<AssociationSlot>.from(next.slots);
        final updated = active.withAttachedMembers(members);
        slots[slotIndex] = slots[slotIndex].copyWith(
          activeAssociation: updated,
        );
        events.add(
          MembersAttached(
            associationId: active.associationId,
            memberCount: members.length,
          ),
        );
        next = next.copyWith(slots: slots);
        return _maybeComplete(next, slotIndex, events);
      },
    );
  }

  GameState _maybeComplete(
    GameState state,
    int slotIndex,
    List<GameEvent> events,
  ) {
    final stack = state.slots[slotIndex].activeAssociation;
    if (stack == null) return state;
    final def = state.associations[stack.associationId];
    if (def == null) return state;
    if (!isAssociationComplete(definition: def, stack: stack)) {
      return state;
    }

    final cleared = clearCompletedSlot(
      slots: state.slots,
      slotIndex: slotIndex,
      associationId: stack.associationId,
    );
    events.add(
      AssociationCompleted(
        associationId: stack.associationId,
        slotIndex: slotIndex,
      ),
    );
    return state.copyWith(
      slots: cleared.slots,
      completedAssociationIds: {
        ...state.completedAssociationIds,
        stack.associationId,
      },
    );
  }

  GameTransition _commit({
    required GameState state,
    required GameAction action,
    required StreakEffect streakEffect,
    required GameState Function(GameState s, List<GameEvent> events) apply,
  }) {
    final events = <GameEvent>[];
    final snapshot = GameStateCodec.encode(
      state.copyWith(undo: const UndoState()),
    );

    var next = apply(state, events);

    // Move cost
    next = next.copyWith(movesRemaining: next.movesRemaining - 1);
    events.add(MoveAccepted(actionType: action.typeName, moveCost: 1));

    // Streak
    if (streakEffect == StreakEffect.correct) {
      final (streak, granted) = next.streak.afterCorrectAction();
      next = next.copyWith(streak: streak);
      if (granted > 0) {
        events.add(StreakRewardEarned(coins: granted, tierReached: granted));
      }
    }

    final completedThisMove = events.any((e) => e is AssociationCompleted);

    // Undo eligibility
    next = next.copyWith(
      undo: completedThisMove
          ? const UndoState().afterCompletionMove()
          : const UndoState().afterEligibleMove(snapshot),
    );

    // Win / Out of Moves
    if (!next.hasRemainingCards) {
      next = next.copyWith(status: AttemptStatus.won);
      events.add(const GameWon());
    } else if (next.movesRemaining == 0) {
      next = next.copyWith(status: AttemptStatus.outOfMoves);
      events.add(const OutOfMovesReached());
    }

    final violation = findInvariantViolation(next);
    if (violation != null) {
      return _reject(state, action, RejectionReason.stateInvariantViolation);
    }

    return GameTransition.accepted(
      previousState: state,
      nextState: next,
      moveCost: 1,
      events: events,
      streakEffect: streakEffect,
    );
  }

  void _emitStackEvents(
    List<GameEvent> events,
    MovableUnit moving,
    MovableUnit? target,
    MovableUnit result,
  ) {
    if (result is AssociationStack && moving is SingleAssociation) {
      events.add(StackCreated(associationId: result.associationId));
    } else if (result is MemberStack &&
        (moving is SingleMember || moving is MemberStack) &&
        target != null) {
      events.add(StacksMerged(associationId: result.associationId));
    }
  }

  bool _validColumn(GameState state, int index) =>
      index >= 0 && index < state.tableau.length;

  bool _validSlot(GameState state, int index) =>
      index >= 0 && index < state.slots.length;
}
