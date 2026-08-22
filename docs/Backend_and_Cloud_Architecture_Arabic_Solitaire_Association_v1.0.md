# Backend & Cloud Architecture
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1) — Firebase-First MVP Baseline  
**Source Documents:** Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 + Screen Inventory & User Flows v1.0 + Content Design System v1.0 + Arabic Content Guidelines v1.0 + Level Design Framework v1.0 + Difficulty Model v1.0 + Solver Specification v1.0 + Game Engine Technical Design v1.0 + Data Model v1.0 + Software Architecture v1.0 + Final Decision Register v1.1  
**Important:** Register-approved architecture is **APPROVED/CONFIRMED**. Azure-heavy MVP topology (ASP.NET Modular Monolith, PostgreSQL, Container Apps, Blob, Front Door, ACR, Key Vault, App Insights, Bicep, etc.) is **SUPERSEDED for MVP** (Register §13A). Exact Firebase/GCP quotas, billing budgets, Functions/Cloud Run resource limits, autoscaling thresholds, and DR RPO/RTO remain intentional **TBD** (Register §14).

---

# 1. Purpose

This document defines the **approved Firebase-first / serverless-first** backend and cloud architecture for the Arabic Solitaire Association game.

It covers:

- Player identity (Firebase Authentication).
- Cloud player/progression state (Cloud Firestore).
- Content/asset delivery (Firebase Storage).
- Sensitive/server-authoritative logic (Cloud Functions and/or Cloud Run).
- Economy / Wallet / IAP validation.
- Daily Reward / Daily Challenge / Daily Streak.
- Push (FCM), Analytics, Crashlytics, Remote Config.
- Admin/CMS security boundaries.
- Environments, CI/CD, observability, backups, cost control.

It does **not** alter approved Game Engine or Solver rules. Game Engine, Solver, and Main Journey Level Generation remain primarily on-device.

---

# 2. Architecture Goals

1. Low operational complexity and cost in MVP.
2. Do not pay for always-on infrastructure unless a demonstrated product/scale need justifies it.
3. Strong integrity for Wallet and purchases via trusted serverless logic.
4. Reliable Cloud Save without per-Move cloud traffic.
5. Offline-friendly Main Journey once content is downloaded.
6. Safe anonymous-first identity with optional Apple/Google linking.
7. Versioned hybrid content delivery.
8. Clear Admin/CMS security boundaries on Firebase/GCP.
9. Managed scaling and quotas instead of pre-provisioned always-on compute.
10. Clear Post-MVP path if ASP.NET + PostgreSQL ever becomes justified.

---

# 3. Architecture Principle

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §6)

- **Firebase-first, serverless-first, cost-conscious.**
- Primary MVP cloud platform: **Firebase / Google Cloud managed services.**
- Prefer Firebase/GCP managed scaling and quotas.
- **No Kubernetes in MVP.**
- **No Redis in MVP by default** (**DEFERRED**).
- **No dedicated Message Broker in MVP by default** (**DEFERRED**).
- **No always-on relational database in MVP by default** (**DEFERRED**).
- **No Azure infrastructure is part of the MVP baseline** (**SUPERSEDED**, §13A).
- ASP.NET Core + PostgreSQL may be reconsidered later only if scale, CMS complexity, relational-query, reporting, or operational constraints justify it (**DEFERRED**).

---

# 4. SUPERSEDED — Azure MVP Topology (Do Not Implement)

**SUPERSEDED for MVP** (Final Decision Register §13A). Previously proposed Azure-heavy decisions must not be implemented unless a future architecture review re-approves them:

| Superseded item | Replacement |
|---|---|
| ASP.NET Core as mandatory MVP backend | Cloud Functions / Cloud Run for sensitive logic |
| Modular Monolith as mandatory MVP backend shape | Serverless function/service modules on Firebase/GCP |
| PostgreSQL as mandatory MVP primary database | Cloud Firestore for suitable document-oriented state |
| Azure as primary MVP cloud provider | Firebase / Google Cloud |
| Azure Container Apps | Cloud Functions / Cloud Run (as needed) |
| Azure Database for PostgreSQL Flexible Server | Firestore (no always-on relational DB by default) |
| Azure Blob Storage | Firebase Storage |
| Azure Front Door / CDN | Firebase Storage / GCP-native static delivery; no separate paid CDN unless measured need |
| Azure Container Registry | Not part of MVP baseline |
| Azure Key Vault | Google Cloud Secret Manager / Firebase-native secret handling |
| Azure Application Insights / Azure Monitor | Firebase / GCP native logs & monitoring |
| Bicep as mandatory MVP IaC | Firebase project config + GCP IaC as needed (exact tool TBD) |
| DB-backed background jobs as default job model | Scheduled Functions / Cloud Tasks / Cloud Scheduler patterns |
| Azure-specific sizing / SKU assumptions | Firebase/GCP quotas & billing budgets (**TBD** tuning) |

AWS and Azure are **not** co-equal MVP options. Azure is out of the MVP baseline.

---

# 5. High-Level Firebase Architecture

```text
                         +----------------------+
                         |   Mobile Clients     |
                         | Flutter / Riverpod   |
                         | Drift local-first    |
                         +----------+-----------+
                                    |
                    Firebase Auth + HTTPS / SDKs
                                    |
         +--------------------------+--------------------------+
         |                          |                          |
         v                          v                          v
+----------------+        +------------------+        +------------------+
| Cloud Firestore|        | Firebase Storage |        | Cloud Functions  |
| player / sync  |        | content bundles  |        | / Cloud Run      |
| config refs    |        | illustration     |        | wallet / IAP     |
| daily metadata |        | assets           |        | daily / admin    |
+----------------+        +------------------+        | anti-abuse       |
                                                      +--------+---------+
                                                               |
                         +-------------------------------------+
                         | Firebase product services           |
                         | Analytics + BigQuery export         |
                         | Crashlytics / FCM / Remote Config   |
                         +-------------------------------------+

Admin CMS (Angular + Microsoft Entra ID + MFA)
  -> privileged Cloud Functions / Cloud Run only
  -> no unrestricted client-side production mutation
```

---

# 6. Client / Backend Responsibility Split

## Client (Flutter)

Owns:

- Game Engine (UI-independent).
- Pure Dart Solver (hybrid execution).
- On-device Main Journey generation.
- On-device Hint / Dead-End where practical.
- Active Attempt persistence in Drift / SQLite (local-first, device-specific).
- Local content cache after download/validate/activate.
- Optimistic local progression/economy display cache.
- Offline Coin spend queue (idempotent, for later reconciliation).

## Backend (Firebase / GCP)

Owns or validates:

- Firebase Authentication identity.
- Durable cloud player/progression/Daily state in Firestore.
- Wallet/economy mutations via trusted Functions/Cloud Run.
- IAP validation and purchase grants.
- Daily Reward / Daily Streak eligibility (backend authoritative for time).
- Privileged Admin operations.
- Anti-abuse validation.
- Content publish manifests and Storage objects.
- FCM scheduling eligibility / send orchestration.
- Audit of sensitive admin actions.

---

# 7. No Per-Move Server Dependency

**APPROVED / CONFIRMED**

Core Main Journey gameplay must not require an API/Firestore request for every Move.

Cloud synchronization must minimize Firestore reads/writes and avoid per-Move cloud traffic.

Reasons: offline resilience, latency, cost, mobile UX, simpler scaling.

---

# 8. Approved Firebase / GCP Service Map

| Concern | APPROVED MVP service |
|---|---|
| Identity | Firebase Authentication (anonymous-first; Apple/Google link) |
| Player / progression / Daily / sync metadata | Cloud Firestore |
| Content bundles & illustration assets | Firebase Storage |
| Sensitive / server-authoritative logic | Cloud Functions and/or Cloud Run |
| Product analytics | Firebase Analytics (+ BigQuery export) |
| Crash reporting | Firebase Crashlytics |
| Push | Firebase Cloud Messaging |
| Client Remote Config | Firebase Remote Config |
| Backend observability | Firebase / GCP native logs & monitoring |
| CI/CD | GitHub Actions |
| Environments | DEV, TEST, STAGING, PROD |
| Ads | Google AdMob + Mediation |
| IAP client | Flutter `in_app_purchase` |
| IAP validation | Cloud Functions / Cloud Run |
| Admin auth | Microsoft Entra ID + MFA |

---

# 9. Logical Backend Modules (Serverless)

**APPROVED** direction: modular *logical* boundaries implemented as Cloud Functions / Cloud Run services — **not** an always-on ASP.NET Modular Monolith.

Suggested modules:

1. Identity / Player
2. Progression / Cloud Save
3. Economy / Wallet
4. Purchases / Entitlements
5. Content / Publishing
6. Levels / Config references
7. Daily systems
8. Notifications
9. Configuration / Feature flags (server-authoritative where required)
10. Admin / CMS privileged API
11. Audit
12. Analytics integration hooks
13. Solver simulation / fallback (optional; exact rules TBD)

---

# 10. Data Store — Cloud Firestore

**APPROVED / CONFIRMED**

Use Cloud Firestore for suitable document-oriented state such as:

- Player profile.
- Progression.
- Daily state.
- Sync metadata.
- Configuration references.
- Lightweight operational data.

Design principles:

- Domain-specific documents (not one monolithic “latest JSON wins” blob).
- Minimize reads/writes; batch sync milestones.
- Idempotent economy/progression writes through trusted functions where required.
- Indexes and security rules aligned to player vs admin privilege.

**DEFERRED:** always-on relational database (PostgreSQL) unless justified later.

---

# 11. Object Storage — Firebase Storage

**APPROVED / CONFIRMED**

Use Firebase Storage for:

- Remote versioned content bundles.
- Illustration assets where appropriate.
- Admin uploads (via privileged publish pipeline).

**APPROVED** content activation:

1. Download.
2. Validate hash.
3. Validate schema.
4. Validate rules compatibility.
5. Atomic activation.
6. Keep last-known-valid bundle for rollback.

No separate paid CDN layer is required for MVP unless measurements demonstrate a need.

---

# 12. Serverless Compute — Functions / Cloud Run

**APPROVED / CONFIRMED**

Sensitive/server-authoritative logic runs through Cloud Functions and/or Cloud Run, including:

- Wallet/economy mutations.
- IAP validation and purchase grants.
- Daily Reward / Daily Streak eligibility.
- Privileged Admin operations.
- Anti-abuse validation.
- Any operation that must not trust the client.
- Optional Solver backend fallback / CMS validation jobs (exact fallback rules **TBD**).

Prefer short-lived, scale-to-zero (or managed quota) compute. Exact resource limits, concurrency, and billing budgets are **STILL TBD** (Register §14).

---

# 13. Identity Architecture

**APPROVED / CONFIRMED** (Register §7)

- Anonymous-first identity uses **Firebase Authentication**.
- Anonymous Firebase user is created first.
- Optional Apple/Google provider linking is supported.
- Provider linking preserves the same logical player identity whenever valid.
- If a provider is already linked elsewhere: **explicit conflict flow**; **no silent automatic merge**.

Internal `player_id` / profile documents map to the Firebase Auth UID (or a stable internal ID linked 1:1). Do not use provider tokens as the internal Player ID.

---

# 14. Anonymous Identity Flow

```text
Client first launch
 -> Firebase Auth signInAnonymously
 -> ensure Player profile doc exists (Functions or guarded client bootstrap)
 -> secure local session via Firebase Auth SDK
 -> Drift caches player/session metadata as needed
```

---

# 15. Account Linking Flow

```text
Anonymous Firebase user
 -> Sign in with Apple/Google
 -> linkWithCredential (or equivalent) when valid
 -> Preserve same Firebase UID / logical player
 -> Sync durable cloud state
```

Conflict if provider already linked elsewhere → explicit UI/flow; no silent merge.

---

# 16. Active Attempt & Offline Policy

**APPROVED / CONFIRMED** (Register §7)

- Active Attempt persistence: **Local-first in Drift / SQLite**.
- Active Attempt: **local / device-specific** (not a cloud merge domain).
- Main Journey fully playable offline once required content is downloaded.
- Offline Coin spending allowed against locally reconciled balance.
- Offline spend uses queued **idempotent** transactions for later server reconciliation.
- Purchases and Rewarded Ads require network.

---

# 17. Cloud Conflict Policy (Domain-Specific)

**APPROVED / CONFIRMED** (Register §7)

| Domain | Policy |
|---|---|
| Progression | Merge to highest valid progression |
| Wallet | Server-authoritative transaction/ledger logic through trusted backend functions |
| Purchases / Entitlements | Store + trusted backend authority |
| Settings | Latest valid revision |
| Active Attempt | Local / device-specific |

Do not merge all domains through one generic last-write-wins blob.

---

# 18. Wallet / Economy

**APPROVED**

- Server-authoritative ledger/transaction logic in Cloud Functions / Cloud Run.
- Append-only (or equivalently auditable) transactions with idempotency keys.
- Client may display locally reconciled balance; cloud Wallet remains authoritative after sync.
- Offline grants/spends queue for reconciliation; never invent unverified IAP grants.

---

# 19. In-App Purchase Validation

**APPROVED**

```text
StoreKit / Play Billing (Flutter in_app_purchase)
 -> Client receives transaction
 -> Cloud Functions / Cloud Run validates with store APIs
 -> Idempotency check
 -> Persist PurchaseTransaction
 -> Grant Coins / Remove Ads entitlement
 -> Client refreshes durable state
```

Do not trust client-only purchase success for permanent entitlements.

---

# 20. Rewarded Ads

**APPROVED** client ads stack: Google AdMob + Mediation.

Backend sensitivity depends on reward type. Coin grants should use idempotent grant records. Exact ad-provider server-side verification mix remains operational TBD; final mediation network mix is **STILL TBD** (Register §14).

---

# 21. Daily Systems

**APPROVED** product behavior (Register §4):

- Backend authoritative for Daily time/eligibility.
- Daily Challenge reset: **00:00 validated player-local timezone**.
- Daily Challenge board: fixed deterministic board per challenge cohort.
- Daily Reward / Streak eligibility must not trust device clock alone when online.

Pipeline for Daily Challenge generation may run as scheduled Cloud Functions / Cloud Run jobs using the shared Pure Dart Solver core (or equivalent) for validation.

---

# 22. Content Delivery

**APPROVED** hybrid delivery:

- Bundled base content.
- Remote versioned content bundles on Firebase Storage (or another Firebase/GCP-native static mechanism when justified).

CMS/Admin can immediately disable problematic content without app release. Production content approval is separate from Publisher action. AI drafts only; human Arabic + semantic approval mandatory.

---

# 23. Notifications

**APPROVED**

- Push: **Firebase Cloud Messaging**.
- Launch infrastructure included.
- Initially active types: Daily Challenge; Streak Risk.
- Quiet hours: 22:00–09:00 player-local time.
- Richer notification types: **DEFERRED** Post-MVP.

---

# 24. Analytics, Crash, Remote Config

**APPROVED**

- Product analytics: **Firebase Analytics**.
- BigQuery export enabled.
- Raw analytics retention baseline: **14 months**, then cost review.
- Mobile crash: **Firebase Crashlytics**.
- Client Remote Config: **Firebase Remote Config**.
- Authoritative sensitive configuration remains server-controlled where required.
- Cost monitoring / budget alerts should be enabled before production rollout.
- Exact analytics cost thresholds that trigger retention-policy review: **STILL TBD**.

No separate Azure observability stack.

---

# 25. Admin / CMS

**APPROVED** (Register §10)

- CMS frontend: **Angular**.
- Admin authentication: **Microsoft Entra ID**.
- MFA for privileged access.
- Production publish permission separated from ordinary content editing.
- Broad Economy / Notification changes require re-authentication + explicit confirmation.
- Audit log retention: **2 years**.
- Admin/CMS accesses Firebase/GCP data and privileged operations **only through approved security boundaries**; **no unrestricted client-side production mutation**.

Admin must support: content authoring/review, Level configuration, Solver validation, publishing/rollback, economy/configuration, audit, essential player support.

---

# 26. Solver Cloud Role

**APPROVED** hybrid execution (Register §5):

- On-device Main Journey generation.
- On-device Hint/Dead-End where practical.
- Same Pure Dart Solver core reusable in CMS/CI/backend simulation.
- Backend fallback available if needed.

Exact Solver algorithm composition, timeouts, whether native optimization is necessary, and exact backend fallback rules remain **STILL TBD** (Register §14).

Heavy CMS/CI simulations should run outside player request latency path (Cloud Run job / scheduled Function).

---

# 27. Environments

**APPROVED**

- DEV
- TEST
- STAGING
- PROD

Separate Firebase projects (or strictly isolated environments) with separate:

- Auth config
- Firestore data
- Storage buckets/prefixes
- Functions/Cloud Run services
- Analytics projects where practical
- Admin access
- Secrets

---

# 28. CI/CD

**APPROVED:** **GitHub Actions**.

Typical stages:

1. Static analysis / lint.
2. Client unit + Game Engine + Solver tests.
3. Functions/Cloud Run unit/integration tests.
4. Build artifacts.
5. Deploy to STAGING.
6. Smoke tests.
7. Controlled PROD promote.

Content publication remains separate from app store release.

---

# 29. Secrets & Security

- Use Google Cloud Secret Manager / Firebase-appropriate secret handling for store validation keys, admin secrets, and service credentials.
- TLS for all external traffic.
- Firestore Security Rules + Admin-only privileged callables.
- Idempotency for purchase, Daily claim, rewarded Coin grant, Level completion reward, Extra Moves / Rescue grants.
- Rate-limit / abuse controls on sensitive callables.
- Pre-launch: automated security checks + focused external/manual penetration test for backend/Admin/purchase flows (vendor **TBD**).

Azure Key Vault is **SUPERSEDED** for MVP.

---

# 30. Observability

**APPROVED**

- Client: Crashlytics + Analytics.
- Backend: Firebase / GCP native logs and monitoring for Cloud Functions / Cloud Run.
- Structured logs with correlation IDs for purchase, sync, reward grants, content publish.
- Alerts for: API/callable failures, purchase validation failures, Daily Challenge missing, content publish failure, budget overruns.

Azure Application Insights / Azure Monitor are **SUPERSEDED** for MVP.

---

# 31. Backups & Disaster Recovery

MVP DR posture:

- Firestore managed backups / export strategy as configured.
- Storage versioning for published bundles where practical.
- Documented restore and content-manifest rollback.
- Secrets/config recovery procedures.

**STILL TBD:** exact DR **RPO/RTO** values (Register §14).

---

# 32. Scaling & Cost

**APPROVED** principles:

- Prefer scale-to-zero / managed quotas.
- Avoid per-Move Firestore traffic.
- Keep Solver primarily on-device.
- No Kubernetes, Redis, or message broker by default.
- Enable billing budgets/alerts before PROD.

**STILL TBD:** exact Firebase/GCP quotas, billing budgets, Cloud Functions / Cloud Run resource limits and scaling thresholds (Register §14).

---

# 33. Graceful Degradation

| System | Backend degraded | Gameplay impact |
|---|---|---|
| Main Journey core | Minimal if content cached | Continue offline |
| Local Restart / generation | Local Solver | Continue |
| Hint / Dead-End | Local where practical | Continue; fallback TBD |
| Cloud Save | Queue sync | Continue locally |
| Daily Reward | Unavailable | Retry later |
| Daily Challenge | May use cached cohort board | Partial |
| Shop / IAP | Pending | No unvalidated grant |
| Rewarded Ads | Provider-dependent | Optional unavailable |
| Content update | Use last-known-valid | Continue |
| Notifications | No immediate gameplay impact | None |

---

# 34. DEFERRED — Explicitly Post-MVP / Not Default

From Register §§13–13A:

- Dedicated Redis / cache layer unless measured need.
- Dedicated Message Broker / queue platform unless justified.
- Kubernetes unless future scale/ops requires it.
- ASP.NET Core + PostgreSQL unless Firebase-first proves insufficient.
- Dedicated always-on backend infrastructure unless justified.
- Separate paid CDN unless measurements demonstrate need.
- Azure MVP topology listed in §4 (SUPERSEDED).

Product Post-MVP (Events, XP, Achievements, Leaderboards, etc.) follows Register §13 product deferrals; extend modules without changing core Engine rules.

---

# 35. STILL TBD — Operational Tuning

Intentional open items (Register §14) that do **not** block this baseline:

- Exact Firebase / Google Cloud quotas, billing budgets, Functions / Cloud Run resource limits and scaling thresholds.
- Exact DR RPO/RTO.
- Exact autoscaling thresholds.
- Exact Solver algorithm composition, timeouts, native opt necessity, backend fallback rules.
- Final ad mediation network mix.
- Final penetration-test vendor.
- Exact analytics cost thresholds for retention-policy review.
- Staffing / calendar / commercial budget (delivery planning).

---

# 36. MVP Cloud Scope (Aligned)

MVP backend/cloud includes:

- Firebase Auth (anonymous + link).
- Firestore durable player/progression/Daily/sync state.
- Firebase Storage content bundles/assets.
- Cloud Functions / Cloud Run for Wallet, IAP, Daily eligibility, Admin, anti-abuse.
- Hybrid on-device Solver/generation with optional backend fallback path.
- Analytics, Crashlytics, FCM, Remote Config.
- GitHub Actions; DEV/TEST/STAGING/PROD.
- Angular CMS + Entra ID + MFA + audit.
- Cost monitoring before PROD.

---

# 37. Decision Register — Confirmed (Architecture)

1. Firebase-first / serverless-first / cost-conscious MVP.
2. Firestore + Storage + Functions/Cloud Run.
3. Firebase Auth anonymous-first + Apple/Google link; explicit conflict flow.
4. Domain-specific cloud conflict policy (Register §7).
5. Active Attempt local-first Drift; no per-Move cloud traffic.
6. Offline Main Journey after content download; offline Coin spend via queued idempotent txns.
7. Purchases / Rewarded Ads require network; IAP validated server-side.
8. Analytics / Crashlytics / FCM / Remote Config.
9. GitHub Actions; four environments.
10. Angular CMS; Entra ID; MFA; 2-year audit retention.
11. No K8s / Redis / broker / always-on RDBMS by default.
12. Azure MVP stack **SUPERSEDED** (§13A).

---

# 38. Recommended Next Backend Deliverables

1. API / Callable Specification (Firebase-aligned).
2. Cloud Save & Sync Specification (Firestore write budgets).
3. Firestore data layout & Security Rules.
4. CMS Specification (Angular + privileged Functions).
5. Infrastructure / Firebase project bootstrap guide.
6. Security Architecture & pen-test scope.
7. Observability & budget-alert plan.
8. Backup & DR Plan (with RPO/RTO once decided).
9. Analytics & KPI Specification.
10. QA & Automated Validation Strategy.
11. MVP WBS / Product Backlog.

---

# 39. Baseline Status

This document is **Backend & Cloud Architecture v1.0**, Decision-Aligned to **Final Decision Register v1.1**.

It establishes the **Firebase / GCP serverless MVP baseline**. Azure Modular Monolith + PostgreSQL + related Azure services are **SUPERSEDED for MVP** and must not be treated as co-equal options. Remaining TBD items are operational/commercial tuning and do not reopen the platform choice.

**End of Backend & Cloud Architecture v1.0**
