# LiveOps & Events Design
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Game Economy Design v1.0 + related product/architecture specs  
**Important:** Daily systems at launch (P0), notification quiet hours, and first Event constraints listed as **APPROVED** in Final Decision Register v1.1 are **CONFIRMED**. Temporary Events remain **Post-launch**. Exact Event reward amounts beyond first-Event constraints and Firebase/GCP quotas remain **TBD** where noted.

---

# 1. Purpose

This document defines the LiveOps and Events framework for the Arabic Solitaire Association game.

It covers:

- Temporary Events.
- Permanent Special Packs.
- Daily Challenge.
- Daily Reward.
- Daily Streak.
- Content refreshes.
- Seasonal content.
- Regional/cultural content.
- Dialect content.
- Event progression.
- Event rewards.
- Event difficulty.
- Event scheduling.
- Event eligibility.
- Event discovery.
- Notifications.
- Remote Config.
- Content publication.
- Event analytics.
- Event operations.
- CMS/Admin support.
- Event QA.
- Rollback.
- Incident handling.
- Monetization guardrails.
- Post-MVP LiveOps roadmap.

The objective is to create a repeatable operational system for keeping the game fresh without changing the core gameplay rules every week.

---

# 2. LiveOps Principles

LiveOps should follow these principles:

1. Core Main Journey remains stable and evergreen.
2. Temporary content should not be required to understand the base game.
3. Events should primarily add content, progression, and rewards rather than new core mechanics.
4. Strongly local/dialect content is better suited to Packs/Events than Main Journey.
5. Current/trending content belongs outside evergreen Main Journey.
6. Event content must use the same human-review quality bar.
7. Event boards must still be Solver-valid.
8. Event rewards must not destabilize the Coin economy.
9. Events must be versioned and remotely controllable.
10. Broken events must be disable-able without an app release.
11. Event participation should be optional.
12. Events must not create pay-to-win pressure.
13. LiveOps must be measurable.
14. Event cadence must respect team/content-production capacity.
15. Do not overbuild a LiveOps system before the base game is stable.

---

# 3. Confirmed Product Direction

The following are **CONFIRMED**:

- Temporary Events are **Post-launch** (after Daily systems and core metrics are stable).
- Permanent Special Packs are Full Product / Post-MVP.
- Dialect/regional content belongs primarily in Packs/Events.
- Time-sensitive/current content belongs primarily in Events/Packs.
- Daily Reward, Daily Challenge, Daily Streak are **P0 at initial launch**.
- Smart Notification infrastructure is included at launch.
- Initially active notification types: **Daily Challenge** and **Streak Risk**.
- Notification quiet hours: **22:00–09:00** player-local time.
- Leaderboards are Full Product / DEFERRED for MVP.
- Main Journey remains evergreen and mixed-content.
- Events/Packs should reuse the same core Game Engine wherever possible.
- Human approval remains mandatory for content.
- Core gameplay rules should not be forked casually for Events.

---

# 4. LiveOps Content Types

The LiveOps system may eventually support:

1. Daily Challenge.
2. Temporary Event.
3. Seasonal Event.
4. Cultural Event.
5. Regional Event.
6. Dialect Event.
7. Topic Event.
8. Limited-time Challenge Series.
9. Permanent Special Pack.
10. Content Refresh.
11. Reward Campaign.
12. Notification Campaign.

Not all need to launch together.

---

# 5. Event vs Pack

## Temporary Event

Has:

- Start time.
- End time.
- Event-specific progression/reward.
- Optional event-specific content.

## Permanent Pack

Has:

- No expiration.
- Specialized content.
- Separate progression if desired.
- Optional unlock policy.

Examples:

- Egyptian dialect.
- Gulf terms.
- Arabic wordplay.
- Geography.
- Ramadan cultural content as permanent knowledge Pack only if appropriate.

---

# 6. Main Journey Boundary

**CONFIRMED**

Main Journey should not become a LiveOps feed.

It remains:

- Endless.
- evergreen-focused.
- mixed-topic.
- stable.

LiveOps should complement Main Journey, not replace it.

---

# 7. Event Architecture Principle

**PROPOSED**

Represent an Event primarily as data/configuration.

Event definition may specify:

- content pool.
- level list/configurations.
- start/end.
- rewards.
- eligibility.
- presentation.
- notification hooks.
- analytics tags.

Avoid event-specific hard-coded logic where possible.

---

# 8. EventDefinition Entity

**PROPOSED**

Suggested fields:

- `event_id`
- `event_key`
- `event_type`
- `title_key`
- `description_key`
- `start_at`
- `end_at`
- `timezone_policy`
- `status`
- `content_bundle_version`
- `event_progression_id`
- `reward_config_id`
- `eligibility_rule_id`
- `presentation_config_id`
- `notification_config_id`
- `rules_version`
- `version`

---

# 9. Event Status

**PROPOSED**

Potential values:

- DRAFT
- SCHEDULED
- ACTIVE
- PAUSED
- COMPLETED
- CANCELLED
- ARCHIVED

---

# 10. Event Time Handling

Backend time should be authoritative.

Use UTC persistence.

Event display converts to local time.

Exact timezone eligibility policy remains **TBD**.

---

# 11. Event Scheduling

**PROPOSED**

Events should be schedulable in advance.

Scheduler should support:

- activation.
- deactivation.
- notification triggers.
- content publication.
- reward windows.

Manual emergency override remains available.

---

# 12. Event Duration

No event duration is approved.

**PROPOSED categories:**

- Micro Event: 1–3 days.
- Short Event: 4–7 days.
- Standard Event: 1–2 weeks.
- Seasonal Event: 2–4 weeks.

These are planning labels only.

---

# 13. Event Cadence

No cadence is approved.

**PROPOSED early LiveOps approach:**

- Daily Challenge: daily.
- Daily Reward/Streak: daily.
- Temporary Event: relatively infrequent at first.
- Permanent Pack: released when content quality/capacity allows.

Avoid running too many overlapping events in early product stages.

---

# 14. Event Overlap

**CONFIRMED — Final Decision Register v1.1**

Initially **max one major Event active at a time**.

Reasons:

- UI clutter.
- content-production burden.
- notification fatigue.
- economy inflation.
- analytics ambiguity.

---

# 15. Event Types by Purpose

Events may target:

## Engagement
Bring players back.

## Content Discovery
Introduce new relations/content.

## Progression Variety
Offer alternate progression.

## Cultural Relevance
Serve regional/seasonal interests.

## Challenge
Offer higher difficulty.

## Retention
Create return reasons.

Monetization is secondary, not the sole purpose.

---

# 16. Seasonal Events

Potential examples:

- Ramadan.
- Eid.
- Summer.
- Back-to-school.
- New Year.

Any cultural/religious Event content requires careful editorial review.

No specific Event is approved by this document.

---

# 17. Regional Events

Potential examples:

- Egypt culture.
- Gulf culture.
- Levant.
- Maghreb.

These can use:

- regional foods.
- places.
- vocabulary.
- cultural knowledge.

Avoid stereotypes.

---

# 18. Dialect Events

May use intentionally dialect-specific content.

Should clearly label:

- region/dialect.
- expected language style.

A player opting in should know the specialization.

---

# 19. Topic Events

Potential:

- Geography.
- Science.
- Sports history.
- Food.
- Language.
- Arabic wordplay.

Current/trending sports or celebrity content requires recency review.

---

# 20. Evergreen vs Time-Sensitive Events

Event content can be:

- Evergreen.
- Semi-evergreen.
- Contemporary.
- Seasonal.

Time-sensitive content should include:

- expiry review date.
- disable date.
- content owner.

---

# 21. Event Content Review

Every Event content item must pass:

- Arabic review.
- semantic review.
- duplicate review.
- cultural review where needed.
- Solver/Level validation.
- final approval.

AI-generated drafts never auto-publish.

---

# 22. Event Content Bundle

**PROPOSED**

Each Event may reference a versioned Event Content Bundle containing:

- Associations.
- Members.
- Variants.
- Level configs.
- assets.
- localized copy.

This supports rollback and cache.

---

# 23. Event Content Isolation

Keep Event content logically separate from Main Journey eligibility.

A current celebrity Association should not accidentally leak into evergreen Main Journey because it exists in the same CMS.

Use scope tags/eligibility.

---

# 24. Event Scope Tags

**PROPOSED**

Content may be tagged:

- MAIN_JOURNEY
- DAILY
- EVENT
- PACK
- TUTORIAL

A content item may support multiple scopes if approved.

---

# 25. Event Level Design

Events should reuse:

- Game Engine.
- Solver.
- Difficulty Model.
- Level Configuration.

Event-specific difference comes from:

- content.
- progression.
- reward.
- presentation.

---

# 26. Event Core Rules

**CONFIRMED direction**

Do not change core rules merely for Event novelty.

Examples of core behavior that should stay stable:

- atomic stacks.
- Stock behavior.
- Association activation.
- Move cost.
- win condition.

Any true mechanic modifier requires explicit future approval and a Rules version.

---

# 27. Event Difficulty

Events may define their own B/S difficulty curve.

Examples:

- Casual Event → lower Board, medium Semantic.
- Expert Wordplay Event → medium Board, high Semantic.
- Strategic Event → high Board, easy Semantic.

Same B/S framework should be reused.

---

# 28. Event Difficulty Profile

**PROPOSED**

EventDefinition may specify:

- target Board range.
- target Semantic range.
- allowed ambiguity.
- allowed relation types.
- group-size profile.
- Move-Limit profile.

---

# 29. Event Progression

Possible structures:

1. Linear Levels.
2. Milestone Track.
3. Score accumulation.
4. Completion count.
5. Daily stages.

**PROPOSED recommendation:**
Start with simple linear Event Levels.

---

# 30. Linear Event Progression

Example:

`Event Level 1 → 2 → 3 → ... → N`

Advantages:

- simple.
- familiar.
- reuses Main Journey patterns.
- easy analytics.

First Event Level count is **CONFIRMED** at **10 Levels**. Later Events may use other sizes.

---

# 31. Event Milestones

**PROPOSED**

Milestones may grant rewards after:

- X Event Levels.
- Event completion.
- specific challenge.

Keep milestone structure simple in early LiveOps.

---

# 32. Event Rewards

Potential rewards:

- Coins.
- Hints.
- Cosmetic item later.
- Badge later.
- Collection item later.

No premium currency.

---

# 33. Event Reward Guardrail

Event rewards must not make normal economy irrelevant.

Before publishing:

- simulate Coin injection.
- compare Daily/Main Journey income.
- review resource inflation.

---

# 34. Event Completion Reward

No value approved.

**PROPOSED**

Event may grant:

- per-Level normal reward.
- optional Event completion reward.

Exact amounts require Economy approval.

---

# 35. Event Reward Claim

**PROPOSED**

Prefer automatic grant for simple Level-completion rewards.

Milestone reward may use explicit Claim only if it improves clarity.

Avoid unnecessary claim friction.

---

# 36. Event Currency

**CONFIRMED for first Event / early LiveOps**

No event-specific currency.

Do not introduce temporary tokens without explicit decision.

Use existing Coins/Hints. First Event: no new currency, no leaderboard.

---

# 37. Event Pass

No paid Event Pass is approved.

Do not assume Battle Pass / Season Pass.

---

# 38. Event Monetization

Current approved monetization remains:

- Rewarded Ads.
- Interstitials.
- Coin Packs.
- Remove Ads.

Events should not automatically introduce new purchase types.

---

# 39. Interstitials in Events

**PROPOSED**

Use same adaptive ad eligibility service.

Do not increase ad pressure just because player enters Event.

---

# 40. Rewarded Ads in Events

Can support same utilities:

- Hints.
- Extra Moves.
- Rescue.

If Event uses normal gameplay.

---

# 41. Remove Ads in Events

Remove Ads entitlement should apply consistently to applicable Interstitials in Event flows.

---

# 42. Event Entry Point

Potential surfaces:

- Home card.
- Events Hub.
- notification deep link.
- completion screen promo.

Exact navigation depends on final UX.

---

# 43. Events Hub

**CONFIRMED Full Product surface concept**

May show:

- active Events.
- upcoming Events.
- completed/recent Events.
- permanent Packs link.

MVP does not need Events Hub if Events are Post-MVP.

---

# 44. Event Card

**PROPOSED**

Display:

- title.
- artwork.
- time remaining.
- progress.
- primary CTA.
- reward preview.

Avoid overly dense cards.

---

# 45. Event Detail Screen

Potential sections:

- title/art.
- event description.
- progress.
- Level list.
- rewards.
- time remaining.
- rules/help if special.

---

# 46. Event Discovery

Player should be able to understand:

- what Event is.
- how long it lasts.
- how to progress.
- what rewards exist.

without reading long instructions.

---

# 47. Event Eligibility

Possible criteria:

- minimum Journey Level.
- completed tutorial.
- app version.
- country/region.
- content locale.
- feature flag.

No player-spend/payer eligibility should affect core Event access unless explicitly approved.

---

# 48. Proposed Minimum Progress Eligibility

**PROPOSED**

Require tutorial completion before major Events.

Reason:

Player should understand the base rules.

Exact minimum Journey Level TBD.

---

# 49. Regional Eligibility

Regional Events may be:

- globally visible.
- region-targeted.
- opt-in.

Avoid using precise location.

Country/locale may be enough if needed.

---

# 50. App Version Eligibility

Event content requiring new schema/assets may set:

- minimum app version.

Older clients should not receive incompatible Event.

---

# 51. Event Enrollment

**PROPOSED**

Simple Events should not require explicit registration.

Opening/starting Event creates PlayerEventProgress automatically.

---

# 52. PlayerEventProgress Entity

Suggested fields:

- `player_id`
- `event_id`
- `status`
- `current_level`
- `completed_levels`
- `milestones_claimed`
- `started_at`
- `completed_at?`
- `last_played_at`

---

# 53. Event Status per Player

**PROPOSED**

- AVAILABLE
- IN_PROGRESS
- COMPLETED
- EXPIRED

---

# 54. Event Expiry

When Event expires:

- new Event Levels cannot be started.
- existing active Event Attempt policy must be defined.
- unclaimed rewards policy must be defined.

These are **TBD**.

---

# 55. Active Attempt at Event Expiry

Possible policies:

A. Allow current Attempt to finish.
B. End immediately.
C. Grace period.

**PROPOSED recommendation:**
Allow current in-progress Attempt to finish if it started before expiry, within a short bounded grace window.

Needs approval.

---

# 56. Unclaimed Event Rewards

Possible policies:

- auto-grant earned rewards.
- expire unclaimed rewards.
- claim grace period.

**PROPOSED recommendation:**
Auto-grant already-earned rewards where technically safe.

---

# 57. Event Replay

Possible:

- unlimited replay of completed Event Levels.
- no reward on replay.
- best score tracking later.

Exact behavior TBD.

---

# 58. Event Failure / Restart

Reuse normal Main Journey rules:

- no Lives.
- Restart available.
- new shuffle if Event uses randomized board.
- same Event Level content/config.

Daily Challenge is separate because shared board may be deterministic.

---

# 59. Deterministic Event Boards

**PROPOSED**

Some competitive/challenge Events may use fixed shared boards.

Only needed where fairness/comparison matters.

Normal Events can remain randomized and Solver-validated.

---

# 60. Daily Challenge Role in LiveOps

**CONFIRMED**

Daily Challenge is the smallest recurring LiveOps unit.

It should:

- refresh daily.
- provide one puzzle.
- use shared/fixed conditions.
- provide special reward.
- create a daily return reason.

---

# 61. Daily Challenge Lifecycle

**PROPOSED**

```text
Generate
→ Solver Validate
→ Publish
→ Active for Day
→ Complete/Expire
→ Archive Metrics
```

---

# 62. Daily Challenge Content

May use:

- Main Journey-quality content.
- curated semantic mix.
- occasional special relation types.

Should not depend on unreviewed trending content.

---

# 63. Daily Challenge Difficulty

No exact difficulty approved.

**PROPOSED**

Prefer medium challenge with occasional harder days rather than random extreme spikes.

---

# 64. Daily Challenge Reward

**CONFIRMED — Final Decision Register v1.1**

Daily Challenge reward: **150 Coins** (auto-granted on first completion).

Unlimited retries during the valid day. Backend authoritative for Daily time/eligibility. Reset: 00:00 validated player-local timezone.

---

# 65. Daily Reward Role

**CONFIRMED**

Daily Reward provides recurring return motivation.

It should remain simple and understandable.

---

# 66. Daily Reward Calendar

**CONFIRMED — Final Decision Register v1.1**

7-day repeating calendar:

| Day | Reward |
|---|---|
| 1 | 100 Coins |
| 2 | 125 Coins |
| 3 | 150 Coins |
| 4 | 1 Hint |
| 5 | 175 Coins |
| 6 | 200 Coins |
| 7 | 300 Coins + 1 Hint |

Missing a day does not reset Daily Reward progression. LiveOps must still support configurable calendars without app release.

---

# 67. Daily Streak Role

**CONFIRMED — Final Decision Register v1.1**

Daily Streak rewards consecutive activity.

- Daily Streak breaks after a missed day.
- Milestone rewards: 3→100, 7→250, 14→400, 30→750 Coins.
- Should encourage return without permanent punishment framing after one miss.

---

# 68. Daily Systems Coordination

Avoid stacking too many mandatory-looking claims.

Potential flow:

Home:
- Daily Reward available.
- Daily Challenge card.
- Streak status.

Keep Main Journey Continue as strongest core action.

---

# 69. LiveOps Calendar

**PROPOSED**

Maintain an operational calendar containing:

- Daily Challenges.
- temporary Events.
- seasonal content.
- content bundle releases.
- notification campaigns.
- economy config changes.
- experiments.

---

# 70. Calendar Ownership

Potential owners:

- Product/LiveOps.
- Content Lead.
- Game Design.
- Marketing.

Small team may combine roles.

One person should own final publish coordination.

---

# 71. Event Planning Lead Time

No SLA approved.

**PROPOSED**

Event planning should include enough time for:

1. theme selection.
2. content generation.
3. human review.
4. Level design.
5. Solver simulation.
6. QA.
7. localization.
8. asset production.
9. scheduling.
10. analytics setup.

---

# 72. Event Production Workflow

```text
Event Brief
→ Content Plan
→ Content Draft
→ Human Review
→ Level Config
→ Solver Validation
→ Playtest
→ Reward/Economy Review
→ Asset/UI Review
→ Analytics Setup
→ Publish to Staging
→ QA
→ Schedule Production
```

---

# 73. Event Brief

**PROPOSED**

Each Event should define:

- objective.
- target audience.
- theme.
- start/end.
- content scope.
- progression.
- difficulty.
- reward budget.
- monetization behavior.
- notifications.
- success metrics.
- rollback plan.

---

# 74. Event Objective

Every Event should have one primary objective.

Examples:

- retention.
- content discovery.
- reactivation.
- cultural relevance.
- challenge.

Avoid vague "because we need an Event."

---

# 75. Event Success Metrics

Possible primary metrics:

- participation rate.
- completion rate.
- return rate.
- Event Levels completed.
- reactivation.

Monetization may be secondary metric unless Event was explicitly designed for commerce.

---

# 76. Event Guardrail Metrics

Mandatory:

- Main Journey engagement.
- retention.
- crash rate.
- content defect rate.
- Coin inflation.
- session exits.
- ad exposure.

An Event should not cannibalize/break core product.

---

# 77. Event Participation KPI

`Event Participants / Eligible Active Players`

No target approved.

---

# 78. Event Completion KPI

`Players Completing Event / Players Starting Event`

Segment by:

- Event Level count.
- difficulty.
- country.
- app version.

---

# 79. Event Progress Funnel

```text
Event Viewed
→ Event Started
→ Level 1 Complete
→ Midpoint
→ Final Level
→ Event Complete
```

Identify drop-off.

---

# 80. Event Retention Impact

Compare:

- Event participants.
- eligible non-participants.

Be careful about selection bias.

Use experiments where feasible.

---

# 81. Event Economy Analytics

Track:

- Coins earned.
- Coins spent.
- Hints consumed.
- Extra Moves.
- Rescue.
- Rewarded Ads.
- Coin Pack purchases associated with Event.

Do not optimize Event difficulty merely to increase utility spend.

---

# 82. Event Content Analytics

Track:

- Association Hint rate.
- wrong placements.
- completion time.
- content reports.
- regional performance.

Especially important for dialect/cultural Events.

---

# 83. Event Notification Strategy

Potential notifications:

- Event started.
- Event ending soon.
- progress reminder.
- new Event available.

Avoid repeated daily spam.

---

# 84. Event Notification Permission

Only send if:

- player granted notifications.
- category enabled.
- event eligible.
- deep link valid.

---

# 85. Event Start Notification

**PROPOSED**

One launch notification may be appropriate for significant Events.

Not every small content update needs push.

---

# 86. Event Ending Notification

**PROPOSED**

May notify player who:

- started Event.
- has incomplete meaningful progress.
- has notifications enabled.

Avoid notifying players who ignored the Event entirely.

---

# 87. Streak-Risk Notification

**CONFIRMED at launch** (with Daily Challenge notifications).

Quiet hours: **22:00–09:00** player-local time.

Timing must use approved timezone policy and avoid manipulative urgency.

---

# 88. Daily Challenge Notification

**CONFIRMED as initially active notification type.**

May notify when:

- new challenge available.
- user has opted in.

Respect quiet hours **22:00–09:00** player-local. Exact send-window micro-timing within allowed hours may still be tuned.

---

# 89. In-App Messaging

**PROPOSED**

For new Event discovery, prefer:

- Home card.
- Events Hub.
- lightweight in-app banner.

before relying heavily on push.

---

# 90. Event Artwork

Events may use:

- custom header illustration.
- icon.
- background treatment.

Avoid requiring an entirely new UI theme for every Event.

Asset scope must match team capacity.

---

# 91. Event Visual Identity

**PROPOSED**

Use modular themed components:

- Event banner.
- accent artwork.
- badge/icon.
- reward icons.

Keep core gameplay board visual stable.

---

# 92. Event Audio

No event-specific audio is required.

Can be added later if production value justifies it.

---

# 93. Event Localization

Arabic-first.

If future additional languages launch:

- Event UI copy localized.
- puzzle content separately localized/curated, not machine-translated blindly.

---

# 94. Cultural Review

Mandatory for:

- religious Events.
- national/cultural Events.
- regional Events.
- politically adjacent dates/topics.

Avoid accidental offense or exclusion.

---

# 95. Religious Event Handling

**PROPOSED**

If Ramadan/Eid Events are introduced:

- keep respectful.
- avoid trivializing sacred text.
- avoid Quranic puzzle manipulation unless separately approved.
- use cultural/everyday knowledge rather than sacred text by default.

---

# 96. Political Events

Avoid current partisan/political Events unless explicitly approved.

The product does not need political LiveOps to remain relevant.

---

# 97. Sports Events

Could be time-sensitive.

Need:

- current data review.
- team/player rights/trademark awareness.
- expiry.

Better suited to temporary Event than Main Journey.

---

# 98. Celebrity/Brand Events

Not automatically approved.

Require:

- rights/legal review as needed.
- recency.
- content policy approval.

---

# 99. Permanent Special Packs

**CONFIRMED**

Packs may include:

- dialect.
- regional culture.
- specialized topics.
- advanced wordplay.

---

# 100. PackDefinition Entity

**PROPOSED**

Fields:

- `pack_id`
- `pack_key`
- `pack_type`
- `title`
- `description`
- `dialect_scope?`
- `content_bundle_version`
- `level_count`
- `unlock_policy`
- `reward_config`
- `status`
- `version`

---

# 101. Pack Types

**PROPOSED**

- DIALECT
- REGION
- TOPIC
- WORDPLAY
- EXPERT
- VISUAL

---

# 102. Pack Unlock Policy

**TBD**

Possible:

- free from Home.
- Journey progression unlock.
- Coin unlock.
- IAP.

No paid Pack model is approved.

---

# 103. Pack Progression

Could use:

- linear levels.
- completion percentage.
- milestones.

Recommendation:
Reuse simple Level progression.

---

# 104. Pack Replay

Likely unlimited.

Reward replay policy TBD.

---

# 105. Pack Content Reuse

Pack content may reuse global Members/Associations if:

- appropriate.
- not overly repetitive.
- special context still provides value.

---

# 106. Pack Analytics

Track:

- Pack opens.
- starts.
- completion.
- level drop-off.
- content quality.
- unlock conversion if gated.

---

# 107. Live Content Refresh

Not every update needs an Event.

Content refresh may:

- add new Main Journey associations.
- disable problematic content.
- update variants.
- tune Level configs.

Use content versioning and Remote Config.

---

# 108. Main Journey Content Injection

**PROPOSED**

New approved evergreen content can enter Main Journey pool without changing player's Level numbering.

Must preserve:

- Level config compatibility.
- semantic difficulty targets.
- reuse constraints.

---

# 109. Problematic Content Removal

Operations should be able to:

- disable Association/Variant.
- remove it from future generation.
- preserve historical analytics.

Active Attempt behavior needs version-safe handling.

---

# 110. Event Rollback

Every scheduled Event should have rollback strategy.

Possible actions:

- pause Event.
- disable new entry.
- revert content bundle.
- disable notifications.
- auto-grant earned rewards if necessary.

---

# 111. Event Kill Switch

**PROPOSED**

Remote switch:

`event.<event_id>.enabled`

Allows emergency disable without app release.

---

# 112. Event Pause

Pause may mean:

- hidden to new users.
- current users may finish active Attempt.
- progress retained.

Exact semantics TBD.

---

# 113. Event Cancellation

If Event must be cancelled:

Need policy for:

- progress.
- earned rewards.
- unclaimed rewards.
- notifications.
- public messaging.

---

# 114. Event Extension

Operations may extend end time.

Must update:

- backend schedule.
- client countdown.
- notifications.
- analytics version.

---

# 115. Event Countdown

Use backend end time.

Client countdown should tolerate local clock errors.

---

# 116. Event Time Sync

If device clock is wrong:

- server time should determine eligibility.
- cached Event may display gracefully offline.

Exact offline expiration policy TBD.

---

# 117. Offline Events

Potential behaviors:

A. Event requires online entry.
B. Download Event then play offline.
C. fully online.

**PROPOSED recommendation:**
Allow downloaded Event Levels to play offline where feasible, but reward/schedule reconciliation occurs when online.

Needs approval.

---

# 118. Offline Event Expiry

If Event expired while player offline:

On reconnect:

- server decides eligibility.
- do not allow indefinite offline exploitation.

---

# 119. Offline Daily Challenge

Daily Challenge fairness/time validity makes offline behavior more complex.

Potential:
Download today's Challenge while online and play offline before its valid end.

Exact policy TBD.

---

# 120. Event State Sync

Cloud state should persist:

- event progress.
- earned rewards.
- milestones.
- last active Event level.

Use idempotent reward grants.

---

# 121. Event Reward Idempotency

Every Event reward uses:

- event_id.
- player_id.
- milestone/level ID.
- unique idempotency key.

No duplicate reward after reconnect/retry.

---

# 122. Event Leaderboards

Leaderboards are Full Product scope.

Could later attach to:

- Daily Challenge.
- Event completion.
- move efficiency.

No Event leaderboard implementation is approved yet.

---

# 123. Competitive Event Fairness

If ranking exists:

- shared board or equivalent conditions.
- server-validated scores.
- anti-cheat measures.
- no paid score advantage.

---

# 124. Event Scoring

Not approved.

Possible metrics:

- completion.
- Moves remaining.
- completion time.
- streak Coins.
- combined score.

Needs separate design before Leaderboards.

---

# 125. Event Segmentation

**PROPOSED**

Events may target by:

- app version.
- country.
- language.
- progression stage.
- experiment cohort.

Avoid sensitive demographic targeting.

---

# 126. Reactivation Events

Could target inactive players with:

- new content.
- Event notification.

Avoid aggressive win-back spam.

---

# 127. New Player Events

Avoid overwhelming first-day users.

**PROPOSED**

Suppress major Event prompts until Tutorial is complete.

---

# 128. Returning Player Events

Returning user Home can show active Event card.

Do not interrupt with multiple modals.

---

# 129. Event Personalization

Not approved.

Do not dynamically change Event difficulty/rewards per payer/user without explicit decision.

---

# 130. Event A/B Testing

Safe experiments:

- Event card artwork.
- entry CTA.
- reward presentation.
- notification timing.

Avoid testing unfairly different reward values unless economy impact is carefully controlled and approved.

---

# 131. Event Experiment Exposure

Store:

- experiment ID.
- variant.
- Event ID.
- exposure timestamp.

---

# 132. Event CMS

Admin should support:

- create Event.
- set dates.
- select content bundle.
- configure Level list.
- configure rewards.
- preview.
- schedule.
- pause.
- cancel.
- publish.
- inspect analytics.

---

# 133. Event Preview

**PROPOSED**

CMS preview should show:

- Home Event card.
- Event detail.
- Level list.
- reward track.
- timer.
- sample board.

---

# 134. Event Validation Checklist

Before scheduling:

- [ ] Dates valid
- [ ] Content approved
- [ ] Levels Solver-valid
- [ ] Difficulty reviewed
- [ ] Rewards economy-reviewed
- [ ] Notifications configured
- [ ] Analytics configured
- [ ] Assets uploaded
- [ ] app-version compatibility checked
- [ ] rollback plan ready
- [ ] staging QA passed

---

# 135. Event QA

Test:

- start boundary.
- end boundary.
- timezone.
- deep links.
- offline/reconnect.
- reward grants.
- duplicate claims.
- app update during Event.
- disabled Event.
- content rollback.
- Remove Ads behavior.
- rewarded ad utilities.

---

# 136. Daily Boundary QA

Test:

- midnight crossing.
- timezone change.
- device clock manipulation.
- offline overnight.
- missed day.
- repeated claim.
- reconnect.

---

# 137. Event Load Testing

For major Event start:

Test:

- Event manifest fetch.
- content bundle download.
- Daily Challenge fetch.
- reward claims.
- notification deep links.

Core gameplay itself remains local.

---

# 138. Event Observability

Operational metrics:

- Event availability.
- manifest errors.
- content download failures.
- challenge generation failures.
- reward grant errors.
- notification failure.
- CMS publication errors.

---

# 139. Event Incident Alerts

Critical alerts:

- active Event unavailable.
- no Daily Challenge published.
- duplicate reward grants.
- Event content bundle corrupt.
- event end time misconfigured.
- notification sent to wrong audience.

---

# 140. LiveOps Dashboard

Recommended:

## Active Content
- current Events.
- current Packs.
- content bundle.

## Participation
- eligible.
- viewed.
- started.
- completed.

## Progression
- Level funnel.
- drop-off.

## Economy
- rewards.
- spend.
- ad use.

## Quality
- content reports.
- crashes.
- solver failures.

---

# 141. LiveOps Calendar Dashboard

Display:

- scheduled Events.
- Daily Challenge generation.
- content releases.
- notifications.
- experiments.
- config changes.

Useful to prevent conflicting launches.

---

# 142. Event Postmortem

**PROPOSED**

After each major Event, record:

- goal.
- participation.
- completion.
- retention impact.
- economy impact.
- monetization impact.
- content issues.
- technical incidents.
- what to repeat.
- what to change.

---

# 143. LiveOps Knowledge Base

Maintain:

- Event templates.
- successful reward structures.
- content types.
- notification learnings.
- failure patterns.
- postmortems.

This prevents relearning each Event.

---

# 144. Event Template Library

**PROPOSED**

Possible reusable templates:

- 5-Level Mini Event.
- 10-Level Event.
- 20-Level Seasonal Event.
- Dialect Pack launch.
- Daily Challenge Special Week.

Exact sizes are not approved.

---

# 145. Event Reward Templates

**PROPOSED**

Reusable reward configurations:

- low Coin.
- Coin + Hint.
- completion bonus.
- cosmetic reward later.

All amounts remotely configurable.

---

# 146. LiveOps Team Roles

Potential responsibilities:

- Product/LiveOps Manager.
- Content Designer.
- Arabic Reviewer.
- Game Designer.
- Visual Designer.
- QA.
- Engineer.
- Analyst.

Small team may combine roles.

---

# 147. Publication Permissions

Only authorized roles may:

- schedule.
- publish.
- pause.
- cancel.
- change rewards.

Use audit logs.

---

# 148. Four-Eyes Principle

**PROPOSED**

For high-risk actions:

- Event publication.
- economy reward change.
- broad notification campaign.

Require second approval if team size permits.

Not mandatory in a one-person MVP workflow.

---

# 149. Event Audit Log

Track:

- who changed Event.
- before/after.
- date.
- reason.
- publish/pause/cancel.

---

# 150. LiveOps Remote Config

Potential keys:

```text
events.enabled
events.<id>.enabled
events.<id>.start_at
events.<id>.end_at
events.<id>.min_level
events.<id>.reward_config
events.<id>.notification_enabled
daily_challenge.enabled
daily_reward.enabled
daily_streak.enabled
```

Exact schema TBD.

---

# 151. Content Manifest and Events

Manifest may include:

- active Event IDs.
- required content bundle versions.
- Pack availability.
- minimum app versions.

---

# 152. Event Deep Links

Potential:

- `event/<event_id>`
- `daily-challenge`
- `pack/<pack_id>`

Use typed parser and safe fallback.

---

# 153. Expired Deep Link

If Event expired:

- open Home or Events Hub.
- show optional "Event انتهى" message.

Do not land on broken screen.

---

# 154. Upcoming Event Teaser

Not required.

**PROPOSED**

Can show upcoming Event only when:

- content ready.
- start date locked.
- teaser adds value.

Avoid teasing uncertain launches.

---

# 155. Event Countdown Pressure

Do not use deceptive countdowns.

Timer must represent real backend Event end.

No fake reset timers.

---

# 156. Reward Scarcity Messaging

Avoid manipulative wording.

Use factual:

- "متاح حتى..."
- "باقي ..."

not false urgency.

---

# 157. Event Monetization Guardrails

Do not:

- increase difficulty to sell utilities.
- gate Event completion behind ads/IAP.
- require Coin Pack purchase.
- use exclusive paid solution.

---

# 158. Event Rewarded Ads

Rewarded ads may remain contextual.

Do not create Event-only ad walls.

---

# 159. Event Interstitial Frequency

Use same or lower normal cadence.

Do not stack Event transition + Interstitial + reward modal repeatedly.

---

# 160. Event UX Modal Priority

Event notifications/promos should not override:

- purchase.
- win.
- dead-end.
- out-of-moves.
- critical error.

Use existing modal priority model.

---

# 161. Event Home Priority

**PROPOSED**

Home remains centered on Continue Main Journey.

Active Event can be prominent but secondary unless product later chooses Event-led periods.

---

# 162. Event Progress Persistence

If app closes mid-Event Level:

Use same active-session persistence policy as normal gameplay.

Expiry rules may override on reconnect.

---

# 163. Event Content Version Freeze

**PROPOSED**

Once Event starts, freeze its main content version unless:

- bug.
- safety issue.
- critical balance issue.

Avoid silently changing puzzle content mid-Event without version bump.

---

# 164. Hotfixing Event Content

If a Level has bad content:

Possible:

- disable Level/config.
- swap to approved replacement.
- version Event.
- preserve player progression.

Exact migration policy TBD.

---

# 165. Event Reward Hotfix

Reward changes mid-Event are sensitive.

If increased:

Consider fairness for prior completers.

If decreased:

Avoid penalizing players after advertised value.

Changes require explicit operational policy.

---

# 166. Event Fairness

Players entering late should know whether:

- full Event is still completable.
- rewards expire.
- progress carries.

Do not hide time constraints.

---

# 167. Late Entry

Possible policies:

- full Event available until fixed end.
- minimum remaining time required.
- grace extension per entrant.

**PROPOSED recommendation:**
Fixed global end; no personalized extensions initially.

---

# 168. Event Re-entry

Players can leave and return while Event active.

Progress persists.

No Lives/Energy gating.

---

# 169. Event Reward Claim Window

Exact claim grace is TBD.

Recommendation:
Avoid separate long claim windows unless needed; auto-grant earned rewards where possible.

---

# 170. Event Completion Celebration

May include:

- completion animation.
- reward summary.
- return Home/Events CTA.

Do not overbuild cinematic sequences in early LiveOps.

---

# 171. Event Collection Rewards

Post-MVP Events may grant:

- badges.
- collection items.
- cosmetics.

This can create long-term reasons to participate without direct gameplay advantage.

---

# 172. Event Exclusivity

Whether cosmetic Event rewards are permanently exclusive or return later is TBD.

Avoid promising "never returns" without a firm policy.

---

# 173. Event Archive

Completed Events should retain:

- definitions.
- versions.
- analytics.
- rewards.
- publication history.

Whether players can browse past Events is TBD.

---

# 174. Event Reuse

Successful Event structures may be reused with:

- new content.
- new artwork.
- adjusted rewards.

Avoid duplicating an entire code path.

---

# 175. Seasonal Reuse

Recurring annual Events may reuse templates but content should be reviewed for freshness before republishing.

---

# 176. Event Content Expiry Review

Contemporary content should have:

- expiry/review date.
- owner.
- status.

Prevent outdated facts from becoming permanent content accidentally.

---

# 177. LiveOps Content Capacity

Before setting cadence, estimate:

- Associations/Event.
- variants/Event.
- review time.
- Level config time.
- art time.
- QA time.

Cadence must be driven by sustainable production capacity.

---

# 178. AI-Assisted Event Content

AI can help:

- generate drafts.
- propose themes.
- create Association variants.
- flag duplicates.
- estimate semantic difficulty.

Human review remains mandatory.

---

# 179. AI Event Planning

**PROPOSED**

AI may generate an Event brief draft containing:

- theme.
- content categories.
- Level mix.
- reward proposal.

But no auto-scheduling or auto-publishing.

---

# 180. Automated Event Validation

Before publish, automation should verify:

- dates.
- reward config.
- content status.
- level solvability.
- app-version compatibility.
- missing assets.
- duplicate IDs.
- deep links.

---

# 181. Event Staging

Every Event should be playable in Staging before production.

Use time override/testing tools to simulate:

- pre-start.
- active.
- ending.
- expired.

---

# 182. Time Travel QA Tools

**PROPOSED**

Admin/test builds may override current time for testing Daily/Event boundaries.

Production must still trust backend time.

---

# 183. Event Sandbox

Content team may preview Event without publishing to all users.

Use:

- internal audience.
- staging.
- feature flag.

---

# 184. Phased Rollout

**PROPOSED**

For risky Event systems:

- internal.
- small cohort.
- wider rollout.

Not necessary for every content-only Event.

---

# 185. Event Analytics Event Set

Recommended:

- `event_impression`
- `event_opened`
- `event_started`
- `event_level_started`
- `event_level_completed`
- `event_milestone_reached`
- `event_reward_granted`
- `event_completed`
- `event_expired`
- `event_notification_opened`

---

# 186. Event Event Properties

Include:

- event_id.
- event_version.
- event_type.
- event_day.
- progress_level.
- eligible_since.
- time_remaining.
- board/semantic difficulty.
- reward config version.
- content bundle version.

---

# 187. Pack Analytics Events

Recommended:

- `pack_viewed`
- `pack_started`
- `pack_level_started`
- `pack_level_completed`
- `pack_completed`
- `pack_unlocked`

---

# 188. LiveOps Success Framework

Evaluate each Event across:

1. Reach.
2. Participation.
3. Progress.
4. Completion.
5. Return/Retention.
6. Economy.
7. Monetization.
8. Quality.
9. Operational Cost.

No Event should be judged only by one number.

---

# 189. Operational Cost KPI

**PROPOSED**

Track approximate:

- content hours.
- art hours.
- QA hours.
- engineering hours.
- incidents.

Compare to Event engagement value.

Important for a small team.

---

# 190. Event Cannibalization KPI

Track whether Event launch causes:

- Main Journey starts to drop.
- total play to rise/fall.
- Daily Challenge participation to change.

Some cannibalization may be acceptable if total engagement improves.

---

# 191. Event Fatigue

Potential signals:

- declining participation across consecutive Events.
- more notification opt-outs.
- lower completion.
- shorter sessions.
- Event card ignore rate.

Cadence may need reduction.

---

# 192. LiveOps Maturity Stages

**PROPOSED**

## Stage 0 — Base Product
Main Journey only.

## Stage 1 — Daily
Daily Reward + Challenge + Streak.

## Stage 2 — Light LiveOps
Occasional temporary Events.

## Stage 3 — Packs
Permanent specialized content.

## Stage 4 — Mature LiveOps
Regular calendar + Events + Packs + meta rewards.

## Stage 5 — Competitive
Leaderboards/advanced Events.

---

# 193. Confirmed MVP / Launch Position

**CONFIRMED — Final Decision Register v1.1**

**Launch P0**
- Daily Reward.
- Daily Challenge.
- Daily Streak.
- Smart Notification infrastructure (initially Daily Challenge + Streak Risk).
- Quiet hours 22:00–09:00 player-local.
- Architecture Event-ready (Remote Config / content versioning).
- No major temporary Event required at first store release.

**Post-launch**
- Temporary Events (first Event only after Daily systems and core metrics are stable).
- First Event: 10 Levels; core rules only; no new currency; no leaderboard; max one major Event at a time.
- Permanent Packs.
- Leaderboards.
- richer LiveOps / notification types.

---

# 194. Event Technical Dependencies

Events depend on:

- Content CMS.
- Level Configuration.
- Solver.
- Difficulty Model.
- Cloud state.
- Reward system.
- Remote Config.
- Notifications.
- Analytics.
- content bundles.
- admin scheduling.

---

# 195. LiveOps Operational Dependencies

Need:

- editorial calendar.
- review workflow.
- QA process.
- publish permissions.
- rollback.
- analytics dashboards.
- postmortem process.

---

# 196. LiveOps Risks

## Content Burnout
Too much content required.

Mitigation:
- sustainable cadence.
- reuse templates.
- AI-assisted drafts.

## Economy Inflation
Too many rewards.

Mitigation:
- reward budgets.
- simulation.

## Notification Fatigue
Too many pushes.

Mitigation:
- category preferences.
- targeted reminders.

## Event Bugs
Time/config issues.

Mitigation:
- staging.
- time-boundary QA.
- kill switches.

## Cultural Risk
Regional/religious mistakes.

Mitigation:
- specialized review.

---

# 197. Event Decision Register — Confirmed

The following are **CONFIRMED**:

1. Temporary Events exist in Full Product.
2. Permanent Special Packs exist.
3. Daily Reward is P0 at launch (confirmed calendar).
4. Daily Challenge is P0 at launch (150 Coins; unlimited retries; deterministic cohort board).
5. Daily Streak is P0 at launch (confirmed milestones; breaks on missed day).
6. Smart Notifications at launch: Daily Challenge + Streak Risk; quiet hours 22:00–09:00.
7. Main Journey remains evergreen-focused.
8. Time-sensitive content belongs outside Main Journey.
9. Strong dialect content belongs mainly in Packs/Events.
10. Events/Packs reuse core Game Engine where possible.
11. Human content approval remains mandatory.
12. Leaderboards exist in Full Product.
13. No Lives/Energy.
14. Rewarded Ads remain optional.
15. Coins/Hints can be used by Event gameplay if it uses normal rules.

---

# 198. Event Decision Register — Proposed / Requires Approval

The following remain **PROPOSED/TBD**:

1. Event type taxonomy beyond first-Event constraints.
2. Event durations / cadence after first Event.
3. Event reward values (beyond using existing Coins/Hints).
4. Milestone structure details.
5. Event expiry / active Attempt grace / unclaimed reward policies.
6. Pack unlock policy (free / Coin / real-money) — future.
7. Event notification cadence beyond launch types.
8. Event offline behavior details.
9. Daily Challenge difficulty day-to-day policy.
10. Event-specific art scope.
11. Regional eligibility targeting.
12. Event leaderboard scoring (Leaderboards DEFERRED).
13. Four-eyes publishing rule.
14. Phased Event rollout mechanics.
15. Recurring seasonal Event policy.
16. Event archive/replay behavior.
17. Cosmetic exclusivity.
18. Event content/reward hotfix policies.
19. Late-entry / claim grace window.

**CONFIRMED (no longer open):** Daily P0 at launch; quiet hours 22:00–09:00; initially active notifications Daily Challenge + Streak Risk; Events post-launch; first Event 10 Levels / core rules / no new currency / no leaderboard; max one major Event at a time; Daily Reward calendar & Challenge 150 Coins & Streak milestones.

---

# 199. Recommended Approval Order

Before building full Event tooling:

1. Approve Event vs Pack model.
2. Approve Event progression model.
3. Approve expiry/late-entry rules.
4. Approve reward philosophy.
5. Approve Event scheduling/timezone.
6. Approve offline behavior.
7. Approve notifications.
8. Approve CMS Event workflow.
9. Approve analytics event set.
10. define first Event template.
11. run one controlled Event.
12. calibrate cadence from operational capacity.

---

# 200. Recommended Initial LiveOps Baseline

A conservative path is:

- First stabilize Main Journey.
- Launch Daily Reward/Challenge/Streak.
- Build CMS scheduling and kill-switch foundation.
- Run occasional content-only temporary Events.
- Add Permanent Packs after content pipeline is stable.
- Add Leaderboards only after deterministic challenge validation and anti-cheat are ready.
- Keep one Event active at a time initially.
- Use existing Coins/Hints rather than new Event currencies.
- Avoid subscriptions/Event Passes until explicitly approved.

---

# 201. Confirmed First Event Constraints

**CONFIRMED — Final Decision Register v1.1**

First temporary Event (post-launch):

- **10 Levels**.
- Core rules only (no new mechanic).
- No new currency.
- No leaderboard.
- Max one major Event active at a time.
- Existing Coins/Hints reward model.
- Theme/content still chosen operationally; must pass human Arabic/semantic review and Solver validation.

---

# 202. Dependencies

This LiveOps & Events Design feeds:

1. **CMS Specification**
2. **Remote Config Specification**
3. **Notification Specification**
4. **API Specification**
5. **Cloud Save & Sync Specification**
6. **Event Content Production Plan**
7. **Analytics dashboards**
8. **QA & Automated Validation Strategy**
9. **MVP / Post-MVP Product Backlog**
10. **Launch & LiveOps Operations Runbook**

---

# 203. Baseline Status

This document is **LiveOps & Events Design v1.0** — **Decision-Aligned** to **Final Decision Register v1.1** (Firebase-first).

It defines how Daily systems, temporary Events, permanent Packs, event content, scheduling, rewards, notifications, operations, analytics, CMS, QA, rollback, and future competitive LiveOps should fit around the stable core game.

Daily systems are **P0 at launch**; temporary Events are **post-launch** with confirmed first-Event constraints. Remaining Event reward/cadence/policy details stay **TBD** where noted.

**End of LiveOps & Events Design v1.0**
