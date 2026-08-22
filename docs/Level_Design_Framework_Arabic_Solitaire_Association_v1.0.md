# Level Design Framework
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source Documents:** Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 + Screen Inventory & User Flows v1.0 + Content Design System v1.0 + Arabic Content Guidelines v1.0 + Final Decision Register v1.1  
**Important:** Register-approved items are marked **APPROVED/CONFIRMED**. Deferred Post-MVP items are marked accordingly. Intentional TBD items (e.g. exact generation fallback behavior, content persistence on incomplete re-entry) remain open. Cloud baseline is **Firebase-first** per Register §§6–9 / §13A (Azure MVP topology **SUPERSEDED**).

---

# 1. Purpose

This document defines how a playable level is designed, configured, generated, validated, classified, published, and monitored.

It converts the approved game rules into a practical Level Design system that can support:

- Main Journey.
- Endless progression.
- Tutorial levels.
- Daily Challenge.
- Events.
- Permanent Packs.
- Difficulty Waves.
- Randomized attempts.
- Solver validation.
- Semantic variation.
- Scalable content production.

The key principle is that a Level is **not one fixed board**.

A Level is a **configuration + content definition** that can produce many different valid boards through randomization.

---

# 2. Definition of a Level

A Level consists of:

1. **Level Identity**
2. **Level Configuration**
3. **Content Selection Rules**
4. **Difficulty Targets**
5. **Move Limit**
6. **Board Layout Constraints**
7. **Association Slot Constraints**
8. **Stock Constraints**
9. **Solver Acceptance Criteria**
10. **Progression Placement**
11. **Analytics Metadata**
12. **Publication Status**

A generated attempt is produced from this Level definition.

---

# 3. Level vs Attempt

## Level

Persistent progression object.

Example:

`Level 137`

Contains:

- Move Limit.
- Association count.
- Group-size profile.
- Tableau profile.
- Stock profile.
- Semantic difficulty target.
- Board difficulty target.
- Content rules.

## Attempt

One randomized playable instance of the Level.

Each Attempt contains:

- Specific selected Association Variants.
- Specific shuffle.
- Specific Tableau distribution.
- Specific Stock order.
- Hidden/revealed card positions.
- Solver result.

**CONFIRMED:** Every Restart creates a new Attempt for the same Level.

---

# 4. Level Configuration — Minimum Fields

Every Level Configuration should support at least:

- `level_id`
- `journey_level_number`
- `chapter_id`
- `level_type`
- `association_count`
- `group_size_profile`
- `tableau_column_count`
- `tableau_column_sizes`
- `stock_size`
- `association_slot_count`
- `move_limit`
- `board_difficulty_target`
- `semantic_difficulty_target`
- `allowed_relation_types`
- `allowed_content_types`
- `ambiguity_policy`
- `content_filters`
- `solver_acceptance_profile`
- `active_status`
- `version`

Exact data types belong to the Data Model.

---

# 5. Level Types

The system should support:

## 5.1 Main Journey Level

**CONFIRMED**

Normal Endless progression.

## 5.2 Tutorial Level

Guided or semi-guided instructional level.

## 5.3 Daily Challenge

**CONFIRMED at launch**

Shared/deterministic or controlled challenge. Included in initial launch with P0, Daily Reward, and Daily Streak.

## 5.4 Event Level

**DEFERRED Post-MVP** temporary progression content.

## 5.5 Pack Level

**DEFERRED Post-MVP** permanent special content.

---

# 6. Core Level Invariants

Every normal playable level must respect the following approved rules:

1. Association Cards are part of the deck.
2. Association Slots begin empty.
3. All Cards start in Tableau or Stock.
4. Each Tableau column initially exposes exactly one face-up Card.
5. Remaining cards beneath are face-down.
6. Stock may contain both Association and Member Cards.
7. All Stacks are atomic and cannot split.
8. Completion happens only in an Association Slot.
9. Restore Stock is unlimited and preserves order.
10. Invalid moves consume no Move.
11. Move Limit is fixed for the Level.
12. Restart creates a new shuffle.
13. The board must be solvable within Move Limit.
14. Win requires all cards to be cleared.

---

# 7. Level Generation Pipeline

Normal Main Journey Attempt generation:

`Level Config`
→ `Content Eligibility`
→ `Association Variant Selection`
→ `Card Pool Construction`
→ `Full Random Shuffle`
→ `Tableau Deal`
→ `Stock Deal`
→ `Association Slots = Empty`
→ `Solver Run`
→ `Move-Limit Validation`
→ `Difficulty Validation`
→ `Content Conflict Validation`
→ `Accept or Regenerate`

---

# 8. Association Count

**CONFIRMED**

Association count varies per Level.

It should not increase linearly forever.

## Proposed Bands

**PROPOSED**

- Intro: 2–3
- Early: 3–4
- Standard: 4–5
- Advanced: 5–6
- Peak: 6+ only if UX/Solver permits

Exact maximum requires device-layout validation.

---

# 9. Group Size

**CONFIRMED**

Supported progression:

- 3-member groups.
- 4-member groups.
- 5-member groups.
- Mixed group sizes.

## Proposed Profiles

**PROPOSED**

### G3
All groups = 3.

### G4
All groups = 4.

### G5
All groups = 5.

### G34
Mix of 3 and 4.

### G45
Mix of 4 and 5.

### G345
Mix of 3, 4, and 5.

These are internal configuration labels only.

---

# 10. Group Size Selection

A Level Configuration may define:

### Fixed Profile
Every generated attempt uses the same group sizes.

### Bounded Random Profile
The generator chooses among approved group-size combinations.

**PROPOSED**

For Main Journey, prefer bounded variation rather than completely arbitrary group-size selection.

Reason:

- Preserves designed difficulty.
- Makes Move Limit tuning more reliable.
- Simplifies Solver validation.

---

# 11. Total Card Count

Total cards in a Level:

`Total Cards = Association Cards + Member Cards`

For each Association:

`Cards = 1 Association Card + N Member Cards`

Example:

4 Associations × 4 Members:

`4 × (1 + 4) = 20 Cards`

The total must exactly equal:

`Total Tableau Cards + Stock Cards`

---

# 12. Tableau Column Count

**CONFIRMED**

Variable by Level.

Level Design must consider:

- Screen width.
- Card readability.
- Stack visibility.
- Drag target size.
- Device compatibility.

## Proposed Bands

**PROPOSED**

- Intro: 4–5 columns
- Standard: 5–7 columns
- Advanced: 6–8 columns

Exact supported maximum is UX-dependent.

---

# 13. Tableau Column Sizes

Column sizes are variable.

Design principles:

- Avoid identical layouts every Level.
- Use asymmetry to create strategic variation.
- Avoid extreme depth early.
- Ensure enough visible interaction at start.

Possible profile types:

- Balanced.
- Slightly asymmetric.
- Deep-center.
- Deep-edge.
- Alternating.
- Highly asymmetric.

These profile names are **PROPOSED**.

---

# 14. Initial Face-Up Rule

**CONFIRMED**

Each Tableau column begins with exactly:

`1 face-up Card`

All cards below start face-down.

The initial face-up card may be:

- Association Card.
- Member Card.

No type restriction is required beyond Solver acceptance.

---

# 15. Stock Size

**CONFIRMED**

Stock size varies per Level.

Stock pressure depends on:

- Number of cards.
- Number of essential cards buried in Stock.
- Required Stock cycles.
- Move Limit.

A large Stock does not automatically mean a hard Level.

---

# 16. Stock Ratio

**PROPOSED**

A useful design metric:

`Stock Ratio = Stock Cards / Total Cards`

Possible qualitative bands:

- Low Stock.
- Medium Stock.
- High Stock.

Exact percentages should be derived from simulation.

---

# 17. Association Slot Count

**CONFIRMED**

Variable by Level.

Slots may be fewer than total Associations.

This creates Slot Pressure.

---

# 18. Slot Pressure Metric

**PROPOSED**

Define:

`Slot Pressure = Association Count - Association Slot Count`

Example:

5 Associations, 3 Slots:

`Slot Pressure = 2`

Potential bands:

- 0 = no pressure
- 1 = light
- 2 = medium
- 3+ = high

This is a useful internal metric, not a player-facing system.

---

# 19. Move Limit

**CONFIRMED**

Every Level has a fixed Move Limit.

It remains the same across Restarts.

The Solver must validate each random board against this limit.

---

# 20. Reference Moves

For each accepted Attempt, Solver should produce:

- Minimum Moves, if exact optimization is feasible.
- Or reference/best-known Moves if exact minimum is too expensive.

This value is required for difficulty analysis.

---

# 21. Move Slack

**PROPOSED**

Define:

`Move Slack = Move Limit - Reference Moves`

Alternative normalized form:

`Move Slack Ratio = Move Slack / Reference Moves`

This is one of the strongest Board Difficulty signals.

---

# 22. Proposed Move Slack Bands

**PROPOSED**

Conceptual:

### Easy
Large slack.

### Medium
Comfortable but meaningful slack.

### Hard
Tight slack.

### Peak
Very tight but fair.

Exact values must come from Solver simulations and human playtests.

---

# 23. Board Difficulty Inputs

Board Difficulty may include:

- Association count.
- Group sizes.
- Tableau column count.
- Tableau depth.
- Stock size.
- Slot pressure.
- Move slack.
- Required Stock cycles.
- Number of initially actionable moves.
- Number of hidden critical cards.
- Branching factor.
- Dead-end probability.
- Empty-column availability.
- Number of forced sequencing dependencies.

---

# 24. Semantic Difficulty Inputs

Semantic Difficulty may include:

- Clue complexity.
- Member familiarity.
- Relation type.
- Ambiguity.
- Topic familiarity.
- Language pattern complexity.
- Wordplay.
- Number of semantically competing Associations.

---

# 25. Two-Axis Level Difficulty

**CONFIRMED**

Every Level should be thought of as:

`Board Difficulty × Semantic Difficulty`

Examples:

- Easy × Easy
- Hard × Easy
- Easy × Hard
- Hard × Hard

This allows difficulty waves without monotony.

---

# 26. Proposed Board Difficulty Scale

**PROPOSED**

Internal 5-level scale:

- B1 — Very Easy
- B2 — Easy
- B3 — Medium
- B4 — Hard
- B5 — Peak

---

# 27. Proposed Semantic Difficulty Scale

**PROPOSED**

Internal 5-level scale:

- S1 — Very Easy
- S2 — Easy
- S3 — Medium
- S4 — Hard
- S5 — Expert

This aligns conceptually with the Content Design System.

---

# 28. Overall Level Difficulty

**PROPOSED**

Overall difficulty should not simply average B and S.

A Level with:

`B5 + S1`

may feel very different from:

`B3 + S3`

Therefore analytics should preserve both axes independently.

---

# 29. Difficulty Waves

**CONFIRMED**

The Main Journey uses waves.

## 10-Level Wave × 5 per Chapter

**CONFIRMED**

Difficulty structure: 10-Level Wave × 5 per Chapter.

Illustrative wave pacing (exact Easy/Hard labels within the wave remain design guidance):

1. Easy
2. Easy+
3. Medium
4. Medium
5. Hard
6. Relief
7. Medium+
8. Hard
9. Hard+
10. Peak

Five such waves form one 50-Level Chapter. Long-term difficulty rises while local waves provide relief.

---

# 30. Relief Levels

A Relief Level should deliberately lower one or more pressure dimensions:

- More Move slack.
- Easier semantics.
- Fewer Associations.
- More Slots.
- Smaller Stock.
- Simpler relation types.

Relief Levels still need meaningful gameplay.

---

# 31. Peak Levels

Peak Levels may combine:

- Higher Association count.
- Tighter Move slack.
- Higher Slot Pressure.
- More complex semantics.
- Larger groups.
- Deeper Tableau.

They must remain Solver-validated and human-reviewed.

---

# 32. Tutorial Level Design

Tutorial levels differ from normal levels.

They may use:

- Fixed or constrained setups.
- Restricted interactions.
- Forced sequence.
- Guaranteed visible targets.
- Free first Hint.
- Reduced/disabled monetization.

These exceptions exist only to teach mechanics.

---

# 33. Tutorial Progression

**PROPOSED**

Tutorial should introduce mechanics in this conceptual order:

1. Match Member to Association.
2. Stack same-group Members.
3. Atomic Stack.
4. Association Card + Word Stack.
5. Association Slot.
6. Stock.
7. Move Limit.
8. Undo.
9. Hint.
10. Streak.

Exact count/order remains pending approval.

---

# 34. Early Main Journey Level Design

Early Levels should prioritize:

- Clear clues.
- Familiar vocabulary.
- Low Slot Pressure.
- Lower Association counts.
- 3-member groups transitioning into 4.
- Generous Move slack.
- Simple Tableau structures.

---

# 35. Standard Mid-Game Design

Mid progression may use:

- 4-member standard groups.
- Moderate Slot Pressure.
- Larger Stock.
- More varied Tableau.
- Mixed semantic difficulty.
- More indirect clues.

---

# 36. Advanced Level Design

Advanced Levels may include:

- 5-member groups.
- Mixed group sizes.
- Higher Slot Pressure.
- Tight Move Limits.
- Larger/deeper Tableau.
- Controlled semantic ambiguity.
- Linguistic and wordplay relations.

---

# 37. Content-Type Level Design

A Level may contain Associations of different content types.

**CONFIRMED**

Possible mix:

- Text.
- Emoji.
- Illustration/Icon.
- Number.
- Symbol.

However, each individual Association remains homogeneous.

---

# 38. Content-Type Mix Rules

**PROPOSED**

Do not introduce too many unfamiliar content types simultaneously.

Example:

Early:
Mostly Text.

Later:
Text + Number/Symbol.

Then:
Text + Emoji.

Later:
Text + Illustration.

Advanced:
Mixed.

---

# 39. Semantic Ambiguity Levels

**CONFIRMED**

Intentional ambiguity belongs to advanced progression.

## Proposed Policy

**PROPOSED**

- B/S low tiers: no intentional ambiguity.
- Mid: mild ambiguity.
- Advanced: controlled ambiguity.
- Peak: multiple plausible interpretations permitted if still fair.

---

# 40. Association Compatibility Review

Before generating a board, selected Associations should be checked for:

- Duplicate clues.
- Duplicate Members.
- Excessive semantic overlap.
- Unintentional ambiguity.
- Conflicting visual identity.
- Topic repetition.

---

# 41. Level Content Set

A Level may define:

### Fixed Content Set
Same Associations every attempt.

### Bounded Content Pool
Select from approved candidate Associations.

Current Restart behavior says same Level content remains the same within that Level attempt sequence.

**CONFIRMED:** Restart keeps same Level Content.

For future levels, whether Main Journey Level content is permanently fixed to one set or selected once per first entry from a pool is **TBD**.

Do not assume this without a product decision.

---

# 42. Attempt Randomization

**CONFIRMED**

Once Level content is determined:

All Cards are randomized across:

- Tableau.
- Stock.

Initial face-up types are unrestricted.

---

# 43. Randomization Constraints

Current design requires ordinary randomization with Solver acceptance.

Do not add hidden placement constraints unless necessary for:

- Tutorial.
- Performance.
- Generation feasibility.

Any such constraints should be documented.

---

# 44. Solver Acceptance

A generated board is accepted only if:

1. It is valid under Game Rules.
2. It is solvable.
3. It is solvable within Move Limit.
4. It meets target Board Difficulty.
5. Content is valid.
6. Generation performance is acceptable.

---

# 45. Solver Rejection Reasons

Recommended diagnostics:

- Unsolvable.
- Solvable but exceeds Move Limit.
- Too easy.
- Too difficult.
- Too many required Stock cycles.
- Excessive dead-end branching.
- Generation timeout.
- Invalid state.
- Content conflict.

---

# 46. Board Generation Retry

**PROPOSED**

Level Generator should retry until:

- Accepted board found.
- Maximum attempts reached.
- Timeout reached.

Fallback behavior belongs to Solver Specification.

Never knowingly show an unvalidated board as fallback.

---

# 47. Generation Debugging

Even though seed-history prevention is not a product feature, engineering should store enough reproduction data for failed boards.

Possible debug data:

- Level ID.
- Config version.
- Content IDs.
- Random seed.
- Shuffle.
- Solver version.

This is **PROPOSED engineering support**, not player-facing behavior.

---

# 48. Level Difficulty Profile

Each Level should have a compact Level Difficulty Profile.

Example:

`B3 / S2 / SlotPressure1 / GroupProfileG4`

This supports:

- Progression planning.
- Analytics.
- Debugging.
- Content review.

---

# 49. Level Archetypes

**PROPOSED**

Useful archetypes:

### Open Board
Many available moves.

### Slot Pressure
Few Association Slots.

### Stock Heavy
Key progression depends on Stock.

### Deep Tableau
Important cards buried.

### Stack Planning
Requires smart same-group consolidation.

### Semantic Puzzle
Board easier, words harder.

### Hybrid Challenge
High Board + Semantic pressure.

These archetypes help create variety.

---

# 50. Open Board Archetype

Characteristics:

- Low slot pressure.
- More face-up flexibility.
- Generous Move slack.
- Easy/medium semantics.

Suitable for:

- Early levels.
- Relief levels.
- Teaching new content types.

---

# 51. Slot Pressure Archetype

Characteristics:

- Associations > Slots.
- Requires completing one group before activating another.
- Increases planning.

Avoid introducing before player understands Association completion.

---

# 52. Stock Heavy Archetype

Characteristics:

- Larger Stock.
- Important cards appear later.
- Restore Stock may be strategically necessary.

Must not become repetitive Move tax.

---

# 53. Deep Tableau Archetype

Characteristics:

- More hidden cards.
- Requires clearing top units to reveal dependencies.

Difficulty comes from access management.

---

# 54. Stack Planning Archetype

Characteristics:

- Empty-column use matters.
- Same-group merges reduce board congestion.
- Atomic-stack limitations matter.

---

# 55. Semantic Puzzle Archetype

Characteristics:

- Board intentionally easier.
- Higher clue/member complexity.

Useful to isolate semantic challenge.

---

# 56. Hybrid Challenge Archetype

Characteristics:

- Higher Board + Semantic difficulty.
- Suitable for Peak levels.

Use carefully to avoid frustration spikes.

---

# 57. Level Variety Strategy

A Chapter should avoid repeating the same archetype too often.

**PROPOSED**

Track recent:

- Archetype.
- Relation type.
- Topic.
- Group profile.
- Slot pressure.
- Content type.

Use variety constraints when selecting the next Level template.

---

# 58. Empty Column Design

Empty Tableau columns are powerful because they accept any movable unit.

Level Design should consider:

- How often empty columns can appear.
- Whether they are expected in optimal play.
- Whether early access makes the board too easy.
- Whether they are necessary to solve.

Solver metrics should record empty-column dependencies.

---

# 59. Critical Cards

**PROPOSED**

A Critical Card is a card whose accessibility strongly constrains the solution.

Examples:

- Association Card buried deeply.
- Final missing Member behind a dependency.
- Key Stock card needed before Slot frees.

Critical-card count may be a Board Difficulty metric.

---

# 60. Forced Sequences

A board may contain sequences where only one path remains viable.

Too many forced Moves can make a Level feel mechanical.

Too few constraints can make it trivial.

Balance should aim for meaningful decision-making.

---

# 61. Branching Factor

**PROPOSED**

Solver should expose approximate number of valid meaningful choices across states.

High branching:

- More exploratory.

Low branching:

- More constrained.

Difficulty is not monotonic with branching; it should be interpreted with dead-end risk.

---

# 62. Dead-End Potential

A Board may be solvable but contain many valid-looking moves that lead to dead ends.

This can increase difficulty significantly.

Level Design should track:

- Number of bad branches.
- Earliest dead-end depth.
- Recoverability.

---

# 63. Dead-End Fairness

Dead ends must arise from strategic choices, not invisible arbitrary traps.

Hints should be able to recommend safe actions.

Automatic Dead-End Detection protects the player from wasting Moves.

---

# 64. Association Completion Timing

Level Design can influence:

- Early completion opportunities.
- Mid-game completions.
- Late completion concentration.

A healthy level should ideally produce meaningful progress during the session rather than withholding all completion until the end.

This is **PROPOSED** as a pacing goal.

---

# 65. Early Progress Feedback

**PROPOSED**

Avoid too many Levels where the player makes many moves before completing the first Association.

Early Association completion improves:

- Feedback.
- Slot turnover.
- Confidence.

Solver simulations may measure `moves_to_first_completion`.

---

# 66. Completion Distribution Metric

**PROPOSED**

Track:

- Moves to first Association completion.
- Moves between completions.
- Final completion concentration.

Useful for pacing analysis.

---

# 67. Stock Cycle Dependency

A board may require:

- Zero full Stock cycles.
- One cycle.
- Multiple cycles.

Because every Stock advance costs a Move, repeated required cycles significantly affect difficulty.

This should be measured.

---

# 68. Restore Dependency

Unlimited Restore Stock is allowed.

However, requiring excessive Restores can feel repetitive.

**PROPOSED**

Set target maximum required Restores per difficulty band.

Exact values TBD.

---

# 69. Move Efficiency

Level Design should differentiate:

- Necessary Moves.
- Optional strategic Moves.
- Wasteful Moves.

Move Limit should allow reasonable human play, not only mathematically perfect play.

---

# 70. Human Margin

**PROPOSED**

Move Limit should be based on:

`Reference Moves + Human Margin`

rather than exact optimum only.

Human Margin may vary by difficulty.

Exact formula belongs to Difficulty Model.

---

# 71. Semantic Difficulty Composition

A Level may contain Associations of mixed semantic difficulty.

Example:

- 2 × S2
- 1 × S3
- 1 × S4

This helps prevent every Association from becoming equally difficult.

---

# 72. Hardest Association Constraint

**PROPOSED**

The Level's semantic difficulty should consider the hardest Association, not just the average.

One extreme outlier can dominate perceived difficulty.

---

# 73. Topic Variety

A level may mix:

- Food.
- Geography.
- Language.
- Science.
- Everyday life.

Chapters should remain mixed.

Avoid unnecessary topic clustering unless intentionally designed.

---

# 74. Relation Type Variety

A Level may mix:

- Category.
- Context.
- Property.
- Language pattern.

However, too much variation in early levels can overwhelm.

Progression controls the breadth.

---

# 75. Main Journey Level Template Library

**PROPOSED**

Instead of designing every Level from zero, maintain reusable templates.

Example:

`MJ_EASY_4A_4G_6C_2S`

Conceptually:

- Main Journey.
- Easy.
- 4 Associations.
- Group size 4.
- 6 columns.
- 2 slots.

Templates reduce content-production overhead.

---

# 76. Template vs Level Instance

A Template defines reusable structural rules.

A Level Definition references:

- Template.
- Difficulty overrides.
- Content constraints.
- Move Limit.
- Chapter position.

This architecture is **PROPOSED**.

---

# 77. Tutorial Templates

Tutorial templates may deliberately violate normal randomization behavior.

Examples:

- Fixed card order.
- Forced first move.
- Predefined Stock.

These exceptions should be isolated from Main Journey generation.

---

# 78. Daily Challenge Design

**CONFIRMED at launch**

Daily Challenge uses the same game engine.

**CONFIRMED** differences:

- Fixed deterministic board per challenge cohort.
- Fixed content.
- Fixed Move Limit.
- One daily configuration.
- Unlimited retries during the valid day.
- Reward: 150 Coins, auto-granted on first completion.
- Reset: 00:00 validated player-local timezone; backend authoritative for Daily time/eligibility.

---

# 79. Daily Challenge Fairness

If players compare performance later through Leaderboards:

All players in the same challenge cohort should receive equivalent board conditions.

This is why deterministic/shared boards are recommended.

---

# 80. Event Level Design

**DEFERRED Post-MVP**

Event levels may vary:

- Content theme.
- Difficulty curve.
- Level count.
- Rewards.

Core game rules remain unchanged unless a future Event mechanic is explicitly approved. First Event only after Daily systems and core metrics are stable.

---

# 81. Pack Level Design

**DEFERRED Post-MVP**

Permanent Packs may specialize in:

- Dialect.
- Geography.
- Culture.
- Wordplay.

Pack progression may use different semantic assumptions because the player opted into specialized content.

---

# 82. Level Naming

Main Journey levels should primarily use numbers.

**CONFIRMED direction**

Chapters are progression structures rather than content themes.

No need for individual Level names in MVP.

---

# 83. Chapter Placement

Standard Chapter = 50 Levels.

A Level should store:

- Chapter ID.
- Position in Chapter.
- Global Journey Level Number.

---

# 84. Chapter Wave Layout

**CONFIRMED**

Within 50 Levels (10-Level Wave × 5):

- 1–10 Wave A
- 11–20 Wave B
- 21–30 Wave C
- 31–40 Wave D
- 41–50 Wave E

Final wave may be slightly stronger as design guidance.

---

# 85. Proposed Chapter Difficulty Distribution

**PROPOSED**

Example:

- 20% easy/relief.
- 35% medium.
- 30% hard.
- 15% peak.

Illustrative only.

Actual distribution requires playtesting.

---

# 86. Progression Unlocks

Level Design should know which mechanics/content types are available at a progression position.

Examples:

- Group size 5 unlocked.
- Emoji allowed.
- Ambiguity allowed.
- Wordplay allowed.

Exact unlock levels are pending approval.

---

# 87. Level Metadata

Recommended metadata:

- Level ID.
- Journey number.
- Chapter.
- Level type.
- Board difficulty.
- Semantic difficulty.
- Archetype.
- Association count.
- Group profile.
- Slot pressure.
- Stock ratio.
- Move Limit.
- Target Move Slack.
- Allowed content types.
- Allowed relation types.
- Ambiguity level.
- Template ID.
- Version.

---

# 88. Attempt Metadata

For every generated attempt:

- Attempt ID.
- Level ID.
- Config version.
- Association Variant IDs.
- Shuffle/debug seed.
- Solver version.
- Reference Moves.
- Board difficulty score.
- Generation attempts.
- Generation time.
- Accepted/rejected status.

---

# 89. Level Analytics

Track:

- Start rate.
- Completion rate.
- Restart rate.
- Hint usage.
- Undo usage.
- Dead-end rate.
- Extra Move usage.
- Average Moves used.
- Remaining Moves.
- Time to complete.
- Association completion timing.
- Stock cycles.
- Restore count.

---

# 90. Generated Board Analytics

Track per Attempt:

- Reference Moves.
- Actual Moves.
- Move Slack used.
- Number of Solver states explored.
- Required Restores.
- Required Stock cycles.
- Dead-end branch count.
- Moves to first completion.

---

# 91. Level Health Indicators

A Level may need revision if:

- Completion rate is abnormally low.
- Restart rate spikes.
- Hint usage spikes.
- Dead-End rate spikes.
- Generation takes too long.
- Solver rejection rate is excessive.
- Semantic complaints rise.
- Move Limit produces excessive rescue dependence.

---

# 92. Board Difficulty Calibration

Compare:

`Predicted Board Difficulty`

against:

- Actual completion rate.
- Move usage.
- Restarts.
- Dead ends.
- Hints.
- Rescue.

Use data to recalibrate internal difficulty bands.

---

# 93. Semantic Difficulty Calibration

Compare:

`Predicted Semantic Difficulty`

against:

- Wrong association attempts.
- Hint use.
- Time to first correct grouping.
- Completion time.
- Player reports.

---

# 94. Level QA — Functional

Every Level Configuration must be tested for:

- Correct total card count.
- Correct slot count.
- Correct Stock size.
- Correct Tableau distribution.
- Move Limit loaded correctly.
- Content compatibility.
- Restart behavior.
- Win condition.
- Reward calculation.

---

# 95. Level QA — Solver

Automated tests should confirm:

- Solvable boards accepted.
- Unsolvable boards rejected.
- Boards exceeding Move Limit rejected.
- Hint remains safe.
- Dead-End Detection is correct.
- Restarts always generate valid attempts.

---

# 96. Level QA — Content

Review:

- All Members belong correctly.
- Clues are fair.
- No accidental duplicate.
- Difficulty is appropriate.
- Ambiguity is intentional.
- Arabic is natural.

---

# 97. Level QA — UX

Test:

- All columns fit.
- Cards are readable.
- Stacks remain visible.
- Slots fit on supported devices.
- Stock window remains usable.
- Drag paths are not obstructed.

---

# 98. Level Publishing Workflow

Recommended:

`Draft`
→ `Content Selected`
→ `Config Complete`
→ `Simulation`
→ `Human Playtest`
→ `Difficulty Review`
→ `QA Approved`
→ `Published`

Status names are **PROPOSED**.

---

# 99. Level Simulation Requirements

Before publishing a Level template/config:

Run a large sample of generated attempts.

Measure:

- Acceptance rate.
- Generation latency.
- Reference Move distribution.
- Board Difficulty distribution.
- Required Restores.
- Dead-end branch frequency.

---

# 100. Simulation Sample Size

**CONFIRMED**

Release simulation:

- 10,000+ boards for critical Templates/Configs.
- Smaller volumes allowed for simpler configurations.

Development tuning may use smaller samples (e.g. ~1,000) before release-candidate runs.

---

# 101. Acceptance Rate

**PROPOSED**

If too many generated boards are rejected, the Level config may be poorly constrained.

Track:

`Accepted Attempts / Total Generated Attempts`

Very low acceptance can cause:

- Long load times.
- High CPU/battery cost.
- Poor scalability.

---

# 102. Generation Latency

Board generation should feel immediate or near-immediate.

Exact target is Technical Design TBD.

The UX should not show a long loading state between every level.

---

# 103. Fallback Strategy

If generation repeatedly fails:

Possible technical strategies include:

- Retry with another shuffle.
- Relax non-core difficulty constraints.
- Use cached validated board.
- Use deterministic backup board.

**TBD**

Any fallback must remain Solver-valid.

---

# 104. Cached Boards

**PROPOSED**

The system may pre-generate and cache validated boards for:

- Slow devices.
- Daily Challenge.
- Emergency fallback.
- High-cost Level configurations.

This is an architecture optimization, not a gameplay rule.

---

# 105. Fixed vs Dynamic Move Limit

**CONFIRMED**

Move Limit is fixed per Level.

Solver does **not** dynamically expose a different Move Limit per Attempt.

This is a hard Level Design rule.

---

# 106. Board Randomness vs Designed Difficulty

Randomness may alter:

- Card positions.
- Stock order.
- Initial face-up cards.

It must not alter the intended Level beyond the approved difficulty range.

The Solver/validator enforces this.

---

# 107. Level Content Persistence on Restart

**CONFIRMED**

Restart:

- Same Level.
- Same content.
- Same Move Limit.
- New shuffle.

This creates board variety while preserving semantic identity.

---

# 108. Level Content Persistence Across Re-entry

Whether leaving and later re-entering the same incomplete Level retains the same Association content or selects content anew is **TBD**.

Do not assume until approved.

---

# 109. First-Time Attempt

**CONFIRMED**

First-ever attempt is randomized.

No fixed seed is required for standard Main Journey.

Tutorial/Daily Challenge may be exceptions.

---

# 110. Repetition Prevention

Seed-history prevention is not a product requirement.

However, content repetition management may still exist separately.

Do not confuse:

- Board shuffle repetition.
- Association/content repetition.

---

# 111. Content Reuse Within Levels

Do not use identical visible Member cards across Associations in the same Level unless explicitly approved later.

This avoids unfair targeting ambiguity.

---

# 112. Association Clue Repetition

Same clue can represent different relations globally.

Within the same Level, duplicate identical clue text should normally be avoided unless intentionally designed and reviewed.

---

# 113. Level Content Balance

**PROPOSED**

A balanced semantic Level may mix:

- Familiar Association.
- Medium Association.
- One harder Association.

Avoid making every Association simultaneously obscure except at deliberate Peak levels.

---

# 114. Level Time Target

Exact level duration is not approved.

**PROPOSED**

Track completion-time bands during playtests.

Level Design should aim for short casual sessions rather than long puzzle marathons in standard Main Journey.

No numeric target should be finalized before testing.

---

# 115. Session Flow Impact

Levels should be short enough to support:

- Multiple levels per session.
- Natural Interstitial moments.
- Daily progression.

But not so short that the game feels trivial.

---

# 116. Economy Interaction

Level difficulty directly affects:

- Hint demand.
- Extra Move demand.
- Rescue demand.
- Remaining-Move reward.

Level Design must not intentionally over-tighten Move Limits to force monetization.

---

# 117. Reward Fairness

Because remaining Moves produce Coins:

Overly generous Move Limits may inflate the economy.

Overly tight Move Limits may create frustration.

Economy and Level Design must be calibrated together.

---

# 118. Level Archetype Rotation

**PROPOSED**

A Chapter should rotate archetypes.

Example conceptual sequence:

- Open Board.
- Semantic Puzzle.
- Stack Planning.
- Relief.
- Slot Pressure.
- Stock Heavy.
- Hybrid.
- Relief.
- Deep Tableau.
- Peak.

This is a framework, not a fixed sequence.

---

# 119. Level Design Authoring Tool

CMS/Admin should allow Level Designers to:

- Select template.
- Set structural values.
- Set difficulty targets.
- Set content constraints.
- Run sample generation.
- View Solver metrics.
- Preview boards.
- Publish/disable config.

---

# 120. Preview Mode

**PROPOSED**

Admin should support:

- Generate sample board.
- Play as user.
- Reveal solution.
- View Solver path.
- View difficulty metrics.
- Regenerate.

High-value for balancing.

---

# 121. Solver Path Inspection

For QA/debugging, authorized users should inspect:

- Reference solution.
- Critical Moves.
- Required Stock cycles.
- Association completion order.

This is not player-facing.

---

# 122. Level Definition Versioning

Each published Level config should be versioned.

If Move Limit or structure changes:

- New version.
- Preserve analytics history.

---

# 123. Live Tuning

Safe tunable fields may include:

- Move Limit.
- Semantic target.
- Content constraints.
- Config activation.

Changes affecting active sessions must be handled carefully.

---

# 124. Disabling a Level

If a Level config is broken:

- Deactivate version.
- Fallback to replacement config.
- Preserve player progression.

Exact live migration behavior remains operational TBD under the Firebase-first content/publish model (versioned bundles in Firebase Storage; no Azure CDN/Blob baseline).

---

# 125. MVP Level Design Scope

MVP/launch requires:

- Main Journey Levels.
- Tutorial Levels.
- Difficulty Waves (10-Level Wave × 5 per Chapter).
- Randomized Attempts.
- Solver validation.
- Variable group sizes.
- Variable Association count.
- Variable Tableau/Stock/Slots.
- Content constraints.
- Level versioning.
- Analytics.
- Simulation (10,000+ for critical Templates/Configs).
- Admin authoring.
- Daily Challenge at launch.

Events/Packs are **DEFERRED Post-MVP**.

---

# 126. MVP Launch Level Volume

**CONFIRMED**

Launch content:

`5 Chapters × 50 Levels = 250 Level Definitions`

These are not 250 fixed boards.

Each produces multiple validated Attempts.

---

# 127. Level Template Count

**PROPOSED**

Instead of 250 unique structural configurations, use a smaller reusable Level Template Library with tuned overrides.

Potential initial range:

`20–40 structural templates`

reused across progression with:

- Different content.
- Difficulty targets.
- Move Limits.
- Group profiles.

This is a recommendation, not approved.

---

# 128. Content Volume Dependency

Required content depends on:

- Average Associations per Level.
- Reuse rate.
- Member Pool size.
- Repetition cooldown.
- Semantic diversity.

A separate Content Production Plan should compute exact volume.

---

# 129. Level Design Checklist

Before publishing:

- [ ] Level identity assigned
- [ ] Chapter position assigned
- [ ] Association count valid
- [ ] Group sizes valid
- [ ] Total card count consistent
- [ ] Tableau layout valid
- [ ] Stock size valid
- [ ] Slot count valid
- [ ] Move Limit set
- [ ] Board target set
- [ ] Semantic target set
- [ ] Content constraints set
- [ ] Ambiguity policy set
- [ ] Solver simulation passed
- [ ] Human playtest passed
- [ ] Arabic content reviewed
- [ ] UX layout checked
- [ ] Analytics metadata configured
- [ ] Version published

---

# 130. Confirmed Level Design Decisions

The following are **CONFIRMED**:

1. Main Journey is Endless.
2. Standard Chapter size = 50 Levels.
3. Launch content = 5 Chapters = 250 Level Definitions.
4. Chapters contain mixed content.
5. Difficulty uses waves: 10-Level Wave × 5 per Chapter.
6. Board and Semantic Difficulty are separate axes.
7. Group Size progresses from 3 → 4 standard → 5/mixed later.
8. Association count is variable.
9. Tableau column count is variable.
10. Tableau column sizes are variable.
11. Each column starts with exactly one face-up Card.
12. Stock size is variable.
13. Association Slot count is variable.
14. Slots may be fewer than Associations.
15. Move Limit is fixed per Level.
16. Restart keeps Move Limit and content.
17. Restart creates a new full shuffle.
18. First attempt is randomized.
19. All Association and Member Cards are shuffled together.
20. Association Slots start empty.
21. Initial face-up card may be any card type.
22. Solver validates solvability.
23. Solver validates within Move Limit.
24. Solver supports Hint and Dead-End Detection.
25. Semantic ambiguity is advanced-only.
26. A Level may mix content types.
27. Each Association remains homogeneous.
28. Completion occurs only in Association Slot.
29. Win requires all cards cleared.
30. Daily Challenge is included at launch.
31. Release simulation uses 10,000+ boards for critical Templates/Configs.

---

# 131. Proposed Level Design Decisions Requiring Approval

The following remain **PROPOSED** or intentional **TBD**:

1. Board Difficulty scale B1–B5.
2. Semantic Difficulty scale S1–S5.
3. Slot Pressure metric/bands.
4. Stock Ratio metric/bands.
5. Move Slack metric/bands (exact values intentional TBD).
6. Association count bands.
7. Tableau column bands.
8. Level Archetypes.
9. Template-based Level authoring.
10. Structural template count.
11. Completion-distribution metrics.
12. Cached/pre-generated boards.
13. Admin Preview Mode.
14. Level publishing workflow.
15. Exact generation fallback behavior (intentional TBD).
16. Content persistence when re-entering an incomplete Level (intentional TBD).

---

# 132. Recommended Next Deliverables

After aligning this Level Design Framework with Final Decision Register v1.1, create/update:

1. **Difficulty Model**
2. **Solver Specification**
3. **Gameplay Interaction Specification**
4. **Level Configuration Schema**
5. **Content Production Plan**
6. **Tutorial Level Specification**
7. **Daily Challenge Specification**
8. **Level QA & Simulation Plan**
9. **Data Model**
10. **CMS Specification**

The **Difficulty Model** converts Board/Semantic difficulty from qualitative labels into measurable generation and progression constraints.

---

# 133. Baseline Status

This document is **Level Design Framework v1.0** (Decision-Aligned to Final Decision Register v1.1).

It defines how Level Definitions and randomized Attempts should work across Main Journey and launch Daily Challenge.

All register-approved rules are preserved as **CONFIRMED**. Deferred Post-MVP items (Events/Packs) are marked accordingly. Intentional TBD items remain open. Cloud notes defer to Firebase-first Backend & Cloud Architecture (Azure MVP topology **SUPERSEDED**).

**End of Level Design Framework v1.0**
