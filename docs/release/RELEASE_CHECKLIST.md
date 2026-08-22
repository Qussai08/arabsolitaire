# Release Checklist — سوليتير العرب: أسطورة المعاني

**Version:** Use at every Release Candidate gate and before expanding staged rollout.  
**Authoritative spec:** `Sprint_11_Production_Hardening_Observability_Security_and_Release_Readiness_v1.0.md`

---

## Pre-conditions

- [ ] Sprint 11 Definition of Done is fully checked.
- [ ] RC build is produced from an immutable tagged commit.
- [ ] RC artifact manifest links commit SHA, build number, and backend versions.

---

## Gameplay Gate

- [ ] All critical Engine tests pass.
- [ ] Undo rules pass.
- [ ] Stock rules (Advance / Restore) pass.
- [ ] Completion / Win pass.
- [ ] Move accounting pass.
- [ ] Streak tiers pass.
- [ ] Solver parity pass (every Solver move accepted by Engine).
- [ ] Generator reproducibility pass (same seed → same board).
- [ ] **No accepted unsolvable board** — replay failures = 0.
- [ ] 10,000+ simulation gate passes for all critical templates.
- [ ] Generator bounded behavior verified (no infinite loops).
- [ ] Solver Inconclusive never treated as Dead-End.

---

## Security Gate

- [ ] No wildcard Firestore writes in rules.
- [ ] No wildcard Storage writes in rules.
- [ ] Wallet client writes denied.
- [ ] Entitlement client writes denied.
- [ ] Content pointer client writes denied.
- [ ] Cross-user read/write denied.
- [ ] Admin role checks enforced.
- [ ] Functions verify authenticated UID from auth context (not client arg).
- [ ] Tokens not logged in any backend log.
- [ ] **No secrets committed** — gitleaks scan passes.
- [ ] App Check status reviewed for Firestore / Storage / Functions.
- [ ] Dependency vulnerability audit completed (Dart / npm).
- [ ] Focused pen-test scope completed or formally scheduled, S0/S1 findings resolved.

---

## Economy Gate

- [ ] Initial Coin + Hint grant idempotent (once per player).
- [ ] Level reward granted once per Attempt win.
- [ ] Chapter reward granted once per chapter completion.
- [ ] Hint consume safe (cannot go negative).
- [ ] Extra Moves rescue limit (max 2 per Attempt) enforced.
- [ ] Dead-End rescue limit (max 1 per Attempt) enforced.
- [ ] No negative Wallet balance possible.
- [ ] Offline queue reconciles safely on reconnect.
- [ ] Crash recovery scenarios pass (charge before grant → idempotent retry).
- [ ] Wallet ledger consistency: balance == sum of ledger entries.

---

## Monetization Gate

- [ ] Rewarded Coins daily cap (3/day) enforced server-side.
- [ ] Rewarded Hint: granted only after provider callback.
- [ ] Rewarded Extra Moves: granted only after provider callback.
- [ ] Rewarded Dead-End: granted only after provider callback.
- [ ] Interstitial guardrails: not shown after Rewarded Ad / purchase / failure.
- [ ] Interstitial session cap (3/session) enforced.
- [ ] Remove Ads entitlement respected.
- [ ] Coin Packs IAP sandbox passes (1k / 3k / 7k / 15k).
- [ ] Restore passes (including reinstall scenario).
- [ ] IAP server validation passes.
- [ ] Duplicate callback protection confirmed.

---

## Daily Systems Gate

- [ ] 7-day repeating reward cycle correct.
- [ ] Missing a day does NOT reset reward calendar.
- [ ] Streak miss resets streak.
- [ ] Streak milestones (3/7/14/30 days) grant correctly.
- [ ] Daily Challenge board is deterministic for a given key.
- [ ] Daily Challenge reward grants on first completion only.
- [ ] Timezone validation: backend authoritative; device clock cannot cheat.
- [ ] DST transitions handled.
- [ ] Quiet hours (22:00–09:00 player-local) respected.
- [ ] FCM deep links work.

---

## Content Gate

- [ ] Bundled content fallback available offline.
- [ ] Remote content update tested.
- [ ] Hash validation rejects tampered bundle.
- [ ] Schema validation rejects unsupported version.
- [ ] Activation is atomic — no partial state.
- [ ] Rollback restores previous bundle.
- [ ] Emergency content disable tested.
- [ ] Human Arabic + semantic approval documented for launch content.
- [ ] Audit log entries visible for publish / rollback / disable events.

---

## Observability Gate

- [ ] Crashlytics custom session keys visible on test crash.
- [ ] Non-fatal recording confirmed.
- [ ] Analytics critical events validated in DebugView / non-PROD.
- [ ] No duplicate events.
- [ ] No accidental PII in event properties.
- [ ] BigQuery export enabled and dataset receiving data.
- [ ] Backend structured logs contain requestId / operationId / result.
- [ ] Critical Cloud Functions metrics exist.
- [ ] Actionable alerts configured (purchase failure, wallet error, content failure, auth spike).
- [ ] Firebase / GCP budget alerts configured before PROD rollout.

---

## Performance Gate

- [ ] Cold start time measured.
- [ ] Home and Journey render acceptable.
- [ ] Drag / drop responsive during gameplay.
- [ ] Solver runs off UI isolate — no jank.
- [ ] Generator runs off UI isolate.
- [ ] Solver performance benchmarks captured (p50 / p95 / max).
- [ ] Memory profile reviewed — no unbounded caches.

---

## Offline / Lifecycle Gate

- [ ] Core gameplay works offline after bootstrapped launch.
- [ ] Reconnect reconciles progression / Wallet / Daily without duplicates.
- [ ] Background / kill / resume preserves active Attempt.
- [ ] Kill during purchase validation → idempotent recovery.
- [ ] Kill during rewarded ad → idempotent recovery.
- [ ] Bundle activation after kill → safe retry.

---

## UX / Accessibility Gate

- [ ] Arabic RTL QA passed (all screens).
- [ ] No broken Arabic shaping, clipped text, or reversed punctuation.
- [ ] Localization keys used for all player-facing strings.
- [ ] Semantic labels on interactive controls.
- [ ] Readable contrast.
- [ ] Touch targets adequate.
- [ ] Text scaling tolerance verified.

---

## Environment Gate

- [ ] DEV / TEST / STAGING / PROD configs are separated.
- [ ] PROD build uses production Firebase project ID.
- [ ] PROD build uses production ad unit IDs (no test IDs).
- [ ] PROD build uses production IAP product IDs (no sandbox IDs).
- [ ] PROD build has no debug menus or cheat screens.
- [ ] No lower-environment config points to PROD.

---

## Store Gate

- [ ] Bundle identifier / application ID configured correctly.
- [ ] Signing and provisioning configured.
- [ ] App icon at all required sizes.
- [ ] Launch assets.
- [ ] Screenshots prepared.
- [ ] Arabic store listing metadata prepared.
- [ ] Privacy Policy URL set.
- [ ] Support URL set.
- [ ] IAP products configured in stores.
- [ ] Content rating / data safety answers completed.
- [ ] Ads declaration completed.

---

## Rollback Gate

- [ ] Staged rollout plan documented (initial %, expansion criteria).
- [ ] Rollout halt procedure documented.
- [ ] Backend / config rollback tested on STAGING.
- [ ] Content rollback drill passes.
- [ ] Kill switch drill passes (disable interstitial / shop / daily challenge).
- [ ] Incident runbooks reviewed and accessible.
- [ ] Release health dashboard accessible.

---

## Final Go/No-Go

- [ ] Engineering sign-off.
- [ ] QA sign-off.
- [ ] Product Owner sign-off.
- [ ] Security review owner sign-off.
- [ ] Content / Publisher sign-off for production content.

**Release status:** `NotReady` / `AtRisk` / `ReadyForRC` / `ReadyForStagedRollout` / `ReadyForGeneralAvailability`
