import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/monetization/application/interstitial_policy.dart';
import 'package:mobile/features/monetization/application/monetization_providers.dart';
import 'package:mobile/features/monetization/data/ad_service.dart';
import 'package:mobile/features/monetization/data/firebase_purchase_repository.dart';
import 'package:mobile/features/monetization/data/monetization_repository.dart';
import 'package:mobile/features/monetization/data/purchase_service.dart';
import 'package:mobile/features/monetization/domain/monetization_models.dart';

// ── View state ────────────────────────────────────────────────────────────────

sealed class MonetizationViewState {
  const MonetizationViewState();
}

final class MonetizationInitial extends MonetizationViewState {
  const MonetizationInitial();
}

final class MonetizationReady extends MonetizationViewState {
  const MonetizationReady({
    required this.context,
    required this.removeAdsEntitlement,
    required this.flags,
    required this.products,
    this.isProcessingAd = false,
    this.isProcessingPurchase = false,
  });

  final MonetizationContext context;
  final Entitlement removeAdsEntitlement;
  final MonetizationFlags flags;
  final List<PurchaseProduct> products;
  final bool isProcessingAd;
  final bool isProcessingPurchase;

  MonetizationReady copyWith({
    MonetizationContext? context,
    Entitlement? removeAdsEntitlement,
    MonetizationFlags? flags,
    List<PurchaseProduct>? products,
    bool? isProcessingAd,
    bool? isProcessingPurchase,
  }) => MonetizationReady(
    context: context ?? this.context,
    removeAdsEntitlement: removeAdsEntitlement ?? this.removeAdsEntitlement,
    flags: flags ?? this.flags,
    products: products ?? this.products,
    isProcessingAd: isProcessingAd ?? this.isProcessingAd,
    isProcessingPurchase: isProcessingPurchase ?? this.isProcessingPurchase,
  );
}

// ── Controller ────────────────────────────────────────────────────────────────

final class MonetizationController extends Notifier<MonetizationViewState> {
  @override
  MonetizationViewState build() {
    _initialize();
    return const MonetizationInitial();
  }

  AdService get _adService => ref.read(adServiceProvider);
  PurchaseService get _purchaseService => ref.read(purchaseServiceProvider);
  PurchaseRepository get _purchaseRepo => ref.read(purchaseRepositoryProvider);
  EntitlementRepository? get _entitlementRepo =>
      ref.read(entitlementRepositoryProvider);
  MonetizationStateRepository? get _stateRepo =>
      ref.read(monetizationStateRepositoryProvider);

  Future<void> _initialize() async {
    await _adService.initialize();
    final ctx = await _stateRepo?.loadContext() ?? const MonetizationContext();
    final entitlement =
        await _entitlementRepo?.getEntitlement(
          EntitlementType.removeInterstitialAds,
        ) ??
        Entitlement.noEntitlement;
    final products = await _purchaseService.loadProducts([
      MonetizationConfig.productRemoveAds,
      MonetizationConfig.productCoins1000,
      MonetizationConfig.productCoins3000,
      MonetizationConfig.productCoins7000,
      MonetizationConfig.productCoins15000,
    ]);
    state = MonetizationReady(
      context: ctx.copyWith(hasRemoveAdsEntitlement: entitlement.active),
      removeAdsEntitlement: entitlement,
      flags: MonetizationFlags.defaults,
      products: products,
    );
    // Prefetch rewarded ads.
    for (final placement in [
      AdPlacement.rewardedCoins,
      AdPlacement.rewardedHint,
    ]) {
      unawaited(_adService.loadRewardedAd(placement));
    }
  }

  // ── Rewarded ads ────────────────────────────────────────────────────────────

  Future<AdResult> showRewardedAd({
    required AdPlacement placement,
    required String operationId,
    String? attemptId,
  }) async {
    final current = state;
    if (current is! MonetizationReady) return AdResult.notAvailable;
    if (current.isProcessingAd) {
      return const AdResult(status: AdResultStatus.alreadyProcessing);
    }
    state = current.copyWith(isProcessingAd: true);
    try {
      final result = await _adService.showRewardedAd(
        placement: placement,
        operationId: operationId,
      );
      if (result.isCompleted) {
        await _stateRepo?.saveContext(
          (state as MonetizationReady).context.copyWith(
            lastRewardedAdAt: DateTime.now(),
          ),
        );
      }
      // Reload for next request.
      unawaited(_adService.loadRewardedAd(placement));
      return result;
    } finally {
      final s = state;
      if (s is MonetizationReady) {
        state = s.copyWith(isProcessingAd: false);
      }
    }
  }

  // ── Interstitial ────────────────────────────────────────────────────────────

  Future<InterstitialDecision> evaluateAndShowInterstitial() async {
    final current = state;
    if (current is! MonetizationReady) {
      return InterstitialDecision.guardrailBlocked;
    }
    final decision = InterstitialPolicy.evaluate(current.context);
    if (decision != InterstitialDecision.eligible) return decision;

    final isReady = _adService.isAdReady(AdPlacement.interstitialPostLevel);
    if (!isReady) {
      unawaited(_adService.loadInterstitial());
      return InterstitialDecision.adUnavailable;
    }

    final shown = await _adService.showInterstitial();
    if (shown) {
      final newCtx = current.context.copyWith(
        levelsSinceLastInterstitial: 0,
        sessionInterstitialCount: current.context.sessionInterstitialCount + 1,
      );
      state = current.copyWith(context: newCtx);
      await _stateRepo?.saveContext(newCtx);
    }
    unawaited(_adService.loadInterstitial());
    return shown
        ? InterstitialDecision.eligible
        : InterstitialDecision.adUnavailable;
  }

  Future<void> onLevelCompleted() async {
    final current = state;
    if (current is! MonetizationReady) return;
    final newCtx = current.context.copyWith(
      levelsSinceLastInterstitial:
          current.context.levelsSinceLastInterstitial + 1,
    );
    state = current.copyWith(context: newCtx);
    await _stateRepo?.incrementLevelsSinceInterstitial();
  }

  // ── IAP ─────────────────────────────────────────────────────────────────────

  Future<void> purchaseProduct(
    String productId, {
    required String idempotencyKey,
  }) async {
    final current = state;
    if (current is! MonetizationReady) return;
    if (current.isProcessingPurchase) return;
    state = current.copyWith(isProcessingPurchase: true);
    try {
      final purchaseState = await _purchaseService.purchase(productId);
      if (purchaseState.status == PurchaseStatus.purchased ||
          purchaseState.status == PurchaseStatus.restored) {
        await _validateAndApplyPurchase(
          productId: productId,
          purchaseToken: purchaseState.purchaseId ?? '',
          idempotencyKey: idempotencyKey,
        );
        await _purchaseService.completePurchase(purchaseState);
      }
    } finally {
      final s = state;
      if (s is MonetizationReady) {
        state = s.copyWith(isProcessingPurchase: false);
      }
    }
  }

  Future<void> restorePurchases() async {
    final entitlements = await _purchaseRepo.restoreEntitlements();
    for (final e in entitlements) {
      await _entitlementRepo?.saveEntitlement(e);
    }
    unawaited(_refreshEntitlement());
  }

  Future<void> _validateAndApplyPurchase({
    required String productId,
    required String purchaseToken,
    required String idempotencyKey,
  }) async {
    final result = await _purchaseRepo.validateAndGrant(
      productId: productId,
      purchaseToken: purchaseToken,
      platform: _detectPlatform(),
      idempotencyKey: idempotencyKey,
    );
    if (result is PurchaseGranted && result.entitlementType != null) {
      await _entitlementRepo?.saveEntitlement(
        Entitlement(
          type: EntitlementType.values.firstWhere(
            (t) => t.name == result.entitlementType,
            orElse: () => EntitlementType.removeInterstitialAds,
          ),
          active: true,
          source: 'iap',
          storeProductId: productId,
        ),
      );
      unawaited(_refreshEntitlement());
    }
    final s = state;
    if (s is MonetizationReady && result is PurchaseGranted) {
      state = s.copyWith(
        context: s.context.copyWith(lastPurchaseAt: DateTime.now()),
      );
    }
  }

  Future<void> _refreshEntitlement() async {
    final entitlement =
        await _entitlementRepo?.getEntitlement(
          EntitlementType.removeInterstitialAds,
        ) ??
        Entitlement.noEntitlement;
    final s = state;
    if (s is MonetizationReady) {
      state = s.copyWith(
        removeAdsEntitlement: entitlement,
        context: s.context.copyWith(
          hasRemoveAdsEntitlement: entitlement.active,
        ),
      );
    }
  }

  String _detectPlatform() {
    // Platform is resolved at call site via dart:io; defaulting to android
    // for MVP. Full platform detection wired in integration layer.
    return 'android';
  }
}

// ignore: prefer_void_to_null
void unawaited(Future<dynamic> future) {
  future.ignore();
}

// ── Provider ──────────────────────────────────────────────────────────────────

final monetizationControllerProvider =
    NotifierProvider<MonetizationController, MonetizationViewState>(
      MonetizationController.new,
    );
