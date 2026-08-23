// Sprint 10 — Remote content manifest discovery + bundle download.
// Uses Firebase Storage for immutable versioned bundle files.
// Uses Firestore for the lightweight active-pointer control document.

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../domain/content_bundle.dart';

// Firestore: /content/pointer/current
// Storage:   content/{env}/bundles/{bundleVersion}/...

class RemoteContentRepository {
  RemoteContentRepository({
    this.environment = 'prod',
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  final String environment;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  // ── Active pointer discovery ──────────────────────────────────────────────

  Future<RemoteContentPointer?> fetchActivePointer() async {
    try {
      final doc = await _firestore
          .collection('content')
          .doc('pointer')
          .get(const GetOptions(source: Source.serverAndCache));
      if (!doc.exists || doc.data() == null) return null;
      return RemoteContentPointer.fromJson(doc.data()!);
    } catch (_) {
      return null;
    }
  }

  // ── Disable metadata (lightweight, fetched more often than full bundle) ───

  Future<DisableMetadata?> fetchDisableMetadata() async {
    try {
      final doc = await _firestore
          .collection('content')
          .doc('disableMetadata')
          .get(const GetOptions(source: Source.serverAndCache));
      if (!doc.exists || doc.data() == null) return null;
      final data = doc.data()!;
      return DisableMetadata.fromJson({
        ...data,
        'fetchedAt': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      return null;
    }
  }

  // ── Bundle manifest download ──────────────────────────────────────────────

  Future<BundleManifest?> fetchManifest(String bundleVersion) async {
    final path = 'content/$environment/bundles/$bundleVersion/manifest.json';
    try {
      final ref = _storage.ref(path);
      final bytes = await ref.getData();
      if (bytes == null) return null;
      final raw = utf8.decode(bytes);
      return BundleManifest.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // ── Bundle file download ──────────────────────────────────────────────────

  Future<Map<String, Uint8List>> downloadBundleFiles(
    String bundleVersion,
    List<BundleFileEntry> entries,
  ) async {
    final result = <String, Uint8List>{};
    for (final entry in entries) {
      final path = 'content/$environment/bundles/$bundleVersion/${entry.path}';
      try {
        final ref = _storage.ref(path);
        final bytes = await ref.getData();
        if (bytes != null) {
          result[entry.path] = bytes;
        }
      } catch (_) {
        // caller checks missing files
      }
    }
    return result;
  }
}
