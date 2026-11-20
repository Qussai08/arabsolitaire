import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/design_system/design_system.dart';

/// Arabic face text. Content reference wins; generated boards store the
/// word on [GameCard.id].
String cardFaceLabel(GameCard card) {
  final reference = card.contentRefId;
  if (reference != null && reference.trim().isNotEmpty) {
    return reference;
  }
  return card.id;
}

String cardCountLabel(int count) {
  final digits = ArabicDigits.format(count);
  return count == 1 ? '$digits كلمة' : '$digits كلمات';
}

/// Mosaic face for one engine card. Size stays 72×96.
class GameCardView extends StatelessWidget {
  const GameCardView({
    super.key,
    required this.card,
    this.highlighted = false,
    this.validTarget = false,
    this.invalid = false,
    this.countLabel,
    this.isSmall = false,
  });

  final GameCard card;
  final bool highlighted;
  final bool validTarget;
  final bool invalid;
  final String? countLabel;

  /// Kept so existing call sites compile. Mosaic cards do not scale down.
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final state = invalid
        ? MosaicCardState.invalid
        : validTarget
        ? MosaicCardState.validTarget
        : highlighted
        ? MosaicCardState.selected
        : card is AssociationCard
        ? MosaicCardState.clue
        : MosaicCardState.word;
    final label = cardFaceLabel(card);
    return MosaicCard(
      state: state,
      word: card is AssociationCard ? null : label,
      clue: card is AssociationCard ? label : null,
      countLabel: card is AssociationCard ? countLabel : null,
    );
  }
}

/// Face-down Mosaic card.
class FaceDownCardView extends StatelessWidget {
  const FaceDownCardView({super.key, this.isSmall = false});

  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return const MosaicCard(state: MosaicCardState.faceDown);
  }
}
