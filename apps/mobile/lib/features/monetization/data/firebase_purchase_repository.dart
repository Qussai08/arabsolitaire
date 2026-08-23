import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile/features/monetization/domain/monetization_models.dart';

/// Result of server-side purchase validation.
sealed class PurchaseValidationResult {
  const PurchaseValidationResult();
}

final class PurchaseGranted extends PurchaseValidationResult {
  const PurchaseGranted({
    this.coinGrant,
    this.entitlementType,
    this.idempotent = false,
  });
  final int? coinGrant;
  final String? entitlementType;
  final bool idempotent;
}

final class PurchaseValidationFailed extends PurchaseValidationResult {
  const PurchaseValidationFailed(this.message);
  final String message;
}

/// Client-side interface to the purchase Cloud Functions.
abstract interface class PurchaseRepository {
  Future<PurchaseValidationResult> validateAndGrant({
    required String productId,
    required String purchaseToken,
    required String platform,
    required String idempotencyKey,
  });

  Future<List<Entitlement>> restoreEntitlements();
}

final class FirebasePurchaseRepository implements PurchaseRepository {
  FirebasePurchaseRepository(this._functions);
  final FirebaseFunctions _functions;

  @override
  Future<PurchaseValidationResult> validateAndGrant({
    required String productId,
    required String purchaseToken,
    required String platform,
    required String idempotencyKey,
  }) async {
    try {
      final callable = _functions.httpsCallable('validateAndGrantPurchase');
      final result = await callable.call<Map<Object?, Object?>>({
        'productId': productId,
        'purchaseToken': purchaseToken,
        'platform': platform,
        'idempotencyKey': idempotencyKey,
      });
      final data = (result.data).cast<String, dynamic>();
      return PurchaseGranted(
        coinGrant: data['coinGrant'] as int?,
        entitlementType: data['entitlementType'] as String?,
        idempotent: data['idempotent'] as bool? ?? false,
      );
    } on FirebaseFunctionsException catch (e) {
      return PurchaseValidationFailed(e.message ?? e.code);
    } catch (e) {
      return PurchaseValidationFailed(e.toString());
    }
  }

  @override
  Future<List<Entitlement>> restoreEntitlements() async {
    try {
      final callable = _functions.httpsCallable('restoreEntitlements');
      final result = await callable.call<Map<Object?, Object?>>(
        <String, dynamic>{},
      );
      final data = (result.data).cast<String, dynamic>();
      final list =
          (data['entitlements'] as List?)?.cast<Map<Object?, Object?>>() ??
          <Map<Object?, Object?>>[];
      return list.map((e) {
        final map = e.cast<String, Object?>();
        return Entitlement(
          type: EntitlementType.values.firstWhere(
            (t) => t.name == (map['entitlementType'] as String?),
            orElse: () => EntitlementType.removeInterstitialAds,
          ),
          active: (map['active'] as bool?) ?? false,
          source: (map['source'] as String?) ?? 'iap',
          storeProductId: map['storeProductId'] as String?,
          purchaseId: map['purchaseId'] as String?,
          revision: (map['revision'] as int?) ?? 0,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}

/// Offline / test stub.
final class OfflinePurchaseRepository implements PurchaseRepository {
  const OfflinePurchaseRepository();

  @override
  Future<PurchaseValidationResult> validateAndGrant({
    required String productId,
    required String purchaseToken,
    required String platform,
    required String idempotencyKey,
  }) async => const PurchaseValidationFailed('Offline');

  @override
  Future<List<Entitlement>> restoreEntitlements() async => [];
}
