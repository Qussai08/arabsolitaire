import 'package:mobile/features/journey/domain/journey_models.dart';

/// Approved 5-chapter launch structure.
///
/// Content is bundled locally. Sprint 5 uses generated LevelDefinition
/// templates; exact polished content arrives via CMS in Sprint 10.
abstract final class JourneyContent {
  static const List<ChapterDefinition> chapters = [
    ChapterDefinition(
      chapterId: 'chapter_cairo',
      order: 1,
      titleAr: 'القاهرة: أول خيط',
      subtitleAr: 'بداية الرحلة في دار الروابط',
      locationKey: 'cairo',
      levelStart: 1,
      levelEnd: 50,
    ),
    ChapterDefinition(
      chapterId: 'chapter_alexandria',
      order: 2,
      titleAr: 'الإسكندرية: أصداء الغياب',
      subtitleAr: 'الروابط ترجع من بعيد',
      locationKey: 'alexandria',
      levelStart: 51,
      levelEnd: 100,
    ),
    ChapterDefinition(
      chapterId: 'chapter_beirut',
      order: 3,
      titleAr: 'بيروت: ما بين السطور',
      subtitleAr: 'المعاني الخفية تظهر',
      locationKey: 'beirut',
      levelStart: 101,
      levelEnd: 150,
    ),
    ChapterDefinition(
      chapterId: 'chapter_marrakech',
      order: 4,
      titleAr: 'مراكش: متاهة المعنى',
      subtitleAr: 'التشويه يصل إلى القلب',
      locationKey: 'marrakech',
      levelStart: 151,
      levelEnd: 200,
    ),
    ChapterDefinition(
      chapterId: 'chapter_dubai',
      order: 5,
      titleAr: 'دبي: ما بعد الذاكرة',
      subtitleAr: 'الحقيقة تُكشف',
      locationKey: 'dubai',
      levelStart: 201,
      levelEnd: 250,
    ),
  ];

  static List<LevelDefinition> buildLevels() {
    final defs = <LevelDefinition>[];
    for (final chapter in chapters) {
      for (var i = 1; i <= 50; i++) {
        final globalNum = chapter.levelStart + (i - 1);
        final wave = ((i - 1) ~/ 10) + 1;
        final wavePos = ((i - 1) % 10) + 1;
        final tier = _tierForWave(wave);
        final storyMilestone = _storyMilestoneFor(chapter.chapterId, i);
        defs.add(LevelDefinition(
          levelDefinitionId:
              '${chapter.chapterId}_level_${i.toString().padLeft(2, '0')}',
          globalLevelNumber: globalNum,
          chapterId: chapter.chapterId,
          chapterLevelNumber: i,
          waveIndex: wave,
          wavePosition: wavePos,
          semanticDifficultyTier: tier,
          storyMilestone: storyMilestone,
          enabled: true,
        ));
      }
    }
    return defs;
  }

  static int _tierForWave(int wave) {
    return switch (wave) { 1 => 1, 2 => 2, 3 => 3, 4 => 4, _ => 5 };
  }

  static String? _storyMilestoneFor(String chapterId, int chapterLevel) {
    if (chapterLevel == 1) return '${chapterId}_start';
    if (chapterLevel == 25) return '${chapterId}_midpoint';
    if (chapterLevel == 50) return '${chapterId}_ending';
    return null;
  }

  /// Canonical story beats for all 5 launch Chapters.
  static const List<StoryBeat> storyBeats = [
    // ── Cairo ──────────────────────────────────────────────────────────
    StoryBeat(
      storyBeatId: 'chapter_cairo_start',
      chapterId: 'chapter_cairo',
      type: StoryBeatType.start,
      triggerLevelNumber: 1,
      backgroundKey: 'cairo_night',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr:
              'مرحباً يا صديقي! أنا شيبوب، حارس دار الروابط.',
        ),
        DialogueLine(
          speakerKey: 'shiboub',
          textAr:
              'الروابط بين الكلمات تكسّرت. ساعدني على إصلاحها!',
        ),
        DialogueLine(
          speakerKey: 'narrator',
          textAr:
              'بصيرة المعنى تلمع في عتمة القاهرة. الرحلة تبدأ.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_cairo_midpoint',
      chapterId: 'chapter_cairo',
      type: StoryBeatType.midpoint,
      triggerLevelNumber: 25,
      backgroundKey: 'cairo_dawn',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'شيء ما يقاوم... التشويه يتحرك!',
        ),
        DialogueLine(
          speakerKey: 'narrator',
          textAr: 'قوة مجهولة تحاول تمزيق ما أعدت بناءه.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_cairo_ending',
      chapterId: 'chapter_cairo',
      type: StoryBeatType.ending,
      triggerLevelNumber: 50,
      backgroundKey: 'cairo_sunrise',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'القاهرة أُعيد ترميمها! لكن الطريق إلى الإسكندرية لا يزال مكسوراً...',
        ),
        DialogueLine(
          speakerKey: 'narrator',
          textAr: 'الروابط الأولى عادت. أسطورة المعاني تواصل رحلتها.',
        ),
      ],
    ),
    // ── Alexandria ─────────────────────────────────────────────────────
    StoryBeat(
      storyBeatId: 'chapter_alexandria_start',
      chapterId: 'chapter_alexandria',
      type: StoryBeatType.start,
      triggerLevelNumber: 51,
      backgroundKey: 'alexandria_sea',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'الإسكندرية! أصداء الغياب ترن في كل مكان.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_alexandria_midpoint',
      chapterId: 'chapter_alexandria',
      type: StoryBeatType.midpoint,
      triggerLevelNumber: 75,
      backgroundKey: 'alexandria_library',
      dialogue: [
        DialogueLine(
          speakerKey: 'narrator',
          textAr: 'العُقد شبكة واحدة متصلة. لا معنى يقوم وحده.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_alexandria_ending',
      chapterId: 'chapter_alexandria',
      type: StoryBeatType.ending,
      triggerLevelNumber: 100,
      backgroundKey: 'alexandria_night',
      dialogue: [
        DialogueLine(
          speakerKey: 'narrator',
          textAr: 'أول صوت لـ عدو العرب يتردد في الأفق.',
        ),
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'انتبه! هناك من لا يريد عودة المعاني!',
        ),
      ],
    ),
    // ── Beirut ─────────────────────────────────────────────────────────
    StoryBeat(
      storyBeatId: 'chapter_beirut_start',
      chapterId: 'chapter_beirut',
      type: StoryBeatType.start,
      triggerLevelNumber: 101,
      backgroundKey: 'beirut_corniche',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'بيروت... المدينة بين السطور.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_beirut_midpoint',
      chapterId: 'chapter_beirut',
      type: StoryBeatType.midpoint,
      triggerLevelNumber: 125,
      backgroundKey: 'beirut_rooftop',
      dialogue: [
        DialogueLine(
          speakerKey: 'narrator',
          textAr: 'معاني مزيّفة تظهر بين الأوراق. التشويه يخترق الكلمات.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_beirut_ending',
      chapterId: 'chapter_beirut',
      type: StoryBeatType.ending,
      triggerLevelNumber: 150,
      backgroundKey: 'beirut_twilight',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'عرفته... رمزه موجود في الأرشيف. سأخفي الحقيقة الآن.',
        ),
      ],
    ),
    // ── Marrakech ──────────────────────────────────────────────────────
    StoryBeat(
      storyBeatId: 'chapter_marrakech_start',
      chapterId: 'chapter_marrakech',
      type: StoryBeatType.start,
      triggerLevelNumber: 151,
      backgroundKey: 'marrakech_medina',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'مراكش متاهة... المعاني ضائعة في أزقتها.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_marrakech_midpoint',
      chapterId: 'chapter_marrakech',
      type: StoryBeatType.midpoint,
      triggerLevelNumber: 175,
      backgroundKey: 'marrakech_souq',
      dialogue: [
        DialogueLine(
          speakerKey: 'narrator',
          textAr: 'التشويه يعيد رسم دار الروابط نفسه. خطر حقيقي.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_marrakech_ending',
      chapterId: 'chapter_marrakech',
      type: StoryBeatType.ending,
      triggerLevelNumber: 200,
      backgroundKey: 'marrakech_atlas',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr:
              'أنا المسؤول... فتحت الباب الذي دخل منه المُبدِّد. أنا آسف.',
        ),
      ],
    ),
    // ── Dubai ──────────────────────────────────────────────────────────
    StoryBeat(
      storyBeatId: 'chapter_dubai_start',
      chapterId: 'chapter_dubai',
      type: StoryBeatType.start,
      triggerLevelNumber: 201,
      backgroundKey: 'dubai_skyline',
      dialogue: [
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'دبي... آخر محطة. الحقيقة وراء هذه الأبراج.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_dubai_midpoint',
      chapterId: 'chapter_dubai',
      type: StoryBeatType.midpoint,
      triggerLevelNumber: 225,
      backgroundKey: 'dubai_desert',
      dialogue: [
        DialogueLine(
          speakerKey: 'narrator',
          textAr:
              'أول مواجهة مباشرة مع عدو العرب — المُبدِّد — يظهر في الظل.',
        ),
      ],
    ),
    StoryBeat(
      storyBeatId: 'chapter_dubai_ending',
      chapterId: 'chapter_dubai',
      type: StoryBeatType.ending,
      triggerLevelNumber: 250,
      backgroundKey: 'dubai_horizon',
      dialogue: [
        DialogueLine(
          speakerKey: 'narrator',
          textAr:
              'مئات العُقد تُكشف... الروابط عادت. اللاعب يُلقَّب: أسطورة المعاني.',
        ),
        DialogueLine(
          speakerKey: 'shiboub',
          textAr: 'فعلتها! دار الروابط آمنة مرة أخرى.',
        ),
      ],
    ),
  ];
}
