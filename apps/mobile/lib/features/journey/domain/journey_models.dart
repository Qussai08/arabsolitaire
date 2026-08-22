/// Domain models for the Journey layer.
///
/// These are pure Dart — no Flutter, Firebase, or Drift dependencies.
library;

enum ChapterState { locked, unlocked, inProgress, completed }

enum LevelStatus { locked, unlocked, inProgress, completed }

enum StoryBeatType { start, midpoint, ending }

// ── Chapter ───────────────────────────────────────────────────────────────

final class ChapterDefinition {
  const ChapterDefinition({
    required this.chapterId,
    required this.order,
    required this.titleAr,
    required this.subtitleAr,
    required this.locationKey,
    required this.levelStart,
    required this.levelEnd,
  });

  final String chapterId;
  final int order;
  final String titleAr;
  final String subtitleAr;
  final String locationKey;
  final int levelStart; // global level number
  final int levelEnd;
}

// ── Level ─────────────────────────────────────────────────────────────────

final class LevelDefinition {
  const LevelDefinition({
    required this.levelDefinitionId,
    required this.globalLevelNumber,
    required this.chapterId,
    required this.chapterLevelNumber,
    required this.waveIndex,
    required this.wavePosition,
    required this.semanticDifficultyTier,
    this.storyMilestone,
    this.enabled = true,
  });

  final String levelDefinitionId;
  final int globalLevelNumber;
  final String chapterId;
  final int chapterLevelNumber; // 1-50 within chapter
  final int waveIndex;          // 1-5 within chapter
  final int wavePosition;       // 1-10 within wave
  final int semanticDifficultyTier; // 1-5
  final String? storyMilestone; // storyBeatId if applicable
  final bool enabled;
}

// ── Journey Progress ──────────────────────────────────────────────────────

final class JourneyProgress {
  const JourneyProgress({
    this.highestUnlockedLevel = 1,
    this.highestCompletedLevel = 0,
    this.currentLevelId,
    this.completedLevelIds = const {},
    this.completedChapterIds = const {},
    this.progressionSchemaVersion = 1,
  });

  final int highestUnlockedLevel;
  final int highestCompletedLevel;
  final String? currentLevelId;
  final Set<String> completedLevelIds;
  final Set<String> completedChapterIds;
  final int progressionSchemaVersion;

  bool isLevelUnlocked(String levelId, int globalNumber) =>
      globalNumber <= highestUnlockedLevel ||
      completedLevelIds.contains(levelId);

  bool isLevelCompleted(String levelId) => completedLevelIds.contains(levelId);

  bool isChapterCompleted(String chapterId) =>
      completedChapterIds.contains(chapterId);

  JourneyProgress afterLevelCompleted({
    required String levelId,
    required int globalNumber,
    required String? nextLevelId,
  }) {
    final newCompleted = {...completedLevelIds, levelId};
    return JourneyProgress(
      highestUnlockedLevel: globalNumber + 1 > highestUnlockedLevel
          ? globalNumber + 1
          : highestUnlockedLevel,
      highestCompletedLevel: globalNumber > highestCompletedLevel
          ? globalNumber
          : highestCompletedLevel,
      currentLevelId: nextLevelId,
      completedLevelIds: newCompleted,
      completedChapterIds: completedChapterIds,
      progressionSchemaVersion: progressionSchemaVersion,
    );
  }

  JourneyProgress afterChapterCompleted(String chapterId) => JourneyProgress(
        highestUnlockedLevel: highestUnlockedLevel,
        highestCompletedLevel: highestCompletedLevel,
        currentLevelId: currentLevelId,
        completedLevelIds: completedLevelIds,
        completedChapterIds: {...completedChapterIds, chapterId},
        progressionSchemaVersion: progressionSchemaVersion,
      );
}

// ── Player Flags ──────────────────────────────────────────────────────────

final class PlayerLocalFlags {
  const PlayerLocalFlags({
    this.isFirstLaunch = true,
    this.onboardingCompleted = false,
    this.tutorialCompleted = false,
    this.unlockedStoryBeatIds = const {},
    this.viewedStoryBeatIds = const {},
  });

  final bool isFirstLaunch;
  final bool onboardingCompleted;
  final bool tutorialCompleted;
  final Set<String> unlockedStoryBeatIds;
  final Set<String> viewedStoryBeatIds;

  PlayerLocalFlags copyWith({
    bool? isFirstLaunch,
    bool? onboardingCompleted,
    bool? tutorialCompleted,
    Set<String>? unlockedStoryBeatIds,
    Set<String>? viewedStoryBeatIds,
  }) =>
      PlayerLocalFlags(
        isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
        unlockedStoryBeatIds: unlockedStoryBeatIds ?? this.unlockedStoryBeatIds,
        viewedStoryBeatIds: viewedStoryBeatIds ?? this.viewedStoryBeatIds,
      );
}

// ── Story Beat ────────────────────────────────────────────────────────────

final class DialogueLine {
  const DialogueLine({
    required this.speakerKey,
    required this.textAr,
    this.textEn,
  });

  final String speakerKey;
  final String textAr;
  final String? textEn;
}

final class StoryBeat {
  const StoryBeat({
    required this.storyBeatId,
    required this.chapterId,
    required this.type,
    required this.triggerLevelNumber,
    required this.dialogue,
    this.backgroundKey,
    this.skippable = true,
  });

  final String storyBeatId;
  final String chapterId;
  final StoryBeatType type;
  final int triggerLevelNumber;
  final List<DialogueLine> dialogue;
  final String? backgroundKey;
  final bool skippable;
}
