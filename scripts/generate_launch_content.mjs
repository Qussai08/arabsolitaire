#!/usr/bin/env node
/**
 * Generates launch content for Arc 1 (5 chapters × 50 levels).
 * Writes associations.json (+ regenerates levels.json with real selection mode).
 *
 * Usage: node scripts/generate_launch_content.mjs
 */
import { writeFileSync, mkdirSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const outDir = path.resolve(__dirname, '../apps/mobile/assets/content/bundle');

const CHAPTERS = [
  'ch_cairo',
  'ch_alexandria',
  'ch_beirut',
  'ch_marrakech',
  'ch_dubai',
];

/** Arabic association packs: [clue, members...] — members must be globally unique. */
const PACKS = [
  // ── Easy (tier 1) — groups of 3 ───────────────────────────────────────────
  ['ألوان أساسية', 'أحمر', 'أزرق', 'أصفر'],
  ['فواكه صيفية', 'بطيخ', 'مانجو', 'خوخ'],
  ['حيوانات أليفة', 'قطة', 'كلب', 'أرنب'],
  ['أجزاء الوجه', 'عين', 'أنف', 'فم'],
  ['أدوات الكتابة', 'قلم', 'دفتر', 'ممحاة'],
  ['أوقات اليوم', 'صباح', 'ظهر', 'مساء'],
  ['أطعمة الإفطار', 'خبز', 'جبن', 'بيض'],
  ['وسائل النقل', 'سيارة', 'قطار', 'طائرة'],
  ['أثاث المنزل', 'طاولة', 'كرسي', 'سرير'],
  ['ظواهر جوية', 'مطر', 'رياح', 'ثلج'],
  ['أرقام', 'واحد', 'اثنان', 'ثلاثة'],
  ['أيام الأسبوع', 'سبت', 'أحد', 'اثنين'],
  ['مشروبات', 'شاي', 'قهوة', 'عصير'],
  ['ملابس', 'قميص', 'بنطلون', 'حذاء'],
  ['أجزاء البيت', 'باب', 'نافذة', 'سقف'],
  ['فواكه شتوية', 'برتقال', 'تفاح', 'موز'],
  ['خضروات', 'طماطم', 'خيار', 'جزر'],
  ['طيور', 'عصفور', 'حمامة', 'نسر'],
  ['حشرات', 'نملة', 'نحلة', 'فراشة'],
  ['آلات موسيقية', 'عود', 'ناي', 'دف'],
  // ── Mid (tier 2) — groups of 4 ────────────────────────────────────────────
  ['كلمات الضوء', 'نور', 'ضياء', 'بريق', 'شعاع'],
  ['كلمات الماء', 'بحر', 'نهر', 'موج', 'قطرة'],
  ['كلمات الليل', 'قمر', 'نجوم', 'ظلام', 'سهر'],
  ['مشاعر القلب', 'حب', 'شوق', 'أمل', 'وفاء'],
  ['كلمات الزمن', 'أمس', 'اليوم', 'غد', 'دهر'],
  ['أصوات الطبيعة', 'رعد', 'همس', 'خرير', 'هديل'],
  ['أدوات المطبخ', 'قدر', 'مقلاة', 'سكين', 'ملعقة'],
  ['مهن قديمة', 'نجار', 'حداد', 'خباز', 'صياد'],
  ['أماكن المدينة', 'سوق', 'مسجد', 'حديقة', 'مكتبة'],
  ['حالات الطقس', 'حار', 'بارد', 'رطب', 'جاف'],
  ['علاقات القرابة', 'أب', 'أم', 'أخ', 'أخت'],
  ['حواس الإنسان', 'بصر', 'سمع', 'شم', 'لمس'],
  ['معادن', 'ذهب', 'فضة', 'برونز', 'حديد'],
  ['أحجار كريمة', 'ياقوت', 'زمرد', 'لؤلؤ', 'عقيق'],
  ['أشجار', 'نخلة', 'زيتون', 'صنوبر', 'بلوط'],
  ['ورود الحديقة', 'فل', 'قرنفل', 'زنبق', 'أقحوان'],
  ['توابل', 'كمون', 'قرفة', 'هيل', 'زعفران'],
  ['حلويات', 'كنافة', 'بقلاوة', 'بسبوسة', 'مهلبية'],
  ['ألعاب شعبية', 'حجلة', 'نرد', 'شطرنج', 'دومينو'],
  ['كتب مقدسة', 'قرآن', 'إنجيل', 'توراة', 'زبور'],
  // ── Advanced (tier 3) — groups of 4 ───────────────────────────────────────
  ['فنون القول', 'شعر', 'قصة', 'حرف', 'بلاغة'],
  ['أثر الذاكرة', 'صورة', 'رائحة', 'صوت', 'طعم'],
  ['أصوات المدينة', 'زحام', 'ضجيج', 'أنوار', 'هرج'],
  ['بحر الإسكندرية', 'موجة', 'مركب', 'منارة', 'شاطئ'],
  ['أزقة القاهرة', 'زقاق', 'حواري', 'قباب', 'مآذن'],
  ['كتب ومخطوطات', 'مخطوطة', 'حبر', 'رق', 'ختم'],
  ['سوق مراكش', 'بهارات', 'سجاد', 'فخار', 'نحاس'],
  ['أبراج دبي', 'ناطحات', 'زجاج', 'أفق', 'لمعان'],
  ['كلمات السفر', 'رحيل', 'وصول', 'طريق', 'محطة'],
  ['كلمات الصداقة', 'صديق', 'رفقة', 'عهد', 'ود'],
  ['كلمات الحرب', 'سيف', 'درع', 'حصن', 'نصر'],
  ['كلمات السلام', 'صلح', 'هدوء', 'أمان', 'وئام'],
  ['فصول السنة', 'ربيع', 'صيف', 'خريف', 'شتاء'],
  ['اتجاهات', 'شمال', 'جنوب', 'شرق', 'غرب'],
  ['عناصر الطبيعة', 'تراب', 'ماء', 'هواء', 'نار'],
  ['حالات النفس', 'فرح', 'حزن', 'غضب', 'سكينة'],
  ['كلمات العلم', 'معرفة', 'بحث', 'تجربة', 'اكتشاف'],
  ['كلمات الفن', 'لوحة', 'لون', 'فرشاة', 'إطار'],
  ['كلمات التجارة', 'بيع', 'شراء', 'ربح', 'خسارة'],
  ['كلمات البناء', 'حجر', 'طوب', 'إسمنت', 'عمود'],
  // ── Hard (tier 4–5) — groups of 5 ─────────────────────────────────────────
  ['رموز الغياب', 'فراغ', 'صمت', 'ظل', 'بقايا', 'صدى'],
  ['خيوط المعنى', 'رابطة', 'صلة', 'جسر', 'خيط', 'عقد'],
  ['وجوه الذاكرة', 'ذكرى', 'نسيان', 'حنين', 'ماض', 'أثر'],
  ['لغة البحر', 'مد', 'انحسار', 'مرسى', 'سفينة', 'مرساة'],
  ['أسرار الكتب', 'سطر', 'هامش', 'حاشية', 'فهرس', 'غلاف'],
  ['متاهة السوق', 'دكان', 'بائع', 'مساومة', 'نداء', 'ميزان'],
  ['مدينة الضوء', 'برج', 'نافورة', 'كوبري', 'صحراء', 'خليج'],
  ['كلمات التشويش', 'قطع', 'تشويه', 'تزييف', 'انفصال', 'ضياع'],
  ['دار الروابط', 'عقدة', 'شبكة', 'ذاكرة', 'معنى', 'وصلة'],
  ['صفات الحكمة', 'صبر', 'تأمل', 'بصيرة', 'عدل', 'رحمة'],
  ['رموز القوة', 'أسد', 'جبل', 'شمس', 'صقر', 'نخل'],
  ['رموز الضعف', 'ورقة', 'زبد', 'هباء', 'ندى', 'قش'],
  ['كلمات الحلم', 'رؤيا', 'سبات', 'خيال', 'أمنية', 'منام'],
  ['كلمات الحقيقة', 'صدق', 'برهان', 'دليل', 'يقينان', 'وضوح'],
  ['كلمات الخداع', 'وهم', 'قناع', 'زيف', 'ستار', 'خديعة'],
  ['أدوات الرحالة', 'خريطة', 'بوصلة', 'زاد', 'حبل', 'قنديل'],
  ['مفردات الخط', 'نسخ', 'رقعة', 'ثلث', 'ديواني', 'كوفي'],
  ['مفردات العطر', 'مسك', 'عنبر', 'بخور', 'ورد', 'ياسمين'],
  ['مفردات القهوة', 'فنجان', 'إبريق', 'رمل', 'دلة', 'فحم'],
  ['مفردات الضيافة', 'ضيافة', 'كرم', 'مأدبة', 'مجلس', 'ترحاب'],
  // ── Extra mid packs for cooldown coverage ─────────────────────────────────
  ['حيوانات برية', 'غزال', 'ذئب', 'ثعلب', 'فهد'],
  ['أسماك', 'سلمون', 'تونة', 'سردين', 'قرش'],
  ['جبال', 'قمة', 'سفح', 'وادي', 'منحدر'],
  ['أنهار', 'نيل', 'دجلة', 'فرات', 'أردن'],
  ['مدن عربية', 'دمشق', 'بغداد', 'تونس', 'صنعاء'],
  ['علوم', 'فيزياء', 'كيمياء', 'رياضيات', 'أحياء'],
  ['رياضات', 'كرة', 'سباحة', 'جري', 'مبارزة'],
  ['أدوات الطبيب', 'سماعة', 'محقن', 'ضمادة', 'مشرط'],
  ['أجزاء السيارة', 'مقود', 'دولاب', 'محرك', 'فرامل'],
  ['أدوات الفلاح', 'محراث', 'منجل', 'بذور', 'سقاية'],
  ['كلمات المطر', 'غيث', 'وابل', 'رذاذ', 'سيل'],
  ['كلمات النار', 'لهب', 'شرر', 'رماد', 'دخان'],
  ['كلمات الريح', 'نسيم', 'عاصفة', 'إعصار', 'هبوب'],
  ['كلمات التراب', 'طين', 'غبار', 'صلصال', 'حصى'],
  ['كلمات السماء', 'سحاب', 'فضاء', 'كوكب', 'مجرة'],
  ['كلمات الأرض', 'بر', 'يابسة', 'قارة', 'جزيرة'],
  ['كلمات الطفل', 'لعبة', 'ضحكة', 'حليب', 'مهد'],
  ['كلمات الشيخ', 'حكمة', 'خبرة', 'لحية', 'عصا'],
  ['كلمات الضيف', 'مرحبا', 'أهلا', 'سهلا', 'تفضل'],
  ['كلمات الطريق', 'درب', 'سبيل', 'مسلك', 'مسار'],
];

function slugify(index, clue) {
  return `av_${String(index + 1).padStart(3, '0')}`;
}

function associationId(index) {
  return `a_${String(index + 1).padStart(3, '0')}`;
}

function tierForSize(size) {
  if (size <= 3) return 1;
  if (size === 4) return 2;
  return 4;
}

function chaptersForTier(tier) {
  if (tier <= 1) return [...CHAPTERS];
  if (tier === 2) return [...CHAPTERS];
  if (tier === 3) return CHAPTERS.slice(1);
  return CHAPTERS.slice(2);
}

function buildAssociations() {
  const usedMembers = new Set();
  const usedClues = new Set();
  const associations = [];

  for (let i = 0; i < PACKS.length; i++) {
    const [clue, ...members] = PACKS[i];
    if (usedClues.has(clue)) {
      throw new Error(`Duplicate clue: ${clue}`);
    }
    for (const m of members) {
      if (usedMembers.has(m)) {
        throw new Error(`Duplicate member word "${m}" in pack ${clue}`);
      }
      usedMembers.add(m);
    }
    usedClues.add(clue);

    const size = members.length;
    const tier = Math.min(5, tierForSize(size) + (i > 60 ? 1 : 0));
    associations.push({
      associationVariantId: slugify(i, clue),
      associationId: associationId(i),
      associationClue: clue,
      memberCards: members,
      contentType: 'text',
      semanticDifficulty: tier,
      visualFlag: false,
      chapterEligibility: chaptersForTier(tier),
      status: 'published',
      arabicReviewState: 'approved',
      semanticReviewState: 'approved',
      approvedBy: 'content-pipeline',
      version: 1,
    });
  }

  return associations;
}

function configRefForWave(wave) {
  // wave 1–5 within each chapter
  if (wave <= 1) return 'early_3x3';
  if (wave === 2) return 'early_3x3_tight';
  if (wave === 3) return 'mid_mixed_334';
  if (wave === 4) return 'mid_4x3';
  return 'late_mixed_445';
}

function difficultyFor(globalLevel, wave) {
  const base = 0.12 + (globalLevel / 250) * 0.55;
  const waveBump = (wave - 1) * 0.04;
  return Math.min(0.85, Math.round((base + waveBump) * 100) / 100);
}

function buildLevels() {
  const levels = [];
  const chapterMeta = [
    { id: 'ch_cairo', start: 1 },
    { id: 'ch_alexandria', start: 51 },
    { id: 'ch_beirut', start: 101 },
    { id: 'ch_marrakech', start: 151 },
    { id: 'ch_dubai', start: 201 },
  ];

  for (const ch of chapterMeta) {
    for (let i = 1; i <= 50; i++) {
      const global = ch.start + (i - 1);
      const wave = Math.floor((i - 1) / 10) + 1;
      const wavePos = ((i - 1) % 10) + 1;
      const tier = Math.min(5, wave);
      let storyMilestoneRef;
      if (i === 1) storyMilestoneRef = `sb_${ch.id}_start`;
      if (i === 25) storyMilestoneRef = `sb_${ch.id}_mid`;
      if (i === 50) storyMilestoneRef = `sb_${ch.id}_end`;

      levels.push({
        levelDefinitionId: `l${String(global).padStart(3, '0')}`,
        chapterId: ch.id,
        globalLevelNumber: global,
        chapterLevelNumber: i,
        waveIndex: wave - 1,
        wavePosition: wavePos - 1,
        levelConfigurationRef: configRefForWave(wave),
        boardDifficultyTarget: difficultyFor(global, wave),
        semanticDifficultyTier: tier,
        contentSelectionMode: 'approved_pool',
        enabled: true,
        ...(storyMilestoneRef ? { storyMilestoneRef } : {}),
      });
    }
  }
  return levels;
}

function sha256(content) {
  return createHash('sha256').update(content, 'utf8').digest('hex');
}

function main() {
  mkdirSync(outDir, { recursive: true });

  const associations = buildAssociations();
  const levels = buildLevels();

  const associationsJson = `${JSON.stringify(associations, null, 2)}\n`;
  const levelsJson = `${JSON.stringify(levels, null, 2)}\n`;

  writeFileSync(path.join(outDir, 'associations.json'), associationsJson);
  writeFileSync(path.join(outDir, 'levels.json'), levelsJson);

  console.log(`Wrote ${associations.length} associations → associations.json`);
  console.log(`Wrote ${levels.length} levels → levels.json`);
  console.log(`Unique member words: ${new Set(associations.flatMap((a) => a.memberCards)).size}`);
  console.log(`associations sha256: ${sha256(associationsJson)}`);
  console.log(`levels sha256: ${sha256(levelsJson)}`);
}

main();
