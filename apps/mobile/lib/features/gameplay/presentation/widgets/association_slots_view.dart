import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/game_card_view.dart';

/// Row of association slots. The first slot sits on the start side.
class AssociationSlotsView extends StatelessWidget {
  const AssociationSlotsView({
    super.key,
    required this.slots,
    required this.revision,
    required this.onDrop,
    this.highlightedSlotIndex,
    this.associations = const {},
    this.vertical = false,
  });

  final List<AssociationSlot> slots;
  final int revision;
  final void Function(DragPayload payload, int slotIndex) onDrop;
  final int? highlightedSlotIndex;
  final Map<AssociationId, AssociationDefinition> associations;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        children: [
          for (var i = 0; i < slots.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
              child: _AssociationSlotView(
                slot: slots[i],
                revision: revision,
                onDrop: (payload) => onDrop(payload, i),
                highlighted: highlightedSlotIndex == i,
                associations: associations,
              ),
            ),
        ],
      );
    }
    // Expanded must be a direct Row child; padding goes inside.
    return Row(
      children: [
        for (var i = 0; i < slots.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: i == 0 ? 0 : 10),
              child: _AssociationSlotView(
                slot: slots[i],
                revision: revision,
                onDrop: (payload) => onDrop(payload, i),
                highlighted: highlightedSlotIndex == i,
                associations: associations,
              ),
            ),
          ),
      ],
    );
  }
}

class _AssociationSlotView extends StatelessWidget {
  const _AssociationSlotView({
    required this.slot,
    required this.revision,
    required this.onDrop,
    required this.associations,
    this.highlighted = false,
  });

  final AssociationSlot slot;
  final int revision;
  final void Function(DragPayload payload) onDrop;
  final Map<AssociationId, AssociationDefinition> associations;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragPayload>(
      onWillAcceptWithDetails: (details) => details.data.revision == revision,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidates, rejected) {
        final accepting = candidates.isNotEmpty;
        final active = slot.activeAssociation;
        final MosaicSlot mosaic;
        if (active == null) {
          mosaic = const MosaicSlot(
            state: MosaicSlotState.empty,
            width: double.infinity,
          );
        } else {
          final definition = associations[active.associationId];
          final total =
              definition?.requiredMemberCount ?? active.members.length;
          final filled = active.members.length;
          final members = [
            for (final member in active.members) cardFaceLabel(member),
          ];
          final complete = total > 0 && filled >= total;
          mosaic = MosaicSlot(
            state: complete
                ? MosaicSlotState.completed
                : accepting
                ? MosaicSlotState.dropTarget
                : MosaicSlotState.active,
            width: double.infinity,
            clue: cardFaceLabel(active.associationCard),
            filled: filled,
            total: total == 0 ? filled : total,
            members: members,
          );
        }
        return Semantics(label: highlighted ? 'تلميح' : null, child: mosaic);
      },
    );
  }
}
