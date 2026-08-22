/// Sync domain models.
library;

enum SyncStatus { idle, syncing, synced, offline, recoverableError, conflict }

enum SyncOperationType {
  upsertProgression,
  upsertSettings,
  upsertStoryProgress,
  markTutorialCompleted,
  createCloudProfile,
}

final class SyncMetadata {
  const SyncMetadata({
    this.lastSuccessfulSyncAt,
    this.lastCloudRevision = 0,
    this.pendingOperationsCount = 0,
    this.lastSyncErrorCode,
    this.identityUid,
    this.syncSchemaVersion = 1,
  });

  final DateTime? lastSuccessfulSyncAt;
  final int lastCloudRevision;
  final int pendingOperationsCount;
  final String? lastSyncErrorCode;
  final String? identityUid;
  final int syncSchemaVersion;
}

final class SyncOperation {
  const SyncOperation({
    required this.operationId,
    required this.operationType,
    required this.payload,
    required this.createdAt,
    required this.idempotencyKey,
    this.attemptCount = 0,
    this.status = SyncOperationStatus.pending,
    this.nextRetryAt,
  });

  final String operationId;
  final SyncOperationType operationType;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final String idempotencyKey;
  final int attemptCount;
  final SyncOperationStatus status;
  final DateTime? nextRetryAt;
}

enum SyncOperationStatus { pending, inFlight, completed, failed, retryable }
