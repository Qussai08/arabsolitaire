import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_engine/game_engine.dart';
import 'package:level_generator/level_generator.dart';
import 'package:mobile/features/content/domain/content_bundle.dart';
import 'package:mobile/features/gameplay/data/level_content_factory.dart';
import 'package:mobile/features/journey/data/journey_content.dart';

void main() {
  late List<AssociationVariantDto> pool;

  setUpAll(() {
    final file = File('assets/content/bundle/associations.json');
    final raw = json.decode(file.readAsStringSync()) as List<dynamic>;
    pool = raw
        .map((e) => AssociationVariantDto.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  test('launch pool has enough associations for Arc 1', () {
    expect(pool.length, greaterThanOrEqualTo(80));
    expect(pool.every((a) => a.isApproved), isTrue);
  });

  test(
    'ApprovedPoolContentSelector generates early Cairo board',
    () {
      final level = JourneyContent.buildLevels().first;
      final config = levelConfigurationFor(level);
      final selector = ApprovedPoolContentSelector(
        pool: pool,
        chapterId: level.chapterId,
        semanticTier: level.semanticDifficultyTier,
      );

      final result = LevelGenerator().generate(
        config: config,
        contentSelector: selector,
        baseSeed: const GenerationSeed(42),
      );

      expect(result, isA<GenerationSucceeded>());
      final generated = (result as GenerationSucceeded).level;
      expect(generated.initialGameState.associations.length, 3);

      final assocCards = generated.initialGameState.allCardsOnBoard
          .whereType<AssociationCard>()
          .toList();

      expect(assocCards, isNotEmpty);
      expect(
        assocCards.any((c) => RegExp(r'[\u0600-\u06FF]').hasMatch(c.id)),
        isTrue,
        reason: 'Association cards should display Arabic clues',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test('level configs cover all 5 chapter waves', () {
    final levels = JourneyContent.buildLevels();
    expect(levels.length, 250);
    for (final level in [levels.first, levels[49], levels[100], levels[200]]) {
      final config = levelConfigurationFor(level);
      expect(config.validate(), isNull);
      expect(config.associationCount, greaterThanOrEqualTo(3));
    }
  });
}
