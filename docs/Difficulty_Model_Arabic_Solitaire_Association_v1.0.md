# Difficulty Model
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source:** Approved GDD + Full Product Scope + MVP Scope + Progression Design + Content Design System + Level Design Framework + Final Decision Register v1.1  
**Rule:** Register-approved items are **APPROVED/CONFIRMED**. Exact difficulty formula weights/bands remain intentional **TBD**. Other new scales and formulas stay **PROPOSED** until calibrated. Cloud/runtime baseline is Firebase-first (Flutter client + Pure Dart Solver hybrid); Azure MVP stack is **SUPERSEDED** (Register §13A).

---

# 1. Purpose

This document converts the approved difficulty philosophy into a measurable system that can be used by Game Design, Content, Solver, Level Generation, Analytics, QA, and LiveOps.

The model must support:

- Board Difficulty.
- Semantic Difficulty.
- Randomized board validation.
- Fixed Move Limits.
- Difficulty Waves.
- Restart consistency.
- Solver-based acceptance/rejection.
- Human semantic review.
- Live calibration from player behavior.

---

# 2. Core Difficulty Model

**CONFIRMED:** Difficulty has two independent axes:

1. **Board Difficulty**
2. **Semantic Difficulty**

A level may therefore be:

- Easy Board / Easy Semantic.
- Hard Board / Easy Semantic.
- Easy Board / Hard Semantic.
- Hard Board / Hard Semantic.

The two axes must remain separately measurable even if an overall internal score is later derived.

---

# 3. Level Target vs Attempt Difficulty

A **Level** stores the intended difficulty profile.

An **Attempt** is one randomized board generated for that Level.

Because Restart produces a new shuffle, each Attempt receives an actual Board Difficulty score.

The Level Generator accepts only Attempts that:

- Are solvable.
- Fit within the fixed Move Limit.
- Remain inside the Level’s intended Board Difficulty band.
- Use the Level’s approved Semantic content.

This ensures randomized boards feel different without making one Restart dramatically easier or harder than another.

---

# 4. Proposed Internal Difficulty Bands

**PROPOSED**

## Board Difficulty
- B1 — Very Easy
- B2 — Easy
- B3 — Medium
- B4 — Hard
- B5 — Peak

## Semantic Difficulty
- S1 — Very Easy
- S2 — Easy
- S3 — Medium
- S4 — Hard
- S5 — Expert

These are internal labels, not player-facing ratings.

---

# 5. Proposed Normalized Scores

**PROPOSED**

Each axis may additionally use an internal normalized score from `0.00` to `1.00`.

Suggested mapping:

| Band | Score |
|---|---|
| 1 | 0.00–0.19 |
| 2 | 0.20–0.39 |
| 3 | 0.40–0.59 |
| 4 | 0.60–0.79 |
| 5 | 0.80–1.00 |

The band boundaries must be calibrated through Solver simulation and playtesting.

---

# 6. Board Difficulty Inputs

Board Difficulty should consider at least:

1. Move Slack.
2. Association Slot Pressure.
3. Tableau Depth.
4. Tableau Asymmetry.
5. Hidden Card Pressure.
6. Association Card Accessibility.
7. Stock Pressure.
8. Required Stock Advances.
9. Required Restores.
10. Association Count.
11. Group Size Profile.
12. Initial Mobility.
13. Branching Complexity.
14. Safe vs Unsafe Choices.
15. Dead-End Potential.
16. Forced Sequence Pressure.
17. Empty Column Availability.
18. Critical Card Accessibility.
19. Association Completion Timing.
20. Solver Search Complexity.

---

# 7. Reference Moves

The Solver should calculate:

- **Minimum Moves**, when exact optimization is feasible.
- Otherwise **Best Known / Reference Moves**.

The Level/Attempt data must indicate which value is being used.

Reference Moves are fundamental for Move-Limit validation and Board Difficulty.

---

# 8. Move Slack

**PROPOSED**

Define:

`Move Slack = Move Limit - Reference Moves`

and:

`Move Slack Ratio = Move Slack / max(Reference Moves, 1)`

Interpretation:

- Larger slack → more forgiving.
- Smaller slack → harder.
- Negative slack → reject board.

---

# 9. Proposed Move Slack Bands

**PROPOSED — calibration values only; exact bands intentional TBD**

| Slack Ratio | Interpretation |
|---|---|
| >35% | Very forgiving |
| 25–35% | Easy |
| 15–25% | Medium |
| 8–15% | Hard |
| <8% | Peak |

These values are not final (intentional TBD).

---

# 10. Fixed Move Limit

**CONFIRMED**

Move Limit is fixed for a given Level.

Restarting does not change it.

Therefore the Generator must reject random boards that require more Moves or fall outside the designed difficulty band.

The visible Move Limit must not dynamically change per Attempt.

---

# 11. Slot Pressure

**PROPOSED**

Raw metric:

`Slot Pressure = Association Count - Association Slot Count`

Normalized metric:

`Slot Pressure Ratio = 1 - (Association Slots / Association Count)`

Example:

5 Associations / 3 Slots:

`Slot Pressure = 2`

Higher Slot Pressure generally increases planning requirements.

---

# 12. Slot Pressure Interaction

Slot Pressure becomes significantly harder when combined with:

- Buried Association Cards.
- Large groups.
- Tight Move Limit.
- Delayed completion.
- High semantic ambiguity.

Therefore it should not be scored in isolation.

---

# 13. Tableau Depth

Potential metrics:

- Average hidden depth.
- Maximum hidden depth.
- Median depth.
- Hidden cards per column.

**PROPOSED**

`Average Hidden Depth = Hidden Tableau Cards / Tableau Columns`

Higher depth generally increases access complexity.

---

# 14. Tableau Asymmetry

Highly uneven columns may increase strategic planning.

Possible metrics:

- Maximum depth minus minimum depth.
- Standard deviation of column sizes.

Asymmetry is a secondary metric, not automatically difficulty.

---

# 15. Hidden Card Pressure

Track how many strategically important Cards are initially hidden.

Examples of important Cards:

- Association Cards.
- Members needed to free a Slot.
- Cards blocking several hidden Cards.
- Members necessary for a critical Stack.

---

# 16. Association Card Accessibility

Because Association Cards are shuffled like normal Cards, measure:

- Initially visible Association Cards.
- Association Cards in Stock.
- Average hidden depth.
- Number blocked behind dependencies.

Association accessibility strongly affects board flow.

---

# 17. Stock Pressure

Potential inputs:

- Stock size.
- Stock ratio.
- Required advances.
- Required full cycles.
- Required Restores.
- Position of critical Cards.

A large Stock is not automatically hard; Solver behavior matters more than raw size.

---

# 18. Stock Ratio

**PROPOSED**

`Stock Ratio = Stock Cards / Total Cards`

Track alongside:

- Required Stock Moves.
- Tableau accessibility.
- Restore requirement.

---

# 19. Required Restores

The Solver should report the minimum required number of Restore Stock actions on a reference solution path.

High required Restore counts increase Move pressure.

However, excessive Restore dependency should also be treated as a quality warning because repetition is not desirable difficulty.

---

# 20. Association Count

**CONFIRMED:** Association count varies.

Higher Association count may increase:

- Total cards.
- Board congestion.
- Semantic alternatives.
- Slot pressure.

It should be interpreted relative to group sizes, Slots, and Tableau layout.

---

# 21. Group Size Pressure

**CONFIRMED:** 3-member groups are introduced first, 4 becomes standard, then 5 and mixed sizes later.

Larger groups generally increase:

- Cards to manage.
- Time to completion.
- Stack size.
- Semantic candidate set.

Mixed sizes may add additional cognitive complexity.

---

# 22. Initial Mobility

**PROPOSED**

Track:

`Initial Valid Move Count`

Very low mobility may imply a forced opening.

Very high mobility may create greater branching and decision complexity.

---

# 23. Branching Factor

**PROPOSED**

Measure average meaningful valid choices across relevant Solver states.

Branching alone is not equivalent to difficulty.

It must be interpreted with how many branches remain solvable.

---

# 24. Safe Branch Ratio

**PROPOSED**

`Safe Branch Ratio = Solvable Child States / Valid Child States`

Low Safe Branch Ratio means many valid-looking moves are strategically dangerous.

This can be a major difficulty driver.

---

# 25. Dead-End Pressure

**PROPOSED**

Measure:

- Number of valid moves that eventually lead to Dead Ends.
- Depth before Dead End becomes detectable.
- Percentage of states with only one safe move.
- Number of recoverable vs unrecoverable Dead Ends.

A board can be solvable yet strategically dangerous.

---

# 26. Forced Sequence Pressure

**PROPOSED**

A Forced State has only one safe continuation.

Track:

- Number of Forced States.
- Longest forced sequence.
- Percentage of reference path that is forced.

Too many forced states can make the puzzle mechanical rather than strategic.

---

# 27. Empty Column Availability

Empty Tableau columns accept any movable unit and therefore create flexibility.

Track:

- Number initially empty, if any.
- Earliest Move an empty column becomes available.
- Whether the reference solution depends on empty-column use.

Earlier availability generally lowers Board Difficulty.

---

# 28. Critical Cards

**PROPOSED**

A Critical Card is a card whose accessibility strongly controls progress.

Examples:

- Association Card required to activate a needed group.
- Last Member needed to free a Slot.
- Card blocking multiple hidden Cards.

Potential metrics:

- Critical Card count.
- Average depth.
- Stock/Tableau distribution.
- Dependency fan-out.

---

# 29. Association Completion Timing

Track:

- Moves to first Association completion.
- Moves between Association completions.
- Number of groups completed near the very end.

Long delays to first progress may increase perceived difficulty and frustration.

---

# 30. Completion Distribution

**PROPOSED**

Use completion timing as both:

- Difficulty metric.
- Quality metric.

A technically valid board that withholds nearly all progress until the end may be rejected if it consistently feels poor in playtests.

---

# 31. Solver Search Complexity

Track:

- States explored.
- Search depth.
- Backtracking.
- Solve duration.

These are useful diagnostics but must not dominate player difficulty because they depend on Solver implementation and hardware.

---

# 32. Proposed Board Difficulty Formula

**PROPOSED — weights are intentional TBD placeholders**

`Board Score =`

- 25% Move Slack Pressure
- 15% Dead-End Pressure
- 10% Slot Pressure
- 10% Hidden/Critical Card Pressure
- 10% Stock/Restore Pressure
- 10% Tableau Depth
- 5% Association/Group Complexity
- 5% Branching Complexity
- 5% Empty Column Scarcity
- 5% Completion Delay

Total: 100%

Exact weights must be calibrated, not frozen now (intentional TBD).

---

# 33. Semantic Difficulty Inputs

Semantic Difficulty should consider:

1. Clue Directness.
2. Member Familiarity.
3. Relation Complexity.
4. Ambiguity.
5. Knowledge Requirement.
6. Linguistic Complexity.
7. Wordplay.
8. Cross-Association Similarity.
9. Regional Comprehensibility.
10. Hardest Member / Association outlier.

---

# 34. Clue Directness

**PROPOSED**

Suggested internal scale:

- C1 — Explicit.
- C2 — Clear.
- C3 — Contextual.
- C4 — Indirect.
- C5 — Highly interpretive.

Examples:

- `فواكه` → highly direct.
- `مطار` → contextual.
- `أجنحة` → indirect/shared property.
- `مصر` → potentially broad.
- `ض` → pattern-based.

---

# 35. Member Familiarity

The Content Design System proposed:

- M1 — Very Common.
- M2 — Common.
- M3 — Moderate.
- M4 — Uncommon.
- M5 — Rare/Specialist.

For each Association track:

- Average Member familiarity.
- Hardest Member.
- Percentage of M4/M5 Members.

---

# 36. Rare Member Outlier

A single obscure word can dominate perceived difficulty.

Therefore the Semantic Model must consider maximum Member difficulty, not just average difficulty.

---

# 37. Relation Complexity

The Content Design System proposed:

- R1 — Direct Category.
- R2 — Contextual.
- R3 — Shared Property.
- R4 — Indirect Semantic.
- R5 — Linguistic.
- R6 — Wordplay.
- R7 — Ambiguous/Advanced.

This taxonomy is **PROPOSED** until approved.

---

# 38. Knowledge Requirement

**PROPOSED**

Suggested scale:

- K1 — Everyday knowledge.
- K2 — General knowledge.
- K3 — Moderate cultural/academic knowledge.
- K4 — Advanced general knowledge.
- K5 — Specialist knowledge.

Main Journey should use K5 sparingly.

---

# 39. Ambiguity

**CONFIRMED:** Intentional ambiguity belongs to advanced progression.

**PROPOSED scale:**

- A0 — None.
- A1 — Mild.
- A2 — Noticeable.
- A3 — Strong but fair.
- A4 — Expert-level controlled ambiguity.

Early Main Journey should remain A0.

---

# 40. Cross-Association Similarity

A level becomes semantically harder when multiple Associations occupy nearby semantic space.

Examples:

- `طيور` and `أجنحة`
- `مطبخ` and `طعام`

This should be explicitly reviewed and, where possible, measured.

---

# 41. Regional Comprehensibility

**PROPOSED**

- U1 — Universal Arabic.
- U2 — Widely understood.
- U3 — Some regional variation.
- U4 — Strongly regional.
- U5 — Dialect-specific.

Main Journey should primarily use U1/U2.

---

# 42. Linguistic Complexity

Arabic-specific difficulty may come from:

- Roots.
- Prefixes/suffixes.
- Letter patterns.
- Word families.
- Diacritic distinction.
- Phrase relationships.
- Morphological reasoning.

These should be separately tagged.

---

# 43. Wordplay Complexity

**PROPOSED**

- W0 — None.
- W1 — Simple.
- W2 — Moderate.
- W3 — Advanced.

Wordplay should be introduced after direct semantic relations are well understood.

---

# 44. Visual Content Difficulty

**CONFIRMED**

Illustration/Icon cards must be clear.

Difficulty should come from the Association, not from poor visual recognition.

Therefore visual-recognition difficulty should normally be low and treated as a quality constraint.

---

# 45. Proposed Semantic Difficulty Formula

**PROPOSED — weights are intentional TBD placeholders**

`Semantic Score =`

- 25% Clue Directness
- 20% Member Familiarity
- 15% Relation Complexity
- 15% Ambiguity
- 10% Knowledge Requirement
- 5% Linguistic Complexity
- 5% Cross-Association Similarity
- 5% Regional Comprehensibility Risk

Total: 100%

Exact weights remain intentional TBD.

---

# 46. Hardest Association Effect

A Level with three easy Associations and one extremely difficult Association should not be classified merely by the average.

The model should preserve:

- Average Association score.
- Maximum Association score.
- Distribution.

---

# 47. Proposed Level Semantic Aggregation

**PROPOSED**

Possible formula:

`Level Semantic Score = 0.65 × Average Association Score + 0.35 × Hardest Association Score`

This is a starting hypothesis only.

---

# 48. Combined Difficulty Profile

Primary Level difficulty should be stored as two labels:

Example:

`B4 / S2`

or:

`B2 / S4`

Do not replace this with a single overall rating.

---

# 49. Optional Overall Score

If internal systems later require one score, it may be derived separately.

**PROPOSED**

Possible concept:

`Overall Score = Board + Semantic + small interaction term`

No final formula is approved.

---

# 50. Interaction Effect

Hard Board + Hard Semantic can create more cognitive load than simple addition suggests.

**PROPOSED**

A small interaction factor may be added to an overall internal score.

The B/S source scores must still remain separate.

---

# 51. Difficulty Profiles

**PROPOSED**

Useful internal authoring profiles:

- Relaxed → low B / low S.
- Strategic → high B / low S.
- Semantic → low B / high S.
- Balanced → medium B / medium S.
- Challenge → high B / high S.
- Peak → very high one or both axes.

These profiles help designers create variety.

---

# 52. Difficulty Waves

**CONFIRMED**

The Main Journey uses waves rather than monotonic difficulty.

**CONFIRMED** structure: 10-Level Wave × 5 per Chapter.

A wave should combine:

- Growth.
- Challenge.
- Relief.
- New peak.

---

# 53. 10-Level Wave Example

**CONFIRMED** wave length; illustrative B/S pairing within the wave:

1. B1/S1
2. B2/S1
3. B2/S2
4. B3/S2
5. B3/S3
6. B1/S2 — Relief
7. B3/S2
8. B4/S2
9. B3/S4
10. B4/S4 — Peak

Exact Easy/Hard band assignments within the wave remain design guidance pending calibration.

---

# 54. Relief Levels

Relief can lower either axis.

Examples:

- Easier Board after strategic peak.
- Easier semantics after linguistic peak.
- Both easier after major Chapter peak.

Relief levels should still be engaging.

---

# 55. Peak Levels

Peak does not always mean B5/S5.

Possible peaks:

- B5/S2.
- B3/S5.
- B4/S4.

This reduces fatigue and keeps Endless progression varied.

---

# 56. Tutorial Difficulty

Tutorial should prioritize learning, not difficulty scoring.

Tutorial boards may be:

- Fixed.
- Constrained.
- Guided.

They may fall outside normal Main Journey randomization rules.

---

# 57. Early Progression

**PROPOSED**

Broad target:

- B1–B2.
- S1–S2.
- No intentional ambiguity.
- Generous Move Slack.
- Small groups.
- Low Slot Pressure.

---

# 58. Mid Progression

**PROPOSED**

Broad target:

- B2–B4.
- S2–S3.
- More slot/Stock pressure.
- Mostly 4-member groups.
- Mild ambiguity late in the band.

---

# 59. Advanced Progression

**PROPOSED**

Broad target:

- B2–B5.
- S2–S5.
- 5-member and mixed groups.
- Stronger semantic relations.
- Controlled ambiguity.
- Tighter but fair Move Limits.

---

# 60. Attempt Acceptance

**PROPOSED**

A generated Attempt may be accepted when:

- `solvable = true`
- `reference_moves <= move_limit`
- Board Score is within configured min/max.
- Semantic Score is within configured min/max.
- Content validation passes.
- Quality warnings remain within allowed limits.
- Solver finishes within technical limits.

---

# 61. Hard Reject Conditions

Always reject:

- Unsolvable board.
- Solution exceeds Move Limit.
- Invalid card/state distribution.
- Broken content membership.
- Technical corruption.
- Solver timeout beyond allowed fallback policy.

---

# 62. Soft Reject Conditions

**PROPOSED**

May reject even if solvable when:

- Too easy for Level target.
- Too hard for Level target.
- Excessive required Restores.
- Extreme Dead-End branch pressure.
- Excessive completion delay.
- Extreme forced sequence.
- Unacceptable difficulty variance.

---

# 63. Difficulty Acceptance Window

**PROPOSED**

Each Level may define:

- Target Board Score.
- Min Board Score.
- Max Board Score.
- Target Semantic Score.
- Min Semantic Score.
- Max Semantic Score.

Semantic score should normally remain nearly fixed across Restarts because Level content remains the same.

---

# 64. Restart Consistency

**CONFIRMED**

Restart:

- Same Level.
- Same content.
- Same Move Limit.
- New shuffle.

Therefore only Board Difficulty should meaningfully vary.

The acceptance window must keep Restart difficulty consistent.

---

# 65. Difficulty Variance

Track across generated Attempts:

- Mean Board Score.
- Min/max.
- Standard deviation.
- Reference Move distribution.

High variance means the Level identity is unstable.

Exact accepted variance threshold is **PROPOSED/TBD**.

---

# 66. Human Margin

Move Limit should not force mathematically perfect play.

**PROPOSED**

Concept:

`Move Limit = Reference Move distribution + intended Human Margin`

Harder levels use less margin.

Exact formula requires simulation and playtesting.

---

# 67. Quality vs Difficulty

A hard board is not automatically a good board.

Separate quality concerns include:

- Excessive repetition.
- Too many Stock Restores.
- No progress for too long.
- Unfair semantic ambiguity.
- Poor visual clarity.

Difficulty and quality should be separately monitored.

---

# 68. Proposed Quality Score

**PROPOSED**

A separate Quality Score may consider:

- Fairness.
- Completion pacing.
- Solver confidence.
- Restore repetition.
- Semantic confidence.
- Content conflicts.

This score should not replace B/S Difficulty.

---

# 69. Human Playtesting

Automated Solver metrics are necessary but insufficient.

Human testers should rate:

- Perceived Board Difficulty.
- Perceived Semantic Difficulty.
- Fairness.
- Frustration.
- Enjoyment.

Predicted vs perceived difficulty should be compared.

---

# 70. Live Calibration

After launch, use real player behavior.

Board calibration signals:

- Completion rate.
- Restarts.
- Dead-End rate.
- Moves used.
- Extra Moves usage.

Semantic calibration signals:

- Hint usage.
- Wrong association attempts.
- Time to correct grouping.
- Content complaints.

---

# 71. Difficulty Misclassification

Trigger review when:

- B2 level performs like B4.
- S2 content needs many Hints.
- Restart difficulty varies widely.
- Relief level is harder than surrounding peak.
- One Association acts as an extreme outlier.

---

# 72. Difficulty and Economy

Difficulty influences:

- Remaining-Move Coins.
- Hint spending.
- Extra Moves.
- Rescue usage.

The game must never intentionally create unfair difficulty to increase monetization.

Difficulty tuning and Economy tuning must be reviewed together.

---

# 73. Difficulty and Hints

High Hint usage is not automatically desirable.

It may indicate:

- Poor clue wording.
- Semantic unfairness.
- Tutorial gap.
- Excessive ambiguity.

Hints are a diagnostic as well as an economy sink.

---

# 74. Difficulty and Rescue

High Rescue usage may indicate:

- Move Limit too tight.
- Dead-End pressure too high.
- Board acceptance range too broad.

Treat Rescue spikes as a design signal, not only monetization success.

---

# 75. Adaptive Difficulty

No player-specific adaptive difficulty system is currently approved.

The current model uses:

- Fixed Level target.
- Fixed Move Limit.
- Random validated Attempts.

Any future dynamic personalization requires a separate decision.

---

# 76. Daily Challenge Difficulty

**CONFIRMED at launch**

Daily Challenge should use:

- Shared/deterministic board per challenge cohort.
- Fixed Move Limit.
- Fixed semantic content.

This allows fair performance comparison.

---

# 77. Event and Pack Difficulty

Events/Packs should reuse the same Board/Semantic framework where possible.

Example:

Dialect Pack:

`B2 / S4`

This makes specialized semantic challenge possible without requiring extremely hard board structure.

---

# 78. Recommended Level Difficulty Data

Suggested Level fields:

- `board_target_score`
- `board_min_score`
- `board_max_score`
- `semantic_target_score`
- `semantic_min_score`
- `semantic_max_score`
- `board_band`
- `semantic_band`
- `move_limit`
- `move_slack_target`
- `slot_pressure_target`
- `ambiguity_level`
- `difficulty_model_version`

Exact schema remains TBD.

---

# 79. Recommended Attempt Metrics

Suggested Attempt metrics:

- `reference_moves`
- `move_slack`
- `move_slack_ratio`
- `board_score`
- `semantic_score`
- `slot_pressure`
- `stock_ratio`
- `required_stock_advances`
- `required_restores`
- `initial_valid_moves`
- `safe_branch_ratio`
- `dead_end_branch_count`
- `forced_state_ratio`
- `moves_to_first_completion`
- `solver_states_explored`
- `solver_duration_ms`

---

# 80. Recommended Content Difficulty Metadata

Suggested Association metadata:

- `clue_directness`
- `member_familiarity_average`
- `member_familiarity_max`
- `relation_complexity`
- `knowledge_level`
- `ambiguity_score`
- `linguistic_complexity`
- `regional_comprehensibility`
- `semantic_score`

---

# 81. Difficulty Analytics

Track:

- Attempt accepted/rejected.
- Difficulty rejection reason.
- Predicted B/S.
- Completion.
- Restarts.
- Moves used.
- Remaining Moves.
- Hints.
- Dead Ends.
- Rescue.
- Wrong semantic attempts.

---

# 82. Difficulty Dashboard

Recommended internal views:

## Board Dashboard
- Board Score by Level.
- Completion by B band.
- Move Slack distribution.
- Dead-End rate.
- Restore count.
- Restart rate.

## Semantic Dashboard
- Semantic Score.
- Hint usage by S band.
- Wrong association attempts.
- Content complaint rate.

## Combined Dashboard
- B × S heatmap.

---

# 83. B × S Heatmap

**PROPOSED**

Maintain a matrix of Board/Semantic combinations.

For each cell track:

- Completion rate.
- Session exit rate.
- Hint usage.
- Rescue usage.
- Player retention.

This reveals whether specific combinations are disproportionately frustrating.

---

# 84. Simulation

Every Level Template should be simulated at scale.

Measure:

- Acceptance rate.
- Reference Move distribution.
- Board Score distribution.
- Difficulty variance.
- Required Restores.
- Dead-End pressure.
- Solver runtime.

---

# 85. Simulation Volume

**CONFIRMED**

- Development tuning: ~1,000 boards/template (operational guidance).
- Pre-release high-confidence validation: **10,000+ boards for critical Templates/Configs**.
- Smaller volumes allowed for simpler configurations.

---

# 86. Difficulty Versioning

The Difficulty Model must be versioned.

Example:

`difficulty_model_version = 1`

If weights or formulas change:

- Existing analytics keep the old version.
- New Attempts record the new version.

Do not silently reinterpret historical data.

---

# 87. Solver Versioning

Store Solver version with Attempt analytics.

Solver improvements can change:

- Reference Moves.
- Search complexity.
- Difficulty estimates.

Versioning protects comparability.

---

# 88. Calibration Process

Recommended cycle:

1. Create qualitative target.
2. Generate/simulate Attempts.
3. Calculate metrics.
4. Human playtest.
5. Compare predicted vs perceived difficulty.
6. Adjust weights/thresholds.
7. Publish.
8. Observe live behavior.
9. Recalibrate.
10. Version the model.

---

# 89. Difficulty QA Checklist

Before a Level is production-ready:

- [ ] Board target defined
- [ ] Semantic target defined
- [ ] Fixed Move Limit defined
- [ ] Solver solvability passed
- [ ] Move-Limit validation passed
- [ ] Board distribution within target
- [ ] Restores acceptable
- [ ] Dead-End pressure acceptable
- [ ] Completion pacing acceptable
- [ ] Semantic review passed
- [ ] Ambiguity review passed
- [ ] Human playtest matches target
- [ ] Analytics metadata configured

---

# 90. Difficulty Fairness Principle

A successful hard level should make the player think:

> “كان ممكن ألعبها أحسن.”

not:

> “اللعبة حشرتني عشوائيًا.”

Randomness may change the path.

It must not remove fairness.

---

# 91. Difficulty vs Obscurity

Do not equate:

`Rare vocabulary = good difficulty`

Advanced challenge should preferably come from:

- Inference.
- Relation complexity.
- Board planning.
- Controlled ambiguity.

rather than merely obscure words.

---

# 92. Difficulty vs Frustration

Frustration may come from:

- Excessive Stock cycling.
- Slow board generation.
- Bad clue wording.
- Too much repetition.
- Poor UI.
- Unfair ambiguity.

These should not be mislabeled as difficulty.

---

# 93. Confirmed Difficulty Decisions

The following are **CONFIRMED**:

1. Board and Semantic Difficulty are separate axes.
2. Difficulty uses waves: 10-Level Wave × 5 per Chapter.
3. Board/Semantic combinations may vary.
4. Move Limit is fixed per Level.
5. Solver validates solvability.
6. Solver validates within Move Limit.
7. Generated boards outside intended difficulty should be rejected.
8. Restart creates a new shuffle but keeps Level content/Move Limit.
9. Group sizes progress from 3 to 4 standard, then 5/mixed.
10. Association count varies.
11. Tableau structure varies.
12. Stock size varies.
13. Association Slot count varies.
14. Slots may be fewer than Associations.
15. Semantic ambiguity is advanced-only.
16. Advanced relation types are supported.
17. Main Journey remains fair and Arabic-first.
18. Launch content = 250 Level Definitions (5 × 50).
19. Release simulation = 10,000+ boards for critical Templates/Configs.
20. Daily Challenge is included at launch.

---

# 94. Proposed Decisions Requiring Approval

The following remain **PROPOSED** or intentional **TBD**:

1. B1–B5 Board scale.
2. S1–S5 Semantic scale.
3. 0–1 normalized scoring.
4. Exact score bands (intentional TBD).
5. Move Slack bands (intentional TBD).
6. Slot Pressure formula.
7. Safe Branch Ratio.
8. Dead-End Pressure model.
9. Completion Delay metric.
10. Board-score weights (intentional TBD).
11. Clue Directness C1–C5.
12. Knowledge K1–K5.
13. Ambiguity A0–A4.
14. Regional U1–U5.
15. Wordplay W0–W3.
16. Semantic-score weights (intentional TBD).
17. Semantic aggregation formula.
18. Overall/interaction score.
19. Named Difficulty Profiles.
20. Illustrative Easy/Hard pairing within the confirmed 10-Level wave.
21. Early/Mid/Advanced B/S bands.
22. Quality Score.
23. Difficulty variance thresholds.

---

# 95. Recommended Approval Order

Before implementation freezes the production validator:

1. Approve B/S scales.
2. Approve Board Difficulty components.
3. Approve Semantic Difficulty components.
4. Approve Move Slack concept.
5. Approve Level acceptance-window concept.
6. Implement Solver metrics.
7. Run simulations (10,000+ for critical Templates/Configs).
8. Human playtest.
9. Tune weights.
10. Approve production thresholds.

Exact weights should not be frozen before simulation data exists (intentional TBD).

---

# 96. Recommended MVP Baseline

The MVP can proceed safely with:

- Two-axis Board/Semantic model.
- Qualitative B1–B5 / S1–S5 labels.
- Fixed Move Limit.
- Solver solvability validation.
- Solver Move-Limit validation.
- Reference Moves.
- Move Slack tracking.
- Slot Pressure tracking.
- Stock/Restore metrics.
- Dead-End branch metrics.
- Human Semantic Difficulty ratings.
- Confirmed 10-Level Wave × 5 per Chapter targets.
- Broad Attempt acceptance ranges.
- Daily Challenge at launch.

Weighted formulas can then be calibrated before release (weights intentional TBD).

---

# 97. Dependencies

This document directly feeds:

1. **Solver Specification**
2. **Level Configuration Schema**
3. **Analytics & KPI Specification**
4. **QA & Automated Validation Strategy**
5. **Game Economy balancing**
6. **Progression tuning**
7. **CMS Level Authoring**

The highest-priority next technical document is the **Solver Specification**, because the Solver must expose many of the metrics defined here.

---

# 98. Baseline Status

This document is **Difficulty Model v1.0** (Decision-Aligned to Final Decision Register v1.1).

It defines how Board and Semantic Difficulty should be measured, validated, calibrated, and monitored while preserving approved game rules.

Register-approved wave/launch/simulation decisions are **CONFIRMED**. Exact difficulty formula weights and bands remain intentional **TBD**. Runtime/cloud baseline is Firebase-first (Flutter + Pure Dart hybrid Solver); Azure is **SUPERSEDED** for MVP.

**End of Difficulty Model v1.0**
