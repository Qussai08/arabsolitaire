import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/game_card_view.dart';

/// Stock pile + visible card fan + Advance/Restore controls.
class StockView extends StatelessWidget {
  const StockView({
    super.key,
    required this.stock,
    required this.revision,
    required this.onAdvance,
    required this.onRestore,
    required this.onDropFromStock,
    this.highlightedCardId,
  });

  final StockState stock;
  final int revision;
  final VoidCallback onAdvance;
  final VoidCallback onRestore;
  final void Function(DragPayload payload) onDropFromStock;
  final String? highlightedCardId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pile / controls
        _buildPileArea(),
        const SizedBox(width: 12),
        // Visible fan (up to 3)
        ..._buildVisibleCards(),
      ],
    );
  }

  Widget _buildPileArea() {
    if (stock.canRestore) {
      return GestureDetector(
        onTap: onRestore,
        child: Semantics(
          label: 'استعادة الورق',
          button: true,
          child: Container(
            width: 72,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFFFD700),
                width: 1.5,
              ),
              color: const Color(0xFF1A3060),
            ),
            child: const Center(
              child: Icon(Icons.refresh, color: Color(0xFFFFD700), size: 24),
            ),
          ),
        ),
      );
    }

    if (stock.canAdvance) {
      return GestureDetector(
        onTap: onAdvance,
        child: Semantics(
          label: 'سحب ورقة',
          button: true,
          child: Container(
            width: 72,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF3A5A8C),
                width: 1.5,
              ),
              color: const Color(0xFF1A3060),
            ),
            child: const Center(
              child: Icon(Icons.arrow_forward, color: Colors.white70, size: 24),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 72,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF3A5A8C).withAlpha((255 * 0.4).round()),
          width: 1,
        ),
      ),
    );
  }

  List<Widget> _buildVisibleCards() {
    final visible = stock.visibleCards;
    if (visible.isEmpty) return [];

    return visible.asMap().entries.map((entry) {
      final i = entry.key;
      final card = entry.value;
      final isPlayable = i == visible.length - 1;
      final highlighted = highlightedCardId == card.id;

      if (!isPlayable) {
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: SizedBox(
            width: 72,
            child: Opacity(
              opacity: 0.6,
              child: GameCardView(card: card, isSmall: true),
            ),
          ),
        );
      }

      final payload = DragPayload(
        sourceType: DragSourceType.stock,
        sourceIndex: 0,
        revision: revision,
      );

      return Semantics(
        label: 'ورقة من المخزون',
        child: Draggable<DragPayload>(
          data: payload,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 72,
              child: GameCardView(card: card, highlighted: true),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: SizedBox(
              width: 72,
              child: GameCardView(card: card, highlighted: highlighted),
            ),
          ),
          child: SizedBox(
            width: 72,
            child: GameCardView(card: card, highlighted: highlighted),
          ),
        ),
      );
    }).toList();
  }
}
