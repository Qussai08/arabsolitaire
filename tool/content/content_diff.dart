// Sprint 10 — Content diff CLI.
// Usage: dart tool/content/content_diff.dart <bundle_a_dir> <bundle_b_dir>
//
// Shows added/changed/removed/disabled items between two bundle versions.
// Used before production promotion to confirm what changed.

import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart tool/content/content_diff.dart <bundle_a_dir> <bundle_b_dir>');
    exit(1);
  }

  final dirA = Directory(args[0]);
  final dirB = Directory(args[1]);

  if (!await dirA.exists()) {
    stderr.writeln('Error: bundle A not found: ${dirA.path}');
    exit(1);
  }
  if (!await dirB.exists()) {
    stderr.writeln('Error: bundle B not found: ${dirB.path}');
    exit(1);
  }

  final manifestA = await _loadManifest(dirA);
  final manifestB = await _loadManifest(dirB);

  stdout.writeln('\n=== Content Diff ===');
  stdout.writeln('From: ${manifestA?['bundleVersion'] ?? 'unknown'}');
  stdout.writeln('To:   ${manifestB?['bundleVersion'] ?? 'unknown'}');
  stdout.writeln('');

  await _diffEntities('Chapters', 'chapterId', dirA, dirB, 'chapters.json');
  await _diffEntities('Levels', 'levelDefinitionId', dirA, dirB, 'levels.json');
  await _diffEntities('Associations', 'associationVariantId', dirA, dirB, 'associations.json');
  await _diffEntities('Story Beats', 'storyBeatId', dirA, dirB, 'story_beats.json');
}

Future<Map<String, dynamic>?> _loadManifest(Directory dir) async {
  final file = File('${dir.path}/manifest.json');
  if (!await file.exists()) return null;
  return json.decode(await file.readAsString()) as Map<String, dynamic>;
}

Future<void> _diffEntities(
  String label,
  String idField,
  Directory dirA,
  Directory dirB,
  String filename,
) async {
  final fileA = File('${dirA.path}/$filename');
  final fileB = File('${dirB.path}/$filename');

  final listA = fileA.existsSync()
      ? (json.decode(await fileA.readAsString()) as List<dynamic>)
          .cast<Map<String, dynamic>>()
      : <Map<String, dynamic>>[];
  final listB = fileB.existsSync()
      ? (json.decode(await fileB.readAsString()) as List<dynamic>)
          .cast<Map<String, dynamic>>()
      : <Map<String, dynamic>>[];

  final mapA = {for (final e in listA) e[idField] as String: e};
  final mapB = {for (final e in listB) e[idField] as String: e};

  final added = mapB.keys.where((k) => !mapA.containsKey(k)).toList();
  final removed = mapA.keys.where((k) => !mapB.containsKey(k)).toList();
  final changed = mapB.keys.where((k) {
    if (!mapA.containsKey(k)) return false;
    return json.encode(mapA[k]) != json.encode(mapB[k]);
  }).toList();
  final disabledInB = mapB.values
      .where((e) => (e['enabled'] == false || e['status'] == 'disabled'))
      .map((e) => e[idField] as String)
      .toList();

  stdout.writeln('── $label ──');
  if (added.isEmpty && removed.isEmpty && changed.isEmpty && disabledInB.isEmpty) {
    stdout.writeln('  No changes.');
  } else {
    if (added.isNotEmpty) {
      stdout.writeln('  Added   (${added.length}): ${added.take(10).join(', ')}${added.length > 10 ? '...' : ''}');
    }
    if (changed.isNotEmpty) {
      stdout.writeln('  Changed (${changed.length}): ${changed.take(10).join(', ')}${changed.length > 10 ? '...' : ''}');
    }
    if (removed.isNotEmpty) {
      stdout.writeln('  Removed (${removed.length}): ${removed.take(10).join(', ')}${removed.length > 10 ? '...' : ''}');
    }
    if (disabledInB.isNotEmpty) {
      stdout.writeln('  Disabled (${disabledInB.length}): ${disabledInB.take(10).join(', ')}');
    }
  }
  stdout.writeln('');
}
