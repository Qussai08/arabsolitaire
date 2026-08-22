# Sprint 11 — Production Hardening, Observability, Security & Release Readiness v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Production Hardening / Observability / Security / Performance / Release Readiness  
**Depends On:** Sprint 10 — Content Bundles, CMS Integration & Publishing Pipeline v1  
**Primary App:** `apps/mobile`  
**Admin/CMS:** `apps/admin`  
**Cloud:** Firebase / Google Cloud  
**Release Targets:** iOS + Android  
**Primary Tooling:** Firebase Analytics, BigQuery, Crashlytics, Firebase/GCP Logs & Monitoring, GitHub Actions  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 11 Objective

Take the MVP from feature-complete to **production-ready**.

Sprint 11 must harden:

- runtime stability;
- observability;
- analytics correctness;
- security;
- App Check;
- secrets/configuration;
- Firebase rules;
- backend functions;
- performance;
- startup time;
- solver/generator runtime behavior;
- memory;
- persistence;
- offline reliability;
- accessibility;
- Arabic RTL;
- localization;
- content delivery;
- monetization;
- Daily systems;
- admin publishing;
- release automation;
- rollback/runbooks;
- store readiness;
- staged rollout;
- final MVP release gate.

The goal is:

> **Release a measurable, secure, recoverable, observable, store-ready MVP with no known release-blocking gameplay, economy, security, content, or infrastructure defects.**

---

# 2. Sprint 11 Success Criteria

Sprint 11 is complete only when:

1. No unresolved S0 defect exists.
2. No unresolved core-path S1 defect exists.
3. Engine ↔ Solver parity is green.
4. No accepted unsolvable board exists in release validation.
5. 10,000+ simulation gate passes for critical Level templates/configurations.
6. Crashlytics is production-validated.
7. Analytics events are validated end-to-end.
8. BigQuery export is enabled/verified.
9. logs/metrics/alerts exist for critical backend flows.
10. Firebase budget alerts exist before production rollout.
11. Security Rules tests pass.
12. App Check hardening is enabled where practical.
13. secrets/config audit passes.
14. purchase/economy endpoints pass focused security review.
15. Admin/publishing endpoints pass focused security review.
16. external/manual penetration test scope is ready and findings triaged.
17. startup/runtime performance is measured and acceptable.
18. gameplay interaction remains responsive.
19. Solver/Generator heavy work does not block UI.
20. offline critical path passes.
21. Arabic RTL QA passes.
22. accessibility baseline passes.
23. content rollback runbook is tested.
24. economy/monetization crash-recovery scenarios pass.
25. App Store/Google Play metadata/build readiness is complete.
26. staged rollout/rollback plan exists.
27. release checklist is executable.
28. production support/incident runbooks exist.
29. PROD configs are separated from lower environments.
30. final MVP Go/No-Go gate can be run from a single checklist.

---

# 3. Non-Goals

Do NOT implement in Sprint 11:

- major new gameplay features;
- Events;
- Leaderboards;
- XP;
- Achievements;
- Badges;
- Collections;
- new currencies;
- subscription;
- Starter Pack;
- major CMS redesign;
- architecture rewrite;
- new backend stack;
- Kubernetes;
- Redis;
- message broker;
- native Rust/C++ optimization without benchmark evidence;
- Arc 2 content production.

This sprint is for hardening, validation, and release readiness.

---

# 4. Release Severity Model

Approved:

```text
S0 — Blocker
S1 — Critical
S2 — Major
S3 — Minor
S4 — Trivial
```

Release rule:

- Any S0 blocks release.
- Any unresolved core-path S1 blocks release.

Core path includes:

- app bootstrap;
- gameplay;
- Engine transitions;
- Solver correctness;
- generation;
- progression;
- Wallet;
- IAP;
- Rewarded Ads;
- Daily reward/challenge;
- content activation;
- identity/sync;
- admin production publishing.

---

# 5. Release Blocker Examples

## S0

Examples:

- app cannot launch;
- accepted unsolvable Main Journey board;
- Wallet can duplicate Coins;
- purchase duplicate grants;
- cross-user data access;
- broken PROD content pointer with no fallback;
- user progression loss;
- crash loop on startup;
- invalid remote bundle bricks app.

## S1

Examples:

- Hint consumes resource but gives no valid Hint;
- Dead-End false positive triggers rescue;
- Restore Stock incorrect;
- account linking loses progression;
- Remove Ads entitlement ignored;
- Daily reward double grant;
- content rollback fails;
- Admin unauthorized publish possible.

---

# 6. Observability Architecture

Production observability must cover:

```text
Mobile App
Firebase Auth
Firestore
Cloud Functions / Cloud Run
Storage / Content
Economy
Monetization
Daily Systems
Notifications
Admin Publishing
```

Use:

- Firebase Analytics;
- BigQuery;
- Crashlytics;
- Firebase/GCP logs;
- metrics;
- alerts.

---

# 7. Crashlytics

Production Crashlytics must include non-sensitive context:

```text
appVersion
buildNumber
environment
rulesVersion
solverVersion
generatorVersion
activeBundleVersion
contentHash
levelDefinitionId
boardFingerprint
authStateType
walletRevision?
```

Do not include:
- auth tokens;
- purchase receipts;
- personal secrets;
- raw provider credentials.

---

# 8. Crashlytics Validation

Required:

- controlled non-PROD test crash;
- confirm event arrival;
- custom keys visible;
- non-fatal recording works;
- breadcrumb/event context useful;
- symbolication works for supported builds.

Do not intentionally crash PROD users.

---

# 9. Analytics Validation

Validate critical events from app to Analytics/BigQuery.

Minimum event families:

## Gameplay
- attempt_started
- move_accepted
- move_rejected
- hint_requested
- hint_used
- dead_end_confirmed
- out_of_moves
- level_won
- restart_requested

## Progression
- level_started
- level_completed
- chapter_completed
- story_beat_viewed
- tutorial_completed

## Economy
- wallet_initialized
- reward_claimed
- hint_purchased
- extra_moves_purchased
- dead_end_rescue_purchased

## Monetization
- rewarded_ad_completed
- interstitial_shown
- purchase_started
- purchase_validated
- restore_completed

## Daily
- daily_reward_claimed
- daily_streak_incremented
- daily_challenge_completed

## Content
- content_bundle_activated
- content_bundle_validation_failed
- content_bundle_rollback

---

# 10. Analytics Schema Quality

Each event should have:

- stable event name;
- documented properties;
- no accidental PII;
- bounded cardinality where practical;
- consistent IDs/versions.

Do not send:
- full Card text;
- arbitrary user-generated strings;
- raw exception stack as event property.

---

# 11. BigQuery Export

Approved:
- Firebase Analytics + BigQuery.

Validate:
- export enabled;
- dataset receiving data;
- event schema visible;
- cost monitored;
- 14-month raw analytics baseline documented.

---

# 12. Logging

Backend logs should be structured.

Include:

```text
requestId
operationId
uid hash/reference
operationType
result
duration
environment
schemaVersion
configVersion
```

Avoid secrets.

---

# 13. Correlation IDs

Recommended:

```text
requestId
operationId
idempotencyKeyHash
```

Propagate through:
- client request;
- backend function;
- ledger/receipt;
- logs.

Useful for support/debugging.

---

# 14. Metrics

Critical metrics:

- function error rate;
- function latency;
- Wallet operation failures;
- duplicate idempotency hits;
- purchase validation failures;
- content validation failures;
- auth/link conflicts;
- sync queue backlog;
- Daily claim errors;
- notification send errors;
- bundle rollback count.

---

# 15. Alerts

Create actionable alerts for:

- high backend error rate;
- purchase validation failure spike;
- Wallet transaction failures;
- repeated content activation failure;
- auth failure spike;
- Firestore permission-denied spike;
- notification function failures;
- crash-free users regression;
- Firebase budget threshold.

Avoid alert fatigue.

---

# 16. Budget Alerts

Approved requirement:
- cost/budget alerts before production.

Configure alerts for:
- Firebase/GCP spend thresholds;
- Functions/Run;
- Firestore;
- Storage;
- BigQuery;
- egress where relevant.

Exact monetary thresholds are operational/TBD.

Do not invent permanent budget values without approval.

---

# 17. Environment Audit

Verify hard separation:

```text
DEV
TEST
STAGING
PROD
```

Check:

- Firebase project IDs;
- Storage buckets;
- Remote Config;
- ad unit IDs;
- IAP product config;
- FCM;
- App Check;
- API endpoints;
- analytics;
- Crashlytics.

No lower-environment config may point to PROD accidentally.

---

# 18. Secrets Audit

Search repository for:

- service account keys;
- private keys;
- OAuth secrets;
- store keys;
- webhook secrets;
- API secrets;
- tokens;
- hard-coded passwords.

Nothing sensitive committed.

Use:
- GitHub Secrets;
- Firebase/GCP secret management;
- environment variables.

---

# 19. Git History Secret Check

Run secret scanning over:
- current tree;
- git history where practical.

If secret discovered:
- revoke/rotate;
- remove;
- document incident.

Do not only delete from latest commit.

---

# 20. App Check

Harden Firebase App Check for:

- Firestore;
- Storage;
- Functions where supported.

Rollout:
- validate metrics first;
- enforce progressively;
- ensure legitimate users are not blocked.

App Check is defense-in-depth.

---

# 21. Firestore Rules Audit

Re-run all rules tests.

Critical:

- user A cannot access user B;
- client cannot mutate Wallet;
- client cannot mutate entitlements;
- client cannot mutate purchase receipts;
- client cannot publish content;
- client cannot alter Daily authoritative rewards;
- current bundle pointer write denied;
- admin paths protected.

---

# 22. Storage Rules Audit

Verify:

- production content read as intended;
- client production content write denied;
- player-private upload paths, if any, scoped correctly;
- no wildcard public write.

---

# 23. Functions Authorization Audit

Every trusted endpoint must verify:

- authenticated user where required;
- correct UID from auth context;
- input schema;
- idempotency;
- permissions;
- environment/config.

Do not trust client UID argument.

---

# 24. Admin Security Audit

Review:

- Entra ID;
- MFA;
- role mapping;
- Publisher;
- Approver;
- audit permissions;
- production publish controls;
- reauthentication for sensitive actions.

---

# 25. Focused Penetration Test Scope

Prepare external/manual security test around:

- Firebase Auth flows;
- account linking/conflicts;
- Firestore rules;
- trusted Functions;
- Wallet;
- reward claims;
- IAP validation;
- ad reward claims;
- Admin/CMS;
- publishing/rollback;
- content disable;
- privilege escalation.

---

# 26. Pen Test Findings Policy

Classify findings using release severity model.

S0/S1:
- must resolve before release.

S2:
- explicit risk acceptance required if deferred.

S3/S4:
- backlog allowed.

---

# 27. Dependency Audit

Audit Flutter/Dart/npm dependencies for:

- known vulnerabilities;
- abandoned packages;
- incompatible licenses;
- unnecessary packages.

Do not upgrade blindly immediately before release.

Use targeted safe updates.

---

# 28. Mobile Security Review

Verify:

- no secrets in app binary;
- no debug endpoints in PROD;
- no DEV menus visible;
- no test ad IDs in PROD;
- no sandbox IAP config in PROD;
- secure network/TLS defaults;
- sensitive logs removed;
- local DB does not store provider tokens.

---

# 29. Local Data Security

Review Drift data:

- player progression;
- active Attempt;
- Wallet cache;
- pending economy operations;
- content cache.

No secrets should be stored unnecessarily.

If local tampering can only affect non-authoritative data:
- server reconciliation must correct.

---

# 30. Purchase Security

Validate:

- server-side receipt/token validation;
- product ID mapping server-side;
- duplicate transaction protection;
- environment validation;
- purchase ownership/account conflict handling;
- restore correctness.

---

# 31. Rewarded Ad Security

Validate:

- reward only after provider completion callback;
- backend idempotency;
- daily Coin cap;
- attempt rescue limit;
- duplicate callback protection;
- pending receipt recovery.

---

# 32. Economy Ledger Audit

Run consistency checker:

```text
wallet balance == authoritative transaction accumulation
```

for emulator/STAGING test users.

Verify:
- no negative balance;
- no duplicate initial grants;
- no duplicate Level/Chapter rewards.

---

# 33. Progression Consistency Audit

Validate:

- no impossible gaps;
- highest completed Level consistent;
- Chapter completion derivable;
- story unlocks valid;
- Tutorial state monotonic.

---

# 34. Engine ↔ Solver Parity

Release-critical.

For all Golden Boards and simulation samples:

- every Solver move accepted by Engine;
- solution replay reaches Win;
- no illegal move generated;
- no false solved result.

Any mismatch:
- S0/S1 depending impact;
- release blocked.

---

# 35. Generator Validation

Critical release configs must pass:

- Engine invariants;
- Solver solvability;
- Move Limit;
- Board Difficulty target;
- no duplicate/missing Cards;
- deterministic seed reproduction.

---

# 36. 10,000+ Simulation Gate

Approved:

Run at least:

```text
10,000+ generated boards
```

for each critical Level template/configuration group selected for release validation.

Capture:

- accepted;
- rejected unsolvable;
- Solver inconclusive;
- generation attempts;
- solution length;
- difficulty metrics;
- generation time;
- Solver time;
- memory/CPU observations.

---

# 37. Simulation Release Blockers

Block release if:

- any accepted board is later unsolvable;
- any solution replay fails;
- invariant violation appears;
- false Dead-End appears;
- generator can hang/unbounded-loop;
- serious performance regression appears.

---

# 38. Solver Inconclusive Policy

Inconclusive:
- never interpreted as unsolvable;
- never accepted for release board validation when proof required;
- never used as confirmed Dead-End.

Revalidate with stronger profile where needed.

---

# 39. Performance Profiling

Profile:

- app startup;
- Home;
- Journey;
- Gameplay render;
- drag/drop;
- animation;
- Engine transition;
- Solver Hint;
- Dead-End check;
- Level generation;
- Drift save/load;
- content activation;
- Wallet calls.

---

# 40. Startup Performance

Measure:

```text
cold start
warm start
time to first usable Home
time to resume active Attempt
```

Firebase/auth/content checks must not unnecessarily block UI.

---

# 41. Flutter Frame Performance

Check:
- drag responsiveness;
- animation jank;
- board updates;
- large tablet layout.

Use Flutter performance tooling.

Do not run Solver on UI isolate.

---

# 42. Solver Performance

Benchmark representative early/mid/late boards.

Capture:

- p50;
- p95;
- max;
- nodes expanded;
- transposition size;
- solution depth.

Exact final budgets are based on measured device capability.

Do not invent arbitrary hard budget without measurements.

---

# 43. Generator Performance

Capture:

- time per accepted board;
- retry count;
- p50/p95;
- worst-case bounded behavior.

If on-device generation becomes too slow:
- tune configs/search;
- do not silently introduce cloud dependency.

---

# 44. Memory Profiling

Check:

- Solver transposition growth;
- content bundles;
- images/assets;
- Drift caches;
- Story assets;
- ad SDKs.

No unbounded caches.

---

# 45. Battery / CPU Review

Pay attention to:

- repeated Solver runs;
- Dead-End checks;
- continuous timers;
- notification scheduling logic;
- polling.

Avoid unnecessary background work.

---

# 46. Network Efficiency

Review:

- Firebase reads/writes;
- content manifest checks;
- Wallet refreshes;
- Daily refreshes;
- entitlement refreshes.

No per-Move network writes.

---

# 47. Offline Release Matrix

Test with network disabled:

- first previously-bootstrapped launch;
- Home;
- Journey;
- active Attempt;
- Level generation using bundled content;
- gameplay;
- Solver;
- local persistence;
- cached content;
- Wallet cache;
- pending reward;
- cached Daily Challenge if available.

---

# 48. Reconnect Matrix

Test:

- progression sync;
- Wallet queue;
- Daily completion;
- content update;
- entitlements;
- pending monetization operations.

No duplicate effects.

---

# 49. App Lifecycle Tests

Test:

- background during gameplay;
- kill during accepted Move persistence;
- kill during purchase validation;
- kill after rewarded ad completion;
- kill during content download;
- kill during bundle activation;
- resume after long offline period.

---

# 50. Crash-Recovery Tests

Critical:

- Extra Moves charged then crash before +5;
- Dead-End Rescue authorized then crash before recovery;
- Rewarded Extra Moves ad complete then crash;
- IAP callback before crash;
- Level reward queued offline then restart;
- bundle staged before crash.

All must recover idempotently.

---

# 51. Content Hardening

Validate:

- corrupted bundle;
- missing asset;
- invalid hash;
- unsupported schema;
- disabled active item;
- rollback;
- active Attempt on old bundle;
- Daily Challenge pinned to old bundle.

---

# 52. CMS Release Hardening

Test:

- unauthorized publish;
- edit after approval;
- rollback;
- emergency disable;
- audit log;
- concurrency conflict;
- STAGING → PROD immutable promotion.

---

# 53. Arabic RTL QA

Full manual pass for:

- onboarding;
- Tutorial;
- Home;
- Journey;
- Gameplay;
- Result;
- Story;
- Shop;
- Daily;
- Settings;
- account/sync;
- error states;
- CMS Arabic content preview where relevant.

---

# 54. Arabic Text Quality QA

Verify:

- no broken shaping;
- no clipped text;
- no reversed punctuation;
- proper mixed Arabic/number handling;
- proper RTL alignment;
- no hard-coded untranslated English in PROD UI.

---

# 55. Localization QA

Ensure:
- all player-facing strings use localization keys;
- fallback works;
- dynamic content locale handling works;
- store prices remain localized.

---

# 56. Accessibility QA

Baseline:

- semantic labels;
- readable contrast;
- touch target size;
- text scaling;
- screen-reader labels for controls;
- lock state not color-only;
- modal focus order.

Drag-only gameplay remains approved, so do not invent tap-to-auto-move.

Document accessibility limitation if required.

---

# 57. Device Matrix

Validate on representative:

## Android
- min API 26;
- mid-range device;
- modern flagship;
- tablet portrait.

## iOS
- iOS 15 minimum;
- modern iPhone;
- larger iPhone;
- iPad portrait.

Do not assume emulator-only validation is enough.

---

# 58. OS Permission QA

Verify:
- notification permission;
- tracking/consent if applicable;
- network errors;
- store flows;
- sign-in providers.

No permission request should deadlock app.

---

# 59. Ad QA

Validate:

- Rewarded Coins;
- Hint;
- Extra Moves;
- Dead-End Rescue;
- unavailable ad;
- cancelled ad;
- duplicate callback;
- Interstitial cadence;
- guardrails;
- Remove Ads.

Use test IDs/sandbox outside PROD.

---

# 60. IAP QA

Validate store sandbox:

- 1k;
- 3k;
- 7k;
- 15k Coin packs;
- Remove Ads;
- pending;
- cancel;
- duplicate callback;
- restore;
- reinstall.

Real-money production prices remain whatever approved store config defines.

---

# 61. Daily QA

Validate:

- 7-day reward cycle;
- missed-day behavior;
- streak reset;
- 3/7/14/30 milestones;
- Daily Challenge deterministic seed;
- same-board retries;
- first-completion reward;
- timezone change;
- DST;
- quiet hours;
- FCM deep links.

---

# 62. Notification QA

Verify:
- permission handling;
- token registration;
- token refresh;
- Streak Risk logic;
- Daily Challenge reminder;
- quiet hours;
- disabled preferences;
- stale notification.

---

# 63. Analytics QA

Use DebugView/non-PROD validation.

Check:
- no duplicate events;
- event ordering;
- property values;
- versions;
- environment tagging.

---

# 64. Privacy Review

Verify data minimization.

Review:
- Analytics;
- Crashlytics;
- FCM;
- Auth;
- Wallet;
- content logs;
- Admin audit.

Do not send unnecessary personal data.

---

# 65. Legal / Store Readiness Boundary

Prepare required app metadata placeholders/contracts for:

- Privacy Policy;
- Terms if needed;
- ads disclosure;
- IAP products;
- data safety/privacy labels;
- account deletion path readiness where required.

Final legal text must come from approved legal source.

Do not invent binding legal statements.

---

# 66. App Store Readiness

Prepare:

- bundle identifier approved/configured;
- signing;
- provisioning;
- app icons;
- launch assets;
- screenshots;
- Arabic metadata;
- privacy answers;
- IAP products;
- review notes;
- support URL;
- privacy URL.

Exact marketing copy can be separate deliverable.

---

# 67. Google Play Readiness

Prepare:

- application ID;
- signing;
- app bundle;
- store listing;
- screenshots;
- content rating;
- data safety;
- ads declaration;
- IAP products;
- testing tracks.

---

# 68. Build Modes

Ensure:

```text
DEV
TEST
STAGING
PROD
```

produce distinct build configs.

PROD must:
- disable debug menus;
- use production Firebase;
- use production ad IDs;
- use production store product IDs;
- use production content pointer.

---

# 69. Versioning

Define:

```text
appVersion
buildNumber
rulesVersion
solverVersion
generatorVersion
contentBundleVersion
economyConfigVersion
monetizationConfigVersion
```

Expose in diagnostics.

---

# 70. Release Artifact Traceability

Every release build should record:

- git commit;
- build number;
- environment;
- dependency lock hash if practical;
- bundle version;
- backend deployment version.

---

# 71. CI/CD Release Pipeline

Recommended:

```text
PR Validation
  ↓
Merge
  ↓
Build/Test
  ↓
STAGING Deploy
  ↓
Integration Tests
  ↓
Manual Release Approval
  ↓
PROD Backend/Config Deploy
  ↓
Mobile Store Artifact
  ↓
Staged Rollout
```

---

# 72. CI Required Checks

- Dart analyze;
- Flutter analyze;
- unit tests;
- Engine tests;
- Solver Golden Boards;
- Generator tests;
- content validation;
- Firebase rules tests;
- backend tests;
- Angular tests;
- security scans;
- build smoke.

---

# 73. Heavy Validation Jobs

Not every PR should run all expensive tests.

Use:
- nightly/manual/release pipeline for:
  - 10,000+ simulations;
  - heavy Solver benchmarks;
  - full content validation;
  - deeper security checks.

---

# 74. Release Branching

Use project’s existing Git strategy.

Do not invent complex GitFlow if unnecessary.

Release artifacts must map to immutable commit/tag.

---

# 75. Backend Deployment Safety

Deploy:
- rules;
- Functions;
- indexes;
- config

with explicit environment.

No accidental PROD from local default command.

---

# 76. Database / Firestore Migration

Any schema evolution required for release:

- backward compatible where possible;
- tested on STAGING;
- rollback/forward-fix plan.

Do not delete old fields immediately if older app builds may still run.

---

# 77. Client Backward Compatibility

During staged rollout, old and new app versions may coexist.

Backend/content must tolerate supported older client versions.

Use:
- schema versions;
- min app versions;
- feature flags.

---

# 78. Remote Config Hardening

Review:
- defaults;
- PROD values;
- kill switches;
- safe fallback.

Sensitive authoritative values must remain server-controlled.

---

# 79. Feature Kill Switches

At minimum consider:

```text
rewardedAdsEnabled
interstitialEnabled
shopEnabled
dailyEnabled
dailyChallengeEnabled
remoteContentUpdatesEnabled
```

Gameplay core should remain usable if optional systems disabled.

---

# 80. Incident Kill Switch Drill

Test on STAGING:

- disable Interstitials;
- disable Shop;
- disable Daily Challenge;
- freeze remote content updates;
- disable bad content Variant.

Verify clients respond safely.

---

# 81. Release Health Dashboard

Create/define dashboard with:

- crash-free users;
- active users;
- level completion rate;
- level generation failures;
- Solver inconclusive rate;
- Wallet/economy error rate;
- purchase validation success;
- content bundle failure rate;
- Daily error rate.

---

# 82. Launch KPIs Boundary

Do not invent business success targets not approved.

Dashboard should surface metrics.

Targets can be set later.

---

# 83. Operational Runbooks

Required runbooks:

1. crash spike;
2. Wallet/economy incident;
3. purchase validation outage;
4. content rollback;
5. bad Association disable;
6. Firebase outage;
7. auth outage;
8. notification outage;
9. Daily reward issue;
10. app rollback/halt staged rollout.

---

# 84. Content Rollback Runbook

Must include:
- identify bundle;
- pointer rollback;
- disable specific item if needed;
- verify active version;
- monitor telemetry.

---

# 85. Economy Incident Runbook

Must include:
- disable affected utility/Shop if needed;
- inspect idempotency receipts;
- audit Wallet ledger;
- prevent duplicate retries;
- reconcile affected users later through trusted process.

Do not create generic client admin-adjust endpoint.

---

# 86. Purchase Incident Runbook

If store validation fails:
- disable purchase CTA via feature flag if necessary;
- preserve pending transactions;
- retry safely;
- no duplicate grants.

---

# 87. Release Rollback Strategy

Backend/config/content:
- rollback immediately where supported.

Mobile binary:
- staged rollout halt;
- expedited fixed build if needed.

Do not rely on store binary rollback being instant.

---

# 88. Staged Rollout

Recommended:

- small percentage;
- monitor;
- expand gradually.

Exact percentages/timing are operational decisions, not fixed here.

---

# 89. Rollout Monitoring

Before expanding:
- crash-free health acceptable;
- no S0/S1;
- economy stable;
- purchase stable;
- content stable;
- generation/solver metrics stable.

---

# 90. PROD Smoke Test

After deployment/build:

- launch;
- anonymous auth;
- Home;
- Journey;
- one Level;
- Hint;
- Wallet read;
- Daily state;
- content version;
- Rewarded test only if production-safe process exists;
- Shop product load;
- no debug UI.

Avoid destructive real purchase tests unless designated test account/sandbox.

---

# 91. Support Diagnostics

Provide user-safe diagnostic info page/DEV support utility:

```text
appVersion
buildNumber
player support ID
bundleVersion
sync status
```

Do not expose internal tokens.

---

# 92. Support ID

Use non-sensitive support identifier.

Do not expose raw auth token.

UID may be displayed only if support policy approves; otherwise use derived support reference.

---

# 93. Data Backup / Recovery

Firebase-managed services provide underlying durability, but app-specific recovery must include:

- content rollback;
- Wallet ledger audit;
- progression reconciliation;
- export/backup of critical Admin/content metadata where practical.

Document recovery assumptions.

---

# 94. Disaster Recovery Boundary

MVP Firebase-first avoids complex multi-region custom infrastructure.

Document:

- service dependencies;
- expected Firebase/GCP resilience;
- manual recovery procedures;
- content rollback;
- config restoration.

Do not invent multi-cloud DR.

---

# 95. Security Checklist

Required release check:

- [ ] no wildcard Firestore writes;
- [ ] no wildcard Storage writes;
- [ ] wallet client writes denied;
- [ ] entitlement client writes denied;
- [ ] content pointer client writes denied;
- [ ] Admin role checks enforced;
- [ ] tokens not logged;
- [ ] secrets not committed;
- [ ] App Check status reviewed;
- [ ] dependency vulnerabilities reviewed;
- [ ] pen test findings triaged.

---

# 96. Gameplay Checklist

- [ ] all critical Engine tests pass;
- [ ] Undo rules pass;
- [ ] Stock rules pass;
- [ ] completion/win pass;
- [ ] move accounting pass;
- [ ] streak pass;
- [ ] Solver parity pass;
- [ ] Generator reproducibility pass;
- [ ] no accepted unsolvable board.

---

# 97. Economy Checklist

- [ ] initial grant once;
- [ ] Level reward once;
- [ ] Chapter reward once;
- [ ] Hint consume safe;
- [ ] Extra Moves limits;
- [ ] Dead-End rescue limit;
- [ ] no negative Wallet;
- [ ] offline queue safe;
- [ ] crash recovery safe.

---

# 98. Monetization Checklist

- [ ] Rewarded Coins cap;
- [ ] Rewarded Hint;
- [ ] Rewarded Extra Moves;
- [ ] Rewarded Dead-End;
- [ ] Interstitial guardrails;
- [ ] Remove Ads;
- [ ] Coin Packs;
- [ ] restore;
- [ ] server validation;
- [ ] duplicate callback safety.

---

# 99. Daily Checklist

- [ ] 7-day cycle;
- [ ] miss does not reset reward calendar;
- [ ] streak miss resets;
- [ ] milestones;
- [ ] deterministic Challenge;
- [ ] first-completion only;
- [ ] timezone validation;
- [ ] quiet hours;
- [ ] FCM preferences.

---

# 100. Content Checklist

- [ ] bundled fallback;
- [ ] remote update;
- [ ] hash validation;
- [ ] schema validation;
- [ ] rules validation;
- [ ] atomic activation;
- [ ] rollback;
- [ ] emergency disable;
- [ ] human approvals;
- [ ] audit.

---

# 101. Accessibility Checklist

- [ ] semantic labels;
- [ ] text scaling;
- [ ] touch targets;
- [ ] contrast;
- [ ] RTL;
- [ ] modal focus;
- [ ] screen reader labels for key controls.

---

# 102. Store Checklist

- [ ] icon;
- [ ] screenshots;
- [ ] Arabic listing;
- [ ] privacy metadata;
- [ ] support URL;
- [ ] ads declaration;
- [ ] IAP products;
- [ ] rating;
- [ ] signing;
- [ ] PROD build.

---

# 103. Release Candidate

Create:

```text
RC1
```

from immutable commit/tag.

Run full release gate.

If blocker fixed:
- produce RC2.

Do not patch release artifact manually.

---

# 104. Release Candidate Validation

RC must use:
- PROD-like config;
- STAGING backend where appropriate for full test;
- production build mode.

No debug cheats.

---

# 105. Release Gate Report

Generate one release report containing:

```text
build version
commit
test summary
simulation summary
security summary
pen-test summary
performance summary
known issues
content bundle version
backend versions
Go/No-Go
```

---

# 106. Known Issues Policy

Every known issue has:

```text
severity
owner
workaround
release impact
decision
```

S0/S1 cannot be hidden in generic backlog.

---

# 107. Go/No-Go Roles

At minimum technical sign-off should include:

- Engineering;
- QA;
- Product/Owner;
- Security review owner;
- Content/Publisher for production content.

Exact people/assignees not fixed here.

---

# 108. Final Release Gate

Release only if:

```text
S0 = 0
core-path unresolved S1 = 0
critical simulations = pass
security gate = pass
content gate = pass
economy gate = pass
store gate = pass
rollback readiness = pass
```

---

# 109. Release Readiness Status

Recommended:

```text
NotReady
AtRisk
ReadyForRC
ReadyForStagedRollout
ReadyForGeneralAvailability
```

---

# 110. Release Notes

Prepare internal release notes:

- included features;
- known limitations;
- operational caveats;
- versions/config.

Player-facing store release notes can be separate.

---

# 111. Post-Release Monitoring Window

Define heightened monitoring after rollout.

Exact hours/days are operational.

Monitor:
- crashes;
- Wallet;
- purchases;
- content;
- Solver/generation;
- Daily systems;
- auth/sync.

---

# 112. Post-Release Hotfix Criteria

Hotfix candidates:

- S0;
- user data/economy risk;
- widespread S1;
- purchase failure;
- content outage not solvable by rollback/disable.

---

# 113. Suggested Tooling / Docs

Create:

```text
docs/release/
├── RELEASE_CHECKLIST.md
├── GO_NO_GO_TEMPLATE.md
├── INCIDENT_RUNBOOKS.md
├── CONTENT_ROLLBACK_RUNBOOK.md
├── ECONOMY_INCIDENT_RUNBOOK.md
├── PURCHASE_INCIDENT_RUNBOOK.md
├── SECURITY_RELEASE_CHECKLIST.md
└── RELEASE_VALIDATION_REPORT_TEMPLATE.md
```

---

# 114. Suggested CI Workflows

```text
.github/workflows/
├── pr-validation.yml
├── mobile-build.yml
├── backend-test.yml
├── firebase-rules-test.yml
├── admin-test.yml
├── content-validation.yml
├── solver-simulation.yml
├── security-scan.yml
└── release-candidate.yml
```

Use existing repo conventions where possible.

---

# 115. Suggested Monitoring Dashboards

Create logical dashboards for:

## Mobile Health
- crash-free;
- startup;
- app version.

## Gameplay Health
- generation failure;
- Solver inconclusive;
- Level completion.

## Economy
- operation success;
- duplicates;
- insufficient funds;
- ledger failures.

## Monetization
- ad completion;
- purchase validation.

## Content
- bundle activation;
- validation failure;
- rollback.

## Daily
- claim success;
- Challenge load failure;
- notification error.

---

# 116. Suggested Implementation Order

## Step 1
Release-severity triage and blocker audit.

## Step 2
Analytics/Crashlytics validation.

## Step 3
Backend structured logging/metrics.

## Step 4
Alerts and budget alerts.

## Step 5
Security Rules/App Check audit.

## Step 6
Secrets/dependency audit.

## Step 7
Economy/purchase/Admin focused security review.

## Step 8
Engine/Solver/Generator release simulations.

## Step 9
Performance profiling and fixes.

## Step 10
Offline/lifecycle/crash-recovery tests.

## Step 11
Arabic/RTL/accessibility QA.

## Step 12
Store readiness.

## Step 13
CI release workflows.

## Step 14
Runbooks and rollback drills.

## Step 15
RC1 build.

## Step 16
Full release gate.

## Step 17
Fix blockers → RC2 if needed.

## Step 18
Staged rollout.

---

# 117. Suggested Commit Sequence

### Commit 1
```text
chore(observability): validate analytics crashlytics and production diagnostics
```

### Commit 2
```text
chore(monitoring): add backend metrics alerts and budget monitoring
```

### Commit 3
```text
security: harden firebase rules app check and secret handling
```

### Commit 4
```text
test(release): add critical engine solver generator release simulations
```

### Commit 5
```text
perf: profile and optimize startup gameplay solver and generator hot paths
```

### Commit 6
```text
test(reliability): add offline lifecycle and crash recovery coverage
```

### Commit 7
```text
test(ux): add rtl localization accessibility and device matrix validation
```

### Commit 8
```text
chore(release): add app store play store and production build readiness
```

### Commit 9
```text
ci(release): add release candidate and heavy validation workflows
```

### Commit 10
```text
docs(runbooks): add incident rollback security and go-no-go procedures
```

### Commit 11
```text
chore(rc): prepare release candidate validation report
```

---

# 118. Sprint 11 Definition of Done

Sprint 11 is DONE only when:

- [ ] S0 count = 0.
- [ ] unresolved core-path S1 count = 0.
- [ ] Engine/Solver parity passes.
- [ ] no accepted unsolvable board found.
- [ ] 10,000+ critical board simulation gate passes.
- [ ] Generator bounded behavior verified.
- [ ] Solver Inconclusive handling verified.
- [ ] Crashlytics production configuration verified.
- [ ] Analytics critical event validation passes.
- [ ] BigQuery export verified.
- [ ] structured backend logs exist.
- [ ] critical metrics exist.
- [ ] actionable alerts exist.
- [ ] Firebase/GCP budget alerts exist.
- [ ] DEV/TEST/STAGING/PROD separation audited.
- [ ] secrets scan passes.
- [ ] git history secret review completed.
- [ ] Firestore rules security tests pass.
- [ ] Storage rules security tests pass.
- [ ] App Check rollout/hardening reviewed.
- [ ] Functions authorization audit passes.
- [ ] Admin/Publisher security audit passes.
- [ ] dependency vulnerability audit completed.
- [ ] focused pen-test scope executed or formally scheduled with release-blocking findings triaged.
- [ ] Wallet ledger consistency verified.
- [ ] IAP duplicate protection verified.
- [ ] Rewarded duplicate protection verified.
- [ ] content rollback drill passes.
- [ ] emergency content disable drill passes.
- [ ] offline core path passes.
- [ ] reconnect reconciliation passes.
- [ ] lifecycle/crash recovery passes.
- [ ] startup performance measured.
- [ ] gameplay frame performance acceptable.
- [ ] Solver performance measured.
- [ ] Generator performance measured.
- [ ] memory profile reviewed.
- [ ] Arabic RTL QA passes.
- [ ] localization QA passes.
- [ ] accessibility baseline passes.
- [ ] Android min API 26 validation passes.
- [ ] iOS 15 validation passes.
- [ ] phone/tablet portrait matrix passes.
- [ ] ads flows QA passes.
- [ ] IAP sandbox QA passes.
- [ ] Daily/timezone/DST QA passes.
- [ ] notification QA passes.
- [ ] content pipeline QA passes.
- [ ] Admin publishing QA passes.
- [ ] PROD feature flags reviewed.
- [ ] kill switches tested.
- [ ] release dashboards exist.
- [ ] incident runbooks exist.
- [ ] release checklist exists.
- [ ] Go/No-Go template exists.
- [ ] release validation report template exists.
- [ ] RC build is traceable to immutable commit.
- [ ] store artifacts/configuration ready.
- [ ] staged rollout plan documented.
- [ ] rollback/halt plan documented.

---

# 119. Sprint 11 Final Exit Gate — MVP Release

Sprint 11 is the final technical MVP gate.

The MVP is **READY FOR STAGED RELEASE** only when:

1. no S0;
2. no unresolved core-path S1;
3. release simulation gate passes;
4. security gate passes;
5. Wallet/IAP/ad integrity gates pass;
6. content activation/rollback gate passes;
7. Daily systems gate passes;
8. offline path passes;
9. store requirements are complete;
10. operational monitoring/rollback exists;
11. Go/No-Go is explicitly approved.

---

# 120. Cursor Execution Prompt — Sprint 11

Use this after Sprint 10 passes its exit gate:

> Implement **Sprint 11 — Production Hardening, Observability, Security & Release Readiness v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_11_Production_Hardening_Observability_Security_and_Release_Readiness_v1.0.md`
> - latest QA & Automated Validation Specification
> - latest Analytics/KPI Specification
> - latest Backend/Cloud Architecture
> - latest Security-related decisions
> - latest Admin/CMS Specification
> - latest Game Engine/Solver/Generator specifications
> - latest Monetization/Economy/Daily specifications
>
> Treat this sprint as the final technical MVP release gate.
>
> Implement and validate:
>
> - production Analytics;
> - BigQuery export;
> - Crashlytics;
> - structured backend logging;
> - critical metrics/alerts;
> - Firebase/GCP budget alerts;
> - environment separation;
> - secrets/config audit;
> - Firestore/Storage rules audit;
> - App Check hardening;
> - Functions auth/authorization audit;
> - Admin/Publisher security audit;
> - dependency vulnerability review;
> - focused external/manual penetration-test readiness and finding triage;
> - Engine ↔ Solver parity;
> - 10,000+ critical Level/template simulations;
> - accepted-board solvability validation;
> - performance profiling;
> - startup/runtime optimizations;
> - Solver/Generator benchmark review;
> - memory review;
> - offline/reconnect testing;
> - app lifecycle/crash recovery;
> - Arabic RTL QA;
> - localization QA;
> - accessibility baseline;
> - Android API 26+ device matrix;
> - iOS 15+ device matrix;
> - Ad/IAP sandbox validation;
> - Daily/timezone/DST validation;
> - content activation/rollback/disable drills;
> - Admin publishing security/rollback validation;
> - production feature flags/kill switches;
> - release dashboards;
> - incident runbooks;
> - CI release-candidate workflows;
> - App Store/Play Store technical readiness;
> - release checklist;
> - Go/No-Go template;
> - release validation report.
>
> Critical release constraints:
>
> - any S0 blocks release;
> - any unresolved core-path S1 blocks release;
> - any accepted unsolvable board blocks release;
> - any Engine/Solver parity defect blocks release;
> - Wallet/IAP duplicate-grant defects block release;
> - cross-user authorization defect blocks release;
> - remote content must never be able to brick the app;
> - no secret may be committed to source control;
> - no test/sandbox ad or IAP configuration may ship in PROD;
> - no PROD debug tools/cheats;
> - no per-Move cloud writes;
> - do not introduce Kubernetes, Redis, brokers, Azure, .NET, PostgreSQL, Rust, or C++ as part of hardening unless a measured approved blocker explicitly requires it.
>
> Run the full release validation suite and produce a final report.
>
> At completion report:
>
> 1. files created/changed;
> 2. unresolved defects grouped by severity;
> 3. Engine/Solver/Generator validation results;
> 4. 10,000+ simulation results;
> 5. observability/alert coverage;
> 6. Firebase usage/cost findings;
> 7. security audit findings;
> 8. penetration-test findings/status;
> 9. performance benchmarks;
> 10. offline/lifecycle/crash-recovery results;
> 11. RTL/localization/accessibility results;
> 12. monetization/IAP/Daily/content QA results;
> 13. store readiness status;
> 14. release/rollback/runbook status;
> 15. final Go/No-Go recommendation;
> 16. any deviations from this Sprint document and why.

---

# 121. Next Stage

After Sprint 11 passes:

# **MVP Release Candidate → Staged Production Rollout**

Then the next roadmap phase can begin based on production metrics and user feedback.

Post-MVP candidates already deferred include:

- Temporary Events;
- Permanent Packs;
- Leaderboards;
- XP;
- Achievements;
- Badges;
- Collections;
- Lore Collectibles;
- additional Chapters / Arc 2 — Arabian Peninsula;
- deeper LiveOps;
- advanced personalization;
- additional content and difficulty tuning.

These are not part of Sprint 11.

---

**End of Sprint 11 — Production Hardening, Observability, Security & Release Readiness v1**
