import 'package:game_engine/game_engine.dart';
import 'package:level_generator/src/model/association_variant.dart';
import 'package:level_generator/src/model/level_configuration.dart';

/// Result of building the exact card pool for a Level.
final class CardPool {
  const CardPool({
    required this.cards,
    required this.associations,
    required this.variants,
  });

  final List<GameCard> cards;
  final Map<AssociationId, AssociationDefinition> associations;
  final List<AssociationVariant> variants;

  int get size => cards.length;
}

abstract final class CardPoolBuilder {
  static CardPool build({
    required LevelConfiguration config,
    required List<AssociationVariant> variants,
  }) {
    final error = validateContent(config: config, variants: variants);
    if (error != null) {
      throw ArgumentError.value(variants, 'variants', error);
    }

    final cards = <GameCard>[];
    final associations = <AssociationId, AssociationDefinition>{};
    final seenCardIds = <CardId>{};
    final seenAssocIds = <AssociationId>{};

    for (final variant in variants) {
      if (!seenAssocIds.add(variant.associationId)) {
        throw ArgumentError('duplicate associationId: ${variant.associationId}');
      }
      associations[variant.associationId] = variant.toDefinition();
      for (final card in variant.toCards()) {
        if (!seenCardIds.add(card.id)) {
          throw ArgumentError('duplicate card id: ${card.id}');
        }
        cards.add(card);
      }
    }

    if (cards.length != config.totalCardCount) {
      throw StateError(
        'pool size ${cards.length} != config ${config.totalCardCount}',
      );
    }

    return CardPool(
      cards: List.unmodifiable(cards),
      associations: Map.unmodifiable(associations),
      variants: List.unmodifiable(variants),
    );
  }

  static String? validateContent({
    required LevelConfiguration config,
    required List<AssociationVariant> variants,
  }) {
    if (variants.length != config.associationCount) {
      return 'variant count ${variants.length} != '
          'associationCount ${config.associationCount}';
    }
    for (var i = 0; i < variants.length; i++) {
      final v = variants[i];
      if (v.memberCount != config.groupSizeProfile[i]) {
        return 'variant[$i] members ${v.memberCount} != '
            'profile ${config.groupSizeProfile[i]}';
      }
      if (v.memberCardIds.toSet().length != v.memberCardIds.length) {
        return 'variant[$i] has duplicate member ids';
      }
      if (v.memberCardIds.contains(v.associationCardId)) {
        return 'variant[$i] association card id collides with member';
      }
    }

    if (config.maxVisualAssociations != null) {
      final visual = variants
          .where((v) => v.contentType.toLowerCase() == 'visual')
          .length;
      if (visual > config.maxVisualAssociations!) {
        return 'too many visual associations: $visual > '
            '${config.maxVisualAssociations}';
      }
    }

    final variantIds = variants.map((v) => v.id).toSet();
    if (variantIds.length != variants.length) {
      return 'duplicate association variant within level';
    }

    return null;
  }
}
