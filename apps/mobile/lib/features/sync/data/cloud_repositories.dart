import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/features/sync/domain/cloud_dtos.dart';

/// Paths in Firestore.
abstract final class FirestorePaths {
  static String playerDoc(String uid) => 'players/$uid';
  static String progressionDoc(String uid) =>
      'players/$uid/state/progression';
  static String storyDoc(String uid) => 'players/$uid/state/story';
  static String settingsDoc(String uid) => 'players/$uid/state/settings';
}

// ── Cloud Progression Repository ─────────────────────────────────────────────

abstract interface class CloudProgressionRepository {
  Future<CloudProgressionDto?> load(String uid);
  Future<void> upsert(String uid, CloudProgressionDto dto);
}

final class FirestoreProgressionRepository
    implements CloudProgressionRepository {
  FirestoreProgressionRepository(this._db);
  final FirebaseFirestore _db;

  @override
  Future<CloudProgressionDto?> load(String uid) async {
    try {
      final snap =
          await _db.doc(FirestorePaths.progressionDoc(uid)).get();
      if (!snap.exists) return null;
      final data = snap.data()!;
      final dto = CloudProgressionDto.fromMap(data);
      if (!dto.isSupported) return null;
      return dto;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> upsert(String uid, CloudProgressionDto dto) async {
    await _db.doc(FirestorePaths.progressionDoc(uid)).set(
      {
        ...dto.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}

// ── Cloud Story Repository ────────────────────────────────────────────────────

abstract interface class CloudStoryRepository {
  Future<CloudStoryDto?> load(String uid);
  Future<void> upsert(String uid, CloudStoryDto dto);
}

final class FirestoreStoryRepository implements CloudStoryRepository {
  FirestoreStoryRepository(this._db);
  final FirebaseFirestore _db;

  @override
  Future<CloudStoryDto?> load(String uid) async {
    try {
      final snap = await _db.doc(FirestorePaths.storyDoc(uid)).get();
      if (!snap.exists) return null;
      final dto = CloudStoryDto.fromMap(snap.data()!);
      if (!dto.isSupported) return null;
      return dto;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> upsert(String uid, CloudStoryDto dto) async {
    await _db.doc(FirestorePaths.storyDoc(uid)).set(
      {
        ...dto.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}

// ── Cloud Settings Repository ─────────────────────────────────────────────────

abstract interface class CloudSettingsRepository {
  Future<CloudSettingsDto?> load(String uid);
  Future<void> upsert(String uid, CloudSettingsDto dto);
}

final class FirestoreSettingsRepository implements CloudSettingsRepository {
  FirestoreSettingsRepository(this._db);
  final FirebaseFirestore _db;

  @override
  Future<CloudSettingsDto?> load(String uid) async {
    try {
      final snap =
          await _db.doc(FirestorePaths.settingsDoc(uid)).get();
      if (!snap.exists) return null;
      final dto = CloudSettingsDto.fromMap(snap.data()!);
      if (!dto.isSupported) return null;
      return dto;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> upsert(String uid, CloudSettingsDto dto) async {
    await _db.doc(FirestorePaths.settingsDoc(uid)).set(
      {
        ...dto.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}

// ── Player Profile Repository ─────────────────────────────────────────────────

final class FirestorePlayerProfileRepository {
  FirestorePlayerProfileRepository(this._db);
  final FirebaseFirestore _db;

  Future<void> createOrUpdateProfile(
    String uid, {
    required String authType,
    required List<String> linkedProviders,
  }) async {
    final doc = _db.doc(FirestorePaths.playerDoc(uid));
    await doc.set(
      {
        'schemaVersion': 1,
        'authType': authType,
        'linkedProviders': linkedProviders,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}

/// Offline no-op repositories used when Firebase is unavailable.
final class OfflineProgressionRepository implements CloudProgressionRepository {
  const OfflineProgressionRepository();
  @override
  Future<CloudProgressionDto?> load(String uid) async => null;
  @override
  Future<void> upsert(String uid, CloudProgressionDto dto) async {}
}

final class OfflineStoryRepository implements CloudStoryRepository {
  const OfflineStoryRepository();
  @override
  Future<CloudStoryDto?> load(String uid) async => null;
  @override
  Future<void> upsert(String uid, CloudStoryDto dto) async {}
}

final class OfflineSettingsRepository implements CloudSettingsRepository {
  const OfflineSettingsRepository();
  @override
  Future<CloudSettingsDto?> load(String uid) async => null;
  @override
  Future<void> upsert(String uid, CloudSettingsDto dto) async {}
}
