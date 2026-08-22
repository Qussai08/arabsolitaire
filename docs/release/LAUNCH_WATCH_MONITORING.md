# Launch Watch & Stabilization — Phase A/B Operations Guide
## سوليتير العرب: أسطورة المعاني

**Authoritative spec:** `MVP_General_Availability_to_Post_Launch_Stabilization_and_Production_Metrics_Review_v1.0.md`  
**Stage:** Post-GA Phase A (Launch Watch) → Phase B (Stabilization)  
**Entry:** GA live, dashboard + alerts operational, no active S0/core S1.

---

## Phase A — Launch Watch

### Heightened Monitoring Period

After each rollout expansion, maintain heightened monitoring for 24–48 hours before the next expansion.

After reaching 100% GA: heightened monitoring period is active until crash-free and economy metrics are stable (exact duration determined operationally by the team).

### Dashboard Groups (Firebase / Google Cloud Console)

#### 1. Mobile Health

| Signal | Source | Alert threshold |
|--------|--------|----------------|
| Crash-free users | Crashlytics | <95% triggers review |
| App version distribution | Crashlytics | |
| ANR rate | Play Console | |

#### 2. Gameplay Health

| Signal | Source | Watch for |
|--------|--------|-----------|
| `level_won` rate | Firebase Analytics | Unusual drop |
| `out_of_moves` rate | Firebase Analytics | Spike (difficulty issue) |
| `dead_end_confirmed` rate | Firebase Analytics | False-positive spike |
| `attempt_started` count | Firebase Analytics | Expected volume |
| Level generation failures | Cloud Functions logs | Any spike |
| Solver inconclusive count | Analytics | Should stay low |

#### 3. Economy Integrity

| Signal | Source | Watch for |
|--------|--------|-----------|
| Wallet operation failures | Cloud Functions metrics | Any spike |
| Duplicate idempotency hits | Cloud Functions logs | Spike = retry storm |
| `wallet_initialized` | Analytics | Correct grant values |
| `reward_claimed` | Analytics | Correct amounts |

#### 4. Monetization

| Signal | Source | Watch for |
|--------|--------|-----------|
| `purchase_validated` success rate | Analytics + Functions | Drop below 95% |
| `rewarded_ad_completed` | Analytics | Unexpected drop |
| IAP validation errors | Functions logs | Any spike |
| Duplicate purchase callbacks | Functions logs | Must be zero net effect |

#### 5. Daily Systems

| Signal | Source | Watch for |
|--------|--------|-----------|
| `daily_reward_claimed` | Analytics | Under-claiming (backend issue) |
| `daily_challenge_completed` | Analytics | Baseline volume |
| Notification delivery | FCM console | Delivery rate |
| Daily claim errors | Functions logs | Any spike |

#### 6. Content + Sync

| Signal | Source | Watch for |
|--------|--------|-----------|
| `content_bundle_activated` | Analytics | Expected after updates |
| `content_bundle_validation_failed` | Analytics | Any = investigate |
| Auth failure spike | Firebase Auth | Sudden spike |
| Sync queue backlog | Functions logs | Growing = investigate |

#### 7. Cost

| Signal | Source | Watch for |
|--------|--------|-----------|
| Firebase / GCP spend | GCP Billing | Budget alert thresholds |
| Firestore reads/writes | GCP Monitoring | Unexpected spike |
| Functions invocations | GCP Monitoring | Cost anomaly |

---

## Incident Response During Launch Watch

**Rule:** No major tuning mid-incident. Stabilize first.

```
Incident detected
  ↓
Classify severity (S0/S1/S2/S3)
  ↓
Halt rollout expansion if S0/S1
  ↓
Can it be fixed server-side?
  ├── YES → Remote Config / content rollback / function fix → monitor
  └── NO  → Halt, prepare hotfix → RC2 → staged rollout
```

See `INCIDENT_RUNBOOKS.md` for detailed runbooks per incident type.

**Do not:**
- Tune economy or gameplay parameters during an active incident.
- Add new features during Launch Watch.
- Deploy unreviewed changes under time pressure.

---

## Phase B — Stabilization Policy

### What is a Stabilization Fix?

Permitted during Phase B:
- Bug / reliability fixes (crash, wrong state, bad gameplay behavior).
- Remote Config adjustment for cadence/cap values (NOT core economy values).
- Content disable/rollback for problematic Associations.
- Backend function fix for idempotency, validation, or sync issues.
- Small targeted hotfix for S0/S1 with proper RC → staged rollout process.

NOT permitted during Phase B without explicit Product Owner approval:
- Economy value changes (Coin amounts, prices, rewards).
- Gameplay rule changes.
- New features.
- Post-MVP content production.

### Hotfix Process

```
Issue identified → severity triage
  ↓
S0: immediate — halt rollout, fix, RC, new rollout
S1: urgent — fix within 24h, RC, staged rollout
S2: plan fix → explicit risk acceptance if deferred
S3/S4: backlog
```

### Phase B Exit Criteria

Phase B is complete when:
- [ ] No active S0 or core-path S1.
- [ ] Crash-free rate stable at acceptable baseline.
- [ ] Wallet / IAP / economy integrity confirmed stable.
- [ ] Purchase validation working correctly.
- [ ] Content pipeline stable (no rollbacks needed).
- [ ] Daily systems stable (reward / streak / challenge).
- [ ] Major incidents closed with post-mortems.
- [ ] Metrics trustworthy (no significant data gaps).

When Phase B is complete → proceed to Phase C (Metrics Review).

---

## Stabilization Principle

Production stability > product tuning > new features.

Do not rush into Post-MVP feature implementation while core launch health is still uncertain.
