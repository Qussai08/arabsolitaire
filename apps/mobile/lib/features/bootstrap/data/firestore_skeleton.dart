import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';

/// Firestore data-source boundary only (Sprint 0).
///
/// Do not trust client writes for authoritative economy operations.
final class FirestoreSkeleton {
  FirestoreSkeleton(this._ref);

  final Ref _ref;

  FirebaseFirestore? get _dbOrNull {
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  bool get isAvailable => _dbOrNull != null;

  Future<void> pingConnectivity() async {
    final logger = _ref.read(appLoggerProvider);
    final db = _dbOrNull;
    if (db == null) {
      logger.info('Firestore unavailable — local-only mode');
      return;
    }
    // No collection reads in Sprint 0 — boundary existence only.
    logger.info('Firestore client bound');
  }
}

final firestoreSkeletonProvider = Provider<FirestoreSkeleton>(
  FirestoreSkeleton.new,
);
