import 'package:game_engine/src/model/association_definition.dart';
import 'package:game_engine/src/model/association_slot.dart';
import 'package:game_engine/src/model/identifiers.dart';
import 'package:game_engine/src/model/movable_unit.dart';

bool isAssociationComplete({
  required AssociationDefinition definition,
  required AssociationStack stack,
}) {
  if (stack.associationCard.id != definition.associationCardId) {
    return false;
  }
  final have = stack.memberIds;
  if (have.length != definition.requiredMemberCardIds.length) {
    return false;
  }
  for (final id in definition.requiredMemberCardIds) {
    if (!have.contains(id)) return false;
  }
  return true;
}

({List<AssociationSlot> slots, AssociationId? completedId}) clearCompletedSlot({
  required List<AssociationSlot> slots,
  required int slotIndex,
  required AssociationId associationId,
}) {
  final next = [...slots];
  next[slotIndex] = next[slotIndex].copyWith(clear: true);
  return (slots: next, completedId: associationId);
}
