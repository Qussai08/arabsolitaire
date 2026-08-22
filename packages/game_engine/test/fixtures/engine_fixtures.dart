import 'package:game_engine/src/model/association_definition.dart';
import 'package:game_engine/src/model/association_slot.dart';
import 'package:game_engine/src/model/card.dart';
import 'package:game_engine/src/model/game_state.dart';
import 'package:game_engine/src/model/identifiers.dart';
import 'package:game_engine/src/model/movable_unit.dart';
import 'package:game_engine/src/model/stock.dart';
import 'package:game_engine/src/model/tableau_column.dart';

/// Shared test/golden fixtures with stable IDs.
abstract final class EngineFixtures {
  static const assocA = 'assoc_a';
  static const assocB = 'assoc_b';

  static AssociationCard aCard({String id = 'a_card'}) =>
      AssociationCard(id: id, associationId: assocA);

  static MemberCard aMember(String id) =>
      MemberCard(id: id, associationId: assocA);

  static AssociationCard bCard({String id = 'b_card'}) =>
      AssociationCard(id: id, associationId: assocB);

  static MemberCard bMember(String id) =>
      MemberCard(id: id, associationId: assocB);

  static AssociationDefinition defA({
    String cardId = 'a_card',
    Set<CardId> members = const {'a1', 'a2'},
  }) {
    return AssociationDefinition(
      associationId: assocA,
      associationCardId: cardId,
      requiredMemberCardIds: members,
    );
  }

  static AssociationDefinition defB({
    String cardId = 'b_card',
    Set<CardId> members = const {'b1', 'b2'},
  }) {
    return AssociationDefinition(
      associationId: assocB,
      associationCardId: cardId,
      requiredMemberCardIds: members,
    );
  }

  static GameState base({
    required List<TableauColumn> tableau,
    StockState stock = const StockState(),
    int slotCount = 1,
    int moveLimit = 50,
    Map<AssociationId, AssociationDefinition>? associations,
    List<AssociationSlot>? slots,
  }) {
    final defs = associations ?? {assocA: defA(), assocB: defB()};
    return GameState(
      attemptId: 'attempt_1',
      levelDefinitionId: 'level_fixture',
      associations: defs,
      tableau: tableau,
      stock: stock,
      slots:
          slots ??
          [for (var i = 0; i < slotCount; i++) AssociationSlot(index: i)],
      moveLimit: moveLimit,
      movesRemaining: moveLimit,
    );
  }

  /// Two matching members exposed on columns 0 and 1.
  static GameState twoMatchingMembers() {
    return base(
      associations: {
        assocA: defA(members: {'a1', 'a2'}),
      },
      tableau: [
        columnWithTop(aMember('a1')),
        columnWithTop(aMember('a2')),
        const TableauColumn(),
      ],
    );
  }

  static GameState associationOntoMember() {
    return base(
      associations: {
        assocA: defA(members: {'a1'}),
      },
      tableau: [
        columnWithTop(aCard()),
        columnWithTop(aMember('a1')),
        const TableauColumn(),
      ],
    );
  }

  static GameState nearCompleteInSlot() {
    final def = defA(members: {'a1', 'a2'});
    return base(
      associations: {assocA: def},
      tableau: [columnWithTop(aMember('a2')), const TableauColumn()],
      slots: [
        AssociationSlot(
          index: 0,
          activeAssociation: AssociationStack(
            associationCard: aCard(),
            members: [aMember('a1')],
          ),
        ),
      ],
    );
  }

  static GameState stockCycle({int moveLimit = 20}) {
    return base(
      associations: {
        assocA: defA(members: {'a1', 'a2'}),
      },
      tableau: [const TableauColumn(), columnWithTop(aMember('a1'))],
      stock: StockState(undealt: [aMember('a2'), aCard(), bMember('b1')]),
      moveLimit: moveLimit,
    );
  }

  static GameState autoRevealBoard() {
    return base(
      associations: {
        assocA: defA(members: {'a1', 'a2'}),
      },
      tableau: [
        TableauColumn(
          hiddenCards: [aMember('a2')],
          exposedUnit: SingleMember(aMember('a1')),
        ),
        const TableauColumn(),
      ],
    );
  }

  static GameState oneMoveToWin({int movesRemaining = 1}) {
    final def = defA(members: {'a1'});
    final state = base(
      associations: {assocA: def},
      tableau: [columnWithTop(aMember('a1'))],
      slots: [
        AssociationSlot(
          index: 0,
          activeAssociation: AssociationStack(associationCard: aCard()),
        ),
      ],
      moveLimit: movesRemaining,
    );
    return state.copyWith(movesRemaining: movesRemaining);
  }
}
