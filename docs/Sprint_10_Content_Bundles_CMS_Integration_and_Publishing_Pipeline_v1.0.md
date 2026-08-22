# Sprint 10 — Content Bundles, CMS Integration & Publishing Pipeline v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Content Operations / Remote Content / Publishing / CMS Integration  
**Depends On:** Sprint 9 — Daily Reward, Daily Challenge, Streak & Notifications v1  
**Primary App:** `apps/mobile`  
**Admin/CMS:** `apps/admin`  
**Content Delivery:** Bundled + Firebase/GCP-native remote delivery  
**Primary Storage:** Firebase Storage  
**Metadata / Control Plane:** Firestore and/or trusted backend config  
**Trusted Backend:** Cloud Functions and/or Cloud Run  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 10 Objective

Implement the first production-capable content operations and publishing pipeline for **سوليتير العرب: أسطورة المعاني**.

Sprint 10 must establish:

- versioned content bundle schema;
- bundled fallback content;
- remote content bundles;
- manifest/version metadata;
- checksum/hash validation;
- schema/rules compatibility checks;
- atomic bundle activation;
- last-known-valid rollback;
- emergency production disable switches;
- CMS-to-bundle publishing contract;
- content lifecycle states;
- Arabic/semantic approval workflow;
- human approval gate;
- production publishing permissions;
- publisher separation;
- audit trail;
- first production-ready ingestion path for Journey Levels, Associations, Chapters, Story Beats, and Daily Challenge content references;
- safe app fallback when remote content is broken or unavailable.

The goal is:

> **Content can be authored, reviewed, published, disabled, rolled back, and consumed without requiring a mobile release for every content update.**

---

# 2. Sprint 10 Success Criteria

Sprint 10 is complete only when:

1. Content bundle schema is versioned.
2. App ships with bundled last-resort content.
3. Remote content can be downloaded.
4. Bundle integrity is hash/checksum validated.
5. Bundle schema is validated before activation.
6. Rules compatibility is validated before activation.
7. Invalid bundle is never activated.
8. Activation is atomic.
9. Last-known-valid bundle is retained.
10. Rollback to last-known-valid works.
11. App works offline with already-activated content.
12. App works if Firebase Storage is unavailable.
13. Production content can be disabled without mobile release.
14. CMS produces bundle-compatible content.
15. Draft/Review/Approved/Published states exist.
16. Human Arabic/semantic approval is mandatory.
17. AI-generated content remains Draft only.
18. Publisher role is separate from production-content approver.
19. Admin actions are audited.
20. Journey/Chapter/Level/Association/Story content can be loaded through the new pipeline.
21. Daily Challenge definitions can reference approved content bundle versions.
22. Client cannot mutate production content directly.
23. Publishing uses trusted backend operations.
24. Content validation tests and rollback scenarios pass.

---

# 3. Non-Goals

Do NOT implement in Sprint 10:

- full final CMS visual polish;
- AI automatic publishing;
- automatic semantic approval;
- unrestricted production mutation;
- arbitrary code execution through content;
- dynamic gameplay rule changes;
- new Game Engine rules;
- new currencies;
- Events;
- Leaderboards;
- XP;
- Achievements;
- Collections;
- final production 250-Level authoring if content is not ready;
- separate paid CDN;
- Azure content hosting;
- Elasticsearch/OpenSearch.

---

# 4. Approved Content Delivery Strategy

Approved:

```text
Bundled Content
    +
Remote Versioned Bundles
```

Remote delivery:
- Firebase Storage or equivalent Firebase/GCP-native static delivery.

No separate paid CDN for MVP unless measured need appears later.

---

# 5. Content Safety Principle

Downloaded content must follow:

```text
download
  ↓
validate integrity
  ↓
validate schema
  ↓
validate rules compatibility
  ↓
validate content constraints
  ↓
stage
  ↓
atomic activate
```

Never activate directly from raw download.

---

# 6. Last-Known-Valid Principle

The app must always retain:

```text
bundled fallback
+
lastKnownValidRemoteBundle
```

If new remote bundle fails:
- keep current active bundle;
- log failure;
- never brick Journey.

---

# 7. Content Bundle Scope

Sprint 10 bundle should support:

- Chapter definitions;
- Level definitions;
- Association variants;
- Member/Association Card references;
- Semantic Difficulty metadata;
- Board Difficulty target references;
- Journey structure;
- Story Beat metadata;
- Story dialogue content;
- Story asset references;
- Daily Challenge eligible content/config refs;
- localization text references where appropriate;
- content disable flags.

Do not place authoritative economy secrets or server credentials in bundle.

---

# 8. Content Bundle Structure

Recommended logical layout:

```text
content-bundle/
├── manifest.json
├── chapters.json
├── levels.json
├── associations.json
├── story_beats.json
├── localization/
│   └── ar.json
├── daily/
│   └── challenge_profiles.json
└── assets_manifest.json
```

Exact physical split may differ.

Keep content types independently testable.

---

# 9. Manifest

Required fields:

```text
bundleId
bundleVersion
schemaVersion
rulesVersion
minimumAppVersion?
maximumAppVersion?
createdAt
publishedAt
contentHash
files
contentTypes
generatorCompatibility?
solverCompatibility?
status
```

Do not require unnecessary fields.

---

# 10. Bundle Version

Use stable, sortable versioning.

Recommended:
- semantic-ish version or monotonic integer.

Example:

```text
2026.08.22.1
```

or:

```text
42
```

Exact scheme can be implementation choice.

Must support:
- compare newer/older;
- rollback;
- audit.

---

# 11. Schema Version

Separate:

```text
schemaVersion
```

from:

```text
bundleVersion
```

Schema version changes when structure/contracts change.

Bundle version changes when content changes.

---

# 12. Rules Version Compatibility

Bundle must declare supported Game Engine rules version.

Client must reject bundle if:

```text
bundle.rulesVersion
```

is unsupported.

Do not attempt to interpret content designed for unknown gameplay rules.

---

# 13. App Version Compatibility

Optional but recommended:

```text
minAppVersion
maxAppVersion
```

Use only if needed.

If incompatible:
- keep previous active bundle.

---

# 14. File Hashes

Each bundle file should include checksum.

Recommended:
- SHA-256.

Manifest includes:
```text
path
sha256
size
```

Client validates before parsing.

---

# 15. Whole-Bundle Hash

Optional additional:

```text
contentHash
```

computed from canonical manifest/file hashes.

Useful for:
- cache key;
- diagnostics;
- corruption detection.

---

# 16. Signature Boundary

Cryptographic signing may be considered later.

Sprint 10 baseline can rely on:
- HTTPS;
- Firebase Storage access;
- trusted publish pipeline;
- per-file hash.

If signing is introduced:
- document key management.

Do not invent signing infrastructure unless needed.

---

# 17. Remote Manifest Discovery

Recommended small control document:

```text
content/current
```

Contains:

```text
activeBundleVersion
bundlePath
minimumRequiredBundle?
disabledBundleVersions
updatedAt
```

Client reads this occasionally.

---

# 18. Kill Switch / Disable Switch

Approved:

Publisher/Admin can immediately disable bad content without app release.

Need server-controlled state:

```text
disabledBundleVersions
disabledLevelIds
disabledAssociationVariantIds
disabledStoryBeatIds
```

Use narrow controls where practical.

Do not require full new bundle just to disable one bad item.

---

# 19. Emergency Disable Behavior

If active content becomes disabled:

Client should:
- stop starting affected new content;
- fallback to safe alternative/previous version where possible;
- preserve active Attempt unless safety/content corruption requires otherwise.

Do not destroy active player state casually.

---

# 20. Level Disable

If a Level is disabled:

- prevent new starts;
- mark temporarily unavailable;
- avoid breaking Journey progression permanently.

Fallback policy may require:
- replacement LevelDefinition;
- emergency bundle.

Do not auto-skip progression unless explicitly approved.

---

# 21. Association Variant Disable

If content issue affects a Variant:

- Generator/content selector must avoid it for future Attempts.

Existing active Attempt:
- may continue if already generated and safe;
- exact emergency policy can be operational.

---

# 22. Story Beat Disable

If Story Beat is disabled:
- skip auto-trigger;
- keep progression moving.

Story Archive should not expose disabled content.

---

# 23. Content States

Recommended lifecycle:

```text
Draft
InReview
Approved
Published
Disabled
Archived
Rejected
```

AI-generated content starts as:

```text
Draft
```

Never:
```text
Approved
```

automatically.

---

# 24. Human Approval Gate

Approved:

Human Arabic + semantic approval is mandatory before production publishing.

Content approval should verify:

- Arabic quality;
- semantic correctness;
- cultural appropriateness;
- association membership correctness;
- clue clarity;
- duplication/reuse constraints;
- content-type constraints;
- story canon alignment where narrative content involved.

---

# 25. AI Draft Boundary

AI may:

- propose Associations;
- propose Member Cards;
- suggest variants;
- propose story dialogue drafts;
- suggest difficulty metadata.

AI may not:

- approve;
- publish;
- bypass human review.

---

# 26. Role Separation

Approved:

Production content approval is separated from Publisher.

Suggested roles:

```text
ContentEditor
ContentReviewer
ContentApprover
Publisher
Admin
```

Publisher cannot self-approve content if separation is enforced.

---

# 27. Admin Authentication

Existing approved baseline:

- Microsoft Entra ID
- MFA

Do not replace with Firebase Auth without explicit approval.

---

# 28. Publisher Permission

Publisher can:

- publish approved content;
- rollback;
- disable bad content;
- activate validated bundle.

Publisher cannot:
- approve their own content if policy separates duties;
- alter gameplay rules.

---

# 29. Audit Log

Every sensitive CMS/publishing action records:

```text
actorId
actorRole
action
entityType
entityId
previousState
newState
timestamp
reason?
bundleVersion?
environment
```

Retention baseline:
- 2 years.

---

# 30. CMS Scope for Sprint 10

Implement only what is needed for production content lifecycle.

Minimum modules:

- Associations;
- Chapters;
- Levels;
- Story Beats;
- Bundle Build;
- Validation Results;
- Approval Queue;
- Publish History;
- Rollback;
- Disable Controls;
- Audit Log view.

No need for full final analytics dashboard.

---

# 31. Association CMS Model

Fields:

```text
associationVariantId
associationId
associationClue
memberCards
contentType
semanticDifficulty
visualFlag
chapterEligibility
status
createdBy
reviewedBy
approvedBy
version
```

Keep localization/content references external where appropriate.

---

# 32. Association Validation

CMS validation should catch:

- duplicate Card IDs;
- missing Members;
- mixed association IDs;
- unsupported group sizes;
- invalid content type mix;
- exact duplicate Variant;
- duplicate clue within invalid cooldown context if Journey history supplied;
- missing approval metadata.

---

# 33. Homogeneous Member Content Type

Approved:

Within one Association:
- Member content type should be homogeneous.

Examples:
- all text;
- all image.

Association Card remains clue text.

CMS validation should enforce.

---

# 34. Visual Association Constraint

Launch rule:
- early/mid Levels max one visual Association.

Level validation must check:
- number of visual Associations <= configured limit.

---

# 35. Association Reuse Rules

Approved:
- same Association Clue reuse cooldown ≥ 20 Levels.
- exact same Variant cannot repeat in same Chapter.

This belongs to content validation/publishing pipeline.

CMS should flag violations.

---

# 36. Level CMS Model

Fields:

```text
levelDefinitionId
chapterId
globalLevelNumber
chapterLevelNumber
waveIndex
wavePosition
levelConfiguration
boardDifficultyTarget
semanticDifficultyTier
associationVariantRefs
contentSelectionMode
storyMilestoneRef?
enabled
status
```

---

# 37. Chapter Structure Validation

Approved:

- 5 launch Chapters.
- 50 Levels per Chapter.
- 10-Level Wave × 5.

Validation should ensure:
- chapter-local numbering 1–50;
- wave positions valid;
- global numbering unique;
- no missing required sequence when publishing full Chapter.

---

# 38. First Five Chapters

Canonical:

1. Cairo — القاهرة: أول خيط
2. Alexandria — الإسكندرية: أصداء الغياب
3. Beirut — بيروت: ما بين السطور
4. Marrakech — مراكش: متاهة المعنى
5. Dubai — دبي: ما بعد الذاكرة

Store stable IDs independently from Arabic display title.

---

# 39. Story Beat CMS

Fields:

```text
storyBeatId
chapterId
beatType
trigger
dialogueLines
speakerRefs
backgroundAssetRef
characterAssetRefs
audioReactionRefs?
skippable
status
canonVersion
```

---

# 40. Narrative Canon Validation

Narrative content must not contradict approved Story Bible.

CMS cannot fully automate canon judgment.

At minimum:
- reviewer checklist;
- canonical character/location references;
- required human narrative approval.

---

# 41. Story Trigger Validation

For 50-Level Chapter baseline:

- Start
- Midpoint
- Ending

If exact trigger Levels configured:
- validate no duplicate trigger;
- validate within Chapter bounds.

---

# 42. Daily Challenge Content Integration

Daily Challenge definition should reference:

```text
bundleVersion
levelConfigurationRef
contentPoolRef
seed/challengeId
```

Do not embed unapproved ad hoc content outside bundle lifecycle.

---

# 43. Bundle Build

Publisher workflow:

```text
Approved Content
  ↓
Bundle Builder
  ↓
Static Validation
  ↓
Game Engine Validation
  ↓
Solver/Generator Validation
  ↓
Bundle Artifact
  ↓
Hash Manifest
  ↓
Staging Publish
  ↓
Smoke Test
  ↓
Production Activate
```

---

# 44. Static Validation

Must validate:

- JSON/schema;
- IDs;
- references;
- uniqueness;
- chapter/level sequence;
- content statuses;
- role approvals;
- asset references;
- manifest correctness.

---

# 45. Engine Validation

For every Level/config:
- construct valid model;
- validate Game Engine compatibility.

Invalid state/config:
- publishing blocked.

---

# 46. Generator Validation

Run representative generation.

For critical Level templates:
- generate sample boards;
- validate Solver acceptance.

Do not require exhaustive 10,000 simulations inside interactive publish if too expensive.

---

# 47. Solver Validation

Publishing should fail if required technical configs are proven invalid/unsolvable.

For production critical templates:
- heavier QA simulation can be pre-release gate.

---

# 48. 10,000+ Simulation Release Gate

Approved QA baseline:

- 10,000+ board simulations for critical templates/configs pre-release.

Sprint 10 should make bundle/config inputs compatible with this pipeline.

Do not run 10,000 automatically on every CMS save.

---

# 49. Validation Severity

Recommended:

```text
Error
Warning
Info
```

Error:
- blocks publish.

Warning:
- requires acknowledgement/approval depending type.

---

# 50. Publishing Environments

Support:

```text
DEV
TEST
STAGING
PROD
```

No direct DEV draft → PROD bypass.

Recommended flow:
- publish to STAGING;
- validate;
- promote to PROD.

---

# 51. Bundle Promotion

Promotion should preserve:

```text
bundleVersion
hashes
```

Do not rebuild different bytes silently during promotion.

---

# 52. Production Activation

Trusted backend updates current bundle pointer atomically.

Client then discovers new version.

Do not overwrite currently active file in place.

Use immutable versioned paths.

---

# 53. Storage Paths

Recommended:

```text
/content/{environment}/bundles/{bundleVersion}/...
```

and a small active pointer/control document.

Immutable bundle paths preferred.

---

# 54. Atomic Activation

Pattern:

1. upload full immutable bundle;
2. verify;
3. publish manifest;
4. update active pointer as final atomic step.

Client never sees half-uploaded active content.

---

# 55. Client Content Manager

Recommended application service:

```text
ContentManager
```

Responsibilities:

- load bundled baseline;
- load active local bundle;
- check remote manifest;
- download candidate;
- verify;
- stage;
- atomically activate;
- rollback;
- expose active version.

---

# 56. Content Manager States

Suggested:

```text
usingBundled
usingLocalRemoteBundle
checkingForUpdate
downloading
validating
activating
updateFailed
rollbackPerformed
```

Do not block Home unnecessarily.

---

# 57. App Startup Content Flow

Recommended:

1. load bundled content;
2. load last-known-valid remote bundle if available;
3. activate local valid version;
4. start app;
5. check remote update in background;
6. download/validate;
7. activate when safe.

Do not block first screen on network.

---

# 58. Atomic Local Activation

Recommended storage layout:

```text
content/
├── active/
├── staged/
├── previous/
└── metadata
```

Bundled content remains application asset.

Activation:
- update local active-version pointer atomically.

---

# 59. Local Content Metadata

Persist:

```text
activeBundleVersion
previousBundleVersion
lastValidationResult
lastUpdateCheckAt
lastSuccessfulActivationAt
activeContentHash
```

---

# 60. Bundle Download

Use Firebase Storage or approved Firebase/GCP-native static delivery.

Do not depend on separate CDN.

---

# 61. Partial Download Recovery

If app closes during download:
- staged bundle remains incomplete;
- never active;
- clean/retry later.

---

# 62. Hash Failure

If file hash mismatch:
- reject entire candidate bundle;
- delete/quarantine staged corrupt data;
- log;
- keep active bundle.

---

# 63. Schema Failure

If parse/schema validation fails:
- reject candidate;
- no activation.

---

# 64. Rules Version Failure

If rules unsupported:
- reject;
- keep previous bundle;
- optionally surface app-update requirement if configured.

---

# 65. Missing Asset

If mandatory asset missing:
- reject bundle or affected content according to explicit manifest policy.

Do not render broken required content silently.

---

# 66. Optional Asset

If explicitly optional:
- fallback placeholder allowed.

Mark optional in schema.

---

# 67. Rollback

Trusted Publisher can mark previous valid bundle active.

Client:
- discovers rollback pointer;
- validates cached/downloaded bundle;
- switches safely.

---

# 68. Automatic Client Rollback

If newly activated bundle produces verified content-loading/compatibility failure:

- rollback to previous last-known-valid version;
- log incident;
- avoid activation retry loop.

Do not infer bundle fault from unrelated crash.

---

# 69. Bad Bundle Quarantine

Client may temporarily remember rejected bundle versions.

Corrected content should publish as a new bundle version.

---

# 70. Content Update Frequency

Check on:
- app launch/resume if stale;
- safe Home/Journey boundary;
- DEV manual refresh.

Avoid continuous polling.

---

# 71. Content Cache

Retain at least:
- active;
- previous;
- bundled fallback.

Keep any version required by:
- active Attempt;
- current Daily Challenge.

Avoid unbounded local cache.

---

# 72. Content Size Metrics

Track:
- bundle size;
- download duration;
- validation duration;
- activation duration.

Thresholds remain tuning decisions.

---

# 73. Compression

Archive/compress if measured useful.

If used:
- validate archive;
- validate extracted files against manifest.

---

# 74. Localization Content

Dynamic content must support Arabic.

Arabic is required for launch production content.

Do not make Arabic review optional.

---

# 75. Arabic Review State

Required:

```text
pending
approved
rejected
```

Production publishing blocked unless approved.

---

# 76. Semantic Review State

Required independently:

```text
pending
approved
rejected
```

Production publishing blocked unless approved.

---

# 77. Narrative Review State

Narrative content should include canon/narrative approval state.

Human review remains mandatory.

---

# 78. Approval Metadata

Store:

```text
approvedBy
approvedAt
approvalVersion
reviewNotes?
```

---

# 79. Edit After Approval

Any material content change:
- invalidates approval;
- returns content to review flow.

Mandatory.

---

# 80. Publish Eligibility

Production bundle may include only content that:

- is Approved;
- has required Arabic approval;
- has semantic approval;
- has narrative approval where applicable;
- passes technical validation;
- is not disabled/archived.

---

# 81. CMS Publishing Service

Trusted operations:

```text
buildBundle
validateBundle
publishToStaging
promoteToProduction
rollbackProduction
disableContent
enableContent
```

Angular client must not write production Storage/control pointers directly.

---

# 82. Admin Reauthentication

For high-impact actions such as:
- PROD publish;
- rollback;
- emergency disable/enable;

use explicit confirmation and appropriate Admin re-authentication/MFA flow.

---

# 83. Audit Retention

Approved:
- 2 years.

Record publish/rollback/disable/approval changes and sensitive permission changes.

---

# 84. CMS Validation Results

Display:
- blocking errors;
- warnings;
- affected IDs;
- remediation context.

---

# 85. Bundle Diff

Before publish, show:

```text
added
changed
removed
disabled
```

for:
- Levels;
- Associations;
- Story Beats;
- Chapters.

---

# 86. Production Diff Confirmation

Publisher confirms:
- version;
- content counts;
- validation summary;
- approval summary;
- previous production version.

---

# 87. Removal Safety

Removing content referenced by Journey/Story/Daily:
- block publishing unless valid replacement/migration exists.

---

# 88. Referential Integrity

Validate all references:

- Level → Chapter;
- Level → Associations/content pools;
- Story Beat → Chapter;
- assets;
- Daily Challenge profiles;
- localization refs.

---

# 89. ID Stability

Published IDs are stable and never reused for unrelated content.

---

# 90. Content Deletion Policy

Prefer:
- Disabled / Archived

over immediate hard deletion of previously published content.

---

# 91. Story Archive Compatibility

Updated Story content can be replayed from current approved version unless future product decision requires historical versions.

Do not duplicate old script into every player record.

---

# 92. Journey Progress Compatibility

Content updates must preserve existing progression.

Avoid changing stable Level identity/global sequencing casually.

---

# 93. Active Attempt Compatibility

A content update must not mutate an active generated Attempt.

Activate new bundle only at safe boundary.

---

# 94. Immutable Asset Paths

Published assets should use immutable/versioned paths so active Attempts can still resolve their content.

---

# 95. Content Fetch Security

Static production content can be client-readable.

Admin/write paths must remain protected.

---

# 96. Storage Rules

Client:
- read intended production bundle/assets;
- write denied.

Trusted publishing backend:
- writes using privileged credentials.

---

# 97. Firestore Control Rules

Client:
- read active pointer/disable metadata;
- write denied.

---

# 98. Content Analytics

Track:

- content_bundle_check
- content_bundle_download_started
- content_bundle_download_completed
- content_bundle_validation_failed
- content_bundle_activated
- content_bundle_rollback
- content_disabled_encountered

Attach:
- bundleVersion;
- schemaVersion;
- contentHash.

---

# 99. Operational Analytics

Track:
- publish frequency;
- validation failures;
- rollbacks;
- emergency disables.

---

# 100. Crashlytics Context

Include:
- activeBundleVersion;
- schemaVersion;
- contentHash;
- current Level ID where safe.

---

# 101. Content Incident Runbook

Document:

1. identify bad item/version;
2. disable item or rollback bundle;
3. verify active pointer;
4. monitor clients;
5. publish corrected new bundle;
6. close incident with audit reason.

---

# 102. QA Preview

Staging CMS should allow previewing:
- Association;
- Level definition;
- Story Beat.

Playable Level preview can use trusted validation tooling.

---

# 103. Gameplay Validation Reuse

Do not duplicate gameplay rules in Angular.

Use:
- Engine/Generator/Solver CLI/backend validation;
- shared schemas for non-gameplay fields.

---

# 104. Validation CLI

Create:

```text
tool/content/content_validate.dart
```

Input:
- content bundle source/artifact.

Output:
- human-readable report;
- machine-readable JSON.

---

# 105. Bundle Builder CLI

Create:

```text
tool/content/content_bundle_build.dart
```

Responsibilities:
- canonicalize;
- validate;
- hash;
- manifest generation;
- package artifact.

---

# 106. CI Publishing Pipeline

Recommended:

```text
Approved CMS Export
  ↓
Trusted Build/CI
  ↓
Validate
  ↓
Build Immutable Bundle
  ↓
Upload STAGING
  ↓
Smoke Test
  ↓
Manual PROD Approval
  ↓
Promote Active Pointer
```

---

# 107. CI Checks

Required:

- schema;
- IDs;
- references;
- approval states;
- Engine compatibility;
- Level Generator config validation;
- Solver validation samples;
- manifest/hash verification.

---

# 108. Manual Production Approval

No automatic production publish after commit/merge.

Explicit authorized publish required.

---

# 109. Rollback Speed

Rollback should be pointer-based and not require rebuild.

---

# 110. Client Version Telemetry

Report active bundle version in analytics and crash diagnostics.

---

# 111. Staged Content Rollout

Optional in v1.

If included:
- cohort/percentage activation;
- previous bundle remains available.

Not required to block Sprint completion.

---

# 112. Minimum Required Bundle

Control plane may expose a minimum version when absolutely necessary.

Avoid hard blocking unless content compatibility truly requires it.

---

# 113. Content Refresh During Gameplay

Download/validate can happen during play.

Activation waits for safe boundary.

---

# 114. Safe Activation Boundary

Good boundaries:
- Home;
- Journey;
- after Attempt ends.

---

# 115. Story Safe Activation

Do not replace a Story Beat while currently playing it.

---

# 116. Daily Challenge Bundle Pinning

Today's Daily Challenge must remain pinned to its referenced bundle/content version.

A global bundle update must not change today's deterministic board.

---

# 117. Daily Bundle Retention

Keep required version until the Daily Challenge expires/completes.

---

# 118. Validation Severity Examples

Blocking:
- duplicate ID;
- missing Member;
- unsupported rules version;
- missing required reference;
- missing required human approvals;
- hash mismatch.

Warning:
- unusual difficulty distribution;
- large asset size;
- near-threshold content reuse.

---

# 119. CMS Minimum Screens

- Content Dashboard
- Associations
- Levels
- Chapters
- Story Beats
- Review Queue
- Approval Queue
- Validation Results
- Bundle Build
- Publish History
- Rollback
- Emergency Disable
- Audit Log

---

# 120. Admin Permissions Matrix

Suggested:

| Action | Editor | Reviewer | Approver | Publisher | Admin |
|---|---:|---:|---:|---:|---:|
| Create/Edit Draft | Yes | Optional | No | No | Yes |
| Submit Review | Yes | Yes | No | No | Yes |
| Review | No | Yes | Yes | No | Yes |
| Approve | No | No | Yes | No | Yes |
| Build Bundle | No | No | Optional | Yes | Yes |
| Publish STAGING | No | No | No | Yes | Yes |
| Publish PROD | No | No | No | Yes | Yes |
| Rollback PROD | No | No | No | Yes | Yes |
| Emergency Disable | No | No | No | Yes | Yes |

Exact role mapping may follow existing Entra groups.

---

# 121. Approval Separation Tests

Ensure:
- Editor cannot self-approve.
- Publisher cannot mutate approval status.
- unauthorized role cannot publish.

---

# 122. Trusted API Contracts

Suggested:

```text
createDraft
updateDraft
submitForReview
reviewContent
approveContent
rejectContent
validateContent
buildBundle
publishStaging
promoteProduction
rollbackProduction
disableContent
enableContent
getPublishHistory
getAuditLog
```

No unrestricted generic production mutation API.

---

# 123. Optimistic Concurrency

CMS entities use:

```text
entityRevision
updatedAt
```

Stale saves must be rejected or merged explicitly.

---

# 124. Draft Autosave

Optional and Draft-only.

Must not alter approval state.

---

# 125. CMS Search/Filter

Support basic filtering by:
- ID;
- Chapter;
- status;
- content type;
- reviewer/approver where applicable.

No external search engine required.

---

# 126. Import / Export

Optional but useful:
- JSON/CSV import.

Imported items:
- Draft;
- fully validated;
- require human approval.

---

# 127. AI Draft Import

AI-assisted content import must set:

```text
source = aiDraft
status = Draft
```

No automatic escalation.

---

# 128. Asset Pipeline

Assets must be:
- versioned;
- existence-validated;
- size/type checked;
- referenced by stable ID/path.

---

# 129. Asset Metadata

Suggested:

```text
assetId
type
storagePath
sha256
size
width?
height?
locale?
required
```

---

# 130. Asset Security

Client:
- read published assets.

Client:
- cannot upload/overwrite production assets.

---

# 131. Content Bundle Tests

Required:

- valid bundle activates;
- hash mismatch rejected;
- malformed JSON rejected;
- unsupported schema rejected;
- unsupported rules version rejected;
- missing file/reference rejected;
- previous active survives failed update;
- rollback succeeds;
- bundled fallback works offline.

---

# 132. CMS Workflow Tests

Required:

- Draft → Review;
- Review → Approved;
- Approved → Published;
- edit after approval invalidates approval;
- AI Draft cannot publish;
- missing Arabic review blocks;
- missing semantic review blocks;
- unauthorized publish denied;
- audit created.

---

# 133. Content Rule Tests

Required:

- same clue reused inside <20-Level cooldown is rejected/flagged as blocking per release validator;
- exact same Variant repeat in same Chapter blocked;
- configured early/mid Level with >1 visual Association blocked;
- mixed Member content type within Association blocked;
- invalid group size blocked;
- duplicate IDs blocked.

---

# 134. Integration Scenario — Publish

### CO-001

1. Editor creates Draft.
2. Reviewer reviews.
3. Arabic and semantic approvals pass.
4. Approver approves.
5. Publisher builds STAGING bundle.
6. validations pass.
7. Staging client activates.
8. Publisher promotes same immutable bundle to PROD.
9. production client downloads/validates.
10. activation happens at safe boundary.

---

# 135. Integration Scenario — Bad Bundle

### CO-002

1. bundle has incorrect hash.
2. client downloads.
3. validation fails.
4. current bundle remains active.
5. failure logged.
6. Journey remains usable.

---

# 136. Integration Scenario — Rollback

### CO-003

1. v12 active.
2. defect discovered.
3. Publisher rolls active pointer to v11.
4. client validates v11.
5. activates safely.
6. rollback audited.

---

# 137. Integration Scenario — Emergency Disable

### CO-004

1. bad Association Variant discovered.
2. Publisher disables it.
3. clients fetch disable metadata.
4. Generator excludes it from future Attempts.
5. no mobile release required.

---

# 138. Integration Scenario — Offline

### CO-005

1. device has last-known-valid bundle.
2. network unavailable.
3. app launches.
4. Journey/content load locally.
5. gameplay works.

---

# 139. Integration Scenario — Active Attempt

### CO-006

1. player starts Level on bundle v20.
2. v21 downloads in background.
3. v21 remains staged.
4. player exits/completes Attempt.
5. v21 activates.
6. board never mutates mid-attempt.

---

# 140. Integration Scenario — Daily Pinning

### CO-007

1. Daily Challenge references v20.
2. v21 becomes global active bundle.
3. today's challenge stays on v20 references.
4. deterministic board remains unchanged.

---

# 141. Integration Scenario — Audit

### CO-008

1. Publisher disables content.
2. audit stores actor/role/item/before/after/time/reason.
3. retention policy is applied.

---

# 142. Performance

Measure:
- manifest fetch;
- download;
- hash validation;
- parse/schema validation;
- activation.

Large validation should not block Flutter UI thread.

---

# 143. Storage Cost Awareness

Measure:
- bundle sizes;
- retained local versions;
- cloud version growth.

No separate CDN unless metrics justify later.

---

# 144. Local Cleanup

Delete obsolete local bundles only when not required by:
- active;
- previous fallback;
- active Attempt;
- active Daily Challenge.

---

# 145. Failure Fallback Chain

```text
Remote Candidate Fails
  ↓
Current Active Remote
  ↓
Previous Valid Remote
  ↓
Bundled Fallback
```

The app should remain usable.

---

# 146. Error Model

Suggested:

```text
manifestUnavailable
downloadFailed
hashMismatch
schemaInvalid
rulesIncompatible
appVersionIncompatible
referenceInvalid
assetMissing
activationFailed
rollbackFailed
bundleDisabled
contentDisabled
```

---

# 147. Content Manager Public API

Recommended:

```dart
Future<ContentSnapshot> loadInitialContent();
Future<ContentUpdateResult> checkForUpdate();
Future<ContentUpdateResult> stageUpdate(...);
Future<ContentUpdateResult> activateStaged();
Future<ContentUpdateResult> rollback();
ContentSnapshot current();
```

---

# 148. Content Snapshot

Suggested:

```text
bundleVersion
schemaVersion
rulesVersion
contentHash
chapters
levels
associations
storyBeats
disableMetadata
source
```

---

# 149. Repository Boundary

Journey, Story, and Daily layers consume typed repositories, not raw JSON.

---

# 150. DTO / Domain Separation

Use:

```text
Bundle DTO
  ↓
Validation / Migration
  ↓
Domain Models
```

---

# 151. Schema Migration

Only perform explicit supported migrations.

Unknown schema:
- reject safely.

---

# 152. Validation Report

Recommended:

```text
isValid
errors[]
warnings[]
bundleVersion
duration
validatedCounts
solverValidationSummary
```

---

# 153. Validation Determinism

Static validation should be deterministic.

Solver pass/fail under fixed configuration should remain deterministic.

---

# 154. Validation Reuse

Gameplay validity comes from Engine/Generator/Solver tooling.

Do not re-code game legality in Admin UI.

---

# 155. Build Reproducibility

Same approved content + same builder version should generate equivalent canonical bundle payload/hash, excluding intentionally variable metadata where normalized.

---

# 156. Bundle Builder Version

Include:

```text
bundleBuilderVersion
```

---

# 157. Validator Version

Include:

```text
contentValidatorVersion
```

---

# 158. Release Notes

Optional operator-facing bundle notes.

Not required in player UI.

---

# 159. Rollback Guard

Target rollback bundle must itself be:
- valid;
- compatible;
- not disabled.

---

# 160. Disable Metadata Freshness

Emergency disable control should be small and lightweight to refresh more often than full bundle.

Still avoid aggressive polling.

---

# 161. High-Impact Confirmation

Require explicit confirmation for:
- Production publish;
- rollback;
- emergency disable/enable.

Rollback/disable reason recommended.

---

# 162. Security Tests

Required:

- mobile client cannot upload content;
- mobile client cannot change active pointer;
- mobile client cannot disable content;
- unauthorized Admin cannot publish;
- Editor cannot approve;
- Publisher cannot forge approvals;
- ordinary roles cannot edit audit log.

---

# 163. Retention

- audit logs: 2 years;
- cloud bundles: enough history for rollback/audit;
- client bundles: only necessary recent versions.

---

# 164. Monitoring

Alert/log:
- repeated validation failures;
- production publish failure;
- rollback;
- active pointer missing;
- high bundled-fallback usage.

---

# 165. CMS Technology

Admin stays:
- Angular.

Do not replatform.

---

# 166. Admin Authentication

Retain:
- Microsoft Entra ID;
- MFA.

---

# 167. Suggested Client Structure

```text
apps/mobile/lib/features/content/
├── application/
├── domain/
├── data/
└── diagnostics/
```

---

# 168. Suggested Admin Structure

```text
apps/admin/src/app/features/content/
├── associations/
├── levels/
├── chapters/
├── story/
├── review/
├── publishing/
├── audit/
└── shared/
```

---

# 169. Suggested Backend Structure

```text
firebase/functions/src/content/
├── build_bundle.ts
├── validate_bundle.ts
├── publish_staging.ts
├── promote_production.ts
├── rollback_production.ts
├── disable_content.ts
├── audit_service.ts
└── content_permissions.ts
```

---

# 170. Suggested Tooling Structure

```text
tool/content/
├── content_validate.dart
├── content_bundle_build.dart
├── content_diff.dart
└── content_simulate.dart
```

---

# 171. Suggested Implementation Order

## Step 1
Bundle schema and manifest.

## Step 2
Typed content models/repositories.

## Step 3
Bundled fallback repository.

## Step 4
Remote manifest discovery.

## Step 5
Download/staging.

## Step 6
Hash/schema/rules/reference validation.

## Step 7
Atomic activation.

## Step 8
Rollback/last-known-valid.

## Step 9
Emergency disable metadata.

## Step 10
CMS content lifecycle.

## Step 11
Review/approval workflow.

## Step 12
Publisher permissions.

## Step 13
Bundle builder/validator tooling.

## Step 14
STAGING/PROD pipeline.

## Step 15
Rollback/disable controls.

## Step 16
Audit.

## Step 17
Journey/Story/Daily integration.

## Step 18
Security/integration testing.

## Step 19
Performance/cost review.

---

# 172. Suggested Commit Sequence

### Commit 1
```text
feat(content): add versioned bundle schema and manifest
```

### Commit 2
```text
feat(content): add bundled and remote content repositories
```

### Commit 3
```text
feat(content): add hash schema rules and reference validation
```

### Commit 4
```text
feat(content): add staged download atomic activation and rollback
```

### Commit 5
```text
feat(content): add emergency disable metadata
```

### Commit 6
```text
feat(admin-content): add content lifecycle review and approval workflow
```

### Commit 7
```text
feat(admin-content): add bundle build publish rollback and disable ui
```

### Commit 8
```text
feat(content-backend): add trusted publishing and audit services
```

### Commit 9
```text
tool(content): add bundle builder validator diff and simulation utilities
```

### Commit 10
```text
test(content): add bundle rollback publishing and permission coverage
```

### Commit 11
```text
security(content): protect storage control plane and publisher actions
```

### Commit 12
```text
docs(content): document content lifecycle publishing and rollback
```

---

# 173. Sprint 10 Definition of Done

Sprint 10 is DONE only when:

- [ ] versioned content bundle schema exists.
- [ ] manifest exists.
- [ ] bundleVersion exists.
- [ ] schemaVersion exists.
- [ ] rulesVersion compatibility exists.
- [ ] per-file hash validation exists.
- [ ] bundled fallback content exists.
- [ ] remote manifest discovery works.
- [ ] remote bundle download works.
- [ ] staged bundle is never active before validation.
- [ ] malformed bundle rejected.
- [ ] hash mismatch rejected.
- [ ] unsupported schema rejected.
- [ ] unsupported rules version rejected.
- [ ] missing required references/assets rejected.
- [ ] atomic activation works.
- [ ] last-known-valid retained.
- [ ] rollback works.
- [ ] offline content works.
- [ ] active Attempt is not mutated by content update.
- [ ] Daily Challenge version remains pinned.
- [ ] emergency disable exists.
- [ ] disabled Association excluded from future generation.
- [ ] disabled Story Beat does not block progression.
- [ ] CMS content lifecycle exists.
- [ ] AI content is Draft only.
- [ ] Arabic approval mandatory.
- [ ] semantic approval mandatory.
- [ ] edit after approval resets approval.
- [ ] Publisher/Approver separation enforced.
- [ ] Microsoft Entra + MFA retained.
- [ ] trusted Production publishing exists.
- [ ] client Production writes denied.
- [ ] bundle builder exists.
- [ ] validation CLI exists.
- [ ] bundle diff exists.
- [ ] STAGING publish exists.
- [ ] PROD promotion exists.
- [ ] rollback exists.
- [ ] audit log exists.
- [ ] audit retention 2 years documented.
- [ ] clue reuse cooldown validation exists.
- [ ] exact Variant same-Chapter repeat blocked.
- [ ] visual Association restriction validation exists.
- [ ] homogeneous Member content validation exists.
- [ ] CO-001 passes.
- [ ] CO-002 passes.
- [ ] CO-003 passes.
- [ ] CO-004 passes.
- [ ] CO-005 passes.
- [ ] CO-006 passes.
- [ ] CO-007 passes.
- [ ] CO-008 passes.
- [ ] Flutter analyze/tests pass.
- [ ] Angular/Admin tests pass.
- [ ] backend/tooling tests pass.

---

# 174. Sprint 10 Exit Gate Before Production Hardening

Do not start Sprint 11 until:

1. remote content cannot brick the app;
2. validation before activation is mandatory;
3. activation is atomic;
4. rollback is proven;
5. emergency disable is operational;
6. human Arabic/semantic review gates are enforced;
7. AI cannot publish;
8. production permissions are tested;
9. published IDs/references are valid;
10. Journey/Story/Daily use typed content repositories;
11. active Attempts remain stable;
12. audit trail is complete;
13. client Production writes are denied;
14. STAGING → PROD promotion is repeatable.

---

# 175. Cursor Execution Prompt — Sprint 10

Use this after Sprint 9 passes its exit gate:

> Implement **Sprint 10 — Content Bundles, CMS Integration & Publishing Pipeline v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_10_Content_Bundles_CMS_Integration_and_Publishing_Pipeline_v1.0.md`
> - latest Content Design System
> - latest Arabic Content Guidelines
> - latest Level Design Framework
> - latest Difficulty Model
> - latest Narrative Canon / Story Bible
> - latest Admin/CMS Specification
> - latest Data Model
> - latest Firebase/Cloud Architecture
>
> Implement:
>
> - bundled fallback content;
> - remote immutable versioned bundles;
> - manifest with bundle/schema/rules versions;
> - per-file SHA-256;
> - remote active-version discovery;
> - staged download;
> - integrity/schema/rules/reference validation;
> - atomic activation;
> - last-known-valid rollback;
> - local bundle retention;
> - safe activation boundaries;
> - emergency disable metadata;
> - typed Journey/Story/Daily content repositories;
> - CMS lifecycle: Draft/InReview/Approved/Published/Disabled/Archived/Rejected;
> - mandatory human Arabic review;
> - mandatory semantic review;
> - narrative/canon review where applicable;
> - AI Draft-only workflow;
> - Approver/Publisher separation;
> - Microsoft Entra ID + MFA Admin baseline;
> - Association/Level/Chapter/Story CMS;
> - bundle builder;
> - content validator CLI;
> - content diff;
> - STAGING publish;
> - manual PROD promotion;
> - rollback;
> - emergency disable;
> - audit log;
> - Storage/Firestore security;
> - integration and security tests.
>
> Critical constraints:
>
> - never activate unvalidated content;
> - never overwrite active immutable bundle files in place;
> - retain bundled fallback + last-known-valid;
> - reject hash/schema/rules/reference failures;
> - do not mutate active gameplay Attempt after bundle change;
> - pin Daily Challenge to its referenced bundle version;
> - same Association Clue reuse cooldown must be at least 20 Levels;
> - exact same Variant cannot repeat within one Chapter;
> - enforce configured max-one visual Association for early/mid Levels;
> - Member Cards within one Association must be homogeneous in content type;
> - AI cannot approve or publish;
> - human Arabic + semantic approval is mandatory;
> - Publisher cannot bypass approval;
> - client cannot write Production content/control plane;
> - do not replace Angular Admin;
> - do not replace Microsoft Entra ID;
> - do not introduce Azure/.NET/PostgreSQL;
> - do not introduce separate paid CDN for MVP.
>
> At completion report:
>
> 1. files created/changed;
> 2. bundle schema/manifest;
> 3. client content manager architecture;
> 4. validation pipeline;
> 5. activation/rollback strategy;
> 6. disable-switch behavior;
> 7. CMS lifecycle/permissions;
> 8. human-review enforcement;
> 9. bundle build/diff tooling;
> 10. STAGING/PROD publishing flow;
> 11. audit/security rules;
> 12. integration/security test results;
> 13. download/validation performance;
> 14. analyze/test/build results;
> 15. unresolved content-operation decisions;
> 16. any deviations and why.

---

# 176. Next Sprint

After Sprint 10 passes the exit gate:

# **Sprint 11 — Production Hardening, Observability, Security & Release Readiness v1**

Expected focus:

- production observability;
- Analytics/Crashlytics validation;
- logs/metrics/alerts;
- Firebase budget alerts;
- App Check hardening;
- secrets/config audit;
- security review;
- penetration-test readiness;
- performance profiling;
- accessibility QA;
- RTL/localization QA;
- 10,000+ critical board simulations;
- release checklist;
- staged rollout;
- rollback/runbooks;
- App Store / Play Store readiness;
- final MVP release gate.

---

**End of Sprint 10 — Content Bundles, CMS Integration & Publishing Pipeline v1**
