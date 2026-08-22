# Post-Launch Operations — سوليتير العرب: أسطورة المعاني

**Authoritative spec:** `MVP_General_Availability_to_Post_Launch_Stabilization_and_Production_Metrics_Review_v1.0.md`

---

## Phase A — Launch Watch

**Entry:** GA live, dashboard operational, no active S0/core S1.

**Monitoring focus:**
- Crashes (Crashlytics — crash-free users).
- Auth (login, anonymous, account linking conflicts).
- Wallet (operation failures, balance drift).
- Purchases (validation success, duplicate callbacks).
- Content (bundle activation, validation failures, rollback count).
- Daily systems (reward claim, streak, challenge completion).
- Solver / Generator (inconclusive rate, level win rate).
- Player support tickets (unexpected volume).

**Decision rule:** No major tuning mid-incident. Stabilize first.

**Hotfix criteria (during Launch Watch):**
- S0: immediate.
- Widespread S1: urgent / disable.
- Economy / IAP integrity: immediate.
- Content outage not solved by rollback/disable: expedited fix.

---

## Phase B — Stabilization

**Entry:** Crash-free stable, no active S0, initial data trustworthy.

**Focus:**
- Bug / reliability fixes.
- Prefer: Remote Config, content disable/rollback, backend function fix, small targeted hotfix.
- Do NOT add new features during stabilization.

**Fix priority:**
1. Security / integrity.
2. Crash / startup.
3. Gameplay correctness (Engine, Solver, Generator).
4. Wallet / IAP.
5. Sync.
6. Content.
7. Daily.
8. Performance.
9. UX friction.
10. Tuning.
11. New features (Post-MVP only, with explicit approval).

---

## Phase C — Production Metrics Review

**Entry:** Phase B criteria met (no active S0/core S1; metrics trustworthy).

**Review areas:**
- Player funnels (onboarding → tutorial → first level → retention).
- Level difficulty (win rate, OOM rate, Dead-End rate, hint usage).
- Economy balance (Coin sources vs sinks, starting balance decay curve).
- Monetization (Rewarded Ad CTR, IAP conversion, Remove Ads attach rate).
- Daily systems (Daily Reward claim rate, Streak length distribution, Challenge completion).
- Content quality (Report rate per Association, disable count).
- Cloud cost (Firestore reads, Functions invocations, Storage egress, BigQuery).
- Player support (top ticket categories).

**Principle:** Multi-metric decisions. Do not act on a single vanity number.  
Do not invent KPI targets not approved. Surface metrics; targets come from Product Owner decision.

---

## Phase D — Roadmap Decision

**Entry:** Phase C review completed.

**Output:** Ranked Post-MVP roadmap:

| Priority | Category |
|----------|----------|
| P0 | Production fixes (security, data loss, economy integrity, crash loops, unsolvable boards, purchase integrity, progression corruption) |
| P1 | Stability / UX |
| P2 | Content / balance |
| P3 | Post-MVP features (Events, Packs, Leaderboards, XP, Collections, Arc 2…) |
| P4 | Technical investments |

**Rules:**
- No roadmap item locked without explicit Product Owner approval.
- Post-MVP features (P3) only with evidence (retention, revenue, risk, ops cost).
- Arc 2 = Arabian Peninsula direction only; city order stays open.
- Do not auto-schedule any Post-MVP feature.

---

## Post-Launch Review Artifact

Must include:
- Executive summary.
- Timeline of key events.
- Stability report (crashes, outages, incidents).
- Gameplay health (win rate, Solver, Generator).
- Progression / Tutorial funnel.
- Difficulty analysis.
- Economy report.
- Monetization report.
- Daily systems report.
- Content report.
- Performance report.
- Security report.
- Cloud cost report.
- Support report.
- Incident list.
- Technical debt summary.
- Opportunity list.
- Ranked P0–P4 roadmap.
- Unresolved Product Owner decisions.
