import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobile/core/storage/app_database.dart' as db_lib;
import 'package:mobile/features/sync/domain/sync_models.dart';

/// Drift-backed durable sync queue.
final class DriftSyncQueueRepository {
  DriftSyncQueueRepository(this._db);
  final db_lib.AppDatabase _db;

  Future<void> enqueue(SyncOperation op) async {
    await _db.into(_db.syncOperationRows).insertOnConflictUpdate(
          db_lib.SyncOperationRowsCompanion(
            operationId: Value(op.operationId),
            operationType: Value(op.operationType.name),
            payloadJson: Value(jsonEncode(op.payload)),
            idempotencyKey: Value(op.idempotencyKey),
            attemptCount: Value(op.attemptCount),
            status: Value(op.status.name),
            nextRetryAt: Value(op.nextRetryAt),
            createdAt: Value(op.createdAt),
          ),
        );
  }

  Future<List<SyncOperation>> loadPending() async {
    final rows = await (_db.select(_db.syncOperationRows)
          ..where(
            (t) =>
                t.status.isIn([
                  SyncOperationStatus.pending.name,
                  SyncOperationStatus.retryable.name,
                ]) &
                (t.nextRetryAt.isNull() |
                    t.nextRetryAt.isSmallerThanValue(DateTime.now().toUtc())),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_rowToOp).toList();
  }

  Future<void> markCompleted(String operationId) async {
    await (_db.update(_db.syncOperationRows)
          ..where((t) => t.operationId.equals(operationId)))
        .write(
          db_lib.SyncOperationRowsCompanion(
            status: Value(SyncOperationStatus.completed.name),
          ),
        );
  }

  Future<void> markFailed(
    String operationId, {
    required bool retryable,
    Duration backoff = const Duration(minutes: 5),
  }) async {
    final row = await (_db.select(_db.syncOperationRows)
          ..where((t) => t.operationId.equals(operationId)))
        .getSingleOrNull();
    if (row == null) return;
    final nextRetry = retryable
        ? DateTime.now().toUtc().add(backoff)
        : null;
    await (_db.update(_db.syncOperationRows)
          ..where((t) => t.operationId.equals(operationId)))
        .write(
          db_lib.SyncOperationRowsCompanion(
            status: Value(
                retryable
                    ? SyncOperationStatus.retryable.name
                    : SyncOperationStatus.failed.name),
            attemptCount: Value(row.attemptCount + 1),
            nextRetryAt: Value(nextRetry),
          ),
        );
  }

  Future<void> purgeCompleted() async {
    await (_db.delete(_db.syncOperationRows)
          ..where(
            (t) => t.status.equals(SyncOperationStatus.completed.name),
          ))
        .go();
  }

  static SyncOperation _rowToOp(db_lib.SyncOperationRow row) {
    return SyncOperation(
      operationId: row.operationId,
      operationType:
          SyncOperationType.values.byName(row.operationType),
      payload: jsonDecode(row.payloadJson) as Map<String, dynamic>,
      idempotencyKey: row.idempotencyKey,
      createdAt: row.createdAt,
      attemptCount: row.attemptCount,
      status: SyncOperationStatus.values.byName(row.status),
      nextRetryAt: row.nextRetryAt,
    );
  }
}
