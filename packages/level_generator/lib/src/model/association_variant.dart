import 'package:game_engine/game_engine.dart';

/// Pre-approved association content reference (IDs only — no Arabic inference).
final class AssociationVariant {
  const AssociationVariant({
    required this.associationId,
    required this.associationCardId,
    required this.memberCardIds,
    this.contentType = 'generic',
    this.variantId,
  });

  final AssociationId associationId;
  final CardId associationCardId;
  final List<CardId> memberCardIds;
  final String contentType;
  final String? variantId;

  int get memberCount => memberCardIds.length;

  String get id => variantId ?? associationId;

  AssociationDefinition toDefinition() {
    return AssociationDefinition(
      associationId: associationId,
      associationCardId: associationCardId,
      requiredMemberCardIds: memberCardIds.toSet(),
    );
  }

  List<GameCard> toCards() {
    return [
      AssociationCard(id: associationCardId, associationId: associationId),
      for (final id in memberCardIds)
        MemberCard(id: id, associationId: associationId),
    ];
  }
}
