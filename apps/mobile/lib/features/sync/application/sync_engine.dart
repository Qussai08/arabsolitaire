import 'package:mobile/features/account/data/auth_repository.dart';
import 'package:mobile/features/journey/data/journey_repository.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
import 'package:mobile/features/sync/data/cloud_repositories.dart';
import 'package:mobile/features/sync/data/drift_sync_queue_repository.dart';
import 'package:mobile/features/sync/domain/cloud_dtos.dart';
import 'package:mobile/features/sync/domain/sync_merge_policy.dart';
import 'package:mobile/features/sync/domain/sync_models.dart';

/// Orchestrates offline-first sync: enqueue → flush → merge.
final class SyncEngine {
  SyncEngine({
    required AuthRepository authRepository,
    required JourneyRepository journeyRepository,
    required DriftSyncQueueRepository syncQueue,
    required this._cloudProgression,
    required this._cloudStory,
    required this._cloudSettings,
  })  : _auth = authRepository,
        _journey = journeyRepository,
        _queue = syncQueue;

  final AuthRepository _auth;
  final JourneyRepository _journey;
  final DriftSyncQueueRepository _queue;
  final CloudProgressionRepository _cloudProgression;
  final CloudStoryRepository _cloudStory;
  // ignore: unused_field
  final CloudSettingsRepository _cloudSettings;

  // ── Enqueue helpers ────────────────────────────────────────────────────────

  Future<void> enqueueProgressionUpsert(JourneyProgress progress) async {
    final op = SyncOperation(
      operationId:
          'progression_${DateTime.now().millisecondsSinceEpoch}',
      operationType: SyncOperationType.upsertProgression,
      payload: {
        'highestCompletedLevel': progress.highestCompletedLevel,
        'highestUnlockedLevel': progress.highestUnlockedLevel,
        'completedLevelIds': progress.completedLevelIds.toList(),
        'completedChapterIds': progress.completedChapterIds.toList(),
      },
      createdAt: DateTime.now().toUtc(),
      idempotencyKey:
          'progression_v${progress.highestCompletedLevel}_${progress.completedLevelIds.length}',
    );
    await _queue.enqueue(op);
  }

  Future<void> enqueueStoryUpsert(PlayerLocalFlags flags) async {
    final op = SyncOperation(
      operationId: 'story_${DateTime.now().millisecondsSinceEpoch}',
      operationType: SyncOperationType.upsertStoryProgress,
      payload: {
        'unlockedStoryBeatIds': flags.unlockedStoryBeatIds.toList(),
        'viewedStoryBeatIds': flags.viewedStoryBeatIds.toList(),
        'onboardingCompleted': flags.onboardingCompleted,
        'tutorialCompleted': flags.tutorialCompleted,
      },
      createdAt: DateTime.now().toUtc(),
      idempotencyKey:
          'story_v${flags.unlockedStoryBeatIds.length}_${flags.viewedStoryBeatIds.length}',
    );
    await _queue.enqueue(op);
  }

  // ── Flush queue ────────────────────────────────────────────────────────────

  /// Flush pending ops to Firebase. No-ops if not authenticated.
  Future<SyncStatus> flush() async {
    final uid = _auth.currentUid;
    if (uid == null) return SyncStatus.offline;

    final ops = await _queue.loadPending();
    if (ops.isEmpty) return SyncStatus.synced;

    var anyFailed = false;
    for (final op in ops) {
      try {
        await _executeOperation(uid, op);
        await _queue.markCompleted(op.operationId);
      } catch (_) {
        await _queue.markFailed(
          op.operationId,
          retryable: true,
        );
        anyFailed = true;
      }
    }
    await _queue.purgeCompleted();
    return anyFailed ? SyncStatus.recoverableError : SyncStatus.synced;
  }

  // ── Merge from cloud ───────────────────────────────────────────────────────

  /// Pull cloud state, merge with local (highest valid wins), persist.
  Future<SyncStatus> pullAndMerge() async {
    final uid = _auth.currentUid;
    if (uid == null) return SyncStatus.offline;

    try {
      final localProgress = await _journey.loadProgress();
      final localFlags = await _journey.loadFlags();

      final cloudProgression =
          await _cloudProgression.load(uid);
      final cloudStory = await _cloudStory.load(uid);

      final mergedProgress =
          SyncMergePolicy.mergeProgression(localProgress, cloudProgression);
      final mergedFlags =
          SyncMergePolicy.mergeStory(localFlags, cloudStory);

      await _journey.saveProgress(mergedProgress);
      await _journey.saveFlags(mergedFlags);

      return SyncStatus.synced;
    } catch (_) {
      return SyncStatus.recoverableError;
    }
  }

  // ── Execute a single operation ─────────────────────────────────────────────

  Future<void> _executeOperation(String uid, SyncOperation op) async {
    switch (op.operationType) {
      case SyncOperationType.upsertProgression:
        final p = op.payload;
        final dto = CloudProgressionDto(
          schemaVersion: CloudProgressionDto.currentSchema,
          contentVersion: 1,
          highestCompletedLevel: p['highestCompletedLevel'] as int,
          revision: DateTime.now().millisecondsSinceEpoch,
        );
        await _cloudProgression.upsert(uid, dto);

      case SyncOperationType.upsertStoryProgress:
        final p = op.payload;
        final dto = CloudStoryDto(
          schemaVersion: CloudStoryDto.currentSchema,
          unlockedStoryBeatIds:
              (p['unlockedStoryBeatIds'] as List).cast<String>(),
          viewedStoryBeatIds:
              (p['viewedStoryBeatIds'] as List).cast<String>(),
          revision: DateTime.now().millisecondsSinceEpoch,
        );
        await _cloudStory.upsert(uid, dto);

      case SyncOperationType.upsertSettings:
      case SyncOperationType.markTutorialCompleted:
      case SyncOperationType.createCloudProfile:
        break;
    }
  }
}
