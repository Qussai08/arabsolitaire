// Tests for Sprint 5: Offline Product Loop — Journey, Story, and Content Validation
//
// Covers:
//   PL-001: New player journey (progression unlocking)
//   PL-003: Chapter story milestones
//   Journey tests: level unlock rules
//   Story tests: beat triggers, skip, archive ordering
//   Content validation tests: duplicate IDs, missing level 1, etc.

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/app_database.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/data/drift_journey_repository.dart';
import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/data/journey_content_validator.dart';
import 'package:mobile/features/journey/data/journey_providers.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

AppDatabase _openTestDb() => AppDatabase(NativeDatabase.memory());

List<Override> _buildOverrides(AppDatabase db) => [
      appDatabaseProvider.overrideWith((_) async => db),
      journeyRepositoryProvider
          .overrideWithValue(DriftJourneyRepository(db)),
    ];

Future<JourneyReady> _awaitReady(ProviderContainer c) async {
  for (int i = 0; i < 200; i++) {
    final s = c.read(journeyControllerProvider);
    if (s is JourneyReady) return s;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  throw StateError('JourneyReady not reached within 10s');
}

// ── Content Validation Tests ─────────────────────────────────────────────────

void main() {
  group('ContentValidation', () {
    test('bundled content passes validation', () {
      expect(
        () => JourneyContentValidator.validate(
          chapters: JourneyContent.chapters,
          levels: JourneyContent.buildLevels(),
        ),
        returnsNormally,
      );
    });

    test('5 chapters defined', () {
      expect(JourneyContent.chapters, hasLength(5));
    });

    test('250 levels defined', () {
      expect(JourneyContent.buildLevels(), hasLength(250));
    });

    test('exactly one Level 1', () {
      final levels = JourneyContent.buildLevels();
      expect(levels.where((l) => l.globalLevelNumber == 1), hasLength(1));
    });

    test('no duplicate level IDs', () {
      final levels = JourneyContent.buildLevels();
      final ids = levels.map((l) => l.levelDefinitionId).toSet();
      expect(ids.length, equals(levels.length));
    });

    test('no duplicate global numbers', () {
      final levels = JourneyContent.buildLevels();
      final nums = levels.map((l) => l.globalLevelNumber).toSet();
      expect(nums.length, equals(levels.length));
    });

    test('validates chapter IDs are stable', () {
      final ids =
          JourneyContent.chapters.map((c) => c.chapterId).toSet();
      expect(ids, containsAll([
        'chapter_cairo',
        'chapter_alexandria',
        'chapter_beirut',
        'chapter_marrakech',
        'chapter_dubai',
      ]));
    });

    test('rejects duplicate chapter IDs', () {
      const dup = ChapterDefinition(
        chapterId: 'chapter_cairo',
        order: 6,
        titleAr: 'test',
        subtitleAr: 'test',
        locationKey: 'test',
        levelStart: 251,
        levelEnd: 300,
      );
      expect(
        () => JourneyContentValidator.validate(
          chapters: [...JourneyContent.chapters, dup],
          levels: JourneyContent.buildLevels(),
        ),
        throwsA(isA<ContentValidationException>()),
      );
    });

    test('rejects duplicate level IDs', () {
      final levels = JourneyContent.buildLevels();
      final dup = LevelDefinition(
        levelDefinitionId: levels.first.levelDefinitionId,
        globalLevelNumber: 999,
        chapterId: 'chapter_cairo',
        chapterLevelNumber: 99,
        waveIndex: 1,
        wavePosition: 1,
        semanticDifficultyTier: 1,
      );
      expect(
        () => JourneyContentValidator.validate(
          chapters: JourneyContent.chapters,
          levels: [...levels, dup],
        ),
        throwsA(isA<ContentValidationException>()),
      );
    });

    test('rejects if no Level 1', () {
      final levels =
          JourneyContent.buildLevels().where((l) => l.globalLevelNumber != 1).toList();
      expect(
        () => JourneyContentValidator.validate(
          chapters: JourneyContent.chapters,
          levels: levels,
        ),
        throwsA(isA<ContentValidationException>()),
      );
    });
  });

  // ── Journey Progress Tests ──────────────────────────────────────────────────

  group('JourneyProgress domain', () {
    test('Level 1 initially unlocked', () {
      const p = JourneyProgress();
      final levels = JourneyContent.buildLevels();
      final level1 = levels.firstWhere((l) => l.globalLevelNumber == 1);
      expect(p.isLevelUnlocked(level1.levelDefinitionId, 1), isTrue);
    });

    test('Level 2 locked before Level 1 complete', () {
      const p = JourneyProgress();
      final levels = JourneyContent.buildLevels();
      final level2 = levels.firstWhere((l) => l.globalLevelNumber == 2);
      expect(p.isLevelUnlocked(level2.levelDefinitionId, 2), isFalse);
    });

    test('completing Level 1 unlocks Level 2', () {
      const p = JourneyProgress();
      final levels = JourneyContent.buildLevels();
      final level1 = levels.firstWhere((l) => l.globalLevelNumber == 1);
      final level2 = levels.firstWhere((l) => l.globalLevelNumber == 2);
      final updated = p.afterLevelCompleted(
        levelId: level1.levelDefinitionId,
        globalNumber: 1,
        nextLevelId: level2.levelDefinitionId,
      );
      expect(updated.isLevelUnlocked(level2.levelDefinitionId, 2), isTrue);
    });

    test('completing Level 1 marks it completed', () {
      const p = JourneyProgress();
      final levels = JourneyContent.buildLevels();
      final level1 = levels.firstWhere((l) => l.globalLevelNumber == 1);
      final updated = p.afterLevelCompleted(
        levelId: level1.levelDefinitionId,
        globalNumber: 1,
        nextLevelId: null,
      );
      expect(updated.isLevelCompleted(level1.levelDefinitionId), isTrue);
    });

    test('completing Level 50 marks chapter complete', () {
      // Build a progress with all 50 Cairo levels complete
      var p = const JourneyProgress();
      final levels = JourneyContent.buildLevels()
          .where((l) => l.chapterId == 'chapter_cairo')
          .toList()
        ..sort((a, b) => a.globalLevelNumber.compareTo(b.globalLevelNumber));

      for (int i = 0; i < levels.length - 1; i++) {
        p = p.afterLevelCompleted(
          levelId: levels[i].levelDefinitionId,
          globalNumber: levels[i].globalLevelNumber,
          nextLevelId: levels[i + 1].levelDefinitionId,
        );
      }
      final last = levels.last;
      p = p.afterLevelCompleted(
        levelId: last.levelDefinitionId,
        globalNumber: last.globalLevelNumber,
        nextLevelId: null,
      );
      p = p.afterChapterCompleted('chapter_cairo');
      expect(p.isChapterCompleted('chapter_cairo'), isTrue);
    });

    test('idempotent: re-completing a level does not double-add', () {
      const p = JourneyProgress();
      final levels = JourneyContent.buildLevels();
      final level1 = levels.firstWhere((l) => l.globalLevelNumber == 1);
      final p1 = p.afterLevelCompleted(
          levelId: level1.levelDefinitionId,
          globalNumber: 1,
          nextLevelId: null);
      final p2 = p1.afterLevelCompleted(
          levelId: level1.levelDefinitionId,
          globalNumber: 1,
          nextLevelId: null);
      expect(p2.completedLevelIds.length, equals(1));
    });
  });

  // ── JourneyController + persistence ─────────────────────────────────────────

  group('JourneyController persistence', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = _openTestDb();
      container = ProviderContainer(overrides: [
        ..._buildOverrides(db),
        journeyControllerProvider.overrideWith(JourneyController.new),
      ]);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('loads default state on fresh db', () async {
      final s = await _awaitReady(container);
      expect(s.progress.highestUnlockedLevel, equals(1));
      expect(s.progress.completedLevelIds, isEmpty);
    });

    test('recordLevelCompleted persists across reload', () async {
      await _awaitReady(container);
      final levels = JourneyContent.buildLevels();
      final level1 = levels.firstWhere((l) => l.globalLevelNumber == 1);

      await container
          .read(journeyControllerProvider.notifier)
          .recordLevelCompleted(
            levelId: level1.levelDefinitionId,
            globalNumber: 1,
          );

      // Create a new container against the SAME db
      final container2 = ProviderContainer(overrides: [
        ..._buildOverrides(db),
        journeyControllerProvider.overrideWith(JourneyController.new),
      ]);
      addTearDown(container2.dispose);

      final s2 = await _awaitReady(container2);
      expect(s2.progress.isLevelCompleted(level1.levelDefinitionId), isTrue);
    });

    test('tutorial completion persists', () async {
      await _awaitReady(container);
      await container
          .read(journeyControllerProvider.notifier)
          .completeTutorial();

      final container2 = ProviderContainer(overrides: [
        ..._buildOverrides(db),
        journeyControllerProvider.overrideWith(JourneyController.new),
      ]);
      addTearDown(container2.dispose);

      final s = await _awaitReady(container2);
      expect(s.flags.tutorialCompleted, isTrue);
    });
  });

  // ── Story beat tests ─────────────────────────────────────────────────────────

  group('Story beats', () {
    test('each chapter has start/midpoint/ending beats', () {
      for (final chapter in JourneyContent.chapters) {
        final beats = JourneyContent.storyBeats
            .where((b) => b.chapterId == chapter.chapterId)
            .toList();
        final types = beats.map((b) => b.type).toSet();
        expect(
          types,
          containsAll([StoryBeatType.start, StoryBeatType.midpoint, StoryBeatType.ending]),
          reason: 'Chapter ${chapter.chapterId} missing beat types',
        );
      }
    });

    test('story beats have correct trigger levels', () {
      for (final chapter in JourneyContent.chapters) {
        final start = JourneyContent.storyBeats.firstWhere(
          (b) => b.chapterId == chapter.chapterId && b.type == StoryBeatType.start,
        );
        final mid = JourneyContent.storyBeats.firstWhere(
          (b) =>
              b.chapterId == chapter.chapterId &&
              b.type == StoryBeatType.midpoint,
        );
        final end = JourneyContent.storyBeats.firstWhere(
          (b) =>
              b.chapterId == chapter.chapterId && b.type == StoryBeatType.ending,
        );
        expect(start.triggerLevelNumber, equals(chapter.levelStart));
        expect(mid.triggerLevelNumber,
            equals(chapter.levelStart + 24)); // level 25 within chapter
        expect(end.triggerLevelNumber, equals(chapter.levelEnd));
      }
    });

    test('unlocking story beat persists and does not replay on next check',
        () async {
      final db = _openTestDb();
      final container = ProviderContainer(overrides: [
        ..._buildOverrides(db),
        journeyControllerProvider.overrideWith(JourneyController.new),
      ]);
      addTearDown(() async {
        container.dispose();
        await db.close();
      });

      await _awaitReady(container);
      const beatId = 'chapter_cairo_start';
      await container
          .read(journeyControllerProvider.notifier)
          .unlockStoryBeat(beatId);
      await container
          .read(journeyControllerProvider.notifier)
          .markStoryBeatViewed(beatId);

      final s = container.read(journeyControllerProvider) as JourneyReady;
      expect(s.flags.unlockedStoryBeatIds, contains(beatId));
      expect(s.flags.viewedStoryBeatIds, contains(beatId));
      // pendingBeatsFor level 1 should now be empty
      final pending = s.pendingBeatsFor(1);
      expect(pending, isEmpty);
    });

    test('skip marks beat as unlocked and viewed', () async {
      final db = _openTestDb();
      final container = ProviderContainer(overrides: [
        ..._buildOverrides(db),
        journeyControllerProvider.overrideWith(JourneyController.new),
      ]);
      addTearDown(() async {
        container.dispose();
        await db.close();
      });

      await _awaitReady(container);
      const beatId = 'chapter_cairo_start';
      // Simulate skip = unlock + mark viewed
      await container
          .read(journeyControllerProvider.notifier)
          .unlockStoryBeat(beatId);
      await container
          .read(journeyControllerProvider.notifier)
          .markStoryBeatViewed(beatId);

      final s = container.read(journeyControllerProvider) as JourneyReady;
      expect(s.flags.unlockedStoryBeatIds, contains(beatId));
      expect(s.flags.viewedStoryBeatIds, contains(beatId));
    });

    test('story archive ordering: start < midpoint < ending', () {
      for (final chapter in JourneyContent.chapters) {
        final beats = JourneyContent.storyBeats
            .where((b) => b.chapterId == chapter.chapterId)
            .toList()
          ..sort((a, b) => a.triggerLevelNumber.compareTo(b.triggerLevelNumber));
        expect(beats[0].type, StoryBeatType.start);
        expect(beats[1].type, StoryBeatType.midpoint);
        expect(beats[2].type, StoryBeatType.ending);
      }
    });
  });

  // ── Reward formula test ─────────────────────────────────────────────────────

  group('Reward formula', () {
    test('base 50 + 2*moves + streak', () {
      const r = WinRewardPreview(remainingMoves: 10, earnedStreakCoins: 5);
      expect(r.total, equals(50 + 20 + 5));
    });

    test('zero remaining moves', () {
      const r = WinRewardPreview(remainingMoves: 0, earnedStreakCoins: 0);
      expect(r.total, equals(50));
    });
  });
}
