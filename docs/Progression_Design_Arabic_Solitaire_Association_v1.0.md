# Progression Design
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Level Design Framework v1.0 + Difficulty Model v1.0 + Content Design System v1.0  
**Important:** Items marked **CONFIRMED** reflect Final Decision Register v1.1 §3 (and related approved cross-links). Items marked **Post-MVP** are explicitly deferred. Items left open remain **STILL TBD** and must not be invented here.

---

# 1. Purpose

This document defines the Main Journey progression model for the Arabic Solitaire Association game.

It covers:

- Endless numerical Main Journey structure.
- Chapter sizing and launch content volume.
- Difficulty-wave pacing across Board and Semantic axes.
- Group-size introduction order.
- Sequential Level unlock rules.
- Association Clue / Variant reuse constraints.
- Content-type progression (text dominant → gradual visual).
- Chapter completion rewards.
- Explicit Post-MVP meta-progression exclusions.

Cross-references:

- Level Design Framework — how Level Definitions are configured and validated.
- Difficulty Model — Board Difficulty and Semantic Difficulty measurement.
- Game Economy Design — Coin/Hint rewards and sinks.
- Content Design System — Association/Variant authoring and reuse policy.
- Final Decision Register v1.1 — authoritative decision baseline.

---

# 2. Confirmed Progression Pillars

**CONFIRMED** — Final Decision Register v1.1 §3

1. Main Journey is endless and numerical.
2. Standard Chapter size is 50 Levels.
3. Launch ships 5 Chapters = 250 Level Definitions.
4. Difficulty uses two axes: Board Difficulty and Semantic Difficulty.
5. Difficulty structure uses a 10-Level Wave × 5 Waves per Chapter.
6. Long-term difficulty rises while local waves provide relief.
7. Group-size progression: groups of 3 first → groups of 4 become standard → groups of 5/mixed later.
8. Sequential unlocking: complete Level N to unlock Level N+1.
9. Same Association Clue reuse cooldown: at least 20 Levels.
10. Exact same Variant cannot repeat inside the same Chapter.
11. Text remains the dominant content type.
12. Early/mid Levels: maximum one visual Association per Level.
13. Illustration content is introduced gradually after tutorial/early Levels.
14. Chapter completion reward: 500 Coins + 2 Hints.

---

# 3. Main Journey Structure

## 3.1 Endless Numerical Journey

**CONFIRMED**

The Main Journey is an evergreen-first, endless numerical progression.

Players advance by completing Levels in order.

Temporary, current, or trending content belongs primarily to Events/Packs (Post-MVP / post-launch LiveOps), not the Main Journey backbone.

## 3.2 Chapters

**CONFIRMED**

- A Chapter contains **50 Levels**.
- Chapters organize pacing, content reuse windows, and completion rewards.
- Chapters do not end the product; the Journey continues numerically beyond launch Chapters.

## 3.3 Launch Content Volume

**CONFIRMED**

Initial launch content:

- **5 Chapters**
- **250 Level Definitions**

Each Level Definition is a configuration + content selection profile that can produce many randomized valid Attempts (see Level Design Framework).

---

# 4. Unlock Rules

**CONFIRMED**

Progression is strictly sequential:

- Completing Level N unlocks Level N+1.
- Locked Levels are not playable ahead of unlock.
- Restart of an unlocked Level creates a new randomized Attempt of the same Level Definition; it does not skip ahead.

Replay of already-completed Levels (if later enabled) is **STILL TBD** for reward policy and is not required for launch progression.

---

# 5. Difficulty Progression

## 5.1 Two Axes

**CONFIRMED**

Every Level targets:

1. **Board Difficulty** — layout, Move Limit pressure, Stock/Tableau/Slot structure.
2. **Semantic Difficulty** — clue directness, Member familiarity, relation complexity, ambiguity.

Axes remain separately measurable (see Difficulty Model).

## 5.2 Wave Structure Inside a Chapter

**CONFIRMED**

Each Chapter uses:

`10-Level Wave × 5 Waves = 50 Levels`

Within each Wave, difficulty rises locally and then provides relief before the next climb.

Across the Chapter and Journey:

- Long-term difficulty rises.
- Local Waves prevent sustained fatigue.

Exact per-Level band templates and numeric scoring formulas belong to the Difficulty Model / Level Design Framework and remain subject to their **PROPOSED** measurement details where not closed by the Register.

## 5.3 Tutorial / Early Journey

Tutorial and earliest Main Journey Levels prioritize:

- Teaching Core Gameplay.
- Low Semantic load.
- Familiar, direct Associations.
- Text-dominant content.

Illustration and heavier visual Associations appear only after the player understands the Association mechanic.

---

# 6. Group-Size Progression

**CONFIRMED**

Association group-size introduction order:

1. **Groups of 3** first.
2. **Groups of 4** become the standard.
3. **Groups of 5** and **mixed** group sizes are introduced later in progression.

Content and Level configuration must keep clues fair at each group size (see Content Design System).

---

# 7. Content Reuse Rules

**CONFIRMED**

### Association Clue cooldown

The same Association Clue must not reuse within fewer than **20 Levels**.

### Variant uniqueness inside a Chapter

The exact same Association Variant cannot repeat inside the same Chapter.

These rules reduce perceived repetition while allowing evergreen concepts to return with new Member sets / Relations over longer spans (see Content Design System).

---

# 8. Content-Type Progression

**CONFIRMED**

- **Text** remains the dominant content type across the Journey.
- Early/mid Levels allow **at most one visual Association per Level**.
- **Illustration** content is introduced gradually after tutorial/early Levels.

Association Cards remain textual clues even when Members are Number, Symbol, Emoji, or Illustration/Icon.

Visual introduction must not create a separate game mode; Core Board rules stay identical.

---

# 9. Chapter Completion Reward

**CONFIRMED**

Completing the final Level of a standard Chapter grants:

`500 Coins + 2 Hints`

This reward is in addition to the normal Level completion economy (base Coins, Remaining Moves Coins, streak Coins — see Game Economy Design).

Chapter Complete presentation UX may still be refined in Screen Inventory / UI design, but the reward values above are closed.

---

# 10. Daily Systems vs Main Journey

**CONFIRMED** — Final Decision Register v1.1 §4

Launch includes Daily Reward, Daily Challenge, and Daily Streak alongside P0 core play.

Daily systems are retention layers; they do **not** advance Main Journey Level unlock.

Daily Challenge uses a fixed deterministic board per challenge cohort and does not replace Chapter progression.

---

# 11. Explicitly Deferred — Post-MVP

**Post-MVP** — Final Decision Register v1.1 §13

The following meta-progression systems are **not** part of launch Main Journey progression:

- Player XP / Player Level.
- Achievements.
- Badges.
- Collections.
- Leaderboards.
- Temporary Events as a progression track (first Event only after Daily systems and core metrics are stable; post-launch).

Permanent Special Packs, richer notification types beyond Daily Challenge / Streak Risk, and advanced LiveOps/event economy are likewise Post-MVP.

Do not invent interim XP, badge, or collection hooks inside Chapter rewards for launch.

---

# 12. Proposed Remaining / STILL TBD

Items intentionally left open (Final Decision Register v1.1 §14 and related product TBD):

1. Exact Board/Semantic band assignment tables per Wave slot (measurement detail in Difficulty Model — **PROPOSED** where not Register-closed).
2. Whether completed-Level replay is enabled, and if so, reward anti-farming rules.
3. Exact Chapter Complete screen presentation (reward values are CONFIRMED; UX chrome may remain PROPOSED).
4. Exact illustration unlock Level index (gradual after tutorial/early is CONFIRMED; precise first-illustration Level number is design tuning).

Commercial pricing, staffing/calendar, and infrastructure sizing TBD items are out of scope for this document.

---

# 13. Cross-Document Responsibilities

| Concern | Owning Document |
|---|---|
| Level Definition fields, generation, Solver acceptance | Level Design Framework |
| Board/Semantic scoring and Wave band templates | Difficulty Model |
| Coin/Hint grants, sinks, Daily economy values | Game Economy Design |
| Association/Variant authoring, fairness, ambiguity | Content Design System |
| Arabic linguistic rules | Arabic Content Guidelines |
| Screens for Chapter Progress / Chapter Complete / Daily | Screen Inventory & User Flows |
| Authoritative closed decisions | Final Decision Register v1.1 |

---

# 14. Progression Decision Register — Confirmed

The following are **CONFIRMED** per Final Decision Register v1.1:

1. Endless numerical Main Journey.
2. Standard Chapter = 50 Levels.
3. Launch = 5 Chapters / 250 Level Definitions.
4. Difficulty axes = Board + Semantic.
5. 10-Level Wave × 5 per Chapter.
6. Long-term rise + local relief.
7. Group sizes: 3 → 4 standard → 5/mixed later.
8. Unlock Level N → Level N+1 only.
9. Association Clue reuse cooldown ≥ 20 Levels.
10. Exact same Variant cannot repeat in the same Chapter.
11. Text-dominant content.
12. Early/mid: max one visual Association per Level.
13. Illustration introduced gradually after tutorial/early.
14. Chapter completion reward = 500 Coins + 2 Hints.
15. No Lives/Energy gating of progression.
16. XP / Player Level / Achievements / Badges / Collections / Leaderboards / Events = Post-MVP (not launch progression).

---

# 15. Progression Decision Register — Proposed Remaining

The following remain **PROPOSED** or **STILL TBD** and require explicit later approval:

1. Exact per-slot Wave difficulty templates and numeric thresholds.
2. Completed-Level replay enablement and reward policy.
3. Exact first-illustration Level index within the “gradual after early” window.
4. Chapter Complete UX presentation details beyond the confirmed reward grant.

---

# 16. Baseline Status

This document is **Progression Design v1.0**.

It aligns Main Journey progression with **Final Decision Register v1.1 §3**, cites related Register sections for Daily and Deferred items, and leaves measurement/UX tuning that the Register intentionally left open as **PROPOSED** / **STILL TBD**.

**End of Progression Design v1.0**
