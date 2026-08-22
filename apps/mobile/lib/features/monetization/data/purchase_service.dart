import 'package:mobile/features/monetization/domain/monetization_models.dart';

/// Abstract IAP service — decouples store SDK from application logic.
abstract interface class PurchaseService {
  /// Load available products from the store.
  Future<List<PurchaseProduct>> loadProducts(List<String> productIds);

  /// Purchase a product. Returns the purchase state.
  Future<PurchaseState> purchase(String productId);

  /// Restore previous non-consumable purchases.
  Future<List<PurchaseState>> restorePurchases();

  /// Acknowledge/complete a pending purchase.
  Future<void> completePurchase(PurchaseState state);
}

/// No-op offline purchase service.
final class NoOpPurchaseService implements PurchaseService {
  const NoOpPurchaseService();

  @override
  Future<List<PurchaseProduct>> loadProducts(
          List<String> productIds) async =>
      [];

  @override
  Future<PurchaseState> purchase(String productId) async =>
      PurchaseState(
        productId: productId,
        status: PurchaseStatus.error,
        error: 'Store not available',
      );

  @override
  Future<List<PurchaseState>> restorePurchases() async => [];

  @override
  Future<void> completePurchase(PurchaseState state) async {}
}

/// Flutter in_app_purchase-backed service.
/// Full wiring requires the `in_app_purchase` package and platform config.
///
/// Architecture stub — SDK wired at platform integration step.
final class StorePurchaseService implements PurchaseService {
  const StorePurchaseService();

  @override
  Future<List<PurchaseProduct>> loadProducts(
      List<String> productIds) async {
    // TODO: final ProductDetailsResponse resp =
    //     await InAppPurchase.instance.queryProductDetails(productIds.toSet());
    // Map resp.productDetails -> PurchaseProduct.
    return [];
  }

  @override
  Future<PurchaseState> purchase(String productId) async {
    // TODO: final purchaseParam = PurchaseParam(
    //     productDetails: details);
    // InAppPurchase.instance.buyConsumable / buyNonConsumable.
    return PurchaseState(
      productId: productId,
      status: PurchaseStatus.error,
      error: 'Store SDK not yet integrated',
    );
  }

  @override
  Future<List<PurchaseState>> restorePurchases() async {
    // TODO: InAppPurchase.instance.restorePurchases();
    return [];
  }

  @override
  Future<void> completePurchase(PurchaseState state) async {
    // TODO: InAppPurchase.instance.completePurchase(purchase);
  }
}
