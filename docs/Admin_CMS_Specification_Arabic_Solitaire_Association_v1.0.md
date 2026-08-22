# Admin/CMS Specification
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + related product/architecture specs  
**Important:** CMS frontend (Angular), admin auth (Microsoft Entra ID + MFA), Firebase/GCP security boundaries, and **2-year audit retention** listed as **APPROVED** in Final Decision Register v1.1 are **CONFIRMED**. ASP.NET Core + PostgreSQL are **DEFERRED**. Azure always-on stack is **SUPERSEDED** for MVP. Exact Firebase/GCP quotas/billing remain **TBD**.

---

# 1. Purpose

This document defines the Admin/CMS system required to operate the Arabic Solitaire Association game.

The CMS must support:

- Content creation.
- Arabic editorial review.
- Semantic review.
- Association/Member management.
- Association Variant management.
- Level Configuration.
- Level Templates.
- Solver validation.
- Difficulty analysis.
- Content publishing.
- Content deactivation.
- Content bundle management.
- Event/Pack management.
- Daily Challenge management.
- Economy configuration.
- Monetization configuration.
- Remote Config.
- Feature Flags.
- Notifications.
- Analytics access.
- Player support tools.
- Audit logs.
- Admin users/roles/permissions.
- QA and staging workflows.

The CMS should allow a small team to operate the product efficiently without requiring direct database access.

---

# 2. CMS Design Principles

The CMS should follow these principles:

1. Human review is mandatory before puzzle content reaches production.
2. Stable IDs must be visible to operators where useful.
3. No production content edit should require raw DB access.
4. Every publish/deactivate action should be auditable.
5. Critical economy/admin operations require stronger permissions.
6. Solver validation should be available from the CMS.
7. Content and Level Configuration should be versioned.
8. Production content should be reversible.
9. Bulk operations should exist where they reduce repetitive editorial work.
10. AI may assist drafting, never auto-publish.
11. Admin UI should be optimized for Arabic-first editorial work.
12. Player-facing Arabic text should be previewable before publication.
13. CMS should separate Draft, Review, Staging, and Production concerns.
14. Dangerous configuration changes should be hard to perform accidentally.
15. CMS complexity should grow with LiveOps maturity rather than front-loading everything.

---

# 3. Admin Surfaces

Recommended high-level Admin/CMS areas:

1. Dashboard.
2. Content Library.
3. Associations.
4. Members.
5. Association Variants.
6. Level Management.
7. Level Templates.
8. Solver Validation.
9. Difficulty Review.
10. Content Bundles.
11. Events.
12. Packs.
13. Daily Challenge.
14. Economy Configuration.
15. Monetization Configuration.
16. Remote Config.
17. Feature Flags.
18. Notifications.
19. Player Support.
20. Analytics.
21. Audit Logs.
22. Admin Users & Roles.
23. System Health.

---

# 4. Admin Navigation

**PROPOSED**

Primary sidebar:

```text
Dashboard
Content
  Associations
  Members
  Variants
Levels
  Level Definitions
  Templates
  Solver Validation
LiveOps
  Daily Challenge
  Events
  Packs
Economy
  Coins & Hints
  Monetization
Configuration
  Remote Config
  Feature Flags
Operations
  Player Support
  Analytics
  Audit Logs
Administration
  Users
  Roles
  System Health
```

Exact information architecture remains subject to UI design.

---

# 5. Dashboard

The Dashboard should summarize operational state.

Recommended widgets:

- Active content bundle version.
- Draft content count.
- Items awaiting review.
- Solver validation failures.
- Levels awaiting approval.
- Active Event.
- Today's Daily Challenge status.
- Content publication status.
- Economy config version.
- Critical alerts.
- Recent admin activity.

---

# 6. Dashboard Alerts

Potential alerts:

- Daily Challenge not published.
- Active content bundle incompatible.
- Solver failure spike.
- Event nearing start without QA approval.
- Missing illustration asset.
- Content item reported/problematic.
- Purchase/Wallet incident.
- Remote Config invalid.
- Event reward config missing.

---

# 7. Content Library

The Content Library should provide unified search across:

- Associations.
- Members.
- Variants.
- clues.
- aliases.
- tags.
- relation types.
- topics.
- content types.

Search must support Arabic effectively.

---

# 8. Arabic Search

**PROPOSED**

CMS search may use normalized Arabic forms internally:

- remove diacritics.
- normalize Alef variants.
- normalize Tatweel.
- optionally normalize Ya/Alif Maqsura for search.

Display text must remain unchanged.

---

# 9. Content Search Filters

Filters may include:

- Status.
- Content Type.
- Relation Type.
- Topic.
- Semantic Difficulty.
- Dialect.
- Region.
- Evergreen Classification.
- Reviewer.
- Created Date.
- Updated Date.
- Production Scope.
- Has Issues.
- Duplicate Risk.
- Asset Missing.

---

# 10. Association Management

Association editor should support:

- Full Relation.
- Visible Clue.
- Relation Type.
- Topic.
- Content Type.
- Semantic Difficulty.
- Dialect Scope.
- Evergreen classification.
- Aliases.
- Notes.
- Tags.
- Status.
- Review history.
- Version history.

---

# 11. Association Editor — Content Fields

Recommended fields:

- `association_id`
- `full_relation`
- `primary_clue`
- `alternate_clues`
- `relation_type`
- `topic`
- `content_type`
- `semantic_band`
- `ambiguity_level`
- `dialect_scope`
- `evergreen_classification`
- `notes`

Exact schema depends on final Data Model.

---

# 12. Clue Preview

CMS should preview the Association Card exactly as it may appear to the player.

Preview should support:

- RTL.
- chosen font.
- card width.
- one/two-line behavior.
- diacritics.
- mixed Arabic/Latin text.

---

# 13. Clue Validation

Potential checks:

- empty clue.
- excessive length.
- suspicious punctuation.
- duplicate clue warning.
- trailing whitespace.
- unsupported characters.
- unapproved diacritic patterns.

These are validation warnings, not always hard blockers.

---

# 14. Member Management

Member editor should support:

- canonical display text.
- aliases.
- content type.
- image/icon asset.
- familiarity rating.
- region/dialect scope.
- evergreen classification.
- notes.
- approval status.

---

# 15. Member Content Types

**CONFIRMED**

CMS must support:

- TEXT.
- NUMBER.
- SYMBOL.
- EMOJI.
- ILLUSTRATION.

---

# 16. Illustration Member Editor

Should support:

- asset upload.
- image preview.
- crop/fit preview.
- semantic concept name.
- alt/internal description.
- approval status.
- replacement/version history.

No real-photo workflow is required for current scope.

---

# 17. Association-Member Relationship

CMS should allow editors to link Members to Associations.

Because relationships are many-to-many globally:

A Member can be linked to multiple Associations.

Each link can store:

- appropriateness.
- difficulty.
- reviewer notes.
- approved status.

---

# 18. Association Variant Management

Variant represents a curated subset of Members used for a playable Association group.

Variant editor should show:

- Association.
- selected Members.
- group size.
- Semantic Difficulty.
- notes.
- production status.
- reuse history.

---

# 19. Variant Creation

Possible flows:

## Manual
Editor selects Members.

## AI-Assisted
AI suggests candidate Member sets.

## Auto-Draft
System proposes balanced subset from approved Member pool.

All variants require human review.

---

# 20. Variant Validation

Validate:

- Member count matches group size.
- All Members linked to Association.
- no duplicate Member.
- all Members same content type.
- no disabled content.
- semantic difficulty consistent.
- no unsafe combination.

---

# 21. Variant Preview

Show:

- Association Card.
- all Member Cards.
- content type.
- semantic labels.

Useful for editorial review before Level assembly.

---

# 22. Duplicate Detection

CMS should warn about:

- duplicate Association concept.
- near-identical clue.
- duplicate Member.
- same Variant Member set.
- high overlap between variants.

---

# 23. Semantic Duplicate Detection

**PROPOSED**

Possible advanced tool:

- semantic similarity score.
- embedding/vector search.
- AI duplicate suggestions.

Not required for first CMS release.

---

# 24. Content Quality Score

No final score is approved.

CMS may display structured review state rather than one composite score.

Potential signals:

- language approved.
- semantic approved.
- difficulty approved.
- duplicate checked.
- game tested.

---

# 25. Content Workflow

**PROPOSED**

Recommended lifecycle:

```text
Draft
→ Language Review
→ Semantic Review
→ Game Review
→ Production Approved
→ Active
```

Alternative editorial states may be simplified for MVP.

---

# 26. Content Statuses

Possible:

- DRAFT
- NEEDS_LANGUAGE_REVIEW
- NEEDS_SEMANTIC_REVIEW
- NEEDS_GAME_REVIEW
- PRODUCTION_APPROVED
- ACTIVE
- DISABLED
- DEPRECATED
- ARCHIVED

---

# 27. Human Review Requirement

**CONFIRMED**

AI-generated content cannot become Active without human approval.

CMS must make this impossible through normal workflow.

---

# 28. Reviewer Notes

Each review stage should support:

- approve.
- reject.
- request changes.
- comment.

Notes must be retained with reviewer/time.

---

# 29. Review History

Show timeline:

- creator.
- edits.
- reviewers.
- rejections.
- approvals.
- publications.
- disable actions.

---

# 30. Arabic Language Review

Reviewer checks:

- natural Arabic.
- spelling.
- clue conciseness.
- proper diacritics.
- regional comprehensibility.
- no translationese.
- display readability.

---

# 31. Semantic Review

Reviewer checks:

- all Members valid.
- relation clear/fair.
- ambiguity intentional.
- clue appropriate.
- no misleading association.
- difficulty classification reasonable.

---

# 32. Game Review

Game Designer checks:

- Level suitability.
- group size suitability.
- relation type unlock stage.
- difficulty fit.
- repetition.
- interaction with other Associations.

---

# 33. Cultural Review

Used when needed for:

- regional.
- religious.
- culturally sensitive.
- contemporary.
- political-adjacent content.

---

# 34. Content Severity

**PROPOSED**

Issue levels:

- BLOCKER.
- MAJOR.
- MINOR.

Example:

BLOCKER:
Semantically wrong content.

MAJOR:
Very misleading clue.

MINOR:
Small wording improvement.

---

# 35. Bulk Content Import

CMS should eventually support:

- CSV.
- spreadsheet template.
- structured JSON.

For bulk drafts.

Imported content enters Draft state.

---

# 36. Bulk Export

Support export for:

- editorial review.
- backup.
- external QA.
- offline review.

Never use export as primary production publication mechanism.

---

# 37. Bulk Actions

Potential:

- assign reviewer.
- change tag.
- update status.
- add scope.
- deactivate.
- export.

Publishing high-risk items should require careful confirmation.

---

# 38. AI Content Assistant

**PROPOSED**

CMS may include AI actions:

- Generate Association ideas.
- Generate Member candidates.
- Generate Variants.
- Suggest clue.
- detect duplicates.
- estimate Semantic Difficulty.
- flag regional ambiguity.
- rewrite unnatural Arabic.

AI output always enters Draft.

---

# 39. AI Prompt Inputs

Assistant may receive:

- relation type.
- topic.
- difficulty.
- group size.
- dialect.
- scope.
- excluded concepts.
- existing duplicates.

---

# 40. AI Output Review

CMS should show AI-origin metadata:

- generated by AI.
- model/version if useful.
- generation time.
- human edits.

Do not automatically trust AI difficulty labels.

---

# 41. Level Management

CMS must support Level Definitions.

Level editor should include:

- Journey Level number.
- Chapter.
- Level type.
- Level Template.
- Move Limit.
- Association count.
- group profile.
- Tableau profile.
- Stock size.
- Slot count.
- Board target.
- Semantic target.
- content selection policy.
- Solver acceptance profile.
- version.
- status.

---

# 42. Level Definition vs Generated Attempt

CMS must clearly explain:

A Level Definition is not one fixed board.

It produces randomized Attempts.

This distinction must be visible in admin terminology.

---

# 43. Level Configuration Editor

Provide structured controls for:

- Association count.
- group sizes.
- Tableau columns.
- Tableau depths.
- Stock size.
- Association Slots.
- Move Limit.
- ambiguity.
- content types.
- relation types.

---

# 44. Level Template Management

**PROPOSED**

Allow reusable structural templates.

Template editor:

- name.
- description.
- association count.
- group profile.
- Tableau profile.
- Stock profile.
- slot profile.
- expected Board band.
- active/version.

---

# 45. Template Usage View

Show:

- Levels using template.
- current version.
- performance metrics.
- simulation pass rate.

Changing template should not silently alter historical Level versions.

---

# 46. Content Selection Policy Editor

Potential filters:

- semantic min/max.
- relation types.
- topics.
- content types.
- dialect.
- evergreen requirement.
- reuse cooldown.
- ambiguity ceiling.

---

# 47. Level Content Preview

CMS should generate candidate Association set for the Level.

Display:

- selected Associations.
- Members.
- semantic scores.
- potential conflicts.

---

# 48. Board Generation Preview

**PROPOSED**

Admin can click:

`Generate Sample Board`

Then view:

- Tableau.
- Stock.
- Association Slots.
- Move Limit.
- Solver result.
- difficulty metrics.

---

# 49. Playtest Mode

Admin should be able to play generated sample as a real player.

Features:

- Drag & Drop.
- Undo.
- Hint.
- solver solution.
- reset/regenerate.
- debug overlay.

---

# 50. Solver Validation Screen

Should display:

- Solvable / Unsolvable.
- within Move Limit.
- Reference Moves.
- Minimum Moves if proven.
- Move Slack.
- Solver duration.
- states explored.
- required Restores.
- first completion moves.
- Board Score.
- rejection reason.

---

# 51. Solver Solution Viewer

**PROPOSED**

Allow step-through:

- Move number.
- source.
- destination.
- board state.
- Association completion.

Admin-only.

---

# 52. Solver Batch Validation

Allow batch simulation over:

- Level.
- Template.
- Chapter.
- Level range.

Metrics:

- generated count.
- accepted rate.
- rejection reasons.
- p95 solver time.
- difficulty distribution.

---

# 53. Simulation Job

Long-running simulation should execute asynchronously.

CMS shows:

- queued.
- running.
- completed.
- failed.

---

# 54. Simulation Result Dashboard

Show:

- acceptance rate.
- reference Moves distribution.
- Board Difficulty distribution.
- Restore distribution.
- Dead-End pressure.
- generation latency.
- timeout count.

---

# 55. Difficulty Review Screen

Compare:

- configured target.
- generated Attempt distribution.
- live player behavior.

For example:

`Target B3 / Actual predicted mean B3 / Live behaves like B4`

---

# 56. Difficulty Calibration Tools

**PROPOSED**

Allow reviewer to:

- inspect outlier Attempts.
- change Move Limit.
- adjust acceptance range.
- modify Template.
- rerun simulation.

No automatic production tuning without approval.

---

# 57. Chapter Management

CMS should show 50-Level standard Chapters.

Views:

- Chapter list.
- Level sequence.
- difficulty wave.
- unresolved issues.
- completion/live analytics.

---

# 58. Chapter Difficulty Visualization

**PROPOSED**

Graph:

- Board Difficulty across 50 Levels.
- Semantic Difficulty across 50 Levels.

Useful to inspect waves and relief points.

---

# 59. Progression Validation

CMS can flag:

- accidental difficulty monotonic spike.
- repeated archetype.
- repeated relation types.
- group-size unlock violation.
- semantic content introduced too early.

Exact rules remain configurable.

---

# 60. Tutorial Management

Tutorial config should allow:

- scripted Level.
- forced/allowed actions.
- instruction copy.
- highlight target.
- step completion.
- skip policy.

Tutorial should reuse Game Engine rules where possible.

---

# 61. Tutorial Preview

Admin can run tutorial flow end-to-end.

Test:

- copy.
- highlighting.
- incorrect action handling.
- completion.

---

# 62. Daily Challenge Management

**CONFIRMED Full Product**

CMS/operations should support:

- challenge date.
- content.
- fixed board/seed.
- Move Limit.
- reward.
- Solver validation.
- status.
- publish.

---

# 63. Daily Challenge Calendar

**PROPOSED**

Calendar view showing:

- prepared days.
- missing days.
- published.
- QA status.
- solver status.

Avoid missing a Daily Challenge.

---

# 64. Daily Challenge Auto-Generation

**PROPOSED**

System may pre-generate candidate Daily Challenges.

Human operator reviews/approves.

No auto-publication initially.

---

# 65. Event Management

CMS should support:

- Event definition.
- dates.
- title/description.
- artwork.
- content bundle.
- Level list.
- reward config.
- eligibility.
- notifications.
- analytics tags.
- kill switch.

---

# 66. Event Calendar

Show:

- active Event.
- upcoming Events.
- content releases.
- Daily Challenge schedule.
- notification campaigns.

---

# 67. Event Workflow

**PROPOSED**

```text
Draft
→ Content Ready
→ Levels Validated
→ Rewards Reviewed
→ QA Ready
→ Scheduled
→ Active
→ Completed
→ Archived
```

---

# 68. Event Preview

Preview:

- Home card.
- Event detail screen.
- Event progression.
- countdown.
- reward summary.
- sample Level.

---

# 69. Event Kill Switch

Authorized admin can:

- pause Event.
- disable Event.
- stop notifications.

Requires confirmation + audit log.

---

# 70. Permanent Pack Management

Support:

- Pack title.
- type.
- dialect/region.
- Level count.
- content.
- unlock policy.
- rewards.
- status.
- version.

---

# 71. Pack Unlock Policy

Because final policy is TBD, CMS should support configuration without assuming:

- free.
- Coin-unlocked.
- paid.

Do not expose unapproved paid Pack type to production by default.

---

# 72. Content Bundle Management

CMS should manage:

- bundle version.
- included content.
- Level configs.
- assets.
- compatibility.
- publication status.
- hash.
- rollback.

---

# 73. Bundle Build

**PROPOSED**

Publish workflow:

1. Select approved entities.
2. build runtime bundle.
3. schema validate.
4. asset validate.
5. compatibility validate.
6. generate hash.
7. upload.
8. update manifest.

---

# 74. Bundle Diff

CMS should show difference between versions:

- added Associations.
- removed Associations.
- updated clues.
- new Levels.
- changed Move Limits.
- asset changes.

---

# 75. Bundle Rollback

Authorized users can point manifest back to prior compatible bundle.

Rollback action must be audited.

---

# 76. Content Compatibility Check

Validate:

- minimum app version.
- rules version.
- content schema.
- asset completeness.

---

# 77. Economy Configuration

CMS should support tunable economy values.

Examples:

- starting Coins.
- starting Hints.
- Hint cost.
- Extra Moves grant.
- Extra Moves price.
- Rescue price.
- Rewarded Coin amount.
- Daily Reward values.

All exact values remain subject to Product approval.

---

# 78. Economy Configuration Safety

Economy changes are high-risk.

Recommended:

- versioned config.
- preview.
- validation.
- reason field.
- staged rollout.
- audit.

---

# 79. Economy Change Confirmation

**PROPOSED**

For production:

Show before/after diff and explicit confirmation.

Potential second approval if team size supports it.

---

# 80. Economy Config Validation

Reject:

- negative values.
- impossible caps.
- malformed reward config.
- conflicting product state.

Warn on:

- extreme value changes.
- large Coin inflation risk.

---

# 81. Monetization Configuration

CMS should support:

- rewarded placements.
- Interstitial enabled/disabled.
- cooldown.
- session cap.
- Remove Ads product visibility.
- Coin Pack product status.

Real-money price comes from platform stores.

---

# 82. Product Catalog Management

Admin may manage internal metadata:

- product ID.
- platform SKU.
- product type.
- Coin amount.
- entitlement.
- active.
- sort order.

Do not manually set localized store prices in CMS.

---

# 83. Remote Config Management

CMS/config console should support:

- key.
- value.
- type.
- environment.
- version.
- rollout.
- effective date.
- owner.
- description.

May integrate with external provider instead of recreating full Remote Config.

---

# 84. Config Types

Possible:

- boolean.
- integer.
- decimal.
- string.
- JSON object.
- enum.

Use schema validation.

---

# 85. Feature Flag Management

Fields:

- key.
- enabled.
- platform.
- app version.
- audience.
- rollout percentage.
- environment.

---

# 86. Feature Flag Safety

Do not use generic flags to change core gameplay rules without rules-version compatibility.

CMS should distinguish:

- safe feature flags.
- rules configuration.

---

# 87. Notification Campaign Management

Support:

- category.
- target audience.
- title.
- body.
- deep link.
- schedule.
- timezone.
- status.
- analytics campaign ID.

---

# 88. Notification Preview

Preview:

- Arabic title/body.
- truncation.
- deep-link target.
- platform appearance approximation.

---

# 89. Notification Audience

Potential criteria:

- notifications enabled.
- Daily Challenge eligible.
- Event participant.
- streak at risk.
- app version.
- country/language.

No sensitive targeting.

---

# 90. Notification Approval

Broad manual campaigns should require:

- preview.
- target count estimate.
- confirmation.
- audit.

---

# 91. Player Support Tools

**PROPOSED**

Support view may include:

- Player ID.
- current Level.
- cloud sync status.
- Wallet balance.
- Wallet transactions.
- Hint balance.
- entitlements.
- purchases.
- Daily state.
- account links.
- recent errors.

---

# 92. Player Search

Search by safe identifiers:

- internal Player ID.
- external provider reference where permitted.
- purchase transaction ID.

Avoid broad PII collection.

---

# 93. Wallet Support

Support should view ledger, not raw-edit balance.

Possible actions:

- grant compensation.
- reverse/correct through transaction.
- add reason.

---

# 94. Manual Compensation

**PROPOSED**

Allowed rewards:

- Coins.
- Hints.

Requires:

- authorized permission.
- reason.
- unique transaction.
- audit.

---

# 95. Entitlement Support

Support may:

- view Remove Ads entitlement.
- revalidate purchase.
- trigger restore/reconciliation.

Manual entitlement override should be highly restricted.

---

# 96. Purchase Support

View:

- platform.
- product.
- transaction status.
- validation result.
- grant result.
- refund/revocation.

---

# 97. Cloud Sync Support

View:

- latest revision.
- last sync.
- pending conflict.
- device count if stored.
- error reason.

Manual conflict resolution should be carefully permissioned.

---

# 98. Active Attempt Support

Optional/debug-only:

- Level ID.
- Attempt ID.
- state revision.
- Solver validation.
- state hash.
- app/engine version.

Avoid exposing full internal board unless needed.

---

# 99. Player Support Audit

Every support-side mutation must be audited.

Examples:

- Coin compensation.
- Hint grant.
- entitlement correction.
- progress correction.

---

# 100. Analytics Integration

CMS may embed or link to dashboards for:

- content.
- Level health.
- Solver.
- economy.
- monetization.
- LiveOps.

Avoid rebuilding full BI platform unnecessarily.

---

# 101. Content Analytics View

Per Association/Variant:

- exposure count.
- Hint rate.
- wrong-placement rate.
- completion time.
- report rate.
- Semantic Difficulty mismatch.

---

# 102. Level Analytics View

Per Level:

- completion rate.
- attempts.
- restarts.
- Dead Ends.
- Extra Moves.
- Hints.
- remaining Moves.
- Board Score.

---

# 103. Solver Analytics View

Show:

- generation acceptance.
- timeout.
- p95 solve time.
- rejection reasons.
- replay mismatch.

---

# 104. Economy Analytics View

Show:

- Coin sources.
- sinks.
- Wallet distribution.
- Hint usage.
- Extra Moves.
- Rescue.

---

# 105. LiveOps Analytics View

Show:

- Event participation.
- completion.
- reward grants.
- Main Journey cannibalization.
- notification performance.

---

# 106. Audit Log

Audit should record:

- actor.
- action.
- entity type.
- entity ID.
- before.
- after.
- timestamp.
- environment.
- reason.
- request/correlation ID.

---

# 107. Audited Actions

At minimum:

- content publish.
- content disable.
- Level config publish.
- Move Limit change.
- Event schedule.
- economy config.
- monetization config.
- notification campaign.
- Wallet compensation.
- entitlement override.
- role changes.

---

# 108. Audit Log Search

Filters:

- actor.
- date.
- entity.
- action.
- environment.
- severity.

---

# 109. Admin Identity

Admin accounts are separate from Player identities.

Do not reuse player account system for CMS staff.

---

# 110. Admin Authentication

**CONFIRMED — Final Decision Register v1.1**

- CMS frontend: **Angular**.
- Admin authentication: **Microsoft Entra ID**.
- **MFA** for privileged access.
- Production publish permission separated from ordinary content editing.
- Broad Economy / Notification changes require re-authentication + explicit confirmation.

---

# 111. Role-Based Access Control

Recommended role categories:

- Content Author.
- Language Reviewer.
- Semantic Reviewer.
- Game Designer.
- Publisher.
- LiveOps Operator.
- Support Agent.
- Analyst.
- Admin.

---

# 112. Permission Model

**PROPOSED**

Granular permissions:

- `content.read`
- `content.write`
- `content.review.language`
- `content.review.semantic`
- `level.read`
- `level.write`
- `solver.run`
- `publish.content`
- `liveops.write`
- `economy.write`
- `monetization.write`
- `player.support.read`
- `player.support.adjust`
- `admin.users.manage`

---

# 113. Least Privilege

Users should receive only permissions needed for their job.

Content Author should not automatically have:

- Wallet adjustment.
- economy changes.
- Admin-user management.

---

# 114. Environment Permissions

**PROPOSED**

A user may have different permissions per:

- DEV.
- STAGING.
- PROD.

Example:
Designer can publish to Staging but not Production.

---

# 115. Production Publish Permission

Production publication should be restricted to:

- Publisher.
- Admin.
- explicitly authorized LiveOps role.

---

# 116. Four-Eyes Approval

**PROPOSED**

For high-risk production operations, optionally require second approval.

Candidates:

- economy change.
- major Event launch.
- broad push campaign.
- bulk content publish.
- production Level Move-Limit changes.

Not mandatory for a one-person team.

---

# 117. Admin Session Security

Recommended:

- short idle timeout.
- secure cookies/tokens.
- reauthentication for critical actions.
- logout all sessions capability.

Exact policy TBD.

---

# 118. CMS Environment Banner

Clearly show:

- DEV.
- STAGING.
- PROD.

Production should have strong visual distinction to prevent accidental edits.

---

# 119. Dangerous Action Confirmation

Actions such as:

- delete.
- deactivate.
- publish.
- send push.
- change economy.
- grant Coins.

should require confirmation with explicit affected scope.

---

# 120. Soft Delete

Published entities should generally be:

- disabled/deprecated.

not hard-deleted.

Draft-only unused content may be hard-deletable.

---

# 121. Version History

Content/Level/Event/config screens should show historical versions.

Allow:

- view.
- compare.
- restore/create new version.

Do not mutate old published versions silently.

---

# 122. Diff Viewer

**PROPOSED**

For versioned entities show:

- old value.
- new value.
- highlighted changes.

Important for:

- clue edits.
- Move Limit.
- reward config.
- Event timing.

---

# 123. Autosave

**PROPOSED**

Draft editor may autosave.

Production publish remains explicit.

---

# 124. Draft Locking

For small team, simultaneous editing conflicts may be rare.

Possible:

- optimistic concurrency.
- edit warning.
- soft lock.

Exact mechanism TBD.

---

# 125. Concurrency Control

Use entity version/revision.

If another admin updated same item:

- prevent silent overwrite.
- show conflict.

---

# 126. Form Validation

Forms should validate:

- required fields.
- supported enums.
- numeric ranges.
- IDs.
- content compatibility.
- asset status.

---

# 127. Cross-Entity Validation

Before publication:

- Variant Members active.
- Association approved.
- Level Template active.
- referenced assets published.
- reward config valid.
- app compatibility valid.

---

# 128. Publication Gate

A content/Level item can publish only if all required checks pass.

Potential checks:

- editorial approved.
- Solver validation.
- QA.
- compatibility.
- no blocker issues.

---

# 129. Validation Severity

**PROPOSED**

- ERROR → publish blocked.
- WARNING → publish allowed with confirmation.
- INFO → informational.

---

# 130. Publication Preview

Before final publish show:

- entities affected.
- versions.
- bundle impact.
- compatibility.
- warnings.
- scheduled activation.

---

# 131. Scheduled Publishing

Support:

- publish now.
- publish at date/time.

Useful for:

- Events.
- content releases.
- Daily Challenge.

---

# 132. Scheduled Deactivation

Support:

- Event expiry.
- time-sensitive content.
- temporary campaigns.

---

# 133. Rollback

Authorized users should be able to rollback:

- content bundle.
- Event.
- Remote Config.
- feature flag.
- economy config where safe.

Wallet transactions are corrected, not rolled back as config state.

---

# 134. Content Disable

Immediate disable should:

- remove item from future generation.
- preserve historical analytics.
- not break already persisted Attempts.

Exact active Attempt behavior depends on versioning.

---

# 135. Level Disable

If Level Configuration is broken:

- deactivate version.
- publish replacement.
- preserve progression.

---

# 136. Bulk Level Generation

**PROPOSED**

CMS may generate draft Level Definitions from:

- progression template.
- Difficulty Wave.
- Level Template set.

All generated Levels remain Draft until reviewed.

---

# 137. Bulk Simulation

Allow:

- select Chapter.
- run N simulations/Level.
- export metrics.

Useful before release.

---

# 138. Content Coverage Dashboard

**PROPOSED**

Show coverage:

- approved Associations.
- variants.
- Members.
- by relation type.
- by semantic difficulty.
- by topic.
- by dialect.
- by content type.

Useful for launch capacity planning.

---

# 139. Reuse Dashboard

Show:

- most reused Associations.
- most reused Members.
- recent exposure.
- reuse cooldown warnings.

---

# 140. Topic Distribution Dashboard

Show Main Journey content mix by topic.

Helps prevent accidental overconcentration.

---

# 141. Difficulty Distribution Dashboard

Show content semantic tiers and Level B/S distribution.

---

# 142. Missing Content Alert

Warn when a Level pool cannot satisfy:

- association count.
- group sizes.
- semantic band.
- content-type requirements.
- reuse rules.

---

# 143. Content Pool Dry-Run

**PROPOSED**

Admin can simulate content selection without board generation.

Output:

- eligible Associations.
- rejected candidates.
- conflict reasons.
- pool size.

---

# 144. Duplicate-Level Content Detection

Warn if consecutive Levels receive:

- same Association.
- same clue.
- high Member overlap.

Exact cooldown rules TBD.

---

# 145. Asset Management

Asset library should support:

- upload.
- search.
- preview.
- status.
- version.
- usage references.
- disable.
- replace.

---

# 146. Asset Usage

Show every content item using an asset before replacement/deactivation.

---

# 147. Asset Validation

Check:

- file format.
- dimensions.
- size.
- transparency if required.
- content type.
- review status.

---

# 148. Admin Localization

CMS UI may initially be English or bilingual.

Puzzle editorial fields must fully support Arabic and RTL.

No final Admin UI language is approved.

---

# 149. RTL Editorial Experience

For Arabic fields:

- right-aligned input.
- RTL preview.
- correct cursor behavior.
- mixed Arabic/Latin handling.
- copy/paste quality.

---

# 150. Editor Keyboard/Character Helpers

**PROPOSED**

Optional utilities:

- insert Arabic diacritics.
- normalization preview.
- suspicious character warnings.

Avoid modifying text automatically without editor awareness.

---

# 151. CMS Performance

Target:

- fast list/filter operations.
- paginated large content sets.
- asynchronous heavy Solver/simulation jobs.
- image thumbnails cached.

Exact numeric performance targets TBD.

---

# 152. Pagination

Use server-side pagination/filtering for large tables.

Avoid loading full Content Library at once.

---

# 153. Saved Filters

**PROPOSED**

Editors may save views such as:

- "Needs Arabic Review"
- "S4/S5 Content"
- "Event-only"
- "Illustration Missing"

---

# 154. Bulk Assignment

Assign reviewer to selected items.

Useful as editorial team grows.

---

# 155. Review Queue

Dedicated queue may sort by:

- priority.
- due date.
- content scope.
- campaign/Event.
- reviewer.

---

# 156. Task Management

CMS may include lightweight editorial tasks or integrate external project management.

Full task/project management is not required inside CMS.

---

# 157. Comments

**PROPOSED**

Entity-level comments may support collaboration.

MVP can rely on review notes if team is small.

---

# 158. Notifications to Admin Staff

Optional internal notifications:

- review assigned.
- publish failed.
- Event missing.
- Solver simulation done.

Not required for MVP.

---

# 159. API Boundaries

**CONFIRMED — Final Decision Register v1.1**

CMS uses approved Admin/security boundaries only.

Admin/CMS accesses **Firebase/GCP** data and privileged operations only through approved security boundaries; **no unrestricted client-side production mutation**.

Admin frontend should not connect directly to production data stores with elevated credentials.

---

# 160. Admin API

Potential groups:

- `/admin/content`
- `/admin/associations`
- `/admin/members`
- `/admin/variants`
- `/admin/levels`
- `/admin/solver`
- `/admin/events`
- `/admin/config`
- `/admin/support`
- `/admin/audit`

Exact routes TBD.

---

# 161. API Authorization

Every Admin endpoint must verify:

- authenticated admin.
- permission.
- environment.
- entity-level constraints where applicable.

---

# 162. Admin API Idempotency

Use idempotency for:

- publish.
- Wallet compensation.
- entitlement correction.
- scheduled notification send.

---

# 163. Background Jobs

CMS may create jobs for:

- bundle build.
- simulation.
- AI generation.
- bulk import.
- notification campaign.
- scheduled publication.

---

# 164. Job Status UI

Show:

- queued.
- running.
- progress.
- completed.
- failed.
- retry.

---

# 165. Failed Job Handling

Show:

- error code.
- friendly explanation.
- technical details for privileged roles.
- retry option where safe.

---

# 166. AI Job Safety

AI generation job failure must never partially publish content.

All output remains Draft.

---

# 167. Staging Preview

Admin should support preview against Staging before Production publication.

---

# 168. Production Preview

Where feasible:

- preview content card.
- Level layout.
- Event screens.

without actually activating to players.

---

# 169. Internal Audience

**PROPOSED**

Feature flags may expose new content/Event to internal test accounts before full launch.

---

# 170. QA Checklist Integration

Entities may have checklists:

- Arabic approved.
- semantic approved.
- Solver passed.
- device preview.
- analytics configured.
- rollout checked.

---

# 171. Release Readiness View

**PROPOSED**

For upcoming release/Event show one screen summarizing:

- unresolved blockers.
- content status.
- Level status.
- Solver.
- assets.
- config.
- notification.
- analytics.
- compatibility.

---

# 172. System Health

CMS can display operational health:

- Cloud Functions / Cloud Run health.
- Admin/CMS API boundaries.
- Firestore / Storage status indicators.
- Content Bundle service.
- Solver simulation jobs.
- FCM / notification service.
- Firebase/GCP native monitoring links.

Do **not** assume Azure Application Insights. Exact Firebase/GCP quotas/billing remain **TBD**.

---

# 173. Incident Banner

**PROPOSED**

Admin Home can show active incident banner.

Examples:

- purchases degraded.
- Daily Challenge unavailable.
- content update paused.

---

# 174. Maintenance Actions

Authorized admin may:

- disable feature flag.
- rollback bundle.
- pause Event.
- disable ads.
- stop notification campaign.

Do not expose dangerous infrastructure-level controls unnecessarily.

---

# 175. Backup Visibility

CMS may display last successful backup timestamp, but actual backup administration belongs to cloud operations.

---

# 176. Privacy Controls

Player support screens should minimize personal data.

Do not expose:

- unnecessary provider tokens.
- secrets.
- full push tokens.
- sensitive device identifiers.

---

# 177. Data Export

Support authorized exports for:

- content.
- Level configs.
- analytics aggregates.
- audit logs.

Player personal-data export requires separate privacy workflow.

---

# 178. Admin Export Audit

High-risk exports should be logged.

---

# 179. Rate Limits

Admin bulk actions/jobs may be throttled to protect backend.

Especially:

- massive simulations.
- AI generation.
- notification sends.

---

# 180. CMS Security

Required principles:

- TLS.
- secure auth.
- MFA for privileged users.
- RBAC.
- audit.
- secure secret handling.
- no direct DB credentials in browser.
- safe file uploads.

---

# 181. CSRF/XSS/Input Security

Admin web app must follow normal web-security controls.

Arabic text should be treated as content, not trusted HTML.

---

# 182. File Upload Security

Validate:

- MIME.
- extension.
- size.
- malicious content.
- storage path.

Use signed uploads or controlled API.

---

# 183. Audit Retention

**CONFIRMED — Final Decision Register v1.1**

Audit log retention: **2 years**.

Audit logs should generally be retained longer than debug logs.

---

# 184. Admin Session Audit

Potentially record:

- login.
- logout.
- failed login.
- role change.
- sensitive action.

---

# 185. CMS MVP P0 Scope

Recommended P0:

- Admin authentication.
- RBAC basics.
- Dashboard.
- Association CRUD.
- Member CRUD.
- Variant CRUD.
- Arabic/semantic review.
- Level Definition CRUD.
- Level Config.
- Solver sample validation.
- batch simulation basic.
- Content Bundle publish.
- deactivate/rollback.
- Remote Config basics.
- Economy config basics.
- Purchase product metadata.
- Audit Log.
- basic Player Support.
- DEV/STAGING/PROD separation.

---

# 186. CMS P1 Scope

Add:

- Daily Reward config.
- Daily Challenge calendar.
- Smart Notification campaigns.
- Emoji/Illustration workflow improvements.
- richer content analytics.
- saved filters/review queues.
- AI content assistant.

---

# 187. CMS Post-MVP Scope

Add:

- Events.
- Packs.
- Leaderboards config.
- Achievements.
- Collections.
- Cosmetics.
- advanced experimentation.
- advanced support tools.
- richer LiveOps calendar.
- semantic duplicate search.
- advanced approval workflows.

---

# 188. CMS Decision Register — Confirmed

The CMS must support these **CONFIRMED** product needs:

1. AI-assisted content + mandatory human approval.
2. Association/Member/Variant content model.
3. Arabic-first editorial content.
4. Level configuration.
5. Solver validation.
6. content activation/deactivation.
7. Main Journey content.
8. Daily Challenge at launch (P0) plus CMS calendar/support.
9. Events/Packs post-launch / Full Product; CMS should be Event-ready.
10. Remote Config.
11. Analytics visibility.
12. economy and monetization operational configuration.
13. versioning.
14. auditability.
15. content types including Text/Number/Symbol/Emoji/Illustration.

---

# 189. CMS Decision Register — Proposed / Requires Approval

The following remain **PROPOSED/TBD**:

1. Exact admin navigation IA.
2. Exact content workflow status labels.
3. Exact roles/permissions matrix details.
4. Four-eyes approval (optional for small team).
5. Bulk import/export formats.
6. AI assistant feature depth.
7. Level Template management UI polish.
8. Solver solution viewer UX.
9. Batch simulation UX.
10. Content bundle publication workflow details.
11. Player Support scope depth.
12. Admin UI language (EN vs bilingual).
13. Saved filters/review queue.
14. Admin staff notifications.
15. Event workflow (Events are post-launch).
16. Daily Challenge auto-generation.
17. Economy config approval policy details (re-auth + confirm already required for broad changes).
18. Notification campaign approval details.
19. Internal test audience mechanics.
20. System health widget set.
21. File upload pipeline details.
22. Content duplicate vector search.
23. Active Attempt support/debug depth.
24. Firebase/GCP quotas/billing for CMS-driven jobs.

**CONFIRMED (no longer open):** Angular CMS; Microsoft Entra ID + MFA; Firebase/GCP via security boundaries; audit retention 2 years; production publish separated from ordinary editing; ASP.NET+PG deferred; Azure stack superseded for MVP.

---

# 190. Recommended Approval Order

Before implementing CMS:

1. Approve MVP CMS scope.
2. approve roles/permissions.
3. approve content workflow.
4. approve content data-entry forms.
5. approve Level Config editor.
6. approve Solver validation experience.
7. approve publication/rollback workflow.
8. approve economy/config safety model.
9. approve audit requirements.
10. approve Player Support scope.
11. CMS frontend/auth already confirmed (Angular + Entra); implement against Firebase/GCP boundaries.
12. build MVP.
13. add LiveOps/Event tooling after Daily launch operations stabilize (Events post-launch).

---

# 191. Recommended MVP CMS Baseline

A pragmatic first CMS should prioritize:

- excellent Arabic content editing.
- simple human review.
- Level configuration.
- one-click Solver validation.
- sample playable preview.
- safe publication.
- rollback.
- audit.
- essential economy/config controls.

It should avoid spending months building:

- advanced campaign automation.
- complex internal task management.
- sophisticated semantic search.
- multi-step enterprise approval workflows.

until the content operation proves it needs them.

---

# 192. Confirmed Admin Technology Direction

**CONFIRMED — Final Decision Register v1.1 (Firebase-first)**

- CMS frontend: **Angular**.
- Admin authentication: **Microsoft Entra ID** + MFA.
- Privileged operations / data access via approved security boundaries into **Firebase / GCP** (Firestore, Storage, Cloud Functions / Cloud Run as needed).
- Solver validation reusable in CMS/CI (Pure Dart core / hybrid execution model).
- Audit retention: **2 years**.

**DEFERRED (not MVP baseline):**

- ASP.NET Core + PostgreSQL backend (reconsider only if Firebase-first proves insufficient).

**SUPERSEDED for MVP:**

- Azure Container Apps / Azure PostgreSQL / Azure App Insights and other Azure always-on stack assumptions from earlier proposals.

---

# 193. CMS UX Priority

The highest-value operator experience is:

```text
Create Content
→ Review
→ Build Level
→ Generate/Play Sample
→ Solver Validate
→ Approve
→ Publish
→ Monitor
```

This loop should be faster than manually editing files or database records.

---

# 194. Dependencies

This Admin/CMS Specification feeds:

1. **API Specification**
2. **Content Metadata Schema**
3. **Level Configuration Schema**
4. **Cloud Save & Sync Specification**
5. **Remote Config Specification**
6. **Notification Specification**
7. **QA & Automated Validation Strategy**
8. **Security Architecture**
9. **MVP Product Backlog / WBS**
10. **Operations Runbook**

---

# 195. Baseline Status

This document is **Admin/CMS Specification v1.0** — **Decision-Aligned** to **Final Decision Register v1.1** (Firebase-first).

It defines the required content, level, Solver, LiveOps, economy, configuration, support, analytics, RBAC, audit, publishing, rollback, and operational capabilities of the Admin/CMS platform.

Angular + Entra ID, Firebase/GCP security boundaries, and 2-year audit retention are **CONFIRMED**. ASP.NET Core + PostgreSQL remain **DEFERRED**; Azure always-on stack is **SUPERSEDED** for MVP.

**End of Admin/CMS Specification v1.0**
