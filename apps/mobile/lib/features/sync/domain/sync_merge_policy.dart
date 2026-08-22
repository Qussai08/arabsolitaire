import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
import 'package:mobile/features/sync/domain/cloud_dtos.dart';

/// Domain-specific merge rules for progression sync.
///
/// All merge operations are pure functions with no Firebase dependencies.
abstract final class SyncMergePolicy {
  // ── Progression ─────────────────────────────────────────────────────────────

  /// Merges local and cloud progression.
  ///
  /// Rule: highest valid completed level wins.
  /// Derived unlocks are recalculated, not blindly copied.
  static JourneyProgress mergeProgression(
    JourneyProgress local,
    CloudProgressionDto? cloud,
  ) {
    if (cloud == null || !cloud.isSupported) return local;

    final cloudLevel = cloud.highestCompletedLevel;
    final localLevel = local.highestCompletedLevel;

    // Higher wins
    if (cloudLevel <= localLevel) return local;

    // Cloud is ahead — rebuild progression from canonical numbers
    return _buildProgressionFromLevel(
      highestCompleted: cloudLevel,
      currentLevelId: cloud.currentLevelId ?? local.currentLevelId,
      existingCompleted: local.completedLevelIds,
    );
  }

  /// Produces the local [CloudProgressionDto] for upload.
  static CloudProgressionDto localToCloudProgression(
    JourneyProgress p,
    int currentRevision,
  ) =>
      CloudProgressionDto(
        schemaVersion: CloudProgressionDto.currentSchema,
        contentVersion: 1,
        highestCompletedLevel: p.highestCompletedLevel,
        revision: currentRevision + 1,
        currentLevelId: p.currentLevelId,
      );

  // ── Story ───────────────────────────────────────────────────────────────────

  /// Rule: union of valid unlocked/viewed IDs.
  static PlayerLocalFlags mergeStory(
    PlayerLocalFlags local,
    CloudStoryDto? cloud,
  ) {
    if (cloud == null || !cloud.isSupported) return local;

    final validIds =
        JourneyContent.storyBeats.map((b) => b.storyBeatId).toSet();

    final mergedUnlocked = {
      ...local.unlockedStoryBeatIds,
      ...cloud.unlockedStoryBeatIds,
    }.intersection(validIds);

    final mergedViewed = {
      ...local.viewedStoryBeatIds,
      ...cloud.viewedStoryBeatIds,
    }.intersection(validIds);

    return local.copyWith(
      unlockedStoryBeatIds: mergedUnlocked,
      viewedStoryBeatIds: mergedViewed,
    );
  }

  /// Produces the local [CloudStoryDto] for upload.
  static CloudStoryDto localToCloudStory(
    PlayerLocalFlags flags,
    int currentRevision,
  ) =>
      CloudStoryDto(
        schemaVersion: CloudStoryDto.currentSchema,
        unlockedStoryBeatIds: flags.unlockedStoryBeatIds.toList(),
        viewedStoryBeatIds: flags.viewedStoryBeatIds.toList(),
        revision: currentRevision + 1,
      );

  // ── Tutorial / Onboarding ───────────────────────────────────────────────────

  /// Rule: monotonic — once true, stays true.
  static PlayerLocalFlags mergeOnboarding(
    PlayerLocalFlags local,
    bool? cloudOnboardingCompleted,
    bool? cloudTutorialCompleted,
  ) {
    final onboarding =
        local.onboardingCompleted || (cloudOnboardingCompleted ?? false);
    final tutorial =
        local.tutorialCompleted || (cloudTutorialCompleted ?? false);

    if (onboarding == local.onboardingCompleted &&
        tutorial == local.tutorialCompleted) {
      return local;
    }

    return local.copyWith(
      onboardingCompleted: onboarding,
      tutorialCompleted: tutorial,
    );
  }

  // ── Settings ─────────────────────────────────────────────────────────────────

  /// Rule: latest valid revision wins.
  static CloudSettingsDto? mergeSettings(
    CloudSettingsDto? local,
    CloudSettingsDto? cloud,
  ) {
    if (cloud == null) return local;
    if (local == null) return cloud.isSupported ? cloud : null;
    if (!cloud.isSupported) return local;
    // Higher revision wins
    return cloud.revision > local.revision ? cloud : local;
  }

  // ── Internal helpers ─────────────────────────────────────────────────────────

  static JourneyProgress _buildProgressionFromLevel({
    required int highestCompleted,
    required String? currentLevelId,
    required Set<String> existingCompleted,
  }) {
    final levels = JourneyContent.buildLevels();
    final validLevels =
        levels.where((l) => l.globalLevelNumber <= highestCompleted).toList();

    final completedIds = {
      ...existingCompleted,
      ...validLevels.map((l) => l.levelDefinitionId),
    };

    // Derive chapter completions
    final completedChapters = <String>{};
    for (final chapter in JourneyContent.chapters) {
      final chapterLevels = levels
          .where((l) => l.chapterId == chapter.chapterId)
          .map((l) => l.levelDefinitionId)
          .toSet();
      if (chapterLevels.every(completedIds.contains)) {
        completedChapters.add(chapter.chapterId);
      }
    }

    return JourneyProgress(
      highestCompletedLevel: highestCompleted,
      highestUnlockedLevel: highestCompleted + 1,
      currentLevelId: currentLevelId,
      completedLevelIds: completedIds,
      completedChapterIds: completedChapters,
    );
  }
}
