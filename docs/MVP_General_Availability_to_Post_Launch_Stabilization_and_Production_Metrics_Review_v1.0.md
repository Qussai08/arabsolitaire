# MVP General Availability → Post-Launch Stabilization & Production Metrics Review
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR EXECUTION  
**Stage Type:** General Availability / Stabilization / Production Review / Roadmap Input  
**Depends On:** MVP Release Candidate → Staged Production Rollout v1  
**Primary App:** `apps/mobile`  
**Admin/CMS:** `apps/admin`  
**Cloud:** Firebase / Google Cloud  
**Analytics:** Firebase Analytics + BigQuery  
**Operations:** Crashlytics + Firebase/GCP Logs/Monitoring  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Objective

Operate the MVP after General Availability in a disciplined stabilization period and turn production evidence into the next product/technical roadmap.

This stage must:

- verify real-world stability;
- identify launch regressions;
- monitor gameplay health;
- validate Solver/Generator behavior in production;
- review player progression;
- review economy balance;
- review monetization behavior;
- review Daily engagement;
- review content quality;
- review retention and funnel behavior;
- review cloud cost;
- review support incidents;
- prioritize fixes;
- separate bugs from tuning opportunities;
- produce a structured Post-Launch Review;
- create the evidence base for Post-MVP roadmap decisions.

The goal is:

> **Stabilize first, understand real behavior second, and only then lock the next roadmap.**

---

# 2. Entry Criteria

Begin this stage only after:

- MVP is in General Availability;
- staged rollout completed or broad rollout explicitly approved;
- launch dashboard is live;
- critical alerts are live;
- incident runbooks are operational;
- release traceability is complete;
- no active S0/core S1 remains unresolved.

---

# 3. Core Principle

During stabilization:

```text
Production Stability
    >
Product Tuning
    >
New Features
```

Do not rush into Post-MVP feature implementation while core launch health is still uncertain.

---

# 4. Stabilization Priorities

Priority order:

1. Security / data integrity
2. Crash / startup stability
3. Gameplay correctness
4. Wallet / IAP / monetization correctness
5. Progression / sync integrity
6. Content correctness
7. Daily system correctness
8. Performance
9. UX friction
10. Product tuning
11. New features

---

# 5. Stabilization Severity Model

Continue using:

```text
S0 — Blocker
S1 — Critical
S2 — Major
S3 — Minor
S4 — Trivial
```

Production hotfix policy:

- S0 → immediate incident response.
- Core-path S1 → urgent hotfix/feature disable.
- S2 → stabilization backlog priority.
- S3/S4 → normal backlog.

---

# 6. Stabilization Window

The exact duration is operational and should not be hard-coded permanently.

Recommended structure:

```text
Phase A — Launch Watch
Phase B — Stabilization
Phase C — Metrics Review
Phase D — Roadmap Decision
```

Do not declare stabilization complete based only on elapsed time.

---

# 7. Phase A — Launch Watch

Focus:

- crash spikes;
- auth failures;
- Wallet failures;
- purchase validation;
- content failures;
- Daily failures;
- Solver/Generator anomalies;
- support reports.

No major tuning during active incident investigation.

---

# 8. Phase B — Stabilization

Focus:

- bug fixes;
- reliability improvements;
- performance fixes;
- content corrections;
- config fixes;
- incident prevention.

Prefer:
- Remote Config;
- content disable/rollback;
- backend fixes;
- small hotfixes

before large mobile changes where appropriate.

---

# 9. Phase C — Metrics Review

Once production health is stable:

Review:

- acquisition funnel;
- onboarding;
- tutorial;
- progression;
- gameplay difficulty;
- retention;
- economy;
- monetization;
- Daily;
- content;
- performance;
- cloud cost;
- support sentiment.

Do not use one isolated metric to justify roadmap changes.

---

# 10. Phase D — Roadmap Decision

Only after evidence review:

- identify validated product opportunities;
- identify technical debt;
- identify content priorities;
- identify operational needs;
- rank Post-MVP initiatives;
- approve next sprint/phase explicitly.

---

# 11. Production Health Dashboard

Maintain one primary dashboard grouped by:

## Reliability
- crash-free users;
- fatal crash count;
- ANRs where available;
- startup failures;
- backend error rate.

## Gameplay
- attempts started;
- levels completed;
- restarts;
- dead ends;
- out-of-moves;
- Solver inconclusive;
- generation failure.

## Progression
- Tutorial completion;
- Level progression;
- Chapter completion;
- sync errors.

## Economy
- Wallet operation success;
- grants;
- spends;
- reconciliation errors.

## Monetization
- Rewarded usage;
- Interstitials;
- IAP validation;
- purchase restore.

## Daily
- Daily Reward;
- Daily Challenge;
- Streak.

## Content
- bundle version;
- validation failures;
- disabled content;
- player reports.

## Cost
- Firestore;
- Functions;
- Storage;
- BigQuery;
- egress.

---

# 12. Reliability Review

Track:

- crash-free users;
- crash-free sessions;
- top crash signatures;
- crashes by app version;
- crashes by device/OS;
- crashes by content bundle;
- crashes by Level ID.

Any crash correlated strongly with:
- one bundle;
- one Level;
- one device class

must be investigated immediately.

---

# 13. Startup Review

Track:

- cold-start failures;
- auth bootstrap failures;
- content load failures;
- Drift migration failures;
- time-to-usable Home.

Goal:
- identify production-only startup bottlenecks.

Do not invent fixed performance threshold without measured baseline.

---

# 14. Gameplay Funnel

Track:

```text
App Open
  ↓
Home
  ↓
Journey
  ↓
Level Start
  ↓
Level Completion
  ↓
Next Level
```

Look for abnormal drop-off between steps.

---

# 15. Tutorial Funnel

Measure:

- onboarding started;
- onboarding completed;
- Tutorial started;
- Tutorial completed;
- Tutorial abandonment step.

Use this to identify confusing mechanics.

Do not immediately simplify core rules without review.

---

# 16. Tutorial Step Analysis

Review drop-off at:

- stacking;
- Association Card;
- Slot;
- Stock;
- Restore;
- Undo;
- Hint.

If one step causes disproportionate abandonment:
- inspect UX/copy first;
- inspect mechanic comprehension second.

---

# 17. Level Completion Analysis

For every Level / template:

Track:

- attempts;
- completion rate;
- restart rate;
- average Moves remaining;
- Hint use;
- Extra Moves use;
- Dead-End frequency;
- Out-of-Moves frequency.

---

# 18. Board Difficulty Review

Compare production outcomes against intended Board Difficulty.

Signals:

- Solver score;
- found solution length;
- Move Limit ratio;
- retry behavior;
- player completion.

Look for:
- boards technically solvable but frustrating;
- boards too trivial;
- mismatch between expected and actual.

---

# 19. Semantic Difficulty Review

Separate from Board Difficulty.

Track player reports around:

- unclear clue;
- ambiguous association;
- culturally disputed meaning;
- difficult vocabulary;
- image ambiguity.

Do not blend semantic difficulty into Solver score.

---

# 20. Solver Production Health

Monitor:

- Hint latency;
- Hint Inconclusive rate;
- Dead-End evaluation latency;
- Dead-End Inconclusive rate;
- Solver node count;
- extreme outliers.

Any false Dead-End report:
- critical defect.

---

# 21. Generator Production Health

Monitor:

- generation attempts per accepted board;
- generation latency;
- candidate rejection causes;
- Solver inconclusive during generation;
- Level config correlations.

If one config repeatedly fails:
- disable/tune content/config through pipeline.

---

# 22. Accepted Unsolvable Board Incident

If any accepted unsolvable board is confirmed:

1. classify as release-critical production incident;
2. identify Level/config/bundle;
3. disable affected content/config;
4. reproduce via seed/fingerprint;
5. fix Generator/Solver/validation;
6. re-run release simulations;
7. publish corrected content/config.

---

# 23. Dead-End Review

Track:

- confirmed Dead-End rate;
- rescue usage;
- restart after Dead-End;
- false-positive reports;
- Solver Inconclusive.

High Dead-End rate may indicate:
- difficulty too high;
- board design issue;
- player understanding issue.

Do not automatically reduce difficulty without diagnosis.

---

# 24. Out-of-Moves Review

Track:

- frequency;
- Level distribution;
- first vs repeat Attempts;
- Extra Moves purchase/ad usage.

Use to evaluate:
- Move Limits;
- board difficulty;
- monetization pressure.

Avoid tuning difficulty purely to increase monetization.

---

# 25. Hint Review

Track:

- Hint request rate;
- Hint success;
- Hint Inconclusive;
- Hint inventory depletion;
- Coin Hint purchase;
- Rewarded Hint usage.

Look for over-reliance on Hint as UX symptom.

---

# 26. Correct Move Streak Review

Track:

- streak tier attainment;
- streak Coin contribution;
- invalid action reset frequency.

Use for balance review.

Do not alter approved thresholds without explicit decision.

---

# 27. Economy Review

Monitor:

- average Coin balance;
- median Coin balance;
- Coin earn sources;
- Coin spend sinks;
- Hint inventory;
- Extra Moves spending;
- Dead-End Rescue spending.

Avoid relying only on averages.

Use distributions.

---

# 28. Economy Source/Sink Analysis

Coin sources:

- initial 300;
- Level rewards;
- Chapter rewards;
- Daily Rewards;
- Daily Challenge;
- Streak milestones;
- Rewarded Coins;
- IAP Coin packs.

Coin sinks:

- Hint purchase;
- Extra Moves;
- Dead-End Rescue.

Review whether economy is:
- inflationary;
- too restrictive;
- balanced.

---

# 29. Economy Integrity Review

Check:

- duplicate grants;
- negative balance attempts;
- rejected offline spends;
- reconciliation failures;
- ledger inconsistencies.

Any integrity defect:
- production incident.

---

# 30. Wallet Ledger Audit

Run periodic audit:

```text
wallet state
vs
transaction ledger
```

Check sample or full population depending scale/cost.

---

# 31. Monetization Review

Track separately:

## Rewarded Ads
- offer shown;
- started;
- completed;
- reward grant;
- failures.

## Interstitials
- eligible;
- shown;
- blocked by guardrail;
- session cap.

## IAP
- product view;
- purchase start;
- validation success;
- restore.

---

# 32. Rewarded Ads Review

Review usage for:

- Coins;
- Hint;
- Extra Moves;
- Dead-End Rescue.

Watch:
- ad unavailability;
- backend reward failures;
- repeated ad usage around difficult Levels.

---

# 33. Interstitial Review

Validate guardrails are working in production.

Check:
- Interstitial after Rewarded Ad = should not happen.
- after purchase = should not happen.
- after Tutorial = should not happen.
- after failure/Dead-End/Out-of-Moves decline = should not happen.

Any violation:
- fix policy.

---

# 34. Remove Ads Review

Check:

- entitlement activation;
- restore;
- Interstitial suppression;
- Rewarded Ads availability.

Do not interpret entitlement user as “all ads disabled”.

---

# 35. IAP Review

Track by pack:

- 1k;
- 3k;
- 7k;
- 15k;
- Remove Ads.

Review:
- conversion;
- validation failure;
- duplicate callbacks;
- refund/revocation incidents.

Do not change real-money prices without approval.

---

# 36. Daily Reward Review

Track:

- view rate;
- claim rate;
- calendar Day distribution;
- failures;
- duplicate claim attempts.

Verify missed-day behavior remains correct.

---

# 37. Daily Streak Review

Track:

- streak length distribution;
- 3/7/14/30 milestone reach;
- Streak Risk notification effectiveness;
- break frequency.

Do not redesign milestone rewards without explicit review.

---

# 38. Daily Challenge Review

Track:

- opens;
- starts;
- retries;
- completion;
- first-completion reward;
- board generation issues;
- day/timezone issues.

---

# 39. Daily Challenge Difficulty

Compare:
- completion rate;
- retries;
- Solver metrics;
- Main Journey difficulty.

Daily should be engaging, not accidentally impossible.

---

# 40. Notification Review

Track:

- permission opt-in;
- Daily Challenge notification sends;
- Streak Risk sends;
- opens;
- quiet-hour compliance;
- stale token failures.

Avoid over-notification.

---

# 41. Timezone Review

Monitor:

- timezone changes;
- suspicious rapid changes;
- Daily claim rejections;
- legitimate travel edge cases.

Tune abuse safeguards carefully.

---

# 42. Retention Review

Review standard cohorts:

- next-day;
- multi-day;
- weekly.

Exact retention target is not predefined.

Compare:
- Tutorial completers;
- Daily participants;
- Chapter progress;
- Hint/Rewarded users.

Use as signals, not absolute truth.

---

# 43. Cohort Analysis

Useful cohorts:

- install date;
- app version;
- country/market;
- content bundle;
- Tutorial completed/not;
- Daily participant/not;
- payer/non-payer;
- Remove Ads owner/non-owner.

Avoid over-segmentation early.

---

# 44. Chapter Progression Review

Track:

- Cairo completion;
- Alexandria unlock/completion;
- Beirut;
- Marrakech;
- Dubai.

Look for steep drop-offs.

Inspect:
- Level difficulty;
- semantic content;
- story flow;
- engagement.

---

# 45. Story Review

Track:

- Story Beat viewed;
- skipped;
- archive replay;
- Chapter completion correlation.

Do not overinterpret high skip rate without qualitative review.

---

# 46. Content Quality Review

Sources:

- player “Report a problem”;
- support tickets;
- content QA;
- social/app-store feedback.

Categorize:
- semantic error;
- typo;
- unclear clue;
- inappropriate image;
- duplicate/repetition;
- narrative issue.

---

# 47. Content Incident SLA Boundary

Severe semantic/factual issues:
- emergency disable if necessary.

Minor copy:
- next bundle.

Exact SLA targets remain operational.

---

# 48. Association Reuse Review

Check real Journey content for:

- clue reuse cooldown;
- Variant repetition;
- content fatigue.

Even valid rules may still feel repetitive.

---

# 49. Visual Content Review

Check:
- image readability;
- device scaling;
- ambiguity;
- load performance;
- asset size.

---

# 50. Arabic Quality Review

Inspect production reports for:

- grammar;
- spelling;
- diacritics where relevant;
- phrasing;
- ambiguity;
- RTL layout.

Use human review.

---

# 51. Performance Review

Track:

- startup;
- gameplay frame performance;
- Solver latency;
- Generator latency;
- content download;
- app memory;
- backend latency.

Compare by:
- device class;
- OS;
- app version.

---

# 52. Low-End Device Review

Pay special attention to:
- Android API 26 class devices;
- lower memory;
- slower CPU.

Do not optimize only for flagship phones.

---

# 53. Battery Review

Watch for:
- excessive background work;
- repeated Solver calls;
- polling;
- notifications scheduling bugs.

---

# 54. Network Review

Track:
- sync retries;
- Firestore failures;
- content downloads;
- Wallet retries.

Offline-first design should reduce user impact.

---

# 55. Cloud Cost Review

Review:

- Firestore reads/writes;
- Functions;
- Storage;
- BigQuery;
- egress;
- Crashlytics/Analytics overhead.

Break down by feature where possible.

---

# 56. Cost Per Active User

Compute internal operational metric if useful:

```text
monthly cloud cost / active users
```

Do not hard-code target until real data exists.

---

# 57. Cost Anomaly Investigation

Look for:
- unnecessary listeners;
- duplicate sync;
- excessive content checks;
- repeated Wallet reads;
- repeated Daily fetch;
- expensive BigQuery queries.

---

# 58. Support Review

Weekly/periodic review:

- ticket volume;
- top categories;
- unresolved critical issues;
- app-store reviews;
- repeated confusion.

---

# 59. App Store Review Mining

Categorize reviews:

- crash;
- ads;
- difficulty;
- Arabic/content;
- purchase;
- progression;
- UX.

Do not react to one isolated review.

---

# 60. Production Bug Backlog

Every bug:

```text
severity
frequency
affectedVersions
affectedUsers
reproduction
workaround
fixVersion
```

Prioritize by:
- severity;
- frequency;
- user impact.

---

# 61. Stabilization Hotfix Rule

A hotfix should fix:

- production defect;
- severe performance issue;
- security issue;
- data integrity issue.

Do not mix in unrelated roadmap features.

---

# 62. Config Tuning Rule

Remote Config/content config changes can tune:
- feature availability;
- Interstitial cadence;
- notifications timing;
- content activation.

Do not use config to bypass approval for core product rules.

---

# 63. Difficulty Tuning Workflow

If tuning required:

```text
Production Evidence
  ↓
Proposed Change
  ↓
Product Approval
  ↓
Content/Level Config Change
  ↓
Solver/Simulation Validation
  ↓
STAGING
  ↓
Production Rollout
```

---

# 64. Economy Tuning Workflow

For any proposed change to:

- Hint price;
- Extra Moves prices;
- Dead-End Rescue price;
- Coin rewards;
- Daily reward values;
- ad reward values;

require explicit product approval.

Do not auto-tune.

---

# 65. Monetization Tuning Workflow

For:

- Interstitial cadence;
- rewarded placement;
- IAP pack structure;
- Remove Ads positioning;

use production data but require explicit approval before permanent change.

---

# 66. Notification Tuning Workflow

Can tune:
- send timing;
- copy;
- enablement.

Must retain:
- quiet hours;
- preferences;
- safe rate.

---

# 67. Content Tuning Workflow

Can:
- disable bad content;
- replace weak Association;
- rebalance Level content;
- polish Story copy.

Must pass:
- human review;
- technical validation;
- publishing pipeline.

---

# 68. Security Monitoring

Continue reviewing:

- auth anomalies;
- cross-user denied attempts;
- malformed economy requests;
- purchase validation abuse;
- timezone abuse;
- admin publish attempts.

---

# 69. Fraud / Abuse Review

Look for:

- impossible reward frequency;
- repeated malformed Wallet operations;
- replay farming attempts;
- Daily timezone farming;
- forged purchase attempts.

Do not build complex anti-fraud system unless evidence supports need.

---

# 70. App Check Review

Monitor rejection/legitimate failure rate.

If enforcement blocks legitimate traffic:
- investigate configuration;
- do not disable security blindly.

---

# 71. Content Disable Review

Monitor emergency disable usage.

Frequent disables may indicate:
- weak review;
- insufficient validation;
- content workflow problem.

---

# 72. Admin/CMS Review

Track operational pain:

- approval bottlenecks;
- validation false positives;
- publish errors;
- rollback usability.

Do not redesign CMS before observing real operator workflow.

---

# 73. Publishing Lead Time

Measure:

```text
Draft → Approved → STAGING → PROD
```

Use to improve content operations.

---

# 74. Release Process Review

After launch, evaluate:

- RC friction;
- store submission issues;
- missing checks;
- rollout delays;
- runbook usefulness.

Update release documentation.

---

# 75. Post-Launch Review Cadence

Recommended:

- frequent during launch watch;
- then regular stabilization reviews;
- then formal Post-Launch Review.

Exact cadence is operational.

---

# 76. Formal Post-Launch Review

Produce one artifact containing:

1. Executive Summary
2. Release Timeline
3. Production Stability
4. Gameplay Metrics
5. Progression
6. Difficulty
7. Economy
8. Monetization
9. Daily Systems
10. Content Quality
11. Performance
12. Security
13. Cloud Cost
14. Support/User Feedback
15. Incidents
16. Technical Debt
17. Product Opportunities
18. Recommended Next Phase

---

# 77. Executive Summary

Answer:

- Is MVP stable?
- Are players progressing?
- Are any systems underperforming technically?
- What are the biggest product frictions?
- What are the biggest operational risks?
- What should be fixed before new features?

---

# 78. Release Timeline Section

Document:

- RC date;
- store approval;
- rollout stages;
- GA date;
- hotfixes;
- incidents;
- content rollbacks.

---

# 79. Stability Section

Include:

- crash trends;
- backend error trends;
- auth/sync;
- critical incidents;
- unresolved defects.

---

# 80. Gameplay Section

Include:

- attempts;
- completion;
- restarts;
- Dead-End;
- Out-of-Moves;
- Hint;
- Undo;
- Solver metrics;
- Generator metrics.

---

# 81. Progression Section

Include:

- Tutorial completion;
- Levels reached;
- Chapter completion;
- progression drop-off;
- sync issues.

---

# 82. Difficulty Section

Include:

- Board Difficulty;
- Semantic Difficulty;
- problem Levels;
- Move Limit issues;
- Daily Challenge difficulty.

---

# 83. Economy Section

Include:

- Coin balances;
- source/sink;
- Hint use;
- Extra Moves;
- Dead-End Rescue;
- integrity errors.

---

# 84. Monetization Section

Include:

- Rewarded;
- Interstitial;
- IAP;
- Remove Ads;
- purchase failures.

Commercial interpretation should be careful with small samples.

---

# 85. Daily Section

Include:

- Daily Reward;
- Streak;
- Challenge;
- notifications;
- timezone issues.

---

# 86. Content Section

Include:

- reported Associations;
- disabled content;
- story skip/replay;
- Arabic quality;
- bundle incidents.

---

# 87. Performance Section

Include:

- startup;
- frame performance;
- Solver;
- Generator;
- memory;
- backend latency.

---

# 88. Security Section

Include:

- security incidents;
- App Check;
- rules denials;
- abuse patterns;
- pen-test follow-up.

---

# 89. Cloud Cost Section

Include:

- total cost;
- major services;
- per-active-user directional metric;
- anomalies;
- optimization candidates.

---

# 90. Support Section

Include:

- ticket categories;
- top complaints;
- repeated confusion;
- app-store feedback.

---

# 91. Incident Section

For each meaningful incident:

```text
date
severity
impact
root cause
mitigation
permanent fix
prevention
```

---

# 92. Technical Debt Section

Rank by:

```text
risk
impact
effort
urgency
```

Do not treat all cleanup as equal priority.

---

# 93. Product Opportunities Section

Only include opportunities supported by:

- metrics;
- support feedback;
- user behavior;
- operational evidence.

Mark:
- hypothesis;
- evidence;
- expected benefit;
- risk.

---

# 94. Post-MVP Candidate Evaluation

Existing deferred candidates:

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

Evaluate them against real production evidence.

Do not assume all should be built.

---

# 95. Candidate Scoring Framework

Recommended criteria:

```text
Player Value
Retention Potential
Revenue Potential
Strategic Fit
Technical Risk
Operational Cost
Content Cost
Implementation Effort
Evidence Strength
```

No automatic scoring weights unless approved.

---

# 96. Arc 2 Decision Boundary

Arc 2 direction is approved:

```text
Arabian Peninsula
```

Exact cities/order remain open.

Do not lock them in this review without explicit approval.

---

# 97. Events Decision Boundary

Temporary Events remain Post-MVP.

Before prioritizing:
- confirm Daily/core retention is stable;
- confirm content operations can support event cadence.

---

# 98. Leaderboard Decision Boundary

Leaderboards remain Post-MVP.

Do not prioritize without:
- anti-cheat readiness;
- meaningful competitive metric;
- player demand.

---

# 99. XP / Achievements Decision Boundary

Do not add simply to create more meta systems.

Evaluate whether current Journey/Daily loop lacks long-term motivation.

---

# 100. Collections / Lore Decision Boundary

Evaluate:
- Story engagement;
- content appetite;
- Chapter completion.

Lore Collectibles may make sense if narrative engagement is strong.

---

# 101. Permanent Packs Decision Boundary

Evaluate:
- content consumption rate;
- willingness to replay;
- monetization behavior;
- content production capacity.

---

# 102. Technical Optimization Decision Boundary

Only introduce deeper optimization when measured.

Examples:
- native Solver optimization;
- backend fallback generation;
- extra caching.

No speculative Rust/C++ rewrite.

---

# 103. Production Architecture Review

Review whether Firebase-first assumptions held:

- cost;
- reliability;
- complexity;
- scale.

Do not migrate architecture without evidence.

---

# 104. Cloud Fallback Criteria

Only consider ASP.NET Core/PostgreSQL fallback if measured need appears, such as:

- complex authoritative backend needs;
- query limitations;
- cost/performance problems.

Not default.

---

# 105. Post-Launch Data Quality Review

Check:

- duplicate analytics;
- missing events;
- invalid properties;
- event version drift.

Metrics are only useful if instrumentation is trustworthy.

---

# 106. Analytics Governance

Document:

```text
event owner
event definition
properties
version
privacy classification
```

Avoid ungoverned event explosion.

---

# 107. Experimentation Boundary

Do not start broad A/B testing until:

- baseline metrics stable;
- instrumentation trusted;
- experiment question clear.

Remote Config can support later experiments.

---

# 108. Roadmap Output

The formal review should produce:

```text
P0 — Production Fixes
P1 — Stability / UX Improvements
P2 — Content / Balance Improvements
P3 — Post-MVP Feature Candidates
P4 — Technical Investments
```

---

# 109. P0 Definition

P0 includes:

- security;
- data loss;
- economy integrity;
- crash loops;
- unsolvable accepted boards;
- purchase integrity;
- progression corruption.

---

# 110. P1 Definition

Examples:

- high-friction Tutorial;
- poor performance;
- common UI confusion;
- high Hint Inconclusive;
- notification issue.

---

# 111. P2 Definition

Examples:

- content clarity;
- Level difficulty;
- weak associations;
- story pacing;
- Daily Challenge tuning.

---

# 112. P3 Definition

Examples:

- Events;
- Packs;
- Leaderboards;
- Collections;
- Arc 2;
- XP.

Requires approval.

---

# 113. P4 Definition

Examples:

- Solver optimization;
- build pipeline improvements;
- CMS usability;
- monitoring improvements;
- technical debt.

---

# 114. Stabilization Completion Criteria

Stabilization is complete only when:

- no active S0;
- no unresolved core-path S1;
- production metrics are trustworthy;
- crash/runtime health stable;
- Wallet/IAP integrity stable;
- content pipeline stable;
- Daily stable;
- major launch incidents closed;
- P0 backlog clear;
- Post-Launch Review completed.

---

# 115. Post-Launch Review Definition of Done

- [ ] production stability reviewed.
- [ ] gameplay funnel reviewed.
- [ ] Tutorial reviewed.
- [ ] Board Difficulty reviewed.
- [ ] Semantic Difficulty reviewed.
- [ ] Solver/Generator reviewed.
- [ ] progression reviewed.
- [ ] economy source/sink reviewed.
- [ ] monetization reviewed.
- [ ] Daily reviewed.
- [ ] content reviewed.
- [ ] performance reviewed.
- [ ] security reviewed.
- [ ] cloud cost reviewed.
- [ ] support feedback reviewed.
- [ ] incidents documented.
- [ ] technical debt ranked.
- [ ] product opportunities ranked.
- [ ] Post-MVP candidates evaluated.
- [ ] no new roadmap locked without approval.

---

# 116. Cursor Execution Prompt — Post-Launch Stabilization & Metrics Review

Use after MVP General Availability:

> Execute the **Post-Launch Stabilization & Production Metrics Review** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code or product configuration, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `MVP_General_Availability_to_Post_Launch_Stabilization_and_Production_Metrics_Review_v1.0.md`
> - latest release report
> - latest incident/runbook documents
> - latest Analytics/KPI specification
> - latest Game Economy / Monetization / Daily / Content specifications
>
> Treat this stage as production stabilization and evidence gathering, not feature expansion.
>
> Analyze and report:
>
> - crash/runtime stability;
> - startup;
> - gameplay funnel;
> - Tutorial funnel;
> - Level completion/restart/dead-end/out-of-moves;
> - Hint/Undo behavior;
> - Solver latency/inconclusive;
> - Generator acceptance/latency;
> - progression and Chapter drop-off;
> - Board Difficulty;
> - Semantic Difficulty/content reports;
> - Wallet integrity;
> - Coin sources/sinks;
> - Hint/Extra Moves/Dead-End Rescue usage;
> - Rewarded/Interstitial behavior;
> - IAP validation/restore;
> - Daily Reward/Streak/Challenge;
> - notifications;
> - content bundle health;
> - Arabic/content quality;
> - performance;
> - security/abuse signals;
> - Firebase/GCP cost;
> - support/app-store feedback.
>
> Critical constraints:
>
> - fix S0/S1 before pursuing new features;
> - do not change approved economy values without explicit approval;
> - do not change gameplay rules without explicit approval;
> - do not lock Arc 2 cities/order;
> - do not automatically start Events, Leaderboards, XP, Packs, Collections, or Arc 2;
> - any accepted unsolvable board remains a release-critical production incident;
> - any Wallet/IAP integrity issue is production-critical;
> - use production evidence to propose, not silently decide, roadmap changes;
> - keep Board Difficulty and Semantic Difficulty separate;
> - preserve Firebase-first architecture unless measured evidence justifies reconsideration.
>
> Produce:
>
> 1. Executive Summary;
> 2. stability findings;
> 3. gameplay funnel;
> 4. progression findings;
> 5. Solver/Generator findings;
> 6. economy findings;
> 7. monetization findings;
> 8. Daily findings;
> 9. content/story findings;
> 10. performance findings;
> 11. security findings;
> 12. cloud-cost findings;
> 13. support/user feedback;
> 14. incident summary;
> 15. technical debt;
> 16. product opportunities;
> 17. ranked P0–P4 recommendations;
> 18. unresolved decisions requiring Product Owner approval.
>
> Do not begin implementation of Post-MVP candidates until explicitly approved.

---

# 117. Next Decision Point

After the formal Post-Launch Review:

# **Post-MVP Roadmap Prioritization & Phase 2 Planning**

Possible candidate areas:

- stabilization fixes;
- UX improvements;
- difficulty/content tuning;
- Temporary Events;
- Permanent Packs;
- Leaderboards;
- XP/Achievements;
- Collections/Lore;
- Arc 2 — Arabian Peninsula;
- deeper LiveOps;
- technical optimization.

The next phase must be selected from production evidence and explicit approval.

---

**End of MVP General Availability → Post-Launch Stabilization & Production Metrics Review**
