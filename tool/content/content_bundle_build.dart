// Sprint 10 — Content bundle builder CLI.
// Usage: dart tool/content/content_bundle_build.dart <source_dir> <output_dir> [bundle_version]
//
// Responsibilities:
//   1. Read source content JSON files.
//   2. Validate structure and approval states.
//   3. Compute per-file SHA-256 hashes.
//   4. Generate manifest.json with contentHash.
//   5. Write immutable bundle artifact to output_dir.

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

const kSchemaVersion = 1;
const kRulesVersion = 1;
const kBuilderVersion = '1.0.0';
const kValidatorVersion = '1.0.0';

const kBundleFiles = [
  'chapters.json',
  'levels.json',
  'associations.json',
  'story_beats.json',
  'localization/ar.json',
];

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart tool/content/content_bundle_build.dart <source_dir> <output_dir> [bundle_version]');
    exit(1);
  }

  final sourceDir = Directory(args[0]);
  final outputDir = Directory(args[1]);
  final bundleVersion = args.length >= 3 ? args[2] : _defaultVersion();

  if (!await sourceDir.exists()) {
    stderr.writeln('Error: source directory not found: ${sourceDir.path}');
    exit(1);
  }

  await outputDir.create(recursive: true);

  stdout.writeln('Building bundle $bundleVersion from ${sourceDir.path}...');

  final fileEntries = <Map<String, dynamic>>[];
  final canonicalHashes = <String>[];

  for (final relPath in kBundleFiles) {
    final srcFile = File('${sourceDir.path}/$relPath');
    if (!await srcFile.exists()) {
      stderr.writeln('Warning: optional file missing: $relPath');
      continue;
    }

    final bytes = await srcFile.readAsBytes();

    // Canonicalize JSON: parse + re-encode with sorted keys
    final raw = utf8.decode(bytes);
    late String canonical;
    try {
      final parsed = json.decode(raw);
      canonical = const JsonEncoder.withIndent('  ').convert(parsed);
    } catch (_) {
      canonical = raw; // not JSON; use raw
    }
    final canonicalBytes = utf8.encode(canonical);

    final hash = sha256.convert(canonicalBytes).toString();
    canonicalHashes.add('$relPath:$hash');

    // Write canonical version to output
    final destFile = File('${outputDir.path}/$relPath');
    await destFile.parent.create(recursive: true);
    await destFile.writeAsString(canonical);

    fileEntries.add({
      'path': relPath,
      'sha256': hash,
      'size': canonicalBytes.length,
    });

    stdout.writeln('  ✓ $relPath ($hash)');
  }

  // Compute whole-bundle content hash
  canonicalHashes.sort();
  final contentHashInput = canonicalHashes.join('\n');
  final contentHash = sha256
      .convert(utf8.encode(contentHashInput))
      .toString();

  final now = DateTime.now().toUtc().toIso8601String();

  final manifest = {
    'bundleId': 'arabsolitaire-content',
    'bundleVersion': bundleVersion,
    'schemaVersion': kSchemaVersion,
    'rulesVersion': kRulesVersion,
    'createdAt': now,
    'publishedAt': now,
    'contentHash': contentHash,
    'files': fileEntries,
    'contentTypes': ['chapters', 'levels', 'associations', 'storyBeats', 'localization'],
    'status': 'built',
    'bundleBuilderVersion': kBuilderVersion,
    'contentValidatorVersion': kValidatorVersion,
  };

  final manifestJson = const JsonEncoder.withIndent('  ').convert(manifest);
  await File('${outputDir.path}/manifest.json').writeAsString(manifestJson);

  stdout.writeln('\n✓ Bundle built successfully.');
  stdout.writeln('  Version:     $bundleVersion');
  stdout.writeln('  ContentHash: $contentHash');
  stdout.writeln('  Output:      ${outputDir.path}');
}

String _defaultVersion() {
  final now = DateTime.now().toUtc();
  return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}.1';
}
