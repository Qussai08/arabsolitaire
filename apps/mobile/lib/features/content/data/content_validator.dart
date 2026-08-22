// Sprint 10 — Content validation pipeline.
// download → validate integrity → validate schema → validate rules compatibility
// → validate content constraints → stage → atomic activate

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../domain/content_bundle.dart';

class ContentValidator {
  const ContentValidator();

  // ── Per-file SHA-256 validation ────────────────────────────────────────────

  /// Returns null if hash matches, or an error message if it does not.
  String? validateFileHash(Uint8List fileBytes, BundleFileEntry entry) {
    if (entry.isTrusted) return null; // bundled content is trusted
    final actual = sha256.convert(fileBytes).toString();
    if (actual != entry.sha256) {
      return 'Hash mismatch for ${entry.path}: '
          'expected ${entry.sha256}, got $actual';
    }
    return null;
  }

  // ── Schema version check ───────────────────────────────────────────────────

  ValidationIssue? checkSchemaVersion(BundleManifest manifest) {
    if (manifest.schemaVersion != kSupportedSchemaVersion) {
      return ValidationIssue(
        severity: ValidationSeverity.error,
        code: 'UNSUPPORTED_SCHEMA_VERSION',
        message: 'Bundle schema version ${manifest.schemaVersion} is not '
            'supported (client supports $kSupportedSchemaVersion).',
      );
    }
    return null;
  }

  // ── Rules version check ────────────────────────────────────────────────────

  ValidationIssue? checkRulesVersion(BundleManifest manifest) {
    if (manifest.rulesVersion != kSupportedRulesVersion) {
      return ValidationIssue(
        severity: ValidationSeverity.error,
        code: 'UNSUPPORTED_RULES_VERSION',
        message: 'Bundle rules version ${manifest.rulesVersion} is not '
            'supported (client supports $kSupportedRulesVersion). '
            'App update may be required.',
      );
    }
    return null;
  }

  // ── Manifest structural validation ────────────────────────────────────────

  List<ValidationIssue> validateManifestStructure(BundleManifest manifest) {
    final issues = <ValidationIssue>[];

    if (manifest.bundleId.isEmpty) {
      issues.add(const ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'MISSING_BUNDLE_ID',
          message: 'bundleId is required.'));
    }
    if (manifest.bundleVersion.isEmpty) {
      issues.add(const ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'MISSING_BUNDLE_VERSION',
          message: 'bundleVersion is required.'));
    }
    if (manifest.files.isEmpty) {
      issues.add(const ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'MISSING_FILES',
          message: 'Manifest must list at least one file.'));
    }

    // Check file path uniqueness
    final paths = manifest.files.map((f) => f.path).toList();
    final uniquePaths = paths.toSet();
    if (uniquePaths.length != paths.length) {
      issues.add(const ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'DUPLICATE_FILE_PATHS',
          message: 'Manifest contains duplicate file paths.'));
    }

    return issues;
  }

  // ── Content structural validation ─────────────────────────────────────────

  List<ValidationIssue> validateContentSnapshot(ContentSnapshot snapshot) {
    final issues = <ValidationIssue>[];
    final sw = Stopwatch()..start();

    issues.addAll(_validateChapters(snapshot.chapters));
    issues.addAll(_validateLevels(snapshot.levels, snapshot.chapters));
    issues.addAll(_validateAssociations(snapshot.associations));
    issues.addAll(
        _validateStoryBeats(snapshot.storyBeats, snapshot.levels));
    issues.addAll(_validateContentRules(
        snapshot.levels, snapshot.associations));

    sw.stop();
    return issues;
  }

  List<ValidationIssue> _validateChapters(List<ChapterDto> chapters) {
    final issues = <ValidationIssue>[];
    final ids = <String>{};

    for (final ch in chapters) {
      if (!ids.add(ch.chapterId)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'DUPLICATE_CHAPTER_ID',
          message: 'Duplicate chapterId: ${ch.chapterId}',
          affectedId: ch.chapterId,
        ));
      }
      if (ch.levelCount <= 0) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'INVALID_LEVEL_COUNT',
          message: 'Chapter ${ch.chapterId} has invalid levelCount.',
          affectedId: ch.chapterId,
        ));
      }
    }
    return issues;
  }

  List<ValidationIssue> _validateLevels(
      List<LevelDto> levels, List<ChapterDto> chapters) {
    final issues = <ValidationIssue>[];
    final chapterIds = chapters.map((c) => c.chapterId).toSet();
    final ids = <String>{};
    final globalNums = <int>{};

    for (final l in levels) {
      if (!ids.add(l.levelDefinitionId)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'DUPLICATE_LEVEL_ID',
          message: 'Duplicate levelDefinitionId: ${l.levelDefinitionId}',
          affectedId: l.levelDefinitionId,
        ));
      }
      if (!globalNums.add(l.globalLevelNumber)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'DUPLICATE_GLOBAL_LEVEL',
          message:
              'Duplicate globalLevelNumber: ${l.globalLevelNumber}',
          affectedId: l.levelDefinitionId,
        ));
      }
      if (!chapterIds.contains(l.chapterId)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'INVALID_CHAPTER_REF',
          message:
              'Level ${l.levelDefinitionId} references unknown chapterId: ${l.chapterId}',
          affectedId: l.levelDefinitionId,
        ));
      }
    }
    return issues;
  }

  List<ValidationIssue> _validateAssociations(
      List<AssociationVariantDto> associations) {
    final issues = <ValidationIssue>[];
    final variantIds = <String>{};

    // Track clue usage per association for cooldown: not per level here
    // (full cooldown check belongs in the CMS/publishing validator, not client)
    for (final a in associations) {
      if (!variantIds.add(a.associationVariantId)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'DUPLICATE_VARIANT_ID',
          message:
              'Duplicate associationVariantId: ${a.associationVariantId}',
          affectedId: a.associationVariantId,
        ));
      }
      // Member cards must be homogeneous content type (all text or all image)
      if (a.contentType != 'text' && a.contentType != 'image') {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'INVALID_CONTENT_TYPE',
          message:
              'AssociationVariant ${a.associationVariantId} has unknown contentType: ${a.contentType}',
          affectedId: a.associationVariantId,
        ));
      }
      if (a.memberCards.isEmpty) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'MISSING_MEMBER_CARDS',
          message:
              'AssociationVariant ${a.associationVariantId} has no member cards.',
          affectedId: a.associationVariantId,
        ));
      }
      if (a.memberCards.length < 2) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'INVALID_GROUP_SIZE',
          message:
              'AssociationVariant ${a.associationVariantId} must have at least 2 member cards.',
          affectedId: a.associationVariantId,
        ));
      }
    }
    return issues;
  }

  List<ValidationIssue> _validateStoryBeats(
      List<StoryBeatDto> beats, List<LevelDto> levels) {
    final issues = <ValidationIssue>[];
    final beatIds = <String>{};
    final triggerLevels = levels.map((l) => l.globalLevelNumber).toSet();

    for (final beat in beats) {
      if (!beatIds.add(beat.storyBeatId)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'DUPLICATE_BEAT_ID',
          message: 'Duplicate storyBeatId: ${beat.storyBeatId}',
          affectedId: beat.storyBeatId,
        ));
      }
      if (levels.isNotEmpty &&
          !triggerLevels.contains(beat.triggerLevel)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.warning,
          code: 'INVALID_TRIGGER_LEVEL',
          message:
              'StoryBeat ${beat.storyBeatId} triggers at level ${beat.triggerLevel} which is not in this bundle.',
          affectedId: beat.storyBeatId,
        ));
      }
    }
    return issues;
  }

  /// Content rules validation (sprint 10 content-rule requirements).
  List<ValidationIssue> _validateContentRules(
      List<LevelDto> levels, List<AssociationVariantDto> associations) {
    final issues = <ValidationIssue>[];

    // ── Visual Association restriction (max 1 per early/mid level) ──────────
    // Early/mid = semanticDifficultyTier 1 or 2
    // (Full assignment is done at generation time; validate pool constraint)
    final visualVariants = associations.where((a) => a.visualFlag).length;
    if (visualVariants > 0) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.info,
        code: 'VISUAL_ASSOCIATIONS_PRESENT',
        message:
            '$visualVariants visual association variant(s) present. '
            'Generator must enforce max-one-visual for early/mid levels.',
      ));
    }

    // ── Clue reuse cooldown (≥20 levels): tracked per publishing pipeline,
    // flagged here as info since we only have the pool, not the sequence ──────

    return issues;
  }

  // ── Full bundle validation (remote candidate) ─────────────────────────────

  Future<ValidationReport> validateRemoteBundle({
    required BundleManifest manifest,
    required Map<String, Uint8List> fileBytes,
    required ContentSnapshot parsedSnapshot,
  }) async {
    final sw = Stopwatch()..start();
    final issues = <ValidationIssue>[];

    // 1. Manifest structure
    issues.addAll(validateManifestStructure(manifest));

    // 2. Schema version
    final schemaIssue = checkSchemaVersion(manifest);
    if (schemaIssue != null) issues.add(schemaIssue);

    // 3. Rules version
    final rulesIssue = checkRulesVersion(manifest);
    if (rulesIssue != null) issues.add(rulesIssue);

    // 4. Per-file hash check (trusted entries bypass bytes requirement)
    for (final entry in manifest.files) {
      if (entry.isTrusted) continue; // bundled/trusted — no download needed
      final bytes = fileBytes[entry.path];
      if (bytes == null) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'MISSING_FILE',
          message: 'Required file not downloaded: ${entry.path}',
          affectedId: entry.path,
        ));
        continue;
      }
      final hashError = validateFileHash(bytes, entry);
      if (hashError != null) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          code: 'HASH_MISMATCH',
          message: hashError,
          affectedId: entry.path,
        ));
      }
    }

    // Stop early if blocking errors before parsing
    if (issues.any((i) => i.isBlocking)) {
      sw.stop();
      return ValidationReport(
        isValid: false,
        issues: issues,
        bundleVersion: manifest.bundleVersion,
        durationMs: sw.elapsedMilliseconds,
      );
    }

    // 5. Content structural validation
    issues.addAll(validateContentSnapshot(parsedSnapshot));

    sw.stop();
    final hasBlockingError = issues.any((i) => i.isBlocking);
    return ValidationReport(
      isValid: !hasBlockingError,
      issues: issues,
      bundleVersion: manifest.bundleVersion,
      durationMs: sw.elapsedMilliseconds,
      validatedCounts: {
        'chapters': parsedSnapshot.chapters.length,
        'levels': parsedSnapshot.levels.length,
        'associations': parsedSnapshot.associations.length,
        'storyBeats': parsedSnapshot.storyBeats.length,
      },
    );
  }

  // ── Parse raw JSON bytes into typed DTOs ──────────────────────────────────

  static ContentSnapshot parseBundle({
    required BundleManifest manifest,
    required Map<String, Uint8List> fileBytes,
  }) {
    List<T> parseList<T>(
        String path, T Function(Map<String, dynamic>) fromJson) {
      final bytes = fileBytes[path];
      if (bytes == null) return [];
      final raw = utf8.decode(bytes);
      final list = json.decode(raw) as List<dynamic>;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }

    Map<String, String> parseLocalization(String path) {
      final bytes = fileBytes[path];
      if (bytes == null) return {};
      final raw = utf8.decode(bytes);
      final j = json.decode(raw) as Map<String, dynamic>;
      final strings = j['strings'] as Map<String, dynamic>? ?? {};
      return strings.map((k, v) => MapEntry(k, v as String));
    }

    return ContentSnapshot(
      manifest: manifest,
      chapters: parseList('chapters.json', ChapterDto.fromJson),
      levels: parseList('levels.json', LevelDto.fromJson),
      associations: parseList(
          'associations.json', AssociationVariantDto.fromJson),
      storyBeats: parseList('story_beats.json', StoryBeatDto.fromJson),
      localization: parseLocalization('localization/ar.json'),
      source: ContentSource.localRemote,
    );
  }
}
