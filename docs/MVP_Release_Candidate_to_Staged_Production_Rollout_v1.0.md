# MVP Release Candidate → Staged Production Rollout
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR EXECUTION  
**Stage Type:** Release Candidate / Production Rollout / Launch Operations  
**Depends On:** Sprint 11 — Production Hardening, Observability, Security & Release Readiness v1  
**Primary App:** `apps/mobile`  
**Admin/CMS:** `apps/admin`  
**Cloud:** Firebase / Google Cloud  
**Release Targets:** iOS + Android  
**Release Strategy:** Staged Production Rollout  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Objective

Move the MVP from validated Release Candidate to controlled Production rollout.

This stage covers:

- release candidate freeze;
- final Go/No-Go;
- production backend/config deployment;
- production content activation;
- App Store / Play Store submission;
- staged rollout;
- telemetry monitoring;
- rollback/halt criteria;
- launch incident response;
- post-release validation;
- transition from release mode to normal product operations.

The goal is:

> **Release safely, observe aggressively, expand gradually, and preserve the ability to halt or recover quickly if production behavior differs from staging.**

---

# 2. Entry Criteria

Do not begin Production rollout unless Sprint 11 exit gate is green.

Required:

- S0 = 0.
- unresolved core-path S1 = 0.
- Engine ↔ Solver parity passes.
- no accepted unsolvable board.
- 10,000+ critical board simulation gate passes.
- Wallet/economy integrity passes.
- IAP duplicate protection passes.
- Rewarded Ads idempotency passes.
- Daily systems pass.
- content activation/rollback passes.
- Firebase security tests pass.
- PROD environment audit passes.
- store artifacts are ready.
- rollback and incident runbooks exist.
- explicit Go approval obtained.

---

# 3. Release Candidate Freeze

Create immutable Release Candidate:

```text
RC1
```

Freeze:

- mobile source commit;
- package locks;
- backend functions version;
- Firebase Rules;
- Remote Config defaults;
- production content bundle;
- economy config;
- monetization config;
- Daily config;
- store product IDs.

No untracked edits after RC creation.

Any code/config fix:
- creates new RC.

---

# 4. Release Traceability

Record:

```text
appVersion
buildNumber
gitCommit
gitTag
rulesVersion
solverVersion
generatorVersion
contentBundleVersion
contentHash
backendDeploymentVersion
economyConfigVersion
monetizationConfigVersion
dailyConfigVersion
firebaseProjectId
```

Store in Release Validation Report.

---

# 5. Final Go / No-Go Meeting

Review:

- QA;
- Security;
- Engineering;
- Product;
- Content;
- Production Ops readiness.

Decision:

```text
GO
NO-GO
CONDITIONAL GO
```

Conditional GO must document:
- accepted issue;
- severity;
- mitigation;
- monitoring;
- rollback threshold.

No S0/S1 exception.

---

# 6. Production Deployment Order

Recommended sequence:

```text
1. Verify PROD secrets/config
2. Deploy Firestore/Storage rules
3. Deploy indexes if required
4. Deploy Cloud Functions / Cloud Run
5. Deploy Remote Config defaults/flags
6. Upload immutable production content bundle
7. Activate production bundle pointer
8. Verify Wallet/Daily/Monetization config
9. Verify AdMob production IDs
10. Verify IAP production product IDs
11. Build/sign mobile artifacts
12. Submit/store release
```

Avoid mobile release before required backend compatibility is ready.

---

# 7. Backend Backward Compatibility

Production backend must support:

- currently installed previous supported app version;
- new RC version during staged rollout.

Do not deploy incompatible backend schema before all users update.

---

# 8. Production Content Activation

Before activation:

- all human approvals complete;
- bundle hash verified;
- bundle validation green;
- STAGING smoke passed;
- rollback target known.

Production pointer updates atomically.

---

# 9. Content Rollback Target

Record:

```text
previousStableBundleVersion
previousStableContentHash
```

Verify it remains accessible.

---

# 10. Production Feature Flags

Review before launch:

```text
rewardedCoinsEnabled
rewardedHintEnabled
rewardedExtraMovesEnabled
rewardedDeadEndRescueEnabled
interstitialEnabled
shopEnabled
removeAdsEnabled
dailyEnabled
dailyChallengeEnabled
remoteContentUpdatesEnabled
```

Use conservative launch state where needed.

Do not enable unfinished/deferred features.

---

# 11. Store Submission — iOS

Prepare:

- production archive;
- signing/provisioning;
- App Store Connect build;
- Arabic metadata;
- screenshots;
- privacy information;
- support URL;
- privacy URL;
- IAP products;
- Remove Ads product;
- review notes;
- ad disclosure;
- age/content rating information.

Use phased release if available and appropriate.

---

# 12. Store Submission — Android

Prepare:

- signed AAB;
- Play Console release;
- Arabic listing;
- screenshots;
- Data Safety;
- ads declaration;
- content rating;
- IAP products;
- testing track validation;
- production rollout config.

---

# 13. Store Review Readiness

Review accounts/test flows should allow reviewers to:

- open app;
- start anonymously;
- reach gameplay;
- understand ads/IAP;
- see Restore Purchases if applicable.

Do not rely on hidden developer steps.

---

# 14. Pre-Launch Production Smoke Test

Before rollout expansion, verify with designated production-safe test accounts:

- app launch;
- anonymous auth;
- Home;
- Journey;
- Level generation;
- gameplay;
- Hint;
- progression;
- Wallet read;
- cloud sync;
- Daily state;
- content bundle version;
- Shop catalog;
- Remove Ads entitlement path if safe/testable;
- notifications configuration.

Do not perform uncontrolled real purchases.

---

# 15. Initial Rollout Principle

Start small.

Rollout percentages/timing are operational and not permanently fixed here.

Recommended pattern:

```text
Internal / Closed
  ↓
Small Production %
  ↓
Observe
  ↓
Expand
  ↓
Observe
  ↓
General Availability
```

---

# 16. Suggested Rollout Stages

Example operational structure:

### Stage A — Internal Production Verification
- team/test users only.

### Stage B — Small External Cohort
- minimal percentage.

### Stage C — Expanded Cohort
- larger percentage after health validation.

### Stage D — Broad Rollout
- majority.

### Stage E — General Availability
- full target market release.

Exact percentages require release-time approval.

---

# 17. Geographic Rollout

Do not change approved market rollout strategy silently.

Use staged rollout capabilities without creating new market scope.

---

# 18. Rollout Expansion Gate

Before each expansion, review:

- crash-free users;
- ANR/fatal errors;
- startup failures;
- progression sync;
- Solver/generator issues;
- Wallet errors;
- purchase validation;
- Rewarded Ads;
- content activation;
- Daily errors;
- auth failures.

---

# 19. Launch Health Dashboard

Keep one launch dashboard showing:

## Mobile
- active installs;
- crash-free users;
- fatal crashes;
- app version distribution.

## Gameplay
- attempt starts;
- Level wins;
- generation failures;
- Solver inconclusive;
- Dead-End rate;
- Out-of-Moves rate.

## Economy
- Wallet errors;
- duplicate-operation hits;
- reward grant failures;
- reconciliation failures.

## Monetization
- Rewarded completion/grant rate;
- Interstitial show rate;
- IAP validation success;
- restore success.

## Daily
- Daily Reward claim success;
- Daily Challenge load/complete;
- streak errors.

## Content
- active bundle version;
- bundle download/validation failures;
- rollback/disable events.

---

# 20. Launch Alerting

Critical alerts:

- crash spike;
- startup crash loop;
- auth outage;
- Wallet mutation failure;
- purchase validation failure spike;
- duplicate grant anomaly;
- Firestore permission error spike;
- content activation failure;
- backend function error spike;
- abnormal Firebase spend.

---

# 21. Launch Observation Window

After each rollout expansion:

- hold;
- observe telemetry;
- check support reports;
- review backend logs.

Exact duration is operational.

Do not expand automatically just because time elapsed.

---

# 22. Rollout Halt Conditions

Immediately halt expansion for:

- any S0;
- core-path S1;
- widespread crash regression;
- progression loss;
- cross-user security issue;
- Wallet duplication;
- purchase duplicate grants;
- content bundle breaking Journey;
- widespread auth failure;
- deterministic board defect causing unsolvable accepted Level.

---

# 23. Rollout Rollback Options

Depending on incident:

## Feature issue
Use feature flag/kill switch.

## Bad content
Disable item or rollback content bundle.

## Backend issue
Rollback/forward-fix Functions/Rules/config.

## Mobile issue
Halt staged rollout and prepare hotfix.

Do not assume binary rollback is immediate.

---

# 24. Crash Spike Runbook

1. identify app version;
2. identify affected route/feature;
3. inspect Crashlytics context;
4. disable optional feature if possible;
5. halt rollout if core path affected;
6. create hotfix RC;
7. validate;
8. resume only after health recovers.

---

# 25. Wallet Incident Runbook

If duplication/corruption suspected:

1. halt affected economy feature;
2. disable Shop/rescue if needed;
3. inspect ledger;
4. inspect idempotency receipts;
5. prevent further mutation;
6. reconcile affected Wallets using trusted admin/offline process;
7. document root cause.

Never expose generic balance editing to client.

---

# 26. Purchase Incident Runbook

If purchase validation fails:

- disable purchase CTA via flag if necessary;
- preserve pending transactions;
- do not re-grant blindly;
- reconcile after service recovery;
- protect duplicate transaction IDs.

---

# 27. Content Incident Runbook

If bad content is found:

1. disable specific content where possible;
2. otherwise rollback bundle;
3. verify control pointer;
4. verify clients receive rollback;
5. publish corrected new bundle;
6. close with audit record.

---

# 28. Daily Incident Runbook

If Daily grants misbehave:

- disable Daily claims/challenge reward if needed;
- preserve Journey/gameplay;
- inspect idempotency keys;
- correct backend config;
- reconcile affected players through trusted process.

---

# 29. Auth / Sync Incident Runbook

If cloud auth/sync unavailable:

- keep local gameplay functional;
- show non-blocking offline/sync state;
- pause cloud operations;
- reconcile when service returns.

Do not block gameplay unnecessarily.

---

# 30. Production Data Validation

During rollout sample/check:

- Wallet balances non-negative;
- no duplicate initial grants;
- no duplicate Level reward;
- no duplicate Chapter reward;
- Daily duplicate claims absent;
- purchase transactions unique;
- progression monotonic.

---

# 31. Solver / Generator Production Watch

Track:

- generation failure;
- Solver timeout/inconclusive;
- Dead-End confirmation frequency;
- board fingerprint anomalies;
- content/config version correlations.

Any accepted unsolvable board:
- immediate release-blocking incident.

---

# 32. Board Reproduction Procedure

For gameplay issue gather:

```text
levelDefinitionId
seed
boardFingerprint
rulesVersion
solverVersion
generatorVersion
contentBundleVersion
```

Reproduce locally/CI.

---

# 33. Content Version Correlation

When a gameplay/content issue appears:

compare:
- bundle version;
- Level ID;
- Association Variant IDs.

This allows rapid disable/rollback.

---

# 34. Support Intake

Create support categories:

- gameplay;
- progression;
- purchases;
- ads;
- account/sync;
- Daily;
- content/language;
- technical crash.

Use support ID/diagnostics, not secrets.

---

# 35. Support Diagnostic Payload

Safe fields:

```text
supportId
appVersion
buildNumber
platform
osVersion
contentBundleVersion
syncStatus
currentLevelId
```

Do not include tokens or purchase receipts.

---

# 36. Post-Release Analytics Validation

Confirm PROD data actually arrives for:

- gameplay;
- progression;
- economy;
- monetization;
- Daily;
- content.

Do not assume STAGING validation guarantees PROD config.

---

# 37. Firebase Cost Watch

During staged rollout monitor:

- Firestore reads/writes;
- Functions invocations;
- Storage egress;
- BigQuery usage;
- FCM load.

Look for unexpected chatty patterns.

---

# 38. Cost Anomaly Response

If cost unexpectedly spikes:

1. identify feature;
2. inspect request frequency;
3. disable optional feature if needed;
4. fix polling/listener/query issue;
5. resume.

Do not degrade authoritative economy/security to save cost.

---

# 39. Ads Production Validation

Verify:

- correct production ad unit IDs;
- no test labels/IDs;
- Rewarded callback grants exactly once;
- Interstitial guardrails still active;
- Remove Ads suppresses Interstitials.

---

# 40. IAP Production Validation

Verify store catalog:

- 1k;
- 3k;
- 7k;
- 15k Coin Packs;
- Remove Ads.

Validate:
- localized pricing;
- backend product mapping;
- no unknown product IDs.

---

# 41. Purchase Price Principle

Display price comes from store.

Do not hard-code a real-money price into app business logic.

---

# 42. Daily Production Validation

Check:

- player-local day;
- claim cycle;
- streak;
- challenge seed;
- notification preferences;
- quiet hours.

Monitor timezone-related errors.

---

# 43. Notification Rollout

Notifications may be enabled conservatively after core launch health is stable.

Do not make notification rollout a blocker for gameplay release if infrastructure is healthy and feature flag allows controlled enablement.

---

# 44. Remote Content Rollout

New content after release:

- Draft;
- Review;
- Approval;
- STAGING;
- validation;
- PROD promotion.

Do not bypass pipeline because app is already live.

---

# 45. First Production Bundle

Record:

```text
launchBundleVersion
launchContentHash
```

Treat as rollback anchor.

---

# 46. Production Audit

Audit all launch-day sensitive operations:

- production publish;
- rollback;
- disable;
- config changes;
- role changes.

---

# 47. Hotfix Release Process

Hotfix:

```text
Incident
  ↓
Fix
  ↓
Focused tests
  ↓
Full affected regression
  ↓
New RC
  ↓
Go/No-Go
  ↓
Staged rollout
```

Do not bypass release controls for urgency.

---

# 48. Hotfix Scope Discipline

Only fix:
- release blocker;
- severe regression;
- necessary dependency.

Do not bundle unrelated features into emergency hotfix.

---

# 49. Versioning After Hotfix

Increment:
- build number;
- app version if store policy requires;
- backend deployment version;
- content bundle version if content changed.

---

# 50. General Availability Gate

Move to GA only when:

- no active S0/S1;
- crash health stable;
- economy stable;
- purchases stable;
- content stable;
- Solver/generator metrics stable;
- cloud cost reasonable;
- support volume manageable;
- no unresolved security concern.

---

# 51. GA Definition

General Availability means:

- rollout broadly enabled for intended launch audience;
- normal support/monitoring mode begins;
- release freeze lifted carefully;
- next roadmap planning can start.

---

# 52. Post-Launch Stabilization Period

For the first period after GA:

- prioritize production defects;
- avoid large architecture changes;
- avoid major new systems;
- collect player metrics;
- tune difficulty/content conservatively.

Exact duration is operational.

---

# 53. Metrics to Review Before Post-MVP Work

Review:

- Tutorial completion;
- Level completion;
- Chapter progression;
- restart rate;
- Hint usage;
- Out-of-Moves rate;
- Dead-End rate;
- Daily participation;
- Rewarded engagement;
- purchase conversion;
- content issue reports;
- crash-free health.

Do not infer product decisions from one metric alone.

---

# 54. Difficulty Tuning Loop

Use production data to evaluate:

- Board Difficulty bands;
- Move Limits;
- Generator acceptance;
- Solver metrics;
- Level churn.

Changes go through:
- content/config pipeline;
- validation;
- staged rollout.

---

# 55. Content Quality Loop

Review:

- player reports;
- Arabic clarity;
- semantic disputes;
- overused Associations;
- visual-content quality.

Bad content can be disabled immediately through approved pipeline.

---

# 56. Monetization Tuning Boundary

Do not change:

- Coin prices;
- ad rewards;
- ad cadence;
- IAP product design

without explicit product approval and server/client configuration review.

---

# 57. Daily Tuning Boundary

Notification timing/config may be tuned.

Core approved values remain:

- Daily Reward schedule;
- Daily Challenge 150 Coins;
- Streak milestones;
- quiet hours 22:00–09:00.

Do not silently redesign Daily loop.

---

# 58. Release Documentation

Required:

```text
docs/release/
├── MVP_RELEASE_PLAN.md
├── MVP_RELEASE_CHECKLIST.md
├── MVP_GO_NO_GO.md
├── MVP_ROLLOUT_RUNBOOK.md
├── MVP_ROLLBACK_RUNBOOK.md
├── MVP_LAUNCH_DASHBOARD.md
├── MVP_HOTFIX_PROCESS.md
└── MVP_POST_LAUNCH_REVIEW_TEMPLATE.md
```

---

# 59. Release Checklist — Pre-Submission

- [ ] RC immutable.
- [ ] Go/No-Go complete.
- [ ] PROD backend deployed.
- [ ] PROD rules deployed.
- [ ] PROD Remote Config reviewed.
- [ ] PROD content bundle active.
- [ ] rollback bundle known.
- [ ] AdMob IDs verified.
- [ ] IAP product IDs verified.
- [ ] store metadata complete.
- [ ] signing verified.
- [ ] analytics/Crashlytics enabled.
- [ ] budget alerts enabled.
- [ ] support links valid.
- [ ] privacy/store declarations complete.

---

# 60. Release Checklist — Production Smoke

- [ ] launch works.
- [ ] auth works.
- [ ] Journey loads.
- [ ] Level generates.
- [ ] gameplay works.
- [ ] progression updates.
- [ ] Wallet reads.
- [ ] Daily loads.
- [ ] content version correct.
- [ ] Shop product list loads.
- [ ] no DEV tools visible.
- [ ] no test ad/store config.

---

# 61. Release Checklist — Rollout Expansion

- [ ] crash health stable.
- [ ] no S0/S1.
- [ ] auth errors stable.
- [ ] Wallet errors stable.
- [ ] purchase validation stable.
- [ ] content errors stable.
- [ ] Solver/generation stable.
- [ ] Firebase cost stable.
- [ ] support reports reviewed.

---

# 62. Rollback Checklist

- [ ] halt rollout.
- [ ] disable affected feature if possible.
- [ ] rollback content if applicable.
- [ ] rollback backend/config if applicable.
- [ ] notify internal owners.
- [ ] preserve logs/evidence.
- [ ] create incident record.
- [ ] prepare hotfix RC.
- [ ] verify recovery.

---

# 63. Release Status Model

Use:

```text
RC_READY
SUBMITTED
IN_REVIEW
APPROVED
STAGED_ROLLOUT
ROLLOUT_PAUSED
HOTFIX_IN_PROGRESS
GENERAL_AVAILABILITY
```

---

# 64. Launch Decision Log

For each rollout step record:

```text
timestamp
releaseVersion
rolloutStage
decision
healthSummary
knownIssues
approver
```

---

# 65. Staged Rollout Exit Criteria

Each stage exits only after:

- telemetry reviewed;
- support reviewed;
- blocker check complete;
- decision recorded.

---

# 66. Production Runbook Ownership

Assign operational ownership before rollout for:

- Engineering;
- Backend/Cloud;
- Mobile;
- Content;
- Economy/Monetization;
- Security;
- Support.

Specific assignees remain project-management detail.

---

# 67. After General Availability

Once GA is stable:

1. produce Post-Launch Review;
2. capture defects/lessons;
3. compare estimated vs actual system behavior;
4. prioritize fixes/tuning;
5. decide Post-MVP roadmap.

---

# 68. Post-Launch Review Template

Include:

- release timeline;
- rollout stages;
- crash health;
- major incidents;
- rollback/hotfixes;
- gameplay metrics;
- economy metrics;
- monetization metrics;
- Daily metrics;
- content issues;
- infrastructure cost;
- user feedback;
- technical debt;
- recommended next phase.

---

# 69. Post-MVP Roadmap Boundary

Deferred candidates include:

- Temporary Events;
- Permanent Packs;
- Leaderboards;
- XP;
- Achievements;
- Badges;
- Collections;
- Lore Collectibles;
- Arc 2 — Arabian Peninsula;
- deeper LiveOps.

Do not automatically schedule them before reviewing production data.

---

# 70. Final Definition of Done

The MVP release stage is DONE only when:

- [ ] Release Candidate has passed final gate.
- [ ] iOS/Android production artifacts are approved.
- [ ] backend/config/content production state is verified.
- [ ] production smoke passes.
- [ ] staged rollout begins safely.
- [ ] each rollout expansion is health-reviewed.
- [ ] no active S0/core S1 remains.
- [ ] rollback capability is proven.
- [ ] monitoring/alerts are live.
- [ ] support/incident processes are operational.
- [ ] General Availability is explicitly approved.
- [ ] post-launch review is scheduled/prepared.
- [ ] release traceability is complete.

---

# 71. Cursor Execution Prompt — MVP Release Candidate → Staged Production Rollout

Use after Sprint 11 passes its final exit gate:

> Execute the **MVP Release Candidate → Staged Production Rollout** process for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing or deploying anything, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `MVP_Release_Candidate_to_Staged_Production_Rollout_v1.0.md`
> - `Sprint_11_Production_Hardening_Observability_Security_and_Release_Readiness_v1.0.md`
> - release checklists/runbooks
> - latest production config/version manifests
>
> Treat the selected Release Candidate as immutable.
>
> Execute:
>
> - release traceability;
> - final Go/No-Go;
> - production environment verification;
> - Firebase Rules/Functions/config deployment;
> - production content activation;
> - rollback-target verification;
> - AdMob production configuration verification;
> - IAP product configuration verification;
> - iOS/Android production builds;
> - store submission readiness;
> - production smoke tests;
> - staged rollout;
> - launch dashboard validation;
> - alert validation;
> - rollout expansion health checks;
> - incident/rollback drills where safe;
> - GA readiness review.
>
> Critical constraints:
>
> - do not release with S0;
> - do not release with unresolved core-path S1;
> - do not modify RC artifacts manually;
> - any fix creates a new RC;
> - maintain backend compatibility with supported old app versions during rollout;
> - do not ship DEV tools, test ads, sandbox IAP, or lower-environment Firebase config;
> - do not enable unapproved deferred features;
> - halt rollout immediately for progression loss, Wallet duplication, cross-user security defects, widespread crashes, purchase duplicate grants, or accepted unsolvable boards;
> - prefer feature disable/content rollback/backend rollback before risky emergency changes;
> - preserve complete audit and release traceability.
>
> At completion report:
>
> 1. Release Candidate version/commit;
> 2. production backend/config versions;
> 3. production content bundle/hash;
> 4. store artifact status;
> 5. production smoke results;
> 6. staged rollout stage/status;
> 7. crash/health dashboard summary;
> 8. Wallet/purchase/content/Daily health;
> 9. Firebase cost observations;
> 10. support/incident findings;
> 11. any rollout pauses/rollbacks/hotfixes;
> 12. unresolved issues by severity;
> 13. General Availability recommendation;
> 14. any deviations from the release plan and why.

---

# 72. Final Stage

After successful staged rollout and explicit approval:

# **MVP General Availability**

Then begin:

# **Post-Launch Stabilization & Production Metrics Review**

Only after that review should the next Post-MVP roadmap be locked.

---

**End of MVP Release Candidate → Staged Production Rollout**
