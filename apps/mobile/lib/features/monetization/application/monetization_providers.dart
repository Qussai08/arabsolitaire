import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/monetization/data/ad_service.dart';
import 'package:mobile/features/monetization/data/admob_ad_service.dart';
import 'package:mobile/features/monetization/data/drift_monetization_repository.dart';
import 'package:mobile/features/monetization/data/firebase_purchase_repository.dart';
import 'package:mobile/features/monetization/data/monetization_repository.dart';
import 'package:mobile/features/monetization/data/purchase_service.dart';

final adServiceProvider = Provider<AdService>((ref) {
  // AdMob test mode enabled; flip to false before store release.
  return AdMobAdService(testMode: true);
});

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return const StorePurchaseService();
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  try {
    return FirebasePurchaseRepository(FirebaseFunctions.instance);
  } catch (_) {
    return const OfflinePurchaseRepository();
  }
});

final entitlementRepositoryProvider =
    Provider<EntitlementRepository?>((ref) {
  final db = ref.watch(appDatabaseProvider).valueOrNull;
  if (db == null) return null;
  return DriftEntitlementRepository(db);
});

final monetizationStateRepositoryProvider =
    Provider<MonetizationStateRepository?>((ref) {
  final db = ref.watch(appDatabaseProvider).valueOrNull;
  if (db == null) return null;
  return DriftMonetizationStateRepository(db);
});

final rewardedAdReceiptRepositoryProvider =
    Provider<RewardedAdReceiptRepository?>((ref) {
  final db = ref.watch(appDatabaseProvider).valueOrNull;
  if (db == null) return null;
  return DriftRewardedAdReceiptRepository(db);
});
