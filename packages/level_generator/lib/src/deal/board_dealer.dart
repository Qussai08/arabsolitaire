import 'package:game_engine/game_engine.dart';
import 'package:level_generator/src/content/card_pool_builder.dart';
import 'package:level_generator/src/model/level_configuration.dart';
import 'package:level_generator/src/random/generation_seed.dart';

/// One deal attempt before Solver / difficulty validation.
final class GeneratedCandidate {
  const GeneratedCandidate({
    required this.seed,
    required this.initialGameState,
    required this.contentIds,
    required this.generationAttemptIndex,
  });

  final GenerationSeed seed;
  final GameState initialGameState;
  final List<String> contentIds;
  final int generationAttemptIndex;
}

abstract final class BoardDealer {
  static GeneratedCandidate deal({
    required LevelConfiguration config,
    required CardPool pool,
    required GenerationSeed candidateSeed,
    required int generationAttemptIndex,
  }) {
    final random = candidateSeed.createRandom();
    final shuffled = seededShuffle(pool.cards, random);

    var offset = 0;
    final tableau = <TableauColumn>[];
    for (final size in config.tableauColumnSizes) {
      final columnCards = shuffled.sublist(offset, offset + size);
      offset += size;
      // Bottom → top: all but last are hidden; last is single exposed unit.
      final exposed = columnCards.last;
      final hidden = columnCards.sublist(0, columnCards.length - 1);
      tableau.add(
        TableauColumn(
          hiddenCards: List.unmodifiable(hidden),
          exposedUnit: MovableUnit.single(exposed),
        ),
      );
    }

    final stockCards = shuffled.sublist(offset);
    if (stockCards.length != config.stockCardCount) {
      throw StateError(
        'stock deal ${stockCards.length} != config ${config.stockCardCount}',
      );
    }

    final slots = [
      for (var i = 0; i < config.associationSlotCount; i++)
        AssociationSlot(index: i),
    ];

    final state = GameState(
      attemptId: 'gen_${candidateSeed.value}_$generationAttemptIndex',
      levelDefinitionId: config.levelDefinitionId,
      associations: pool.associations,
      tableau: tableau,
      stock: StockState(undealt: List.unmodifiable(stockCards)),
      slots: slots,
      moveLimit: config.moveLimit,
      movesRemaining: config.moveLimit,
      rulesVersion: config.rulesVersion,
    );

    return GeneratedCandidate(
      seed: candidateSeed,
      initialGameState: state,
      contentIds: [for (final v in pool.variants) v.id],
      generationAttemptIndex: generationAttemptIndex,
    );
  }
}
