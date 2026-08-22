# Sprint 5 — Product Loop, Tutorial & Journey v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Product Loop / Onboarding / Journey / Narrative Integration  
**Depends On:** Sprint 4 — Playable Gameplay Vertical Slice v1  
**Primary App:** `apps/mobile`  
**Consumes:** `packages/game_engine`, `packages/game_solver`, `packages/level_generator`  
**Primary Local Data:** Drift / SQLite  
**Cloud:** Not authoritative in this sprint  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 5 Objective

Build the first complete **player-facing product loop** around the already-playable core gameplay.

Sprint 5 must turn the vertical slice into a coherent game experience with:

- app shell;
- first-time onboarding;
- interactive Tutorial;
- Home;
- Main Journey;
- Chapter progression;
- Level selection/start/resume;
- local progression;
- Chapter unlocks;
- first five Chapter structure;
- basic Chapter map;
- result/reward presentation;
- narrative Story Beats;
- Story Archive baseline;
- content-driven Level Definitions;
- resume/continue flow.

The primary goal is:

> **A player can install the app, understand the game, complete the Tutorial, enter the Main Journey, progress through Levels and Chapters, see story beats, resume progress, and continue playing without requiring cloud services.**

---

# 2. Sprint 5 Success Criteria

Sprint 5 is complete only when:

1. First launch enters onboarding/tutorial correctly.
2. Returning player bypasses completed onboarding.
3. Tutorial teaches core mechanics interactively.
4. Home screen exists and is Arabic-first.
5. “Continue” resumes the correct active Level/Attempt.
6. Main Journey screen exists.
7. Chapter progression works locally.
8. Sequential Level unlocking works.
9. Level N completion unlocks Level N+1.
10. Chapter completion unlocks next Chapter.
11. Launch Chapter structure includes the approved first five Chapters.
12. Level Definitions are data-driven, not hard-coded in widgets.
13. Story Beats trigger at approved Chapter milestones.
14. Story Beats are immediately skippable.
15. Story Archive replays unlocked story moments.
16. Result screen shows approved reward breakdown.
17. Chapter completion reward is presented correctly.
18. Active Attempt and progression survive app restart.
19. Offline product loop works end-to-end.
20. No Firebase dependency is required for core Journey progression.
21. RTL and Arabic UX are coherent across all new screens.
22. Core flows are covered by widget/integration tests.

---

# 3. Non-Goals

Do NOT implement in Sprint 5:

- authoritative cloud progression;
- Firebase cloud save;
- Wallet ledger/server-authoritative economy;
- IAP;
- ads;
- Daily Reward;
- Daily Streak;
- Daily Challenge;
- live notification delivery;
- CMS;
- production content publishing pipeline;
- all 250 polished production Levels;
- full voice acting;
- final Chapter environment art;
- full cinematic story production;
- leaderboard;
- XP;
- achievements;
- badges;
- collections;
- permanent Packs;
- events.

Temporary local-only progression is acceptable in this sprint.

---

# 4. Product Loop Overview

Target loop:

```text
App Launch
   ↓
Bootstrap
   ↓
First Run?
 ┌───────┴────────┐
Yes              No
 ↓                ↓
Onboarding      Home
 ↓                ↓
Tutorial      Continue / Journey
 ↓                ↓
Home         Chapter / Level
                  ↓
               Gameplay
                  ↓
             Level Result
                  ↓
           Progression Update
                  ↓
          Next Level / Journey
```

---

# 5. App Shell

Create the first real application shell.

Minimum sections:

- Home
- Journey
- Settings access
- Story Archive access

Do not overbuild bottom navigation if the product does not need it.

Recommended v1:
- Home as primary hub;
- Journey entered from Home;
- Settings through top-level action/menu.

---

# 6. Home Screen

The Home screen should support:

- game title/identity;
- Continue;
- Main Journey;
- optional Daily placeholder disabled/hidden until later sprint;
- Story Archive;
- Settings;
- player local progression summary.

Keep UI production-oriented but not final-art dependent.

---

# 7. Continue Logic

“Continue” priority:

## If active Attempt exists
Resume exact Attempt.

## Else if Journey has unlocked current Level
Open/start current Level.

## Else
Open Journey.

Do not generate a new Attempt if a valid active Attempt exists.

---

# 8. First-Time Onboarding

On first install:

1. short welcome;
2. introduce core game idea;
3. enter Tutorial;
4. complete Tutorial;
5. mark onboarding complete;
6. unlock Journey entry.

Keep onboarding short.

No account creation required.

---

# 9. Onboarding Narrative Tone

Onboarding may lightly introduce:

- دار الروابط;
- بصيرة المعنى;
- شيبوب.

Do not front-load full lore.

The player should understand:

- relationships are broken;
- they can restore them;
- matching connected cards is the core task.

---

# 10. Tutorial Philosophy

Tutorial must be:

- interactive;
- progressive;
- short;
- skippable only if product-approved? Current requirement is not explicitly locked.

### Sprint 5 temporary policy

For first-time players:
- Tutorial should be strongly encouraged.
- A skip option may exist only if implemented as temporary UX and clearly marked as configurable/TBD.

Do not treat Tutorial skip policy as permanent canon.

---

# 11. Tutorial Structure

Recommended Tutorial sequence:

## Step 1 — Member Matching
Teach:
- Member → matching Member.

## Step 2 — Stack
Teach:
- same-group stacking;
- stacks move atomically.

## Step 3 — Association Card
Teach:
- Association Card → matching Member/Stack.

## Step 4 — Association Slot
Teach:
- Association Card/Stack → empty Slot.

## Step 5 — Complete Association
Teach:
- Member/Stack → active Association;
- group completes and disappears.

## Step 6 — Tableau Reveal
Teach:
- moving exposed unit reveals next hidden Card.

## Step 7 — Stock
Teach:
- Stock visible window;
- only top/final visible Card playable;
- Advance;
- Restore.

## Step 8 — Moves
Teach:
- valid action costs 1 Move.

## Step 9 — Undo
Teach:
- Undo behavior and restriction.

## Step 10 — Hint
Teach:
- Hint suggests but does not execute.

Tutorial should not require:
- economy;
- ads;
- paid rescues.

---

# 12. Tutorial Board

Use deterministic handcrafted/fixture boards.

Do not use normal random Generator flow for instructional steps unless tightly controlled.

Tutorial boards must:

- guarantee expected interaction;
- avoid irrelevant legal alternatives when teaching a concept;
- remain Engine-valid;
- use authoritative Game Engine.

Do not create a separate tutorial rules engine.

---

# 13. Tutorial Guidance System

Recommended model:

```text
TutorialStep
├── targetAction
├── allowedActions
├── instructionTextKey
├── highlightTargets
├── completionCondition
└── nextStep
```

UI may temporarily block unrelated actions during a teaching step.

This is Tutorial orchestration, not a change to core Game Engine rules.

---

# 14. Tutorial UI

Use:

- Shiboub dialogue bubble;
- subtle highlights;
- arrows/pulses;
- short text.

Avoid:
- full-screen walls of text;
- long unskippable sequences.

---

# 15. Tutorial Completion

On completion:

Persist:

```text
tutorialCompleted = true
```

Then route to:
- Home;
or
- Level 1 Journey start.

Recommended:
- Home with clear “ابدأ الرحلة” CTA.

---

# 16. Main Journey

Main Journey is the primary progression system.

Approved:

- Endless numerical Levels.
- Chapters.
- 50 Levels per standard Chapter.
- Sequential unlocking.
- 5 launch Chapters = 250 Level Definitions.

Sprint 5 should establish the architecture and first launch structure.

---

# 17. Launch Chapter Structure

Approved Chapters:

1. **القاهرة: أول خيط**
2. **الإسكندرية: أصداء الغياب**
3. **بيروت: ما بين السطور**
4. **مراكش: متاهة المعنى**
5. **دبي: ما بعد الذاكرة**

Each:
- 50 Levels.

Chapter IDs should be stable and language-independent.

Example:

```text
chapter_cairo
chapter_alexandria
chapter_beirut
chapter_marrakech
chapter_dubai
```

---

# 18. Level Numbering

Recommended global numbering:

```text
Chapter 1: Levels 1–50
Chapter 2: Levels 51–100
Chapter 3: Levels 101–150
Chapter 4: Levels 151–200
Chapter 5: Levels 201–250
```

UI may also show chapter-local level number.

Do not duplicate progression truth.

---

# 19. LevelDefinition

Use data-driven definitions.

Minimum:

```text
levelDefinitionId
globalLevelNumber
chapterId
chapterLevelNumber
levelConfiguration
semanticDifficultyTier
boardDifficultyTarget
contentPoolRef / content constraints
storyMilestone?
enabled
```

Do not hard-code Level configuration inside UI screens.

---

# 20. Journey Repository

Recommended interface:

```dart
abstract interface class JourneyRepository {
  Future<JourneyProgress> loadProgress();
  Future<void> saveProgress(JourneyProgress progress);
  Future<List<ChapterDefinition>> loadChapters();
  Future<List<LevelDefinition>> loadLevels(String chapterId);
}
```

Sprint 5:
- local implementation.

Later:
- cloud-synced implementation.

---

# 21. Journey Progress Model

Recommended:

```text
highestUnlockedLevel
highestCompletedLevel
completedLevelIds
completedChapterIds
currentLevelId
lastPlayedLevelId
```

Avoid storing redundant derived fields unless useful.

---

# 22. Sequential Unlock Rule

Approved:

- Level 1 unlocked initially after Tutorial/onboarding.
- Completing Level N unlocks Level N+1.
- Locked Levels cannot start.

No stars/score gating in MVP.

---

# 23. Chapter Unlock Rule

A Chapter becomes accessible when:

- previous Chapter’s final Level is completed.

Chapter 1:
- available from start after Tutorial.

---

# 24. Chapter Completion

When Level 50 of a Chapter is completed:

1. mark Chapter complete;
2. show Chapter completion flow;
3. present approved Chapter reward:
   - 500 Coins;
   - 2 Hints;
4. unlock next Chapter;
5. trigger Chapter ending Story Beat;
6. return/continue to Journey.

Sprint 5 presentation may be local/mock reward only.

Authoritative Wallet mutation is deferred.

---

# 25. Level Completion Flow

Recommended:

```text
Gameplay Win
  ↓
Level Result
  ↓
Local Progression Update
  ↓
Story Beat if milestone
  ↓
Next Level / Journey
```

Do not update progression before Engine confirms Win.

---

# 26. Level Result Screen

Display:

- Level completed;
- remaining Moves;
- base reward;
- remaining-Move reward;
- streak Coins;
- total reward;
- Continue;
- Journey.

Formula:

```text
50 + (2 × remainingMoves) + streakCoins
```

Wallet persistence deferred.

---

# 27. Reward Presentation Boundary

Sprint 5 should distinguish:

```text
Calculated Reward
```

from:

```text
Authoritative Wallet Grant
```

Only the first is in scope.

Do not claim Coins are permanently granted to cloud wallet yet.

If a temporary local wallet preview is created, mark it non-authoritative and isolated.

---

# 28. Journey Screen

Minimum:

- Chapter cards/sections;
- level progression;
- locked/unlocked states;
- completed state;
- current Level emphasis;
- Chapter title;
- Chapter progress.

No final environment art required.

---

# 29. Chapter Map Baseline

Approved world-map direction:
- artistic Arab-world map;
- glowing Nodes;
- connections.

Sprint 5 baseline may use:
- simplified stylized node map;
- placeholder background;
- location markers.

Do not block product loop on final map art.

---

# 30. Chapter Node States

Support:

```text
locked
unlocked
inProgress
completed
```

Completed:
- visually restored/glowing.

Locked:
- dark/inactive.

---

# 31. Level Selection UX

Within Chapter:

- show 1–50 Level nodes/list;
- completed;
- current;
- locked.

Only unlocked Levels tappable.

Avoid overcomplicated stars/badges.

---

# 32. Start Level

When user starts a Level:

1. load LevelDefinition;
2. check for matching active Attempt;
3. if valid active Attempt exists:
   - resume;
4. else:
   - generate new valid Attempt;
5. persist active Attempt;
6. enter Gameplay.

---

# 33. Replay Completed Level

Whether completed Levels are replayable is not explicitly locked.

### Sprint 5 recommendation

Allow replay of completed Levels for testing/product flexibility, but:
- replay does not re-unlock progression;
- reward behavior should remain non-authoritative/TBD.

Mark this behavior configurable until explicitly approved.

Do not use it to grant repeated permanent rewards.

---

# 34. Active Attempt Ownership

Only one active Main Journey Attempt needs to be supported in MVP baseline unless later approved otherwise.

Starting another Level while active Attempt exists may require:
- resume existing;
- discard/restart confirmation;
- explicit switch.

Exact UX is not locked.

Use conservative temporary confirmation and mark configurable.

---

# 35. Local Progression Persistence

Use Drift.

Persist:
- unlocked/completed Levels;
- completed Chapters;
- Tutorial completion;
- onboarding state;
- current Journey position;
- unlocked Story Beats.

---

# 36. Progression Data Versioning

Include:

```text
progressionSchemaVersion
contentVersion
```

Do not make local progression impossible to migrate later.

---

# 37. Journey Content Source

Sprint 5 supports:

- bundled local Level Definitions;
- versioned JSON/Dart asset file;
- repository abstraction.

Do not fetch remote content as a core requirement.

---

# 38. Content Bundle Compatibility

Even before remote delivery:

Level content should be structured as if it belongs to a versioned content bundle.

Recommended metadata:

```text
contentBundleVersion
schemaVersion
rulesVersion
```

This prepares Sprint 8/Content operations.

---

# 39. Level Definition Loading

At bootstrap:

- load bundled Level Definitions;
- validate schema;
- validate IDs;
- validate Chapter references;
- validate unique global Level numbers.

Fail safely on invalid content.

---

# 40. Journey Content Validation

Required validation:

- exactly one Level 1;
- no duplicate IDs;
- no duplicate global numbers;
- Chapter order valid;
- chapter-local numbers valid;
- each launch Chapter supports 1–50 definitions structurally;
- Level Configuration valid;
- rules version supported.

Sprint 5 may use partial fixture definitions for development but architecture must support all 250.

---

# 41. First Five Chapter Metadata

Store:

```text
chapterId
order
titleAr
subtitleAr
locationKey
levelStart
levelEnd
storyBeatRefs
mapNode
```

---

# 42. Chapter Narrative Integration

Story Beats occur at:

- Chapter Start;
- Chapter Midpoint;
- Chapter Ending.

For 50-Level Chapter, recommended milestone:

```text
Start: before/around Level 1
Midpoint: after Level 25
End: after Level 50
```

This exact numeric trigger is a practical implementation choice consistent with 50-Level Chapters.

If narrative docs later specify different exact level, narrative config should override.

---

# 43. Story Beat Model

Recommended:

```text
storyBeatId
chapterId
type: start | midpoint | ending
trigger
dialogueLines
characterRefs
backgroundRef
animationRef?
skippable
```

Sprint 5 can use placeholder animation/art references.

---

# 44. Story Beat Presentation

Approved:

- short animated moments;
- dialogue bubbles;
- 10–20 seconds typical;
- immediately skippable.

Implement reusable Story Beat player.

---

# 45. Story Beat Player

Minimum:

- background/scene;
- character portrait/placeholder;
- dialogue bubble;
- next/auto progression;
- Skip;
- completion callback.

No full cutscene engine required.

---

# 46. Story Beat Unlock

When seen/unlocked:

Persist:

```text
unlockedStoryBeatIds
```

Story Archive uses this.

Skipped Story Beat still counts as unlocked.

---

# 47. Story Archive

Accessible from:
- Home;
or
- Chapter screen.

Shows:
- unlocked Chapter story moments;
- locked placeholders optionally;
- replay action.

Replaying does not change progression.

---

# 48. Arc 1 Narrative Baseline

Sprint 5 must support these canonical beats structurally:

## Cairo
- Start: first broken threads / Shiboub / Insight of Meaning.
- Midpoint: Distortion reacts.
- End: Cairo repaired; broken path to Alexandria.

## Alexandria
- Midpoint: Nodes are one connected network.
- End: first voice of عدو العرب.

## Beirut
- Midpoint: false meanings appear.
- End: Shiboub recognizes villain symbol and hides truth.

## Marrakech
- Midpoint: Distortion reshapes Dar Al-Rawabit.
- End: Shiboub confesses he enabled the villain’s entry.

## Dubai
- Midpoint: first shadow/projection encounter with عدو العرب / المُبدِّد.
- End: hundreds of Nodes revealed; player named أسطورة المعاني.

Sprint 5 may use script placeholders or approved short canonical copy.

---

# 49. Story Copy Boundary

Do not rewrite Canon.

Dialogue wording may be polished.

Core meaning must remain unchanged.

All story content should be externalized from widgets.

---

# 50. Shiboub Presentation

Shiboub is:
- comedic;
- expressive;
- narrative guide.

Sprint 5 can use:
- placeholder portrait;
- simple avatar;
- text bubble.

Do not wait for final 3D model.

---

# 51. Narrative Skip

Every Story Beat:
- skip button visible immediately.

On skip:
- mark Story Beat seen/unlocked;
- continue flow;
- no lost progression.

---

# 52. Home Progress Summary

Suggested:

- current Chapter;
- current Level;
- Chapter progress %;
- Continue CTA.

Do not add XP/Player Level.

---

# 53. Settings Baseline

Minimum:

- language structure;
- sound/music toggles placeholders if implemented;
- vibration toggle if implemented;
- privacy/legal placeholders as needed later;
- reset local progress only in DEV or behind explicit confirmation.

Do not add account/cloud settings yet.

---

# 54. Arabic Localization

All Sprint 5 UI text must use localization keys.

Do not hard-code player-facing Arabic strings throughout widgets.

Default locale:
- Arabic.

English can exist structurally if already in project.

---

# 55. RTL Journey Design

Verify:

- Chapter order presentation;
- Level numbering readability;
- map labels;
- progress indicators;
- buttons;
- dialog direction.

Numbers may remain Western or localized based on global localization policy; do not invent a new policy in this sprint if not approved.

---

# 56. Onboarding State Model

Suggested:

```text
isFirstLaunch
onboardingCompleted
tutorialCompleted
```

May be simplified.

Avoid states that can contradict each other.

---

# 57. Tutorial Resume

If app closes during Tutorial:

Preferred:
- resume current Tutorial step if practical;
or
- restart Tutorial safely.

Exact behavior is not product-critical yet.

Choose the simplest reliable behavior and document it.

---

# 58. Tutorial Engine Boundary

Tutorial can constrain UI actions but must submit actual actions to Game Engine.

Never fake successful moves just to advance Tutorial.

---

# 59. Tutorial Error Handling

If player attempts wrong move:

- Engine rejects;
- Tutorial gives contextual guidance;
- no Move penalty unless Engine rule applies.

Use the approved invalid-action streak reset, though Tutorial may hide streak UI until introduced.

---

# 60. Tutorial Moves

Tutorial may use generous/fixed Move Limit.

Do not introduce no-cost valid moves unless Tutorial Level rules explicitly configure them.

Game Engine Move rules remain unchanged.

---

# 61. Journey Progress Update Transaction

On Level Win, local progression update should be atomic where practical.

Update:
- completed Level;
- next unlocked Level;
- current Level;
- Chapter completion if applicable;
- story unlock trigger metadata.

Avoid partial progression writes.

---

# 62. Idempotent Local Level Completion

Re-processing same Level completion should not:

- duplicate completed Level;
- unlock incorrectly;
- duplicate Chapter completion flag.

This prepares later server reconciliation.

---

# 63. Result → Story Ordering

Recommended:

For normal Level:
```text
Win → Result → Next
```

For Story milestone:
```text
Win → Result → Story Beat → Journey/Next
```

For Chapter final:
```text
Win → Result → Chapter Completion → Story Ending → Next Chapter Unlock
```

Exact visual order can be refined, but state updates must be consistent.

---

# 64. Chapter Completion Reward Preview

Display:

```text
500 Coins
+2 Hints
```

Since authoritative economy is deferred:
- present as reward definition;
- do not implement insecure persistent wallet mutation.

Later Sprint will bind to server-authoritative grant.

---

# 65. Progression Event Model

Recommended application events:

```text
TutorialCompleted
LevelStarted
LevelCompleted
LevelUnlocked
ChapterStarted
ChapterMidpointReached
ChapterCompleted
ChapterUnlocked
StoryBeatUnlocked
StoryBeatViewed
```

Do not place these in Game Engine.

---

# 66. Analytics Hooks

May emit:

- onboarding_started;
- onboarding_completed;
- tutorial_step_started;
- tutorial_step_completed;
- tutorial_completed;
- journey_opened;
- chapter_opened;
- level_selected;
- level_started;
- level_completed;
- story_beat_viewed;
- story_beat_skipped;
- chapter_completed.

Keep analytics non-authoritative.

---

# 67. Resume Logic After Win

Once a Level is completed:
- clear its active Attempt;
- next Continue target becomes next unlocked Level.

Do not resume a completed board.

---

# 68. Resume Logic After Out-of-Moves

If Attempt ended:
- active Attempt may be cleared when player chooses Restart/Exit according to flow.

Do not auto-resume a terminal Attempt as playable.

---

# 69. Resume Logic After Confirmed Dead-End

Same principle:
- terminal/recovery flow;
- if user exits, store terminal state only if useful for UX;
- next Continue should not falsely imply playable winning state.

Simplest v1:
- require Restart before continuing Journey gameplay.

---

# 70. Level Start State

Before entering Gameplay:
- show lightweight Level intro/loading;
- Chapter/Level title;
- generation progress if needed.

Avoid long pre-level screens.

---

# 71. Journey Loading State

Local content/progression should load quickly.

Provide:
- loading;
- recoverable error;
- invalid content error.

Do not silently skip corrupted Level Definitions.

---

# 72. Invalid Content Handling

If a Level Definition is invalid:
- disable affected Level;
- log diagnostic;
- prevent start;
- show safe error.

Do not generate with invalid config.

---

# 73. Developer Journey Tools

DEV-only:

- unlock all Chapters;
- set current Level;
- mark/unmark Tutorial complete;
- trigger Story Beat;
- clear active Attempt;
- reset local progression;
- jump to Chapter midpoint/end.

Never expose in PROD.

---

# 74. Journey Fixture Content

Sprint 5 can use:
- enough real/test Level Definitions to validate all flows;
- generated templates for the rest.

Do not manually hand-code 250 widget cases.

Architecture must scale to all 250.

---

# 75. 250-Level Structural Validation

Even if actual polished content is incomplete, provide a test fixture or generated config set that proves:

- 5 Chapters;
- 50 Levels each;
- unique IDs;
- sequential global numbering;
- valid LevelConfiguration references.

---

# 76. Difficulty Wave Support

Journey content model should support approved:

```text
10-Level Wave × 5 per Chapter
```

Recommended metadata:

```text
waveIndex
wavePosition
```

This is content/config metadata.

No UI is required to expose wave numbers.

---

# 77. Group Progression Support

Level Definitions must support:

- early groups of 3;
- standard groups of 4;
- later groups of 5/mixed.

Do not assume fixed group size in Journey layer.

---

# 78. Story Milestone Trigger Safety

A Story Beat should not replay automatically every time a completed Level is revisited.

Track:
- unlocked;
- viewed.

Auto-trigger only on first eligible progression event.

Replay happens through Story Archive.

---

# 79. Chapter Start Beat

Trigger once:
- when Chapter first becomes active/opened;
or
- before first Level.

Recommended:
- before first Level on first entry.

---

# 80. Chapter Midpoint Beat

Trigger once:
- after midpoint milestone completion.

For baseline:
- after Level 25 of Chapter.

---

# 81. Chapter Ending Beat

Trigger once:
- after Level 50 / Chapter completion.

---

# 82. Story Archive Ordering

Group by Chapter.

Within Chapter:
1. Start
2. Midpoint
3. Ending

Locked beats may display:
- hidden;
- lock icon;
- no spoilers.

---

# 83. Local Story Assets

Sprint 5 may use:
- static background assets;
- placeholder character art;
- basic fade/pan.

Do not block on final visual production.

---

# 84. Navigation Routes

Recommended routes:

```text
/
onboarding
tutorial
home
journey
chapter/:chapterId
level/:levelId
gameplay
result
story/:storyBeatId
story-archive
settings
```

Use route guards for:
- onboarding;
- locked Level;
- missing content.

---

# 85. Route Guard — Locked Level

Direct navigation to locked Level:
- reject;
- route to Journey;
- no generation.

---

# 86. Route Guard — Tutorial

If Tutorial not completed:
- protect Main Journey entry if that is current onboarding policy.

Keep logic centralized.

---

# 87. Navigation Restore

On cold launch:
- bootstrap;
- determine onboarding state;
- if active Attempt:
  - Home still opens with Continue;
  - do not automatically force Gameplay unless approved.

Recommended:
- Home first, Continue prominent.

---

# 88. Local Data Tables

Suggested Drift additions:

```text
journey_progress
level_progress
chapter_progress
story_progress
player_local_flags
```

Keep normalized enough for migration.

Do not store huge duplicate content blobs.

---

# 89. Level Progress Fields

Possible:

```text
levelId
status
completedAtLocal?
bestRemainingMoves? (optional/TBD)
lastAttemptSeed? (debug optional)
```

Do not create score systems not approved.

---

# 90. Best Score Boundary

No official star/best-score meta is approved.

Do not add:
- stars;
- high-score rewards;
- rank.

If storing diagnostic best Remaining Moves, keep internal and do not expose as product feature without approval.

---

# 91. Offline Product Loop Test

Must pass with network disabled:

1. fresh local launch;
2. onboarding;
3. Tutorial;
4. Home;
5. Journey;
6. start Level;
7. play;
8. win;
9. update progression;
10. unlock next Level;
11. restart app;
12. progress remains.

---

# 92. Tutorial Tests

Required:

- first run routes to onboarding;
- Tutorial step progression;
- wrong action guidance;
- correct action advances;
- atomic stack teaching;
- Slot activation;
- Stock teaching;
- Undo teaching;
- Hint teaching;
- completion persists;
- returning launch bypasses Tutorial.

---

# 93. Journey Tests

Required:

- Level 1 unlocked initially;
- Level 2 locked before Level 1 win;
- Level 1 win unlocks Level 2;
- locked Level cannot open;
- Level 50 completion completes Chapter;
- next Chapter unlocks;
- completed Chapter remains completed;
- local reload preserves progress.

---

# 94. Story Tests

Required:

- Chapter Start triggers once;
- midpoint triggers once;
- ending triggers once;
- skip marks viewed/unlocked;
- replay does not alter progression;
- locked Story Beat cannot replay;
- Story Archive ordering correct.

---

# 95. Result Tests

Required:

- reward formula correct;
- remaining Move display correct;
- streak Coins correct;
- Chapter completion reward shown;
- completion clears active Attempt;
- Continue target becomes next Level.

---

# 96. Content Validation Tests

Required:

- duplicate Level ID rejected;
- duplicate global number rejected;
- invalid Chapter reference rejected;
- invalid LevelConfiguration rejected;
- unsupported rules version rejected;
- malformed content bundle handled.

---

# 97. Integration Scenario — New Player

### PL-001

1. Fresh install.
2. Welcome.
3. Tutorial.
4. Complete Tutorial.
5. Home.
6. Enter Journey.
7. Cairo Level 1 unlocked.
8. Start Level.
9. Win.
10. Result.
11. Level 2 unlocks.
12. Restart app.
13. Home Continue points to Level 2.

---

# 98. Integration Scenario — Active Attempt Resume

### PL-002

1. Start Level.
2. Make several moves.
3. Close app.
4. Reopen.
5. Home shows Continue.
6. Continue restores exact board.
7. Finish Level.
8. progression updates once.

---

# 99. Integration Scenario — Chapter Milestones

### PL-003

Using test progression shortcuts:

1. Enter Chapter first time.
2. Start Story Beat appears.
3. Complete midpoint Level.
4. Midpoint Story Beat appears once.
5. Complete Chapter final Level.
6. Chapter completion reward shown.
7. Ending Story Beat appears.
8. next Chapter unlocks.
9. Story Archive contains all three beats.

---

# 100. Performance

Measure:

- Home startup;
- Journey load;
- LevelDefinition load;
- Story Beat opening;
- progression transaction;
- route transitions.

No heavy Solver work should run just to display Journey.

---

# 101. Accessibility

Ensure:
- large touch targets;
- Arabic text scaling;
- semantic labels on Journey nodes/buttons;
- locked state not communicated only by color;
- Story Skip accessible;
- progress readable.

---

# 102. Error States

Implement safe user-facing handling for:

- missing local content;
- corrupt progression;
- unsupported schema;
- Level generation failure;
- resume incompatibility.

Do not expose stack traces.

---

# 103. Progression Recovery

If local progression is corrupted:

Preferred:
- attempt migration/validation;
- preserve valid completed progress where possible;
- do not wipe Active Attempt unless necessary;
- log diagnostics.

Exact cloud recovery comes later.

---

# 104. Product Loop Architecture Boundary

Game Engine owns:
- board gameplay.

Journey owns:
- progression/unlocks.

Narrative layer owns:
- Story Beat triggers/content.

Economy later owns:
- authoritative reward grants.

Keep these separated.

---

# 105. Suggested Feature Structure

```text
apps/mobile/lib/features/
├── onboarding/
├── tutorial/
├── home/
├── journey/
│   ├── application/
│   ├── data/
│   ├── domain/
│   └── presentation/
├── story/
├── gameplay/
└── settings/
```

Do not force Clean Architecture ceremony where simple code is enough.

---

# 106. Suggested Implementation Order

## Step 1
Progression domain + repository.

## Step 2
Level/Chapter content models.

## Step 3
Bundled content loader + validation.

## Step 4
Home shell.

## Step 5
Journey screen.

## Step 6
Level start/resume integration.

## Step 7
Level completion progression update.

## Step 8
Onboarding.

## Step 9
Interactive Tutorial.

## Step 10
Chapter completion.

## Step 11
Story Beat model/player.

## Step 12
Chapter story triggers.

## Step 13
Story Archive.

## Step 14
Local persistence/migrations.

## Step 15
DEV journey tools.

## Step 16
Integration/offline tests.

---

# 107. Suggested Commit Sequence

### Commit 1
```text
feat(journey): add chapter level and local progression domain
```

### Commit 2
```text
feat(content): add bundled journey definitions and validation
```

### Commit 3
```text
feat(home): add arabic home shell and continue flow
```

### Commit 4
```text
feat(journey): add chapter and level progression ui
```

### Commit 5
```text
feat(journey): integrate level start resume and completion
```

### Commit 6
```text
feat(onboarding): add first-run onboarding flow
```

### Commit 7
```text
feat(tutorial): add engine-backed interactive tutorial
```

### Commit 8
```text
feat(story): add story beat player and chapter triggers
```

### Commit 9
```text
feat(story): add story archive replay
```

### Commit 10
```text
feat(journey): add chapter completion and next chapter unlock
```

### Commit 11
```text
test(product-loop): add onboarding journey story and resume integration coverage
```

### Commit 12
```text
docs(product-loop): document tutorial journey and narrative integration
```

---

# 108. Sprint 5 Definition of Done

Sprint 5 is DONE only when:

- [ ] App shell exists.
- [ ] Arabic Home exists.
- [ ] Continue flow works.
- [ ] first-run onboarding works.
- [ ] Tutorial works.
- [ ] Tutorial uses Game Engine.
- [ ] Tutorial completion persists.
- [ ] Main Journey screen exists.
- [ ] first five approved Chapters exist structurally.
- [ ] 50-Level-per-Chapter structure supported.
- [ ] 250-Level architecture validated.
- [ ] Level Definitions are data-driven.
- [ ] Level 1 initially unlocks.
- [ ] sequential Level unlocking works.
- [ ] locked Levels cannot start.
- [ ] Chapter unlock works.
- [ ] local progression persists.
- [ ] active Attempt resume integrates with Journey.
- [ ] result screen exists.
- [ ] reward calculation display correct.
- [ ] Chapter completion reward display correct.
- [ ] Chapter map baseline exists.
- [ ] Chapter Node states work.
- [ ] Story Beat model exists.
- [ ] Story Beat player exists.
- [ ] Story Beats are immediately skippable.
- [ ] Chapter Start trigger works.
- [ ] Chapter Midpoint trigger works.
- [ ] Chapter Ending trigger works.
- [ ] Story triggers only once automatically.
- [ ] Story Archive exists.
- [ ] unlocked Story Beats replay.
- [ ] story replay does not alter progression.
- [ ] Shiboub can be presented in story UI.
- [ ] Arc 1 canonical beat structure is represented.
- [ ] bundled content schema/versioning exists.
- [ ] content validation exists.
- [ ] offline product loop passes.
- [ ] PL-001 passes.
- [ ] PL-002 passes.
- [ ] PL-003 passes.
- [ ] Flutter analyze passes.
- [ ] Flutter tests pass.
- [ ] no cloud-authoritative progression introduced prematurely.
- [ ] no XP/stars/leaderboards/achievements added.

---

# 109. Sprint 5 Exit Gate Before Cloud & Economy

Do not start Sprint 6 until:

1. new player journey works end-to-end;
2. Tutorial reliably teaches core mechanics;
3. Home/Continue/Journey flows are stable;
4. local progression is idempotent and persistent;
5. Level/Chapter unlock rules pass tests;
6. Story trigger rules pass tests;
7. Story Archive works;
8. 250-Level content structure is proven scalable;
9. offline product loop works;
10. gameplay and progression boundaries remain clean;
11. reward display is separated from authoritative Wallet;
12. no cloud dependency is required for core Journey.

---

# 110. Cursor Execution Prompt — Sprint 5

Use this after Sprint 4 passes its exit gate:

> Implement **Sprint 5 — Product Loop, Tutorial & Journey v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_5_Product_Loop_Tutorial_and_Journey_v1.0.md`
> - latest Screen Inventory & User Flows
> - latest Progression Design
> - latest Level Design Framework
> - latest Narrative Canon / Story Bible
>
> Build the first complete offline-first product loop around the existing playable Gameplay vertical slice.
>
> Implement:
>
> - app shell;
> - Arabic Home;
> - Continue flow;
> - first-run onboarding;
> - interactive Game-Engine-backed Tutorial;
> - Main Journey;
> - Chapter definitions;
> - Level definitions;
> - local progression;
> - sequential Level unlocking;
> - Chapter unlocking;
> - Level start/resume;
> - result screen;
> - reward breakdown presentation;
> - Chapter completion presentation;
> - first five approved Chapters;
> - 50-Level Chapter structure;
> - 250-Level scalable content structure;
> - bundled/versioned Level Definition loading;
> - content validation;
> - Chapter map baseline;
> - Story Beat model/player;
> - Chapter Start/Midpoint/Ending triggers;
> - Story Archive;
> - local persistence and migrations;
> - offline integration tests.
>
> Critical constraints:
>
> - Game Engine remains authoritative for gameplay.
> - Journey layer owns progression, not Game Engine.
> - Do not add cloud dependency to core progression yet.
> - Do not implement authoritative Wallet grants yet.
> - Reward values may be displayed but Wallet mutation is deferred.
> - Level N completion unlocks only Level N+1.
> - Chapter completion unlocks next Chapter.
> - Story Beats are immediately skippable.
> - Story canon must not be rewritten.
> - Cairo → Alexandria → Beirut → Marrakech → Dubai.
> - Story beats occur at Chapter Start, Midpoint, and Ending.
> - Do not add XP, stars, leaderboards, achievements, badges, Packs, subscriptions, or premium currency.
> - Tutorial must use actual Engine rules rather than fake transitions.
> - Core Journey must work fully offline.
>
> For development, use bundled Level Definitions and local Drift progression.
>
> Structure content so remote versioned bundles can replace/extend it later without rewriting Journey UI.
>
> At completion report:
>
> 1. files created/changed;
> 2. Home/Journey architecture;
> 3. onboarding/tutorial flow;
> 4. Level/Chapter data model;
> 5. progression persistence model;
> 6. Level unlock logic;
> 7. story trigger/player/archive implementation;
> 8. content bundle/versioning approach;
> 9. tests added;
> 10. offline test result;
> 11. analyze/test/build results;
> 12. unresolved UX/product decisions;
> 13. any deviations from this Sprint document and why.

---

# 111. Next Sprint

After Sprint 5 passes the exit gate:

# **Sprint 6 — Firebase Identity, Cloud Progression & Sync v1**

Expected focus:

- Firebase anonymous-first authentication;
- Google/Apple linking architecture;
- player profile;
- cloud Journey progression;
- sync metadata;
- local/cloud reconciliation;
- offline-first sync queue;
- settings sync;
- explicit account conflict flow;
- server-authoritative boundaries;
- Firestore rules;
- cloud state migration;
- multi-device progression foundation.

---

**End of Sprint 5 — Product Loop, Tutorial & Journey v1**
