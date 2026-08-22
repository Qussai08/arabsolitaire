import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/economy/data/drift_wallet_repository.dart';
import 'package:mobile/features/economy/data/economy_repository.dart';
import 'package:mobile/features/economy/data/firebase_economy_repository.dart';
import 'package:mobile/features/economy/data/wallet_repository.dart';
import 'package:mobile/features/economy/domain/economy_models.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final db = ref.watch(appDatabaseProvider).valueOrNull;
  if (db == null) return const _NoOpWalletRepository();
  return DriftWalletRepository(db);
});

final economyRepositoryProvider = Provider<EconomyRepository>((ref) {
  try {
    return FirebaseEconomyRepository(FirebaseFunctions.instance);
  } catch (_) {
    return const OfflineEconomyRepository();
  }
});

final economyOperationRepositoryProvider =
    Provider<DriftEconomyOperationRepository?>((ref) {
  final db = ref.watch(appDatabaseProvider).valueOrNull;
  if (db == null) return null;
  return DriftEconomyOperationRepository(db);
});

/// No-op wallet repo for when DB is initializing.
final class _NoOpWalletRepository implements WalletRepository {
  const _NoOpWalletRepository();
  @override
  Future<WalletSnapshot> getSnapshot() async => WalletSnapshot.empty;
  @override
  Stream<WalletSnapshot> watchSnapshot() => Stream.value(WalletSnapshot.empty);
  @override
  Future<void> saveSnapshot(WalletSnapshot snapshot) async {}
  @override
  Future<void> applyPendingDelta({
    required int coinDelta,
    required int hintDelta,
  }) async {}
  @override
  Future<void> clearPendingDeltas() async {}
}
