import 'package:mobile/features/monetization/domain/monetization_models.dart';

/// Local read/write repository for persisted monetization state.
abstract interface class EntitlementRepository {
  Future<Entitlement> getEntitlement(EntitlementType type);
  Stream<Entitlement> watchEntitlement(EntitlementType type);
  Future<void> saveEntitlement(Entitlement entitlement);
}

abstract interface class MonetizationStateRepository {
  Future<MonetizationContext> loadContext();
  Future<void> saveContext(MonetizationContext ctx);
  Future<void> incrementLevelsSinceInterstitial();
  Future<void> resetLevelsSinceInterstitial();
}

abstract interface class RewardedAdReceiptRepository {
  Future<void> saveReceipt(RewardedAdReceipt receipt);
  Future<List<RewardedAdReceipt>> loadPendingReceipts();
  Future<void> markBackendGranted(String operationId);
  Future<void> markLocalEffectApplied(String operationId);
  Future<void> purgeCompleted();
}
