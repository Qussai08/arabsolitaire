import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/journey/application/journey_state.dart';
import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/data/journey_providers.dart';
import 'package:mobile/features/journey/data/journey_repository.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

class JourneyController extends Notifier<JourneyViewState> {
  JourneyRepository get _repo => ref.read(journeyRepositoryProvider);

  @override
  JourneyViewState build() {
    Future.microtask(_load);
    return const JourneyLoading();
  }

  // ── Init ────────────────────────────────────────────────────────────────────

  Future<void> _load() async {
    try {
      final progress = await _repo.loadProgress();
      final flags = await _repo.loadFlags();
      state = JourneyReady(
        chapters: JourneyContent.chapters,
        levels: JourneyContent.buildLevels(),
        progress: progress,
        flags: flags,
      );
    } catch (e) {
      state = JourneyError(e.toString());
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  JourneyReady? get _ready =>
      state is JourneyReady ? state as JourneyReady : null;

  // ── Onboarding / Tutorial ───────────────────────────────────────────────────

  Future<void> completeOnboarding() async {
    final r = _ready;
    if (r == null) return;
    final newFlags = r.flags.copyWith(
      isFirstLaunch: false,
      onboardingCompleted: true,
    );
    await _repo.saveFlags(newFlags);
    state = JourneyReady(
      chapters: r.chapters,
      levels: r.levels,
      progress: r.progress,
      flags: newFlags,
    );
  }

  Future<void> completeTutorial() async {
    final r = _ready;
    if (r == null) return;
    final newFlags = r.flags.copyWith(tutorialCompleted: true);
    await _repo.saveFlags(newFlags);
    state = JourneyReady(
      chapters: r.chapters,
      levels: r.levels,
      progress: r.progress,
      flags: newFlags,
    );
  }

  // ── Story beats ──────────────────────────────────────────────────────────────

  Future<void> unlockStoryBeat(String storyBeatId) async {
    final r = _ready;
    if (r == null) return;
    if (r.flags.unlockedStoryBeatIds.contains(storyBeatId)) return;
    final newFlags = r.flags.copyWith(
      unlockedStoryBeatIds: {...r.flags.unlockedStoryBeatIds, storyBeatId},
    );
    await _repo.saveFlags(newFlags);
    state = JourneyReady(
      chapters: r.chapters,
      levels: r.levels,
      progress: r.progress,
      flags: newFlags,
    );
  }

  Future<void> markStoryBeatViewed(String storyBeatId) async {
    final r = _ready;
    if (r == null) return;
    if (r.flags.viewedStoryBeatIds.contains(storyBeatId)) return;
    final newFlags = r.flags.copyWith(
      viewedStoryBeatIds: {...r.flags.viewedStoryBeatIds, storyBeatId},
    );
    await _repo.saveFlags(newFlags);
    state = JourneyReady(
      chapters: r.chapters,
      levels: r.levels,
      progress: r.progress,
      flags: newFlags,
    );
  }

  // ── Progression ──────────────────────────────────────────────────────────────

  /// Called after the player successfully completes a level.
  Future<void> recordLevelCompleted({
    required String levelId,
    required int globalNumber,
  }) async {
    final r = _ready;
    if (r == null) return;

    final levels = r.levels;
    final currentIndex = levels.indexWhere(
      (l) => l.levelDefinitionId == levelId,
    );
    final nextLevelId = currentIndex >= 0 && currentIndex + 1 < levels.length
        ? levels[currentIndex + 1].levelDefinitionId
        : null;

    var newProgress = r.progress.afterLevelCompleted(
      levelId: levelId,
      globalNumber: globalNumber,
      nextLevelId: nextLevelId,
    );

    // Check if that completed an entire chapter
    final chapter = JourneyContent.chapters
        .cast<ChapterDefinition?>()
        .firstWhere(
          (c) =>
              c != null &&
              c.levelStart <= globalNumber &&
              c.levelEnd >= globalNumber,
          orElse: () => null,
        );
    if (chapter != null && !newProgress.isChapterCompleted(chapter.chapterId)) {
      final allChapterLevels = levels
          .where((l) => l.chapterId == chapter.chapterId)
          .map((l) => l.levelDefinitionId)
          .toSet();
      if (allChapterLevels.every(newProgress.completedLevelIds.contains)) {
        newProgress = newProgress.afterChapterCompleted(chapter.chapterId);
      }
    }

    // Unlock story beats that fire at this level
    var flags = r.flags;
    final beatsToUnlock = JourneyContent.storyBeats
        .where(
          (b) =>
              b.triggerLevelNumber == globalNumber &&
              !flags.unlockedStoryBeatIds.contains(b.storyBeatId),
        )
        .map((b) => b.storyBeatId)
        .toSet();
    if (beatsToUnlock.isNotEmpty) {
      flags = flags.copyWith(
        unlockedStoryBeatIds: {...flags.unlockedStoryBeatIds, ...beatsToUnlock},
      );
    }

    await _repo.saveProgress(newProgress);
    if (beatsToUnlock.isNotEmpty) await _repo.saveFlags(flags);

    state = JourneyReady(
      chapters: r.chapters,
      levels: r.levels,
      progress: newProgress,
      flags: flags,
    );
  }
}
