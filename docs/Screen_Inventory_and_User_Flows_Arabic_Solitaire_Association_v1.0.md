# Screen Inventory & User Flows
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 (`docs/Progression_Design_Arabic_Solitaire_Association_v1.0.md`)  
**Important:** Register-approved game/product behavior is **CONFIRMED**. New UX/navigation proposals introduced here remain **PROPOSED**. Explicitly deferred Register items are **Post-MVP**. Open commercial/tuning items remain **STILL TBD**.

---

# 1. Purpose

This document defines the complete screen inventory and major user flows for the Arabic Solitaire Association game.

It translates the product/game scope into:

- Player-facing screens.
- Navigation structure.
- Gameplay overlays.
- Success/failure flows.
- Economy flows.
- Daily engagement flows.
- Account/cloud flows.
- Settings and legal flows.
- Monetization flows.
- Admin/content-management flows at a high level.

The goal is to provide a clear UX blueprint before wireframing, UI design, technical architecture, and backlog decomposition.

---

# 2. UX Principles

## 2.1 Arabic-First / RTL-First

All primary player-facing flows shall be designed for Arabic and RTL from the start.

Requirements include:

- RTL navigation.
- Correct Arabic text shaping.
- Mixed Arabic/Latin support.
- Consistent placement of back/close actions.
- Card text fitting for Arabic.
- Clear touch targets.
- No assumptions based on LTR-first layouts.

## 2.2 Fast Path to Gameplay

The player should be able to:

`Open App → Continue → Play`

with minimal interruption.

The Home screen should not become a crowded hub before all meta systems exist.

## 2.3 Gameplay Is the Center

Navigation, monetization, rewards, daily systems, and progression should support the Core Gameplay rather than compete with it.

## 2.4 Overlays Before New Screens

For in-session actions such as:

- Hint feedback.
- Out-of-Moves.
- Dead End.
- Restart confirmation.
- Reward delivery.

prefer lightweight overlays/sheets when possible instead of navigating away from gameplay.

## 2.5 Clear State Communication

The user should always understand:

- What happened.
- What can be done next.
- Whether Coins/Moves/Hints were consumed.
- Whether a purchase/ad reward was granted.
- Whether progress was saved.

---

# 3. Navigation Model

## 3.1 Proposed Primary Navigation

**PROPOSED**

For MVP, use a simple home-centered navigation rather than a permanent bottom navigation bar.

Suggested structure:

`Splash`
→ `Onboarding / Tutorial if first launch`
→ `Home`

From Home:

- Continue Main Journey
- Chapter / Level Progress
- Daily Reward
- Daily Challenge
- Shop
- Account / Cloud
- Settings

Full Product may later add dedicated entry points for:

- Events
- Packs
- Achievements
- Collections
- Badges
- Leaderboards
- Cosmetics

## 3.2 Why No Permanent Bottom Navigation in MVP

**PROPOSED**

Reasons:

- The MVP has one dominant activity: play.
- Reduces visual clutter.
- Keeps the experience closer to a casual puzzle game.
- Easier to expand later.

This is not yet an approved UX decision.

---

# 4. Screen Inventory Summary

## 4.1 P0 MVP Screens

1. Splash / Initialization
2. First-Time Welcome
3. Tutorial Intro
4. Interactive Tutorial Gameplay
5. Home / Continue Journey
6. Chapter / Level Progress
7. Gameplay
8. Pause Menu
9. Restart Confirmation
10. Hint Message Overlay
11. Dead-End Detected Overlay
12. Dead-End Rescue Offer
13. Out-of-Moves Offer
14. Level Complete
15. Reward Breakdown
16. Shop
17. Remove Ads Purchase
18. Coin Pack Purchase
19. Purchase Result
20. Account / Cloud Save
21. Link Account
22. Cloud Sync Status / Conflict
23. Settings
24. Help / How to Play
25. Privacy & Legal
26. Restore Purchases
27. Network / Service Error
28. Generic Confirmation / Error Dialog
29. Daily Reward
30. Daily Challenge Landing
31. Daily Challenge Gameplay
32. Daily Challenge Complete
33. Daily Streak
34. Notification Permission Prompt
35. Notification Preferences
36. Chapter Milestone / Chapter Complete
37. Report a Problem

## 4.2 P1 MVP Screens

None required beyond P0 for Daily/Chapter/Report surfaces already listed above. Remaining P1 items, if any, are feature-flag UX polish only.

## 4.3 Post-MVP Full Product Screens

38. Player Profile / Player Level
39. Achievements
40. Achievement Detail
41. Badges
42. Collections
43. Collection Detail
44. Cosmetics / Themes
45. Cosmetic Preview
46. Events Hub
47. Event Detail
48. Event Gameplay
49. Permanent Packs Hub
50. Pack Detail
51. Pack Gameplay
52. Leaderboards
53. Content Update / New Content
54. Inbox / Reward Inbox — if later approved

---

# 5. Splash / Initialization Screen

## Priority
P0

## Purpose

Prepare the game and route the player to the correct initial state.

## Content

- Game logo.
- Lightweight loading indicator.
- Optional version/build info in development builds.

## Background Operations

- Load local player state.
- Initialize core configuration.
- Load Remote Config.
- Validate local content/config version.
- Initialize analytics.
- Initialize purchase entitlement state.
- Initialize ad SDKs where allowed.
- Restore anonymous identity.
- Check cloud-save status if available.
- Preload essential assets.

## Routing

### First Launch
→ First-Time Welcome

### Returning Player
→ Home

### Critical Initialization Error
→ Recoverable Error state

## UX Rule

Do not hold the player on Splash for non-critical services such as Ads if the game can continue without them.

---

# 6. First-Time Welcome

## Priority
P0

## Purpose

Introduce the game concept quickly.

## Proposed Content

**PROPOSED**

- Short headline.
- One-sentence explanation:
  - discover the relation,
  - organize cards,
  - clear the board.
- Primary CTA: `ابدأ`
- Secondary option to open Help later is sufficient; avoid long onboarding slides.

## Flow

`First-Time Welcome`
→ `Tutorial Intro`

---

# 7. Tutorial Intro

## Priority
P0

## Purpose

Set expectations before interactive teaching starts.

## Content

- Very brief explanation of Association Cards.
- Very brief explanation of Member Cards.
- Visual example.
- CTA: `ابدأ التدريب`

## Important

Do not explain every rule upfront.

The approved onboarding strategy uses:

- Concise explanation.
- Interactive tutorial.

---

# 8. Interactive Tutorial Gameplay

## Priority
P0

## Purpose

Teach core mechanics through guided gameplay.

## Tutorial Capabilities

The tutorial engine should support:

- Highlighting one card.
- Highlighting one target.
- Blocking unrelated actions when required.
- Showing short contextual Arabic instructions.
- Waiting for the expected player action.
- Progressing to the next step.
- Skipping already-understood explanations where appropriate.

## Proposed Tutorial Topics

**PROPOSED**

1. Match a Member Card to an Association.
2. Stack same-group Member Cards.
3. Explain atomic Stack behavior.
4. Move Association Card onto its group Stack.
5. Move Association Stack to a Slot.
6. Use Stock.
7. Understand the 3-card Stock window.
8. Understand Moves.
9. Use Undo.
10. Use Hint.
11. Understand correct-action streak.
12. Complete the level.

Exact sequencing is to be approved in the Tutorial Specification.

## Exit

Tutorial completion:
→ Home or direct first real level.

---

# 9. Home / Continue Journey

## Priority
P0

## Purpose

Primary player hub.

## Required Information

- Current Main Journey Level.
- Current Chapter.
- Chapter progress.
- Coin balance.
- Hint balance if exposed globally.
- Main CTA: `متابعة`
- Entry to Shop.
- Entry to Settings.
- Entry to Account/Cloud.
- Daily Reward badge.
- Daily Challenge card.
- Daily Streak indicator.

**CONFIRMED** — Final Decision Register v1.1 §4: Daily Reward, Daily Challenge, and Daily Streak ship at launch (not optional P1).

## Post-MVP Additions

- Events.
- Packs.
- Achievements.
- Collections.
- Leaderboards.
- Player Level.

## Proposed Layout Hierarchy

**PROPOSED**

1. Continue button as strongest action.
2. Current level/chapter progress.
3. Daily cards (launch).
4. Secondary utilities.

Avoid presenting the Home screen like a dashboard with too many equal-weight actions.

---

# 10. Chapter / Level Progress Screen

## Priority
P0

## Purpose

Show where the player is in the Endless Journey.

## Content

- Current Chapter.
- `x / 50` progress.
- Current level.
- Completed/available/locked states.
- Optional previous level replay if later approved.

## Proposed Representation

**PROPOSED**

Use a simple vertical or horizontal progression list rather than a large illustrated map for MVP.

Reason:

- Faster to build.
- Clearer for Endless scale.
- Works well with Chapters.
- Easier to virtualize for many levels.

## Level States

- Locked.
- Available.
- Completed.

Optional future performance indicators:

- Best remaining Moves.
- No-Hint completion.
- No-Rescue completion.

These are not currently required.

---

# 11. Gameplay Screen

## Priority
P0

## Purpose

Primary game experience.

## Major Regions

### Top Bar
- Back/Pause.
- Level number.
- Move counter.
- Coin balance or in-session reward feedback.
- Hint control.
- Undo control.

### Association Slots Area
- Variable number of Slots.
- Empty Slot state.
- Active Association Card.
- Progress count such as `2/4`.
- Completed Association animation/removal.

### Tableau Area
- Variable number of columns.
- Face-down cards.
- Face-up cards.
- Stacks.
- Empty column state.

### Stock Area
- Stock control.
- Last up-to-3 visible cards.
- Only top/final card playable.
- Restore Stock control.

### Streak Feedback
- Current streak progress.
- Required count.
- Coin reward feedback.

## Required Interactions

- Drag single Card.
- Drag atomic Stack.
- Drop to compatible Member Card/Stack.
- Drop Association Card on compatible Member Stack.
- Drop Association Card/Stack to Slot.
- Drop Member Card/Stack to Active Association.
- Drop any movable unit to empty Tableau column.
- Cycle Stock.
- Restore Stock.
- Undo.
- Hint.
- Pause.

## Invalid Interaction Feedback

Invalid drop:

- Card/Stack returns to origin.
- Clear invalid feedback.
- No Move consumed.
- Current correct-action streak resets.

## Automatic Behavior

- Flip newly exposed Tableau card.
- Update Moves.
- Update streak.
- Update Association progress.
- Detect completion.
- Remove completed Association.
- Detect win.
- Detect Dead End.

---

# 12. Pause Menu

## Priority
P0

## Purpose

Temporarily suspend active play.

## Actions

- Resume.
- Restart.
- How to Play.
- Settings shortcut.
- Exit to Home.

## Rules

If player exits:
- Progress/session preservation behavior depends on active-session save policy.
- Do not silently count exit as a loss unless explicitly defined later.

---

# 13. Restart Confirmation

## Priority
P0

## Purpose

Prevent accidental loss of current attempt state.

## Message

Explain that Restart:

- Restarts the current level.
- Creates a new shuffle.
- Keeps the same level and Move Limit.

## Actions

- Confirm Restart.
- Cancel.

## Flow

Confirm:
→ Generate new board
→ Solver validation
→ Gameplay

---

# 14. Hint Message Overlay

## Priority
P0

## Purpose

Communicate the Solver-recommended action.

## Behavior

When player taps Hint:

### If Hint Balance > 0
- Consume 1 Hint.
- Show a short instruction.
- Highlight source/target where useful.
- Do not perform the move.

### If Hint Balance = 0
→ Hint Acquisition Offer.

## Example Messages

- `انقل "تفاح" إلى مجموعة "فواكه".`
- `انقل المجموعة إلى العمود الفارغ.`
- `اسحب الكارت التالي من الستوك.`

## Important

Hint UI should not cover the cards it refers to.

---

# 15. Hint Acquisition Offer

## Priority
P0

## Purpose

Allow player to obtain a Hint when none remain.

## Options

- Buy Hint with Coins.
- Watch Rewarded Ad.
- Cancel.

## Required Display

- Coin cost.
- Current balance.
- Rewarded Ad reward.
- Disabled state if ad unavailable.

Exact values come from Remote Config/Economy.

---

# 16. Dead-End Detected Overlay

## Priority
P0

## Purpose

Inform the player that the current game state is no longer solvable.

## Trigger

Automatic Solver detection.

## Content

- Clear message that the current arrangement cannot be completed.
- Avoid blaming language.

## Actions

Depending on state:

- Undo — if eligible.
- Rescue.
- Restart.
- Close only if there is still a meaningful allowed action; otherwise do not allow return to an impossible board without explicit choice.

---

# 17. Dead-End Rescue Offer

## Priority
P0

## Purpose

Offer recovery without forcing Restart.

## Potential Options

- Use Coins.
- Watch Rewarded Ad.
- Restart.

## Required

- State exactly what Rescue will do (Solver-Guided Recovery State; preserve completed progress as much as possible; guarantee a winning continuation).
- State Coin cost: **200 Coins**; max **1** rescue per Attempt (**CONFIRMED** — Final Decision Register v1.1 §2).
- State ad reward.
- Do not charge before successful rescue generation.
- No separate Mid-Level Reshuffle in MVP.

## Post-Action

Rescue accepted:
→ Create rescue board/state
→ Solver validate
→ Resume Gameplay

Rescue failed technically:
→ Do not consume Coins/reward
→ Show error
→ Keep player state safe

---

# 18. Out-of-Moves Offer

## Priority
P0

## Purpose

Allow the player to continue the current attempt after Moves reach zero.

## Content

- `نفدت الحركات`
- Offer Extra Moves: **+5 Moves** (**CONFIRMED** — Final Decision Register v1.1 §2).
- Coin option:
  - first Extra-Move rescue: **150 Coins**
  - second Extra-Move rescue: **250 Coins**
  - max **2** Extra-Move rescues per Attempt
- Rewarded Ad option.
- Restart.

## Flow

### Coin Purchase
Validate balance
→ Deduct Coins
→ Add Moves
→ Resume Gameplay

### Rewarded Ad
Ad completed
→ Grant Moves
→ Resume Gameplay

### Decline
→ Restart / Home choice depending UX.

---

# 19. Level Complete Screen

## Priority
P0

## Purpose

Celebrate completion and move the player forward.

## Required Content

- Level complete status.
- Base reward.
- Remaining Moves reward.
- Streak-earned Coins.
- Total Coins earned.
- Current Coin balance.
- Continue CTA.

## Formula

**CONFIRMED**

`50 Base Coins`
+
`2 × Remaining Moves`
+
`Streak Coins earned during play`

## Navigation

Primary:
→ Next Level

Secondary:
→ Home

Optional:
→ Chapter progress preview.

---

# 20. Reward Breakdown

## Priority
P0

This may be a section inside Level Complete rather than a separate screen.

## Required

Show reward sources distinctly:

- Base.
- Remaining Moves.
- Streak.

Avoid hiding reward math.

---

# 21. Shop

## Priority
P0

## Purpose

Central monetization surface.

## MVP Sections

### Remove Ads
- Product name.
- Benefit summary.
- Store price.
- Purchase CTA.

### Coin Packs
- Pack amount.
- Store price.
- Purchase CTA.

## Not Required for MVP

- Large cosmetic catalogue.
- Bundles.
- Event store.
- Premium currency.

## UX Rule

Do not show utility Coin spends as confusing real-money products.

Coin-funded Hints/Rescue may remain contextual.

---

# 22. Remove Ads Purchase Flow

## Priority
P0

## Flow

`Shop`
→ Select Remove Ads
→ Native Store Purchase
→ Pending/Success/Failure

### Success
- Persist entitlement.
- Suppress Interstitial Ads only (**CONFIRMED** — Remove Ads removes Interstitials only).
- Keep Rewarded Ads optional.

### Failure
- Clear message.
- No state change.

### Pending
- Show pending status.
- Do not grant entitlement prematurely.

---

# 23. Coin Pack Purchase Flow

## Priority
P0

## Flow

`Shop`
→ Select Coin Pack
→ Native Store Purchase
→ Validation
→ Grant Coins
→ Updated balance

## Requirements

- Duplicate transaction protection.
- Restore/reconciliation logic where relevant.
- Analytics.
- Safe retry after failure.

---

# 24. Purchase Result Screen / Dialog

## Priority
P0

## Success

Show:

- Purchased product.
- Coins or entitlement granted.

## Failure

Show:

- Purchase not completed.
- Retry/close.

## Pending

Show:

- Purchase is processing.
- No duplicate re-purchase encouragement.

---

# 25. Account / Cloud Save

## Priority
P0

## Purpose

Allow the player to understand save status and optionally link an account.

## States

### Anonymous / Saved
- Anonymous player.
- Cloud save status.
- CTA to link Apple/Google.

### Linked
- Linked provider.
- Sync status.
- Optional sign-out/unlink rules subject to platform policy.

### Offline
- Local progress preserved.
- Cloud sync pending.

## Important

Anonymous-first identity uses **Firebase Authentication** (Final Decision
Register v1.1 §7). Do not make linking feel mandatory.

---

# 26. Link Account Flow

## Priority
P0

## Flow

`Account`
→ Choose Sign in with Apple / Google
→ Authentication
→ Link anonymous profile
→ Sync
→ Success

## Conflict Case

If remote progress already exists:
→ Cloud Sync Conflict flow.

---

# 27. Cloud Sync Conflict

## Priority
P0

## Purpose

Resolve conflicting local and remote progression safely.

## Possible Resolution UX

**CONFIRMED** conflict policy is domain-specific (Final Decision Register v1.1 §7):

- Progression → merge to highest valid progression.
- Wallet → server-authoritative ledger (trusted Cloud Functions / Cloud Run).
- Purchases/Entitlements → store + trusted backend authoritative.
- Settings → latest revision.
- Active Attempt → local/device-specific.

Cloud sync must minimize Firestore reads/writes and avoid per-Move cloud traffic.

**PROPOSED** presentation may still show a comparison of local vs cloud progression/settings for clarity, but economy-sensitive balances follow server authority rather than free user choice.

---

# 28. Settings

## Priority
P0

## Sections

### Audio
- Sound.
- Music if included.
- Haptics.

### Notifications
If enabled.

### Account
Shortcut.

### Purchases
- Restore Purchases.

### Help
- How to Play.
- Support.

### Legal
- Privacy Policy.
- Terms where applicable.

### App
- Version info.

---

# 29. Help / How to Play

## Priority
P0

## Purpose

Provide reference after Tutorial.

## Topics

- Goal.
- Association Cards.
- Same-group stacking.
- Atomic Stacks.
- Association Slots.
- Stock.
- Moves.
- Undo.
- Hints.
- Streak rewards.
- Dead End.
- Restart.

## Format

**PROPOSED**

Use short illustrated cards/sections rather than long text.

---

# 30. Privacy & Legal

## Priority
P0

## Content

- Privacy Policy.
- Terms/Conditions if required.
- Data deletion/request path where applicable.
- Advertising/privacy choices where required.
- Third-party notices if needed.

External legal pages may open in an in-app web surface or system browser depending implementation.

---

# 31. Restore Purchases

## Priority
P0

## Purpose

Restore eligible entitlements such as Remove Ads.

## Flow

`Settings / Shop`
→ Restore Purchases
→ Store restore
→ Validate
→ Update entitlement
→ Result

---

# 32. Generic Network / Service Error

## Priority
P0

## Use Cases

- Remote Config unavailable.
- Cloud save temporarily unavailable.
- Ad unavailable.
- Purchase service unavailable.
- Content service unavailable.

## UX Principle

If the failed service is non-critical:
allow the player to continue playing.

Do not turn transient backend failures into unnecessary hard blocks.

---

# 33. Daily Reward Screen

## Priority
P0 — launch (Final Decision Register v1.1 §4)

## Purpose

Drive daily return behavior.

## Content

- Current calendar day.
- Reward sequence.
- Claimed/unclaimed states.
- Claim CTA.
- Next reward preview.

## Flow

`Home`
→ Daily Reward
→ Claim
→ Reward animation
→ Home

## Confirmed Rules

**CONFIRMED** — Final Decision Register v1.1 §4

- 7-day repeating calendar.
- Missing a day does not reset Daily Reward progression.
- Daily Streak breaks after a missed day.
- Day rewards: 100 / 125 / 150 Coins / 1 Hint / 175 / 200 / 300 Coins + 1 Hint.
- Streak milestones: 3→100, 7→250, 14→400, 30→750 Coins.

---

# 34. Daily Challenge Landing

## Priority
P0 — launch (Final Decision Register v1.1 §4)

## Content

- Today's challenge.
- Completion state.
- Reward (150 Coins on first completion).
- Move Limit if shown before entry.
- Play CTA.

## Rules

**CONFIRMED**

- Daily Challenge is separate from Main Journey progression.
- Fixed deterministic board per challenge cohort.
- Unlimited retries during the valid day.
- Reward auto-granted on first completion.
- Reset at 00:00 validated player-local timezone; backend authoritative.

---

# 35. Daily Challenge Gameplay

## Priority
P0 — launch

Uses the same Core Gameplay screen/engine with a Daily Challenge configuration.

Possible distinctions:

- Shared/deterministic board.
- Dedicated label.
- Different reward logic.
- Separate completion state.

Do not fork the game engine.

---

# 36. Daily Challenge Complete

## Priority
P0 — launch

## Content

- Completion.
- Reward.
- Performance.
- Return Home.

**Post-MVP:**
- Leaderboard CTA.

---

# 37. Daily Streak

## Priority
P0 — launch

May be shown as:

- Home widget.
- Daily Reward section.
- Lightweight milestone overlay.

A dedicated full screen is optional.

## Content

- Current streak.
- Best streak.
- Next milestone.

---

# 38. Notification Permission Flow

## Priority
P0 — launch (Final Decision Register v1.1 §4)

Smart Notification infrastructure ships at launch.

**CONFIRMED** initially active types:

- Daily Challenge.
- Streak Risk.

## Proposed Timing

**PROPOSED**

Request permission after the player has experienced value, not on first launch.

Good triggers may include:

- After first Daily Reward claim.
- After first Daily Challenge completion.

## Pre-Permission Screen

Explain what notifications are for:

- Daily Challenge.
- Streak Risk.

Then trigger system permission.

---

# 39. Notification Preferences

## Priority
P0 — launch

If notifications are enabled, allow category preferences:

- Daily Challenge.
- Streak Risk.
- Events / New content later (**Post-MVP** richer types).

**CONFIRMED** — Final Decision Register v1.1 §4

Notification quiet hours: **22:00–09:00** player-local time.

---

# 40. Player Profile / Player Level

## Priority
Post-MVP

## Purpose

Show long-term meta progression.

## Content

- Player Level.
- XP bar.
- Badges.
- Achievement summary.
- Collection summary.
- Main Journey Level.

No Friends/PvP controls are currently required.

---

# 41. Achievements

## Priority
Post-MVP

## Content

- Achievement categories.
- Progress.
- Completed status.
- Reward where applicable.

## Detail Screen

- Requirement.
- Progress.
- Reward.
- Completion date.

---

# 42. Badges

## Priority
Post-MVP

## Content

- Earned badges.
- Locked badges.
- Badge rarity if later defined.
- Optional selected/displayed badge.

---

# 43. Collections

## Priority
Post-MVP

## Content

- Collection groups.
- Completion percentage.
- Rewards.
- Locked/earned entries.

Exact collectible model remains TBD.

---

# 44. Cosmetics / Themes

## Priority
Post-MVP

## Content

- Owned.
- Locked.
- Coin price.
- Preview.

Potential categories:

- Card backs.
- Board backgrounds.
- Slot styles.
- UI themes.

## Rule

No gameplay power.

---

# 45. Events Hub

## Priority
Post-MVP

## Content

- Active Events.
- Time remaining.
- Event progress.
- Rewards.
- CTA.

---

# 46. Event Detail

## Priority
Post-MVP

## Content

- Event explanation.
- Event level progress.
- Rewards/milestones.
- Play CTA.

---

# 47. Permanent Packs Hub

## Priority
Post-MVP

Potential Packs:

- Egyptian.
- Saudi/Gulf.
- Levantine.
- Maghrebi.
- Cultural.
- Linguistic challenge.

## Content

- Pack title.
- Progress.
- Unlock status.
- CTA.

---

# 48. Leaderboards

## Priority
Post-MVP

Potential categories:

- Daily Challenge.
- Weekly.
- Event.
- Main Journey milestone.

No Friends leaderboard is required under current scope.

---

# 49. Major User Flow — First-Time Player

`App Open`
→ Splash
→ First-Time Welcome
→ Tutorial Intro
→ Interactive Tutorial
→ Tutorial Complete
→ Home
→ Continue
→ First Main Journey Level
→ Gameplay
→ Level Complete
→ Next Level

Optional after first few levels:

→ Introduce Daily Reward / notifications contextually (Daily systems are launch P0).

---

# 50. Major User Flow — Returning Player

`App Open`
→ Splash
→ Load local/cloud state
→ Home
→ Continue
→ Generate/Validate Board
→ Gameplay

---

# 51. Main Journey Level Start Flow

`Home / Chapter Progress`
→ Select available/current level
→ Load Level Configuration
→ Select content
→ Full Shuffle
→ Deal Tableau/Stock
→ Initialize empty Association Slots
→ Solver Validation
→ Difficulty Validation

### Accepted
→ Gameplay

### Rejected
→ Regenerate

### Repeated Generation Failure
→ Fallback/Error handling

---

# 52. Valid Move Flow

`Drag Card/Stack`
→ Drop target
→ Game Engine validates

### Valid
→ Commit move
→ Consume Move
→ Update Tableau/Association
→ Update streak if correct/neutral
→ Auto-reveal if needed
→ Check Association completion
→ Check Win
→ Check Dead End

### Invalid
→ Return to origin
→ No Move consumed
→ Reset current streak
→ Continue

---

# 53. Association Completion Flow

`Valid final member placement`
→ Association reaches required count
→ Completion animation
→ Remove Association + Members
→ Free Slot
→ Update board
→ Check Win
→ Check Dead End
→ Continue

Undo is unavailable for this completion Move.

---

# 54. Hint Flow

`Gameplay`
→ Tap Hint

### Hint available
→ Solver analyzes current state
→ Consume Hint
→ Show instruction/highlight
→ Player manually acts

### No Hints
→ Hint Acquisition Offer

#### Coins
→ Validate balance
→ Deduct Coins
→ Grant/use Hint
→ Show recommendation

#### Rewarded Ad
→ Complete Ad
→ Grant Hint
→ Show recommendation

#### Cancel
→ Gameplay

---

# 55. Undo Flow

`Gameplay`
→ Tap Undo

### Eligible
→ Revert last Move
→ Restore 1 Move
→ Disable consecutive Undo
→ Resume

### Not Eligible
→ Disabled state or short explanation

Undo unavailable when:
- Last action was already Undo.
- Last Move completed an Association.
- No eligible previous Move.

---

# 56. Out-of-Moves Flow

`Moves = 0`
→ Pause Gameplay
→ Show Out-of-Moves Offer

### Coin Extra Moves
→ Deduct Coins
→ Add Moves
→ Resume

### Rewarded Ad
→ Ad success
→ Add Moves
→ Resume

### Restart
→ Confirm
→ New random board
→ Solver validate
→ Gameplay

---

# 57. Dead-End Flow

`Gameplay state changed`
→ Solver detects no completion path
→ Pause
→ Dead-End Detected Overlay

### Undo eligible
→ Undo

### Rescue with Coins
→ Confirm cost
→ Apply solver-validated rescue
→ Resume

### Rewarded Rescue
→ Ad
→ Apply rescue
→ Resume

### Restart
→ New attempt

---

# 58. Level Win Flow

`All cards cleared`
→ Freeze board
→ Compute reward
→ Level Complete
→ Show breakdown
→ Persist completion
→ Unlock next level
→ Update Chapter progress
→ Save Cloud when available

### Continue
→ Next level generation

### Home
→ Home

---

# 59. Restart Flow

`Pause / Dead-End / Failure`
→ Restart
→ Confirmation
→ Preserve level content/config
→ New full shuffle
→ Solver validation
→ Reset attempt-specific state
→ Gameplay

Attempt-specific state includes:

- Moves reset to level Move Limit.
- Current correct-action streak reset.
- Association Slots empty.
- Board redealt.

Persistent resources remain unchanged except any already-spent resources.

---

# 60. Shop Purchase Flow

`Home / Contextual Offer`
→ Shop or Product
→ Native Store

### Purchase Success
→ Validate
→ Grant entitlement/Coins
→ Analytics
→ UI update

### Failure
→ No grant
→ Error

### Pending
→ Pending state
→ Reconcile later

---

# 61. Remove Ads Flow

`Shop`
→ Remove Ads
→ Store purchase
→ Validate entitlement
→ Disable Interstitial eligibility
→ Success message

Rewarded Ads remain optional.

---

# 62. Cloud Save Flow

`Progress changes`
→ Save locally first
→ Attempt cloud sync

### Online Success
→ Mark synced

### Offline/Failure
→ Keep local
→ Mark pending sync
→ Retry later

For economy/purchase-sensitive state, final authority follows Final Decision Register v1.1 §7 (wallet ledger; purchases store/backend authoritative).

---

# 63. Account Linking Flow

`Anonymous Player`
→ Account
→ Choose provider
→ Authenticate
→ Detect remote account state

### No remote progress
→ Link and upload local progression

### Existing remote progress
→ Resolve conflict/merge policy
→ Link
→ Sync

---

# 64. Daily Reward Flow

`Home`
→ Daily Reward available
→ Open calendar
→ Claim
→ Grant reward
→ Update state
→ Optional streak update
→ Home

Prevent duplicate claim.

---

# 65. Daily Challenge Flow

`Home`
→ Daily Challenge
→ Landing
→ Start
→ Shared challenge board
→ Gameplay

### Complete
→ Reward
→ Mark complete

### Fail/Restart
→ Unlimited retries during the valid day (**CONFIRMED**)

Main Journey progress unchanged.

---

# 66. Notification Flow

`Scheduled condition`
→ Push notification
→ Player taps

Deep-link targets:

- Daily Challenge.
- Daily Reward.
- Home.
- Event later.

If destination unavailable/outdated:
→ Home with graceful message.

---

# 67. Error Flow — Ad Unavailable

`Player chooses Rewarded Ad`
→ Ad unavailable

Show:

- `الإعلان غير متاح حاليًا`
- Coin alternative if appropriate.
- Retry later.

Do not consume Coins or resources.

---

# 68. Error Flow — Purchase Failure

`Purchase`
→ Store failure

Show:

- Purchase not completed.
- Retry / close.

Do not grant entitlement.

---

# 69. Error Flow — Solver Generation Failure

If repeated randomization/solver attempts fail:

1. Log diagnostic.
2. Use configured fallback.
3. Never present an unvalidated board knowingly.

Possible fallback strategies belong to Solver Specification.

Player-facing message should be rare and generic.

---

# 70. Error Flow — Cloud Save Failure

Gameplay should continue locally.

Show non-blocking sync status where relevant.

Do not repeatedly interrupt the player with modal errors.

---

# 71. Screen State Model

Every screen should consider:

- Loading.
- Loaded.
- Empty where relevant.
- Error.
- Offline where relevant.
- Disabled controls.
- Pending purchase/ad.
- Syncing.
- Success.

Gameplay additionally requires:

- Active.
- Paused.
- Dead End.
- Out of Moves.
- Completing Association.
- Level Complete.

---

# 72. Back Navigation Rules

## Gameplay
Back action:
→ Pause Menu, not immediate exit.

## Shop / Settings / Account
Back:
→ Previous screen.

## Purchase in progress
Do not allow navigation to create duplicate purchase actions.

## Tutorial
Back behavior is **TBD**:
- Could pause/exit tutorial.
- Should not accidentally skip onboarding state.

---

# 73. Modal Priority Rules

If multiple system states occur simultaneously, prioritize:

1. Purchase/transaction critical state.
2. Association completion animation.
3. Level win.
4. Dead End.
5. Out of Moves.
6. Reward presentation.
7. Hint messages.
8. Non-critical notifications.

This ordering is **PROPOSED** and should be validated technically.

---

# 74. Gameplay Overlay Rules

Avoid stacking multiple overlays.

Examples:

- Do not show Hint prompt while Level Complete is opening.
- Do not show Interstitial immediately after Rewarded Ad.
- Do not show Daily Reward modal over active gameplay.
- Do not interrupt an Association completion with monetization.

---

# 75. Ad Placement UX

## Rewarded Ads
Always user-initiated.

Entry points:

- No Hints.
- Out of Moves.
- Dead-End Rescue.
- Optional Coin grant.

## Interstitial Ads
Only between natural gameplay moments.

**CONFIRMED** — Final Decision Register v1.1 §2

- Adaptive.
- Baseline around every 3–5 completed Levels.
- Max 3/session.
- Not immediately after Rewarded Ad, purchase, tutorial, failure, Dead-End, or Out-of-Moves decline.

Never:

- Mid-drag.
- Mid-level.
- During tutorial.
- Immediately after failure.
- Immediately after Rewarded Ad.
- Immediately after purchase.

Remove Ads removes Interstitials only; optional Rewarded Ads remain.

---

# 76. Economy UX Flow Principles

Every Coin spend should show:

- Cost.
- Current balance.
- Result.

If balance insufficient:

→ Shop or Rewarded alternative.

Avoid auto-spending Coins without explicit action.

---

# 77. Chapter Progress Flow

`Level Complete`
→ Update `x/50`
→ If not Chapter end
→ Next level

If Chapter final level:
→ Chapter milestone experience
→ Grant Chapter completion reward: **500 Coins + 2 Hints** (**CONFIRMED** — Final Decision Register v1.1 §3 / Progression Design v1.0)
→ Unlock next Chapter
→ Continue

---

# 78. Proposed Chapter Complete Screen

## Priority
P0 — launch (reward CONFIRMED; presentation **PROPOSED**)

**CONFIRMED** reward:

`500 Coins + 2 Hints`

**PROPOSED** presentation content:

- `اكتمل الفصل`
- Chapter number.
- 50/50 progress.
- Reward grant.
- Next Chapter CTA.

Do not block continuation behind a purchase.

See Progression Design v1.0 (`docs/Progression_Design_Arabic_Solitaire_Association_v1.0.md`).

---

# 79. Replay Flow

Replay behavior is not approved.

If enabled later:

`Chapter / Level Progress`
→ Select completed level
→ New randomized attempt

Reward behavior must be explicitly defined to prevent Coin farming.

No replay reward rule should be assumed yet.

---

# 80. Visual Content Flow

For Illustration/Emoji/Number/Symbol Associations:

- Core gameplay is unchanged.
- Association Card remains text.
- Member Card rendering changes by content type.
- Drop/Stack rules remain identical.

The UX should not create separate game modes for different content types.

---

# 81. Mixed Content Level Flow

A Level can contain:

- Text Association.
- Emoji Association.
- Illustration Association.
- Number/Symbol Association.

The player interacts with all through the same Core Board.

No extra tutorial should be required once the player understands that the Association clue remains textual.

---

# 82. Content Error Reporting

## Priority
P0 — launch

**CONFIRMED** — Final Decision Register v1.1 §8

Main Journey includes a simple **Report a problem** action from launch.

Flow:

`Pause / Help`
→ Report a problem
→ Select reason
→ Submit level/content identifiers

Useful for Arabic semantic QA and operational disablement without app release.

---

# 83. Admin / CMS Screen Inventory

The following are internal, not player-facing.

## P0 Internal Screens

1. Admin Login
2. Content Dashboard
3. Association List
4. Association Editor
5. Member Editor
6. Content Review Queue
7. Duplicate/Search Results
8. Level Configuration List
9. Level Configuration Editor
10. Solver Validation Result
11. Publish / Activate / Deactivate
12. Content Version History
13. Basic Remote Config
14. Basic Operations / Diagnostics

## Post-MVP Internal Screens

15. Event Management
16. Pack Management
17. Achievement Management
18. Badge Management
19. Collection Management
20. Cosmetic Management
21. Advanced Economy Configuration
22. Experiment Management
23. Leaderboard Operations
24. AI Content Studio

---

# 84. Admin Flow — Content Creation

`Admin`
→ Create Association
→ Enter full relation
→ Enter concise clue
→ Add Members
→ Set content type
→ Set relation type
→ Set semantic difficulty
→ Language/Semantic review
→ Duplicate check
→ Approve
→ Publish

Human approval is mandatory.

---

# 85. Admin Flow — Level Configuration

`Admin`
→ Create/Edit Level Configuration
→ Set:
- Association count
- Group sizes
- Tableau columns/sizes
- Stock size
- Association Slot count
- Move Limit
- Board difficulty target
- Semantic difficulty target
- Eligible content constraints

→ Run validation/simulation
→ Review metrics
→ Approve
→ Publish

---

# 86. Admin Flow — Disable Problematic Content

`Content Search`
→ Open item
→ Deactivate
→ Publish content version
→ Remote/client receives update

The system should support operational removal of problematic content without waiting for an app release where architecture allows.

---

# 87. User Flow Matrix

| Flow | MVP Priority | Entry | Success Exit |
|---|---|---|---|
| First-time onboarding | P0 | First launch | Home / first level |
| Main Journey | P0 | Home | Next level |
| Restart | P0 | Gameplay | New attempt |
| Hint | P0 | Gameplay | Gameplay |
| Out of Moves | P0 | Gameplay | Gameplay / Restart |
| Dead End | P0 | Gameplay | Gameplay / Restart |
| Level Complete | P0 | Gameplay | Next level / Home |
| Shop purchase | P0 | Home/Offer | Shop/Home |
| Account link | P0 | Account | Account/Home |
| Cloud sync | P0 | Background | Synced |
| Daily Reward | P0 | Home | Home |
| Daily Challenge | P0 | Home | Home |
| Daily Streak | P0 | Home | Home |
| Report a problem | P0 | Pause/Help | Submitted / Home |
| Events | Post-MVP | Home | Home |
| Packs | Post-MVP | Home | Home |
| Achievements | Post-MVP | Profile/Home | Home |
| Leaderboards | Post-MVP | Home | Home |

---

# 88. MVP Navigation Recommendation

**PROPOSED**

Recommended MVP Home navigation:

### Main Content
- Continue Journey
- Chapter Progress

### Secondary Cards
- Daily Reward — launch
- Daily Challenge — launch
- Daily Streak — launch

### Utility
- Shop
- Account
- Settings
- Report a problem (from Pause/Help during Main Journey)

Avoid a five-tab navigation until Post-MVP meta systems create enough independent destinations.

---

# 89. Full Product Navigation Evolution

When Full Product systems grow, navigation may evolve to:

**PROPOSED**

- Home
- Journey
- Events/Packs
- Progress/Profile
- Shop

Settings remain under profile/menu.

This is intentionally not a current MVP commitment.

---

# 90. UX Decisions Already Confirmed

The following underlying behaviors are **CONFIRMED** (including Final Decision Register v1.1) and must be reflected in screens/flows:

1. Drag & Drop is the primary card interaction.
2. Invalid drops are rejected.
3. Invalid moves consume no Move.
4. Invalid moves reset current correct-action streak.
5. Association completion is automatic.
6. Completed Association disappears immediately.
7. Stack cannot be split.
8. Stock shows up to three visible cards; only the final card is playable.
9. Restore Stock is unlimited and preserves order.
10. Undo returns one eligible Move and cannot chain.
11. Completion Move cannot be undone.
12. Hint gives instruction only, not auto-play.
13. Hint does not consume a Move.
14. Dead End is detected automatically; Dead-End Rescue exists (200 Coins; max 1/Attempt; Solver-Guided Recovery).
15. Out-of-Moves offers Extra Moves (+5; 150 then 250 Coins; max 2/Attempt).
16. Restart generates a new shuffle.
17. Win requires all cards cleared.
18. Base completion reward = 50 Coins.
19. Remaining Moves = 2 Coins each.
20. Correct-action streak uses 3/4/5 reward progression.
21. No Lives/Energy.
22. Main Journey is Endless (Progression Design v1.0).
23. Standard Chapter = 50 levels; launch 5 Chapters / 250 Level Definitions.
24. Chapter completion reward = 500 Coins + 2 Hints.
25. Anonymous play is allowed.
26. Apple/Google account linking is optional.
27. Rewarded Ads are optional (Hints, Extra Moves, Dead-End Rescue, Coins).
28. Remove Ads removes Interstitials only; Rewarded Ads remain optional.
29. Interstitials: adaptive; ~every 3–5 completed Levels; max 3/session; skip after Rewarded Ad, purchase, tutorial, failure, Dead-End, or Out-of-Moves decline.
30. Daily Reward, Daily Challenge, and Daily Streak ship at launch.
31. Smart Notifications at launch: Daily Challenge + Streak Risk; quiet hours 22:00–09:00 player-local.
32. Main Journey **Report a problem** ships at launch.
33. Cloud conflict policy is domain-specific (progression max, wallet ledger, purchases authoritative, settings latest, active attempt local).

---

# 91. UX Decisions Still Proposed / TBD

The following require approval or later UI design:

1. No bottom navigation in MVP.
2. Exact Home layout.
3. Exact Chapter Progress visualization.
4. Exact tutorial count and sequencing.
5. Whether Hint uses text only or text + target highlighting.
6. Exact Dead-End Rescue UI chrome (values CONFIRMED).
7. Exact fallback after repeated board-generation failure.
8. Cloud conflict comparison presentation (policy CONFIRMED).
9. Daily Reward calendar presentation chrome (values CONFIRMED).
10. Notification permission timing.
11. Chapter Complete screen presentation (reward CONFIRMED).
12. Replay support and replay reward anti-farming (**STILL TBD**).
13. Full Product navigation structure.
14. Exact modal priority.
15. Exact real-money IAP store prices (**STILL TBD** — Final Decision Register v1.1 §14).

---

# 92. Recommended Next UX Deliverables

After approval of this screen inventory, produce:

1. **Information Architecture**
2. **Low-Fidelity Wireframes**
3. **Gameplay Interaction Specification**
4. **Tutorial Flow Specification**
5. **Error & Empty States Catalogue**
6. **Component Inventory / Design System**
7. **Clickable Prototype**
8. **Final UI Design**

For engineering planning, the most important next document is the **Gameplay Interaction Specification**, because gameplay behavior drives both UI state and Game Engine contracts.

---

# 93. Baseline Status

This document is **Screen Inventory & User Flows v1.0**, decision-aligned to **Final Decision Register v1.1**.

It maps approved product/game rules into the required UX surfaces and flows, including launch Daily systems, Chapter rewards, Interstitial/Remove Ads rules, and Report a problem.

Where UX chrome was not closed by the Register, this document keeps **PROPOSED** / **STILL TBD** markers rather than inventing final UI.

**End of Screen Inventory & User Flows v1.0**
