import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';

/// Visual representation of a single game card.
class GameCardView extends StatelessWidget {
  const GameCardView({
    super.key,
    required this.card,
    this.highlighted = false,
    this.isSmall = false,
  });

  final GameCard card;
  final bool highlighted;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final isAssoc = card is AssociationCard;
    final baseColor = isAssoc ? const Color(0xFF1A4A7C) : Colors.white;
    final textColor = isAssoc ? Colors.white : const Color(0xFF1A2030);
    final border = highlighted
        ? Border.all(color: const Color(0xFFFFD700), width: 2.5)
        : Border.all(color: const Color(0xFFCCCCCC), width: 0.8);

    final fontSize = isSmall ? 10.0 : 13.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: double.infinity,
      height: isSmall ? 42 : 58,
      decoration: BoxDecoration(
        color: highlighted
            ? baseColor.withAlpha((255 * 0.85).round())
            : baseColor,
        borderRadius: BorderRadius.circular(6),
        border: border,
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: const Color(0xFFFFD700).withAlpha((255 * 0.6).round()),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Center(
          child: Text(
            card.id,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: isAssoc ? FontWeight.w700 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// Face-down card (hidden tableau card).
class FaceDownCardView extends StatelessWidget {
  const FaceDownCardView({super.key, this.isSmall = false});

  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isSmall ? 14 : 18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C4A7C), Color(0xFF1A3060)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF3A5A8C).withAlpha((255 * 0.8).round()),
          width: 0.7,
        ),
      ),
    );
  }
}
