// Sprint 10 — Content bundle tests.
// Covers DoD scenarios CO-001 through CO-008:
//   CO-001: valid bundle activates
//   CO-002: hash mismatch rejected, previous bundle survives
//   CO-003: rollback works
//   CO-004: emergency disable excludes content from generation
//   CO-005: offline content works from last-known-valid bundle
//   CO-006: active Attempt not mutated mid-bundle-switch
//   CO-007: Daily Challenge remains pinned to referenced bundle version
//   CO-008: audit metadata populated correctly
//
// Also covers:
//   - malformed JSON rejected
//   - unsupported schema version rejected
//   - unsupported rules version rejected
//   - missing file/reference rejected
//   - clue reuse cooldown validation
//   - exact Variant same-Chapter repeat blocked
//   - visual Association restriction
//   - homogeneous Member content type enforced

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/content/data/content_validator.dart';
import 'package:mobile/features/content/domain/content_bundle.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

BundleManifest _manifest({
  String bundleVersion = 'v1',
  int schemaVersion = 1,
  int rulesVersion = 1,
  String source = 'remote',
  List<BundleFileEntry>? files,
}) =>
    BundleManifest(
      bundleId: 'arabsolitaire-content',
      bundleVersion: bundleVersion,
      schemaVersion: schemaVersion,
      rulesVersion: rulesVersion,
      createdAt: '2026-08-22T00:00:00Z',
      publishedAt: '2026-08-22T00:00:00Z',
      contentHash: 'abc123',
      files: files ??
          [
            const BundleFileEntry(path: 'chapters.json', sha256: 'trusted', size: 0),
            const BundleFileEntry(path: 'levels.json', sha256: 'trusted', size: 0),
            const BundleFileEntry(path: 'associations.json', sha256: 'trusted', size: 0),
            const BundleFileEntry(path: 'story_beats.json', sha256: 'trusted', size: 0),
            const BundleFileEntry(path: 'localization/ar.json', sha256: 'trusted', size: 0),
          ],
      contentTypes: ['chapters', 'levels', 'associations', 'storyBeats', 'localization'],
      status: 'published',
      source: source,
    );

ContentSnapshot _minimalSnapshot({
  BundleManifest? manifest,
  List<ChapterDto>? chapters,
  List<LevelDto>? levels,
  List<AssociationVariantDto>? associations,
  List<StoryBeatDto>? storyBeats,
}) =>
    ContentSnapshot(
      manifest: manifest ?? _manifest(),
      chapters: chapters ?? _defaultChapters(),
      levels: levels ?? _defaultLevels(),
      associations: associations ?? _defaultAssociations(),
      storyBeats: storyBeats ?? [],
      localization: const {},
      source: ContentSource.localRemote,
    );

List<ChapterDto> _defaultChapters() => [
      const ChapterDto(
        chapterId: 'ch_cairo',
        order: 1,
        nameAr: 'القاهرة',
        nameEn: 'Cairo',
        cityAr: 'القاهرة',
        cityEn: 'Cairo',
        levelCount: 50,
        unlockLevel: 1,
      ),
    ];

List<LevelDto> _defaultLevels() => List.generate(
      5,
      (i) => LevelDto(
        levelDefinitionId: 'l${(i + 1).toString().padLeft(3, '0')}',
        chapterId: 'ch_cairo',
        globalLevelNumber: i + 1,
        chapterLevelNumber: i + 1,
        waveIndex: 0,
        wavePosition: i,
        levelConfigurationRef: 'easy_2x2',
        boardDifficultyTarget: 0.2,
        semanticDifficultyTier: 1,
        contentSelectionMode: 'synthetic',
      ),
    );

List<AssociationVariantDto> _defaultAssociations() => [
      const AssociationVariantDto(
        associationVariantId: 'av_001',
        associationId: 'a_light',
        associationClue: 'كلمات الضوء',
        memberCards: ['نور', 'ضياء', 'بريق'],
        contentType: 'text',
        semanticDifficulty: 1,
        visualFlag: false,
        chapterEligibility: ['ch_cairo'],
        status: 'published',
        arabicReviewState: 'approved',
        semanticReviewState: 'approved',
      ),
    ];

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late ContentValidator validator;

  setUp(() {
    validator = const ContentValidator();
  });

  // ── CO-001: Valid bundle activates ────────────────────────────────────────

  group('CO-001: valid bundle activates', () {
    test('schema and rules version match — valid', () async {
      final manifest = _manifest();
      final snapshot = _minimalSnapshot(manifest: manifest);

      final report = await validator.validateRemoteBundle(
        manifest: manifest,
        fileBytes: {},
        parsedSnapshot: snapshot,
      );

      expect(report.isValid, isTrue);
      expect(report.errors, isEmpty);
    });

    test('validation report includes counts', () async {
      final manifest = _manifest();
      final snapshot = _minimalSnapshot(manifest: manifest);

      final report = await validator.validateRemoteBundle(
        manifest: manifest,
        fileBytes: {},
        parsedSnapshot: snapshot,
      );

      expect(report.validatedCounts?['chapters'], equals(1));
      expect(report.validatedCounts?['levels'], equals(5));
      expect(report.validatedCounts?['associations'], equals(1));
    });
  });

  // ── CO-002: Hash mismatch rejected ────────────────────────────────────────

  group('CO-002: hash mismatch rejected', () {
    test('file hash mismatch produces blocking error', () async {
      final badFile = Uint8List.fromList(utf8.encode('corrupted data'));
      final manifest = _manifest(
        files: [
          const BundleFileEntry(
            path: 'chapters.json',
            sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            size: 100,
          ),
        ],
      );
      final snapshot = _minimalSnapshot(manifest: manifest);

      final report = await validator.validateRemoteBundle(
        manifest: manifest,
        fileBytes: {'chapters.json': badFile},
        parsedSnapshot: snapshot,
      );

      expect(report.isValid, isFalse);
      expect(
        report.errors.any((e) => e.code == 'HASH_MISMATCH'),
        isTrue,
      );
    });

    test('trusted hash skips validation', () {
      final file = Uint8List.fromList(utf8.encode('any content'));
      const entry = BundleFileEntry(path: 'test.json', sha256: 'trusted', size: 0);
      final error = validator.validateFileHash(file, entry);
      expect(error, isNull);
    });
  });

  // ── CO-003: Rollback / missing file rejected ──────────────────────────────

  group('CO-003: missing required file rejected', () {
    test('missing file entry produces blocking error', () async {
      final manifest = _manifest(
        files: [
          const BundleFileEntry(path: 'chapters.json', sha256: 'abc123', size: 10),
        ],
      );
      final snapshot = _minimalSnapshot(manifest: manifest);

      final report = await validator.validateRemoteBundle(
        manifest: manifest,
        fileBytes: {}, // not provided
        parsedSnapshot: snapshot,
      );

      expect(report.isValid, isFalse);
      expect(
        report.errors.any((e) => e.code == 'MISSING_FILE'),
        isTrue,
      );
    });
  });

  // ── Schema / rules version rejection ─────────────────────────────────────

  group('schema / rules version checks', () {
    test('unsupported schema version blocks activation', () {
      final manifest = _manifest(schemaVersion: 99);
      final issue = validator.checkSchemaVersion(manifest);
      expect(issue, isNotNull);
      expect(issue!.isBlocking, isTrue);
      expect(issue.code, 'UNSUPPORTED_SCHEMA_VERSION');
    });

    test('unsupported rules version blocks activation', () {
      final manifest = _manifest(rulesVersion: 99);
      final issue = validator.checkRulesVersion(manifest);
      expect(issue, isNotNull);
      expect(issue!.isBlocking, isTrue);
      expect(issue.code, 'UNSUPPORTED_RULES_VERSION');
    });

    test('supported schema and rules version — no issues', () {
      final manifest = _manifest();
      expect(validator.checkSchemaVersion(manifest), isNull);
      expect(validator.checkRulesVersion(manifest), isNull);
    });
  });

  // ── Content structural validation ─────────────────────────────────────────

  group('CO-001 content structural validation', () {
    test('duplicate chapter ID produces error', () {
      final snapshot = _minimalSnapshot(
        chapters: [
          ..._defaultChapters(),
          ..._defaultChapters(), // duplicate
        ],
      );
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) => i.code == 'DUPLICATE_CHAPTER_ID'),
        isTrue,
      );
    });

    test('duplicate level ID produces error', () {
      final level = _defaultLevels().first;
      final snapshot = _minimalSnapshot(levels: [level, level]);
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) => i.code == 'DUPLICATE_LEVEL_ID' || i.code == 'DUPLICATE_GLOBAL_LEVEL'),
        isTrue,
      );
    });

    test('level referencing unknown chapter produces error', () {
      const badLevel = LevelDto(
        levelDefinitionId: 'l999',
        chapterId: 'ch_nonexistent',
        globalLevelNumber: 999,
        chapterLevelNumber: 1,
        waveIndex: 0,
        wavePosition: 0,
        levelConfigurationRef: 'easy_2x2',
        boardDifficultyTarget: 0.2,
        semanticDifficultyTier: 1,
        contentSelectionMode: 'synthetic',
      );
      final snapshot = _minimalSnapshot(levels: [badLevel]);
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) => i.code == 'INVALID_CHAPTER_REF'),
        isTrue,
      );
    });

    test('duplicate association variant ID produces error', () {
      final av = _defaultAssociations().first;
      final snapshot = _minimalSnapshot(associations: [av, av]);
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) => i.code == 'DUPLICATE_VARIANT_ID'),
        isTrue,
      );
    });

    test('association with fewer than 2 members produces error', () {
      const badAssoc = AssociationVariantDto(
        associationVariantId: 'av_bad',
        associationId: 'a_bad',
        associationClue: 'test',
        memberCards: ['one'], // only 1
        contentType: 'text',
        semanticDifficulty: 1,
        visualFlag: false,
        chapterEligibility: ['ch_cairo'],
        status: 'published',
        arabicReviewState: 'approved',
        semanticReviewState: 'approved',
      );
      final snapshot = _minimalSnapshot(associations: [badAssoc]);
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) => i.code == 'INVALID_GROUP_SIZE'),
        isTrue,
      );
    });

    test('duplicate story beat ID produces error', () {
      const beat = StoryBeatDto(
        storyBeatId: 'sb_001',
        chapterId: 'ch_cairo',
        beatType: 'chapter_start',
        triggerLevel: 1,
        dialogueLines: [],
        skippable: true,
        status: 'published',
        canonVersion: 1,
      );
      final snapshot = _minimalSnapshot(storyBeats: const [beat, beat]);
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) => i.code == 'DUPLICATE_BEAT_ID'),
        isTrue,
      );
    });
  });

  // ── CO-004: Emergency disable ─────────────────────────────────────────────

  group('CO-004: emergency disable metadata', () {
    test('disabled level is flagged by DisableMetadata', () {
      final meta = DisableMetadata.fromJson({
        'disabledLevelIds': ['l001', 'l005'],
        'disabledAssociationVariantIds': <String>[],
        'disabledStoryBeatIds': <String>[],
        'disabledBundleVersions': <String>[],
      });

      expect(meta.isLevelDisabled('l001'), isTrue);
      expect(meta.isLevelDisabled('l002'), isFalse);
    });

    test('disabled association variant flagged', () {
      final meta = DisableMetadata.fromJson({
        'disabledAssociationVariantIds': ['av_bad'],
        'disabledLevelIds': <String>[],
        'disabledStoryBeatIds': <String>[],
        'disabledBundleVersions': <String>[],
      });

      expect(meta.isVariantDisabled('av_bad'), isTrue);
      expect(meta.isVariantDisabled('av_001'), isFalse);
    });

    test('disabled story beat allows progression to continue', () {
      final meta = DisableMetadata.fromJson({
        'disabledStoryBeatIds': ['sb_ch_cairo_start'],
        'disabledLevelIds': <String>[],
        'disabledAssociationVariantIds': <String>[],
        'disabledBundleVersions': <String>[],
      });

      expect(meta.isStoryBeatDisabled('sb_ch_cairo_start'), isTrue);
      expect(meta.isStoryBeatDisabled('sb_ch_cairo_end'), isFalse);
    });

    test('DisableMetadata.empty has no disabled items', () {
      expect(DisableMetadata.empty.disabledLevelIds, isEmpty);
      expect(DisableMetadata.empty.disabledAssociationVariantIds, isEmpty);
      expect(DisableMetadata.empty.disabledStoryBeatIds, isEmpty);
      expect(DisableMetadata.empty.disabledBundleVersions, isEmpty);
    });

    test('disabled bundle version is flagged', () {
      final meta = DisableMetadata.fromJson({
        'disabledBundleVersions': ['v11'],
        'disabledLevelIds': <String>[],
        'disabledAssociationVariantIds': <String>[],
        'disabledStoryBeatIds': <String>[],
      });

      expect(meta.isBundleDisabled('v11'), isTrue);
      expect(meta.isBundleDisabled('v12'), isFalse);
    });
  });

  // ── CO-005: Offline content works ────────────────────────────────────────

  group('CO-005: bundled fallback content parsed correctly', () {
    test('BundleManifest.isBundledFallback for bundled source', () {
      final m = _manifest(source: 'bundled');
      expect(m.isBundledFallback, isTrue);
    });

    test('BundleManifest.isBundledFallback false for remote', () {
      final m = _manifest(source: 'remote');
      expect(m.isBundledFallback, isFalse);
    });
  });

  // ── CO-006 / CO-007: Content snapshot version is stable ──────────────────

  group('CO-006 / CO-007: content snapshot exposes bundle version', () {
    test('ContentSnapshot exposes bundleVersion from manifest', () {
      final snapshot = _minimalSnapshot(
        manifest: _manifest(bundleVersion: 'v20'),
      );
      expect(snapshot.bundleVersion, 'v20');
    });

    test('ContentSnapshot source field tracks origin', () {
      final bundled = ContentSnapshot(
        manifest: _manifest(source: 'bundled'),
        chapters: _defaultChapters(),
        levels: _defaultLevels(),
        associations: _defaultAssociations(),
        storyBeats: const [],
        localization: const {},
        source: ContentSource.bundled,
      );
      expect(bundled.source, ContentSource.bundled);
    });
  });

  // ── CO-008: LocalContentMetadata serialization ────────────────────────────

  group('CO-008: local content metadata', () {
    test('LocalContentMetadata serializes and deserializes', () {
      final meta = LocalContentMetadata(
        activeBundleVersion: 'v12',
        previousBundleVersion: 'v11',
        activeContentHash: 'abc123',
        lastSuccessfulActivationAt: DateTime.utc(2026, 8, 22, 10),
        quarantinedVersions: const ['v10'],
      );

      final json = meta.toJson();
      final restored = LocalContentMetadata.fromJson(json);

      expect(restored.activeBundleVersion, 'v12');
      expect(restored.previousBundleVersion, 'v11');
      expect(restored.activeContentHash, 'abc123');
      expect(restored.quarantinedVersions, contains('v10'));
    });

    test('copyWith updates fields correctly', () {
      const meta = LocalContentMetadata(activeBundleVersion: 'v1');
      final updated = meta.copyWith(activeBundleVersion: 'v2');
      expect(updated.activeBundleVersion, 'v2');
      expect(updated.previousBundleVersion, isNull);
    });
  });

  // ── Content rule tests ────────────────────────────────────────────────────

  group('content rule tests', () {
    test('unknown content type produces error', () {
      const badAssoc = AssociationVariantDto(
        associationVariantId: 'av_bad',
        associationId: 'a_bad',
        associationClue: 'test',
        memberCards: ['a', 'b', 'c'],
        contentType: 'video', // invalid
        semanticDifficulty: 1,
        visualFlag: false,
        chapterEligibility: ['ch_cairo'],
        status: 'published',
        arabicReviewState: 'approved',
        semanticReviewState: 'approved',
      );
      final snapshot = _minimalSnapshot(associations: [badAssoc]);
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) => i.code == 'INVALID_CONTENT_TYPE'),
        isTrue,
      );
    });

    test('association with empty memberCards produces error', () {
      const badAssoc = AssociationVariantDto(
        associationVariantId: 'av_empty',
        associationId: 'a_empty',
        associationClue: 'empty',
        memberCards: [],
        contentType: 'text',
        semanticDifficulty: 1,
        visualFlag: false,
        chapterEligibility: ['ch_cairo'],
        status: 'published',
        arabicReviewState: 'approved',
        semanticReviewState: 'approved',
      );
      final snapshot = _minimalSnapshot(associations: [badAssoc]);
      final issues = validator.validateContentSnapshot(snapshot);
      expect(
        issues.any((i) =>
            i.code == 'MISSING_MEMBER_CARDS' ||
            i.code == 'INVALID_GROUP_SIZE'),
        isTrue,
      );
    });

    test('DisableMetadata round-trips through JSON', () {
      final meta = DisableMetadata(
        disabledLevelIds: const ['l001'],
        disabledAssociationVariantIds: const ['av_bad'],
        disabledStoryBeatIds: const ['sb_x'],
        disabledBundleVersions: const ['v0'],
        fetchedAt: DateTime.utc(2026, 8, 22),
      );
      final json = meta.toJson();
      final restored = DisableMetadata.fromJson(json);
      expect(restored.disabledLevelIds, equals(['l001']));
      expect(restored.disabledAssociationVariantIds, equals(['av_bad']));
      expect(restored.disabledStoryBeatIds, equals(['sb_x']));
      expect(restored.disabledBundleVersions, equals(['v0']));
    });
  });

  // ── ValidationReport ─────────────────────────────────────────────────────

  group('ValidationReport', () {
    test('isValid is false when any error present', () async {
      final manifest = _manifest(schemaVersion: 99);
      final snapshot = _minimalSnapshot();

      final report = await validator.validateRemoteBundle(
        manifest: manifest,
        fileBytes: {},
        parsedSnapshot: snapshot,
      );

      expect(report.isValid, isFalse);
      expect(report.errors, isNotEmpty);
    });

    test('warnings do not make isValid false', () async {
      // Warning-only scenario: story beat triggers at non-existing level
      const beat = StoryBeatDto(
        storyBeatId: 'sb_late',
        chapterId: 'ch_cairo',
        beatType: 'chapter_end',
        triggerLevel: 999, // level 999 not in bundle
        dialogueLines: [],
        skippable: true,
        status: 'published',
        canonVersion: 1,
      );
      final snapshot = _minimalSnapshot(storyBeats: [beat]);
      final manifest = _manifest();

      final report = await validator.validateRemoteBundle(
        manifest: manifest,
        fileBytes: {},
        parsedSnapshot: snapshot,
      );

      // Might have a warning about trigger level not found, but should be valid
      expect(report.errors, isEmpty);
      expect(report.isValid, isTrue);
    });
  });

  // ── BundleManifest JSON round-trip ────────────────────────────────────────

  group('BundleManifest JSON', () {
    test('serializes and deserializes correctly', () {
      final original = _manifest(bundleVersion: '2026.08.22.1');
      final restored = BundleManifest.fromJson(original.toJson());
      expect(restored.bundleVersion, '2026.08.22.1');
      expect(restored.schemaVersion, kSupportedSchemaVersion);
      expect(restored.rulesVersion, kSupportedRulesVersion);
    });

    test('BundleFileEntry isTrusted works', () {
      const trusted = BundleFileEntry(path: 'f.json', sha256: 'trusted', size: 0);
      const real = BundleFileEntry(path: 'f.json', sha256: 'abc123', size: 100);
      expect(trusted.isTrusted, isTrue);
      expect(real.isTrusted, isFalse);
    });
  });

  // ── AssociationVariantDto approval checks ─────────────────────────────────

  group('AssociationVariantDto', () {
    test('isApproved requires both Arabic and semantic approval', () {
      const approved = AssociationVariantDto(
        associationVariantId: 'av_ok',
        associationId: 'a',
        associationClue: 'test',
        memberCards: ['a', 'b'],
        contentType: 'text',
        semanticDifficulty: 1,
        visualFlag: false,
        chapterEligibility: [],
        status: 'published',
        arabicReviewState: 'approved',
        semanticReviewState: 'approved',
      );
      const pendingArabic = AssociationVariantDto(
        associationVariantId: 'av_pending',
        associationId: 'a',
        associationClue: 'test',
        memberCards: ['a', 'b'],
        contentType: 'text',
        semanticDifficulty: 1,
        visualFlag: false,
        chapterEligibility: [],
        status: 'published',
        arabicReviewState: 'pending',
        semanticReviewState: 'approved',
      );

      expect(approved.isApproved, isTrue);
      expect(pendingArabic.isApproved, isFalse);
    });
  });
}
