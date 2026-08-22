export const PRODUCT_REMOVE_ADS = 'remove_ads';
export const PRODUCT_COINS_1000 = 'coins_1000';
export const PRODUCT_COINS_3000 = 'coins_3000';
export const PRODUCT_COINS_7000 = 'coins_7000';
export const PRODUCT_COINS_15000 = 'coins_15000';

export const COIN_PACK_GRANTS: Record<string, number> = {
  [PRODUCT_COINS_1000]: 1000,
  [PRODUCT_COINS_3000]: 3000,
  [PRODUCT_COINS_7000]: 7000,
  [PRODUCT_COINS_15000]: 15000,
};

export const NON_CONSUMABLE_PRODUCTS = new Set([PRODUCT_REMOVE_ADS]);
export const CONSUMABLE_PRODUCTS = new Set(Object.keys(COIN_PACK_GRANTS));

export interface EntitlementDoc {
  entitlementType: string;
  active: boolean;
  source: string;
  storeProductId?: string;
  purchaseId?: string;
  validatedAt?: FirebaseFirestore.Timestamp;
  revision: number;
  updatedAt: FirebaseFirestore.Timestamp;
}

export interface PurchaseReceiptDoc {
  uid: string;
  productId: string;
  purchaseToken: string;
  platform: 'android' | 'ios';
  grantedAt: FirebaseFirestore.Timestamp;
  coinGrant?: number;
  entitlementType?: string;
  idempotencyKey: string;
}
