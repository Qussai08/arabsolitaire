import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/account/data/auth_repository.dart';
import 'package:mobile/features/account/data/firebase_auth_repository.dart';
import 'package:mobile/features/journey/data/journey_providers.dart';
import 'package:mobile/features/sync/application/sync_engine.dart';
import 'package:mobile/features/sync/data/cloud_repositories.dart';
import 'package:mobile/features/sync/data/drift_sync_queue_repository.dart';

// ── Auth ──────────────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  try {
    return FirebaseAuthRepository(FirebaseAuth.instance);
  } catch (_) {
    return const OfflineAuthRepository();
  }
});

// ── Cloud repositories ────────────────────────────────────────────────────────

final cloudProgressionRepositoryProvider = Provider<CloudProgressionRepository>(
  (ref) {
    try {
      return FirestoreProgressionRepository(FirebaseFirestore.instance);
    } catch (_) {
      return const OfflineProgressionRepository();
    }
  },
);

final cloudStoryRepositoryProvider = Provider<CloudStoryRepository>((ref) {
  try {
    return FirestoreStoryRepository(FirebaseFirestore.instance);
  } catch (_) {
    return const OfflineStoryRepository();
  }
});

final cloudSettingsRepositoryProvider = Provider<CloudSettingsRepository>((
  ref,
) {
  try {
    return FirestoreSettingsRepository(FirebaseFirestore.instance);
  } catch (_) {
    return const OfflineSettingsRepository();
  }
});

// ── Sync queue ────────────────────────────────────────────────────────────────

final syncQueueRepositoryProvider = Provider<DriftSyncQueueRepository?>((ref) {
  final db = ref.watch(appDatabaseProvider).valueOrNull;
  if (db == null) return null;
  return DriftSyncQueueRepository(db);
});

// ── Sync engine ───────────────────────────────────────────────────────────────

final syncEngineProvider = Provider<SyncEngine?>((ref) {
  final queue = ref.watch(syncQueueRepositoryProvider);
  if (queue == null) return null;

  return SyncEngine(
    authRepository: ref.watch(authRepositoryProvider),
    journeyRepository: ref.watch(journeyRepositoryProvider),
    syncQueue: queue,
    cloudProgression: ref.watch(cloudProgressionRepositoryProvider),
    cloudStory: ref.watch(cloudStoryRepositoryProvider),
    cloudSettings: ref.watch(cloudSettingsRepositoryProvider),
  );
});
