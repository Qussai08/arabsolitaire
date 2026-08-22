import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobile/core/storage/app_database.dart' as db_lib;
import 'package:mobile/features/economy/data/wallet_repository.dart';
import 'package:mobile/features/economy/domain/economy_models.dart';

final class DriftWalletRepository implements WalletRepository {
  DriftWalletRepository(this._db);
  final db_lib.AppDatabase _db;
  static const _mainId = 'main';

  @override
  Future<WalletSnapshot> getSnapshot() async {
    final row = await (_db.select(_db.walletCacheRows)
          ..where((t) => t.id.equals(_mainId)))
        .getSingleOrNull();
    if (row == null) return WalletSnapshot.empty;
    return _rowToSnapshot(row);
  }

  @override
  Stream<WalletSnapshot> watchSnapshot() {
    return (_db.select(_db.walletCacheRows)
          ..where((t) => t.id.equals(_mainId)))
        .watchSingleOrNull()
        .map((row) => row == null ? WalletSnapshot.empty : _rowToSnapshot(row));
  }

  @override
  Future<void> saveSnapshot(WalletSnapshot snapshot) async {
    await _db.into(_db.walletCacheRows).insertOnConflictUpdate(
          db_lib.WalletCacheRowsCompanion(
            id: const Value(_mainId),
            coinBalance: Value(snapshot.coinBalance),
            hintBalance: Value(snapshot.hintBalance),
            pendingCoinDelta: Value(snapshot.pendingCoinDelta),
            pendingHintDelta: Value(snapshot.pendingHintDelta),
            walletRevision: Value(snapshot.walletRevision),
            lastReconciledAt: Value(snapshot.lastReconciledAt),
            isStale: Value(snapshot.isStale),
          ),
        );
  }

  @override
  Future<void> applyPendingDelta({
    required int coinDelta,
    required int hintDelta,
  }) async {
    final current = await getSnapshot();
    await saveSnapshot(
      current.copyWith(
        pendingCoinDelta: current.pendingCoinDelta + coinDelta,
        pendingHintDelta: current.pendingHintDelta + hintDelta,
      ),
    );
  }

  @override
  Future<void> clearPendingDeltas() async {
    await (_db.update(_db.walletCacheRows)
          ..where((t) => t.id.equals(_mainId)))
        .write(
          const db_lib.WalletCacheRowsCompanion(
            pendingCoinDelta: Value(0),
            pendingHintDelta: Value(0),
          ),
        );
  }

  static WalletSnapshot _rowToSnapshot(db_lib.WalletCacheRow row) {
    return WalletSnapshot(
      coinBalance: row.coinBalance,
      hintBalance: row.hintBalance,
      pendingCoinDelta: row.pendingCoinDelta,
      pendingHintDelta: row.pendingHintDelta,
      walletRevision: row.walletRevision,
      lastReconciledAt: row.lastReconciledAt,
      isStale: row.isStale,
    );
  }
}

/// Local economy operation queue (durable pending ops).
final class DriftEconomyOperationRepository {
  DriftEconomyOperationRepository(this._db);
  final db_lib.AppDatabase _db;

  Future<void> enqueue(EconomyOperation op) async {
    await _db.into(_db.economyOperationRows).insertOnConflictUpdate(
          db_lib.EconomyOperationRowsCompanion(
            operationId: Value(op.operationId),
            operationType: Value(op.type.name),
            idempotencyKey: Value(op.idempotencyKey),
            payloadJson: Value(jsonEncode(op.payload)),
            createdAt: Value(op.createdAt),
            coinDelta: Value(op.coinDelta),
            hintDelta: Value(op.hintDelta),
            status: Value(op.status.name),
            attemptCount: Value(op.attemptCount),
            nextRetryAt: Value(op.nextRetryAt),
            serverTransactionId: Value(op.serverTransactionId),
          ),
        );
  }

  Future<List<EconomyOperation>> loadPending() async {
    final rows = await (_db.select(_db.economyOperationRows)
          ..where(
            (t) =>
                t.status.isIn([
                  EconomyOperationStatus.pending.name,
                  EconomyOperationStatus.retryable.name,
                ]) &
                (t.nextRetryAt.isNull() |
                    t.nextRetryAt.isSmallerThanValue(
                        DateTime.now().toUtc())),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_rowToOp).toList();
  }

  Future<void> markCompleted(
    String operationId, {
    required String serverTransactionId,
  }) async {
    await (_db.update(_db.economyOperationRows)
          ..where((t) => t.operationId.equals(operationId)))
        .write(
          db_lib.EconomyOperationRowsCompanion(
            status: Value(EconomyOperationStatus.completed.name),
            serverTransactionId: Value(serverTransactionId),
          ),
        );
  }

  Future<void> markFailed(
    String operationId, {
    required bool retryable,
    Duration backoff = const Duration(minutes: 2),
  }) async {
    final row = await (_db.select(_db.economyOperationRows)
          ..where((t) => t.operationId.equals(operationId)))
        .getSingleOrNull();
    if (row == null) return;
    final nextRetry =
        retryable ? DateTime.now().toUtc().add(backoff) : null;
    await (_db.update(_db.economyOperationRows)
          ..where((t) => t.operationId.equals(operationId)))
        .write(
          db_lib.EconomyOperationRowsCompanion(
            status: Value(retryable
                ? EconomyOperationStatus.retryable.name
                : EconomyOperationStatus.failed.name),
            attemptCount: Value(row.attemptCount + 1),
            nextRetryAt: Value(nextRetry),
          ),
        );
  }

  Future<void> purgeCompleted() async {
    await (_db.delete(_db.economyOperationRows)
          ..where(
            (t) => t.status.equals(EconomyOperationStatus.completed.name),
          ))
        .go();
  }

  static EconomyOperation _rowToOp(db_lib.EconomyOperationRow row) {
    return EconomyOperation(
      operationId: row.operationId,
      type: EconomyOperationType.values.byName(row.operationType),
      idempotencyKey: row.idempotencyKey,
      payload: jsonDecode(row.payloadJson) as Map<String, dynamic>,
      createdAt: row.createdAt,
      coinDelta: row.coinDelta,
      hintDelta: row.hintDelta,
      status: EconomyOperationStatus.values.byName(row.status),
      attemptCount: row.attemptCount,
      nextRetryAt: row.nextRetryAt,
      serverTransactionId: row.serverTransactionId,
    );
  }
}
