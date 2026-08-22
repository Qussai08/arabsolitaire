# Production Deployment Order — سوليتير العرب: أسطورة المعاني

**Authoritative spec:** `MVP_Release_Candidate_to_Staged_Production_Rollout_v1.0.md` §6  
**Entry:** Sprint 11 exit gate green, Go/No-Go explicitly approved.

---

## Pre-Deployment Checklist

Before executing any deployment step:

- [ ] RC tag created from immutable commit (`rc/<version>`).
- [ ] Release Validation Report completed and signed.
- [ ] Go/No-Go decision recorded as GO.
- [ ] PROD secrets / config audited — no lower-env config present.
- [ ] STAGING smoke test passed with RC build.
- [ ] Content bundle hash verified.
- [ ] Rollback target known (previous bundle pointer, previous rules version).
- [ ] On-call rotation confirmed.
- [ ] Incident runbooks accessible.

---

## Deployment Sequence

Run in this exact order. Do not skip steps. Do not deploy mobile before backend is ready.

### Step 1 — Verify PROD secrets and config

```bash
# Confirm no test ad IDs, sandbox IAP IDs, or lower-env pointers are present.
# Review: apps/mobile/lib/app/config/ for PROD flavor
# Review: firebase/ — ensure project alias 'prod' points to correct project
firebase use prod --project arabsolitaire
```

### Step 2 — Deploy Firestore and Storage rules

```bash
cd firebase
firebase deploy --only firestore:rules,storage --project prod
```

Verify rules are live:
- [ ] Rules deployment succeeded.
- [ ] No wildcard writes visible in new rules.

### Step 3 — Deploy Firestore indexes (if changed)

```bash
firebase deploy --only firestore:indexes --project prod
```

Monitor index build in Firebase Console — do not proceed until indexes are ready if any new indexes are required.

### Step 4 — Deploy Cloud Functions

```bash
firebase deploy --only functions --project prod
```

Verify:
- [ ] Functions deployed without error.
- [ ] Function health in GCP Cloud Monitoring.
- [ ] No invocation errors in first 5 minutes.

### Step 5 — Deploy Remote Config defaults

```bash
# Update defaults via Firebase Console or Admin SDK.
# Verify all kill switches default to enabled.
# Verify PROD feature flag values are correct.
```

- [ ] `rewarded_ads_enabled: true`
- [ ] `interstitial_enabled: true`
- [ ] `shop_enabled: true`
- [ ] `daily_enabled: true`
- [ ] `daily_challenge_enabled: true`
- [ ] `remote_content_updates_enabled: true`
- [ ] Cadence/cap values correct.

### Step 6 — Upload and activate production content bundle

```bash
# Upload via CMS publishing pipeline (Cloud Functions / Admin SDK).
# This step requires:
# - human approval completed in CMS;
# - bundle hash verified;
# - STAGING smoke passed.
# Do NOT update content/pointer until upload is confirmed.
```

After upload:
- [ ] Bundle hash matches expected value.
- [ ] `content/pointer` updated to new bundle version.
- [ ] `content_bundle_activated` Analytics event visible in DebugView (test device).

### Step 7 — Verify Wallet / Daily / Monetization config

```bash
# Confirm economy config version in Remote Config matches expected.
# Confirm Daily reward table is correct (100/125/150/1Hint/175/200/300+1Hint).
# Confirm IAP product IDs are production — NOT sandbox.
# Confirm AdMob unit IDs are production — NOT test IDs.
```

- [ ] Economy config version correct.
- [ ] Daily reward table correct.
- [ ] IAP product IDs: production.
- [ ] AdMob unit IDs: production.

### Step 8 — Build, sign, and submit mobile artifacts

```bash
# Android
cd apps/mobile
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
# Sign with PROD keystore (via CI or local Fastlane — do not commit keystore).
# Upload to Play Store Internal Test track → promote to staged rollout.

# iOS
# Build with Xcode using PROD provisioning profile.
# Archive and upload to App Store Connect.
# Submit for review (allow review before staged rollout expansion).
```

- [ ] Android AAB signed and uploaded.
- [ ] iOS IPA signed and uploaded.
- [ ] Both builds link to correct RC commit.

### Step 9 — PROD Smoke Test

Run immediately after backend deployment, before expanding rollout:

1. Launch app (PROD build on test device).
2. Anonymous auth completes.
3. Home screen loads.
4. Journey renders a level.
5. Level generates without error.
6. Hint consumes resource.
7. Wallet displays balance.
8. Daily state visible.
9. Shop product list loads.
10. No debug UI / DEV menu visible.
11. `content_bundle_activated` event received.

- [ ] All smoke test steps passed.

---

## Staged Rollout (see STAGED_ROLLOUT_PLAN.md)

Start at 1% after PROD smoke test passes. Follow STAGED_ROLLOUT_PLAN.md for expansion criteria and halt triggers.

---

## Rollback Procedures

### Backend rollback

```bash
# Rules rollback: redeploy previous tagged version
git checkout <previous-rc-tag>
firebase deploy --only firestore:rules,storage --project prod

# Functions rollback: redeploy previous function version
firebase deploy --only functions --project prod

# Content rollback: update content/pointer via Admin SDK
```

### Mobile rollback

Google Play and App Store do not provide instant binary rollback.

- Halt rollout expansion immediately.
- Fix → RC2 → new staged rollout.
- Use Remote Config to disable affected features while expediting fix.

---

## Post-Deployment Monitoring

For the first 24–48 hours after each rollout expansion:

- Crashlytics: crash-free rate (alert threshold TBD by Ops).
- Cloud Monitoring: function error rate.
- Analytics: `purchase_validated`, `wallet_initialized`, `content_bundle_activated`.
- Firebase Console: auth anomalies.
- Support channels: user-reported issues.

Do not expand rollout if any S0/S1 is observed.

---

## Release Traceability Record

Complete before marking GA:

| Field | Value |
|-------|-------|
| App version | |
| Build number | |
| Git commit | |
| Git tag (RC) | |
| Rules version | |
| Solver version | |
| Generator version | |
| Content bundle version | |
| Content hash | |
| Backend deployment version | |
| Economy config version | |
| Firebase PROD project ID | |
| Deployment date | |
| Deployed by | |
