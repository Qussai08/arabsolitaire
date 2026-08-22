# Sprint 3 — Level Generator & Difficulty Validation v1
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Procedural Generation / Solver Validation / Difficulty Calibration  
**Depends On:** Sprint 2 — Solver Core v1  
**Primary Package:** `packages/level_generator`  
**Consumes:** `packages/game_engine`, `packages/game_solver`  
**Future Consumers:** Flutter gameplay application, CMS/Admin tooling, QA simulation tooling, CI release validation  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 3 Objective

Implement the first production-capable Level Generator and Board Difficulty validation pipeline for **سوليتير العرب: أسطورة المعاني**.

The Generator must:

- consume approved Level Configuration;
- consume pre-approved Association content;
- construct a complete card pool;
- randomize cards across Tableau + Stock;
- enforce initial-deal invariants;
- produce deterministic results when a seed is supplied;
- validate generated boards through the Solver;
- accept only boards solvable within the fixed visible Move Limit;
- collect Board Difficulty metrics;
- reject boards outside the target difficulty range;
- retry safely under bounded generation budgets;
- expose generation diagnostics;
- support batch simulation for QA and balancing;
- remain independent from Flutter UI and Firebase.

The Generator must not change gameplay rules.

---

# 2. Sprint 3 Success Criteria

Sprint 3 is complete only when:

1. `level_generator` remains pure Dart.
2. Generator depends only on approved lower-level pure Dart packages.
3. A typed `LevelConfiguration` model exists.
4. Card-pool construction is deterministic for a supplied seed.
5. Tableau and Stock deal invariants are always satisfied.
6. Association Slots start empty.
7. All Association and Member Cards are distributed exactly once.
8. No card duplication or loss occurs.
9. Generated boards are Solver-validated before acceptance.
10. Accepted boards are solvable within the fixed Move Limit.
11. Accepted boards satisfy target Board Difficulty constraints.
12. Retry/fallback behavior is bounded.
13. Generation can return `Inconclusive`/failure cleanly instead of looping forever.
14. Generation metrics are exposed.
15. Reproducible board seed/support exists for QA.
16. Batch simulation CLI/tool exists.
17. Golden generator configurations exist.
18. Generator output replays/solves through Game Engine + Solver.
19. No semantic Arabic inference is done inside the Generator.
20. Generator is ready to feed Sprint 4 playable vertical slice.

---

# 3. Non-Goals

Do NOT implement in Sprint 3:

- Flutter gameplay UI;
- drag/drop;
- animations;
- final Chapter map;
- Daily Challenge backend scheduling;
- Firebase content publishing;
- AI content generation;
- CMS authoring UI;
- semantic quality review;
- economy;
- ads;
- IAP;
- story cutscenes;
- final 250 production Level Definitions;
- full difficulty tuning for launch;
- native optimization;
- cloud generation service.

---

# 4. Generator Core Principle

The Generator is a constrained board constructor.

Conceptually:

```text
LevelConfiguration
      +
Approved Content Input
      +
Seed
      ↓
Card Pool
      ↓
Randomized Deal
      ↓
Initial GameState
      ↓
Solver Validation
      ↓
Difficulty Validation
      ↓
Accepted Attempt
```

If validation fails:

```text
retry with next candidate
```

The Generator must never silently alter:

- gameplay rules;
- Move Limit;
- Association membership;
- Slot count;
- content semantics.

---

# 5. Level Definition vs Attempt

Separate:

## Level Definition

Stable product configuration.

Examples:

- Level number;
- Chapter;
- allowed group count;
- group sizes;
- Tableau column count;
- Stock target size;
- Association Slot count;
- Move Limit;
- Board Difficulty target;
- Semantic Difficulty metadata;
- content constraints.

## Attempt

One generated concrete board from that Level Definition.

An Attempt includes:

- exact card distribution;
- hidden/exposed Tableau state;
- exact Stock order;
- seed;
- generated board metadata;
- Solver validation metrics.

Restart creates a new Attempt from the same Level Definition.

---

# 6. LevelConfiguration Model

Recommended fields:

```text
levelDefinitionId
rulesVersion
generatorVersion
chapterId
levelNumber
associationCount
memberCountPerAssociation or groupSizeProfile
tableauColumnCount
tableauColumnSizes
stockCardCount
associationSlotCount
moveLimit
boardDifficultyTarget
semanticDifficultyTier
contentSelectionConstraints
maxGenerationAttempts
solverOptionsProfile
```

Not every field must be public if derivable.

Use typed validated construction.

---

# 7. Level Configuration Invariants

Validate before generation:

1. associationCount > 0.
2. Association Slot count > 0.
3. Slot count may be less than Association count.
4. Tableau column count > 0.
5. Move Limit > 0.
6. Total deal capacity equals total card count.
7. Every Association has exactly one Association Card.
8. Every Association has approved Member count.
9. Group sizes are supported by current rules.
10. No impossible distribution constraints.
11. Initial Tableau column sizes satisfy one-exposed-card rule.
12. Stock count matches total cards after Tableau allocation.

Invalid configuration:
- fail fast;
- do not enter retry loop.

---

# 8. Launch Group-Size Progression Support

Generator must support:

- groups of 3;
- groups of 4;
- groups of 5;
- mixed later-Level group profiles.

Do not hard-code a single group size.

Recommended model:

```text
groupSizeProfile = [3,3,3]
or
groupSizeProfile = [4,4,4,4]
or
groupSizeProfile = [3,4,5,...]
```

Each Association Definition must match its required Member count.

---

# 9. Content Input Contract

The Generator receives already approved content references.

Recommended input:

```text
AssociationVariant {
  associationId
  associationCardId
  memberCardIds
  contentType
  semanticMetadata
}
```

Generator uses stable IDs only.

It must not decide:
- whether Arabic wording is correct;
- whether clues are culturally appropriate;
- whether meanings are semantically valid.

That belongs to content pipeline/CMS/human review.

---

# 10. Content Selection Boundary

Sprint 3 may implement a simple content selection contract.

Example:

```dart
abstract interface class ContentSelector {
  List<AssociationVariant> select(...);
}
```

For v1:
- deterministic fixture selector;
- supplied fixed content list;
- seeded selection from eligible pool.

Do not implement AI selection.

---

# 11. Content Constraints

Support configuration constraints such as:

- required Association count;
- allowed content types;
- max visual Associations;
- no duplicate exact Variant within same Level;
- no identical display-card identity conflicts if represented in metadata;
- group size compatibility.

Cross-Level cooldown rules are not Generator-local unless historical context is supplied.

For launch rule:
- same Association Clue reuse cooldown ≥ 20 Levels;
- exact same Variant cannot repeat within same Chapter.

These require higher-level Journey/content planning context and may be enforced later by content pipeline or batch planner.

Do not fake history if unavailable.

---

# 12. Card Pool Construction

For selected Associations:

Create exactly:

```text
1 Association Card
+
N Member Cards
```

per Association.

Pool invariants:

- every card ID unique;
- each card has exactly one `associationId`;
- all required cards present;
- no extras;
- pool size matches configuration.

---

# 13. Randomness

Randomness belongs to Generator.

Use explicit seeded RNG.

Requirements:

- same input + same seed + same generator version → same candidate deal;
- no reliance on ambient system randomness for reproducible path;
- seed stored in generation metadata.

Example:

```text
GenerationSeed
```

May be integer/string-derived.

---

# 14. Seed Policy

Support:

## Explicit seed
For:
- QA;
- bug reproduction;
- Golden Generator tests;
- Daily Challenge future use.

## Generated seed
For:
- normal player Attempt;
- restart.

The app/application layer may supply a random seed source.

Generator itself should accept a seed rather than read device randomness implicitly where practical.

---

# 15. Deal Construction

Generation must distribute all cards across:

- Tableau;
- Stock.

Association Slots:
- always empty at start.

No cards start inside Slots.

---

# 16. Tableau Initial Deal

Approved:

- each Tableau column has exactly one face-up Card initially;
- cards beneath are face-down;
- column sizes vary by Level Configuration;
- initial face-up card can be Association or Member;
- no additional type restriction unless Level Configuration later adds one.

Recommended generation process:

1. determine card order for each column;
2. assign all but top/exposed as hidden;
3. top card becomes exposed single-card unit.

Do not pre-build stacks during initial deal.

---

# 17. Tableau Column Sizes

Column sizes are configuration-driven.

Could be:

```text
[4,5,5,6,6]
```

etc.

Validate:

```text
sum(columnSizes) + stockCardCount == totalCardCount
```

If dynamic column size generation is introduced:
- it must be bounded;
- deterministic under seed;
- validated before deal.

---

# 18. Stock Initial State

Remaining configured cards go to Stock.

Stock must preserve exact order.

Initial Stock visible/playable state must be produced via Game Engine-compatible Stock model.

Do not reproduce Stock UI logic independently if Engine already exposes helper constructors.

---

# 19. Initial GameState Construction

Generator output must build a valid GameState with:

- Attempt ID or candidate ID;
- Level Definition ID;
- rules version;
- Move Limit;
- `movesRemaining = moveLimit`;
- empty completed Association set;
- initial streak state;
- empty Association Slots;
- generated Tableau;
- generated Stock;
- status `inProgress`.

Engine invariant validation must pass before Solver call.

---

# 20. Attempt Candidate

Recommended internal model:

```text
GeneratedCandidate
├── seed
├── initialGameState
├── contentIds
├── generationAttemptIndex
└── preValidationMetadata
```

---

# 21. Solver Validation

Every candidate must be validated with Solver.

Accepted only if Solver returns:

```text
Solved
```

with:

```text
solutionLength <= moveLimit
```

If Solver returns:

```text
Unsolvable
```

reject candidate.

If Solver returns:

```text
Inconclusive
```

candidate is not accepted.

Depending on retry policy:
- retry candidate;
- optionally retry same candidate under a stronger Solver profile;
- or fail generation cleanly.

Do not accept Inconclusive as solvable.

---

# 22. Fixed Move Limit Rule

The Generator must not tune visible Move Limit per generated Attempt.

For a given Level Definition:

```text
moveLimit is fixed
```

Candidate either:
- fits;
- or is rejected.

Do not “solve in 31, therefore set Move Limit to 31”.

---

# 23. Solver Validation Profiles

Support typed profile/config.

Example:

```text
fastValidation
standardValidation
deepValidation
```

Exact time/node budgets remain tuning details.

Potential generation flow:

1. fast validation;
2. if inconclusive and candidate otherwise promising:
   - optional stronger validation;
3. otherwise reject/retry.

Do not make profile names product-visible.

---

# 24. Board Difficulty Model

Sprint 3 validates **Board Difficulty**, not Semantic Difficulty.

Semantic Difficulty comes from content metadata/review.

Board Difficulty should be derived from Solver/generation metrics.

Potential signals:

- solution length;
- solution length / Move Limit ratio;
- nodes expanded;
- branching factor;
- forced-move ratio;
- number of Stock Advances;
- number of Stock Restores;
- hidden-card reveal depth;
- number of neutral rearrangements;
- Association activation timing;
- number of available legal moves at key states;
- search depth;
- transposition density.

---

# 25. DifficultyScore

Create a normalized internal model.

Example:

```text
DifficultyMetrics
DifficultyScore
DifficultyBand
```

Avoid pretending v1 weights are scientifically final.

Recommended:

- raw metrics always retained;
- derived score configurable/versioned;
- bands initially broad.

---

# 26. Initial Difficulty Bands

Use broad engineering bands only, e.g.:

```text
veryEasy
easy
medium
hard
veryHard
```

Exact thresholds remain calibration/TBD.

Level Configuration should target:

```text
minScore
maxScore
```

or:

```text
DifficultyBand
```

Avoid hard-coding launch thresholds before simulation data.

---

# 27. Solution Length Metric

Important signal:

```text
solutionLength / moveLimit
```

Examples conceptually:

- low ratio may indicate spare Move capacity;
- near-1.0 ratio may indicate tight board.

Do not use this metric alone.

---

# 28. Search Effort Metric

Use Solver metrics such as:

- nodesExpanded;
- maxDepth;
- branchingFactor;
- transpositionHits.

High search effort may correlate with complexity.

But search implementation changes can shift these values.

Therefore:
- include `solverVersion`;
- include `difficultyModelVersion`.

---

# 29. Forced Move Ratio

Potential metric:

At each solution state, measure number of legal options.

A high percentage of states with only one productive path may indicate forced structure.

This metric may be added if cheap enough.

Do not block v1 if it materially complicates Solver.

---

# 30. Stock Dependency Metrics

Track:

- number of Stock Advance actions in solution;
- number of Restore actions;
- number of Cards played from Stock;
- deepest Stock cycle required.

Useful for Board Difficulty calibration.

---

# 31. Hidden Reveal Metrics

Track:

- number of hidden Cards;
- reveals required by solution;
- max reveal chain depth;
- how late key Association Cards appear.

If Engine/Solver does not expose some metrics yet:
- add non-invasive instrumentation;
- do not alter gameplay rules.

---

# 32. Neutral Rearrangement Metrics

Track number of:
- empty Tableau moves;
- non-progress neutral moves required by solved path.

This can help distinguish obvious from planning-heavy boards.

---

# 33. Difficulty Acceptance

A candidate is accepted only if:

1. Engine state valid.
2. Solver returns Solved.
3. solution length <= fixed Move Limit.
4. difficulty metrics fall within target.
5. content/config constraints satisfied.

If any condition fails:
- reject candidate.

---

# 34. Difficulty Validation Strategy

Recommended initial behavior:

```text
if score < target.min => tooEasy
if score > target.max => tooHard
else => accepted
```

For exact launch calibration, thresholds remain configurable.

---

# 35. Generation Retry Loop

Recommended:

```text
for attempt in 1..maxGenerationAttempts:
    generate candidate with derived seed
    validate engine invariants
    solve candidate
    compute difficulty
    if accepted:
        return GeneratedLevel
return GenerationFailure
```

Never unbounded-loop.

---

# 36. Derived Candidate Seeds

Given a base seed:

```text
candidateSeed = derive(baseSeed, attemptIndex)
```

This gives deterministic retry sequence.

Same:
- config;
- content;
- base seed;
- generator version

should reproduce same accepted candidate or same failure sequence.

---

# 37. Generation Failure Model

Recommended:

```dart
sealed class GenerationResult {}
```

Variants:

```text
Generated
Failed
Inconclusive
```

Possible failure reasons:

```text
invalidConfiguration
invalidContent
engineInvariantFailure
noCandidateWithinRetryBudget
solverInconclusiveBudget
difficultyTargetNotReached
unsupportedRulesVersion
cancelled
```

Do not throw for normal generation failure.

---

# 38. GeneratedLevel Output

Recommended:

```text
GeneratedLevel
├── levelDefinitionId
├── seed
├── initialGameState
├── selectedAssociationVariantIds
├── solutionLength
├── solutionActions? (optional/debug)
├── solverMetrics
├── difficultyMetrics
├── difficultyScore
├── generationAttempts
├── rulesVersion
├── solverVersion
├── generatorVersion
└── difficultyModelVersion
```

Do not persist full solution to production client unless needed.

For QA/debug, solution may be optionally included.

---

# 39. Generation Metrics

Expose:

- generation attempt count;
- candidates rejected as unsolvable;
- candidates rejected as too easy;
- candidates rejected as too hard;
- Solver inconclusive count;
- elapsed generation time;
- accepted candidate seed;
- Solver metrics;
- Difficulty metrics.

These are important for tuning.

---

# 40. Generator Version

Expose:

```text
generatorVersion
```

Any change that materially alters deal reproducibility should update it.

This is important for:

- QA reproduction;
- Daily Challenge later;
- analytics;
- content validation.

---

# 41. Difficulty Model Version

Expose:

```text
difficultyModelVersion
```

If scoring weights/thresholds change:
- metrics remain comparable only with version context.

---

# 42. Golden Generator Configurations

Create deterministic fixtures.

Minimum:

### GG-001 — Small Easy
- 3 Associations;
- group size 3;
- simple Tableau;
- comfortable Move Limit.

### GG-002 — Stock Heavy
- significant Stock dependence.

### GG-003 — Restore Required
- acceptance only when Restore path exists.

### GG-004 — Reveal Heavy
- several hidden cards required.

### GG-005 — Tight Move Limit
- solution near Move Limit.

### GG-006 — Too Easy Candidate
- rejected by lower difficulty bound.

### GG-007 — Too Hard Candidate
- rejected by upper difficulty bound.

### GG-008 — Unsolvable Candidate
- rejected.

### GG-009 — Solver Inconclusive
- generation handles cleanly.

### GG-010 — Deterministic Seed
- same seed produces same board.

### GG-011 — Retry Determinism
- first candidate rejected, later candidate accepted reproducibly.

### GG-012 — Mixed Group Sizes
- supports varying group profiles.

---

# 43. Required Generator Tests — Configuration

Test:

- invalid association count rejected;
- zero Tableau columns rejected;
- zero Move Limit rejected;
- invalid capacity rejected;
- unsupported group size rejected if applicable;
- slot count validated;
- invalid Stock size rejected;
- total cards equals Tableau + Stock.

---

# 44. Required Generator Tests — Card Pool

Test:

- exactly one Association Card per Association;
- all required Members included;
- no duplicate Card IDs;
- no missing Cards;
- correct total pool size;
- mixed groups handled correctly.

---

# 45. Required Generator Tests — Deal

Test:

- every Card appears exactly once;
- each non-empty Tableau column exposes exactly one Card;
- hidden Cards remain hidden;
- Stock order deterministic;
- Slots empty;
- all configured column sizes satisfied;
- no initial stacks.

---

# 46. Required Generator Tests — Seed

Test:

- same seed -> same candidate;
- different seed generally changes candidate;
- derived retry seed deterministic;
- serialized seed reproduces same board;
- generator version included in metadata.

---

# 47. Required Generator Tests — Solver Validation

Test:

- solved candidate accepted if difficulty valid;
- unsolvable rejected;
- solution over Move Limit rejected;
- Inconclusive not accepted;
- replayed solution ends won;
- Solver result metadata retained.

---

# 48. Required Generator Tests — Difficulty

Test:

- raw metrics captured;
- too-easy rejected;
- too-hard rejected;
- in-range accepted;
- score deterministic for same Solver metrics/model version;
- version metadata retained.

---

# 49. Required Generator Tests — Retry

Test:

- stops at max attempts;
- accepts later valid candidate;
- deterministic attempt sequence;
- no infinite loop;
- failure reason meaningful.

---

# 50. Required Generator Tests — Engine Invariants

Every generated candidate must pass:

```text
GameEngine.validateState
```

or equivalent invariant validator.

Reject before Solver if invalid.

---

# 51. Batch Simulation Tool

Create CLI:

```text
tool/generator_simulation.dart
```

Inputs:

- Level Configuration;
- number of boards;
- seed range/base seed;
- Solver profile;
- optional output file.

Outputs aggregated metrics.

---

# 52. Batch Simulation Metrics

At minimum:

```text
boardsRequested
boardsGenerated
generationSuccessRate
averageAttemptsToAccept
unsolvableRejectRate
tooEasyRejectRate
tooHardRejectRate
solverInconclusiveRate
averageGenerationTime
p50/p95GenerationTime
averageSolutionLength
averageNodesExpanded
difficultyScoreDistribution
stockRestoreDistribution
```

---

# 53. Simulation Output

Support:
- console summary;
- JSON or CSV file output.

Useful for:
- Difficulty tuning;
- CI artifacts;
- release validation;
- future CMS preview.

No Flutter dependency.

---

# 54. Simulation Scale

Sprint 3 development:
- small local batches.

Later release QA:
- critical templates/configurations: 10,000+ boards.

Do not force 10,000-board run on every PR.

Recommended:
- PR smoke: 10–100 boards.
- nightly/manual: larger batch.
- release gate: 10,000+ for critical templates.

---

# 55. Level Template Concept

Introduce reusable Level Configuration templates if helpful.

Example:

```text
Early_3x3
Early_4x3
Standard_4x4
Advanced_Mixed
```

These are engineering templates, not final launch content.

Do not produce all 250 Level Definitions in this sprint.

---

# 56. 10-Level Wave Compatibility

The product uses:

```text
10-Level Wave × 5 per Chapter
```

Sprint 3 should make config model capable of supporting difficulty waves.

For example:

```text
WavePosition
DifficultyTarget
GroupSizeProfile
MoveLimit
BoardLayoutProfile
```

Actual 250-level tuning comes later.

---

# 57. Semantic Difficulty Separation

Generator must keep:

```text
BoardDifficulty
```

separate from:

```text
SemanticDifficulty
```

Do not combine them into one opaque score.

Semantic Difficulty metadata may travel with content/Level Definition, but Solver cannot infer it.

---

# 58. Visual Content Constraint Support

Level Configuration should support:

```text
maxVisualAssociations
```

Launch rule:
- early/mid Levels max one visual Association.

Generator may enforce this if content metadata exposes visual/nonvisual classification.

Do not interpret image content itself.

---

# 59. Content-Type Homogeneity

Within one Association:
- Member content type must be homogeneous.

Generator should validate metadata if available.

Across a Level:
- content types may mix.

Association Card remains text clue.

---

# 60. Random Shuffle Quality

Use Fisher-Yates or equivalent unbiased seeded shuffle.

Do not use ad hoc repeated swaps.

Determinism required under seed.

---

# 61. Candidate Distribution Strategy

Baseline:

1. shuffle full card pool;
2. assign configured Tableau column capacities;
3. remaining cards to Stock.

This matches approved “full randomization across Tableau + Stock”.

Do not strategically place special Card types unless later explicitly approved.

Solver acceptance handles bad/random candidates.

---

# 62. Initial Face-Up Rule

No restriction on initial face-up type.

Therefore:
- Association Cards may be face-up.
- Member Cards may be face-up.

Do not bias the generator toward Member-only or Association-only exposed starts unless later approved.

---

# 63. Attempt ID

Attempt identity should be outside pure random distribution semantics.

Generated output can include:
- seed;
- candidate index.

Application layer may create globally unique Attempt ID.

Do not let random attempt ID affect board generation.

---

# 64. Generation Cancellation

Support cancellation.

Needed for:
- user leaves screen;
- batch task stopped;
- app lifecycle;
- future CMS preview cancellation.

Cancellation result:
- clean failure/inconclusive;
- no partial accepted board.

---

# 65. Time Budget

Support overall generation time budget.

If max time exceeded:
- stop;
- return generation inconclusive/failure;
- report attempts and Solver outcomes.

Do not loop indefinitely waiting for perfect difficulty.

---

# 66. Candidate Budget

Support:

```text
maxGenerationAttempts
```

Level Definition may define or inherit it.

Exact production values remain tunable.

---

# 67. Difficulty Relaxation

Do **not** silently relax target difficulty in v1.

If target cannot be reached:
- return failure;
- let higher-level tooling decide whether to:
  - change config;
  - adjust thresholds;
  - retry with different base seed;
  - alter content set.

Silent relaxation would undermine Level Definition intent.

---

# 68. Move Limit Relaxation

Never relax Move Limit automatically.

This is explicitly prohibited.

---

# 69. Content Mutation

Never change Association membership to make a board solvable.

Selected content is immutable for that candidate.

If board fails:
- re-deal;
- or reselect content if configuration allows a new selection on next attempt.

Document whether retries reuse same content or reselect.

---

# 70. Recommended Retry Policy

Baseline:

- select content once per generation call;
- re-deal with derived seeds;
- if max deal attempts exhausted:
  - fail.

Optional later:
- outer loop can reselect content.

This gives better reproducibility.

If content reselection is implemented, keep it as separate explicit budget.

---

# 71. Two-Level Retry Budget

Optional robust model:

```text
contentSelectionAttempt
  └── dealAttempt
```

Example:

- up to N content selections;
- up to M deals per selection.

Do not overcomplicate unless needed.

---

# 72. QA Reproduction String

Recommended generate a compact diagnostic string:

```text
levelDefinitionId
generatorVersion
solverVersion
rulesVersion
seed
candidateAttempt
contentVariantIds hash
```

This lets QA reproduce reported boards.

Do not rely only on screenshots.

---

# 73. Board Fingerprint

Create stable board fingerprint/hash from:

- exact Tableau layout;
- Stock order;
- selected Associations;
- config/rules version.

Useful for:
- duplicate detection;
- analytics;
- support.

Do not use it as a security secret.

---

# 74. Duplicate Board Detection

Sprint 3 may support duplicate fingerprint detection in batch simulation.

No product-facing seed-history anti-repeat feature is required.

Do not add player history behavior.

---

# 75. Generator Debug Output

Optional debug representation:

```text
Tableau columns
Hidden/Exposed cards
Stock order
Slot count
Move Limit
Seed
Solution length
Difficulty metrics
```

No UI dependencies.

---

# 76. Generator Performance

Measure:

- candidate construction time;
- Solver time;
- total generation time.

Solver will dominate.

Avoid optimizing shuffle while search is bottleneck.

---

# 77. On-Device Generation Goal

Main Journey generation is primarily on-device.

Therefore Generator must:
- be isolate-compatible;
- avoid Firebase dependencies;
- avoid large memory spikes;
- support bounded execution.

Flutter isolate integration comes later.

---

# 78. Fallback Boundary

If future measured data proves some boards too expensive to generate locally:
- backend fallback may be considered.

This is not Sprint 3 scope.

Do not implement cloud generation now.

---

# 79. Difficulty Calibration Data

Persist/export raw metrics in simulation output.

Do not only output accepted/rejected.

We will need distributions to set:
- thresholds;
- wave profiles;
- Move Limits;
- generation budgets.

---

# 80. Acceptance Rate Target

No permanent target is approved yet.

Measure:
- success rate;
- retries;
- time.

Do not invent a KPI like 90% acceptance and encode it.

---

# 81. Generator API

Recommended:

```dart
GenerationResult generate({
  required LevelConfiguration configuration,
  required List<AssociationVariant> content,
  required GenerationSeed seed,
  required GenerationOptions options,
});
```

Optional:

```dart
Stream<GenerationProgress>
```

not necessary for pure v1 unless useful.

---

# 82. GenerationOptions

Suggested:

```text
maxAttempts
overallTimeout
solverOptions
includeSolutionInResult
enableDifficultyValidation
enableDiagnostics
```

Production defaults should be configurable.

---

# 83. Difficulty Evaluator Interface

Recommended:

```dart
abstract interface class DifficultyEvaluator {
  DifficultyEvaluation evaluate(
    GameState state,
    SolveResult solvedResult,
  );
}
```

This separates Generator from scoring formula.

---

# 84. DifficultyEvaluation

Suggested:

```text
rawMetrics
score
band
acceptedAgainstTarget
modelVersion
```

---

# 85. Search Solution Dependency

Difficulty should use Solver’s proven solution and search metrics.

If Solver supports multiple solutions later:
- may choose shortest or first.
- v1 should document which is used.

Preferred v1:
- use Solver’s first proven bounded solution;
- record its length.

Do not claim it is mathematically shortest unless search mode guarantees that.

---

# 86. Exact Minimum Solution Length

If Iterative Deepening Solver guarantees first solution at shallowest depth:
- solution length is shortest within search model.

If not:
- call it `foundSolutionLength`, not `optimalSolutionLength`.

Naming must be truthful.

---

# 87. State Version Compatibility

Generator must validate:

- rulesVersion supported by Engine;
- Solver supports rulesVersion;
- generator config schema supported.

Unsupported:
- fail explicitly.

---

# 88. Serialization

Support serialization for:

- LevelConfiguration;
- GenerationSeed;
- GeneratedLevel metadata;
- DifficultyMetrics;
- Generation diagnostics.

Useful for:
- CI;
- CMS later;
- QA.

---

# 89. Package Structure

Recommended:

```text
packages/level_generator/
├── lib/
│   ├── level_generator.dart
│   └── src/
│       ├── api/
│       │   ├── generator.dart
│       │   ├── generation_options.dart
│       │   ├── generation_result.dart
│       │   └── generated_level.dart
│       │
│       ├── config/
│       │   ├── level_configuration.dart
│       │   ├── board_layout_profile.dart
│       │   └── difficulty_target.dart
│       │
│       ├── content/
│       │   ├── association_variant.dart
│       │   └── content_selector.dart
│       │
│       ├── random/
│       │   ├── generation_seed.dart
│       │   └── seeded_random.dart
│       │
│       ├── pool/
│       │   └── card_pool_builder.dart
│       │
│       ├── deal/
│       │   ├── board_dealer.dart
│       │   └── candidate.dart
│       │
│       ├── validation/
│       │   ├── candidate_validator.dart
│       │   └── generation_retry_policy.dart
│       │
│       ├── difficulty/
│       │   ├── difficulty_metrics.dart
│       │   ├── difficulty_evaluator.dart
│       │   ├── difficulty_score.dart
│       │   └── difficulty_model_version.dart
│       │
│       ├── diagnostics/
│       │   ├── generation_metrics.dart
│       │   ├── board_fingerprint.dart
│       │   └── reproduction_info.dart
│       │
│       └── version/
│           └── generator_version.dart
│
├── test/
│   ├── config/
│   ├── pool/
│   ├── deal/
│   ├── validation/
│   ├── difficulty/
│   ├── reproducibility/
│   └── golden/
│
└── tool/
    └── generator_simulation.dart
```

Keep structure proportional to actual implementation.

---

# 90. Suggested Implementation Order

## Step 1
Level Configuration + validation.

## Step 2
AssociationVariant content contract.

## Step 3
Seeded RNG + deterministic shuffle.

## Step 4
Card pool builder.

## Step 5
Tableau/Stock dealer.

## Step 6
Initial GameState construction.

## Step 7
Engine invariant validation.

## Step 8
Solver validation loop.

## Step 9
GenerationResult + diagnostics.

## Step 10
Difficulty raw metrics.

## Step 11
Difficulty evaluator/bands.

## Step 12
Retry policy.

## Step 13
Board fingerprint/reproduction metadata.

## Step 14
Golden Generator tests.

## Step 15
Batch simulation CLI.

## Step 16
Performance measurements.

---

# 91. Suggested Commit Sequence

### Commit 1
```text
feat(generator): add level configuration and validation
```

### Commit 2
```text
feat(generator): add seeded randomness and content contracts
```

### Commit 3
```text
feat(generator): build card pools and deterministic deals
```

### Commit 4
```text
feat(generator): construct engine-valid initial game states
```

### Commit 5
```text
feat(generator): add solver validation and bounded retry pipeline
```

### Commit 6
```text
feat(generator): add board difficulty metrics and evaluation
```

### Commit 7
```text
feat(generator): add generation diagnostics fingerprints and reproduction data
```

### Commit 8
```text
test(generator): add golden configs deterministic seed and validation tests
```

### Commit 9
```text
perf(generator): add batch simulation cli and generation metrics
```

### Commit 10
```text
docs(generator): document generation contracts and difficulty model
```

---

# 92. Sprint 3 Definition of Done

Sprint 3 is DONE only when:

- [ ] `level_generator` is pure Dart.
- [ ] No Flutter dependency.
- [ ] No Firebase dependency.
- [ ] `LevelConfiguration` implemented.
- [ ] Configuration validation implemented.
- [ ] Group sizes 3/4/5/mixed supported.
- [ ] AssociationVariant input contract implemented.
- [ ] Seed type implemented.
- [ ] Deterministic RNG implemented.
- [ ] Unbiased seeded shuffle implemented.
- [ ] Card pool builder implemented.
- [ ] No duplicate/missing cards.
- [ ] Tableau deal implemented.
- [ ] exactly one exposed card per non-empty Tableau column.
- [ ] Stock deal implemented.
- [ ] Slots start empty.
- [ ] Initial GameState passes Engine invariants.
- [ ] Solver validation integrated.
- [ ] Unsolvable candidate rejected.
- [ ] Inconclusive candidate not accepted.
- [ ] Fixed Move Limit enforced.
- [ ] Move Limit never auto-relaxed.
- [ ] Difficulty metrics implemented.
- [ ] Board Difficulty kept separate from Semantic Difficulty.
- [ ] Difficulty target validation implemented.
- [ ] Too-easy candidate rejected.
- [ ] Too-hard candidate rejected.
- [ ] Bounded retry implemented.
- [ ] Overall timeout/cancellation supported.
- [ ] Generation failure model implemented.
- [ ] GeneratedLevel metadata implemented.
- [ ] Generator version implemented.
- [ ] Difficulty model version implemented.
- [ ] Board fingerprint implemented.
- [ ] Reproduction metadata implemented.
- [ ] Same seed/config reproduces same board.
- [ ] Golden Generator configurations implemented.
- [ ] Solver replay confirms accepted board wins.
- [ ] Batch simulation CLI exists.
- [ ] Simulation outputs useful metrics.
- [ ] `dart analyze` passes.
- [ ] `dart test` passes.
- [ ] README/docs updated.

---

# 93. Sprint 3 Exit Gate Before Playable Vertical Slice

Do not start Sprint 4 until:

1. deterministic seed reproduction is proven;
2. Engine invariants pass on all generated boards;
3. accepted boards always Solver-solve within Move Limit;
4. no Inconclusive board is accepted;
5. retry loop is bounded;
6. batch simulation runs successfully;
7. Board Difficulty metrics are available;
8. baseline difficulty ranges are testable/configurable;
9. representative configs have measured generation time;
10. mobile execution feasibility is reviewed;
11. Golden Generator tests pass;
12. board reproduction information is sufficient for QA.

---

# 94. Cursor Execution Prompt — Sprint 3

Use this after Sprint 2 passes its exit gate:

> Implement **Sprint 3 — Level Generator & Difficulty Validation v1** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - `Sprint_3_Level_Generator_and_Difficulty_Validation_v1.0.md`
> - latest Game Engine specification
> - latest Solver specification
> - latest Difficulty Model
> - latest Level Design Framework
>
> Work primarily inside `packages/level_generator`.
>
> Keep the package pure Dart and independent from Flutter, Riverpod, Firebase, Drift, analytics, UI, ads, and IAP.
>
> Implement:
>
> - typed `LevelConfiguration`;
> - validation of configuration invariants;
> - AssociationVariant/content input contract;
> - seeded deterministic randomness;
> - unbiased shuffle;
> - card-pool construction;
> - deterministic Tableau + Stock deal;
> - exactly one exposed Card per non-empty Tableau column;
> - empty Association Slots;
> - valid initial `GameState`;
> - Game Engine invariant validation;
> - Solver validation;
> - fixed Move Limit acceptance;
> - bounded candidate retry;
> - generation result/failure model;
> - Board Difficulty raw metrics;
> - configurable/versioned Difficulty evaluation;
> - strict separation of Board Difficulty from Semantic Difficulty;
> - board fingerprint;
> - QA reproduction metadata;
> - Generator version;
> - Difficulty Model version;
> - Golden Generator configurations;
> - deterministic-seed tests;
> - Solver acceptance/replay tests;
> - batch simulation CLI.
>
> Critical constraints:
>
> - all cards are fully randomized across Tableau + Stock;
> - do not strategically place Association or Member Cards;
> - initial face-up Card type is unrestricted;
> - Association Slots start empty;
> - no card may be duplicated or lost;
> - fixed visible Move Limit must never be changed per Attempt;
> - candidate is accepted only if Solver proves it solvable within Move Limit;
> - `Inconclusive` must never be accepted as solvable;
> - do not silently relax difficulty target;
> - do not silently relax Move Limit;
> - Generator must not infer Arabic semantic correctness;
> - Semantic Difficulty is metadata/content concern, separate from Board Difficulty;
> - same seed/config/version must reproduce the same deal;
> - retry loops must be bounded;
> - no cloud generation in this sprint.
>
> Start with correctness and reproducibility before performance tuning.
>
> At completion report:
>
> 1. files created/changed;
> 2. Generator public API;
> 3. Level Configuration model;
> 4. seed/reproducibility approach;
> 5. deal algorithm;
> 6. Solver validation flow;
> 7. Board Difficulty metrics/model;
> 8. retry/failure handling;
> 9. Golden Generator tests;
> 10. batch simulation results;
> 11. analyze/test results;
> 12. unresolved tuning decisions;
> 13. any deviations from this Sprint document and why.

---

# 95. Next Sprint

After Sprint 3 passes the exit gate:

# **Sprint 4 — Playable Gameplay Vertical Slice v1**

Expected focus:

- Flutter gameplay screen;
- Board renderer;
- RTL-safe layout;
- drag/drop;
- source/destination mapping;
- Game Engine integration;
- Stock UI;
- Association Slots;
- Move counter;
- Streak feedback;
- Undo;
- Hint integration with Solver;
- Out-of-Moves state;
- Dead-End UX;
- Win flow;
- animations;
- one end-to-end generated Level Attempt;
- local Attempt persistence baseline.

---

**End of Sprint 3 — Level Generator & Difficulty Validation v1**
