import 'package:drift/drift.dart';
import 'package:mobile/core/storage/app_database.dart' as db_lib;
import 'package:mobile/features/monetization/data/monetization_repository.dart';
import 'package:mobile/features/monetization/domain/monetization_models.dart';

// ── Entitlement ───────────────────────────────────────────────────────────────

final class DriftEntitlementRepository implements EntitlementRepository {
  DriftEntitlementRepository(this._db);
  final db_lib.AppDatabase _db;

  @override
  Future<Entitlement> getEntitlement(EntitlementType type) async {
    final row = await (_db.select(
      _db.entitlementRows,
    )..where((t) => t.entitlementType.equals(type.name))).getSingleOrNull();
    if (row == null) return Entitlement.noEntitlement;
    return _rowToEntitlement(row);
  }

  @override
  Stream<Entitlement> watchEntitlement(EntitlementType type) {
    return (_db.select(_db.entitlementRows)
          ..where((t) => t.entitlementType.equals(type.name)))
        .watchSingleOrNull()
        .map(
          (row) =>
              row == null ? Entitlement.noEntitlement : _rowToEntitlement(row),
        );
  }

  @override
  Future<void> saveEntitlement(Entitlement entitlement) async {
    await _db
        .into(_db.entitlementRows)
        .insertOnConflictUpdate(
          db_lib.EntitlementRowsCompanion(
            entitlementType: Value(entitlement.type.name),
            active: Value(entitlement.active),
            source: Value(entitlement.source),
            storeProductId: Value(entitlement.storeProductId),
            purchaseId: Value(entitlement.purchaseId),
            validatedAt: Value(entitlement.validatedAt),
            revision: Value(entitlement.revision),
          ),
        );
  }

  static Entitlement _rowToEntitlement(db_lib.EntitlementRow row) {
    return Entitlement(
      type: EntitlementType.values.firstWhere(
        (e) => e.name == row.entitlementType,
        orElse: () => EntitlementType.removeInterstitialAds,
      ),
      active: row.active,
      source: row.source,
      storeProductId: row.storeProductId,
      purchaseId: row.purchaseId,
      validatedAt: row.validatedAt,
      revision: row.revision,
    );
  }
}

// ── MonetizationState ─────────────────────────────────────────────────────────

final class DriftMonetizationStateRepository
    implements MonetizationStateRepository {
  DriftMonetizationStateRepository(this._db);
  final db_lib.AppDatabase _db;
  static const _mainId = 'main';

  @override
  Future<MonetizationContext> loadContext() async {
    final row = await (_db.select(
      _db.monetizationStateRows,
    )..where((t) => t.id.equals(_mainId))).getSingleOrNull();
    if (row == null) return const MonetizationContext();
    return MonetizationContext(
      levelsSinceLastInterstitial: row.levelsSinceLastInterstitial,
      lastRewardedAdAt: row.lastRewardedAdAt,
      lastPurchaseAt: row.lastPurchaseAt,
      lastTutorialCompletedAt: row.lastTutorialCompletedAt,
    );
  }

  @override
  Future<void> saveContext(MonetizationContext ctx) async {
    await _db
        .into(_db.monetizationStateRows)
        .insertOnConflictUpdate(
          db_lib.MonetizationStateRowsCompanion(
            id: const Value(_mainId),
            levelsSinceLastInterstitial: Value(ctx.levelsSinceLastInterstitial),
            lastRewardedAdAt: Value(ctx.lastRewardedAdAt),
            lastPurchaseAt: Value(ctx.lastPurchaseAt),
            lastTutorialCompletedAt: Value(ctx.lastTutorialCompletedAt),
          ),
        );
  }

  @override
  Future<void> incrementLevelsSinceInterstitial() async {
    final current = await loadContext();
    await saveContext(
      current.copyWith(
        levelsSinceLastInterstitial: current.levelsSinceLastInterstitial + 1,
      ),
    );
  }

  @override
  Future<void> resetLevelsSinceInterstitial() async {
    final current = await loadContext();
    await saveContext(current.copyWith(levelsSinceLastInterstitial: 0));
  }
}

// ── RewardedAdReceipt ─────────────────────────────────────────────────────────

final class DriftRewardedAdReceiptRepository
    implements RewardedAdReceiptRepository {
  DriftRewardedAdReceiptRepository(this._db);
  final db_lib.AppDatabase _db;

  @override
  Future<void> saveReceipt(RewardedAdReceipt receipt) async {
    await _db
        .into(_db.rewardedAdReceiptRows)
        .insertOnConflictUpdate(
          db_lib.RewardedAdReceiptRowsCompanion(
            operationId: Value(receipt.operationId),
            rewardType: Value(receipt.rewardType.name),
            adCompleted: Value(receipt.adCompleted),
            attemptId: Value(receipt.attemptId),
            backendGranted: Value(receipt.backendGranted),
            localEffectApplied: Value(receipt.localEffectApplied),
          ),
        );
  }

  @override
  Future<List<RewardedAdReceipt>> loadPendingReceipts() async {
    final rows =
        await (_db.select(_db.rewardedAdReceiptRows)..where(
              (t) =>
                  t.backendGranted.equals(false) |
                  t.localEffectApplied.equals(false),
            ))
            .get();
    return rows.map(_rowToReceipt).toList();
  }

  @override
  Future<void> markBackendGranted(String operationId) async {
    await (_db.update(
      _db.rewardedAdReceiptRows,
    )..where((t) => t.operationId.equals(operationId))).write(
      const db_lib.RewardedAdReceiptRowsCompanion(backendGranted: Value(true)),
    );
  }

  @override
  Future<void> markLocalEffectApplied(String operationId) async {
    await (_db.update(
      _db.rewardedAdReceiptRows,
    )..where((t) => t.operationId.equals(operationId))).write(
      const db_lib.RewardedAdReceiptRowsCompanion(
        localEffectApplied: Value(true),
      ),
    );
  }

  @override
  Future<void> purgeCompleted() async {
    await (_db.delete(_db.rewardedAdReceiptRows)..where(
          (t) =>
              t.backendGranted.equals(true) & t.localEffectApplied.equals(true),
        ))
        .go();
  }

  static RewardedAdReceipt _rowToReceipt(db_lib.RewardedAdReceiptRow row) {
    return RewardedAdReceipt(
      operationId: row.operationId,
      rewardType: RewardedRewardType.values.firstWhere(
        (e) => e.name == row.rewardType,
        orElse: () => RewardedRewardType.coins,
      ),
      adCompleted: row.adCompleted,
      attemptId: row.attemptId,
      backendGranted: row.backendGranted,
      localEffectApplied: row.localEffectApplied,
      createdAt: row.createdAt,
    );
  }
}
