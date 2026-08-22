import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class JourneyViewState {
  const JourneyViewState();
}

final class JourneyLoading extends JourneyViewState {
  const JourneyLoading();
}

final class JourneyReady extends JourneyViewState {
  const JourneyReady({
    required this.chapters,
    required this.levels,
    required this.progress,
    required this.flags,
  });

  final List<ChapterDefinition> chapters;
  final List<LevelDefinition> levels;
  final JourneyProgress progress;
  final PlayerLocalFlags flags;

  ChapterState chapterState(ChapterDefinition chapter) {
    if (progress.isChapterCompleted(chapter.chapterId)) {
      return ChapterState.completed;
    }
    if (chapter.levelStart <= progress.highestUnlockedLevel) {
      return ChapterState.unlocked;
    }
    return ChapterState.locked;
  }

  LevelStatus levelStatus(LevelDefinition level) {
    if (progress.isLevelCompleted(level.levelDefinitionId)) {
      return LevelStatus.completed;
    }
    if (progress.isLevelUnlocked(
        level.levelDefinitionId, level.globalLevelNumber)) {
      if (progress.currentLevelId == level.levelDefinitionId) {
        return LevelStatus.inProgress;
      }
      return LevelStatus.unlocked;
    }
    return LevelStatus.locked;
  }

  /// Story beats triggered at [globalLevelNumber] that have not yet been seen.
  List<StoryBeat> pendingBeatsFor(int globalLevelNumber) {
    return JourneyContent.storyBeats
        .where((b) =>
            b.triggerLevelNumber == globalLevelNumber &&
            !flags.viewedStoryBeatIds.contains(b.storyBeatId))
        .toList();
  }
}

final class JourneyError extends JourneyViewState {
  const JourneyError(this.message);
  final String message;
}

// ── Tutorial state helper ─────────────────────────────────────────────────────

enum TutorialStep { notStarted, step1Move, step2Association, step3Undo, done }

extension JourneyReadyTutorial on JourneyReady {
  TutorialStep get tutorialStep {
    if (flags.tutorialCompleted) return TutorialStep.done;
    if (!flags.onboardingCompleted) return TutorialStep.notStarted;
    return TutorialStep.step1Move;
  }
}
