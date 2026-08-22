# Sprint 8 — Ads, IAP & Monetization v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Monetization / Ads / IAP / Entitlements  
**Depends On:** Sprint 7 — Economy, Wallet & Server-Authoritative Rewards v1  
**Primary App:** `apps/mobile`  
**Primary Cloud:** Firebase  
**Trusted Backend:** Cloud Functions and/or Cloud Run  
**Ad Provider:** Google AdMob + Mediation  
**IAP Client:** Flutter `in_app_purchase`  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 8 Objective

Implement the first production-capable monetization layer for **سوليتير العرب: أسطورة المعاني**.

Sprint 8 must add:

- Google AdMob integration;
- mediation-ready ad architecture;
- Rewarded Ads;
- Rewarded Coin grant;
- Rewarded Hint;
- Rewarded Extra Moves;
- Rewarded Dead-End Rescue;
- Interstitial Ads;
- Interstitial cadence and guardrails;
- Remove Ads entitlement;
- Coin Pack IAP;
- server-side purchase validation;
- purchase restore;
- duplicate callback protection;
- entitlement persistence;
- monetization analytics;
- safe offline behavior;
- graceful failure when ad/store services are unavailable.

The goal is:

> **Monetization becomes usable without weakening economy authority, gameplay correctness, player trust, or offline-first gameplay.**

---

# 2. Sprint 8 Success Criteria

Sprint 8 is complete only when:

1. AdMob initializes safely.
2. Rewarded Ads can grant approved rewards only after verified completion.
3. Rewarded Coin grant is exactly 100 Coins.
4. Rewarded Coin grant is capped at 3/day.
5. Rewarded Hint grants the approved Hint benefit.
6. Rewarded Extra Moves grants +5 Moves through approved controlled gameplay flow.
7. Rewarded Dead-End Rescue authorizes one recovery flow correctly.
8. Interstitials follow approved cadence and guardrails.
9. Interstitials never show in prohibited contexts.
10. Remove Ads disables Interstitials only.
11. Rewarded Ads remain available after Remove Ads purchase.
12. Coin Pack IAP products are integrated structurally.
13. Real-money prices are not hard-coded if still TBD.
14. IAP purchase validation is server-side.
15. Duplicate purchase callbacks cannot duplicate grants.
16. Purchase restore works.
17. Entitlements survive reinstall/account restoration where store permits.
18. Wallet remains server-authoritative.
19. Offline gameplay remains fully playable.
20. Ad/store failures never corrupt gameplay state.
21. Monetization analytics are implemented.
22. Emulator/mock/store-sandbox tests cover critical flows.

---

# 3. Non-Goals

Do NOT implement in Sprint 8:

- subscription;
- premium currency;
- Starter Pack;
- battle pass;
- paid Chapter unlocks;
- loot boxes;
- rewarded Daily systems;
- leaderboards;
- XP;
- Achievements;
- Packs;
- Events economy;
- live pricing experimentation without approved config;
- custom ad network implementation outside mediation;
- intrusive cross-promotion systems.

---

# 4. Approved Monetization Model

## Rewarded Ads

Supported use cases:

- Coins
- Hint
- Extra Moves
- Dead-End Rescue

## Rewarded Coin Grant

- **100 Coins**
- maximum **3 per day**

## Interstitial Ads

Baseline:
- approximately every **3–5 completed Levels**
- maximum **3 per session**

## Remove Ads

Removes:
- **Interstitial Ads only**

Does not remove:
- Rewarded Ads

## Coin Packs

Approved pack sizes:

- 1,000 Coins
- 3,000 Coins
- 7,000 Coins
- 15,000 Coins

Real-money prices:
- **TBD**

## No Subscription

Not in MVP.

## No Premium Currency

Not in MVP.

---

# 5. Monetization Authority Principle

The client may request monetization actions.

The client must not authoritatively grant:

- Coins;
- Hints;
- Extra Moves;
- Dead-End Rescue entitlement;
- Remove Ads entitlement;
- Coin Pack grants.

Trusted backend/store validation decides the authoritative result.

---

# 6. Monetization Architecture

Recommended:

```text
Flutter UI
   ↓
Monetization Application Layer
   ↓
Ad Service / IAP Service
   ↓
Trusted Backend Validation
   ↓
Economy / Entitlement Services
```

Do not allow ad/IAP SDK callbacks to mutate Wallet directly.

---

# 7. Suggested Feature Structure

```text
apps/mobile/lib/features/monetization/
├── application/
│   ├── monetization_controller.dart
│   ├── rewarded_ad_use_cases.dart
│   ├── interstitial_policy.dart
│   ├── purchase_use_cases.dart
│   └── entitlement_use_cases.dart
│
├── domain/
│   ├── rewarded_reward_type.dart
│   ├── ad_placement.dart
│   ├── ad_result.dart
│   ├── purchase_product.dart
│   ├── purchase_state.dart
│   └── entitlement.dart
│
├── data/
│   ├── ad_service.dart
│   ├── admob_ad_service.dart
│   ├── purchase_service.dart
│   ├── store_purchase_service.dart
│   └── monetization_repository.dart
│
└── presentation/
```

---

# 8. AdMob Initialization

Initialize AdMob after core app bootstrap.

Requirements:

- do not block app launch;
- safe failure;
- environment-specific ad unit IDs;
- test IDs in DEV/TEST;
- production IDs only in PROD;
- no secrets hard-coded.

---

# 9. Mediation Readiness

Use AdMob mediation architecture.

Sprint 8 should:

- avoid network-specific logic in UI;
- expose generic ad-service abstraction;
- support future mediation adapters/config;
- keep mediation partner mix configurable.

Final mediation network mix:
- TBD.

---

# 10. Rewarded Ad Contract

Recommended:

```dart
Future<RewardedAdResult> showRewardedAd({
  required RewardedRewardType rewardType,
  required String operationId,
});
```

Possible results:

```text
completed
notAvailable
cancelled
failed
alreadyProcessing
```

Reward is not granted solely because ad UI closed.

---

# 11. Reward Verification Principle

A Rewarded Ad reward is granted only after SDK/provider reports successful completion according to the provider contract.

Then:

1. create trusted reward claim;
2. submit idempotent operation to backend;
3. backend verifies request/eligibility;
4. economy mutation occurs;
5. client reconciles Wallet/gameplay effect.

---

# 12. Rewarded Ad Operation IDs

Every ad reward claim must include unique:

```text
rewardedAdOperationId
```

Suggested idempotency keys:

```text
rewarded_coins:{uid}:{operationId}
rewarded_hint:{uid}:{operationId}
rewarded_extra_moves:{uid}:{attemptId}:{operationId}
rewarded_dead_end_rescue:{uid}:{attemptId}:{operationId}
```

---

# 13. Rewarded Coins

Approved:

```text
+100 Coins
```

Maximum:

```text
3/day
```

The daily cap must be backend-authoritative.

Client may display remaining quota.

Do not trust device clock.

---

# 14. Rewarded Coin Cap Data

Trusted backend tracks:

```text
rewardDateKey
rewardedCoinCount
```

Reset based on validated player-local day policy when Daily infrastructure is available.

If Sprint 8 precedes full Daily authority implementation:

- use backend UTC-backed day boundary temporarily only if already approved;
- otherwise isolate cap service so it can adopt validated player-local day logic in Sprint 9.

Do not silently lock a permanent timezone policy.

---

# 15. Rewarded Hint

Reward:

```text
+1 Hint
```

Flow:

1. ad completed;
2. backend idempotently grants Hint;
3. Wallet refreshes;
4. Hint may then be consumed through existing economy flow.

Do not bypass Hint inventory.

---

# 16. Rewarded Extra Moves

Reward:

```text
+5 Moves
```

Use case:
- Out-of-Moves recovery.

Flow:

1. verify Attempt eligible;
2. show Rewarded Ad;
3. on completion, backend authorizes ad rescue;
4. client applies controlled +5 Moves exactly once;
5. persist Attempt;
6. mark operation applied.

Do not use normal gameplay Move action for grant.

---

# 17. Rewarded Extra Moves Limit

Current approved product scope allows Rewarded Ads for Extra Moves.

If total per-Attempt limits between Coin and Rewarded variants are not explicitly defined:

- keep reward type usage separately tracked;
- do not invent a permanent combined cap;
- enforce only approved hard limits where applicable;
- surface unresolved policy if implementation needs exact total rescue cap.

---

# 18. Rewarded Dead-End Rescue

Use case:
- confirmed Dead-End only.

Flow:

1. Solver confirms Dead-End.
2. Rewarded Ad completes.
3. backend authorizes idempotent rescue.
4. Solver-Guided Recovery State generated.
5. result verified solvable.
6. client applies recovery once.
7. persist Attempt.

If recovery generation fails:
- retry using same authorization;
- do not require another ad;
- do not duplicate rescue grant.

---

# 19. Rewarded Dead-End Limit

Approved Coin rescue limit:
- max 1/Attempt.

Rewarded rescue should not create unlimited repeat rescue loops.

Recommended MVP:
- Dead-End Rescue remains max 1/Attempt regardless of payment method.

If latest approved docs say otherwise, latest decision wins.

---

# 20. Ad Availability UX

If Rewarded Ad unavailable:

- keep Coin option if available;
- show safe message;
- do not block gameplay forever;
- do not fake reward.

Suggested copy:

```text
الإعلان غير متاح حاليًا
```

---

# 21. Ad Failure Safety

If ad fails before completion:

- no reward;
- no Wallet mutation;
- no gameplay rescue.

If ad completes but backend grant is temporarily unavailable:

- store pending verified ad-reward operation;
- reconcile later;
- avoid requiring player to watch again where technically supportable.

---

# 22. Rewarded Ad Pending Receipt

Persist:

```text
operationId
rewardType
attemptId?
adCompleted
backendGranted
localEffectApplied
createdAt
```

This supports crash recovery.

---

# 23. Interstitial Policy

Approved baseline:

```text
every 3–5 completed Levels
```

with:
```text
max 3/session
```

The exact interval should be configurable.

Do not hard-code a rigid "every 4 levels" product rule.

---

# 24. Interstitial Eligibility

Interstitial may be considered only after an eligible completed Level/result flow.

Do not interrupt:
- active gameplay;
- Tutorial;
- Story Beat mid-dialogue;
- loading;
- purchase flow.

---

# 25. Interstitial Guardrails

Approved: do not show immediately after:

- Rewarded Ad;
- purchase;
- Tutorial;
- failure;
- Dead-End;
- Out-of-Moves decline.

Also avoid showing:
- before the player sees Win result;
- between critical story lines;
- during first-run onboarding.

---

# 26. Interstitial Session Cap

Maximum:

```text
3/session
```

Track locally in current app session.

Session definition:
- app process/session baseline.

Do not persist forever.

---

# 27. Interstitial Cooldown

Recommended internal policy fields:

```text
completedLevelsSinceLastInterstitial
sessionInterstitialCount
lastMonetizationEventType
lastInterstitialAt
isTutorialRecentlyCompleted
```

Exact cooldown time:
- configurable/TBD.

---

# 28. Interstitial Decision API

Recommended:

```dart
InterstitialDecision evaluate({
  required MonetizationContext context,
});
```

Possible:

```text
eligible
notEnoughLevels
sessionCapReached
guardrailBlocked
removeAdsEntitled
adUnavailable
```

---

# 29. Interstitial Display Timing

Recommended:

```text
Win
  ↓
Result Screen
  ↓
Player taps Continue
  ↓
Interstitial eligibility check
  ↓
Interstitial
  ↓
Journey / Next Level
```

This avoids hijacking the reward moment.

---

# 30. Remove Ads Entitlement

Approved behavior:

Remove Ads removes:
- Interstitial Ads.

Rewarded Ads remain:
- available;
- optional.

Do not disable Rewarded Ads for Remove Ads owners.

---

# 31. Remove Ads Product

Exact real-money price:
- TBD.

Use product ID placeholder/config.

Do not hard-code fake production price.

---

# 32. Remove Ads Validation

Entitlement must come from:
- store purchase validation;
- trusted backend entitlement record.

Client local flag alone is insufficient.

---

# 33. Entitlement Model

Recommended:

```text
entitlementType
active
source
storeProductId
purchaseId
validatedAt
revision
```

Supported Sprint 8 entitlement:

```text
removeInterstitialAds
```

---

# 34. Entitlement Firestore Structure

Recommended:

```text
players/{uid}/entitlements/remove_ads
```

Client:
- may read own entitlement.
- cannot write authoritative entitlement directly.

---

# 35. IAP Product Model

Coin packs:

```text
coins_1000
coins_3000
coins_7000
coins_15000
```

Remove Ads:
```text
remove_ads
```

Exact store IDs should be environment/platform configurable.

---

# 36. Price Handling

Store-provided localized price is displayed.

Do not hard-code currency/price text.

Exact commercial prices remain TBD until approved/store-configured.

---

# 37. Consumable vs Non-Consumable

Coin Packs:
- consumable.

Remove Ads:
- non-consumable entitlement.

Use platform store semantics correctly.

---

# 38. Purchase Flow

Recommended:

```text
Load Products
  ↓
User selects
  ↓
Store purchase
  ↓
Purchase callback
  ↓
Send receipt/token to trusted backend
  ↓
Validate
  ↓
Grant Coins / Entitlement
  ↓
Acknowledge/complete purchase
  ↓
Refresh Wallet/Entitlements
```

---

# 39. Server-Side Purchase Validation

Mandatory.

Trusted backend verifies:

- platform;
- product ID;
- receipt/token;
- purchase status;
- ownership;
- duplicate transaction;
- environment;
- entitlement/grant state.

Do not trust client callback alone.

---

# 40. Purchase Transaction Identity

Use store transaction/order ID when available.

Map to internal:

```text
purchaseValidationId
```

Idempotency key should include:
- platform;
- purchase transaction ID.

---

# 41. Duplicate Purchase Callback

Store callbacks can repeat.

Backend:
- checks already-processed transaction;
- returns original grant/entitlement receipt;
- never double-grants Coins.

---

# 42. Coin Pack Grants

Approved pack sizes:

| Product | Coins |
|---|---:|
| Pack 1 | 1,000 |
| Pack 2 | 3,000 |
| Pack 3 | 7,000 |
| Pack 4 | 15,000 |

Backend maps trusted product ID to authoritative Coin grant.

Client must not send "grant 15000" as authority.

---

# 43. Remove Ads Grant

After validated purchase:

- entitlement set active;
- Interstitial policy immediately suppresses future Interstitials;
- Rewarded Ads remain optional.

---

# 44. Purchase Restore

Required for:
- non-consumable Remove Ads.

For Coin consumables:
- do not re-grant consumed purchases on restore unless platform semantics explicitly support unfinished transaction recovery.

---

# 45. Restore Flow

1. user requests Restore Purchases or platform triggers restore.
2. store returns owned/restorable purchases.
3. backend validates.
4. entitlement reconciles.
5. UI updates.

Do not grant duplicate Coin consumables.

---

# 46. Pending Purchase

Handle store states:

```text
pending
purchased
restored
error
cancelled
```

Do not grant while pending.

---

# 47. Purchase Completion/Acknowledgment

Complete/acknowledge store purchase only according to store SDK guidance after appropriate validation.

Do not leave purchases perpetually unfinished.

---

# 48. Offline IAP

Purchases require network/store access.

If offline:
- disable or fail gracefully.

Do not simulate purchase locally.

---

# 49. Shop Screen

Sprint 8 should add basic Shop.

Sections:

- Coin Packs
- Remove Ads

No:
- subscription;
- premium currency;
- bundles.

---

# 50. Coin Pack Presentation

Display:
- Coin amount;
- localized store price;
- purchase CTA.

Do not show fake discount percentages unless approved.

---

# 51. Remove Ads Presentation

Explain clearly:

```text
إزالة الإعلانات البينية
```

and:

```text
الإعلانات الاختيارية مقابل المكافآت تظل متاحة
```

Avoid misleading “No Ads” if Rewarded Ads remain.

---

# 52. Rewarded Ads Placement

Approved contexts:

- get Coins;
- get Hint;
- Out-of-Moves Extra Moves;
- confirmed Dead-End Rescue.

Do not add Rewarded Ads to random unrelated screens.

---

# 53. Rewarded Coins Entry

Potential placement:
- Shop / Wallet area.

Show:
- +100 Coins;
- remaining daily ad claims.

No more than 3/day.

---

# 54. Rewarded Hint Entry

Potential placement:
- Hint flow when inventory low/zero.

Show:
- “شاهد إعلانًا واحصل على تلميح”.

No auto-play ad.

---

# 55. Rewarded Extra Moves Entry

Out-of-Moves overlay:

Options:
- Coin purchase;
- Rewarded Ad;
- Restart/Exit.

Do not force ad.

---

# 56. Rewarded Dead-End Entry

Confirmed Dead-End overlay:

Options:
- 200 Coins;
- Rewarded Ad;
- Restart.

Do not show unless Solver confirmed Dead-End.

---

# 57. Consent / Privacy Boundary

Ad SDK privacy/consent requirements must be respected.

Implement consent flow where required by platform/regulation/SDK.

Do not invent legal text.

Use:
- provider-recommended consent SDK/tooling;
- placeholder legal links until final policy approved.

---

# 58. Child/Teen Consideration

Audience is 13+.

Ad configuration should avoid inappropriate targeting.

Use platform/ad network settings consistent with general-audience 13+ product.

Do not enable personalized-ad behavior without required consent.

---

# 59. Ad Personalization

Exact consent/personalization policy may depend on market/legal rollout.

Architecture must support:
- non-personalized ads;
- consent state;
- region-specific behavior.

Do not hard-code universal personalized ads.

---

# 60. Frequency Configuration

Remote/configurable where safe:

- interstitial min/max completed-level interval;
- session cap;
- cooldown;
- Rewarded Coin daily cap;
- feature flags.

Authoritative reward amounts/caps must also exist server-side.

---

# 61. Server Monetization Config

Trusted backend config should include:

```text
rewardedCoinAmount = 100
rewardedCoinDailyCap = 3
coinPackProductMap
removeAdsProductIds
```

Do not rely solely on client Remote Config.

---

# 62. Monetization Config Version

Expose:

```text
monetizationConfigVersion
```

Useful for:
- debugging;
- analytics;
- stale-client handling.

---

# 63. Product Catalog

Recommended backend/store config:

```text
productId
platform
type
grantType
grantAmount
active
```

Do not let client invent grant amount.

---

# 64. Store Environment Separation

Use:
- sandbox/test products in DEV/TEST/STAGING as appropriate;
- production products only in PROD.

Never run automated purchase tests against production store account.

---

# 65. Purchase Validation Backend Structure

Suggested:

```text
firebase/functions/src/monetization/
├── validate_purchase.ts
├── grant_purchase.ts
├── restore_entitlements.ts
├── rewarded_ad_reward.ts
├── monetization_config.ts
├── purchase_repository.ts
└── entitlement_repository.ts
```

---

# 66. Ad Reward Backend Structure

Suggested:

```text
firebase/functions/src/ads/
├── grant_rewarded_coins.ts
├── grant_rewarded_hint.ts
├── authorize_rewarded_extra_moves.ts
├── authorize_rewarded_dead_end_rescue.ts
└── rewarded_ad_limits.ts
```

Could be unified if cleaner.

---

# 67. Security Rules

Client cannot directly write:

- entitlements;
- purchase grants;
- reward receipts;
- authoritative ad reward counters;
- Wallet grants.

Client may read own state where appropriate.

---

# 68. Rewarded Coin Daily Counter Security

Counter must be trusted/backend-managed.

Client may display remaining count from server/cache.

Do not allow direct client increment/reset.

---

# 69. Ad Session State

Interstitial session count can remain local.

Rewarded Coin daily cap cannot remain only local.

---

# 70. Exactly-Once Rewarded Effect

Pattern:

1. ad SDK confirms completion;
2. backend reward claim idempotent;
3. backend grant/authorization succeeds;
4. client applies local effect if needed;
5. mark local receipt applied.

Applies to:
- Coins;
- Hint;
- Extra Moves;
- Dead-End Rescue.

---

# 71. Crash Recovery — Rewarded Extra Moves

If ad completed and backend authorized but app crashes before applying +5:

On resume:
- recover pending receipt;
- apply +5 once.

Do not make player watch again.

---

# 72. Crash Recovery — Dead-End Rescue

Same:
- authorization persists;
- recovery generation can retry;
- no second ad required.

---

# 73. Crash Recovery — IAP

If store callback arrives and app crashes:
- unfinished purchase reconciled on next launch;
- backend validation idempotent;
- grant/entitlement recovered.

---

# 74. Monetization Queue

Maintain durable pending operations:

```text
rewardedAdClaims
purchaseValidations
entitlementRefresh
```

Do not mix identity across accounts.

---

# 75. Account Change Safety

If Firebase UID changes:
- pause pending monetization queue;
- never submit old account purchase/ad claim under new UID.

Purchases may require explicit restore/reconciliation.

---

# 76. Purchase Ownership Conflict

If store purchase appears already associated with another logical player:

- do not silently transfer economic grant;
- return explicit conflict;
- preserve both accounts;
- require future support/merge policy if needed.

---

# 77. Remove Ads Account Restoration

Validated entitlement should sync across devices for same linked player/store ownership.

If anonymous-only account is lost:
- restore through store where platform permits.

---

# 78. Shop Availability

If product catalog fails to load:
- show unavailable state;
- keep gameplay working;
- hide invalid price placeholders.

---

# 79. Rewarded Ad Preloading

Preload where useful:
- but avoid excessive resource use.

Potential:
- preload next eligible Rewarded Ad after previous finishes;
- preload Interstitial only when nearing eligibility.

Do not preload all formats aggressively.

---

# 80. Ad Lifecycle

Handle:
- loaded;
- failed;
- shown;
- impression;
- clicked;
- dismissed;
- reward earned.

Only reward-earned/completion event triggers reward claim.

---

# 81. Interstitial Dismissal

After dismissal:
- continue navigation.
- no gameplay reward.

If load/show fails:
- continue navigation without blocking.

---

# 82. Interstitial Timeout

Do not make player wait long for ad load.

If unavailable quickly enough:
- skip and continue.

Exact timeout is UX/performance tuning.

---

# 83. First Sessions Protection

Consider suppressing Interstitials during:
- first Tutorial;
- immediate first Levels.

Approved guardrail includes Tutorial.

If exact onboarding grace Level count is needed and not approved:
- keep configurable/TBD.

---

# 84. Purchase UI Lock

While purchase pending:
- disable duplicate tap;
- show spinner/state;
- allow safe cancellation behavior where store permits.

Backend idempotency remains mandatory.

---

# 85. Purchase Error UX

Handle:
- cancelled;
- unavailable;
- pending;
- validation failed;
- already owned;
- network error.

Use localized safe messages.

---

# 86. Refund / Revocation Readiness

Architecture must support future entitlement revocation.

For Remove Ads:
- if store/backend later reports revoked/refunded, entitlement may deactivate.

Do not implement a permanent irreversible local flag.

---

# 87. Consumable Refund Complexity

Coin pack refund handling may require policy later.

Sprint 8 should:
- record purchase transaction IDs;
- keep audit trail;
- not implement arbitrary negative balance revocation without approved policy.

---

# 88. Monetization Analytics

Track:

## Rewarded Ads
- rewarded_ad_offer_shown
- rewarded_ad_started
- rewarded_ad_completed
- rewarded_ad_failed
- rewarded_reward_granted
- rewarded_reward_failed

## Interstitial
- interstitial_eligible
- interstitial_shown
- interstitial_failed
- interstitial_dismissed
- interstitial_guardrail_blocked

## IAP
- shop_opened
- product_loaded
- purchase_started
- purchase_pending
- purchase_completed
- purchase_cancelled
- purchase_failed
- purchase_validated
- purchase_duplicate
- restore_started
- restore_completed

---

# 89. Revenue Analytics

Use store/provider revenue events where available.

Do not manually fabricate revenue from localized display price.

BigQuery export remains approved.

---

# 90. Analytics Privacy

Do not log:
- purchase receipt/token;
- OAuth credentials;
- full store payload.

Use:
- product ID;
- transaction outcome;
- anonymized operation IDs.

---

# 91. DEV Monetization Tools

DEV-only:

- force rewarded available/unavailable;
- simulate rewarded completion;
- simulate interstitial eligibility;
- reset local interstitial session count;
- fake product catalog;
- simulate purchase states;
- inspect entitlement cache.

Must not affect PROD backend.

---

# 92. Test Ad IDs

Use official test ad units in non-PROD.

Never use production ad IDs for automated testing.

---

# 93. Store Sandbox Tests

Use:
- Google Play test purchase flow;
- Apple StoreKit sandbox/test environment.

No real-money automated test transactions.

---

# 94. Rewarded Ad Tests

Required:

- ad unavailable -> no reward;
- cancelled -> no reward;
- failed -> no reward;
- completed -> one reward;
- duplicate completion callback -> one reward;
- crash after backend grant -> local effect recovered;
- wrong attempt -> rescue rejected;
- daily Coin cap enforced.

---

# 95. Interstitial Tests

Required:

- eligible after configured completed-Level threshold;
- blocked before threshold;
- max 3/session;
- blocked after Rewarded Ad;
- blocked after purchase;
- blocked after Tutorial;
- blocked after failure;
- blocked after Dead-End;
- blocked after Out-of-Moves decline;
- disabled by Remove Ads;
- Rewarded still available with Remove Ads.

---

# 96. IAP Tests

Required:

- product list load;
- purchase success;
- purchase pending;
- purchase cancelled;
- purchase failure;
- validation failure;
- duplicate callback;
- duplicate transaction;
- Coin grant exactly once;
- Remove Ads entitlement exactly once;
- restore Remove Ads;
- no duplicate Coin restore.

---

# 97. Purchase Security Tests

Required:

- forged product ID rejected;
- client grant amount ignored;
- invalid receipt rejected;
- wrong environment rejected;
- already processed transaction idempotent;
- user A cannot use user B validated purchase receipt where store identity prevents it.

---

# 98. Integration Scenario — Rewarded Coins

### MO-001

1. player opens Coins reward.
2. watches completed Rewarded Ad.
3. backend grants +100 Coins.
4. repeat 3 times in day.
5. fourth claim rejected/disabled.
6. no duplicate grant on callback retry.

---

# 99. Integration Scenario — Rewarded Hint

### MO-002

1. player has 0 Hints.
2. chooses Rewarded Hint.
3. ad completes.
4. backend grants +1 Hint.
5. Hint request consumes 1.
6. Solver suggestion shown.

---

# 100. Integration Scenario — Rewarded Extra Moves

### MO-003

1. Out-of-Moves.
2. player chooses Rewarded Ad.
3. ad completes.
4. backend authorizes.
5. +5 Moves applied once.
6. crash/relaunch does not duplicate.

---

# 101. Integration Scenario — Rewarded Dead-End Rescue

### MO-004

1. Solver confirms Dead-End.
2. player chooses Rewarded Ad.
3. ad completes.
4. rescue authorization succeeds.
5. recovery state generated and verified.
6. applied once.
7. second rescue rejected if max-one rule applies.

---

# 102. Integration Scenario — Interstitial

### MO-005

1. complete eligible number of Levels.
2. result shown.
3. continue tapped.
4. Interstitial shows.
5. next navigation resumes.
6. session count increments.
7. after Remove Ads entitlement, same flow skips Interstitial.

---

# 103. Integration Scenario — Coin Pack

### MO-006

1. open Shop.
2. select 3,000 Coin pack.
3. store purchase succeeds.
4. backend validates product.
5. +3,000 Coins granted exactly once.
6. duplicate callback returns same receipt.

---

# 104. Integration Scenario — Remove Ads

### MO-007

1. purchase Remove Ads.
2. backend validates.
3. entitlement active.
4. Interstitials suppressed.
5. Rewarded Ads still visible.
6. reinstall/restore.
7. entitlement restored.

---

# 105. Offline Regression

With no network:
- Main Journey playable.
- Wallet cache visible.
- ads unavailable gracefully.
- Shop unavailable gracefully.
- no crashes.
- no Interstitial blocking navigation.
- no fake rewards.

---

# 106. Monetization State Controller

Recommended states:

```text
idle
loadingAd
showingAd
claimingReward
loadingProducts
purchasing
validatingPurchase
restoring
recoverableError
```

Avoid one global blocking state for all monetization.

---

# 107. Ad Placement IDs

Use typed IDs:

```text
rewardedCoins
rewardedHint
rewardedExtraMoves
rewardedDeadEndRescue
interstitialPostLevel
```

Do not scatter string IDs.

---

# 108. Product IDs

Typed/configured per platform/environment.

Do not assume iOS/Android product IDs identical.

---

# 109. Local Entitlement Cache

Persist:
- last validated Remove Ads entitlement;
- revision;
- updatedAt.

If offline:
- honor last valid non-expired/non-revoked entitlement.

For non-consumable Remove Ads, local cache can suppress Interstitial offline after prior validation.

---

# 110. Entitlement Refresh

Refresh:
- app startup online;
- purchase success;
- restore;
- account change.

Avoid per-screen network calls.

---

# 111. Interstitial Policy Data

Persist only what needs persistence.

Session counters:
- memory/session.

Entitlement:
- persisted.

Completed-Level cadence counter:
- can be local persistent or derived.

Document choice.

---

# 112. Cadence Counter Recommendation

Persist:
```text
levelsSinceLastInterstitial
```

Reset when:
- Interstitial actually shown.

If app closes before ad shows:
- do not reset.

---

# 113. Guardrail Event Memory

Track recent monetization-sensitive events:

```text
lastRewardedAdAt
lastPurchaseAt
lastTutorialCompletedAt
lastFailureAt
lastDeadEndAt
lastOutOfMovesDeclineAt
```

Exact time cooldowns remain configurable.

---

# 114. Remote Config

Client-facing tunables can include:

- Interstitial enabled;
- Rewarded placements enabled;
- cadence range;
- session cap;
- cooldowns;
- Shop feature flags.

Trusted server still enforces:
- reward amounts;
- daily caps;
- product grants.

---

# 115. Feature Flags

Each monetization feature should be kill-switchable:

```text
rewardedCoinsEnabled
rewardedHintEnabled
rewardedExtraMovesEnabled
rewardedDeadEndRescueEnabled
interstitialEnabled
shopEnabled
removeAdsEnabled
```

Useful for rollout and incidents.

---

# 116. Fallback Behavior

If Remote Config unavailable:
- safe defaults.
- gameplay remains operational.

If ad SDK unavailable:
- skip ad option.

If store unavailable:
- Shop shows unavailable state.

---

# 117. Compliance Logging

Keep records sufficient to investigate:
- reward grant;
- purchase grant;
- entitlement state.

Do not over-collect user data.

---

# 118. Performance

Measure:

- AdMob init latency;
- rewarded load time;
- interstitial load time;
- product query latency;
- validation function latency;
- entitlement refresh latency.

None should block core gameplay startup.

---

# 119. Cost-Conscious Backend

Reward/IAP operations are low frequency.

Prefer:
- direct trusted function calls;
- idempotent Firestore transaction;
- minimal documents.

Do not add Kafka/Redis/brokers.

---

# 120. Suggested Implementation Order

## Step 1
Monetization domain models/config.

## Step 2
AdMob abstraction + safe initialization.

## Step 3
Rewarded Coins backend grant.

## Step 4
Rewarded Hint.

## Step 5
Rewarded Extra Moves.

## Step 6
Rewarded Dead-End Rescue.

## Step 7
Interstitial policy/guardrails.

## Step 8
Remove Ads entitlement model.

## Step 9
Store product catalog.

## Step 10
IAP purchase flow.

## Step 11
Server-side validation.

## Step 12
Coin Pack grants.

## Step 13
Remove Ads grant.

## Step 14
Restore purchases.

## Step 15
Crash recovery/pending operations.

## Step 16
Analytics.

## Step 17
Sandbox/emulator/security tests.

## Step 18
Performance/cost review.

---

# 121. Suggested Commit Sequence

### Commit 1
```text
feat(monetization): add ad purchase and entitlement domain contracts
```

### Commit 2
```text
feat(ads): integrate admob and rewarded ad abstraction
```

### Commit 3
```text
feat(ads): add server-authoritative rewarded coin and hint grants
```

### Commit 4
```text
feat(ads): add rewarded extra moves and dead-end rescue flows
```

### Commit 5
```text
feat(ads): add interstitial policy cadence and guardrails
```

### Commit 6
```text
feat(iap): add store product catalog and purchase flow
```

### Commit 7
```text
feat(iap): add server-side purchase validation and idempotent grants
```

### Commit 8
```text
feat(iap): add remove ads entitlement and restore purchases
```

### Commit 9
```text
feat(shop): add coin packs and remove ads ui
```

### Commit 10
```text
test(monetization): add rewarded interstitial iap and entitlement coverage
```

### Commit 11
```text
security(monetization): protect entitlements purchases and reward counters
```

### Commit 12
```text
docs(monetization): document ads iap and monetization guardrails
```

---

# 122. Sprint 8 Definition of Done

Sprint 8 is DONE only when:

- [ ] AdMob initializes safely.
- [ ] DEV/TEST use test ad IDs.
- [ ] Rewarded Coins grants exactly 100 Coins.
- [ ] Rewarded Coins cap is max 3/day.
- [ ] Rewarded Hint grants exactly 1 Hint.
- [ ] Rewarded Extra Moves grants +5 Moves exactly once.
- [ ] Rewarded Dead-End Rescue works only on confirmed Dead-End.
- [ ] ad completion is required before reward claim.
- [ ] duplicate rewarded callback does not duplicate reward.
- [ ] pending rewarded operation survives crash.
- [ ] Interstitial baseline cadence is configurable around 3–5 completed Levels.
- [ ] Interstitial session cap is 3.
- [ ] Interstitial blocked after Rewarded Ad.
- [ ] Interstitial blocked after purchase.
- [ ] Interstitial blocked after Tutorial.
- [ ] Interstitial blocked after failure.
- [ ] Interstitial blocked after Dead-End.
- [ ] Interstitial blocked after Out-of-Moves decline.
- [ ] Interstitial never interrupts active gameplay.
- [ ] Remove Ads suppresses Interstitials.
- [ ] Rewarded Ads remain available with Remove Ads.
- [ ] Shop exists.
- [ ] 1k Coin Pack configured.
- [ ] 3k Coin Pack configured.
- [ ] 7k Coin Pack configured.
- [ ] 15k Coin Pack configured.
- [ ] real-money price is store-provided/configured, not invented.
- [ ] Coin Packs treated as consumables.
- [ ] Remove Ads treated as non-consumable.
- [ ] server-side purchase validation implemented.
- [ ] duplicate purchase callback is idempotent.
- [ ] Coin grant occurs exactly once.
- [ ] Remove Ads entitlement occurs exactly once.
- [ ] Restore Purchases restores Remove Ads.
- [ ] Restore does not duplicate Coin consumables.
- [ ] client cannot directly write entitlement.
- [ ] client cannot directly write purchase grant.
- [ ] client cannot directly mutate Wallet via monetization.
- [ ] monetization analytics implemented.
- [ ] sandbox/emulator tests pass.
- [ ] MO-001 passes.
- [ ] MO-002 passes.
- [ ] MO-003 passes.
- [ ] MO-004 passes.
- [ ] MO-005 passes.
- [ ] MO-006 passes.
- [ ] MO-007 passes.
- [ ] offline core regression passes.
- [ ] Flutter analyze passes.
- [ ] backend tests pass.
- [ ] no subscription/premium currency/Starter Pack added.

---

# 123. Sprint 8 Exit Gate Before Daily Systems

Do not start Sprint 9 until:

1. Rewarded grants are exactly-once.
2. Rewarded Coin cap is trusted/backend-enforced.
3. Interstitial guardrails pass tests.
4. Remove Ads entitlement works and restores.
5. Coin Pack purchase grants are validated and idempotent.
6. duplicate store callbacks are harmless.
7. monetization failures never block core gameplay.
8. no direct client Wallet/entitlement authority exists.
9. account switching does not mix purchase operations.
10. crash recovery works.
11. sandbox/store tests are green.
12. offline gameplay remains unaffected.

---

# 124. Cursor Execution Prompt — Sprint 8

Use this after Sprint 7 passes its exit gate:

> Implement **Sprint 8 — Ads, IAP & Monetization v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_8_Ads_IAP_and_Monetization_v1.0.md`
> - latest Monetization Specification
> - latest Game Economy Design
> - latest Data Model
> - latest Firebase/Cloud Architecture
>
> Implement the approved MVP monetization layer.
>
> Implement:
>
> - Google AdMob integration;
> - mediation-ready ad abstraction;
> - Rewarded Coins:
>   - +100 Coins;
>   - max 3/day;
> - Rewarded Hint;
> - Rewarded Extra Moves:
>   - +5 Moves;
> - Rewarded Dead-End Rescue;
> - idempotent rewarded-ad reward claims;
> - crash recovery for completed-ad/pending-grant flows;
> - Interstitial Ads;
> - configurable baseline cadence around 3–5 completed Levels;
> - max 3 Interstitials/session;
> - approved Interstitial guardrails;
> - Remove Ads entitlement that disables Interstitials only;
> - Rewarded Ads remain optional after Remove Ads;
> - Shop;
> - 1k / 3k / 7k / 15k Coin Pack products;
> - Flutter `in_app_purchase` integration;
> - server-side purchase validation;
> - purchase transaction idempotency;
> - Coin Pack server-authoritative grants;
> - Remove Ads non-consumable entitlement;
> - Restore Purchases;
> - pending/failed/cancelled purchase handling;
> - monetization analytics;
> - Firebase/store sandbox tests;
> - security rules.
>
> Critical constraints:
>
> - do not trust client ad callback as authority for economic mutation;
> - do not trust client purchase callback as authority for Coin grant;
> - server must map product ID to grant amount;
> - do not hard-code real-money prices while pricing is TBD;
> - use localized store price;
> - Coin Packs are consumable;
> - Remove Ads is non-consumable;
> - Remove Ads removes Interstitials only;
> - Rewarded Ads remain available;
> - Interstitials must not show immediately after Rewarded Ad, purchase, Tutorial, failure, Dead-End, or Out-of-Moves decline;
> - max 3 Interstitials/session;
> - Rewarded Coin cap is max 3/day and backend-authoritative;
> - gameplay must remain usable offline;
> - ad/store unavailability must fail gracefully;
> - no subscription;
> - no premium currency;
> - no Starter Pack;
> - no Daily Reward/Streak/Challenge in this sprint.
>
> Use official test ad IDs and store sandbox environments outside PROD.
>
> At completion report:
>
> 1. files created/changed;
> 2. AdMob/mediation architecture;
> 3. Rewarded flow contracts;
> 4. Interstitial eligibility/guardrail implementation;
> 5. IAP product IDs/config model;
> 6. server-side validation flow;
> 7. entitlement model;
> 8. restore-purchase behavior;
> 9. crash-recovery/idempotency behavior;
> 10. security rules;
> 11. sandbox/emulator tests;
> 12. monetization analytics;
> 13. analyze/test/build results;
> 14. unresolved commercial/store configuration items;
> 15. any deviations from this Sprint document and why.

---

# 125. Next Sprint

After Sprint 8 passes the exit gate:

# **Sprint 9 — Daily Reward, Daily Challenge, Streak & Notifications v1**

Expected focus:

- 7-day Daily Reward;
- Daily Reward backend authority;
- Daily Streak;
- streak milestones;
- Daily Challenge;
- deterministic Daily board;
- first-completion reward;
- validated player-local day boundary;
- timezone abuse protection;
- FCM;
- Daily Challenge notification;
- Streak Risk notification;
- quiet hours;
- notification preferences;
- idempotent Daily grants;
- offline/online reconciliation.

---

**End of Sprint 8 — Ads, IAP & Monetization v1**
