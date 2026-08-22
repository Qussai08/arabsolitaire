import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:game_solver/src/canonical/canonical_state_key.dart';
import 'package:test/test.dart';

import 'fixtures/solver_fixtures.dart';

void main() {
  final solver = GameSolver();
  const options = SolverOptions.testDefaults;

  group('golden boards', () {
    test('GB-001 one move win', () {
      final result = solver.solve(
        state: SolverFixtures.oneMoveWin(),
        options: options,
      );
      expect(result, isA<Solved>());
      final solved = result as Solved;
      expect(solved.solutionLength, 1);
      expect(
        GameReplay.run(
          initialState: SolverFixtures.oneMoveWin(),
          actions: solved.actions,
        ).finalState.status,
        AttemptStatus.won,
      );
    });

    test('GB-002 exact move limit', () {
      final state = SolverFixtures.exactTwoMoves();
      final result = solver.solve(state: state, options: options);
      expect(result, isA<Solved>());
      expect((result as Solved).solutionLength, 2);
      expect(result.solutionLength, state.movesRemaining);
    });

    test('GB-003 one move over budget → unsolvable', () {
      final result = solver.solve(
        state: SolverFixtures.oneOverBudget(),
        options: options,
      );
      expect(result, isA<Unsolvable>());
    });

    test('GB-004 stock required', () {
      final result = solver.solve(
        state: SolverFixtures.stockRequired(),
        options: options,
      );
      expect(result, isA<Solved>());
      expect((result as Solved).actions.any((a) => a is AdvanceStock), isTrue);
    });

    test('GB-005 restore available and board solvable', () {
      final state = SolverFixtures.restoreRequired();
      expect(state.stock.canRestore, isTrue);
      expect(solver.legalActions(state).any((a) => a is RestoreStock), isTrue);
      expect(
        solver.legalActions(state).any((a) => a is MoveStockToTableau),
        isFalse,
        reason: 'playable waste card should be blocked',
      );
      final result = solver.solve(state: state, options: options);
      expect(result, isA<Solved>());
    });

    test('GB-006 reveal required', () {
      final result = solver.solve(
        state: SolverFixtures.revealRequired(),
        options: options,
      );
      expect(result, isA<Solved>());
    });

    test('GB-007 association stack / activation path', () {
      final result = solver.solve(
        state: SolverFixtures.associationStackRequired(),
        options: options,
      );
      expect(result, isA<Solved>());
    });

    test('GB-008 empty column rearrangement', () {
      final result = solver.solve(
        state: SolverFixtures.emptyColumnRearrangement(),
        options: options,
      );
      expect(result, isA<Solved>());
    });

    test('GB-009 symmetric empty columns still solvable', () {
      final result = solver.solve(
        state: SolverFixtures.emptyColumnRearrangement(),
        options: options,
      );
      expect(result, isA<Solved>());
    });

    test('GB-010 confirmed dead-end', () {
      final result = solver.solve(
        state: SolverFixtures.confirmedDeadEnd(),
        options: options,
      );
      expect(result, isA<Unsolvable>());
      final dead = solver.evaluateDeadEnd(
        state: SolverFixtures.confirmedDeadEnd(),
        options: options,
      );
      expect(dead, isA<ConfirmedDeadEnd>());
    });

    test('GB-011 cycle trap terminates and solves', () {
      final result = solver.solve(
        state: SolverFixtures.cycleTrap(),
        options: options,
      );
      expect(result, isA<Solved>());
    });

    test('GB-012 multi-association win', () {
      final result = solver.solve(
        state: SolverFixtures.multiAssociation(),
        options: options,
      );
      expect(result, isA<Solved>());
      expect(
        GameReplay.run(
          initialState: SolverFixtures.multiAssociation(),
          actions: (result as Solved).actions,
        ).finalState.status,
        AttemptStatus.won,
      );
    });

    test('GB-013 inconclusive node budget', () {
      final result = solver.solve(
        state: SolverFixtures.multiAssociation(),
        options: const SolverOptions(
          maxExpandedNodes: 1,
          timeout: Duration(seconds: 5),
        ),
      );
      expect(result, isA<SolveInconclusive>());
      expect(
        (result as SolveInconclusive).reason,
        InconclusiveReason.nodeBudgetExceeded,
      );
    });

    test('GB-014 final move at zero wins', () {
      final result = solver.solve(
        state: SolverFixtures.oneMoveWin(movesRemaining: 1),
        options: options,
      );
      expect(result, isA<Solved>());
      final replay = GameReplay.run(
        initialState: SolverFixtures.oneMoveWin(movesRemaining: 1),
        actions: (result as Solved).actions,
      );
      expect(replay.finalState.status, AttemptStatus.won);
      expect(replay.finalState.movesRemaining, 0);
    });
  });

  group('hint and dead-end', () {
    test('hint returns first action of proven solution', () {
      final hint = solver.findHint(
        state: SolverFixtures.exactTwoMoves(),
        options: options,
      );
      expect(hint, isA<HintAvailable>());
      final available = hint as HintAvailable;
      final applied = const GameEngine().applyAction(
        SolverFixtures.exactTwoMoves(),
        available.action,
      );
      expect(applied.accepted, isTrue);
    });

    test('hint inconclusive when budget tiny', () {
      final hint = solver.findHint(
        state: SolverFixtures.multiAssociation(),
        options: const SolverOptions(maxExpandedNodes: 1),
      );
      expect(hint, isA<HintInconclusive>());
    });

    test('dead-end inconclusive never confirmed on budget', () {
      final dead = solver.evaluateDeadEnd(
        state: SolverFixtures.multiAssociation(),
        options: const SolverOptions(maxExpandedNodes: 1),
      );
      expect(dead, isA<DeadEndInconclusive>());
    });
  });

  group('parity and canonicalization', () {
    test('legal actions all accepted by engine', () {
      final state = SolverFixtures.exactTwoMoves();
      for (final action in solver.legalActions(state)) {
        expect(
          const GameEngine().applyAction(state, action).accepted,
          isTrue,
          reason: '$action',
        );
      }
      expect(solver.legalActions(state).any((a) => a is UndoLastMove), isFalse);
    });

    test('canonical key stable and excludes streak', () {
      final a = SolverFixtures.exactTwoMoves();
      final b = a.copyWith(
        streak: const StreakState(currentCounter: 2, targetTier: 4),
      );
      expect(CanonicalStateKey.of(a), CanonicalStateKey.of(b));
    });

    test('member stack order irrelevant in key', () {
      final u1 = MemberStack([
        SolverFixtures.aMember('a1'),
        SolverFixtures.aMember('a2'),
      ]);
      final u2 = MemberStack([
        SolverFixtures.aMember('a2'),
        SolverFixtures.aMember('a1'),
      ]);
      final s1 = SolverFixtures.state(
        associations: {
          SolverFixtures.assocA: SolverFixtures.defA(members: {'a1', 'a2'}),
        },
        tableau: [TableauColumn(exposedUnit: u1)],
      );
      final s2 = SolverFixtures.state(
        associations: {
          SolverFixtures.assocA: SolverFixtures.defA(members: {'a1', 'a2'}),
        },
        tableau: [TableauColumn(exposedUnit: u2)],
      );
      expect(CanonicalStateKey.of(s1), CanonicalStateKey.of(s2));
    });

    test('determinism of solve category', () {
      final state = SolverFixtures.exactTwoMoves();
      final a = solver.solve(state: state, options: options);
      final b = solver.solve(state: state, options: options);
      expect(a.runtimeType, b.runtimeType);
      expect((a as Solved).actions, (b as Solved).actions);
    });
  });

  group('package wiring', () {
    test('versions', () {
      expect(gameSolverPackageVersion, isNotEmpty);
    });
  });
}
