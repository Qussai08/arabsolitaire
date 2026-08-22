import 'package:game_engine/game_engine.dart';

/// Deterministic Solver golden boards (GB-*).
abstract final class SolverFixtures {
  static const assocA = 'assoc_a';
  static const assocB = 'assoc_b';

  static AssociationCard aCard([String id = 'a_card']) =>
      AssociationCard(id: id, associationId: assocA);

  static MemberCard aMember(String id) =>
      MemberCard(id: id, associationId: assocA);

  static AssociationCard bCard([String id = 'b_card']) =>
      AssociationCard(id: id, associationId: assocB);

  static MemberCard bMember(String id) =>
      MemberCard(id: id, associationId: assocB);

  static AssociationDefinition defA({
    String cardId = 'a_card',
    Set<String> members = const {'a1'},
  }) {
    return AssociationDefinition(
      associationId: assocA,
      associationCardId: cardId,
      requiredMemberCardIds: members,
    );
  }

  /// Association that completes with only its Association Card (blocker utility).
  static AssociationDefinition defBEmpty({String cardId = 'b_card'}) {
    return AssociationDefinition(
      associationId: assocB,
      associationCardId: cardId,
      requiredMemberCardIds: const {},
    );
  }

  static AssociationDefinition defB({
    String cardId = 'b_card',
    Set<String> members = const {'b1'},
  }) {
    return AssociationDefinition(
      associationId: assocB,
      associationCardId: cardId,
      requiredMemberCardIds: members,
    );
  }

  static GameState state({
    required List<TableauColumn> tableau,
    StockState stock = const StockState(),
    List<AssociationSlot>? slots,
    Map<String, AssociationDefinition>? associations,
    int moveLimit = 20,
    int? movesRemaining,
    Set<String>? completed,
  }) {
    return GameState(
      attemptId: 'gb',
      levelDefinitionId: 'gb_level',
      associations: associations ?? {assocA: defA()},
      tableau: tableau,
      stock: stock,
      slots: slots ?? [const AssociationSlot(index: 0)],
      moveLimit: moveLimit,
      movesRemaining: movesRemaining ?? moveLimit,
      completedAssociationIds: completed,
    );
  }

  static GameState oneMoveWin({int movesRemaining = 1}) {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
      },
      tableau: [columnWithTop(aMember('a1'))],
      slots: [
        AssociationSlot(
          index: 0,
          activeAssociation: AssociationStack(associationCard: aCard()),
        ),
      ],
      moveLimit: movesRemaining,
      movesRemaining: movesRemaining,
    );
  }

  static GameState exactTwoMoves() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
      },
      tableau: [columnWithTop(aCard()), columnWithTop(aMember('a1'))],
      moveLimit: 2,
      movesRemaining: 2,
    );
  }

  static GameState oneOverBudget() {
    return exactTwoMoves().copyWith(movesRemaining: 1);
  }

  static GameState stockRequired() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
      },
      tableau: [const TableauColumn(), columnWithTop(aCard())],
      stock: StockState(undealt: [aMember('a1')]),
      slots: [const AssociationSlot(index: 0)],
      moveLimit: 10,
    );
  }

  /// Needed card buried; playable member has no legal destination (forces Restore).
  static GameState restoreRequired() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
        assocB: defB(members: {'b1'}),
      },
      tableau: [columnWithTop(aCard()), columnWithTop(bCard())],
      stock: StockState(
        undealt: const [],
        waste: [aMember('a1'), bMember('b1')],
      ),
      slots: [const AssociationSlot(index: 0)],
      moveLimit: 20,
    );
  }

  /// Reveal hidden a1 by parking empty-member Association Card B.
  static GameState revealRequired() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
        assocB: defBEmpty(),
      },
      tableau: [
        TableauColumn(
          hiddenCards: [aMember('a1')],
          exposedUnit: SingleAssociation(bCard()),
        ),
        const TableauColumn(),
        columnWithTop(aCard()),
      ],
      slots: [const AssociationSlot(index: 0)],
      moveLimit: 10,
    );
  }

  static GameState associationStackRequired() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
      },
      tableau: [
        columnWithTop(aCard()),
        columnWithTop(aMember('a1')),
        const TableauColumn(),
      ],
      moveLimit: 10,
    );
  }

  static GameState emptyColumnRearrangement() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
        assocB: defBEmpty(),
      },
      tableau: [
        TableauColumn(
          hiddenCards: [aMember('a1')],
          exposedUnit: SingleAssociation(bCard()),
        ),
        columnWithTop(aCard()),
        const TableauColumn(),
        const TableauColumn(),
      ],
      slots: [const AssociationSlot(index: 0)],
      moveLimit: 12,
    );
  }

  static GameState confirmedDeadEnd() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
        assocB: defB(members: {'b1'}),
      },
      tableau: [columnWithTop(bMember('b1'))],
      slots: [
        AssociationSlot(
          index: 0,
          activeAssociation: AssociationStack(associationCard: aCard()),
        ),
      ],
      moveLimit: 5,
    );
  }

  static GameState cycleTrap() => stockRequired();

  static GameState multiAssociation() {
    return state(
      associations: {
        assocA: defA(members: {'a1'}),
        assocB: defB(members: {'b1'}),
      },
      tableau: [
        columnWithTop(aCard()),
        columnWithTop(aMember('a1')),
        columnWithTop(bCard()),
        columnWithTop(bMember('b1')),
      ],
      slots: [const AssociationSlot(index: 0), const AssociationSlot(index: 1)],
      moveLimit: 20,
    );
  }
}
