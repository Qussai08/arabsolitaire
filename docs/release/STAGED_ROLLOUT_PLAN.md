# Staged Production Rollout Plan — سوليتير العرب: أسطورة المعاني

**Authoritative spec:** `MVP_Release_Candidate_to_Staged_Production_Rollout_v1.0.md`  
**Entry:** Sprint 11 exit gate green, explicit Go approved.

---

## Rollout Phases

| Phase | % of Users | Duration | Expansion Criteria |
|-------|-----------|----------|--------------------|
| 1 — Internal | 1% (internal/testers) | 24–48 h | No S0/S1, crash-free acceptable, economy stable |
| 2 — Limited | 5–10% | 48–72 h | Phase 1 healthy, no regressions |
| 3 — Expanded | 20–30% | 48–72 h | Phase 2 healthy |
| 4 — Broad | 50–80% | 48–72 h | Phase 3 healthy |
| 5 — Full GA | 100% | — | Phase 4 healthy, no pending S0/S1 |

Exact percentages and timings are operational decisions adjusted based on observed metrics. Do not advance mechanically — require health confirmation at each gate.

---

## Halt / Rollback Criteria

Immediately halt rollout expansion if any of the following is observed:

- Crash-free rate drops more than 5% relative to pre-release baseline.
- S0 defect discovered in production.
- Wallet duplication or economy integrity issue.
- Purchase validation failure rate spikes.
- Accepted unsolvable board report confirmed.
- Content bundle failure spike.
- Auth spike indicating a systemic issue.

**Actions on halt:**
1. Stop expanding rollout percentage.
2. Assess: can it be fixed server-side (Remote Config / content rollback / function hotfix)?
3. If server-side fix resolves it → monitor and resume.
4. If binary fix required → halt rollout, prepare RC2, new staged rollout.

---

## Health Monitoring During Rollout

Monitor continuously in Firebase / Google Cloud Console:

- Crash-free users (Crashlytics).
- Function error rates (Cloud Monitoring).
- Purchase validation success (custom metric + Analytics).
- Wallet operation failures.
- Content bundle activation events.
- Daily claim errors.
- Solver inconclusive rate (Analytics `level_won` vs `out_of_moves` ratio).
- Auth failure spike.

---

## PROD Smoke Test (post-deployment)

Run after each backend deployment before expanding rollout:

1. Launch app (PROD build).
2. Anonymous auth completes.
3. Home screen loads.
4. Journey screen loads.
5. One Level generates and plays.
6. Hint consumes resource correctly.
7. Wallet reads current balance.
8. Daily state is visible.
9. Shop product list loads.
10. No debug UI visible.

Use a designated test account for sandbox monetization checks.

---

## Post-Rollout Transition

After reaching 100% GA and no active S0/S1:

1. Formally declare MVP in General Availability.
2. Begin Post-GA Phase A — Launch Watch.
3. Heightened monitoring window begins.

See `MVP_General_Availability_to_Post_Launch_Stabilization_and_Production_Metrics_Review_v1.0.md`.
