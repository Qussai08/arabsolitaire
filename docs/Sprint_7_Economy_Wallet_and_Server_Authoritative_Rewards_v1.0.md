# Sprint 7 — Economy, Wallet & Server-Authoritative Rewards v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Economy / Wallet / Trusted Reward Grants / Offline Reconciliation  
**Depends On:** Sprint 6 — Firebase Identity, Cloud Progression & Sync v1  
**Primary App:** `apps/mobile`  
**Primary Cloud:** Firebase  
**Trusted Backend:** Cloud Functions and/or Cloud Run  
**Primary Local Store:** Drift / SQLite  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 7 Objective

Implement the first production-capable economy and wallet foundation for **سوليتير العرب: أسطورة المعاني**.

Sprint 7 must add:

- server-authoritative Coin balance;
- server-authoritative Hint inventory;
- starting grants;
- Level completion reward grants;
- Chapter completion reward grants;
- Hint Coin purchase;
- Extra Moves Coin purchase;
- Dead-End Rescue Coin purchase;
- offline Coin spending queue where approved;
- idempotent trusted economy mutations;
- duplicate reward protection;
- transaction ledger;
- client/local cache of reconciled balance;
- safe retry/reconciliation;
- reward preview vs authoritative grant separation;
- anti-tamper boundaries;
- economy analytics and diagnostics;
- Firestore rules preventing direct client balance mutation.

The goal is:

> **The player can earn and spend approved resources safely, with authoritative trusted backend logic, while preserving offline-first gameplay where the product explicitly allows it.**

---

# 2. Sprint 7 Success Criteria

Sprint 7 is complete only when:

1. Wallet balance is authoritative on trusted backend.
2. Hint inventory is authoritative on trusted backend.
3. Starting grant is applied once only.
4. Level rewards are granted once per eligible completion.
5. Chapter rewards are granted once per eligible completion.
6. Duplicate callbacks/retries cannot duplicate grants.
7. Hint purchase charges exactly 75 Coins.
8. Extra Moves first purchase charges exactly 150 Coins.
9. Extra Moves second purchase charges exactly 250 Coins.
10. Maximum 2 Extra-Move Coin rescues per Attempt is enforced.
11. Dead-End Rescue Coin purchase charges exactly 200 Coins.
12. Maximum 1 Dead-End Rescue per Attempt is enforced.
13. Offline Coin spend queue works for approved spend flows.
14. Reconciliation handles duplicate/offline retries safely.
15. Direct client mutation of authoritative balance is blocked.
16. Transaction ledger records all authoritative mutations.
17. Wallet cache can be displayed offline using last reconciled state.
18. Reward previews remain distinct from actual authoritative grants.
19. Economy errors do not corrupt gameplay state.
20. Emulator/integration tests cover idempotency and anti-duplication.

---

# 3. Non-Goals

Do NOT implement in Sprint 7:

- Rewarded Ads;
- Interstitial Ads;
- Remove Ads;
- IAP real-money Coin packs;
- purchase restoration;
- store receipt validation;
- Daily Reward;
- Daily Streak;
- Daily Challenge reward;
- subscription;
- premium currency;
- Starter Pack;
- full economy live tuning UI;
- CMS economy editor;
- leaderboard rewards.

---

# 4. Approved Economy Values

## Starting Resources

- **Starting Coins:** 300
- **Starting Hints:** 3

## Hint

- **Hint Coin price:** 75 Coins

## Extra Moves

Grant:
- **+5 Moves**

Coin pricing:
- first rescue: **150 Coins**
- second rescue: **250 Coins**

Limit:
- maximum **2 per Attempt**

## Dead-End Rescue

Price:
- **200 Coins**

Limit:
- maximum **1 per Attempt**

## Level Reward

Formula:

```text
50 + (2 × Remaining Moves) + Streak Coins
```

Base:
- 50 Coins

Remaining Move:
- 2 Coins per remaining Move

## Chapter Completion Reward

- 500 Coins
- 2 Hints

These values are approved.

---

# 5. Economy Authority Principle

The client must never be the final authority for:

- Coin balance;
- Hint inventory;
- reward eligibility;
- reward grant;
- Coin spend;
- Hint spend;
- Extra Moves spend;
- Dead-End Rescue spend.

Trusted backend decides and records all authoritative mutations.

---

# 6. Wallet Model

Recommended authoritative wallet:

```text
coinBalance
hintBalance
walletRevision
updatedAt
```

Optional derived fields:
- lifetimeEarnedCoins
- lifetimeSpentCoins

Do not add unapproved currency types.

---

# 7. Wallet Firestore Structure

Recommended:

```text
players/{uid}/economy/wallet
players/{uid}/economy/transactions/{transactionId}
```

or equivalent trusted structure.

Client may read wallet.

Client must not directly write authoritative wallet fields.

---

# 8. Wallet Initialization

On first trusted economy setup:

Apply once:

```text
+300 Coins
+3 Hints
```

Use idempotency key such as:

```text
initial_grant:{uid}:v1
```

Repeated initialization:
- returns existing result;
- never doubles balance.

---

# 9. Transaction Ledger

Every authoritative mutation must record:

```text
transactionId
uid
type
resource
amount
balanceBefore
balanceAfter
idempotencyKey
referenceType
referenceId
createdAt
metadata
```

Do not store unnecessary personal data.

---

# 10. Transaction Types

Suggested:

```text
initialGrant
levelReward
chapterReward
hintPurchase
extraMovesPurchase
deadEndRescuePurchase
offlineSpendReconciliation
adminAdjustmentFuture
iapGrantFuture
rewardedAdGrantFuture
dailyRewardFuture
dailyChallengeRewardFuture
```

Future types may exist in enum but should not be active until their sprints.

---

# 11. Idempotency

Mandatory for every mutation.

Trusted API accepts:

```text
idempotencyKey
```

Same logical operation repeated:
- returns original result;
- no duplicate mutation.

Examples:

```text
level_reward:{uid}:{levelId}:{completionId}
chapter_reward:{uid}:{chapterId}:v1
hint_purchase:{uid}:{operationId}
extra_moves:{uid}:{attemptId}:{rescueIndex}
dead_end_rescue:{uid}:{attemptId}
```

---

# 12. Level Reward Grant

Client submits trusted claim after Engine-confirmed Win and progression update.

Payload should include minimal verifiable data:

```text
levelId
completionId
remainingMoves
streakCoins
rulesVersion
```

Server calculates:

```text
reward = 50 + (2 × remainingMoves) + streakCoins
```

Do not trust client-submitted total reward.

---

# 13. Level Reward Verification

Backend should validate:

- authenticated UID;
- Level exists/eligible;
- completion claim not already rewarded;
- numeric ranges sane;
- remainingMoves >= 0;
- streakCoins sane under rules;
- completion/progression state consistent enough for MVP.

Do not over-engineer full anti-cheat proof in this sprint.

---

# 14. Level Reward Idempotency

One eligible completion grant per intended completion policy.

Current MVP progression is sequential.

For first-time progression reward:
- reward once per Level completion.

If replay rewards are not approved:
- do not grant again for replayed completed Level.

Default Sprint 7 policy:
- reward only first completion of Level.

If project docs already specify replay reward differently, latest approved decision wins.

---

# 15. Chapter Reward Grant

When final Level completes Chapter:

Grant once:

```text
+500 Coins
+2 Hints
```

Idempotency key:

```text
chapter_reward:{uid}:{chapterId}:v1
```

Never duplicate on:
- retry;
- app restart;
- duplicate sync;
- repeated result screen.

---

# 16. Hint Purchase

Trusted operation:

```text
purchaseHint
```

Cost:

```text
75 Coins
```

Result:

```text
-75 Coins
+1 Hint
```

Must:
- check sufficient balance;
- mutate atomically;
- record ledger;
- return new balances.

---

# 17. Hint Consumption

Using a Hint consumes:

```text
1 Hint
```

Important:
- Solver produces suggestion.
- Economy operation consumes Hint resource.

Recommended flow:

1. request Hint action from Solver;
2. if Hint available:
   - consume Hint authoritatively;
3. only after successful consumption:
   - show Hint.

Avoid charging when Solver returns Inconclusive.

---

# 18. Hint Failure Cases

Do not charge Hint if:
- already won;
- Solver inconclusive;
- no valid winning continuation;
- backend consumption failed.

If charge succeeds but app fails before showing:
- operation idempotency/recovery should allow redisplay/retry without double charge where practical.

---

# 19. Extra Moves Purchase

Trusted operation:

```text
purchaseExtraMoves
```

Per Attempt:

```text
rescueIndex 1 -> 150 Coins
rescueIndex 2 -> 250 Coins
```

Grant:
- +5 Moves

Maximum:
- 2/Attempt

---

# 20. Extra Moves Authority Split

Backend authorizes and charges.

Game Engine/application applies the +5 Move extension through a controlled non-gameplay operation after successful trusted purchase.

Do not let arbitrary UI mutate `movesRemaining`.

---

# 21. Extra Moves Idempotency

Key:

```text
extra_moves:{uid}:{attemptId}:{rescueIndex}
```

Duplicate call:
- no double charge;
- no double grant.

Backend must validate:
- rescueIndex sequence;
- max 2;
- enough Coins.

---

# 22. Dead-End Rescue Purchase

Trusted operation:

```text
purchaseDeadEndRescue
```

Cost:
- 200 Coins

Limit:
- 1/Attempt

The actual Solver-Guided Recovery State creation belongs to gameplay/recovery integration.

Sprint 7 economy responsibility:
- authorize spend;
- record rescue entitlement/use for Attempt;
- prevent duplicate purchase.

---

# 23. Dead-End Rescue Idempotency

Key:

```text
dead_end_rescue:{uid}:{attemptId}
```

Duplicate:
- no double charge.

---

# 24. Attempt Economy Metadata

Local Attempt should track:

```text
extraMovesPurchasesUsed
deadEndRescueUsed
economyOperationIds
```

Authoritative backend should also verify attempt-scoped limits where practical.

Do not trust client counters alone.

---

# 25. Offline Coin Spending — Approved Principle

Offline Coin spending is allowed against locally reconciled balance.

Required:

- local cached wallet;
- pending idempotent transaction;
- optimistic local reservation;
- later reconciliation.

This is the trickiest part of Sprint 7.

---

# 26. Offline Spend Scope

Offline spend may be used for approved Coin utilities such as:

- Hint purchase;
- Extra Moves;
- Dead-End Rescue;

only when product flow can safely reconcile later.

Network-dependent features remain unavailable offline.

---

# 27. Offline Wallet Cache

Local state:

```text
lastServerCoinBalance
lastServerHintBalance
pendingCoinDelta
pendingHintDelta
availableLocalCoinBalance
availableLocalHintBalance
walletRevision
lastReconciledAt
```

Recommended:

```text
available = lastServerBalance + acceptedLocalPendingDelta
```

Do not permanently fork balances.

---

# 28. Offline Spend Reservation

When offline:

1. validate against local reconciled available balance;
2. create pending operation with idempotency key;
3. reserve/deduct locally;
4. grant local utility effect;
5. sync later.

If server later rejects:
- reconciliation must handle deficit/conflict safely.

---

# 29. Offline Spend Risk

Because the same account could spend offline on multiple devices, over-spend is possible.

MVP policy must be conservative.

Recommended:
- allow offline spending only using balance known from last reconciliation;
- maintain device-local pending reservations;
- server processes in arrival order;
- rejected conflicting operations reconcile back.

Do not claim perfect multi-device offline prevention.

---

# 30. Reconciliation Result

Pending operation outcomes:

```text
accepted
duplicateAccepted
rejectedInsufficientFunds
rejectedLimitReached
rejectedInvalid
retryableFailure
```

Local client applies canonical server result.

---

# 31. Rejected Offline Spend

If a previously granted local utility was consumed but server rejects later, product recovery can be complex.

For MVP safest approach:

- only allow offline spends that affect current local Attempt;
- on conflict, reconcile Wallet and log;
- do not retroactively corrupt completed board.

Document debt/negative handling if needed.

Prefer preventing likely over-spend through conservative balance cache.

---

# 32. Negative Balance

Authoritative Wallet should never go negative.

Backend must atomically verify:

```text
balance >= cost
```

before spend.

Local optimistic balance should also never go below zero.

---

# 33. Atomic Backend Mutation

Economy operation should atomically:

1. validate;
2. check idempotency;
3. read wallet;
4. ensure balance;
5. update wallet;
6. write ledger;
7. write operation receipt;
8. commit.

Use Firestore transaction or equivalent trusted transactional mechanism.

---

# 34. Economy Operation Receipt

Recommended record:

```text
players/{uid}/economy/operations/{idempotencyKeyHash}
```

Contains:
- status;
- transaction IDs;
- resulting balances;
- operation type;
- reference.

This simplifies duplicate responses.

---

# 35. Trusted Backend API

Recommended callable HTTPS/Callable Function endpoints:

```text
initializeWallet
grantLevelReward
grantChapterReward
purchaseHint
consumeHint
purchaseExtraMoves
purchaseDeadEndRescue
getWalletSnapshot
reconcilePendingOperations
```

Do not expose generic `adjustBalance(amount)` endpoint to client.

---

# 36. Client Wallet Repository

Recommended:

```dart
abstract interface class WalletRepository {
  Future<WalletSnapshot> getSnapshot();
  Stream<WalletSnapshot> watchLocalSnapshot();
  Future<EconomyResult> purchaseHint(...);
  Future<EconomyResult> consumeHint(...);
  Future<EconomyResult> purchaseExtraMoves(...);
  Future<EconomyResult> purchaseDeadEndRescue(...);
  Future<EconomyResult> claimLevelReward(...);
  Future<EconomyResult> claimChapterReward(...);
}
```

---

# 37. Wallet Snapshot

Suggested:

```text
coinBalance
hintBalance
pendingCoinDelta
pendingHintDelta
effectiveCoinBalance
effectiveHintBalance
revision
syncStatus
```

UI should distinguish stale/offline state subtly if needed.

---

# 38. Economy Queue

Reuse/extend Sprint 6 sync queue.

Operation types:

```text
economyHintPurchase
economyHintConsume
economyExtraMoves
economyDeadEndRescue
economyLevelReward
economyChapterReward
```

However:

Reward claims may be queued offline.

Server resolves idempotently later.

---

# 39. Offline Level Reward Claim

Player may win offline.

Flow:

1. local result displays calculated reward.
2. queue level reward claim.
3. local pending reward may optionally appear as pending balance.

Safer recommendation:
- reflect it in local effective balance as pending grant;
- mark pending until reconciled.

This preserves offline continuity.

---

# 40. Pending Grant Model

Local wallet may include:

```text
pendingEarnedCoins
pendingEarnedHints
pendingSpentCoins
pendingSpentHints
```

Effective display:

```text
reconciled balance + pending accepted-local deltas
```

UI does not need to expose complexity unless sync issue occurs.

---

# 41. Reward Eligibility

Backend should prevent duplicate first-completion rewards.

Possible proof sources:
- cloud progression record;
- reward receipt record;
- completion ID.

Do not trust only client “I won”.

---

# 42. Completion ID

Generate stable unique completion ID per successful first completion event.

Store:
- locally;
- sync;
- reward claim.

Backend dedupes by:
- level reward key;
- completion ID.

---

# 43. Replay Reward Policy

Because repeated completed Level reward behavior is not approved as a farming loop:

Sprint 7 should enforce:
- no repeat authoritative Level reward for replay.

Replays remain gameplay-only unless later approved.

---

# 44. Streak Coins Validation

Server should not trust arbitrary streak Coins.

Options:

- validate against sane maximum from level/Move count;
- or accept value from signed/trusted completion proof later.

For Sprint 7:
- apply conservative range checks;
- log suspicious claims.

Full anti-cheat comes later.

---

# 45. Wallet UI

Add wallet display where appropriate:

- Home header;
- gameplay utility bar;
- result screen.

Display:
- Coins;
- Hints.

No premium currency.

---

# 46. Hint UI Integration

Hint button should show:
- current Hint balance;
- if 0:
  - offer Coin purchase at 75 Coins.

Rewarded Ad option comes later.

---

# 47. Extra Moves UI Integration

At Out-of-Moves:

- first Coin rescue: 150 Coins
- second Coin rescue: 250 Coins
- each +5 Moves
- max 2

If insufficient balance:
- disable Coin purchase;
- no ad option yet.

---

# 48. Dead-End Rescue UI Integration

At confirmed Dead-End:

Offer:
- 200 Coin rescue
- max once per Attempt
- Restart

Actual recovery-state generation must only proceed after successful economy authorization.

---

# 49. Purchase Confirmation

For meaningful Coin spend:
- clear CTA with cost.

Whether an extra confirmation dialog is needed is UX detail.

Avoid accidental double taps through operation-in-flight locking/idempotency.

---

# 50. Operation-In-Flight State

Disable repeated tap while same operation pending.

Still rely on backend idempotency.

UI locking is convenience, not correctness.

---

# 51. Wallet Refresh

Refresh:
- app resume;
- sync complete;
- economy operation result;
- account identity change.

Avoid constant polling.

---

# 52. Firestore Security Rules

Client:
- may read own Wallet snapshot if stored readably.
- must not write authoritative wallet/ledger directly.

Recommended:
- wallet writes denied to client;
- ledger writes denied;
- operation receipts read-only where needed.

Trusted Functions/Admin SDK bypass client rules.

---

# 53. Emulator Tests — Security

Required:

- user cannot set own `coinBalance`;
- user cannot set own `hintBalance`;
- user cannot create ledger transaction;
- user cannot modify operation receipt;
- user A cannot read user B wallet;
- own permitted read succeeds.

---

# 54. Backend Unit Tests

Test:

- initial grant once;
- duplicate initial grant no-op;
- level reward formula;
- duplicate level reward;
- chapter reward once;
- insufficient funds;
- Hint purchase atomicity;
- Extra Moves first/second pricing;
- third Extra Moves rejected;
- Dead-End second purchase rejected;
- idempotent duplicate spend;
- no negative balance.

---

# 55. Offline Reconciliation Tests

Required:

- offline Hint purchase queued;
- offline Level reward queued;
- reconnect accepted;
- duplicate queue delivery safe;
- insufficient-funds rejection reconciles;
- multi-device race does not create negative wallet;
- stale wallet refresh corrects local cache.

---

# 56. Economy Integration Scenario

### EC-001 — New Player

1. new identity.
2. initialize Wallet.
3. receives 300 Coins + 3 Hints.
4. app restart.
5. balances unchanged.
6. duplicate init does not grant again.

---

# 57. Level Reward Scenario

### EC-002

1. complete Level with:
   - 4 Moves remaining;
   - 7 streak Coins.
2. preview:
   - 50 + 8 + 7 = 65.
3. claim.
4. backend grants 65 once.
5. duplicate claim returns same receipt.
6. replay Level grants nothing additional.

---

# 58. Chapter Reward Scenario

### EC-003

1. complete Chapter final Level.
2. normal Level reward granted.
3. Chapter reward:
   - +500 Coins;
   - +2 Hints.
4. duplicate flow after restart grants nothing additional.

---

# 59. Hint Scenario

### EC-004

1. Hint balance > 0:
   - Solver finds Hint;
   - consume 1 Hint;
   - show Hint.
2. Hint balance 0:
   - buy Hint for 75 Coins;
   - Hint balance +1;
   - then consume when requested.

---

# 60. Extra Moves Scenario

### EC-005

1. Out-of-Moves.
2. buy first rescue:
   - 150 Coins;
   - +5 Moves.
3. reach Out-of-Moves again.
4. buy second:
   - 250 Coins;
   - +5 Moves.
5. third attempt rejected.

---

# 61. Dead-End Rescue Scenario

### EC-006

1. Solver confirms Dead-End.
2. buy rescue for 200 Coins.
3. operation succeeds once.
4. generate Solver-Guided Recovery State.
5. second rescue purchase rejected.

---

# 62. Offline Win Scenario

### EC-007

1. device offline.
2. player wins Level.
3. reward preview shown.
4. claim queued.
5. local effective Wallet reflects pending grant if implemented.
6. reconnect.
7. server grants once.
8. local reconciles.

---

# 63. Multi-Device Spend Race

### EC-008

1. same account on A and B.
2. both cached at 200 Coins.
3. A spends 150.
4. B offline attempts 150.
5. server accepts one valid order and rejects operation that would overdraw.
6. authoritative balance never negative.
7. B reconciles safely.

---

# 64. Economy Error Model

Suggested:

```text
insufficientFunds
insufficientHints
limitReached
duplicate
invalidOperation
notEligible
offlineQueued
serverUnavailable
authRequired
schemaMismatch
internalError
```

Do not expose backend stack traces.

---

# 65. Economy Result

Recommended:

```text
status
operationId
transactionIds
walletSnapshot
grant/spend details
isPending
errorCode
```

---

# 66. Local Pending State

Drift tables:

```text
wallet_cache
economy_operations
economy_receipts
```

Could reuse generic sync operations with typed payload.

Keep schema clean.

---

# 67. Wallet Revision

Trusted backend increments:

```text
walletRevision
```

Client stores last reconciled revision.

Use to detect stale cache.

---

# 68. Transaction Ordering

Backend timestamps are authoritative.

Client-created time only diagnostic.

---

# 69. Analytics

Track:

- wallet_initialized;
- reward_claimed;
- reward_duplicate;
- hint_purchased;
- hint_consumed;
- extra_moves_purchased;
- dead_end_rescue_purchased;
- economy_insufficient_funds;
- economy_offline_queued;
- economy_reconciled;
- economy_rejected.

No sensitive tokens.

---

# 70. Fraud / Abuse Signals

Log suspicious:

- impossible repeated reward claims;
- invalid high streak Coins;
- repeated rejected operations;
- malformed attempt references.

Do not build full anti-fraud engine yet.

---

# 71. Cloud Function Organization

Suggested:

```text
firebase/functions/src/economy/
├── initialize_wallet.ts
├── grant_level_reward.ts
├── grant_chapter_reward.ts
├── purchase_hint.ts
├── consume_hint.ts
├── purchase_extra_moves.ts
├── purchase_dead_end_rescue.ts
├── wallet_service.ts
├── transaction_repository.ts
└── economy_validation.ts
```

Language/runtime may follow existing Firebase function stack.

Do not introduce .NET backend.

---

# 72. Function Authentication

Every client-callable economy endpoint:
- requires Firebase Auth;
- uses `context.auth.uid`;
- never trusts UID passed from client as authority.

---

# 73. App Check

Enable/prepare App Check where practical.

Still:
- not substitute for auth;
- not substitute for idempotency;
- not substitute for server validation.

---

# 74. Rate Limiting

Basic abuse protection recommended.

Could use:
- per-operation limits;
- attempt-scoped limits;
- function-level protections.

Do not overbuild global rate-limiter infrastructure.

---

# 75. Attempt Reference Validation

For Extra Moves / Dead-End Rescue:

Payload includes:
- attemptId;
- levelId;
- rescue index/type.

Backend may store attempt economy usage receipt.

No need to upload full GameState.

---

# 76. Economy / Gameplay Separation

Game Engine:
- tracks gameplay state.

Economy:
- authorizes resource spend/grant.

Application:
- coordinates both.

Example Extra Moves:

```text
OutOfMoves
  ↓
Economy purchase approved
  ↓
Application applies controlled +5 Moves
  ↓
Gameplay resumes
```

---

# 77. Controlled Move Grant

Add an application/domain-level operation that safely extends Attempt Moves.

Do not route through normal `GameAction` if it would imply 1-Move cost/streak semantics.

Recommended:
- `applyExtraMovesGrant(5)` through a controlled Attempt service or explicit Engine system operation.

Document boundary.

---

# 78. Dead-End Recovery Integration

After successful 200-Coin authorization:

1. request Solver-Guided Recovery State.
2. verify resulting state has winning continuation.
3. replace current local GameState through controlled recovery operation.
4. persist Attempt.
5. mark rescue used.
6. gameplay resumes.

If recovery generation fails after charge:
- operation must support retry without re-charge.
- do not charge again.

---

# 79. Rescue Receipt

Economy receipt should allow:
- recovery retry after app crash.

Store:
```text
attemptId
rescueAuthorized = true
rescueApplied = false/true
```

or equivalent local/trusted state.

---

# 80. Extra Moves Crash Recovery

If backend charged but app crashed before applying +5:

On resume:
- fetch/reconcile operation receipt;
- apply grant once locally.

Need local idempotency marker:
```text
appliedEconomyOperationIds
```

---

# 81. Exactly-Once Effect Pattern

For spend-backed local effects:

1. server mutation idempotent.
2. client receives operation receipt.
3. client applies local effect if receipt not yet applied.
4. mark receipt applied locally.
5. repeat safely on restart.

This is critical.

---

# 82. Reward Exactly-Once Pattern

For reward:
- server grant is source of truth.
- client only refreshes Wallet after receipt.
- no duplicate local additive math after reconciliation.

---

# 83. UI Wallet Consistency

Prefer:
- render from local reconciled wallet cache;
- update optimistically only for offline pending operations;
- reconcile to server snapshot.

Avoid scattered Coin counters.

---

# 84. Insufficient Funds UX

Show:
```text
رصيدك غير كافٍ
```

No real-money Coin pack CTA yet because IAP comes later.

Could show only:
- current balance;
- cancel.

---

# 85. Hint Inventory UX

Show count.

If 0:
- Coin purchase option.

No ad option yet.

---

# 86. Result Screen Integration

After Win:

1. calculate preview immediately.
2. queue/submit grant.
3. update Wallet when authoritative result arrives.
4. allow progression flow without long blocking if offline.

Do not force network before player can continue.

---

# 87. Chapter Reward Offline

Same:
- queue authoritative grant;
- progression continues;
- reconcile later.

---

# 88. Economy Sync Priority

Pending spends should generally reconcile before new dependent spends if online.

Maintain operation ordering where balance dependency exists.

---

# 89. Queue Ordering

Use FIFO per wallet where practical.

Do not process dependent spend operations in arbitrary parallel order.

Reward grants may be processed safely with idempotency but still maintain deterministic sequencing.

---

# 90. Concurrency

Backend transactions protect concurrent operations.

Client:
- serialize local wallet-affecting queue per user.

---

# 91. Account Change

If Firebase UID changes:
- pause economy queue;
- do not send old player operations under new UID;
- preserve queues scoped by identity.

---

# 92. Identity-Scoped Wallet Cache

Wallet cache and pending operations must be scoped to:

```text
firebaseUid / logicalPlayerId
```

Never mix accounts.

---

# 93. Local Logout/Conflict Safety

On account conflict:
- do not merge Wallets.
- do not transfer pending economy operations automatically.
- preserve current local account state.

Wallet merge is not approved.

---

# 94. Wallet Cloud Read

Use direct own-wallet read.

Avoid always-on listeners unless needed.

Refresh on meaningful events.

---

# 95. Cost-Conscious Economy

Economy operations are low frequency.

Prefer:
- one function call;
- one transaction;
- minimal document reads/writes.

Do not create event-stream infrastructure.

---

# 96. Emulator Setup

Use:
- Auth Emulator;
- Firestore Emulator;
- Functions Emulator.

Economy integration tests should run without PROD.

---

# 97. Security Rule Test Matrix

- wallet client write denied;
- ledger client write denied;
- operation receipt client write denied;
- own wallet read allowed if intended;
- other-user wallet read denied;
- other-user ledger denied.

---

# 98. Function Test Matrix

- unauthenticated call rejected;
- duplicate idempotency handled;
- invalid payload rejected;
- sufficient/insufficient balance;
- transaction rollback on failure;
- ledger and wallet remain consistent.

---

# 99. Ledger Invariants

For every transaction:

```text
balanceAfter = balanceBefore + amount
```

For spend:
- amount negative.

Wallet balance must equal ordered ledger accumulation from initial state conceptually.

Exact audit reconstruction can be a QA tool.

---

# 100. Ledger Audit Tool

Recommended dev/test utility:

- read Wallet;
- read ledger;
- recompute balance;
- verify consistency.

No UI required.

---

# 101. Schema Versioning

Include:

```text
economySchemaVersion
walletSchemaVersion
transactionSchemaVersion
```

Do not overwrite unknown newer schema.

---

# 102. Remote Config Boundary

Economy values are approved and may become configurable later.

For Sprint 7:
- define typed config with approved defaults;
- sensitive authoritative prices must also be known by backend.

Never rely only on client Remote Config for spend cost.

---

# 103. Economy Config Source

Trusted backend should use:
- versioned server config;
or
- server-controlled Remote Config equivalent where appropriate.

Client receives values for display.

Server remains authority.

---

# 104. Config Version

Every economy operation may include/return:

```text
economyConfigVersion
```

Useful for diagnostics.

---

# 105. Price Mismatch

If client shows stale 150 but server expects changed value in future:
- server response should return authoritative price/error.
- client refreshes config.

For current v1 values fixed/approved.

---

# 106. Testing Offline First

Sprint 7 must prove:

- player can complete Level offline;
- reward claim queues;
- player can spend locally only if allowed by cached balance;
- reconnect reconciles;
- no duplicate grants;
- no negative authoritative balance.

---

# 107. Performance

Measure:
- wallet read;
- function call latency;
- offline queue flush;
- result-screen non-blocking behavior.

No economy operation should freeze gameplay UI.

---

# 108. Accessibility

Economy dialogs:
- clear cost;
- clear resource icon/text;
- RTL;
- semantic buttons;
- insufficient-funds message understandable without color.

---

# 109. Developer Tools

DEV-only:
- inspect wallet cache;
- inspect pending economy queue;
- copy operation ID;
- force sync;
- simulate offline;
- view ledger summary.

Do not add “give me Coins” client shortcut connected to PROD backend.

---

# 110. Suggested Client Feature Structure

```text
apps/mobile/lib/features/economy/
├── application/
├── data/
├── domain/
└── presentation/
```

Possible domain:
```text
WalletSnapshot
EconomyOperation
EconomyReceipt
EconomyError
```

---

# 111. Suggested Backend Structure

```text
firebase/functions/src/economy/
├── api/
├── domain/
├── repositories/
├── validation/
└── config/
```

Keep simple and testable.

---

# 112. Suggested Implementation Order

## Step 1
Wallet domain model + local cache.

## Step 2
Trusted wallet initialization.

## Step 3
Transaction ledger.

## Step 4
Idempotency receipts.

## Step 5
Level reward grant.

## Step 6
Chapter reward grant.

## Step 7
Hint purchase + consume.

## Step 8
Extra Moves purchase.

## Step 9
Dead-End Rescue purchase.

## Step 10
Offline economy queue.

## Step 11
Reconciliation.

## Step 12
Gameplay/result UI integration.

## Step 13
Security rules.

## Step 14
Emulator tests.

## Step 15
Crash recovery/idempotent local effect application.

## Step 16
Cost/performance audit.

---

# 113. Suggested Commit Sequence

### Commit 1
```text
feat(economy): add wallet domain cache and transaction contracts
```

### Commit 2
```text
feat(economy): add trusted wallet initialization and starting grants
```

### Commit 3
```text
feat(economy): add idempotent transaction ledger
```

### Commit 4
```text
feat(economy): add level and chapter reward grants
```

### Commit 5
```text
feat(economy): add hint purchase and consumption
```

### Commit 6
```text
feat(economy): add extra moves and dead-end rescue purchases
```

### Commit 7
```text
feat(economy): add offline operation queue and reconciliation
```

### Commit 8
```text
feat(gameplay): integrate authoritative utility spends and rewards
```

### Commit 9
```text
security(economy): deny direct wallet and ledger client writes
```

### Commit 10
```text
test(economy): add emulator idempotency offline and concurrency coverage
```

### Commit 11
```text
chore(economy): add ledger audit and dev diagnostics
```

### Commit 12
```text
docs(economy): document wallet authority and reconciliation
```

---

# 114. Sprint 7 Definition of Done

Sprint 7 is DONE only when:

- [ ] authoritative Wallet exists.
- [ ] authoritative Hint balance exists.
- [ ] starting 300 Coins granted once.
- [ ] starting 3 Hints granted once.
- [ ] transaction ledger exists.
- [ ] every operation has idempotency key.
- [ ] duplicate operations do not duplicate effects.
- [ ] Level reward formula enforced server-side.
- [ ] first Level completion reward granted once.
- [ ] replay does not farm duplicate Level reward.
- [ ] Chapter reward grants 500 Coins + 2 Hints once.
- [ ] Hint purchase costs 75 Coins.
- [ ] Hint consumption costs 1 Hint.
- [ ] Solver Inconclusive does not consume Hint.
- [ ] Extra Moves first rescue costs 150.
- [ ] Extra Moves second rescue costs 250.
- [ ] third Extra Moves rescue rejected.
- [ ] each Extra Moves rescue grants +5 Moves exactly once.
- [ ] Dead-End Rescue costs 200.
- [ ] second Dead-End Rescue rejected.
- [ ] crash recovery prevents double local effect.
- [ ] offline wallet cache exists.
- [ ] offline Coin spend queue exists.
- [ ] offline reward claims queue.
- [ ] reconnect reconciliation works.
- [ ] authoritative balance never negative.
- [ ] multi-device spend race handled safely.
- [ ] client direct wallet write denied.
- [ ] client direct ledger write denied.
- [ ] cross-player wallet access denied.
- [ ] emulator tests pass.
- [ ] EC-001 passes.
- [ ] EC-002 passes.
- [ ] EC-003 passes.
- [ ] EC-004 passes.
- [ ] EC-005 passes.
- [ ] EC-006 passes.
- [ ] EC-007 passes.
- [ ] EC-008 passes.
- [ ] Flutter analyze passes.
- [ ] backend tests pass.
- [ ] no ads/IAP/Daily economy added prematurely.

---

# 115. Sprint 7 Exit Gate Before Monetization

Do not start Sprint 8 until:

1. wallet authority is proven;
2. initial grants are exactly-once;
3. reward claims are idempotent;
4. utility purchases are idempotent;
5. offline reconciliation is stable;
6. crash recovery prevents double local effects;
7. client cannot directly mutate Wallet;
8. ledger is consistent;
9. multi-device race does not create negative balance;
10. gameplay/result flow remains non-blocking offline;
11. emulator security tests are green;
12. economy config/versioning is documented.

---

# 116. Cursor Execution Prompt — Sprint 7

Use this after Sprint 6 passes its exit gate:

> Implement **Sprint 7 — Economy, Wallet & Server-Authoritative Rewards v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_7_Economy_Wallet_and_Server_Authoritative_Rewards_v1.0.md`
> - latest Game Economy Design
> - latest Monetization Specification where economy boundaries are relevant
> - latest Data Model
> - latest Firebase/Cloud architecture
>
> Implement a trusted, idempotent economy system using Firebase serverless infrastructure.
>
> Implement:
>
> - authoritative Coin Wallet;
> - authoritative Hint inventory;
> - one-time starting grant: 300 Coins + 3 Hints;
> - transaction ledger;
> - operation receipts/idempotency;
> - Level reward grant using `50 + 2 × remainingMoves + streakCoins`;
> - one-time Chapter reward: 500 Coins + 2 Hints;
> - Hint purchase for 75 Coins;
> - Hint consumption;
> - Extra Moves purchases:
>   - first 150 Coins;
>   - second 250 Coins;
>   - +5 Moves each;
>   - max 2 per Attempt;
> - Dead-End Rescue purchase:
>   - 200 Coins;
>   - max 1 per Attempt;
> - offline Coin/reward operation queue;
> - local reconciled Wallet cache;
> - reconnect reconciliation;
> - exactly-once application of spend-backed local gameplay effects;
> - Firestore/Function security;
> - emulator tests;
> - concurrency/idempotency tests;
> - wallet/result/gameplay UI integration.
>
> Critical constraints:
>
> - client must never directly authoritatively mutate Coin/Hint balance;
> - every mutation requires idempotency;
> - authoritative Wallet must never go negative;
> - replayed completed Levels must not farm duplicate rewards;
> - do not charge Hint if Solver cannot provide a proven Hint;
> - do not charge rescue twice if app crashes after server success;
> - server must calculate reward/cost authoritatively;
> - no Rewarded Ads;
> - no Interstitials;
> - no Remove Ads;
> - no IAP;
> - no Daily Reward/Streak/Challenge economy yet;
> - no subscription;
> - no premium currency;
> - preserve offline-first gameplay;
> - keep Firebase usage cost-conscious.
>
> Use trusted Cloud Functions/Cloud Run only where server authority is required.
>
> Do not create a generic client-callable balance-adjustment endpoint.
>
> At completion report:
>
> 1. files created/changed;
> 2. Wallet/ledger data model;
> 3. trusted function/API contracts;
> 4. idempotency strategy;
> 5. offline queue/reconciliation behavior;
> 6. Level/Chapter reward flow;
> 7. Hint/Extra Moves/Dead-End Rescue flow;
> 8. crash-recovery handling;
> 9. Firestore security rules;
> 10. emulator/concurrency tests;
> 11. observed Firebase reads/writes per common economy operation;
> 12. analyze/test/build results;
> 13. unresolved economy/product decisions;
> 14. any deviations from this Sprint document and why.

---

# 117. Next Sprint

After Sprint 7 passes the exit gate:

# **Sprint 8 — Ads, IAP & Monetization v1**

Expected focus:

- AdMob;
- Mediation;
- Rewarded Ads;
- Rewarded Coins;
- Rewarded Hint;
- Rewarded Extra Moves;
- Rewarded Dead-End Rescue;
- Interstitial cadence/guardrails;
- Remove Ads entitlement;
- Coin Pack IAP;
- server-side purchase validation;
- restore purchases;
- duplicate callback protection;
- store entitlements;
- monetization analytics.

---

**End of Sprint 7 — Economy, Wallet & Server-Authoritative Rewards v1**
