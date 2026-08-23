import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/game_card_view.dart';

/// Row of Association Slots — drop targets for activating associations.
class AssociationSlotsView extends StatelessWidget {
  const AssociationSlotsView({
    super.key,
    required this.slots,
    required this.revision,
    required this.onDrop,
    this.highlightedSlotIndex,
  });

  final List<AssociationSlot> slots;
  final int revision;
  final void Function(DragPayload payload, int slotIndex) onDrop;
  final int? highlightedSlotIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < slots.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _AssociationSlotView(
              slot: slots[i],
              slotIndex: i,
              revision: revision,
              onDrop: (p) => onDrop(p, i),
              highlighted: highlightedSlotIndex == i,
            ),
          ),
      ],
    );
  }
}

class _AssociationSlotView extends StatelessWidget {
  const _AssociationSlotView({
    required this.slot,
    required this.slotIndex,
    required this.revision,
    required this.onDrop,
    this.highlighted = false,
  });

  final AssociationSlot slot;
  final int slotIndex;
  final int revision;
  final void Function(DragPayload payload) onDrop;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragPayload>(
      onWillAcceptWithDetails: (details) => details.data.revision == revision,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidates, rejected) {
        final accepting = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 90,
          constraints: const BoxConstraints(minHeight: 62),
          decoration: BoxDecoration(
            color: accepting
                ? const Color(0xFF2A5C2A).withAlpha((255 * 0.3).round())
                : (slot.isEmpty
                      ? const Color(0xFF0D2040).withAlpha((255 * 0.6).round())
                      : const Color(0xFF1A4A7C).withAlpha((255 * 0.4).round())),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: highlighted
                  ? const Color(0xFFFFD700)
                  : (slot.isEmpty
                        ? const Color(0xFF3A5A8C).withAlpha((255 * 0.5).round())
                        : const Color(0xFF4A8AEC)),
              width: highlighted ? 2.5 : 1.2,
            ),
          ),
          child: slot.isEmpty
              ? _buildEmpty()
              : _buildActive(slot.activeAssociation!),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Icon(
          Icons.add_circle_outline,
          color: Color(0xFF3A5A8C),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildActive(AssociationStack assoc) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameCardView(card: assoc.associationCard),
          if (assoc.members.isNotEmpty) ...[
            const SizedBox(height: 3),
            ...assoc.members.map(
              (m) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: GameCardView(card: m, isSmall: true),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
