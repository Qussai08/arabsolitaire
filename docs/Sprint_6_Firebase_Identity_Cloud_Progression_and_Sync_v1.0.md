# Sprint 6 — Firebase Identity, Cloud Progression & Sync v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Cloud Identity / Sync / Multi-Device Progression Foundation  
**Depends On:** Sprint 5 — Product Loop, Tutorial & Journey v1  
**Primary App:** `apps/mobile`  
**Primary Cloud:** Firebase  
**Primary Local Store:** Drift / SQLite  
**Trusted Backend:** Cloud Functions and/or Cloud Run  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 6 Objective

Implement the first production-capable cloud identity and synchronization foundation for **سوليتير العرب: أسطورة المعاني**.

Sprint 6 must add:

- Firebase anonymous-first identity;
- optional Google/Apple account linking architecture;
- explicit account-link conflict handling;
- player cloud profile;
- cloud Journey progression;
- sync metadata;
- local/cloud reconciliation;
- offline-first synchronization queue;
- settings sync;
- Story progress sync where appropriate;
- safe multi-device progression foundation;
- Firestore security rules;
- idempotent sync operations;
- migration from local-only Sprint 5 progression;
- cloud availability without making gameplay network-dependent.

The target is:

> **The player can start anonymously, play offline, later reconnect, sync progress safely, and optionally link a permanent sign-in provider without losing valid progression.**

---

# 2. Sprint 6 Success Criteria

Sprint 6 is complete only when:

1. New installs can create/use Firebase Anonymous Auth.
2. Core gameplay still works if Firebase is unavailable.
3. Anonymous user receives a stable logical player identity.
4. Local Journey progress uploads safely to cloud.
5. Cloud progress restores on another device after identity linking/sign-in.
6. Progression merge uses highest valid progression.
7. Settings use latest-valid-revision reconciliation.
8. Active Attempt remains device-local in MVP.
9. Sync is not performed per gameplay Move.
10. Offline mutations queue locally.
11. Queued sync operations are idempotent.
12. Duplicate sync does not duplicate progression/events.
13. Google linking flow is architecturally supported.
14. Apple linking flow is architecturally supported.
15. Provider conflict never silently merges two different players.
16. Firestore client rules prevent cross-player data access.
17. Sensitive economy state is not made client-authoritative.
18. Local-only Sprint 5 users can migrate without losing progression.
19. Sync failures are recoverable.
20. Multi-device tests pass for progression/settings.
21. Network-offline product loop still passes.
22. Firebase reads/writes are kept coarse-grained and cost-conscious.

---

# 3. Non-Goals

Do NOT implement in Sprint 6:

- authoritative Wallet ledger;
- Coin grants/spends;
- IAP validation;
- Rewarded Ad grants;
- Extra Moves purchase;
- Dead-End rescue charging;
- Daily Reward/Streak backend authority;
- Daily Challenge backend scheduling;
- notification jobs;
- CMS;
- content publishing;
- leaderboards;
- XP;
- achievements;
- subscriptions;
- full account-management center;
- social graph;
- cross-device Active Attempt sync.

---

# 4. Identity Model

Approved identity strategy:

## Anonymous-first

Every player can begin immediately without registration.

Firebase Authentication should create an anonymous identity.

Cloud profile is tied to:

```text
firebaseUid
logicalPlayerId
```

For MVP, `firebaseUid` may be the technical identity key if architecture remains clean.

If introducing a separate `playerId`, document why.

---

# 5. Identity Principles

Identity must:

- never block first gameplay unnecessarily;
- support offline-first local bootstrap;
- allow later provider linking;
- survive app restarts;
- avoid silent account merging;
- prevent cross-user access;
- support multi-device restoration after permanent provider link.

---

# 6. Authentication States

Recommended:

```text
uninitialized
offlineLocalOnly
anonymousAuthenticated
linkedAuthenticated
linking
conflict
recoverableError
```

Do not force login screens on first launch.

---

# 7. Anonymous Authentication Flow

Preferred flow:

```text
App Bootstrap
  ↓
Load local player state
  ↓
Attempt Firebase init
  ↓
Existing Firebase user?
  ├── Yes → use identity
  └── No  → sign in anonymously
  ↓
Start background sync
```

If network unavailable:

```text
continue local-only
retry auth/sync later
```

Gameplay must not be blocked.

---

# 8. Logical Player Profile

Recommended Firestore document:

```text
players/{uid}
```

Fields may include:

```text
schemaVersion
createdAt
updatedAt
authType
linkedProviders
progressRevision
settingsRevision
lastSyncAt
appVersion
platformMetadata? minimal
```

Avoid storing unnecessary personal data.

---

# 9. Provider Linking

Supported future/initial providers:

- Google
- Apple

Linking means:

```text
anonymous Firebase user
  +
provider credential
  ↓
same Firebase logical account
```

Use Firebase account linking, not creating parallel profiles by default.

---

# 10. Provider Conflict Rule

Approved:

If provider credential is already attached to another Firebase account:

- do not silently merge;
- do not overwrite either profile;
- show explicit conflict flow.

Possible state:

```text
AccountLinkConflict
```

Application must expose enough information to choose a safe flow later.

---

# 11. Conflict Resolution Boundary

Sprint 6 should implement technical detection and safe UX scaffold.

Potential options may include:

- keep current anonymous progress;
- switch to existing provider account;
- later explicit merge workflow.

Exact full merge policy is not locked.

Therefore:

- detect;
- pause;
- preserve both;
- do not guess.

---

# 12. Local Player Identity

Before cloud auth succeeds, local data should belong to a local installation/player record.

Suggested local metadata:

```text
localPlayerId
firebaseUid?
identityState
createdAt
lastAuthAttemptAt
```

When Firebase identity becomes available:

- associate local progression safely;
- do not duplicate migration repeatedly.

---

# 13. Sync Domain Boundaries

Sprint 6 syncs:

- Journey progression;
- Chapter completion;
- unlocked Story Beats;
- viewed Story Beats;
- Tutorial/onboarding completion;
- selected user settings;
- sync/version metadata.

Sprint 6 does NOT sync:

- active gameplay Attempt;
- transient UI state;
- animation state;
- Solver traces;
- debug metadata;
- authoritative wallet.

---

# 14. Progression Merge Rule

Approved:

## Highest valid progression wins.

For sequential Journey:

```text
max(highestCompletedLevel)
```

subject to:

- content validity;
- known Level IDs;
- no impossible gaps if schema expects sequence.

Derived unlocks are recalculated from authoritative merged completion.

---

# 15. Progression Merge Semantics

Example:

Device A:
```text
highestCompletedLevel = 37
```

Cloud:
```text
highestCompletedLevel = 42
```

Merged:
```text
42
```

Do not downgrade valid progression.

---

# 16. Completed Level IDs

If storing explicit completed IDs:

- union only if they are valid Level Definitions;
- verify sequential rules;
- canonicalize derived progression.

For MVP sequential progression, storing just the highest completed valid Level may be sufficient.

Avoid redundant noisy data unless needed.

---

# 17. Chapter Progression

Chapter completion should be derived from Level completion where possible.

Example:

```text
Chapter complete iff final Level of Chapter completed
```

Do not trust contradictory client flags.

---

# 18. Story Progress Merge

Story Beats correspond to progression milestones.

Merge:

```text
unlockedStoryBeatIds = union(valid unlocked IDs)
viewedStoryBeatIds = union(valid viewed IDs)
```

But only retain IDs valid for current content schema.

Story viewed state does not alter core progression.

---

# 19. Tutorial / Onboarding Merge

Use monotonic booleans:

```text
onboardingCompleted = local || cloud
tutorialCompleted = local || cloud
```

Never regress completed onboarding due to older device state.

---

# 20. Settings Sync Rule

Approved:

## Latest valid revision wins.

Each synced settings document/state should include:

```text
revision
updatedAtServer
```

Prefer monotonic revision controlled through sync logic.

---

# 21. Settings Scope

Potential synced settings:

- language;
- sound enabled;
- music enabled;
- vibration/haptics enabled;
- notification preferences later.

Do not sync:
- device-specific performance flags;
- debug settings;
- temporary modal state.

---

# 22. Active Attempt Rule

Approved:

## Active Attempt remains local/device-specific in MVP.

Do not upload per-Move GameState.

Do not try to resume exact in-progress board across devices in Sprint 6.

Cloud may know:

```text
lastPlayedLevelId
```

but not full active board state.

---

# 23. Cloud Progression Data Model

Recommended structure:

```text
players/{uid}
players/{uid}/progression/main
players/{uid}/settings/main
players/{uid}/story/main
```

or a compact single-player document if data remains small.

Choose based on:

- write frequency;
- rule clarity;
- cost;
- future maintainability.

Avoid over-fragmentation.

---

# 24. Recommended Compact MVP Shape

A pragmatic initial model:

```text
players/{uid}
  profile fields

players/{uid}/state/progression
players/{uid}/state/settings
players/{uid}/state/story
```

This gives clear security and independent revisioning.

---

# 25. Progression Cloud Record

Suggested:

```text
schemaVersion
contentVersion
highestCompletedLevel
currentLevelId
updatedAt
revision
sourceDeviceId? non-sensitive
```

Avoid client-provided arbitrary unlock lists if derived.

---

# 26. Story Cloud Record

Suggested:

```text
schemaVersion
unlockedStoryBeatIds
viewedStoryBeatIds
revision
updatedAt
```

---

# 27. Settings Cloud Record

Suggested:

```text
schemaVersion
language
soundEnabled
musicEnabled
hapticsEnabled
revision
updatedAt
```

Only include settings that actually exist.

---

# 28. Sync Metadata

Local Drift should track:

```text
lastSuccessfulSyncAt
lastCloudRevision
pendingOperationsCount
lastSyncErrorCode
identityUid
syncSchemaVersion
```

---

# 29. Sync Queue

Use local durable queue.

Suggested table:

```text
sync_operations
```

Fields:

```text
operationId
operationType
payload
createdAt
attemptCount
nextRetryAt
status
idempotencyKey
```

---

# 30. Sync Operation Types

Sprint 6 examples:

```text
upsertProgression
upsertSettings
upsertStoryProgress
markTutorialCompleted
```

Prefer coarse-grained state sync over event-per-Move/event-per-Level if cost is lower and correctness remains.

---

# 31. Idempotency

Every queued operation must have:

```text
operationId
idempotencyKey
```

Repeated delivery:
- must not corrupt cloud state;
- must not duplicate side effects.

For simple upsert state:
- revision/merge semantics may naturally be idempotent.

Still preserve operation identity for diagnostics.

---

# 32. Sync Triggering

Recommended triggers:

- app becomes online;
- app resumes;
- Level completion;
- Chapter completion;
- Story progress change;
- settings change;
- explicit account link;
- periodic lightweight background opportunity where platform permits.

Do not sync every gameplay Move.

---

# 33. Sync Debounce

Coalesce rapid local changes.

Example:
- several settings toggles;
- multiple story flags during one flow.

Prefer one state upsert rather than many Firestore writes.

---

# 34. Offline Behavior

If offline:

- local state updates immediately;
- queue sync operation;
- UI continues;
- retry later.

Do not show blocking network errors for normal offline gameplay.

---

# 35. Sync State UX

Provide subtle account/sync state where useful.

Possible states:

```text
synced
syncing
offline
syncError
```

Do not make cloud status dominate gameplay UI.

---

# 36. Sync Conflict Principle

Use domain-specific rules.

Approved:

## Progression
Highest valid progression.

## Settings
Latest valid revision.

## Active Attempt
Local-only.

## Purchases/Entitlements
Deferred; store/backend authority later.

## Wallet
Deferred; server-authoritative later.

---

# 37. Cloud-to-Local Merge Flow

Recommended:

```text
authenticate
  ↓
load cloud state
  ↓
load local state
  ↓
validate both
  ↓
domain-specific merge
  ↓
persist merged local state
  ↓
upsert canonical cloud state if needed
```

---

# 38. Local-to-Cloud Initial Migration

For existing Sprint 5 user:

1. authenticate anonymously;
2. read cloud state;
3. if empty:
   - upload valid local state;
4. if cloud exists:
   - merge;
5. persist migration marker.

Do not reset local player.

---

# 39. Migration Marker

Persist:

```text
cloudMigrationVersion
cloudMigrationCompletedAt
firebaseUid
```

Migration must be re-runnable safely.

---

# 40. Multi-Device Scenario

Device A:
- anonymous → links Google.
- progresses to Level 80.
- syncs.

Device B:
- signs in with same Google identity.
- loads cloud.
- local fresh state merges to Level 80.
- Journey unlocks accordingly.

Active Attempt does not transfer.

---

# 41. Anonymous Account Limitation

Anonymous account alone is generally device/account-install dependent.

UI should later encourage linking for recovery.

Sprint 6 may expose a non-intrusive:

```text
احفظ تقدمك
```

entry point.

Do not force linking.

---

# 42. Account Linking UX

Minimum UI:

- “حفظ التقدم”
- Google
- Apple where supported
- current state indicator

Do not require email/password.

---

# 43. Apple Sign-In Platform Rule

Apple provider should be presented where supported/required.

Implementation details belong to Firebase/client integration.

Do not block Android on Apple-specific UI.

---

# 44. Google Sign-In

Integrate through Firebase Auth-compatible flow.

No separate user database password handling.

---

# 45. Sign-Out Behavior

Sign-out policy is not fully locked.

Sprint 6 recommendation:
- avoid prominent sign-out unless account UI needs it;
- if implemented, do not destroy local progression automatically;
- mark behavior clearly.

Do not silently sign the user into a new anonymous account and overwrite state.

---

# 46. Account Deletion

Not full scope in Sprint 6, but architecture should not block future privacy deletion.

Player cloud records must be addressable by UID and deletable later.

Do not implement irreversible partial deletion workflow prematurely.

---

# 47. Firebase Repository Interfaces

Recommended:

```dart
abstract interface class AuthRepository
abstract interface class CloudProgressionRepository
abstract interface class CloudSettingsRepository
abstract interface class CloudStoryRepository
abstract interface class SyncRepository
```

Keep Firebase SDK calls out of UI.

---

# 48. AuthRepository API

Suggested:

```dart
Future<AuthState> currentState();
Future<AuthState> ensureAnonymousIdentity();
Future<LinkResult> linkGoogle();
Future<LinkResult> linkApple();
Stream<AuthState> watchAuthState();
```

Exact naming may differ.

---

# 49. SyncCoordinator

Central application service.

Responsibilities:

- detect auth/online state;
- read local pending state;
- fetch cloud state;
- merge;
- persist canonical local state;
- push canonical cloud state;
- retry failures;
- expose sync status.

Do not scatter sync logic across widgets.

---

# 50. Network Connectivity

Do not rely solely on “network connected” indicator.

Actual Firebase operation may fail.

Treat connectivity signal as optimization, not truth.

---

# 51. Retry Strategy

Use bounded exponential backoff with jitter for background sync.

Do not hammer Firebase.

Suggested conceptual:

```text
1s
2s
4s
8s
...
capped
```

Exact tuning can remain configuration.

---

# 52. Retry Classification

Retry:
- transient network errors;
- unavailable;
- timeout.

Do not blindly retry:
- permission denied;
- malformed data;
- unsupported schema;
- auth conflict.

---

# 53. Firestore Transactions

Use transactions/batched writes only where atomic cross-field semantics require them.

Progression monotonic merge may use:

- trusted Cloud Function;
or
- security-rule-constrained client transaction if provably safe.

Because progression is player-owned and non-economic, client-side sync may be acceptable if rules prevent cross-user writes and state cannot unlock paid value.

Document choice.

---

# 54. Security Boundary

Progression is less sensitive than Wallet but still must not be globally writable.

Firestore rules:

- authenticated user only;
- UID path must equal `request.auth.uid`;
- schema constraints where practical;
- deny unknown collections by default.

---

# 55. Economy Separation

Do not add fields like:

```text
coins
hints
purchases
```

to client-writable progression documents.

Authoritative economy comes later through trusted backend operations.

This separation is mandatory.

---

# 56. Firestore Rules Baseline

Conceptual:

```text
match /players/{uid} {
  allow read, write: if request.auth != null
                     && request.auth.uid == uid;
}
```

Then tighten per subdocument/schema.

Do not use:

```text
allow read, write: if true;
```

in production.

---

# 57. Field Validation

Where practical, rules should validate:

- expected fields;
- field types;
- allowed revisions;
- non-negative progression;
- known reasonable limits.

Do not put complex game logic into Firestore rules.

---

# 58. Progression Tamper Boundary

Main Journey progression is client-derived from local Engine win.

Sprint 6 can sync it client-side.

However:
- do not use progression document as proof for economic grants later;
- Chapter/Level reward grants must be protected/idempotent in trusted backend when implemented.

This prevents forged progression from becoming free currency.

---

# 59. Server Timestamps

Use server timestamps for:

- cloud updatedAt;
- sync diagnostics;
- settings conflict support.

Do not use device clock as sole conflict authority.

---

# 60. Revision Numbers

Each domain document may carry monotonic:

```text
revision
```

Local change:
- increments local revision.

Cloud merge:
- chooses canonical state;
- writes next revision if needed.

Avoid infinite ping-pong.

---

# 61. Device ID

If useful, generate privacy-safe local installation ID for diagnostics.

Do not use advertising identifiers.

Use only for:
- sync origin diagnostics;
- conflict logs.

---

# 62. Sync Loop Prevention

After applying cloud state locally:
- do not immediately enqueue identical state indefinitely.

Use:
- revision comparison;
- content equality hash;
- last-synced snapshot.

---

# 63. State Hash

Optional:

```text
progressionHash
settingsHash
storyHash
```

Useful to skip redundant writes.

Not a security feature.

---

# 64. Cloud Schema Version

Every synced domain record includes:

```text
schemaVersion
```

Unsupported newer schema:
- do not overwrite;
- return explicit compatibility error.

---

# 65. Content Version Mismatch

If cloud progression references future/newer content version:

- preserve highest valid known progress;
- avoid destructive downgrade;
- defer unknown IDs;
- log mismatch.

Do not corrupt progression.

---

# 66. Local Schema Migration

Drift migration must add:

- identity table/fields;
- sync queue;
- sync metadata;
- cloud revisions.

Migration test required.

---

# 67. Suggested Drift Tables

```text
player_identity
sync_metadata
sync_operations
```

Existing:

```text
journey_progress
story_progress
settings/local_flags
```

may gain sync revision columns.

---

# 68. Auth Bootstrap

Recommended startup:

1. local DB ready.
2. app can enter Home.
3. Firebase init asynchronously.
4. ensure anonymous auth.
5. run sync.
6. update sync/account indicator.

Do not delay gameplay unnecessarily for auth.

---

# 69. Cold Start Offline

Expected:

- local identity loaded;
- Firebase auth pending/unavailable;
- local Journey works;
- sync indicator offline;
- no crash;
- no forced login.

---

# 70. Cold Start Online

Expected:

- local state loads quickly;
- anonymous/existing auth resolves;
- background merge runs;
- if cloud has higher progression:
  - Journey updates safely.

Avoid disruptive navigation jumps mid-gameplay.

---

# 71. Mid-Session Cloud Merge

If cloud reveals higher progression while user is on Home/Journey:
- update unlocked content.

If user is actively playing:
- do not destroy current Attempt.

Active Attempt remains local.

---

# 72. Current Level Reconciliation

After merge:

```text
currentLevel = highestCompletedLevel + 1
```

bounded by available content.

If active Attempt exists for a lower level:
- keep local Attempt playable until user exits;
- do not downgrade cloud progression.

---

# 73. Story Reconciliation

Higher cloud Journey progress may imply some Story Beats should be unlocked.

Recalculate canonical story unlock eligibility when needed.

Do not auto-mark unseen Story Beats as viewed unless cloud/local says viewed.

---

# 74. Tutorial Reconciliation

If cloud says tutorial complete:
- local device should not force Tutorial.

If local says complete and cloud does not:
- merge to complete.

---

# 75. Settings Conflict

Use:
- revision;
- server update timestamp if needed.

Example:
- Device A changes sound off.
- Device B changes language later.
- Avoid overwriting unrelated fields if using whole-document LWW.

Preferred:
- either per-settings-field metadata;
or
- one settings document with atomic user save semantics.

Keep v1 simple and document tradeoff.

---

# 76. Settings Merge Recommendation

For v1:

Use whole settings document with:

```text
revision
updatedAt
```

Latest valid revision wins.

If later simultaneous independent setting edits become an issue, evolve to per-field revision.

---

# 77. Sync Observability

Track locally and optionally analytics:

- sync_started;
- sync_completed;
- sync_failed;
- sync_conflict_detected;
- account_link_started;
- account_link_completed;
- account_link_conflict.

Do not log OAuth tokens.

---

# 78. Crashlytics Context

Safe metadata:

- auth state type;
- sync operation type;
- schema version;
- app environment.

Never:
- provider access token;
- ID token;
- raw credential payload.

---

# 79. Token Handling

Use Firebase SDK-managed auth tokens.

Do not manually persist provider access tokens in Drift.

Do not print tokens.

---

# 80. Firebase Emulator Support

Strongly recommended for Sprint 6.

Use Emulator Suite for:
- Auth;
- Firestore;
- Functions if used.

This allows repeatable tests without touching production.

---

# 81. Environment Separation

DEV / TEST / STAGING / PROD Firebase projects/configurations remain separate.

Never run automated integration tests against PROD.

---

# 82. Firestore Indexes

Only add indexes actually required.

Do not create large speculative index sets.

Player-state direct-document access should need minimal indexing.

---

# 83. Cost-Conscious Design

Prefer:

- direct document reads by UID;
- coarse-grained state writes;
- background sync on meaningful events;
- local-first reads.

Avoid:

- listeners on many documents;
- per-Move writes;
- frequent polling;
- unnecessary collection scans.

---

# 84. Snapshot Listeners

Use real-time listeners only if clearly beneficial.

For MVP progression sync:
- explicit fetch/sync lifecycle may be cheaper and simpler.

Do not default to always-on listeners.

---

# 85. Sync Frequency

Recommended:

- after meaningful progression event;
- app resume;
- account linking;
- manual retry;
- connectivity restoration.

Not:
- every card move;
- every animation;
- every screen rebuild.

---

# 86. Conflict UX

If account-link conflict occurs:

Show safe message:

```text
هذا الحساب مرتبط بتقدم آخر.
لن يتم دمج التقدم تلقائيًا.
```

Provide non-destructive options only.

Exact merge UX can be finalized later.

---

# 87. Progress Preservation

Before any identity switch/link conflict action:

- ensure local state is persisted;
- create recoverable snapshot if practical.

Never discard progress because OAuth returned an existing-account conflict.

---

# 88. Link Success

After provider link:

1. verify current Firebase UID remains intended identity;
2. fetch cloud state;
3. merge if necessary;
4. sync canonical state;
5. show confirmation:
   - progress protected.

---

# 89. Provider Already Linked

If linking provider already linked to current user:
- treat as success/no-op.

Do not duplicate state.

---

# 90. Auth Session Change

Watch Firebase auth state.

If UID changes unexpectedly:
- pause sync;
- preserve local state;
- require reconciliation flow.

Do not silently rebind local progression.

---

# 91. Security Rules Tests

Required using emulator where possible:

- unauthenticated player read denied;
- unauthenticated write denied;
- user A cannot read user B;
- user A cannot write user B;
- user can read own allowed state;
- user can write own allowed progression;
- economy fields cannot be written if present/protected;
- unknown restricted paths denied.

---

# 92. Auth Tests

Required:

- new user anonymous sign-in;
- existing anonymous session reuse;
- offline auth startup;
- Google link success mock/integration;
- Apple link success mock/integration;
- provider already linked;
- credential-in-use conflict;
- auth state change.

---

# 93. Sync Tests — Progression

Required:

- local 10 + cloud 15 => 15;
- local 20 + cloud 15 => 20 and cloud updated;
- equal => no redundant write;
- invalid cloud value ignored/rejected safely;
- local offline completion queues;
- reconnect uploads;
- duplicate queue replay safe.

---

# 94. Sync Tests — Story

Required:

- union unlocked IDs;
- union viewed IDs;
- invalid IDs removed/ignored;
- no duplicate storage;
- cloud higher Journey unlock recalculates eligible Story Beats.

---

# 95. Sync Tests — Settings

Required:

- newer valid revision wins;
- older revision ignored;
- malformed settings rejected;
- local change offline queued;
- reconnect syncs once.

---

# 96. Migration Tests

Required:

- Sprint 5 local-only player → Sprint 6 cloud profile;
- cloud empty;
- cloud ahead;
- local ahead;
- migration interrupted then retried;
- no duplicate profile mutation;
- no local progress loss.

---

# 97. Multi-Device Integration Scenario

### CS-001

Device A:
1. anonymous user.
2. Tutorial complete.
3. progresses to Level 12.
4. links Google.
5. sync completes.

Device B:
1. fresh app.
2. signs in/links same Google path.
3. cloud progression fetched.
4. Level 13 becomes current.
5. Tutorial not repeated.
6. Story progress restored.

---

# 98. Offline Reconciliation Scenario

### CS-002

1. Device offline at Level 20.
2. completes Levels 20–23.
3. local progress persists.
4. several sync operations coalesce.
5. reconnect.
6. cloud updates to Level 23 completion.
7. no duplicate writes/grants.
8. local remains correct.

---

# 99. Conflict Scenario

### CS-003

1. current anonymous user has Level 30.
2. player tries Google provider linked to another Firebase account with Level 50.
3. Firebase returns conflict.
4. local Level 30 preserved.
5. cloud Level 50 account untouched.
6. explicit conflict UI shown.
7. no automatic merge.

---

# 100. Security Scenario

### CS-004

1. user A authenticated.
2. attempt to read/write `players/userB/...`.
3. emulator rules deny.
4. own document access permitted according to schema.

---

# 101. Offline Core Regression

Re-run Sprint 5 product-loop offline scenario after Sprint 6.

Cloud feature must not regress:
- onboarding;
- Tutorial;
- Journey;
- gameplay;
- progression;
- story.

---

# 102. Sync Controller State

Recommended:

```text
idle
syncing
synced
offline
recoverableError
conflict
```

Expose to UI minimally.

---

# 103. Manual Sync Retry

Provide a retry action in account/settings sync status if error persists.

Do not require app restart.

---

# 104. Data Validation Layer

Before merging cloud state:

- parse typed DTO;
- validate schema;
- validate Level bounds;
- validate IDs;
- reject malformed data.

Never feed arbitrary Firestore maps directly to Journey state.

---

# 105. DTO / Domain Separation

Firebase DTOs should not leak into domain/UI.

Recommended:

```text
Firestore DTO
  ↓ mapper
Cloud Progression Model
  ↓ merge
Journey Domain State
```

---

# 106. Firestore Converter

Use typed converter/serialization pattern where practical.

Do not scatter string field names across app.

---

# 107. Date/Time

Use server timestamps for cloud metadata.

Do not rely on local clock for conflict truth.

Daily-system timezone logic is later.

---

# 108. Cloud Function Boundary

Sprint 6 may not need Functions for simple progression sync.

If used:
- justify trusted operation;
- keep cost-conscious;
- no always-on service.

Do not move simple read/write through backend solely for architecture aesthetics.

---

# 109. App Check

Firebase App Check can be prepared/enabled where feasible.

It is defense-in-depth, not authorization.

Do not rely on it instead of Security Rules.

If rollout complexity blocks Sprint 6:
- document as pre-production hardening item.

---

# 110. Privacy Principle

Store the minimum necessary identity/profile data.

Do not collect:
- age;
- address;
- contacts;
- phone;
- unnecessary demographics

for this sync system.

---

# 111. Account UI Structure

Suggested:

```text
الإعدادات
  └── الحساب وحفظ التقدم
      ├── الحالة: ضيف / محفوظ
      ├── Google
      ├── Apple
      └── حالة المزامنة
```

Keep concise.

---

# 112. Arabic UX Strings

All strings via localization.

Examples:

```text
حفظ التقدم
تم حفظ تقدمك
غير متصل
جارٍ المزامنة
تمت المزامنة
تعذر مزامنة التقدم
هذا الحساب مرتبط بتقدم آخر
```

Final wording may be polished.

---

# 113. Error Handling

Distinguish:

```text
AuthFailure
PermissionFailure
NetworkFailure
SchemaFailure
ConflictFailure
SyncFailure
MigrationFailure
```

UI uses safe messages.

Logs preserve technical codes.

---

# 114. Failure Recovery

Network failure:
- queue/retry.

Permission failure:
- stop retrying repeatedly;
- log/report.

Schema incompatibility:
- preserve local;
- do not overwrite cloud.

Conflict:
- preserve both;
- explicit UX.

---

# 115. Performance

Measure:

- auth bootstrap latency;
- cloud progression fetch;
- sync write latency;
- offline queue flush;
- app startup impact.

Cloud sync must not make Home feel blocked.

---

# 116. Cost Metrics

In DEV/STAGING, optionally track:

- reads per sync;
- writes per sync;
- sync frequency.

Goal:
- catch chatty behavior early.

No permanent KPI threshold is locked yet.

---

# 117. Repository Structure

Suggested additions:

```text
apps/mobile/lib/features/account/
apps/mobile/lib/features/sync/
apps/mobile/lib/core/network/
firebase/firestore/
firebase/rules/
```

Data implementations may live under feature/data.

---

# 118. Suggested Implementation Order

## Step 1
Auth domain/repository.

## Step 2
Anonymous Auth bootstrap.

## Step 3
Local identity migration.

## Step 4
Cloud progression DTO/repository.

## Step 5
Cloud story/settings DTOs.

## Step 6
Merge policies.

## Step 7
Sync metadata + queue in Drift.

## Step 8
SyncCoordinator.

## Step 9
Offline retry/coalescing.

## Step 10
Firestore Security Rules.

## Step 11
Account/save-progress UI.

## Step 12
Google linking.

## Step 13
Apple linking.

## Step 14
Conflict detection UI.

## Step 15
Firebase Emulator integration tests.

## Step 16
Multi-device simulation/tests.

## Step 17
Cost/performance review.

---

# 119. Suggested Commit Sequence

### Commit 1
```text
feat(auth): add firebase anonymous identity foundation
```

### Commit 2
```text
feat(sync): add cloud progression story and settings contracts
```

### Commit 3
```text
feat(sync): implement domain-specific merge policies
```

### Commit 4
```text
feat(sync): add drift sync queue and metadata
```

### Commit 5
```text
feat(sync): implement offline-first sync coordinator
```

### Commit 6
```text
security(firebase): add player-scoped firestore rules
```

### Commit 7
```text
feat(account): add save-progress account status ui
```

### Commit 8
```text
feat(auth): add google and apple linking flows
```

### Commit 9
```text
feat(auth): add non-destructive provider conflict handling
```

### Commit 10
```text
test(sync): add emulator progression migration and security coverage
```

### Commit 11
```text
perf(sync): reduce redundant firebase reads and writes
```

### Commit 12
```text
docs(sync): document identity cloud state and reconciliation
```

---

# 120. Sprint 6 Definition of Done

Sprint 6 is DONE only when:

- [ ] Firebase Anonymous Auth works.
- [ ] Offline launch still works.
- [ ] local-only identity exists before Firebase availability.
- [ ] Firebase UID persists.
- [ ] player cloud profile created safely.
- [ ] Journey progression cloud record exists.
- [ ] Story progress cloud record exists.
- [ ] settings cloud record exists.
- [ ] active Attempt remains local-only.
- [ ] highest-valid progression merge implemented.
- [ ] Tutorial/onboarding monotonic merge implemented.
- [ ] Story union merge implemented.
- [ ] settings latest-valid-revision merge implemented.
- [ ] Drift sync metadata exists.
- [ ] durable sync queue exists.
- [ ] offline changes queue.
- [ ] reconnect flushes queue.
- [ ] sync writes are idempotent.
- [ ] redundant writes are minimized.
- [ ] initial Sprint 5 → Sprint 6 migration implemented.
- [ ] migration is retry-safe.
- [ ] Google link flow implemented or fully integration-ready.
- [ ] Apple link flow implemented or fully integration-ready.
- [ ] provider conflict detected.
- [ ] conflict does not silently merge.
- [ ] local progress preserved during conflict.
- [ ] Firestore rules deny cross-player access.
- [ ] economy state is not client-writable through progression.
- [ ] emulator security tests pass.
- [ ] progression sync tests pass.
- [ ] settings sync tests pass.
- [ ] story sync tests pass.
- [ ] migration tests pass.
- [ ] CS-001 passes.
- [ ] CS-002 passes.
- [ ] CS-003 passes.
- [ ] CS-004 passes.
- [ ] offline Sprint 5 regression still passes.
- [ ] Flutter analyze passes.
- [ ] Flutter tests pass.
- [ ] Firebase usage remains cost-conscious.

---

# 121. Sprint 6 Exit Gate Before Economy

Do not start Sprint 7 until:

1. anonymous identity is stable;
2. cloud progression sync is reliable;
3. offline queue is idempotent;
4. multi-device progression works;
5. provider conflict is non-destructive;
6. Firestore security tests pass;
7. active Attempt remains local-only;
8. progression cannot mutate future authoritative economy;
9. migration from local-only state is safe;
10. cloud sync does not block gameplay;
11. Firebase read/write volume is reviewed;
12. error recovery is tested.

---

# 122. Cursor Execution Prompt — Sprint 6

Use this after Sprint 5 passes its exit gate:

> Implement **Sprint 6 — Firebase Identity, Cloud Progression & Sync v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_6_Firebase_Identity_Cloud_Progression_and_Sync_v1.0.md`
> - latest Data Model
> - latest Backend & Cloud Architecture
> - latest Progression Design
> - latest Screen Inventory/User Flows where account UX is relevant
>
> Build an offline-first Firebase identity and cloud synchronization foundation.
>
> Implement:
>
> - Firebase anonymous-first authentication;
> - local identity fallback;
> - player cloud profile;
> - cloud Journey progression;
> - cloud Story progress;
> - cloud Settings;
> - domain-specific merge policies;
> - Drift sync metadata;
> - durable idempotent sync queue;
> - reconnect/resume sync triggers;
> - local-only → cloud migration;
> - sync status;
> - account/save-progress UI;
> - Google provider linking;
> - Apple provider linking;
> - explicit non-destructive provider conflict handling;
> - player-scoped Firestore Security Rules;
> - Firebase Emulator integration tests;
> - multi-device sync scenarios.
>
> Critical constraints:
>
> - gameplay must remain usable offline;
> - do not block startup on Firebase;
> - anonymous-first identity is the default;
> - active Attempt remains local/device-specific;
> - no per-Move cloud writes;
> - progression merge uses highest valid progression;
> - Tutorial/onboarding completion is monotonic;
> - Story progress merges valid unlocked/viewed IDs;
> - Settings use latest valid revision;
> - provider already linked to another player must never silently merge;
> - preserve both sides on conflict;
> - do not add client-authoritative Wallet/Coin/Hint state;
> - do not implement IAP, ads, Daily grants, or economy in this sprint;
> - Firestore rules must deny cross-user access;
> - no production wildcard-open Firebase rules;
> - do not persist provider access/ID tokens manually;
> - minimize reads/writes and avoid always-on listeners unless justified.
>
> Use Firebase Emulator Suite for security/sync tests where practical.
>
> At completion report:
>
> 1. files created/changed;
> 2. auth architecture;
> 3. Firestore data model;
> 4. sync queue/reconciliation algorithm;
> 5. merge rules;
> 6. local-to-cloud migration;
> 7. Google/Apple linking behavior;
> 8. account conflict behavior;
> 9. Firestore security rules;
> 10. emulator/integration tests;
> 11. offline test result;
> 12. Firebase reads/writes observed per common sync flow;
> 13. analyze/test/build results;
> 14. unresolved account/product decisions;
> 15. any deviations from this Sprint document and why.

---

# 123. Next Sprint

After Sprint 6 passes the exit gate:

# **Sprint 7 — Economy, Wallet & Server-Authoritative Rewards v1**

Expected focus:

- Wallet ledger;
- starting balance;
- Hint inventory;
- level reward grants;
- Chapter reward grants;
- Hint purchase;
- Extra Moves Coin purchase;
- Dead-End Rescue Coin purchase;
- offline spending queue;
- trusted Cloud Functions/Cloud Run operations;
- idempotent reward grants;
- anti-duplication;
- reconciliation;
- server-authoritative balances;
- economy transaction history foundation.

---

**End of Sprint 6 — Firebase Identity, Cloud Progression & Sync v1**
