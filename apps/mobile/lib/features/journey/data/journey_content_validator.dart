import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

/// Validates the bundled journey content structure at startup.
///
/// Throws [ContentValidationException] if any rule is violated.
abstract final class JourneyContentValidator {
  static void validate({
    required List<ChapterDefinition> chapters,
    required List<LevelDefinition> levels,
  }) {
    _validateChapters(chapters);
    _validateLevels(chapters, levels);
    _validateStoryBeats(chapters);
  }

  static void _validateChapters(List<ChapterDefinition> chapters) {
    if (chapters.isEmpty) {
      throw const ContentValidationException('No chapters defined');
    }
    final ids = <String>{};
    for (final c in chapters) {
      if (!ids.add(c.chapterId)) {
        throw ContentValidationException(
          'Duplicate chapter ID: ${c.chapterId}',
        );
      }
      if (c.levelEnd < c.levelStart) {
        throw ContentValidationException(
          'Chapter ${c.chapterId}: levelEnd < levelStart',
        );
      }
    }
    // Chapters must be sorted and contiguous
    final sorted = [...chapters]..sort((a, b) => a.order.compareTo(b.order));
    for (int i = 0; i < sorted.length; i++) {
      if (sorted[i].order != i + 1) {
        throw ContentValidationException(
          'Chapter order gap at position ${i + 1}',
        );
      }
    }
  }

  static void _validateLevels(
    List<ChapterDefinition> chapters,
    List<LevelDefinition> levels,
  ) {
    if (levels.isEmpty) {
      throw const ContentValidationException('No levels defined');
    }
    final chapterIds = chapters.map((c) => c.chapterId).toSet();
    final levelIds = <String>{};
    final globalNumbers = <int>{};
    bool hasLevel1 = false;

    for (final l in levels) {
      if (!levelIds.add(l.levelDefinitionId)) {
        throw ContentValidationException(
          'Duplicate level ID: ${l.levelDefinitionId}',
        );
      }
      if (!globalNumbers.add(l.globalLevelNumber)) {
        throw ContentValidationException(
          'Duplicate global level number: ${l.globalLevelNumber}',
        );
      }
      if (!chapterIds.contains(l.chapterId)) {
        throw ContentValidationException(
          'Level ${l.levelDefinitionId} references unknown chapter: ${l.chapterId}',
        );
      }
      if (l.globalLevelNumber == 1) hasLevel1 = true;
    }

    if (!hasLevel1) {
      throw const ContentValidationException('No Level 1 defined');
    }

    // Global numbers must be contiguous starting from 1
    final maxNumber = levels
        .map((l) => l.globalLevelNumber)
        .reduce((a, b) => a > b ? a : b);
    if (maxNumber != levels.length) {
      throw ContentValidationException(
        'Global level numbers must be 1..${levels.length}, max was $maxNumber',
      );
    }
  }

  static void _validateStoryBeats(List<ChapterDefinition> chapters) {
    final chapterIds = chapters.map((c) => c.chapterId).toSet();
    final ids = <String>{};
    for (final b in JourneyContent.storyBeats) {
      if (!ids.add(b.storyBeatId)) {
        throw ContentValidationException(
          'Duplicate story beat ID: ${b.storyBeatId}',
        );
      }
      if (!chapterIds.contains(b.chapterId)) {
        throw ContentValidationException(
          'Story beat ${b.storyBeatId} references unknown chapter: ${b.chapterId}',
        );
      }
    }
  }
}

final class ContentValidationException implements Exception {
  const ContentValidationException(this.message);
  final String message;

  @override
  String toString() => 'ContentValidationException: $message';
}
