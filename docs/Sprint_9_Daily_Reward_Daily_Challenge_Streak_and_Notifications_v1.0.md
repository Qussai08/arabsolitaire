# Sprint 9 — Daily Reward, Daily Challenge, Streak & Notifications v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Daily Engagement / Backend Authority / Notifications  
**Depends On:** Sprint 8 — Ads, IAP & Monetization v1  
**Primary App:** `apps/mobile`  
**Primary Cloud:** Firebase  
**Trusted Backend:** Cloud Functions and/or Cloud Run  
**Notifications:** Firebase Cloud Messaging  
**Primary Local Store:** Drift / SQLite  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 9 Objective

Implement the approved Daily engagement systems for **سوليتير العرب: أسطورة المعاني**.

Sprint 9 must add:

- 7-day Daily Reward calendar;
- backend-authoritative Daily Reward eligibility;
- Daily Streak;
- Daily Streak milestone rewards;
- Daily Challenge;
- deterministic Daily Challenge board;
- first-completion Daily Challenge reward;
- validated player-local day boundary;
- timezone abuse protection;
- local caching/offline presentation;
- FCM notification foundation;
- Daily Challenge notifications;
- Streak Risk notifications;
- quiet hours;
- notification preferences;
- idempotent Daily grants;
- safe offline/online reconciliation.

The goal is:

> **Give players a reliable daily reason to return without compromising economy authority, timezone correctness, or offline-first gameplay.**

---

# 2. Sprint 9 Success Criteria

Sprint 9 is complete only when:

1. Daily Reward follows the approved 7-day schedule.
2. Missing a day does not reset Daily Reward calendar progress.
3. Daily Streak breaks when a day is missed.
4. Daily Streak milestone rewards are correct.
5. Daily Reward claims are backend-authoritative.
6. Duplicate Daily Reward claims cannot duplicate rewards.
7. Daily Challenge appears once per player-local day.
8. Daily Challenge board is deterministic for the intended cohort/day.
9. Daily Challenge allows unlimited retries during the active day.
10. Daily Challenge reward is granted only on first completion.
11. Daily Challenge reward is exactly 150 Coins.
12. Day boundary uses validated player-local timezone.
13. Device clock manipulation cannot trivially farm rewards.
14. Timezone switching abuse is mitigated.
15. FCM notification infrastructure works.
16. Daily Challenge notification works.
17. Streak Risk notification works.
18. Quiet hours 22:00–09:00 local are respected.
19. Notification preferences are respected.
20. Offline app can show last-known Daily state safely.
21. Offline claims do not grant authoritative rewards until reconciled.
22. Daily operations are idempotent.
23. Core gameplay still works without network.
24. Emulator/integration tests cover date, timezone, and duplicate edge cases.

---

# 3. Non-Goals

Do NOT implement in Sprint 9:

- Events;
- Leaderboards;
- XP;
- Achievements;
- Badges;
- Collections;
- Permanent Packs;
- advanced notification campaigns;
- push segmentation;
- marketing automation;
- full CRM;
- seasonal event calendar;
- subscription;
- premium currency;
- new ad placements;
- new Coin pack sizes.

---

# 4. Approved Daily Reward Schedule

7-day repeating calendar:

| Day | Reward |
|---|---|
| Day 1 | 100 Coins |
| Day 2 | 125 Coins |
| Day 3 | 150 Coins |
| Day 4 | 1 Hint |
| Day 5 | 175 Coins |
| Day 6 | 200 Coins |
| Day 7 | 300 Coins + 1 Hint |

After Day 7:
- calendar repeats to Day 1.

---

# 5. Daily Reward Missed-Day Rule

Approved:

## Missing a day does NOT reset Daily Reward progress.

Example:

- Player claims Day 3.
- Returns three days later.
- Next eligible claim remains Day 4.

Daily Reward is a progression calendar, not a streak.

---

# 6. Daily Streak Rule

Approved:

## Missing a day breaks the Daily Streak.

Daily Streak measures consecutive active/qualifying days.

Milestones:

- 3 days → 100 Coins
- 7 days → 250 Coins
- 14 days → 400 Coins
- 30 days → 750 Coins

---

# 7. Daily Challenge Reward

Approved:

```text
150 Coins
```

Rules:

- one Daily Challenge per valid day;
- unlimited retries during that day;
- first completion only grants reward;
- repeated completion that same day grants nothing additional.

---

# 8. Daily Challenge Board Rule

Board must be deterministic per intended challenge cohort.

Conceptually:

```text
dailyChallengeSeed = f(dayKey, cohortKey, challengeVersion)
```

Same cohort/day/version:
- same board.

Do not depend on device randomness.

---

# 9. Daily Challenge Content

Use approved content and Level Generator.

Daily Challenge can use:
- dedicated Daily LevelConfiguration;
- approved content pool;
- deterministic seed.

It must still:
- pass Engine invariants;
- Solver validation;
- fixed Move Limit;
- difficulty target.

Do not create a separate ruleset unless explicitly approved.

---

# 10. Day Boundary

Approved reset time:

```text
00:00 validated player-local timezone
```

Backend remains authoritative.

Do not trust raw device clock alone.

---

# 11. Player Timezone Model

Store:

```text
timezoneId
timezoneOffsetAtValidation
timezoneRevision
timezoneValidatedAt
```

Prefer IANA timezone identifiers where platform/library support is reliable.

Example:
```text
Africa/Cairo
Asia/Riyadh
Asia/Dubai
```

---

# 12. Time Authority Principle

Use a combination of:

- backend server time;
- player timezone identifier;
- trusted timezone rules;
- last validated timezone state.

Client time is for UX only.

Backend determines:
- current Daily key;
- claim eligibility;
- streak continuity.

---

# 13. Daily Key

Recommended:

```text
YYYY-MM-DD
```

in validated player-local timezone.

Example:

```text
2026-08-21
```

This is not UTC date unless UTC is the player's validated timezone.

---

# 14. Timezone Change Handling

Timezone changes are legitimate during travel.

But frequent switching can be abusive.

Recommended:

- allow legitimate timezone updates;
- store previous timezone;
- track change timestamp;
- apply cooldown/risk rules for reward eligibility if needed.

Do not permanently lock player timezone.

---

# 15. Timezone Abuse Mitigation

Backend should detect suspicious patterns such as:

- repeated timezone changes in short period;
- moving day boundary backwards/forwards repeatedly;
- claiming multiple “days” faster than physically plausible.

Possible policy:

- clamp eligibility to at most one Daily claim per server-defined rolling period;
- require minimum elapsed server time between claims.

Exact anti-abuse thresholds remain configurable.

Do not invent harsh bans.

---

# 16. Daily Reward Cloud Record

Recommended:

```text
players/{uid}/daily/reward
```

Fields:

```text
schemaVersion
calendarDayIndex
lastClaimedDayKey
lastClaimedAt
nextEligibleDayIndex
revision
```

`calendarDayIndex` is 1–7.

---

# 17. Daily Reward Claim

Trusted endpoint:

```text
claimDailyReward
```

Server:

1. authenticate;
2. resolve validated local day;
3. verify not already claimed today;
4. determine current calendar Day N;
5. grant reward through Wallet service;
6. advance Day index;
7. record claim;
8. return receipt.

---

# 18. Daily Reward Idempotency

Key:

```text
daily_reward:{uid}:{dayKey}
```

Duplicate request:
- returns original receipt;
- no duplicate grant.

---

# 19. Daily Reward Progression

After successful claim:

```text
Day 1 -> 2
Day 2 -> 3
...
Day 7 -> 1
```

Missed dates do not change index.

---

# 20. Daily Reward UI

Home may show:

- current Daily Reward Day;
- today’s reward;
- claim button;
- claimed state;
- next reward preview.

Do not show false availability if backend has not confirmed.

---

# 21. Offline Daily Reward UX

If offline:
- show last-known Daily Reward state;
- claim button may be disabled or marked network-required.

Because authoritative reward requires backend eligibility check:
- do not grant offline authoritatively.

A queued claim is possible but could create confusing stale-day behavior.

Recommended v1:
- Daily Reward claim requires network.

---

# 22. Daily Streak Qualification

A day qualifies for streak when approved daily engagement condition occurs.

Recommended MVP qualification:

```text
first meaningful game activity / Daily Challenge completion / Daily Reward claim
```

However exact qualifying event must be explicit.

### Sprint 9 recommended canonical implementation

Count a Daily Streak day when the player completes at least one eligible gameplay activity on that validated local day.

Use one backend call/event:
```text
markDailyActivity
```

Avoid counting mere app open.

If latest product docs specify a different trigger, latest decision wins.

---

# 23. Daily Activity Record

Recommended:

```text
players/{uid}/daily/activity/{dayKey}
```

or compact rolling record.

Fields:

```text
qualified
firstQualifiedAt
source
```

Could be stored more compactly to reduce reads/writes.

---

# 24. Streak State

Recommended:

```text
currentStreakDays
lastQualifiedDayKey
longestStreakDays? optional
claimedMilestones
revision
```

Do not add leaderboard/public streak.

---

# 25. Streak Continuity

On new qualifying day:

If previous qualified day == immediately preceding local day:

```text
currentStreakDays += 1
```

Else:

```text
currentStreakDays = 1
```

Same-day repeated activity:
- does not increment again.

---

# 26. Streak Milestone Grants

On reaching:

```text
3
7
14
30
```

grant approved Coin reward once for that milestone occurrence/policy.

Important:
- define repeat-cycle behavior carefully.

### Sprint 9 recommendation

Milestones trigger on the exact streak count and are not repeatedly farmed within same streak.

After streak breaks and a new streak reaches milestone again, whether milestone rewards repeat is not explicitly locked.

Keep reward receipt/idempotency architecture capable of either policy.

Do not silently choose permanent repeat behavior if implementation requires it.

---

# 27. Streak Milestone Idempotency

Example key:

```text
daily_streak:{uid}:{streakCycleId}:{milestone}
```

Where `streakCycleId` identifies one uninterrupted streak run.

This supports safe repeat semantics later.

---

# 28. Daily Streak UI

Show:

- current streak count;
- next milestone;
- progress;
- warning when at risk.

Example:

```text
🔥 6 أيام
المكافأة التالية عند 7 أيام
```

Final iconography/copy can be polished.

---

# 29. Streak Risk

A player is “at risk” when:

- current streak > 0;
- current local day is nearing end;
- no qualifying activity yet today.

Notification may remind them.

---

# 30. Daily Challenge Cloud Record

Recommended:

```text
players/{uid}/daily/challenge
```

Fields:

```text
currentDayKey
challengeId
completed
completedAt
rewardGranted
attemptCount? optional
revision
```

Avoid per-move cloud writes.

---

# 31. Daily Challenge Definition

Recommended:

```text
challengeId
dayKey
cohortKey
levelConfigurationRef
seed
contentPoolVersion
rulesVersion
generatorVersion
solverVersion
rewardAmount
activeFrom
activeUntil
```

---

# 32. Cohort Strategy

Keep simple.

Potential cohort dimensions:
- app version;
- content version;
- region/language group.

Do not over-segment.

If no cohort split needed:
- one global Arabic cohort.

---

# 33. Daily Challenge Generation

Preferred:

- deterministic seed generated server-side or via deterministic formula;
- challenge definition can be cached locally;
- board generated on-device using Level Generator;
- same board reproducible.

Server may pre-validate challenge definition/seed.

---

# 34. Daily Challenge Validation

Before challenge is considered active:

- LevelConfiguration valid;
- content available;
- Generator reproducible;
- Solver proves solvable;
- difficulty within target.

For production, Daily seed can be pre-generated/validated ahead of time.

---

# 35. Daily Challenge Attempt

Unlimited retries within active day.

Each retry:
- same deterministic board;
- not new random shuffle.

This differs from Main Journey restart behavior.

Important:
- Daily Challenge restart reuses same fixed board for that day/cohort.

---

# 36. Daily Challenge Active Attempt

Local Attempt may persist across app restart during same day.

At day change:
- old Daily Attempt expires;
- new challenge loads.

Do not carry yesterday’s attempt as today’s challenge.

---

# 37. Daily Challenge Completion

On Engine Win:

1. mark local completion;
2. submit authoritative completion claim;
3. backend verifies not already rewarded;
4. grant 150 Coins;
5. mark completed;
6. sync UI.

---

# 38. Daily Challenge Idempotency

Key:

```text
daily_challenge_reward:{uid}:{dayKey}:{challengeId}
```

Duplicate:
- no duplicate Coin grant.

---

# 39. Offline Daily Challenge

Approved core gameplay is offline-first.

Possible behavior:

- if today's challenge definition is already cached, player can play offline;
- completion is stored locally;
- reward claim queues;
- backend grants when reconnected if still valid under policy.

Recommended:
- allow offline play of cached challenge;
- mark reward pending.

If no definition cached:
- Daily Challenge unavailable offline.

---

# 40. Late Offline Reconciliation

If player completed Daily Challenge offline before day ended but reconnects after reset:

Need proof metadata:

```text
challengeId
dayKey
completionTimestampLocal? diagnostic
attemptSeed
completionProof metadata
```

Backend policy should avoid rewarding obviously fabricated stale claims.

Simplest v1:
- accept queued completion only if challenge was legitimately loaded/cached for that day and operation created before expiry according to trusted/local sync metadata.

Exact anti-cheat strength can evolve.

---

# 41. Daily Challenge UI

Home:
- Daily Challenge card;
- status:
  - available;
  - in progress;
  - completed;
  - unavailable offline.

Show:
- 150 Coins reward;
- time remaining until local midnight;
- optional streak relevance.

---

# 42. Time Remaining

Client may display countdown using device time adjusted against last server-time offset.

Do not use countdown as authority.

Backend eligibility remains authoritative.

---

# 43. Notification Types — Launch

Approved initial notification types:

1. Daily Challenge
2. Streak Risk

No other push categories required at launch.

---

# 44. FCM Token Management

Store FCM tokens under player/device scope.

Recommended:

```text
players/{uid}/devices/{deviceId}
```

Fields:

```text
fcmToken
platform
timezoneId
notificationsEnabled
lastSeenAt
appVersion
```

Keep minimal.

---

# 45. Device Token Lifecycle

Update token when:

- FCM token rotates;
- user account changes;
- app reinstalls;
- notification permission changes.

Remove/disable stale token where possible.

---

# 46. Notification Preferences

Local + cloud preference fields:

```text
dailyChallengeNotificationsEnabled
streakRiskNotificationsEnabled
```

Default policy should respect platform permission and product defaults.

Exact opt-in default can follow platform conventions.

---

# 47. Quiet Hours

Approved:

```text
22:00–09:00 player-local time
```

Do not send non-critical Daily notifications during quiet hours.

---

# 48. Quiet Hours Scheduling

Backend determines local send window.

If intended send time falls in quiet hours:
- delay until after 09:00;
or
- send earlier before 22:00 if product logic supports.

Do not wake users during quiet hours.

---

# 49. Daily Challenge Notification

Purpose:
- remind player that today’s challenge is available.

Suggested timing:
- morning/daytime outside quiet hours.

Exact clock time is not locked.

Keep configurable.

---

# 50. Streak Risk Notification

Purpose:
- notify player before current streak would break.

Must:
- check streak > 0;
- check no qualifying activity today;
- respect quiet hours.

If risk window lands after 22:00:
- notify before quiet hours if appropriate.

---

# 51. Notification Scheduling Architecture

Recommended server-side scheduled job:

```text
Cloud Scheduler
  ↓
Cloud Function / Cloud Run Job
  ↓
select eligible player devices
  ↓
send FCM
```

Keep cost-conscious.

Do not create always-on workers.

---

# 52. Notification Fanout

Avoid scanning entire player collection inefficiently.

Potential approaches:
- maintain eligible notification schedule metadata;
- batch by timezone bucket;
- use scheduled queues.

Exact optimization can be phased.

For MVP scale:
- start simple but measurable.

---

# 53. Timezone Bucketing

Optional optimization:

Group devices by timezone or offset bucket for scheduling.

Do not over-engineer before scale requires it.

---

# 54. Notification Idempotency

Each notification logical send should have key:

```text
daily_challenge:{uid}:{dayKey}
streak_risk:{uid}:{dayKey}
```

Prevent duplicate sends.

---

# 55. Notification Receipt Tracking

Optional lightweight tracking:

- scheduled;
- sent;
- opened.

Do not rely on delivery receipt for gameplay logic.

---

# 56. Deep Links

Daily Challenge notification:
- opens Home/Daily Challenge.

Streak Risk:
- opens Home or Daily area.

Do not navigate directly into invalid/expired challenge without checking current day.

---

# 57. Expired Notification Handling

If user opens yesterday's notification:
- route to current Daily area;
- do not show stale challenge as active.

---

# 58. Notification Permission UX

Ask at contextually appropriate time.

Avoid asking immediately on first app launch unless product UX approves it.

Recommended:
- after player understands Daily systems;
- explain value.

Exact timing is UX-tunable.

---

# 59. Notification Localization

Arabic-first.

Use localization templates.

Example:

Daily Challenge:
```text
تحدي اليوم جاهز
```

Streak Risk:
```text
سلسلتك اليومية في خطر
```

Final copy may be refined.

---

# 60. Notification Template Config

Templates can be versioned/configurable.

Fields:
- title;
- body;
- deep link;
- enabled.

Do not hard-code all copy in server code.

---

# 61. Daily Backend APIs

Recommended:

```text
getDailyState
claimDailyReward
markDailyActivity
getDailyChallenge
claimDailyChallengeReward
updateTimezone
updateNotificationPreferences
registerDeviceToken
```

Do not expose generic grant endpoint.

---

# 62. Daily State API

`getDailyState` should return:

```text
dayKey
timezoneId
dailyRewardState
streakState
dailyChallengeState
notificationPreferenceSummary
serverNow
```

Useful for one coarse-grained Home refresh.

---

# 63. Cost-Conscious Read Strategy

Prefer:
- one Daily state fetch on Home/resume;
- local cache;
- targeted writes on claim/activity.

Avoid:
- many real-time listeners;
- per-minute countdown reads.

---

# 64. Local Daily Cache

Drift may store:

```text
daily_state_cache
daily_challenge_cache
notification_preferences
```

Include:
- fetchedAt;
- dayKey;
- timezone;
- revision.

---

# 65. Day Change Detection

Client detects possible local day change and refreshes backend state when online.

Backend confirms.

Do not self-grant on local midnight.

---

# 66. App Resume Behavior

On resume:

1. determine if local day may have changed;
2. refresh Daily state if online;
3. invalidate old challenge if necessary;
4. update Home cards;
5. do not interrupt active Main Journey gameplay.

---

# 67. Daily Challenge During Midnight

If player is actively playing Daily Challenge across midnight:

Product behavior needs determinism.

Recommended v1:
- challenge attempt remains playable until it ends locally, but reward eligibility is checked against backend and may expire.

However this UX policy is not explicitly locked.

If implementation needs hard behavior, mark TBD and avoid silent permanent choice.

---

# 68. Reward Claim Time

Daily Reward:
- claim based on current validated day.

Daily Challenge:
- first completion within active challenge eligibility window.

Streak:
- based on qualifying activity day.

---

# 69. Daily Reward UI States

```text
loading
available
claimedToday
offlineUnavailable
error
```

---

# 70. Daily Challenge UI States

```text
loading
available
inProgress
completed
expired
offlineUnavailable
error
```

---

# 71. Streak UI States

```text
noStreak
active
qualifiedToday
atRisk
brokenRecently
```

Do not overcomplicate if not needed.

---

# 72. Streak Broken Event

If previous streak breaks:
- update state on next backend evaluation;
- optionally show subtle message.

Do not punish with Coin loss.

---

# 73. Streak Milestone Presentation

On milestone reward:
- show celebratory local UI;
- backend grant receipt updates Wallet.

Do not grant locally without receipt.

---

# 74. Daily Reward Presentation

On successful claim:
- animate reward;
- update Wallet;
- show next Day preview.

---

# 75. Daily Challenge Result

On first completion:
- show:
  - challenge complete;
  - +150 Coins;
  - streak qualification if applicable.

Repeated completion:
- no second reward.

---

# 76. Daily Challenge and Streak Relationship

Completing Daily Challenge may count as Daily Activity qualification.

This is sensible and should be wired through `markDailyActivity` or equivalent.

Do not create duplicate streak increments from:
- Level completion + Daily Challenge + Reward claim same day.

Same day counts once.

---

# 77. Main Journey and Streak

Completing a Main Journey Level can also qualify Daily Activity.

This gives broad participation.

Recommended:
- first qualifying gameplay completion of day marks activity.

Do not require Daily Challenge specifically.

---

# 78. Rewarded Ads and Daily Streak

Watching an ad alone should not qualify a Daily gameplay streak.

Do not let monetization action count as gameplay activity unless explicitly approved.

---

# 79. Daily Reward and Daily Streak

Claiming Daily Reward alone could be considered engagement, but gameplay-streak semantics are stronger if based on gameplay activity.

Keep implementation aligned with the chosen qualification event.

If not explicitly approved, treat `eligible gameplay activity` as Sprint 9 baseline and document.

---

# 80. Backend Daily Service

Recommended domain service:

```text
DailyService
├── resolveDayKey
├── getRewardState
├── claimReward
├── markActivity
├── updateStreak
├── evaluateMilestones
├── getChallenge
└── claimChallengeReward
```

---

# 81. Economy Integration

All rewards route through Sprint 7 Wallet service.

Do not mutate Wallet directly in Daily code.

Examples:
- Daily Reward;
- Streak milestone;
- Daily Challenge reward.

Use idempotency keys.

---

# 82. Daily Reward Idempotency Keys

Examples:

```text
daily_reward:{uid}:{dayKey}
daily_streak:{uid}:{streakCycleId}:{milestone}
daily_challenge:{uid}:{challengeId}
```

---

# 83. Daily Challenge Fingerprint

Store challenge reproduction metadata:

```text
challengeId
seed
generatorVersion
solverVersion
rulesVersion
boardFingerprint
contentBundleVersion
```

Useful for QA.

---

# 84. Daily Challenge Seed Security

Seed itself need not be secret.

Fairness depends on same board, not secrecy.

Do not rely on obscurity.

---

# 85. Challenge Prevalidation

Recommended operational process:

- pre-generate upcoming challenge definitions;
- Solver validate;
- store approved seed/config;
- activate per day.

Avoid generating expensive random challenge on every player request.

---

# 86. Upcoming Challenge Horizon

Could precompute:
- 7–30 days.

Exact horizon is operational/TBD.

Do not overbuild scheduler.

---

# 87. Challenge Fallback

If today's challenge config invalid/unavailable:
- disable Daily Challenge safely;
- do not substitute random unvalidated board silently.

Fallback can use last-known approved emergency challenge only if explicitly configured.

---

# 88. Daily Content Versioning

Challenge definition references content bundle version.

If client lacks required content:
- attempt download later when remote content delivery exists;
- for Sprint 9, use bundled/available approved content.

---

# 89. Notification Scheduler Failure

If push scheduling fails:
- Daily systems still work;
- no reward impact.

Notifications are engagement helpers, not authority.

---

# 90. FCM Token Security

Client may register/update its own device token.

Rules/backend should prevent:
- user A registering token under user B.

---

# 91. Device Cleanup

If FCM reports invalid token:
- mark/remove token.

Avoid repeated send errors.

---

# 92. Notification Preferences Sync

Preferences sync through Sprint 6 settings flow.

Server checks before scheduling.

---

# 93. Quiet Hours and Timezone Change

When timezone changes:
- notification schedule updates.

Do not send based on stale timezone indefinitely.

---

# 94. Analytics

Track:

## Daily Reward
- daily_reward_viewed
- daily_reward_claim_started
- daily_reward_claimed
- daily_reward_claim_failed

## Daily Streak
- daily_activity_qualified
- daily_streak_incremented
- daily_streak_broken
- daily_streak_milestone

## Daily Challenge
- daily_challenge_opened
- daily_challenge_started
- daily_challenge_retried
- daily_challenge_completed
- daily_challenge_reward_claimed

## Notifications
- notification_permission_prompted
- notification_permission_result
- daily_challenge_notification_sent
- streak_risk_notification_sent
- notification_opened

---

# 95. Privacy

Do not store:
- precise location;
- unnecessary travel history.

Timezone is sufficient.

Do not infer geolocation from notifications.

---

# 96. Emulator/Test Time Abstraction

Create injectable clock/time service for backend and client tests.

Never use hard-wired `DateTime.now()` everywhere.

Tests must simulate:
- midnight;
- DST;
- timezone changes;
- missed days.

---

# 97. DST Handling

Use timezone-aware date calculation.

Do not assume every day is exactly 24 hours.

Daily key is calendar-date based in timezone.

---

# 98. Daily Reward Test Matrix

Required:

- Day 1 claim;
- Day 2 next day;
- missed 3 days -> next reward still next calendar index;
- Day 7 -> loops to Day 1;
- duplicate same-day claim;
- timezone change;
- offline unavailable;
- wallet grant idempotent.

---

# 99. Daily Streak Test Matrix

Required:

- first qualifying day -> streak 1;
- same day second activity -> still 1;
- next consecutive day -> 2;
- missed day -> reset to 1;
- milestone 3 grant;
- milestone 7 grant;
- duplicate milestone evaluation no duplicate reward;
- timezone manipulation attempt;
- DST transition.

---

# 100. Daily Challenge Test Matrix

Required:

- same day/cohort -> same seed/board;
- next day -> different challenge;
- unlimited retries same board;
- first completion grants 150;
- second completion no reward;
- offline cached play;
- expired challenge handling;
- duplicate reward claim;
- Solver validation.

---

# 101. Notification Test Matrix

Required:

- Daily Challenge eligible notification;
- disabled preference suppresses;
- quiet hours suppress/delay;
- Streak Risk only when at risk;
- qualified day suppresses Streak Risk;
- stale token cleanup;
- expired notification deep link safe.

---

# 102. Integration Scenario — Daily Reward

### DA-001

1. login online.
2. open Home.
3. Daily Reward Day 1 available.
4. claim.
5. +100 Coins authoritative.
6. reload app same day.
7. claim disabled.
8. return two days later.
9. next reward is Day 2, not reset.

---

# 103. Integration Scenario — Daily Streak

### DA-002

1. complete eligible gameplay on Day 1.
2. streak = 1.
3. complete on Day 2.
4. streak = 2.
5. complete on Day 3.
6. streak = 3.
7. +100 Coins milestone granted once.
8. miss Day 4.
9. play Day 5.
10. streak resets to 1.

---

# 104. Integration Scenario — Daily Challenge

### DA-003

1. open Challenge.
2. deterministic board loads.
3. fail/restart.
4. same board reloads.
5. complete.
6. +150 Coins granted once.
7. replay challenge.
8. no second reward.

---

# 105. Integration Scenario — Offline Challenge

### DA-004

1. challenge cached while online.
2. go offline.
3. play and complete.
4. local state marks pending completion.
5. reconnect.
6. backend validates claim.
7. +150 Coins once.

---

# 106. Integration Scenario — Timezone Abuse

### DA-005

1. claim reward.
2. rapidly switch device timezone forward.
3. backend sees insufficient trusted elapsed time / suspicious change.
4. second immediate claim denied.
5. legitimate later claim succeeds.

---

# 107. Integration Scenario — Notifications

### DA-006

1. user enables Daily Challenge + Streak Risk notifications.
2. Daily Challenge notification sent outside quiet hours.
3. user does not qualify streak by evening.
4. Streak Risk notification scheduled before quiet hours.
5. after activity qualifies, no additional risk notification sent.

---

# 108. Offline Regression

With no network:
- Main Journey still works.
- active Attempt works.
- Wallet cache works.
- Daily cached info can display.
- Daily Reward claim does not fake success.
- cached Daily Challenge may remain playable.
- no notification dependency blocks app.

---

# 109. Firestore Security Rules

Client may read own Daily state if architecture uses readable docs.

Client must not directly write:
- authoritative Daily Reward claim result;
- streak milestone grant;
- Daily Challenge reward status;
- notification send records.

Trusted backend owns authority.

---

# 110. Backend Scheduled Jobs

Potential jobs:

- Daily Challenge activation/validation.
- Notification scheduling/fanout.
- stale FCM token cleanup.

Use Cloud Scheduler + Functions/Run as needed.

No always-on worker.

---

# 111. Cost-Conscious Design

Avoid:
- one scheduled job per user;
- continuous listeners;
- per-minute polling.

Prefer:
- timezone buckets;
- batch evaluation;
- on-demand Daily state fetch;
- coarse-grained writes.

---

# 112. Daily Home Refresh

Recommended:
- fetch on app resume/Home open if stale;
- cache for current day.

Do not refetch every widget rebuild.

---

# 113. Local Countdown

Time remaining can update locally every minute/second without backend reads.

At boundary:
- refresh authoritative state.

---

# 114. Failure UX

Daily Reward:
```text
تعذر استلام المكافأة الآن
```

Daily Challenge:
```text
تعذر تحميل تحدي اليوم
```

Notification permission:
- explain, don't nag repeatedly.

---

# 115. Developer Tools

DEV-only:
- override test clock;
- set timezone;
- simulate day advance;
- reset Daily Reward state in emulator;
- set streak count;
- force milestone;
- load challenge by day key;
- trigger test notification.

Never expose in PROD.

---

# 116. Suggested Client Structure

```text
apps/mobile/lib/features/daily/
├── application/
├── domain/
├── data/
└── presentation/
```

Sub-features:
- reward;
- streak;
- challenge;
- notifications.

---

# 117. Suggested Backend Structure

```text
firebase/functions/src/daily/
├── daily_state.ts
├── claim_daily_reward.ts
├── mark_daily_activity.ts
├── daily_streak.ts
├── get_daily_challenge.ts
├── claim_daily_challenge.ts
├── timezone_service.ts
└── daily_config.ts

firebase/functions/src/notifications/
├── register_device.ts
├── schedule_daily_notifications.ts
├── send_daily_challenge.ts
├── send_streak_risk.ts
└── token_cleanup.ts
```

---

# 118. Suggested Implementation Order

## Step 1
Trusted time/timezone service.

## Step 2
Daily Reward state + claim.

## Step 3
Daily Streak qualification.

## Step 4
Streak milestone grants.

## Step 5
Daily state API.

## Step 6
Daily Challenge definition model.

## Step 7
Deterministic challenge seed/config.

## Step 8
Challenge local UI/gameplay integration.

## Step 9
Challenge completion reward.

## Step 10
Local Daily cache.

## Step 11
FCM token registration.

## Step 12
Notification preferences.

## Step 13
Daily Challenge notifications.

## Step 14
Streak Risk notifications.

## Step 15
Quiet hours.

## Step 16
Timezone abuse protections.

## Step 17
Emulator/timezone tests.

## Step 18
Cost/performance review.

---

# 119. Suggested Commit Sequence

### Commit 1
```text
feat(daily): add trusted player-local day and timezone service
```

### Commit 2
```text
feat(daily): add backend-authoritative daily reward calendar
```

### Commit 3
```text
feat(daily): add daily activity and streak tracking
```

### Commit 4
```text
feat(daily): add idempotent streak milestone rewards
```

### Commit 5
```text
feat(daily): add deterministic daily challenge definitions
```

### Commit 6
```text
feat(daily): integrate daily challenge gameplay and reward
```

### Commit 7
```text
feat(daily): add local cache and offline challenge reconciliation
```

### Commit 8
```text
feat(notifications): add fcm device registration and preferences
```

### Commit 9
```text
feat(notifications): add daily challenge and streak risk scheduling
```

### Commit 10
```text
feat(notifications): enforce player-local quiet hours
```

### Commit 11
```text
test(daily): add date timezone dst challenge and idempotency coverage
```

### Commit 12
```text
docs(daily): document daily systems and notification authority
```

---

# 120. Sprint 9 Definition of Done

Sprint 9 is DONE only when:

- [ ] 7-day Daily Reward schedule implemented.
- [ ] Day 1 = 100 Coins.
- [ ] Day 2 = 125 Coins.
- [ ] Day 3 = 150 Coins.
- [ ] Day 4 = 1 Hint.
- [ ] Day 5 = 175 Coins.
- [ ] Day 6 = 200 Coins.
- [ ] Day 7 = 300 Coins + 1 Hint.
- [ ] missing a day does not reset Daily Reward calendar.
- [ ] Daily Reward backend-authoritative.
- [ ] duplicate Daily Reward claim idempotent.
- [ ] Daily Reward loops Day 7 → Day 1.
- [ ] Daily Streak implemented.
- [ ] missed day breaks Daily Streak.
- [ ] 3-day milestone = 100 Coins.
- [ ] 7-day milestone = 250 Coins.
- [ ] 14-day milestone = 400 Coins.
- [ ] 30-day milestone = 750 Coins.
- [ ] milestone grants idempotent.
- [ ] one same-day activity increments streak only once.
- [ ] Daily Challenge implemented.
- [ ] deterministic board per day/cohort.
- [ ] unlimited retries same board.
- [ ] first completion reward = 150 Coins.
- [ ] repeated completion grants nothing.
- [ ] fixed Daily Challenge board preserved on retry.
- [ ] cached offline challenge can be played.
- [ ] queued offline completion reconciles safely.
- [ ] validated player-local 00:00 day boundary implemented.
- [ ] device clock not authoritative.
- [ ] timezone changes tracked.
- [ ] obvious timezone farming mitigated.
- [ ] DST/date edge cases tested.
- [ ] FCM device registration works.
- [ ] Daily Challenge notification works.
- [ ] Streak Risk notification works.
- [ ] quiet hours 22:00–09:00 local enforced.
- [ ] notification preferences enforced.
- [ ] stale/invalid FCM token handling exists.
- [ ] notification deep links safe.
- [ ] Daily operations use Wallet service.
- [ ] no direct client reward grants.
- [ ] DA-001 passes.
- [ ] DA-002 passes.
- [ ] DA-003 passes.
- [ ] DA-004 passes.
- [ ] DA-005 passes.
- [ ] DA-006 passes.
- [ ] offline core regression passes.
- [ ] Flutter analyze passes.
- [ ] backend tests pass.
- [ ] emulator tests pass.

---

# 121. Sprint 9 Exit Gate Before Content Operations

Do not start Sprint 10 until:

1. Daily Reward is exactly-once and authoritative.
2. Daily Reward missed-day behavior is correct.
3. Daily Streak resets correctly.
4. milestone grants are idempotent.
5. Daily Challenge is deterministic.
6. Challenge reward is first-completion only.
7. timezone/day-boundary logic is tested.
8. obvious timezone farming is mitigated.
9. FCM token lifecycle works.
10. quiet hours are enforced.
11. notification preferences are respected.
12. offline Main Journey remains unaffected.
13. Daily systems remain cost-conscious.
14. Wallet integration remains authoritative.

---

# 122. Cursor Execution Prompt — Sprint 9

Use this after Sprint 8 passes its exit gate:

> Implement **Sprint 9 — Daily Reward, Daily Challenge, Streak & Notifications v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_9_Daily_Reward_Daily_Challenge_Streak_and_Notifications_v1.0.md`
> - latest Game Economy Design
> - latest Progression Design
> - latest Analytics/KPI Specification
> - latest Firebase/Cloud Architecture
> - latest Notification-related decisions
>
> Implement the approved Daily engagement systems.
>
> Implement:
>
> - 7-day repeating Daily Reward:
>   - D1 100 Coins
>   - D2 125
>   - D3 150
>   - D4 1 Hint
>   - D5 175
>   - D6 200
>   - D7 300 Coins + 1 Hint
> - missed day does not reset Daily Reward calendar;
> - backend-authoritative Daily Reward eligibility;
> - Daily Streak;
> - missed day breaks streak;
> - streak milestones:
>   - 3d 100 Coins
>   - 7d 250
>   - 14d 400
>   - 30d 750
> - idempotent milestone grants;
> - Daily Challenge;
> - deterministic board per day/cohort;
> - unlimited retries;
> - first completion reward exactly 150 Coins;
> - validated player-local day boundary at 00:00;
> - trusted server time;
> - timezone change handling/abuse mitigation;
> - cached/offline Daily Challenge play where definition is available;
> - queued completion reconciliation;
> - FCM device token management;
> - Daily Challenge notification;
> - Streak Risk notification;
> - notification preferences;
> - quiet hours 22:00–09:00 player-local time;
> - notification deep links;
> - analytics;
> - emulator/timezone/DST tests.
>
> Critical constraints:
>
> - device clock is not authoritative;
> - Daily rewards use trusted Wallet service;
> - no direct client Coin/Hint grant;
> - Daily Reward missed-day behavior must not reset calendar;
> - Daily Streak must reset on missed day;
> - same day must not increment streak twice;
> - Daily Challenge retry must use the same deterministic board;
> - repeated Daily Challenge completion must not grant reward twice;
> - notification systems must not affect reward eligibility;
> - quiet hours must be respected;
> - do not create always-on infrastructure;
> - Main Journey must remain playable offline;
> - do not add Events/Leaderboards/XP/Achievements/Packs in this sprint.
>
> Use an injectable clock/timezone abstraction for deterministic tests.
>
> At completion report:
>
> 1. files created/changed;
> 2. Daily Reward state/claim model;
> 3. Daily Streak qualification and milestone logic;
> 4. Daily Challenge seed/cohort model;
> 5. timezone/day-boundary implementation;
> 6. timezone abuse mitigation;
> 7. offline challenge reconciliation;
> 8. FCM/token architecture;
> 9. notification scheduling/quiet-hour logic;
> 10. idempotency keys;
> 11. emulator/timezone/DST tests;
> 12. observed Firebase reads/writes for Daily flows;
> 13. analyze/test/build results;
> 14. unresolved Daily/notification product decisions;
> 15. any deviations from this Sprint document and why.

---

# 123. Next Sprint

After Sprint 9 passes the exit gate:

# **Sprint 10 — Content Bundles, CMS Integration & Publishing Pipeline v1**

Expected focus:

- versioned content bundle schema;
- bundled + remote content;
- Firebase Storage delivery;
- manifest;
- checksum/hash validation;
- atomic activation;
- last-known-valid rollback;
- content compatibility;
- production disable switch;
- CMS-to-bundle publishing contract;
- content QA pipeline;
- Arabic/semantic approval state;
- first production-ready Journey content ingestion workflow.

---

**End of Sprint 9 — Daily Reward, Daily Challenge, Streak & Notifications v1**
