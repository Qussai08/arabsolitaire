import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobile/core/storage/app_database.dart' as db_lib;
import 'package:mobile/features/journey/data/journey_repository.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

final class DriftJourneyRepository implements JourneyRepository {
  DriftJourneyRepository(this._db);
  final db_lib.AppDatabase _db;
  static const _mainId = 'main';

  // ── JourneyProgress ─────────────────────────────────────────────────────────

  @override
  Future<JourneyProgress> loadProgress() async {
    final row = await (_db.select(
      _db.journeyProgressRows,
    )..where((t) => t.id.equals(_mainId))).getSingleOrNull();
    if (row == null) return const JourneyProgress();
    final completedLevels = (jsonDecode(row.completedLevelIdsJson) as List)
        .cast<String>()
        .toSet();
    final completedChapters = (jsonDecode(row.completedChapterIdsJson) as List)
        .cast<String>()
        .toSet();
    return JourneyProgress(
      highestUnlockedLevel: row.highestUnlockedLevel,
      highestCompletedLevel: row.highestCompletedLevel,
      currentLevelId: row.currentLevelId,
      completedLevelIds: completedLevels,
      completedChapterIds: completedChapters,
    );
  }

  @override
  Future<void> saveProgress(JourneyProgress progress) async {
    await _db
        .into(_db.journeyProgressRows)
        .insertOnConflictUpdate(
          db_lib.JourneyProgressRowsCompanion(
            id: const Value(_mainId),
            highestUnlockedLevel: Value(progress.highestUnlockedLevel),
            highestCompletedLevel: Value(progress.highestCompletedLevel),
            currentLevelId: Value(progress.currentLevelId),
            completedLevelIdsJson: Value(
              jsonEncode(progress.completedLevelIds.toList()),
            ),
            completedChapterIdsJson: Value(
              jsonEncode(progress.completedChapterIds.toList()),
            ),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  // ── PlayerLocalFlags ─────────────────────────────────────────────────────────

  @override
  Future<PlayerLocalFlags> loadFlags() async {
    final row = await (_db.select(
      _db.playerFlagRows,
    )..where((t) => t.id.equals(_mainId))).getSingleOrNull();
    if (row == null) return const PlayerLocalFlags();
    final unlockedBeats = (jsonDecode(row.unlockedStoryBeatIdsJson) as List)
        .cast<String>()
        .toSet();
    final viewedBeats = (jsonDecode(row.viewedStoryBeatIdsJson) as List)
        .cast<String>()
        .toSet();
    return PlayerLocalFlags(
      isFirstLaunch: row.isFirstLaunch,
      onboardingCompleted: row.onboardingCompleted,
      tutorialCompleted: row.tutorialCompleted,
      unlockedStoryBeatIds: unlockedBeats,
      viewedStoryBeatIds: viewedBeats,
    );
  }

  @override
  Future<void> saveFlags(PlayerLocalFlags flags) async {
    await _db
        .into(_db.playerFlagRows)
        .insertOnConflictUpdate(
          db_lib.PlayerFlagRowsCompanion(
            id: const Value(_mainId),
            isFirstLaunch: Value(flags.isFirstLaunch),
            onboardingCompleted: Value(flags.onboardingCompleted),
            tutorialCompleted: Value(flags.tutorialCompleted),
            unlockedStoryBeatIdsJson: Value(
              jsonEncode(flags.unlockedStoryBeatIds.toList()),
            ),
            viewedStoryBeatIdsJson: Value(
              jsonEncode(flags.viewedStoryBeatIds.toList()),
            ),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
  }
}
