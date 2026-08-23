import 'package:level_generator/level_generator.dart';
import 'package:mobile/features/content/domain/content_bundle.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

/// Maps Journey chapter ids (`chapter_cairo`) ↔ content bundle ids (`ch_cairo`).
String toContentChapterId(String journeyChapterId) {
  return switch (journeyChapterId) {
    'chapter_cairo' => 'ch_cairo',
    'chapter_alexandria' => 'ch_alexandria',
    'chapter_beirut' => 'ch_beirut',
    'chapter_marrakech' => 'ch_marrakech',
    'chapter_dubai' => 'ch_dubai',
    _ =>
      journeyChapterId.startsWith('ch_')
          ? journeyChapterId
          : journeyChapterId.replaceFirst('chapter_', 'ch_'),
  };
}

/// Builds a [LevelConfiguration] for a Journey level definition.
LevelConfiguration levelConfigurationFor(LevelDefinition level) {
  final wave = level.waveIndex; // 1–5 in JourneyContent; 0–4 in bundle levels
  final normalizedWave = wave <= 0 ? 1 : (wave > 5 ? 5 : wave);

  return switch (normalizedWave) {
    1 => LevelConfiguration(
      levelDefinitionId: level.levelDefinitionId,
      chapterId: toContentChapterId(level.chapterId),
      levelNumber: level.chapterLevelNumber,
      groupSizeProfile: const [3, 3, 3],
      tableauColumnSizes: const [3, 3, 3],
      stockCardCount: 3,
      associationSlotCount: 2,
      moveLimit: 55,
      difficultyTarget: DifficultyTarget.any,
      maxGenerationAttempts: 40,
    ),
    2 => LevelConfiguration(
      levelDefinitionId: level.levelDefinitionId,
      chapterId: toContentChapterId(level.chapterId),
      levelNumber: level.chapterLevelNumber,
      groupSizeProfile: const [3, 3, 3],
      tableauColumnSizes: const [3, 3, 3],
      stockCardCount: 3,
      associationSlotCount: 2,
      moveLimit: 45,
      difficultyTarget: DifficultyTarget.any,
      maxGenerationAttempts: 40,
    ),
    3 => LevelConfiguration(
      levelDefinitionId: level.levelDefinitionId,
      chapterId: toContentChapterId(level.chapterId),
      levelNumber: level.chapterLevelNumber,
      groupSizeProfile: const [3, 3, 4],
      tableauColumnSizes: const [3, 3, 3, 2],
      stockCardCount: 2,
      associationSlotCount: 2,
      moveLimit: 55,
      difficultyTarget: DifficultyTarget.any,
      maxGenerationAttempts: 50,
    ),
    4 => LevelConfiguration(
      levelDefinitionId: level.levelDefinitionId,
      chapterId: toContentChapterId(level.chapterId),
      levelNumber: level.chapterLevelNumber,
      groupSizeProfile: const [4, 4, 4],
      tableauColumnSizes: const [4, 4, 3],
      stockCardCount: 4,
      associationSlotCount: 2,
      moveLimit: 60,
      difficultyTarget: DifficultyTarget.any,
      maxGenerationAttempts: 50,
    ),
    _ => LevelConfiguration(
      levelDefinitionId: level.levelDefinitionId,
      chapterId: toContentChapterId(level.chapterId),
      levelNumber: level.chapterLevelNumber,
      groupSizeProfile: const [4, 4, 5],
      tableauColumnSizes: const [4, 4, 4],
      stockCardCount: 4,
      associationSlotCount: 2,
      moveLimit: 70,
      difficultyTarget: DifficultyTarget.any,
      maxGenerationAttempts: 60,
    ),
  };
}

/// Selects approved pool associations for a level generation attempt.
final class ApprovedPoolContentSelector implements ContentSelector {
  ApprovedPoolContentSelector({
    required this.pool,
    required this.chapterId,
    required this.semanticTier,
    this.cooldownLevels = 20,
    this.recentVariantIds = const [],
  });

  final List<AssociationVariantDto> pool;
  final String chapterId;
  final int semanticTier;
  final int cooldownLevels;
  final List<String> recentVariantIds;

  @override
  List<AssociationVariant> select({
    required LevelConfiguration config,
    required GenerationSeed seed,
  }) {
    final contentChapter = toContentChapterId(chapterId);
    final maxTier = semanticTier.clamp(1, 5);
    final cooldown = recentVariantIds.take(cooldownLevels).toSet();

    var eligible = pool.where((a) {
      if (a.status != 'published') return false;
      if (!a.isApproved) return false;
      if (!a.chapterEligibility.contains(contentChapter) &&
          !a.chapterEligibility.contains(chapterId)) {
        return false;
      }
      if (a.semanticDifficulty > maxTier + 1) return false;
      if (cooldown.contains(a.associationVariantId)) return false;
      return true;
    }).toList();

    if (eligible.isEmpty) {
      eligible = pool
          .where((a) => a.status == 'published' && a.isApproved)
          .toList();
    }

    final bySize = <int, List<AssociationVariantDto>>{};
    for (final a in eligible) {
      bySize.putIfAbsent(a.memberCards.length, () => []).add(a);
    }

    final random = seed.createRandom();
    final selected = <AssociationVariant>[];
    final usedVariantIds = <String>{};
    final usedMemberWords = <String>{};
    final usedClues = <String>{};

    for (final size in config.groupSizeProfile) {
      final candidates =
          List<AssociationVariantDto>.from(bySize[size] ?? const [])
            ..removeWhere(
              (a) =>
                  usedVariantIds.contains(a.associationVariantId) ||
                  usedClues.contains(a.associationClue) ||
                  a.memberCards.any(usedMemberWords.contains),
            );

      if (candidates.isEmpty) {
        // Fall back: any published variant of the right size.
        final fallback = pool
            .where(
              (a) =>
                  a.memberCards.length == size &&
                  a.status == 'published' &&
                  !usedVariantIds.contains(a.associationVariantId) &&
                  !a.memberCards.any(usedMemberWords.contains),
            )
            .toList();
        if (fallback.isEmpty) {
          throw StateError(
            'No association of size $size available for $contentChapter',
          );
        }
        candidates.addAll(fallback);
      }

      final shuffled = seededShuffle(candidates, random);
      final pick = shuffled.first;
      usedVariantIds.add(pick.associationVariantId);
      usedClues.add(pick.associationClue);
      usedMemberWords.addAll(pick.memberCards);
      selected.add(_toGeneratorVariant(pick));
    }

    return List.unmodifiable(selected);
  }
}

AssociationVariant _toGeneratorVariant(AssociationVariantDto dto) {
  // Card ids are Arabic display strings so GameCardView shows real content.
  // associationId remains a stable opaque id for Engine matching.
  return AssociationVariant(
    associationId: dto.associationId,
    associationCardId: dto.associationClue,
    memberCardIds: List.unmodifiable(dto.memberCards),
    contentType: dto.contentType,
    variantId: dto.associationVariantId,
  );
}

/// Fallback associations when the content snapshot is unavailable.
List<AssociationVariantDto> bundledFallbackAssociations() {
  return const [
    AssociationVariantDto(
      associationVariantId: 'av_fallback_colors',
      associationId: 'a_fallback_colors',
      associationClue: 'ألوان أساسية',
      memberCards: ['أحمر', 'أزرق', 'أصفر'],
      contentType: 'text',
      semanticDifficulty: 1,
      visualFlag: false,
      chapterEligibility: [
        'ch_cairo',
        'ch_alexandria',
        'ch_beirut',
        'ch_marrakech',
        'ch_dubai',
      ],
      status: 'published',
      arabicReviewState: 'approved',
      semanticReviewState: 'approved',
    ),
    AssociationVariantDto(
      associationVariantId: 'av_fallback_fruit',
      associationId: 'a_fallback_fruit',
      associationClue: 'فواكه',
      memberCards: ['تفاح', 'موز', 'برتقال'],
      contentType: 'text',
      semanticDifficulty: 1,
      visualFlag: false,
      chapterEligibility: [
        'ch_cairo',
        'ch_alexandria',
        'ch_beirut',
        'ch_marrakech',
        'ch_dubai',
      ],
      status: 'published',
      arabicReviewState: 'approved',
      semanticReviewState: 'approved',
    ),
    AssociationVariantDto(
      associationVariantId: 'av_fallback_pets',
      associationId: 'a_fallback_pets',
      associationClue: 'حيوانات أليفة',
      memberCards: ['قطة', 'كلب', 'أرنب'],
      contentType: 'text',
      semanticDifficulty: 1,
      visualFlag: false,
      chapterEligibility: [
        'ch_cairo',
        'ch_alexandria',
        'ch_beirut',
        'ch_marrakech',
        'ch_dubai',
      ],
      status: 'published',
      arabicReviewState: 'approved',
      semanticReviewState: 'approved',
    ),
  ];
}
