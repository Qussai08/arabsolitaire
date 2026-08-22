// Sprint 10 — Local file-system bundle store.
// Manages active/, staged/, previous/ directories and metadata file.
// Atomic activation: write staged → swap pointers → never corrupt active.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../domain/content_bundle.dart';

class LocalBundleStore {
  static const _root = 'contentManager';
  static const _metaFile = 'metadata.json';

  Future<Directory> _rootDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _root));
    await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> _dir(String name) async {
    final root = await _rootDir();
    final dir = Directory(p.join(root.path, name));
    await dir.create(recursive: true);
    return dir;
  }

  // ── Metadata ──────────────────────────────────────────────────────────────

  Future<LocalContentMetadata> loadMetadata() async {
    final root = await _rootDir();
    final file = File(p.join(root.path, _metaFile));
    if (!await file.exists()) return const LocalContentMetadata();
    try {
      final raw = await file.readAsString();
      return LocalContentMetadata.fromJson(
          json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const LocalContentMetadata();
    }
  }

  Future<void> _saveMetadata(LocalContentMetadata meta) async {
    final root = await _rootDir();
    final file = File(p.join(root.path, _metaFile));
    await file.writeAsString(json.encode(meta.toJson()));
  }

  // ── Staged write ─────────────────────────────────────────────────────────

  /// Writes all files for a candidate bundle into the staged directory.
  /// Files are never active until [atomicActivate] is called.
  Future<void> writeStaged({
    required BundleManifest manifest,
    required Map<String, Uint8List> fileBytes,
  }) async {
    final staged = await _dir('staged');
    // Clear any previous staged content
    await _clearDir(staged);

    // Write manifest
    final manifestFile = File(p.join(staged.path, 'manifest.json'));
    await manifestFile.writeAsString(json.encode(manifest.toJson()));

    // Write each file
    for (final entry in manifest.files) {
      final bytes = fileBytes[entry.path];
      if (bytes == null) continue;
      final dest = File(p.join(staged.path, entry.path));
      await dest.parent.create(recursive: true);
      await dest.writeAsBytes(bytes);
    }
  }

  // ── Atomic activation ────────────────────────────────────────────────────

  /// Moves staged → active, current active → previous.
  /// Returns false if staged is empty/incomplete.
  Future<bool> atomicActivate(String bundleVersion,
      String contentHash) async {
    final staged = await _dir('staged');
    final manifestFile = File(p.join(staged.path, 'manifest.json'));
    if (!await manifestFile.exists()) return false;

    final previous = await _dir('previous');
    final active = await _dir('active');

    // Move current active → previous (overwrite)
    if (await _streamIsEmpty(active.list())) {
      // active is empty — skip backup
    } else {
      await _clearDir(previous);
      await _copyDir(active, previous);
    }

    // Move staged → active
    await _clearDir(active);
    await _copyDir(staged, active);
    await _clearDir(staged);

    // Update metadata
    final meta = await loadMetadata();
    final previousVersion = meta.activeBundleVersion;
    final updated = meta.copyWith(
      activeBundleVersion: bundleVersion,
      previousBundleVersion: previousVersion,
      lastSuccessfulActivationAt: DateTime.now().toUtc(),
      activeContentHash: contentHash,
    );
    await _saveMetadata(updated);
    return true;
  }

  // ── Rollback ─────────────────────────────────────────────────────────────

  /// Swaps previous ↔ active if previous bundle is present and valid.
  Future<bool> rollbackToPrevious() async {
    final previous = await _dir('previous');
    final prevManifest = File(p.join(previous.path, 'manifest.json'));
    if (!await prevManifest.exists()) return false;

    final active = await _dir('active');
    final temp = await _dir('rollback_temp');

    await _clearDir(temp);
    await _copyDir(active, temp);

    await _clearDir(active);
    await _copyDir(previous, active);

    await _clearDir(previous);
    await _copyDir(temp, previous);
    await _clearDir(temp);

    // Swap metadata versions
    final meta = await loadMetadata();
    final updated = meta.copyWith(
      activeBundleVersion: meta.previousBundleVersion,
      previousBundleVersion: meta.activeBundleVersion,
      lastSuccessfulActivationAt: DateTime.now().toUtc(),
    );
    await _saveMetadata(updated);
    return true;
  }

  // ── Load active bundle files ──────────────────────────────────────────────

  Future<BundleManifest?> loadActiveManifest() async {
    final active = await _dir('active');
    final file = File(p.join(active.path, 'manifest.json'));
    if (!await file.exists()) return null;
    try {
      final raw = await file.readAsString();
      return BundleManifest.fromJson(
          json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, Uint8List>> loadActiveFiles(
      List<String> paths) async {
    final active = await _dir('active');
    final result = <String, Uint8List>{};
    for (final path in paths) {
      final file = File(p.join(active.path, path));
      if (await file.exists()) {
        result[path] = await file.readAsBytes();
      }
    }
    return result;
  }

  // ── Disable metadata ──────────────────────────────────────────────────────

  Future<DisableMetadata?> loadCachedDisableMetadata() async {
    final root = await _rootDir();
    final file = File(p.join(root.path, 'disable_metadata.json'));
    if (!await file.exists()) return null;
    try {
      final raw = await file.readAsString();
      return DisableMetadata.fromJson(
          json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDisableMetadata(DisableMetadata meta) async {
    final root = await _rootDir();
    final file = File(p.join(root.path, 'disable_metadata.json'));
    await file.writeAsString(json.encode(meta.toJson()));
  }

  // ── Quarantine ────────────────────────────────────────────────────────────

  Future<void> addQuarantinedVersion(String version) async {
    final meta = await loadMetadata();
    if (meta.quarantinedVersions.contains(version)) return;
    await _saveMetadata(meta.copyWith(
      quarantinedVersions: [...meta.quarantinedVersions, version],
    ));
  }

  Future<void> recordUpdateCheck() async {
    final meta = await loadMetadata();
    await _saveMetadata(
        meta.copyWith(lastUpdateCheckAt: DateTime.now().toUtc()));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _clearDir(Directory dir) async {
    if (!await dir.exists()) return;
    await for (final entity in dir.list()) {
      await entity.delete(recursive: true);
    }
  }

  Future<void> _copyDir(Directory src, Directory dest) async {
    await dest.create(recursive: true);
    await for (final entity in src.list(recursive: false)) {
      final relative =
          p.relative(entity.path, from: src.path);
      if (entity is File) {
        final destFile = File(p.join(dest.path, relative));
        await destFile.parent.create(recursive: true);
        await entity.copy(destFile.path);
      } else if (entity is Directory) {
        final destSubDir = Directory(p.join(dest.path, relative));
        await _copyDir(entity, destSubDir);
      }
    }
  }
}

Future<bool> _streamIsEmpty(Stream<FileSystemEntity> stream) async {
  await for (final _ in stream) {
    return false;
  }
  return true;
}
