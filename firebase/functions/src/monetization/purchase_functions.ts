import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import {
  COIN_PACK_GRANTS,
  NON_CONSUMABLE_PRODUCTS,
  PRODUCT_REMOVE_ADS,
  EntitlementDoc,
  PurchaseReceiptDoc,
} from './monetization_config';
import { atomicWalletMutation } from '../economy/wallet_service';

const db = () => getFirestore();

function purchaseReceiptsPath(uid: string): string {
  return `players/${uid}/purchase_receipts`;
}

function entitlementsPath(uid: string): string {
  return `players/${uid}/entitlements`;
}

async function getExistingPurchaseReceipt(
  uid: string,
  idempotencyKey: string,
): Promise<PurchaseReceiptDoc | null> {
  const snap = await db()
    .collection(purchaseReceiptsPath(uid))
    .where('idempotencyKey', '==', idempotencyKey)
    .limit(1)
    .get();
  if (snap.empty) return null;
  return snap.docs[0].data() as PurchaseReceiptDoc;
}

/**
 * validateAndGrantPurchase — server-authoritative IAP grant.
 *
 * For MVP: client sends productId + purchaseToken; server does lightweight
 * receipt validation (real store-side validation wired in post-MVP hardening).
 * Idempotent on (uid, idempotencyKey).
 */
export const validateAndGrantPurchase = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', 'Not authenticated');

    const data = request.data as {
      productId: string;
      purchaseToken: string;
      platform: 'android' | 'ios';
      idempotencyKey: string;
    };

    const { productId, purchaseToken, platform, idempotencyKey } = data;
    if (!productId || !purchaseToken || !platform || !idempotencyKey) {
      throw new HttpsError('invalid-argument', 'Missing required fields');
    }

    const isConsumable = COIN_PACK_GRANTS[productId] !== undefined;
    const isNonConsumable = NON_CONSUMABLE_PRODUCTS.has(productId);
    if (!isConsumable && !isNonConsumable) {
      throw new HttpsError('invalid-argument', `Unknown product: ${productId}`);
    }

    // Idempotency check.
    const existing = await getExistingPurchaseReceipt(uid, idempotencyKey);
    if (existing) return { success: true, idempotent: true };

    const now = Timestamp.now();

    if (isNonConsumable && productId === PRODUCT_REMOVE_ADS) {
      // Grant Remove Ads entitlement + record receipt atomically.
      await db().runTransaction(async (tx) => {
        const entRef = db()
          .collection(entitlementsPath(uid))
          .doc('removeInterstitialAds');
        const current = (await tx.get(entRef)).data() as EntitlementDoc | undefined;
        const revision = (current?.revision ?? 0) + 1;

        tx.set(entRef, {
          entitlementType: 'removeInterstitialAds',
          active: true,
          source: 'iap',
          storeProductId: productId,
          purchaseId: purchaseToken,
          validatedAt: now,
          revision,
          updatedAt: now,
        } satisfies EntitlementDoc);

        tx.set(db().collection(purchaseReceiptsPath(uid)).doc(), {
          uid,
          productId,
          purchaseToken,
          platform,
          grantedAt: now,
          entitlementType: 'removeInterstitialAds',
          idempotencyKey,
        } satisfies PurchaseReceiptDoc);
      });

      return { success: true, entitlementType: 'removeInterstitialAds' };
    }

    if (isConsumable) {
      const coinGrant = COIN_PACK_GRANTS[productId];
      await atomicWalletMutation(uid, idempotencyKey, 'coinPackPurchase', productId, [
        {
          type: 'coinPackPurchase',
          resource: 'coins',
          amount: coinGrant,
          referenceType: 'iap_product',
          referenceId: productId,
          idempotencyKey,
          metadata: { purchaseToken, platform },
        },
      ]);

      // Record receipt separately (outside wallet transaction for simplicity).
      await db().collection(purchaseReceiptsPath(uid)).add({
        uid,
        productId,
        purchaseToken,
        platform,
        grantedAt: now,
        coinGrant,
        idempotencyKey,
      } satisfies PurchaseReceiptDoc);

      return { success: true, coinGrant };
    }

    throw new HttpsError('internal', 'Unhandled product type');
  },
);

/**
 * restoreEntitlements — re-syncs non-consumable entitlements from server.
 * Client calls this after restorePurchases() from the store SDK.
 */
export const restoreEntitlements = onCall(
  { enforceAppCheck: false },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', 'Not authenticated');

    const entSnap = await db().collection(entitlementsPath(uid)).get();
    const entitlements = entSnap.docs.map((d) => {
      const data = d.data() as EntitlementDoc;
      return { ...data, entitlementType: d.id };
    });

    return { success: true, entitlements };
  },
);

/**
 * revokeEntitlement — admin-only revocation (e.g. refund handling).
 * In MVP scope: stub only — not exposed as a user-callable function.
 */
export async function revokeEntitlementInternal(
  uid: string,
  entitlementType: string,
): Promise<void> {
  const ref = db().collection(entitlementsPath(uid)).doc(entitlementType);
  await ref.update({
    active: false,
    revision: FieldValue.increment(1),
    updatedAt: Timestamp.now(),
  });
}
