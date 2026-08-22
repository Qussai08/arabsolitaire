// Sprint 10 — Content validation CLI.
// Usage: dart tool/content/content_validate.dart <bundle_dir>
//
// Input:  path to a directory containing manifest.json and bundle files.
// Output: human-readable report + machine-readable JSON (validation_result.json).

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart tool/content/content_validate.dart <bundle_dir>');
    exit(1);
  }

  final bundleDir = Directory(args[0]);
  if (!await bundleDir.exists()) {
    stderr.writeln('Error: directory not found: ${bundleDir.path}');
    exit(1);
  }

  final result = await validateBundle(bundleDir);
  _printReport(result);

  // Write machine-readable JSON
  final outFile = File('${bundleDir.path}/validation_result.json');
  await outFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(result.toJson()),
  );
  stdout.writeln('\nValidation result written to: ${outFile.path}');

  exit(result.isValid ? 0 : 1);
}

// ── Validation models (self-contained to avoid Flutter deps) ─────────────────

enum IssueSeverity { error, warning, info }

class Issue {
  Issue(this.severity, this.code, this.message, {this.affectedId});
  final IssueSeverity severity;
  final String code;
  final String message;
  final String? affectedId;
  bool get isBlocking => severity == IssueSeverity.error;
}

class ValidateResult {
  ValidateResult({
    required this.isValid,
    required this.issues,
    required this.bundleVersion,
    required this.durationMs,
    required this.counts,
  });

  final bool isValid;
  final List<Issue> issues;
  final String bundleVersion;
  final int durationMs;
  final Map<String, int> counts;

  Map<String, dynamic> toJson() => {
        'isValid': isValid,
        'bundleVersion': bundleVersion,
        'durationMs': durationMs,
        'counts': counts,
        'errors': issues
            .where((i) => i.isBlocking)
            .map((i) => {'code': i.code, 'message': i.message, 'affectedId': i.affectedId})
            .toList(),
        'warnings': issues
            .where((i) => i.severity == IssueSeverity.warning)
            .map((i) => {'code': i.code, 'message': i.message, 'affectedId': i.affectedId})
            .toList(),
        'infos': issues
            .where((i) => i.severity == IssueSeverity.info)
            .map((i) => {'code': i.code, 'message': i.message})
            .toList(),
      };
}

// ── Core validation logic ─────────────────────────────────────────────────────

Future<ValidateResult> validateBundle(Directory dir) async {
  final sw = Stopwatch()..start();
  final issues = <Issue>[];
  String bundleVersion = 'unknown';

  // 1. Read manifest
  final manifestFile = File('${dir.path}/manifest.json');
  if (!await manifestFile.exists()) {
    return ValidateResult(
      isValid: false,
      issues: [Issue(IssueSeverity.error, 'MISSING_MANIFEST', 'manifest.json not found.')],
      bundleVersion: bundleVersion,
      durationMs: sw.elapsedMilliseconds,
      counts: {},
    );
  }

  late Map<String, dynamic> manifest;
  try {
    manifest = json.decode(await manifestFile.readAsString()) as Map<String, dynamic>;
  } catch (e) {
    return ValidateResult(
      isValid: false,
      issues: [Issue(IssueSeverity.error, 'MALFORMED_MANIFEST', 'manifest.json is not valid JSON: $e')],
      bundleVersion: bundleVersion,
      durationMs: sw.elapsedMilliseconds,
      counts: {},
    );
  }

  bundleVersion = manifest['bundleVersion'] as String? ?? 'unknown';
  final schemaVersion = manifest['schemaVersion'] as int? ?? -1;
  final rulesVersion = manifest['rulesVersion'] as int? ?? -1;
  const supportedSchema = 1;
  const supportedRules = 1;

  // 2. Schema version
  if (schemaVersion != supportedSchema) {
    issues.add(Issue(IssueSeverity.error, 'UNSUPPORTED_SCHEMA_VERSION',
        'schemaVersion $schemaVersion is not supported (supported: $supportedSchema)'));
  }

  // 3. Rules version
  if (rulesVersion != supportedRules) {
    issues.add(Issue(IssueSeverity.error, 'UNSUPPORTED_RULES_VERSION',
        'rulesVersion $rulesVersion is not supported (supported: $supportedRules)'));
  }

  // 4. Per-file hash validation
  final files = manifest['files'] as List<dynamic>? ?? [];
  for (final f in files) {
    final entry = f as Map<String, dynamic>;
    final path = entry['path'] as String;
    final expectedHash = entry['sha256'] as String;
    final file = File('${dir.path}/$path');

    if (!await file.exists()) {
      issues.add(Issue(IssueSeverity.error, 'MISSING_FILE',
          'Required file missing: $path', affectedId: path));
      continue;
    }

    if (expectedHash == 'trusted') continue; // bundled content

    final bytes = await file.readAsBytes();
    final actualHash = sha256.convert(bytes).toString();
    if (actualHash != expectedHash) {
      issues.add(Issue(IssueSeverity.error, 'HASH_MISMATCH',
          'Hash mismatch for $path: expected $expectedHash, got $actualHash',
          affectedId: path));
    }
  }

  // 5. Content structural validation
  final counts = <String, int>{};

  try {
    // Chapters
    final chaptersFile = File('${dir.path}/chapters.json');
    final chapters = chaptersFile.existsSync()
        ? (json.decode(await chaptersFile.readAsString()) as List<dynamic>)
        : <dynamic>[];
    counts['chapters'] = chapters.length;
    final chapterIds = <String>{};
    for (final c in chapters) {
      final ch = c as Map<String, dynamic>;
      final id = ch['chapterId'] as String;
      if (!chapterIds.add(id)) {
        issues.add(Issue(IssueSeverity.error, 'DUPLICATE_CHAPTER_ID',
            'Duplicate chapterId: $id', affectedId: id));
      }
    }

    // Levels
    final levelsFile = File('${dir.path}/levels.json');
    final levels = levelsFile.existsSync()
        ? (json.decode(await levelsFile.readAsString()) as List<dynamic>)
        : <dynamic>[];
    counts['levels'] = levels.length;
    final levelIds = <String>{};
    final globalNums = <int>{};
    for (final l in levels) {
      final lv = l as Map<String, dynamic>;
      final id = lv['levelDefinitionId'] as String;
      final num = lv['globalLevelNumber'] as int;
      final chapId = lv['chapterId'] as String;
      if (!levelIds.add(id)) {
        issues.add(Issue(IssueSeverity.error, 'DUPLICATE_LEVEL_ID',
            'Duplicate levelDefinitionId: $id', affectedId: id));
      }
      if (!globalNums.add(num)) {
        issues.add(Issue(IssueSeverity.error, 'DUPLICATE_GLOBAL_LEVEL',
            'Duplicate globalLevelNumber: $num', affectedId: id));
      }
      if (!chapterIds.contains(chapId)) {
        issues.add(Issue(IssueSeverity.error, 'INVALID_CHAPTER_REF',
            'Level $id references unknown chapter: $chapId', affectedId: id));
      }
    }

    // Associations
    final assocFile = File('${dir.path}/associations.json');
    final assocs = assocFile.existsSync()
        ? (json.decode(await assocFile.readAsString()) as List<dynamic>)
        : <dynamic>[];
    counts['associations'] = assocs.length;
    final variantIds = <String>{};
    // Track clue usage for cooldown validation
    final cluesByVariant = <String, String>{};
    for (final a in assocs) {
      final av = a as Map<String, dynamic>;
      final vid = av['associationVariantId'] as String;
      final clue = av['associationClue'] as String;
      final members = av['memberCards'] as List<dynamic>? ?? [];

      if (!variantIds.add(vid)) {
        issues.add(Issue(IssueSeverity.error, 'DUPLICATE_VARIANT_ID',
            'Duplicate associationVariantId: $vid', affectedId: vid));
      }
      if (members.length < 2) {
        issues.add(Issue(IssueSeverity.error, 'INVALID_GROUP_SIZE',
            'AssociationVariant $vid needs at least 2 member cards.', affectedId: vid));
      }
      cluesByVariant[vid] = clue;

      // Approval state check (publishing pipeline)
      final arabicState = av['arabicReviewState'] as String? ?? '';
      final semanticState = av['semanticReviewState'] as String? ?? '';
      if (arabicState != 'approved') {
        issues.add(Issue(IssueSeverity.error, 'MISSING_ARABIC_APPROVAL',
            'AssociationVariant $vid missing Arabic approval.', affectedId: vid));
      }
      if (semanticState != 'approved') {
        issues.add(Issue(IssueSeverity.error, 'MISSING_SEMANTIC_APPROVAL',
            'AssociationVariant $vid missing semantic approval.', affectedId: vid));
      }
    }

    // Story beats
    final beatsFile = File('${dir.path}/story_beats.json');
    final beats = beatsFile.existsSync()
        ? (json.decode(await beatsFile.readAsString()) as List<dynamic>)
        : <dynamic>[];
    counts['storyBeats'] = beats.length;
    final beatIds = <String>{};
    for (final b in beats) {
      final bt = b as Map<String, dynamic>;
      final bid = bt['storyBeatId'] as String;
      if (!beatIds.add(bid)) {
        issues.add(Issue(IssueSeverity.error, 'DUPLICATE_BEAT_ID',
            'Duplicate storyBeatId: $bid', affectedId: bid));
      }
    }
  } catch (e) {
    issues.add(Issue(IssueSeverity.error, 'PARSE_ERROR',
        'Failed to parse content files: $e'));
  }

  sw.stop();
  return ValidateResult(
    isValid: !issues.any((i) => i.isBlocking),
    issues: issues,
    bundleVersion: bundleVersion,
    durationMs: sw.elapsedMilliseconds,
    counts: counts,
  );
}

void _printReport(ValidateResult result) {
  final status = result.isValid ? '✓ VALID' : '✗ INVALID';
  stdout.writeln('\n$status — Bundle: ${result.bundleVersion}');
  stdout.writeln('Duration: ${result.durationMs}ms');
  stdout.writeln('Counts: ${result.counts}');

  final errors = result.issues.where((i) => i.isBlocking).toList();
  final warnings = result.issues.where((i) => i.severity == IssueSeverity.warning).toList();
  final infos = result.issues.where((i) => i.severity == IssueSeverity.info).toList();

  if (errors.isNotEmpty) {
    stdout.writeln('\nErrors (${errors.length}):');
    for (final e in errors) {
      stdout.writeln('  [${e.code}] ${e.message}');
    }
  }
  if (warnings.isNotEmpty) {
    stdout.writeln('\nWarnings (${warnings.length}):');
    for (final w in warnings) {
      stdout.writeln('  [${w.code}] ${w.message}');
    }
  }
  if (infos.isNotEmpty) {
    stdout.writeln('\nInfo (${infos.length}):');
    for (final i in infos) {
      stdout.writeln('  [${i.code}] ${i.message}');
    }
  }
}
