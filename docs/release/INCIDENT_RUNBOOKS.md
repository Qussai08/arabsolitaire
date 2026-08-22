# Incident Runbooks — سوليتير العرب: أسطورة المعاني

**Authoritative spec:** Sprint 11 §83–§87, §112  
**Priority order:** Security / integrity → crash / startup → gameplay correctness → Wallet / IAP → sync → content → Daily → performance → UX friction

---

## 1. Crash Spike Runbook

**Trigger:** Crashlytics crash-free rate drops significantly (e.g. >5% sessions affected).

**Steps:**
1. Identify crash group in Crashlytics — read `boardFingerprint`, `levelDefinitionId`, `activeBundleVersion`, `rulesVersion`.
2. Determine if crash is in gameplay, content activation, or backend call.
3. If content-related → follow Content Rollback Runbook.
4. If gameplay / Engine → treat as S0/S1 — halt staged rollout expansion.
5. If ad SDK → disable `interstitial_enabled` or `rewarded_ads_enabled` via Remote Config.
6. File incident with reproduction steps, affected versions, mitigation applied.
7. Expedite hotfix build if S0; fix → new build → RC → staged rollout.

**Do not:** Patch the release artifact manually. Produce a new tagged build.

---

## 2. Wallet / Economy Incident Runbook

**Trigger:** Wallet operation failures spike; duplicate grants detected; ledger inconsistency found.

**Immediate actions:**
1. Disable affected utility (Hint purchase / Extra Moves / Dead-End rescue) via Remote Config kill switch if safe.
2. Do NOT create a generic admin-adjust endpoint.
3. Inspect idempotency receipts in Firestore `economy/operations`.
4. Audit Wallet ledger: `balance == Σ(transaction.amount)` for affected players.
5. Block duplicate retries at Function level (idempotency key check).
6. Reconcile affected users via a trusted one-off admin process (not ad-hoc client script).
7. Document: how many players affected, root cause, coins over/under-granted, reconciliation plan.

**Escalate immediately** if: duplicate Coin grants > 10% of session volume, or Wallet goes negative for any player.

---

## 3. Purchase Validation Outage Runbook

**Trigger:** Purchase validation Cloud Function error rate spikes; store returns non-retryable error.

**Immediate actions:**
1. Disable purchase CTA via `shop_enabled: false` in Remote Config if necessary.
2. Preserve all pending purchase transactions — do NOT discard.
3. Verify the IAP Cloud Function is receiving store callbacks (check function logs for `purchase_validated`).
4. If store API is down → wait for recovery; transactions will retry idempotently.
5. If function is broken → deploy hotfix function.
6. Verify no duplicate grants on retry.
7. Re-enable `shop_enabled` after confirming validation works.

---

## 4. Content Rollback Runbook

**Trigger:** Active content bundle causes validation failure, game errors, or player-visible incorrect content.

**Steps:**
1. Identify the bad bundle version from `content_bundle_validation_failed` Analytics events or player reports.
2. Use CMS / Admin function to update `content/pointer` to the previous known-good bundle version.
3. If a specific Association/Member is problematic → use `disable_content` function to disable that item without full rollback.
4. Verify `content/pointer` reflects the rollback version.
5. Monitor: `content_bundle_activated` and `content_bundle_rollback` events in Analytics.
6. Alert on-call if active Attempts are on the bad bundle version (they may need a restart prompt).
7. Do NOT activate a new bundle until root cause is identified.

---

## 5. Bad Association Disable Runbook

**Trigger:** A specific Association or Member card has incorrect Arabic content, is semantically ambiguous beyond fairness, or has been reported by multiple players.

**Steps:**
1. Identify the `associationId` from player reports or CMS content review.
2. Call `disable_content` function with the Association variant ID and reason.
3. The function updates `content/disableMetadata` — clients will exclude this item from new generation.
4. Active Attempts currently using the disabled item continue until the Attempt ends.
5. Prepare corrected content via CMS → human review → approval → new bundle.
6. Re-enable only after a new approved bundle is published.

---

## 6. Firebase / Google Cloud Outage Runbook

**Trigger:** Firebase Auth, Firestore, Functions, or Storage reports degradation.

**App behavior:**
- Main Journey gameplay is fully offline-capable if content is cached.
- Auth: Anonymous players can play without internet; linked accounts may see login failure.
- Wallet: Offline queue accumulates — reconcile on reconnect.
- Daily systems: Backend-authoritative features unavailable; show graceful unavailable state.
- IAP / Rewarded Ads: Require network — show "unavailable" gracefully.

**Steps:**
1. Monitor Firebase Status (https://status.firebase.google.com).
2. Do NOT send mass push notifications during outage — FCM may be degraded.
3. When restored: Wallet queue reconciles automatically; Daily state syncs; purchases retry idempotently.
4. Review idempotency receipt logs for any duplicate operations during degraded window.

---

## 7. Auth Outage Runbook

**Trigger:** Firebase Authentication reports degradation; sign-in / account linking fails.

**Steps:**
1. Anonymous auth allows offline play — no action needed for core gameplay.
2. If linking (Apple / Google) is failing → show user-friendly error; no silent loss of progress.
3. Progression sync will queue until auth is restored.
4. On restoration: verify sync queue processes without duplicate progression writes.

---

## 8. Notification Outage Runbook

**Trigger:** FCM delivery rate drops; notification function failures spike.

**Steps:**
1. Check notification function logs for `notification_function_error` entries.
2. Verify FCM token refresh is working.
3. Notifications are non-critical (Daily Challenge reminder, Streak Risk).
4. If function is broken → disable notification scheduling via Remote Config (TBD flag).
5. Do NOT send duplicate notifications on recovery — check last-sent timestamps.

---

## 9. Daily Reward Issue Runbook

**Trigger:** Daily reward double-granted, or reward unavailable despite player qualifying.

**Steps:**
1. Check `daily_reward_claimed` Analytics event for duplicates (same uid, same day_index, multiple events).
2. Inspect `players/{uid}/daily/reward` document — `lastClaimed` timestamp is authoritative.
3. If double-grant: audit Wallet ledger; record incident; plan correction via trusted admin process.
4. If reward blocked: check backend timezone authority; verify `daily_enabled: true` in Remote Config.
5. Do NOT create a generic "grant coins" admin endpoint — use purpose-built reconciliation.

---

## 10. App Rollback / Halt Staged Rollout Runbook

**Trigger:** S0 or widespread S1 discovered after staged rollout begins.

**Steps:**
1. Immediately halt staged rollout expansion in Play Store / App Store Connect.
2. Communicate internally — do not expand percentage until root cause is resolved.
3. Assess: can the issue be fixed server-side (content rollback, Remote Config, function hotfix)?
   - If yes → fix server-side, monitor, resume rollout if resolved.
   - If no → prepare expedited hotfix build → RC2 → new staged rollout.
4. Mobile binary rollback to a previous version is not instant — rely on halting expansion.
5. Preserve pending transactions from the bad build — do not discard on rollback.
6. Document: affected build range, player count, root cause, remediation.

---

## Severity Classification

| Severity | Description | Response |
|----------|-------------|----------|
| S0 | App crash loop, Wallet duplication, cross-user access, accepted unsolvable board, progression loss | Immediate — halt rollout |
| S1 | Hint gives wrong hint, false Dead-End, Remove Ads ignored, Daily double grant | Urgent — fix in RC2 or hotfix |
| S2 | Interstitial shown when it shouldn't, minor content error | Plan fix — explicit risk acceptance if deferred |
| S3 / S4 | Minor UX friction, cosmetic | Backlog allowed |

---

*Review runbooks before each release. Update with findings from previous incidents.*
