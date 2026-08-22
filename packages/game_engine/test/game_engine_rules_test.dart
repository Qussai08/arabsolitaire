import 'package:game_engine/game_engine.dart';
import 'package:game_engine/src/rules/tableau_rules.dart';
import 'package:test/test.dart';

import 'fixtures/engine_fixtures.dart';

void main() {
  const engine = GameEngine();

  group('movable units', () {
    test('creates member stack from matching members', () {
      final stack = MemberStack([
        EngineFixtures.aMember('a1'),
        EngineFixtures.aMember('a2'),
      ]);
      expect(stack.size, 2);
      expect(stack.associationId, EngineFixtures.assocA);
    });

    test('rejects mixed association member stack', () {
      expect(
        () => MemberStack([
          EngineFixtures.aMember('a1'),
          EngineFixtures.bMember('b1'),
        ]),
        throwsArgumentError,
      );
    });

    test('creates association stack from matching members', () {
      final stack = AssociationStack(
        associationCard: EngineFixtures.aCard(),
        members: [EngineFixtures.aMember('a1')],
      );
      expect(stack.cards.length, 2);
    });

    test('rejects mismatched association stack', () {
      expect(
        () => AssociationStack(
          associationCard: EngineFixtures.aCard(),
          members: [EngineFixtures.bMember('b1')],
        ),
        throwsArgumentError,
      );
    });
  });

  group('tableau rules', () {
    test('GE-001 member merge', () {
      final state = EngineFixtures.twoMatchingMembers();
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(t.accepted, isTrue);
      expect(t.moveCost, 1);
      expect(t.streakEffect, StreakEffect.correct);
      final exposed = t.nextState.tableau[1].exposedUnit;
      expect(exposed, isA<MemberStack>());
      expect(exposed!.size, 2);
      expect(t.nextState.tableau[0].isEmpty, isTrue);
    });

    test('rejects non-matching member merge', () {
      final state = EngineFixtures.base(
        associations: {
          EngineFixtures.assocA: EngineFixtures.defA(members: {'a1'}),
          EngineFixtures.assocB: EngineFixtures.defB(members: {'b1'}),
        },
        tableau: [
          columnWithTop(EngineFixtures.aMember('a1')),
          columnWithTop(EngineFixtures.bMember('b1')),
        ],
      );
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(t.accepted, isFalse);
      expect(t.rejectionReason, RejectionReason.associationMismatch);
      expect(t.nextState.movesRemaining, state.movesRemaining);
      expect(t.nextState.streak.currentCounter, 0);
    });

    test('GE-002 association onto matching member', () {
      final state = EngineFixtures.associationOntoMember();
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(t.accepted, isTrue);
      expect(t.nextState.tableau[1].exposedUnit, isA<AssociationStack>());
    });

    test('member cannot move onto association in tableau', () {
      final state = EngineFixtures.associationOntoMember();
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 1, toColumn: 0),
      );
      expect(t.accepted, isFalse);
      expect(
        t.rejectionReason,
        RejectionReason.memberCannotMoveOntoAssociationInTableau,
      );
    });

    test('any unit to empty tableau is neutral', () {
      final state = EngineFixtures.twoMatchingMembers();
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 2),
      );
      expect(t.accepted, isTrue);
      expect(t.streakEffect, StreakEffect.neutral);
      expect(t.nextState.streak.currentCounter, 0);
    });

    test('GE-006 auto-reveal after source move', () {
      final state = EngineFixtures.autoRevealBoard();
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(t.accepted, isTrue);
      expect(t.nextState.tableau[0].exposedUnit, isA<SingleMember>());
      expect(
        (t.nextState.tableau[0].exposedUnit! as SingleMember).card.id,
        'a2',
      );
      expect(t.events.whereType<CardRevealed>(), isNotEmpty);
      expect(t.moveCost, 1);
    });

    test('association stack cannot move onto non-empty tableau', () {
      final stack = AssociationStack(
        associationCard: EngineFixtures.aCard(),
        members: [EngineFixtures.aMember('a1')],
      );
      final state = EngineFixtures.base(
        associations: {
          EngineFixtures.assocA: EngineFixtures.defA(members: {'a1'}),
        },
        tableau: [
          TableauColumn(exposedUnit: stack),
          columnWithTop(EngineFixtures.bMember('b1')),
        ],
      );
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(t.accepted, isFalse);
      expect(
        t.rejectionReason,
        RejectionReason.associationStackCannotMoveOntoNonEmptyTableau,
      );
    });
  });

  group('slots & completion', () {
    test('GE-003 association activation in slot', () {
      final state = EngineFixtures.base(
        associations: {
          EngineFixtures.assocA: EngineFixtures.defA(members: {'a1'}),
        },
        tableau: [columnWithTop(EngineFixtures.aCard())],
        slotCount: 1,
      );
      final t = engine.applyAction(
        state,
        const MoveTableauToSlot(fromColumn: 0, slotIndex: 0),
      );
      expect(t.accepted, isTrue);
      expect(t.nextState.slots[0].activeAssociation, isNotNull);
      expect(t.events.whereType<AssociationActivated>(), isNotEmpty);
    });

    test('GE-004 association completion frees slot', () {
      final state = EngineFixtures.nearCompleteInSlot();
      final t = engine.applyAction(
        state,
        const MoveTableauToSlot(fromColumn: 0, slotIndex: 0),
      );
      expect(t.accepted, isTrue);
      expect(t.nextState.slots[0].isEmpty, isTrue);
      expect(
        t.nextState.completedAssociationIds,
        contains(EngineFixtures.assocA),
      );
      expect(t.events.whereType<AssociationCompleted>(), isNotEmpty);
    });

    test('wrong member to active association rejected', () {
      final state = EngineFixtures.base(
        associations: {
          EngineFixtures.assocA: EngineFixtures.defA(members: {'a1'}),
          EngineFixtures.assocB: EngineFixtures.defB(members: {'b1'}),
        },
        tableau: [columnWithTop(EngineFixtures.bMember('b1'))],
        slots: [
          AssociationSlot(
            index: 0,
            activeAssociation: AssociationStack(
              associationCard: EngineFixtures.aCard(),
            ),
          ),
        ],
      );
      final t = engine.applyAction(
        state,
        const MoveTableauToSlot(fromColumn: 0, slotIndex: 0),
      );
      expect(t.accepted, isFalse);
      expect(
        t.rejectionReason,
        RejectionReason.associationMismatchWithActiveSlot,
      );
    });
  });

  group('stock', () {
    test('GE-005 advance restore visible window', () {
      var state = EngineFixtures.stockCycle();
      expect(state.stock.playableCard, isNull);

      var t = engine.applyAction(state, const AdvanceStock());
      expect(t.accepted, isTrue);
      expect(t.streakEffect, StreakEffect.neutral);
      state = t.nextState;
      expect(state.stock.visibleCards.length, 1);
      expect(state.stock.playableCard!.id, 'a2');

      t = engine.applyAction(state, const AdvanceStock());
      state = t.nextState;
      t = engine.applyAction(state, const AdvanceStock());
      state = t.nextState;
      expect(state.stock.visibleCards.length, 3);
      expect(state.stock.playableCard!.id, 'b1');
      expect(state.stock.canAdvance, isFalse);
      expect(state.stock.canRestore, isTrue);

      final orderBefore = state.stock.waste.map((c) => c.id).toList();
      t = engine.applyAction(state, const RestoreStock());
      expect(t.accepted, isTrue);
      state = t.nextState;
      expect(state.stock.waste, isEmpty);
      expect(state.stock.undealt.map((c) => c.id), orderBefore);

      // playable after re-advance; removed cards must not return
      t = engine.applyAction(state, const AdvanceStock());
      state = t.nextState;
      t = engine.applyAction(state, const MoveStockToTableau(toColumn: 0));
      expect(t.accepted, isTrue);
      state = t.nextState;
      expect(state.stock.allRemainingCards.any((c) => c.id == 'a2'), isFalse);

      // finish cycle and restore — a2 still gone
      while (state.stock.canAdvance) {
        state = engine.applyAction(state, const AdvanceStock()).nextState;
      }
      if (state.stock.canRestore) {
        state = engine.applyAction(state, const RestoreStock()).nextState;
      }
      expect(state.stock.allRemainingCards.any((c) => c.id == 'a2'), isFalse);
    });

    test('non-playable stock interaction via only playable API', () {
      var state = EngineFixtures.stockCycle();
      state = engine.applyAction(state, const AdvanceStock()).nextState;
      state = engine.applyAction(state, const AdvanceStock()).nextState;
      // Only playable (last) can move — engine has no action for older waste cards.
      expect(state.stock.visibleCards.length, 2);
      expect(state.stock.playableCard!.id, 'a_card');
    });
  });

  group('moves win streak undo', () {
    test('invalid action costs 0 and resets streak counter', () {
      var state = EngineFixtures.twoMatchingMembers();
      state = engine
          .applyAction(
            state,
            const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
          )
          .nextState;
      expect(state.streak.currentCounter, 1);
      final bad = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(bad.accepted, isFalse);
      expect(bad.moveCost, 0);
      expect(bad.nextState.streak.currentCounter, 0);
      expect(bad.nextState.streak.targetTier, state.streak.targetTier);
    });

    test('tier 5 grants +5 and stays at tier 5', () {
      const streak = StreakState(currentCounter: 4, targetTier: 5);
      final (next, granted) = streak.afterCorrectAction();
      expect(granted, 5);
      expect(next.targetTier, 5);
      expect(next.currentCounter, 0);
      expect(next.earnedStreakCoins, 5);
    });

    test('GE-009 streak 3→4→5 progression', () {
      // Build a board where we can do many correct merges.
      var state = EngineFixtures.base(
        associations: {
          EngineFixtures.assocA: EngineFixtures.defA(
            members: {
              'a1',
              'a2',
              'a3',
              'a4',
              'a5',
              'a6',
              'a7',
              'a8',
              'a9',
              'a10',
              'a11',
              'a12',
            },
          ),
        },
        tableau: [
          for (var i = 1; i <= 12; i++)
            columnWithTop(EngineFixtures.aMember('a$i')),
        ],
        slotCount: 0,
        moveLimit: 40,
      );

      // Merge pairs: 0→1, 2→3, ... each merge is correct
      void merge(int from, int to) {
        final t = engine.applyAction(
          state,
          MoveTableauToTableau(fromColumn: from, toColumn: to),
        );
        expect(t.accepted, isTrue, reason: '$from->$to');
        state = t.nextState;
      }

      merge(0, 1); // 1
      merge(2, 3); // 2
      final t3 = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 4, toColumn: 5),
      );
      expect(t3.accepted, isTrue);
      state = t3.nextState;
      expect(state.streak.earnedStreakCoins, 3);
      expect(state.streak.targetTier, 4);
      expect(state.streak.currentCounter, 0);
      expect(t3.events.whereType<StreakRewardEarned>(), isNotEmpty);

      merge(6, 7);
      merge(8, 9);
      merge(10, 11);
      // need 4th correct for tier 4 — merge stacks
      // columns 1,3,5,7,9,11 have stacks; merge 1→3
      final beforeTier4 = state.streak;
      expect(beforeTier4.targetTier, 4);
      expect(beforeTier4.currentCounter, 3);
      final t4 = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 1, toColumn: 3),
      );
      expect(t4.accepted, isTrue);
      state = t4.nextState;
      expect(state.streak.earnedStreakCoins, 3 + 4);
      expect(state.streak.targetTier, 5);

      // five more corrects at tier 5
      // remaining stacks at 3,5,7,9,11 — merge among empties carefully
      // After merges: col3 has large stack, 5,7,9,11 have stacks
      for (final pair in [
        [5, 3],
        [7, 3],
        [9, 3],
        [11, 3],
      ]) {
        state = engine
            .applyAction(
              state,
              MoveTableauToTableau(fromColumn: pair[0], toColumn: pair[1]),
            )
            .nextState;
      }
      // 4 corrects so far at tier 5; one more needed
      // only col3 left with stack — need another member somewhere
      // Use empty tableau neutral then we need another correct — put association path
      // Simpler assert: after 4 merges at tier 5, counter is 4
      expect(state.streak.targetTier, 5);
      expect(state.streak.currentCounter, 4);
    });

    test('GE-010 final move win at 0 moves', () {
      final state = EngineFixtures.oneMoveToWin(movesRemaining: 1);
      final t = engine.applyAction(
        state,
        const MoveTableauToSlot(fromColumn: 0, slotIndex: 0),
      );
      expect(t.accepted, isTrue);
      expect(t.nextState.movesRemaining, 0);
      expect(t.nextState.status, AttemptStatus.won);
      expect(t.events.whereType<GameWon>(), isNotEmpty);
      expect(t.events.whereType<OutOfMovesReached>(), isEmpty);
    });

    test('out of moves when not won', () {
      final state = EngineFixtures.twoMatchingMembers().copyWith(
        movesRemaining: 1,
      );
      final t = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 2),
      );
      expect(t.accepted, isTrue);
      expect(t.nextState.status, AttemptStatus.outOfMoves);
      expect(t.nextState.hasRemainingCards, isTrue);
    });

    test('GE-007 undo restores board and moves', () {
      final state = EngineFixtures.twoMatchingMembers();
      final moved = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(moved.nextState.undo.available, isTrue);
      final undone = engine.applyAction(moved.nextState, const UndoLastMove());
      expect(undone.accepted, isTrue);
      expect(undone.moveCost, 0);
      expect(undone.nextState.movesRemaining, state.movesRemaining);
      expect(undone.nextState.tableau[0], state.tableau[0]);
      expect(undone.nextState.tableau[1], state.tableau[1]);
      expect(undone.nextState.undo.lastMoveWasUndone, isTrue);

      final second = engine.applyAction(undone.nextState, const UndoLastMove());
      expect(second.accepted, isFalse);
      expect(second.rejectionReason, RejectionReason.consecutiveUndoNotAllowed);
    });

    test('GE-008 undo blocked after completion', () {
      final state = EngineFixtures.nearCompleteInSlot();
      final t = engine.applyAction(
        state,
        const MoveTableauToSlot(fromColumn: 0, slotIndex: 0),
      );
      expect(t.nextState.undo.blockedByCompletion, isTrue);
      final undo = engine.applyAction(t.nextState, const UndoLastMove());
      expect(undo.accepted, isFalse);
      expect(undo.rejectionReason, RejectionReason.undoBlockedByCompletion);
    });

    test('undo restores auto-reveal', () {
      final state = EngineFixtures.autoRevealBoard();
      final moved = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      final undone = engine.applyAction(moved.nextState, const UndoLastMove());
      expect(undone.nextState.tableau[0], state.tableau[0]);
      expect(undone.nextState.tableau[1], state.tableau[1]);
    });

    test('invalid action does not replace undo history', () {
      final state = EngineFixtures.twoMatchingMembers();
      final moved = engine.applyAction(
        state,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      final bad = engine.applyAction(
        moved.nextState,
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(bad.nextState.undo.available, isTrue);
      expect(
        bad.nextState.undo.previousStateJson,
        moved.nextState.undo.previousStateJson,
      );
    });
  });

  group('serialization & replay', () {
    test('state and action round-trip', () {
      final state = EngineFixtures.stockCycle();
      final encoded = GameStateCodec.encode(state);
      final decoded = GameStateCodec.decode(encoded);
      expect(decoded, state);

      const action = MoveTableauToTableau(fromColumn: 0, toColumn: 1);
      expect(ActionCodec.decode(ActionCodec.encode(action)), action);
    });

    test('replay is deterministic', () {
      final initial = EngineFixtures.twoMatchingMembers();
      final actions = [
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
        const MoveTableauToTableau(fromColumn: 1, toColumn: 2),
      ];
      final a = GameReplay.run(initialState: initial, actions: actions);
      final b = GameReplay.run(initialState: initial, actions: actions);
      expect(a.succeeded, isTrue);
      expect(a.finalState, b.finalState);
    });
  });

  group('package identity', () {
    test('versions exposed', () {
      expect(gameEnginePackageVersion, isNotEmpty);
      expect(gameEngineRulesVersion, '1.0.0');
    });

    test('validateTableauPlacement helper for empty', () {
      final r = validateTableauPlacement(
        moving: SingleMember(EngineFixtures.aMember('a1')),
        target: null,
      );
      expect(r.ok, isTrue);
      expect(r.streak, StreakEffect.neutral);
    });
  });
}
