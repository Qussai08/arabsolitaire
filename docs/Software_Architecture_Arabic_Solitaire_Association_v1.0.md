# Software Architecture
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1) — Firebase-First  
**Source Documents:** Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 + Screen Inventory & User Flows v1.0 + Content Design System v1.0 + Arabic Content Guidelines v1.0 + Level Design Framework v1.0 + Difficulty Model v1.0 + Solver Specification v1.0 + Game Engine Technical Design v1.0 + Data Model v1.0 + Final Decision Register v1.1  
**Important:** Register-approved product and architecture decisions are **APPROVED/CONFIRMED**. Azure Modular Monolith / PostgreSQL / Container Apps / Blob / Front Door / ACR / Key Vault / App Insights / Bicep and related Azure MVP topology are **SUPERSEDED for MVP** (Register §13A). Exact Solver composition/timeouts/native/fallback, Firebase quotas/billing/resource limits, DR RPO/RTO, and staffing remain **STILL TBD** (Register §14).

---

# 1. Purpose

This document defines the Software Architecture for the Arabic Solitaire Association game.

It covers:

- Client application architecture.
- Domain architecture.
- Game Engine integration.
- Solver integration.
- Backend/service boundaries.
- Data access.
- Cloud Save.
- Content delivery.
- Economy and monetization integration.
- CMS/Admin boundaries.
- Analytics.
- Notifications.
- Remote Config.
- Testing architecture.
- Security boundaries.
- Offline behavior.
- Versioning.
- Scalability.
- Maintainability.

Cloud provider and MVP topology are **APPROVED** as Firebase-first (see **Backend & Cloud Architecture**). Exact quotas, billing budgets, Functions/Cloud Run resource limits, and DR RPO/RTO remain operational **TBD**.

---

# 2. Architecture Goals

The architecture should optimize for:

1. Correctness of game rules.
2. Solver/Game Engine consistency.
3. Testability.
4. Fast mobile UX.
5. Offline-capable core gameplay.
6. Arabic-first RTL support.
7. Easy content expansion.
8. Safe economy and purchase handling.
9. Separation of gameplay from monetization.
10. Scalable content/admin operations.
11. Versioned rules/content.
12. Long-term maintainability.
13. Reuse between Main Journey, Daily Challenge, Events, and Packs.
14. Avoiding over-engineering before product validation.

---

# 3. Architectural Style

**APPROVED / CONFIRMED** direction (Final Decision Register v1.1)

Use a combination of:

- **Clean Architecture** on the Flutter client
- **Domain-Driven Design concepts**
- **Modular Monolith on the client** (feature modules + shared Game Engine/Solver packages)
- **Firebase-first serverless backend** with logical module boundaries (Cloud Functions / Cloud Run) — **not** an always-on ASP.NET Modular Monolith for MVP
- **Repository Pattern**
- **Dependency Injection** (Riverpod)
- **Event-driven domain notifications** (in-process)
- **CQRS selectively where it creates value** (Admin/CMS, wallet, analytics)
- **Immutable/pure state transitions for gameplay**

Avoid microservices, Kubernetes, Redis, and message brokers by default during MVP (**DEFERRED** unless justified).

**SUPERSEDED for MVP:** ASP.NET Core Modular Monolith + PostgreSQL as mandatory backend shape (Register §13A).

---

# 4. High-Level Architecture

```text
+-------------------------------------------------------------+
|                       Mobile Client                          |
|                                                             |
|  Presentation / UI                                          |
|  Application Layer                                          |
|  Game Domain / Engine                                       |
|  Solver Core                                                |
|  Local Persistence                                          |
|  Remote Data / API                                          |
|  Analytics / Ads / IAP Adapters                             |
+----------------------------+--------------------------------+
                             |
                             v
+-------------------------------------------------------------+
|         Firebase / GCP Serverless Backend                    |
|                                                             |
|  Firebase Auth (anonymous-first + Apple/Google link)        |
|  Cloud Functions / Cloud Run (wallet, IAP, Daily, Admin)    |
|  Progression / Cloud Save (Firestore; domain merge policy)   |
|  Content Delivery (Storage bundles)                         |
|  Remote Config / FCM / Analytics / Crashlytics              |
|  Admin/CMS privileged API (Angular + Entra ID)              |
+----------------------------+--------------------------------+
                             |
                             v
+-------------------------------------------------------------+
|                     Data / Platform                          |
|                                                             |
|  Cloud Firestore                                            |
|  Firebase Storage                                           |
|  Firebase Analytics (+ BigQuery export)                     |
|  Crashlytics / FCM / Remote Config                          |
|  AdMob + Store IAP providers                                |
|  (No Redis / broker / always-on RDBMS by default)           |
+-------------------------------------------------------------+
```

---

# 5. Client Application Layers

**APPROVED** direction

Client layers:

1. Presentation
2. Application
3. Domain
4. Infrastructure

---

# 6. Presentation Layer

Responsibilities:

- Screens.
- Widgets/views.
- RTL layout.
- Drag & Drop rendering.
- Animations.
- Dialogs/overlays.
- Input mapping.
- Accessibility.
- Audio/haptics.
- Navigation.

Presentation must not own gameplay rules.

---

# 7. Application Layer

Responsibilities:

- User use-cases.
- Flow orchestration.
- Calling Game Engine.
- Calling Solver.
- Calling repositories.
- Coordinating cloud/local persistence.
- Coordinating Ads/IAP.
- Feature flags.
- Navigation decisions.

Examples:

- StartLevel
- RestartLevel
- RequestHint
- PurchaseExtraMoves
- ClaimDailyReward
- LinkAccount
- SyncProgress

---

# 8. Domain Layer

Contains pure business/game rules.

Major domains:

- Gameplay.
- Level.
- Content.
- Progression.
- Economy abstractions.
- Identity abstractions.

Gameplay Domain should have minimal framework dependencies.

---

# 9. Infrastructure Layer

Responsibilities:

- HTTP.
- Database/local storage.
- File/cache access.
- Ads SDK.
- IAP SDK.
- Push SDK.
- Analytics SDK.
- Authentication provider integrations.
- Remote Config provider.

Infrastructure implements Domain/Application interfaces.

---

# 10. Client Technology Stack

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §5)

Approved client stack:

- **Flutter** (portrait only; min iOS 15; min Android 8 / API 26; responsive tablet from same app)
- **Dart**
- **Riverpod** (application/UI state; Engine independent of Riverpod)
- **Drift / SQLite** (local database; Active Attempt local-first)
- **GoRouter** (navigation — engineering choice consistent with Flutter)
- **Dio** or Firebase SDK clients as appropriate for HTTPS/callables
- **Freezed / immutable models** where useful
- Flutter `in_app_purchase` for IAP
- **Firebase** adapters for Analytics, Crashlytics, FCM, Remote Config, Auth

**CONFIRMED:** Game Engine is framework-independent from UI/state management. Solver implementation is **Pure Dart**. Solver execution is **Hybrid**.

---

# 11. Alternative Client Options (Not Selected for MVP)

Unity, Native Swift+Kotlin, and React Native were considered historically and are **not** the MVP baseline. Flutter is **APPROVED**.

---

# 12. Recommended Flutter Module Structure

**APPROVED** direction (exact folder names may evolve)

```text
lib/
  app/
    bootstrap/
    navigation/
    config/

  core/
    error/
    result/
    logging/
    analytics/
    network/
    storage/
    localization/
    feature_flags/

  features/
    onboarding/
    home/
    journey/
    gameplay/
    shop/
    account/
    settings/
    daily_reward/
    daily_challenge/

  game/
    domain/
    engine/
    solver/
    level_generator/
    difficulty/
    replay/
    serialization/

  content/
    domain/
    repository/
    cache/

  economy/
    domain/
    wallet/
    rewards/

  integrations/
    ads/
    iap/
    auth/
    push/
    remote_config/
```

Exact naming may evolve without changing approved stack.

---

# 13. Feature-First vs Layer-First Structure

**APPROVED** direction:

**Feature-first at product level**, with internal Clean Architecture layers.

Example:

```text
features/gameplay/
  presentation/
  application/
  domain/
  infrastructure/
```

Shared Game Engine/Solver remain in dedicated framework-independent modules.

---

# 14. Game Engine Package

**APPROVED / CONFIRMED** (Engine independent of UI)

Create an isolated package:

```text
packages/game_engine/
```

It should contain:

- GameState.
- GameAction.
- Rules.
- Move validation.
- Move execution.
- Stack logic.
- Stock logic.
- Association logic.
- Move counter.
- Streak.
- Undo.
- Win evaluation.
- Serialization contracts.

It must not depend on Flutter UI or Riverpod.

---

# 15. Solver Package

**APPROVED / CONFIRMED** (Pure Dart; hybrid execution)

Create:

```text
packages/game_solver/
```

Depends on:

- game_engine domain/rules

Contains:

- Search state.
- Canonicalization.
- Search algorithm.
- Transposition table.
- Heuristics.
- Hint selection.
- Dead-End analysis.
- Difficulty metrics.

It should be testable in CLI/CI without launching the app.

---

# 16. Level Generator Package

**APPROVED** direction (on-device Main Journey generation)

```text
packages/level_generator/
```

Responsibilities:

- Select content.
- Build Card Pool.
- Shuffle.
- Deal Tableau/Stock.
- Call Solver.
- Validate Move Limit.
- Validate Difficulty.
- Retry/reject.
- Produce validated Attempt.

---

# 17. Difficulty Package

Optional separated module:

```text
packages/difficulty_model/
```

Responsibilities:

- Calculate Board Difficulty.
- Consume Solver metrics.
- Combine semantic metadata.
- Validate Level target bands.
- Version calculations.

Could initially live inside Level Generator to avoid over-modularization.

---

# 18. Shared Domain Package

Optional:

Possible shared package:

```text
packages/game_domain/
```

Only if needed.

Avoid too many packages early.

MVP may keep:

- Game Engine.
- Solver.
- App.

as the main separations.

---

# 19. State Management

**APPROVED / CONFIRMED**

Use **Riverpod** for application/UI state.

Game Engine itself maintains domain state independently of Riverpod.

Pattern:

```text
UI
  -> GameplayController
      -> GameEngine.dispatch(action)
      -> GameTransition
      -> update provider state
      -> render
```

Riverpod should not contain core move rules.

---

# 20. Gameplay Controller

Responsibilities:

- Bridge UI and Game Engine.
- Map drag/drop to GameAction.
- Update UI state.
- Launch animations from events.
- Request Dead-End checks.
- Coordinate Hint.
- Persist snapshots.
- Handle pause/resume.

---

# 21. Navigation Architecture

**APPROVED** direction

Use declarative navigation with Flutter **GoRouter**.

Routes:

- onboarding
- home
- journey
- gameplay
- shop
- account
- settings
- daily

Gameplay overlays should prefer local modal/overlay state rather than route changes.

---

# 22. Dependency Injection

**APPROVED**

Use dependency injection through **Riverpod** providers (dedicated DI container only if later needed).

Repositories/services should depend on interfaces.

Example:

```text
ProgressRepository
WalletRepository
ContentRepository
PurchaseRepository
AnalyticsService
```

---

# 23. Repository Pattern

Recommended repositories:

- PlayerRepository
- JourneyRepository
- LevelRepository
- ContentRepository
- WalletRepository
- HintRepository
- PurchaseRepository
- EntitlementRepository
- DailyRepository
- SettingsRepository

Repositories abstract:

- local cache
- cloud API
- synchronization strategy

---

# 24. Use-Case Layer

Application use-cases may include:

- InitializeApp
- ContinueJourney
- StartLevel
- GenerateAttempt
- RestartLevel
- SubmitGameAction
- RequestHint
- UndoMove
- ContinueAfterExtraMoves
- ApplyDeadEndRescue
- CompleteLevel
- SyncPlayerState
- PurchaseProduct

Use explicit use-cases for workflows with side effects.

---

# 25. CQRS Usage

**PROPOSED**

Use CQRS selectively.

Good candidates:

- Admin/CMS content publishing.
- Wallet transactions.
- Analytics read models.
- Level simulation reports.

Avoid implementing CQRS for every simple mobile screen.

---

# 26. Domain Events

Gameplay Domain Events:

- MoveAccepted
- MoveRejected
- CardRevealed
- AssociationActivated
- AssociationCompleted
- StreakRewardEarned
- LevelWon
- MovesExhausted

Application reacts to them.

---

# 27. Integration Events

Backend-side integration events may include:

- PlayerLevelCompleted
- WalletChanged
- PurchaseValidated
- DailyRewardClaimed
- ContentPublished

Whether a real message broker is needed in MVP: **DEFERRED** — no dedicated message broker by default (Register §13).

Do not introduce one solely for architectural purity.

---

# 28. Event-Driven Boundary

Domain events are in-process.

Integration events cross service/application boundaries.

Keep them conceptually separate.

---

# 29. Error Handling

Use explicit typed errors/results.

Suggested categories:

- ValidationError
- NetworkError
- AuthError
- SyncError
- PurchaseError
- SolverError
- ContentError
- PersistenceError
- UnexpectedError

Gameplay invalid move is not an exceptional error.

---

# 30. Result Pattern

**PROPOSED**

Use a typed result:

```text
Result<T, Failure>
```

instead of throwing exceptions for expected operational outcomes.

Exceptions remain for truly unexpected failures.

---

# 31. Offline-First Gameplay

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §7)

Core Main Journey is fully playable offline after required content/config is downloaded.

Offline-capable local data:

- Current Level config.
- Content bundle.
- Active Attempt (Drift / SQLite, local-first, device-specific).
- Progress cache.
- Settings.
- Locally reconciled Coin balance + queued idempotent offline spend transactions.

Network-required:

- Store purchase.
- Rewarded Ads.
- cloud sync.
- account linking.
- Daily eligibility that depends on trusted backend time when online.

---

# 32. Local Persistence

**APPROVED / CONFIRMED**

Use **Drift / SQLite** for local persistence.

Supports:

- structured data
- transactions
- versioning
- fast reads
- Active Attempt local-first snapshots

**Isar** is not the MVP baseline.

---

# 33. Local Storage Boundaries

Local stores:

- Player cache.
- Journey progress.
- Active Attempt snapshot.
- Content bundle/cache.
- Settings.
- Entitlement cache.
- Economy display cache.
- Remote Config cache.

Authoritative purchase/wallet values should reconcile with server where applicable.

---

# 34. Active Attempt Persistence

**APPROVED / CONFIRMED**

Persist active Attempt **locally** (Drift) after every committed Move or through short debounce.

Game Engine snapshot is serialized.

Cloud conflict policy: Active Attempt is **local/device-specific** (Register §7).

Benefits:

- crash recovery
- OS termination recovery
- seamless resume
- no per-Move Firestore traffic

---

# 35. Local Encryption

If sensitive tokens are stored:

Use platform secure storage for:

- auth tokens
- refresh tokens
- encryption keys where required

Do not store them in plain database records.

---

# 36. Networking Layer

**APPROVED** direction

Prefer Firebase SDKs (Auth, Firestore, Storage, Functions callables, Remote Config, FCM) plus HTTPS client (e.g. Dio) where custom endpoints on Cloud Run are used.

Responsibilities:

- Auth session via Firebase Auth.
- Retry rules for idempotent operations.
- Correlation IDs.
- Timeout handling.
- JSON serialization.
- API error mapping.

Avoid automatic retries for non-idempotent purchases/wallet operations unless idempotency keys are used.

Minimize Firestore reads/writes; never sync per Move.

---

# 37. API Design Style

**APPROVED** direction

Player/mobile integration is primarily:

- Firebase Auth
- Firestore document sync (domain-specific)
- Cloud Functions / Cloud Run HTTPS or callables for sensitive mutations
- Firebase Storage for content bundles

REST/JSON OpenAPI remains useful for Admin/CMS privileged surfaces and any Cloud Run HTTP APIs.

GraphQL is not required.

---

# 38. Backend Architecture Style

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §6)

MVP backend is **Firebase-first / serverless-first**, not an always-on Modular Monolith.

Logical modules (implemented as Cloud Functions / Cloud Run + Firestore):

1. Identity
2. Player
3. Progression
4. Economy
5. Monetization
6. Content
7. Daily
8. Notification
9. Admin
10. Configuration

Reasons:

- cost-conscious (avoid always-on infra)
- managed scaling and quotas
- faster MVP delivery for mobile games
- clear future extraction / ASP.NET+PG reconsideration only if justified (**DEFERRED**)

**SUPERSEDED for MVP:** ASP.NET Core Modular Monolith as mandatory backend shape (Register §13A).

---

# 39. Backend Technology Stack

**APPROVED / CONFIRMED**

- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
- **Cloud Functions and/or Cloud Run** for sensitive/server-authoritative logic
- **Firebase Analytics** (+ BigQuery export), **Crashlytics**, **FCM**, **Remote Config**
- **GitHub Actions**; environments **DEV / TEST / STAGING / PROD**

**SUPERSEDED for MVP** (Register §13A): ASP.NET Core, PostgreSQL, Azure Container Apps, Azure Blob, Front Door, ACR, Key Vault, App Insights, Bicep, Azure-specific SKUs.

**DEFERRED:** Redis, dedicated message broker, Kubernetes, always-on relational DB, ASP.NET Core + PostgreSQL unless justified.

Exact Firebase/GCP quotas, billing, Functions/Cloud Run resource limits: **STILL TBD**.

---

# 40. Alternative Backend Options (Not MVP Baseline)

AWS and Azure are **not** co-equal MVP options. Azure is **out of the MVP baseline**.

ASP.NET Core + PostgreSQL may be reconsidered **later** only if Firebase-first proves insufficient (scale, CMS complexity, relational queries, reporting, ops).

---

# 41. Backend Module Boundaries

Suggested modules:

```text
Identity
Players
Progression
Levels
Content
Economy
Purchases
Daily
Notifications
Admin
Configuration
AnalyticsIntegration
```

Each module owns:

- use cases
- domain rules
- repository interfaces
- API contracts

---

# 42. Backend Data Access

**APPROVED** direction

- Firestore for suitable document-oriented player/progression/Daily/sync/config data.
- Trusted Cloud Functions / Cloud Run for Wallet ledger mutations and other non-client-trusted writes.
- Firebase Storage for content bundles/assets.

Do not introduce EF Core / PostgreSQL for MVP.

---

# 43. Database

**APPROVED / CONFIRMED**

**Cloud Firestore** is the MVP primary cloud data store for suitable document-oriented state.

**SUPERSEDED for MVP:** PostgreSQL as mandatory primary database.

**DEFERRED:** always-on relational database unless justified later.

Details: Backend & Cloud Architecture.

---

# 44. Cache

**DEFERRED** by default

Redis / dedicated cache is **not** in MVP by default (Register §13).

Add only when measured load/use case justifies it.

---

# 45. Object Storage

**APPROVED / CONFIRMED**

**Firebase Storage** for:

- illustration assets
- content bundles
- admin uploads (via privileged publish pipeline)

No separate paid CDN layer required for MVP unless measurements demonstrate a need. Azure Blob / Front Door are **SUPERSEDED**.

---

# 46. Content Delivery Architecture

**APPROVED / CONFIRMED**

Use hybrid versioned bundles (bundled base + remote Firebase Storage bundles).

Flow:

```text
CMS
 -> Publish content version
 -> Build Content Bundle
 -> Store in Firebase Storage
 -> Client checks manifest
 -> Client downloads compatible version
 -> validate hash / schema / rules compatibility
 -> atomic activation
 -> keep last-known-valid for rollback
```

Benefits:

- fewer API calls
- offline gameplay
- safe rollback
- predictable client state

---

# 47. Content Bundle Manifest

Potential fields:

- bundle_version
- minimum_app_version
- rules_version
- created_at
- content_hash
- asset_manifest
- level_config_versions

---

# 48. Content Compatibility

Client should reject/ignore bundles requiring unsupported:

- rules version
- content schema version
- app version

Never apply incompatible content silently.

---

# 49. Cloud Save Architecture

**APPROVED / CONFIRMED**

Use local-first writes with background cloud sync to Firestore (minimize reads/writes; no per-Move traffic).

Flow:

```text
Gameplay
 -> save locally (Drift)
 -> enqueue sync milestones
 -> trusted Functions / Firestore rules validate
 -> domain-specific merge
 -> local sync status updated
```

Economy/purchase records require stronger server authority than ordinary progression.

---

# 50. Sync Boundaries

Separate sync categories:

- progression
- settings
- active session
- wallet
- entitlements
- daily state

Do not merge them through one generic "latest JSON wins" blob if integrity matters.

---

# 51. Cloud Save Conflict Strategy

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §7)

Domain-specific policy:

| Domain | Policy |
|---|---|
| Progression | Merge to highest valid progression |
| Wallet | Server-authoritative transaction/ledger via trusted backend functions |
| Purchases / Entitlements | Store + trusted backend authority |
| Settings | Latest valid revision |
| Active Attempt | Local / device-specific |

Do not use one generic “latest JSON wins” merge across domains.

---

# 52. Identity Architecture

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §7)

- Anonymous-first via **Firebase Authentication**
- Anonymous Firebase user created first
- Optional Apple/Google provider linking
- Linking preserves the same logical player identity when valid
- Explicit conflict flow if provider already linked elsewhere; **no silent automatic merge**

Architecture:

```text
Anonymous Firebase UID
 -> Cloud Player Profile (Firestore)
 -> Link Provider
 -> Same Player Identity
```

Avoid mandatory login gates.

---

# 53. Authentication Provider Integration

**APPROVED / CONFIRMED**

Use **Firebase Authentication**:

- Anonymous user created first.
- Optional Apple/Google provider linking.
- Linking preserves the same logical player identity when valid.
- Explicit conflict flow if provider already linked elsewhere; no silent automatic merge.

Do not make Apple/Google tokens the internal Player ID.

---

# 54. Session Token Strategy

**APPROVED**

Use Firebase Auth session management (ID tokens / refresh handled by Firebase Auth SDK).

Store sensitive tokens in platform secure storage where the SDK requires persistence.

Exact token caching details are engineering implementation, not an open platform choice.

---

# 55. Economy Architecture

**APPROVED**

Wallet and paid grants are transactional through trusted Cloud Functions / Cloud Run.

```text
Gameplay Reward / IAP / Ad grant
 -> Economy Application Service (serverless)
 -> Wallet Ledger
 -> Balance Projection
 -> Client cache refresh
```

Game Engine does not directly persist Wallet. Offline Coin spend queues idempotent transactions for later reconciliation.

---

# 56. Wallet Ledger

**APPROVED / CONFIRMED**

Append-only (or equivalently auditable) transactions with idempotency, executed through trusted Cloud Functions / Cloud Run.

Benefits:

- auditability
- duplicate protection
- debugging
- charge/refund handling

Wallet current balance can be stored as projection/cache; client display may use locally reconciled balance pending sync.

---

# 57. Hint Balance Architecture

Hints may use:

- separate ledger
or
- simple transactional balance

Because Hint is less financially sensitive than Coins, MVP may use simpler balance with idempotent grants/spends.

---

# 58. Purchase Architecture

Flow:

```text
Client Store SDK
 -> platform purchase
 -> backend validation
 -> PurchaseTransaction
 -> entitlement/coin grant
 -> client refresh
```

Do not trust client-only purchase success for permanent entitlements.

---

# 59. Remove Ads Entitlement

Stored as durable Player Entitlement.

Client caches it locally.

On app start:

- use cache immediately
- reconcile with backend/store where needed

---

# 60. Rewarded Ads Architecture

**APPROVED** ads stack: Google AdMob + Mediation.

Flow:

```text
Gameplay Offer
 -> Ad Adapter
 -> Ad Completion
 -> Reward Grant (idempotent where Coins)
 -> Wallet/Hint/ExtraMoves
```

Purchases and Rewarded Ads require network. Exact server-side ad verification mix remains operational TBD; final mediation network mix **STILL TBD**.

---

# 61. Ads Adapter

Presentation/Application depends on interface:

```text
RewardedAdsService
InterstitialAdsService
```

SDK-specific implementation remains Infrastructure.

This allows provider replacement.

---

# 62. IAP Adapter

Interface:

- loadProducts
- purchase
- restore
- observePendingTransactions

Platform-specific StoreKit/Play Billing remains Infrastructure.

---

# 63. Solver Architecture

Solver should be a framework-independent library.

Recommended dependencies:

```text
Game Rules
Game State
Search Infrastructure
Difficulty Metrics
```

It should not depend on:

- UI
- ads
- network
- localization

---

# 64. Solver Placement

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §5)

Hybrid execution:

- on-device Main Journey generation
- on-device Hint/Dead-End where practical
- same Pure Dart Solver core reusable in CMS/CI/backend simulation (Cloud Functions / Cloud Run)
- backend fallback available if needed

Exact algorithm composition, timeouts, native optimization necessity, and exact backend fallback rules remain **STILL TBD** (Register §14).

---

# 65. Game Engine / Solver Contract

The Engine exposes canonical state.

Solver returns:

- solvability
- reference path
- Hint move
- dead-end result
- metrics

Solver never mutates Engine state directly.

---

# 66. Async Solver Execution

Solver calls:

- generation
- Hint
- Dead-End

must not block the UI thread.

Use:

- isolates/workers
- background task execution
- async compute strategy

Exact implementation depends on client stack.

---

# 67. Flutter Solver Execution

**APPROVED** direction

Start **Pure Dart**; use Dart Isolates for CPU-heavy work.

Do not choose FFI/native prematurely.

Whether native optimization is ever necessary remains intentional **TBD**.

---

# 68. Game State State-Management Boundary

Recommended:

- Engine state immutable.
- Controller owns current snapshot.
- Riverpod exposes state.
- UI renders snapshot.

No UI widget should directly alter Card collections.

---

# 69. Analytics Architecture

**APPROVED / CONFIRMED**

Use adapter interface:

```text
AnalyticsService.track(event)
```

Domain emits structured events; Application maps them.

**Approved provider:** Firebase Analytics (BigQuery export enabled; raw retention baseline 14 months then cost review).

Exact analytics cost thresholds for retention-policy review: **STILL TBD**.

---

# 70. Crash Reporting

**APPROVED / CONFIRMED**

Use adapter:

```text
CrashReporter
```

**Approved provider:** Firebase Crashlytics.

Capture:

- app version
- engine version
- solver version
- attempt ID
- non-sensitive state hash

Avoid dumping excessive player data.

Backend/serverless observability uses Firebase / GCP native logs and monitoring — **no** Azure App Insights stack.

---

# 71. Remote Config

**APPROVED / CONFIRMED**

**Client-facing:** Firebase Remote Config.

Authoritative sensitive configuration remains server-controlled where required.

Config categories:

- economy
- ads
- daily systems
- feature flags
- level activation
- content manifest

Core gameplay rule changes require versioning, not casual Remote Config.

---

# 72. Feature Flags

Safe uses:

- Daily Reward on/off
- Daily Challenge on/off
- notifications
- illustration content
- ad placements
- experimental screens

Unsafe without Rules version:

- changing Stack behavior
- changing move cost
- changing completion semantics

---

# 73. Notification Architecture

**APPROVED / CONFIRMED**

Client:

- permission
- token registration
- deep-link handling

Backend:

- eligibility calculation
- scheduling/trigger
- payload generation

Provider: **Firebase Cloud Messaging** (APNs remains underlying iOS channel).

Initially active types: Daily Challenge; Streak Risk. Quiet hours 22:00–09:00 player-local.

---

# 74. Deep Link Architecture

Potential destinations:

- Home
- Daily Challenge
- Daily Reward
- Event later

Use typed route/deep-link parser.

Invalid/expired target falls back to Home.

---

# 75. CMS Architecture

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §10)

Admin web app separate from mobile app.

- **Angular** CMS frontend
- **Microsoft Entra ID** admin authentication
- **MFA** for privileged access
- Production publish permission separated from ordinary content editing
- Access Firebase/GCP only through approved security boundaries; no unrestricted client-side production mutation

CMS responsibilities:

- Content CRUD.
- Reviews.
- Level Config.
- Solver validation.
- Publish / rollback.
- Activate/deactivate.
- Economy/configuration.
- Audit (2-year retention).
- Essential player support.

---

# 76. CMS Technology

**APPROVED**

- Angular admin frontend
- Privileged Cloud Functions / Cloud Run Admin API
- Firestore + Storage (not ASP.NET + PostgreSQL for MVP)

**SUPERSEDED:** ASP.NET Core + PostgreSQL CMS backend as MVP baseline.

---

# 77. CMS Solver Integration

Admin can request:

- validate Level
- generate sample Attempt
- show reference solution
- show difficulty metrics

This should call shared Solver logic/service rather than reimplementing rules in browser UI.

---

# 78. Admin Authorization

Use RBAC.

Possible roles:

- Author
- Arabic Reviewer
- Semantic Reviewer
- Game Designer
- Publisher
- Admin

Least privilege.

---

# 79. Audit Architecture

Admin changes emit audit records.

Audit-sensitive areas:

- content
- level config
- economy config
- entitlements
- manual wallet corrections

---

# 80. Logging Architecture

Use structured logs.

Fields:

- correlation_id
- player_id when appropriate
- level_id
- attempt_id
- app_version
- engine_version
- solver_version

Avoid logging Arabic content unnecessarily if stable IDs are sufficient.

---

# 81. Correlation IDs

**PROPOSED**

Use correlation IDs for:

- client API request
- backend workflow
- purchase validation
- content publish
- cloud sync

Useful for production debugging.

---

# 82. Testing Architecture

Testing layers:

1. Unit tests
2. Domain tests
3. Solver tests
4. Property-based tests
5. Integration tests
6. Repository tests
7. API tests
8. UI/widget tests
9. End-to-end tests
10. Simulation tests

---

# 83. Game Engine Testing

Must be highly automated.

Focus:

- rule invariants
- move legality
- move cost
- Stack atomicity
- Stock behavior
- Undo
- completion
- win
- replay

---

# 84. Solver Testing

Includes:

- golden boards
- known solvable
- known unsolvable
- Move-Limit boundary
- Stock loops
- dead-end branches
- Hint validation
- solution replay

---

# 85. Property-Based Testing

**PROPOSED**

Very suitable for:

- random Game States
- action sequences
- card conservation
- no duplicate ownership
- Stack homogeneity
- reward idempotency

---

# 86. Integration Testing

Important integrations:

- Engine ↔ Solver
- App ↔ Local DB
- App ↔ Backend
- Backend ↔ DB
- Backend ↔ Store validation
- Backend ↔ Push provider
- CMS ↔ Solver/Content

---

# 87. End-to-End Tests

Critical flows:

- First launch.
- Tutorial.
- Level complete.
- Restart.
- Hint.
- Dead End.
- Out of Moves.
- Extra Moves.
- Purchase Coins.
- Remove Ads.
- Account link.
- Cloud sync.

---

# 88. CI Architecture

**APPROVED / CONFIRMED**

**CI provider:** GitHub Actions.

Environments: **DEV, TEST, STAGING, PROD**.

Pipeline stages:

1. Static analysis.
2. Unit tests.
3. Game Engine tests.
4. Solver tests.
5. Functions/Cloud Run tests.
6. UI tests.
7. Build.
8. Simulation smoke suite.
9. Security/dependency scan.
10. Artifact publish / deploy staging → controlled prod.

---

# 89. Simulation in CI

Run lightweight simulation on every relevant change.

Run larger simulation:

- nightly
- release candidate
- Solver/rule changes

Avoid blocking every commit on huge 10k+ simulations.

---

# 90. Code Quality Rules

Recommended:

- strict linting
- formatting
- null safety
- typed DTO/domain separation
- no domain logic in widgets/controllers
- no SDK calls in domain
- no raw JSON deep in UI

---

# 91. SOLID Application

## Single Responsibility
Game modules have narrow ownership.

## Open/Closed
Future content modes should reuse engine.

## Liskov
Adapters implement stable contracts.

## Interface Segregation
Separate Analytics, Ads, Purchases, Storage interfaces.

## Dependency Inversion
Domain depends on abstractions, not SDKs.

---

# 92. DDD Boundaries

Potential bounded contexts:

- Gameplay
- Content
- Progression
- Economy
- Identity
- Engagement
- Administration

Do not turn every context into a microservice.

---

# 93. Domain Entities vs DTOs

Separate:

- API DTO
- persistence model
- domain entity
- UI model

MVP can simplify mapping where safe, but Game Engine domain should remain isolated from network DTOs.

---

# 94. DTO Versioning

Content and cloud APIs should support versioning.

Avoid breaking older app versions abruptly.

Possible strategies:

- URL version
- contract version field
- backward-compatible additive fields

Exact API versioning TBD.

---

# 95. Serialization

Recommended formats:

- JSON for API/content bundles initially
- compact binary later only if size/performance requires it

Do not optimize prematurely.

---

# 96. Content Bundle Compression

**PROPOSED**

Use standard HTTP compression and asset caching.

Move to binary formats only if actual bundle size becomes problematic.

---

# 97. Security Architecture Principles

1. Do not trust client for paid grants.
2. Validate purchases server-side.
3. Protect tokens in secure storage.
4. Use TLS.
5. Least privilege.
6. Audit admin changes.
7. Idempotency for economy.
8. Rate-limit sensitive APIs.
9. Avoid secrets in app bundle where possible.

---

# 98. API Authorization

Player APIs:

- player session/token

Admin APIs:

- stronger authenticated user + RBAC

Store webhook/server notifications:

- provider verification

---

# 99. Rate Limiting

Potential sensitive APIs:

- purchase validation
- rewarded grant
- daily claims
- account linking
- admin login

Exact policy belongs to Backend/Cloud Architecture.

---

# 100. Anti-Tamper Scope

Client-side gameplay may be modified by advanced users.

MVP focus:

- protect purchases
- protect Wallet
- protect entitlement
- protect server progression where necessary

Do not add heavy anti-tamper until competitive requirements justify it.

---

# 101. Privacy Architecture

Design for minimal data.

Anonymous gameplay should require:

- internal player ID
- technical device/app metadata only as needed

No social graph or contact access.

---

# 102. Performance Architecture

Critical fast paths:

- drag validation
- move execution
- card animation
- active state save
- Solver request dispatch

Heavy tasks:

- Solver search
- content update
- cloud sync

must be isolated from frame rendering.

---

# 103. Memory Performance

Avoid:

- repeated deep cloning of massive unrelated app state
- retaining all Attempt histories in memory
- storing duplicate asset bytes

Game State is relatively small; correctness should win over premature micro-optimization.

---

# 104. Background Work

Candidate background tasks:

- cloud sync
- content update
- analytics upload
- pre-generation
- Solver analysis where appropriate

Respect mobile OS lifecycle.

---

# 105. Pre-Generation

**PROPOSED**

Optionally generate next Attempt while player sees Level Complete/Home.

Benefits:

- instant next-level start

Must not waste excessive battery.

---

# 106. Content Caching

Cache:

- content manifest
- content bundle
- illustrations
- level configs

Use version/hash-based invalidation.

---

# 107. Resilience

Gameplay should survive temporary failure of:

- backend
- analytics
- ads
- remote config

Core play should not stop unnecessarily.

---

# 108. API Failure Strategy

Read operations:

- cached fallback where safe

Write operations:

- local pending queue for progression
- idempotent retry
- no duplicate wallet/purchase operation

---

# 109. Purchase Failure Strategy

Never fake success.

Pending purchases remain pending until validated.

UI must reconcile after restart.

---

# 110. Analytics Failure Strategy

Do not block gameplay.

Buffer/drop according to SDK limits.

---

# 111. Content Failure Strategy

If remote update fails:

- continue with last valid compatible bundle

Never switch to partial content state.

---

# 112. Remote Config Failure Strategy

Use:

- last-known valid config
- bundled defaults

Core rules remain compiled/versioned.

---

# 113. Cloud Save Failure Strategy

Gameplay continues locally.

Sync retried later.

Wallet/purchase state requires stronger reconciliation rules.

---

# 114. Version Compatibility

Track:

- app_version
- content_schema_version
- content_bundle_version
- rules_version
- engine_version
- solver_version
- difficulty_model_version

These should appear in diagnostics.

---

# 115. Release Compatibility

Backend/content service should know minimum supported app version for new content/config.

Do not publish incompatible rules to old clients.

---

# 116. Feature Evolution

Future systems:

- Achievements
- Collections
- Events
- Packs
- Leaderboards
- Cosmetics

should integrate as new modules without modifying core Game Engine rules unless they truly add gameplay mechanics.

---

# 117. No Separate Engines

Do not create separate engines for:

- Main Journey
- Daily Challenge
- Events
- Packs

Use the same Game Engine with different Level/Content configurations.

---

# 118. Tutorial Architecture

Use a Tutorial Controller/Script layer wrapping the Game Engine.

It may:

- constrain valid UI actions
- show instructions
- force setup

but should reuse core rules.

---

# 119. Daily Challenge Architecture

Uses:

- same Game Engine
- deterministic Attempt
- separate progression/reward module

Potential leaderboard later.

---

# 120. Event Architecture

Events should primarily add:

- content
- progression
- rewards

not fork the core Engine.

---

# 121. Pack Architecture

Packs are content/progression modules.

Special dialect rules belong to content, not Game Engine.

---

# 122. Observability

Key operational metrics:

- API latency
- purchase failures
- sync failures
- content update failures
- Solver generation failures
- game crash rate
- level generation latency

---

# 123. Solver Observability

Track:

- duration
- states explored
- acceptance rate
- timeout
- retries
- hint latency
- dead-end latency

---

# 124. Content Observability

Track:

- bundle version adoption
- publish success
- content disable events
- content complaint/error rate

---

# 125. Architecture Decision Records

**APPROVED** practice

Use ADRs for major choices. Platform choices already closed by Final Decision Register v1.1 include:

- Flutter + Riverpod + Drift
- Pure Dart Solver / hybrid execution
- Firebase-first backend (Firestore, Storage, Functions/Cloud Run, Auth, Analytics, Crashlytics, FCM, Remote Config)
- GitHub Actions + 4 environments
- Angular CMS + Entra ID
- Domain-specific Cloud Save conflict policy

ADRs remain useful for engineering details (folder layout, callable shapes, Firestore document layout). Azure Modular Monolith proposals are **SUPERSEDED** and should not be re-opened without architecture review.

---

# 126. Suggested ADR Template

```text
Title
Status
Context
Decision
Alternatives
Consequences
Risks
Date
Owner
```

---

# 127. Proposed Client Package Dependency Direction

```text
presentation
   ↓
application
   ↓
domain
   ↑
infrastructure implements domain/application ports
```

Game Engine:

```text
UI/App
  ↓
Game Engine
  ↓
Pure Domain Types
```

Solver:

```text
Solver
  ↓
Game Engine Rules/State contracts
```

No reverse dependency from Game Engine to UI.

---

# 128. Backend Dependency Direction

```text
HTTPS / Callable / Admin API
 ↓
Application (Cloud Functions / Cloud Run modules)
 ↓
Domain rules (wallet, daily, publish, etc.)
 ↑
Infrastructure (Firestore, Storage, Secret Manager, store APIs)
```

Modules communicate through contracts/events.

Avoid unrestricted client-side production mutation of Firestore.

---

# 129. Module Ownership

Suggested ownership:

## Gameplay
- client Engine/Solver/Generator

## Content
- backend + CMS + client cache

## Progression
- client + backend

## Economy
- backend authoritative for Wallet/paid grants

## Identity
- backend

## Daily
- backend + client UI

---

# 130. Extraction Strategy

If future scale requires extraction beyond serverless modules:

Potential first candidates:

- Content delivery
- Notifications
- Analytics pipeline
- Purchase validation

Do not pre-split before need. Kubernetes / Redis / broker / ASP.NET+PG remain **DEFERRED** until justified.

---

# 131. Transaction Boundaries

Trusted serverless transactions for:

- Wallet spend/grant
- purchase grant
- Daily Reward claim
- Level completion reward
- entitlement update

Content publication can use separate transactional workflow.

(No always-on relational DB transaction model required for MVP.)

---

# 132. Background Jobs

Potential jobs (Cloud Scheduler / Cloud Tasks / scheduled Functions — not DB-backed Azure jobs):

- push notifications
- content bundle build
- stale content review
- purchase reconciliation
- analytics export
- Daily Challenge generation

Exact worker sizing remains **TBD** (quotas/billing). Azure DB-backed background jobs as default model are **SUPERSEDED**.

---

# 133. Daily Challenge Generation

**APPROVED** direction

Backend/operational pipeline (Cloud Functions / Cloud Run):

1. Choose config/content.
2. Generate deterministic board.
3. Solver validate (shared Pure Dart core).
4. Store Challenge definition (Firestore / Storage as appropriate).
5. Publish.
6. Client downloads.

Backend is authoritative for Daily time/eligibility (00:00 player-local timezone).

---

# 134. Main Journey Generation Location

**APPROVED / CONFIRMED**

On-device Main Journey generation using validated Level Config + Content + Pure Dart Solver.

Optional backend fallback if needed; exact fallback rules **STILL TBD**.

Reasons:

- offline
- low backend load / cost
- fast restart

---

# 135. Alternative: Server-Generated Attempts

Not preferred for MVP. Available only as hybrid fallback when justified; exact rules **TBD**.

Cons of primary server generation: network dependency, backend CPU, latency, weaker offline.

---

# 136. Architecture for Attempt Generation

Recommended abstraction:

```text
AttemptGenerator
```

Implementations may be:

- LocalAttemptGenerator
- RemoteAttemptGenerator
- CachedAttemptGenerator

Application selects strategy.

This keeps future options open without changing gameplay.

---

# 137. State Synchronization Contract

Game Engine state should not be synced card-by-card to backend during every move.

Recommended:

- local active Attempt
- sync milestone/progression
- optionally sync compressed snapshot periodically

Avoid high-frequency backend dependence.

---

# 138. Repositories and Sync

Example:

```text
JourneyRepository
  - local source
  - remote source
  - sync policy

ContentRepository
  - bundled source
  - local cache
  - remote source
```

---

# 139. Data Source Pattern

**PROPOSED**

Repositories may compose:

- LocalDataSource
- RemoteDataSource
- CachePolicy

Do not expose raw HTTP/DB logic to use-cases.

---

# 140. UI Rendering Model

Presentation should consume view models such as:

- GameplayViewState
- HomeViewState
- ShopViewState
- AccountViewState

Game Engine domain entities should not be rendered directly if UI-specific transformation is needed.

---

# 141. Gameplay ViewState

Potential:

- columns
- visible Stock cards
- Slots
- move counter
- streak
- undo enabled
- hint state
- attempt status

Generated from Engine snapshot.

---

# 142. Animation State

Animations are ephemeral UI state.

Do not persist them in Game State.

---

# 143. Accessibility Architecture

UI maps domain/card content into:

- semantics labels
- readable descriptions
- focus order

Engine remains accessibility-neutral.

---

# 144. Localization Architecture

UI strings use localization resource files.

Content is delivered through Content Domain.

Do not mix UI translations with puzzle content records.

---

# 145. Arabic-First Architecture

Support:

- RTL by default
- mixed-script handling
- content-driven font sizing
- Arabic normalization only in content/search utilities

Game logic never transforms display text.

---

# 146. Fonts

Font choice belongs to Visual/UI Design.

Software architecture only requires:

- bundled or platform-safe licensed font strategy
- dynamic text scaling
- fallback handling

No font is selected here.

---

# 147. Time and Date Handling

Use trusted backend time for Daily eligibility when online.

Client converts for display.

Daily Challenge reset: **00:00 validated player-local timezone**; backend authoritative.

Avoid device-clock trust alone for reward-sensitive daily claims.

---

# 148. Server Time

**APPROVED**

Daily Reward/Challenge and streak-sensitive operations use trusted backend time when online.

Offline Coin spend uses queued idempotent reconciliation; Daily claims that require eligibility wait for network.

---

# 149. Configuration Precedence

**APPROVED** direction

Priority:

1. Core compiled Rules
2. Compatible Firebase Remote Config / server-controlled config
3. Local cached config
4. Bundled default

Core Rules cannot be overridden by incompatible Remote Config.

---

# 150. Migration Architecture

Client migrations:

- local DB schema
- active Attempt schema
- content cache schema

Backend migrations:

- DB schema
- content schema
- API contracts

Version everything.

---

# 151. Backward Compatibility

Prefer additive API changes.

Avoid requiring same-day app/backend deployment coupling.

Content bundles declare minimum app version.

---

# 152. Development Environments

**APPROVED**

- DEV
- TEST
- STAGING
- PROD

(plus local developer machines)

Use separate Firebase projects / configs for:

- Auth
- Firestore
- Storage
- Functions/Cloud Run
- store product IDs where possible
- analytics environments

---

# 153. Build Flavors

**APPROVED** direction

Client flavors:

- dev
- staging
- prod

Potentially:

- mock/local

Each flavor points to its own Firebase/backend config.

---

# 154. Secrets Management

Never commit:

- API secrets
- signing secrets
- server credentials

Client public configuration is not treated as secret.

Server secrets use Google Cloud Secret Manager / Firebase-appropriate secret handling.

Azure Key Vault is **SUPERSEDED** for MVP.

---

# 155. Developer Tooling

Recommended:

- static analysis
- formatter
- code generation where useful
- pre-commit checks
- test coverage
- ADR repository
- API contract generation if valuable

---

# 156. Code Generation

Possible in Flutter:

- Freezed
- JSON serialization

Use code generation only where it reduces boilerplate without making debugging harder.

---

# 157. API Contract Strategy

**APPROVED** direction

- Firebase Auth / Firestore / Storage / Callables as primary mobile integration surface.
- OpenAPI (or equivalent) for Admin HTTP APIs on Cloud Run where useful.
- Do not use generated DTOs directly as domain entities.

---

# 158. Admin API

Admin API should be separate authorization surface, even if same backend application.

Paths/modules:

- /admin/content
- /admin/levels
- /admin/publish
- /admin/config

Exact routes TBD.

---

# 159. Public Player API

Potential modules:

- /identity
- /player
- /progress
- /wallet
- /purchases
- /content
- /daily

Do not expose admin operations.

---

# 160. Health Checks

Cloud Functions / Cloud Run services should expose health/readiness where applicable.

Firestore and Storage rely on Firebase/GCP service health. Exact SLO numbers remain **TBD**.

---

# 161. Observability Correlation

Client includes correlation IDs where useful.

Backend logs request correlation.

Critical flows:

- purchase
- cloud sync
- reward grants
- content update

---

# 162. Architecture Testing Gate

Before production:

- domain dependency rules checked
- Game Engine has no UI dependency
- Solver has no UI/SDK dependency
- repository contracts tested
- offline fallback tested
- purchase flow tested
- content compatibility tested
- cloud sync failure tested

---

# 163. MVP Software Architecture Scope

MVP software architecture includes:

- Mobile client.
- Game Engine.
- Solver.
- Level Generator.
- Local persistence.
- Backend API.
- Player identity.
- Progression/cloud save.
- Wallet/economy.
- Ads/IAP adapters.
- Content delivery.
- CMS/Admin.
- Analytics/crash.
- Remote Config.
- Basic notifications if P1 included.

---

# 164. Post-MVP Architecture Extensions

Future modules:

- XP
- Achievements
- Collections
- Badges
- Cosmetics
- Events
- Packs
- Leaderboards

These should extend existing module boundaries rather than redesigning core gameplay.

---

# 165. Architecture Decision Register — Confirmed

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §§5–10, 13, 13A, 14):

### Product (preserved)
1. Arabic-first mobile game; iOS/Android; Endless Main Journey.
2. Solver-dependent rules; randomized Solver-validated boards; fixed Move Limit.
3. Hint and Dead-End use Solver; content data-driven + human review.
4. Anonymous identity + optional Apple/Google linking; Cloud Save; Coins/Hints/Ads/IAP; no Lives/Energy.
5. Daily systems at launch; CMS/Admin required; Analytics/Remote Config required.

### Client
6. **Flutter** + **Riverpod** + **Drift / SQLite**.
7. Game Engine framework-independent from UI/state management.
8. Solver: **Pure Dart**; hybrid search direction; **hybrid execution**.
9. On-device Main Journey generation; on-device Hint/Dead-End where practical.

### Backend / Cloud
10. **Firebase-first / serverless-first / cost-conscious**.
11. Firestore + Storage + Cloud Functions/Cloud Run + Firebase Auth.
12. Analytics, Crashlytics, FCM, Remote Config; GitHub Actions; DEV/TEST/STAGING/PROD.
13. Domain-specific Cloud Save conflict policy (Register §7); Active Attempt local-first; no per-Move cloud traffic.
14. Offline Main Journey after content download; offline Coin spend via queued idempotent transactions.
15. Purchases/Rewarded Ads require network; IAP validated server-side.
16. Angular CMS + Microsoft Entra ID + MFA; audit retention 2 years.
17. AdMob + Mediation; Flutter `in_app_purchase`.

### Explicitly SUPERSEDED for MVP (§13A)
18. ASP.NET Core Modular Monolith, PostgreSQL, Azure (Container Apps, PG Flexible Server, Blob, Front Door, ACR, Key Vault, App Insights/Monitor), Bicep mandatory IaC, DB-backed jobs default, Azure SKU assumptions.

### Explicitly DEFERRED (§13)
19. Redis, message broker, Kubernetes, always-on relational DB, ASP.NET+PG unless justified.

---

# 166. Architecture Decision Register — Still Open / Proposed Engineering Detail

**STILL TBD** (Register §14) — do not block baseline:

1. Exact Solver algorithm composition after benchmarking.
2. Exact timeout/performance budgets.
3. Whether native optimization is ever necessary.
4. Exact backend fallback rules.
5. Exact Firebase/GCP quotas, billing budgets, Functions/Cloud Run resource limits and scaling thresholds.
6. Exact DR RPO/RTO.
7. Staffing / calendar / commercial budget.
8. Final ad mediation network mix; pen-test vendor; analytics cost thresholds for retention review.

**PROPOSED** engineering details (may evolve without reopening platform choice):

- Exact Flutter folder naming / package split.
- GoRouter route map; Dio vs callable-only networking mix.
- OpenAPI for Admin HTTP surfaces.
- Isolates for heavy Solver work.
- In-process domain event catalog.
- Exact Firestore document layout (belongs to Data Model / Sync Spec).

---

# 167. Closed Decisions — No Longer Blocking Coding Start

The following are **closed** by Final Decision Register v1.1 and are **not** open platform choices:

1. Mobile client framework → Flutter.
2. State management → Riverpod.
3. Local database → Drift / SQLite.
4. Solver language → Pure Dart.
5. Solver execution → Hybrid.
6. Main Journey generation → on-device (fallback rules TBD).
7. Backend → Firebase/GCP serverless.
8. Primary cloud data → Firestore.
9. Auth → Firebase Auth anonymous-first + link.
10. Cloud Save conflict → domain-specific policy (§7).
11. Wallet → server-authoritative via trusted functions.
12. Content delivery → hybrid versioned bundles on Firebase Storage.
13. CMS → Angular + Entra ID.
14. Analytics/Crash/Push/Remote Config → Firebase suite.
15. Ads → AdMob + Mediation.
16. CI → GitHub Actions; 4 environments.
17. Offline policy → Register §7.
18. Azure MVP topology → SUPERSEDED.

---

# 168. Approved MVP Architecture Baseline

**APPROVED / CONFIRMED**

### Client
- Flutter + Riverpod + GoRouter + Drift
- Pure Dart Game Engine (UI-independent)
- Pure Dart Solver (hybrid execution)
- Local Attempt generation
- Local-first Active Attempt persistence
- Firebase Auth / Analytics / Crashlytics / FCM / Remote Config adapters

### Backend
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Cloud Functions and/or Cloud Run for wallet, IAP, Daily, Admin, anti-abuse
- No Redis / broker / K8s / always-on RDBMS by default
- Azure Modular Monolith **SUPERSEDED**

### Admin
- Angular + Microsoft Entra ID + MFA
- Privileged Functions/Cloud Run only

### Integrations
- AdMob + Mediation
- Flutter `in_app_purchase` + server validation
- Apple/Google account linking via Firebase Auth

### Content
- versioned hybrid bundles
- hash/schema/rules validate + atomic activation + last-known-valid rollback

---

# 169. Why This Baseline Fits the Product

It optimizes for:

- small-team execution
- fast iteration
- one mobile codebase
- strong deterministic game logic
- offline gameplay
- minimal always-on infrastructure cost
- content scalability
- safe monetization
- future feature expansion

It avoids premature:

- Kubernetes
- microservices
- event-broker dependence
- Azure always-on Modular Monolith
- server-side gameplay roundtrips / per-Move cloud traffic

---

# 170. Risks

## Solver Performance
Pure Dart may become expensive for advanced boards.

Mitigation:
- benchmark early
- isolates
- pruning
- native/FFI later only if needed (**TBD**)
- backend fallback available (**exact rules TBD**)

## Cloud Sync / Firestore Cost
Excessive reads/writes or conflict bugs.

Mitigation:
- domain-specific merge policy
- server-authoritative Wallet
- no per-Move sync
- budget alerts before PROD

## Content Volume
Large Arabic content operation can become a production bottleneck.

Mitigation:
- CMS
- AI-assisted drafts
- review workflow
- content bundle pipeline

## Random Difficulty Variance
Mitigation: Solver + Difficulty acceptance windows

---

# 171. Technical Debt Guardrails

Avoid:

- putting rules in UI
- duplicating Solver/Game Engine logic
- hard-coding Level content
- direct SDK usage everywhere
- one giant global state provider
- unrestricted client-side production Firestore mutation
- storing Wallet as client-only integer
- shipping incompatible content without versioning
- reintroducing Azure/ASP.NET/PostgreSQL MVP topology without architecture review

---

# 172. Recommended Next Deliverables

1. **API / Callable Specification** (Firebase-aligned)
2. **Cloud Save & Sync Specification**
3. **CMS Specification**
4. **Analytics & KPI Specification**
5. **QA & Automated Validation Strategy**
6. **Level Generator Specification**
7. **Gameplay Interaction Specification**
8. **MVP Product Backlog / WBS**
9. **Estimation & Delivery Roadmap**
10. Firestore Security Rules + Data Model alignment

---

# 173. Baseline Status

This document is **Software Architecture v1.0**, Decision-Aligned to **Final Decision Register v1.1**.

It defines the approved Flutter/Riverpod/Drift client structure, UI-independent Game Engine, Pure Dart hybrid Solver, Firebase-first serverless backend boundaries, content delivery, Cloud Save conflict policy, economy/monetization integration, CMS, testing, and integrations.

Azure Modular Monolith + PostgreSQL and related Azure services are **SUPERSEDED for MVP**. Remaining TBD items are Solver tuning, Firebase quotas/billing/resource limits, DR RPO/RTO, and staffing — they do not reopen the platform baseline.

**End of Software Architecture v1.0**
