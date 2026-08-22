# Solver Specification
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source Documents:** Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Progression Design v1.0 + Content Design System v1.0 + Level Design Framework v1.0 + Difficulty Model v1.0 + Final Decision Register v1.1  
**Important:** Register-approved items are **APPROVED/CONFIRMED** (Pure Dart Solver; hybrid search direction; hybrid execution). Exact Solver algorithm composition, timeouts, native optimization necessity, and exact backend fallback rules remain intentional **TBD** (Register §14). Backend simulation/fallback runs on Firebase/GCP serverless (Cloud Functions / Cloud Run), not Azure.

---

# 1. Purpose

The Solver is a core gameplay subsystem.

It is not only a developer/debugging tool.

The Solver must support four production responsibilities:

1. **Board Validation**  
   Determine whether a generated board is solvable.

2. **Move-Bounded Validation**  
   Determine whether the board can be solved within the Level's fixed Move Limit.

3. **Hint Generation**  
   Return a safe/useful next move from the current player state.

4. **Dead-End Detection**  
   Determine whether the current state still has at least one valid completion path.

It also provides data used by:

- Difficulty Model.
- Level Generator.
- Automated QA.
- Analytics.
- Admin/CMS preview tools.
- Debugging.
- Game balancing.

---

# 2. Solver Design Principles

The Solver must be:

- Correct with respect to the approved game rules.
- Deterministic for the same full state/configuration when deterministic mode is requested.
- Independent from UI animation state.
- Capable of analyzing randomized boards before they reach the player.
- Capable of analyzing a live board after player actions.
- Safe enough that Hint does not knowingly recommend a losing move when a winning continuation exists.
- Instrumented for performance and diagnostic metrics.
- Versioned.

---

# 3. Solver Is Not the Game Engine

The Game Engine is authoritative for:

- Applying player actions.
- Validating immediate move legality.
- Updating Moves.
- Updating Streak.
- Updating cards/stacks.
- Completing Associations.
- Revealing cards.
- Producing player-visible state.

The Solver is responsible for:

- Searching future states.
- Determining solvability.
- Finding/reference-scoring solution paths.
- Identifying safe moves.
- Detecting dead states.
- Supplying difficulty metrics.

The Solver must use the same shared rule definitions as the Game Engine wherever possible to avoid rule drift.

---

# 4. Confirmed Core Rules the Solver Must Respect

The Solver must model all of the following **CONFIRMED** rules:

1. Association Cards are part of the deck.
2. Association Cards may start in Tableau or Stock.
3. Association Slots start empty.
4. Each Tableau column starts with exactly one face-up card.
5. Cards below it are face-down.
6. Exposing the next face-down card flips it automatically.
7. Empty Tableau columns accept any movable unit.
8. Member Cards may stack only with Members of the same Association.
9. Same-group stacks may merge.
10. Every formed stack is atomic.
11. Stacks can never be split.
12. Internal stack order does not affect gameplay rules.
13. Association Card in Tableau is inactive.
14. Association Card can be placed onto a same-group Member Card/Stack.
15. Member Card/Stack cannot be placed onto an Association Card while that Association remains in Tableau.
16. Once an Association Card joins a Tableau stack, no additional Members may be added to that stack while it remains in Tableau.
17. A combined Association stack may move as one unit.
18. An Association Card moved to an Association Slot becomes active.
19. Active Associations may accept a matching Member Card or full matching Member Stack.
20. A combined Association stack moved to a Slot carries its attached Members immediately.
21. Association completes only in an Association Slot.
22. Completion is automatic when all required Members are present.
23. Completed Association and Members disappear immediately.
24. Completion frees the Slot.
25. Stock displays up to the last three exposed cards.
26. Only the final/top exposed Stock card is playable.
27. Removing that card makes the previous visible Stock card playable.
28. Stock can be advanced/cycled.
29. Restore Stock is unlimited.
30. Restore Stock preserves the order of remaining Stock cards.
31. Stock advance costs one Move.
32. Restore Stock costs one Move.
33. Moving a card/stack costs one Move.
34. Moving an entire stack always costs one Move regardless of size.
35. Invalid/rejected actions consume no Move.
36. Move Limit is fixed for a Level.
37. Win requires all cards to be cleared.
38. Restart creates a new full shuffle for the same Level content/configuration.
39. Hints do not perform the move.
40. Dead-End Detection must recognize states with no remaining solution.
41. Player is free to make any legal move even when strategically poor.

---

# 5. Solver Responsibilities

The Solver shall expose logical capabilities equivalent to:

- `ValidateInitialBoard`
- `FindSolution`
- `FindSolutionWithinMoveLimit`
- `GetReferenceMoveCount`
- `GetSafeNextMoves`
- `GetHint`
- `IsDeadEnd`
- `AnalyzeDifficulty`
- `ExplainRejection`
- `GenerateDebugTrace`

Exact API names belong to Software Architecture/API design.

---

# 6. Solver Modes

**PROPOSED**

The Solver should support multiple execution modes.

## 6.1 Generation Validation Mode

Used before a randomized board is shown.

Goals:

- Fast solvability check.
- Move-Limit validation.
- Difficulty metrics.
- Reference solution.

## 6.2 Hint Mode

Used during play.

Goals:

- Find at least one safe winning continuation.
- Return one recommended next action.
- Prefer useful human-readable actions.

## 6.3 Dead-End Mode

Used after impactful player actions.

Goal:

- Determine whether any solution remains.

## 6.4 Deep Analysis Mode

Used offline/admin/QA.

Goals:

- More exhaustive search.
- Minimum Move analysis.
- Branch statistics.
- Difficulty diagnostics.

---

# 7. Solver Input

A Solver request should contain:

- Game Rules version.
- Solver version/mode.
- Level Configuration.
- Move Limit.
- Remaining Moves.
- Association definitions.
- Group membership.
- Current Tableau state.
- Hidden-card order/state.
- Current Stock state.
- Active Association Slots.
- Completed Associations.
- Current atomic Stack structure.
- Current exposed cards.
- Attempt identifier/debug seed where available.

Streak/economy state is not required for pure solvability unless a future rule makes it gameplay-relevant.

---

# 8. Solver Output

A Solver response should be able to contain:

- `solvable`
- `solution_found`
- `solution_moves`
- `reference_move_count`
- `minimum_move_count` if proven
- `winning_next_moves`
- `recommended_hint_move`
- `dead_end`
- `states_explored`
- `branches_explored`
- `solver_duration`
- `required_stock_advances`
- `required_restores`
- `moves_to_first_completion`
- `safe_branch_ratio`
- `difficulty_metrics`
- `confidence`
- `termination_reason`

---

# 9. Canonical Card Identity

Every physical card instance must have a stable card ID.

Suggested conceptual fields:

- `card_id`
- `card_kind`
- `association_id`
- `content_id`
- `content_type`

Card kinds:

- Association Card.
- Member Card.

The Solver must reason from IDs/group membership, not visible Arabic text.

---

# 10. Association Identity

Every Member Card references one target `association_id` for the current Level.

The same displayed word may belong to different global relations across different Levels, but the Solver only cares about the Level-specific target mapping.

This avoids semantic ambiguity inside the algorithm.

Semantic difficulty belongs to the Content/Difficulty systems, not to logical move legality.

---

# 11. Tableau State Model

Each Tableau column should be representable as:

- Ordered hidden cards.
- One exposed movable unit at the top.

The exposed unit may be:

- Single Member Card.
- Single Association Card.
- Atomic Member Stack.
- Atomic Association Stack.

When the exposed unit moves away:

- If a hidden card becomes exposed, it flips automatically.
- That reveal is part of the resulting state and costs no additional Move.

---

# 12. Atomic Stack Model

**CONFIRMED**

Stacks cannot be split.

The Solver should therefore represent a Stack as one movable entity.

A Stack should contain:

- `association_id`
- `contains_association_card`
- `member_count`
- `member_card_ids` or equivalent canonical set
- `association_card_id` if present

Internal card order is not gameplay-relevant.

---

# 13. Stack Canonicalization

**PROPOSED**

Because internal order does not matter, canonicalize a Member Stack using sorted card IDs or a compact membership representation.

Example logical identity:

`association_id + sorted(member_card_ids) + association_flag`

This significantly reduces duplicate search states produced by equivalent internal orderings.

---

# 14. Member Stack Rules

A Member Stack:

- Contains only Members of one Association.
- May accept compatible Member Card/Stack.
- May accept its Association Card.
- May move as a unit.
- May move to an empty Tableau column.
- May move to its active Association Slot.

---

# 15. Association Stack Rules

An Association Stack in Tableau:

- Contains one Association Card.
- May contain zero or more matching Members.
- Is inactive.
- Cannot accept additional Member Cards/Stacks while in Tableau.
- Can move to another valid Tableau location where rules permit movement of the whole unit.
- Can move to an empty Tableau column.
- Can move to an empty Association Slot and become active.

Once placed in a Slot, attached Members immediately count toward completion.

---

# 16. Tableau Placement Legality

The Solver's rule engine must distinguish at least:

## Member → Member/Member Stack
Valid only when `association_id` matches.

## Member Stack → Member/Member Stack
Valid only when `association_id` matches.

## Association Card → Member/Member Stack
Valid only when `association_id` matches.

## Member/Member Stack → Association Card in Tableau
Invalid.

## Any movable unit → Empty Column
Valid.

## Member/Stack → Association Stack in Tableau
Invalid because the Association Stack is locked against additions while inactive.

---

# 17. Active Association Slot State

Each Slot should contain either:

- Empty.
- Active Association state.

An Active Association state includes:

- `association_id`
- `association_card_id`
- `member_card_ids`
- `member_count`
- `required_member_count`

---

# 18. Association Slot Placement

Valid transitions:

## Association Card → Empty Slot
Activates Association.

## Association Stack → Empty Slot
Activates Association and transfers attached Members.

## Member Card → Matching Active Association
Adds one Member.

## Member Stack → Matching Active Association
Adds all Members.

Invalid:

- Member → Empty Slot.
- Member Stack → Empty Slot.
- Association Card → occupied Slot.
- Member/Stack → non-matching Active Association.

---

# 19. Association Completion Transition

When:

`member_count == required_member_count`

the Solver must immediately apply completion semantics:

1. Remove the Association Card.
2. Remove all Members in that Active Association.
3. Set Slot to Empty.
4. Mark Association complete.
5. Check whether the entire board is now empty.

Completion does not cost a second Move.

---

# 20. Stock State Model

The Solver must model Stock according to approved behavior without assuming a classic Solitaire waste-pile rule that has not been approved.

Required logical behavior:

- Stock has an ordered sequence of remaining Cards.
- Advancing Stock changes which cards are exposed.
- Up to the last three exposed cards are visible.
- Only the newest/final exposed card is playable.
- If that playable card is moved away, the previous exposed visible card becomes playable.
- Restore Stock recycles remaining Stock cards in the same order.
- Restore is unlimited.
- Advance and Restore each cost one Move.

---

# 21. Stock Representation

**PROPOSED**

Represent Stock using:

- Ordered undealt/recycled sequence.
- Ordered currently exposed window/pile.
- Index/cycle position.
- Remaining card identities.

The implementation may internally use a pile/waste model as long as its externally observable behavior matches the approved rules exactly.

---

# 22. Stock Canonical State

A canonical Stock state should preserve all information needed to determine future playable cards.

Possible representation:

`(remaining_sequence, exposed_sequence_up_to_or_beyond_window, current_cycle_state)`

The visible UI window may show only three cards, but the Solver may need a fuller internal sequence representation.

---

# 23. Stock Advance Action

A Stock Advance:

- Costs one Move.
- Changes Stock state.
- May expose the next card.
- Is neutral for Streak, but Streak is not required for solvability.

The precise internal transformation must match the Game Engine's authoritative Stock implementation.

---

# 24. Stock Card Removal

When the current playable Stock card is moved:

- The card leaves Stock.
- The immediately preceding exposed card, if any, becomes playable.
- No additional Move is charged for exposure itself.
- The card movement itself costs one Move.

---

# 25. Restore Stock Action

Restore Stock:

- Costs one Move.
- Is unlimited.
- Preserves the order of the remaining Stock cards.
- Does not reshuffle.

The Solver must prevent infinite search loops caused by unlimited Restores through state deduplication and Move-bound pruning.

---

# 26. Move Cost Model

Every legal Solver action that corresponds to player gameplay has a cost.

**CONFIRMED**

Cost = 1 Move for:

- Stock Advance.
- Restore Stock.
- Tableau Card move.
- Tableau Stack move.
- Association Card to Slot.
- Association Stack to Slot.
- Member Card/Stack to Active Association.

No action costs more because multiple cards are inside a Stack.

---

# 27. Zero-Cost Automatic Transitions

Automatic transitions cost zero Moves:

- Flip newly exposed Tableau card.
- Association completion/removal.
- Slot freeing after completion.
- UI-only updates.

The Solver should apply these as part of the state transition rather than as searchable actions.

---

# 28. Invalid Actions

Invalid actions are not generated by the Solver.

The Game Engine may receive and reject invalid player attempts.

For search efficiency, the Solver enumerates only legal moves.

---

# 29. Search State

A canonical search state must contain enough information to determine all future legal moves and completion possibility.

Minimum logical state:

- Tableau columns.
- Hidden/exposed structure.
- Stock state/order.
- Association Slots.
- Completed Associations.
- Remaining Moves or Moves Used.
- Level configuration/rule version.

---

# 30. State Fields Not Required for Solvability

The following do not affect current core solvability:

- Coin balance.
- Streak tier.
- Current streak count.
- Daily state.
- XP.
- Ads.
- Cosmetic theme.

They should not inflate Solver state.

---

# 31. Move History

Full move history is not inherently required to determine solvability.

However, history may matter for:

- Player Undo UI.
- Diagnostics.
- Hint explanation.
- Preventing immediate Solver oscillation in heuristic modes.

The canonical search state should avoid including irrelevant history unless needed.

---

# 32. Undo in Solver Search

Undo is not a normal forward search move.

Reason:

Search already explores alternative branches from prior states.

Including Undo as a search action would create artificial cycles.

For Dead-End UX:

- Solver analyzes the current state normally.
- Game Engine separately knows whether Undo is available as a rescue.

---

# 33. Extra Moves in Solver

Initial board validation uses the Level's fixed Move Limit.

The board must be solvable **without requiring purchased/ad-funded Extra Moves**.

This is essential for fairness.

Extra Moves are a rescue after player inefficiency, not part of board solvability acceptance.

---

# 34. Dead-End Rescue in Solver

The normal Solver answers:

`Is current state solvable under current remaining Moves?`

A rescue operation is a separate transformation.

After any rescue transformation:

- The resulting state must be revalidated by the Solver before being shown.

The exact rescue transformation remains **TBD**.

---

# 35. Solvability Definition

A state is solvable when there exists a sequence of legal moves that:

- Clears all Tableau cards.
- Clears all Stock cards.
- Completes all Associations.
- Uses no more than the available Move budget where Move-bounded mode is requested.

---

# 36. Unbounded vs Move-Bounded Solvability

The Solver should distinguish:

## Logical Solvability
Can the state ever be completed under legal rules, ignoring Move Limit?

## Move-Bounded Solvability
Can it be completed within `remaining_moves`?

A state can be logically solvable but effectively lost because not enough Moves remain.

For gameplay Dead-End handling, the product should decide whether "dead end" includes only logical impossibility or also Move-bounded impossibility. The current Move-Limit design strongly suggests both are valuable signals, but the exact player-facing distinction is **PROPOSED/TBD**.

---

# 37. Recommended Dead-End Semantics

**PROPOSED**

Use two internal statuses:

- `STRUCTURAL_DEAD_END`: no legal completion path even with unlimited Moves.
- `MOVE_BUDGET_DEAD_END`: completion path exists, but not within remaining Moves.

Player-facing UI may unify them if desired, but internal distinction is useful for:

- Rescue choice.
- Analytics.
- Difficulty tuning.

---

# 38. Search Objective

The Solver may have multiple search objectives:

1. Find any solution.
2. Find a solution within Move Limit.
3. Find minimum Moves.
4. Find a safe next move quickly.
5. Analyze branching/difficulty.

Different objectives may use different algorithms or stop conditions.

---

# 39. Search Algorithm Choice

Exact Solver algorithm composition remains intentional **TBD** after benchmarking.

**Candidate approaches** (direction guidance only):

- A*.
- IDA*.
- Best-First Search.
- Depth-First Search with pruning.
- Iterative Deepening DFS.
- Dynamic Programming / memoized DFS.
- Hybrid heuristic search.

The final algorithm composition should be selected after prototype benchmarks on representative board sizes.

---

# 40. Recommended Algorithm Direction

**CONFIRMED** search direction:

Hybrid search with canonicalization/memoization/bounded search.

Illustrative hybrid shape (exact composition intentional TBD):

- Fast memoized DFS / IDA* for bounded solvability.
- A* or Best-First variant when minimum/reference Move quality is needed.
- Shared transposition table.
- Strong domain-specific pruning.

---

# 41. Why Brute Force Alone Is Risky

Potential state explosion comes from:

- Multiple Tableau columns.
- Multiple legal stack merges.
- Empty-column movement.
- Stock cycling.
- Unlimited Restores.
- Multiple Association Slots.
- Player freedom among valid moves.

Therefore canonicalization and pruning are mandatory for production-scale performance.

---

# 42. State Canonicalization

Equivalent states should hash identically where gameplay-future behavior is equivalent.

Potential canonicalization:

- Normalize internal Stack order.
- Normalize completed Associations.
- Consider whether interchangeable empty Tableau columns can be canonicalized.
- Consider whether Tableau columns with structurally identical content can be ordered canonically.

Any symmetry reduction must preserve correctness.

---

# 43. Empty Column Symmetry

**PROPOSED**

Multiple empty Tableau columns are often functionally equivalent.

The Solver may canonicalize them to reduce duplicate states.

Example:

Moving the same Stack to Empty Column A vs Empty Column B may produce equivalent future possibilities.

This should be proven against all movement rules before implementation.

---

# 44. Tableau Column Symmetry

**PROPOSED**

Columns may be canonicalized only when their hidden/exposed sequences are structurally equivalent.

Do not reorder columns blindly if UI-independent gameplay still depends on column identity through hidden-card sequences.

---

# 45. Transposition Table

**PROPOSED**

Maintain a hash map/set of visited canonical states.

Possible stored values:

- Best Moves Used reaching state.
- Best Remaining Moves.
- Solvability result.
- Lower bound.
- Search depth.

If the same state is reached with worse Move usage, prune it.

---

# 46. Dominance Rule

**PROPOSED**

If state S has been reached previously with fewer or equal Moves Used, a later path reaching identical S with more Moves Used is dominated and can be pruned.

This is safe because future possibilities are identical but Move budget is worse.

---

# 47. Unlimited Restore Loop Prevention

Because Restore is unlimited, naive search can loop indefinitely.

State hashing must recognize repeated Stock/Tableau/Slot configurations.

If Restore returns to a previously visited identical state with fewer remaining Moves, the new state is strictly dominated and should be pruned.

---

# 48. Reverse-Move Cycles

The player may legally move Stacks between Tableau columns in ways that return to prior states.

Visited-state pruning must prevent infinite:

`A → B → A → B`

search loops.

---

# 49. Lower-Bound Heuristics

**PROPOSED**

For Move-bounded pruning, estimate a minimum number of remaining Moves.

Possible lower-bound components:

- At least one move to activate each not-yet-active Association.
- At least one move to transfer each independent Member Stack into its Association.
- Required Stock advances.
- Required Restores lower bound.
- Necessary Tableau reveals/moves.

If:

`moves_used + lower_bound > move_limit`

prune state.

The lower bound must never overestimate if used for correctness-critical pruning.

---

# 50. Admissible Heuristic Requirement

When using A* for optimality:

Heuristic must be admissible if minimum Move proof is required.

For non-optimal reference search, heuristic may be more aggressive but must clearly report that Move count is best-known rather than proven minimum.

---

# 51. Association Completion Heuristic

**PROPOSED**

Prefer moves that:

- Complete an Association.
- Free an Association Slot.
- Reveal a hidden Tableau card.
- Reduce number of movable units.
- Create strategically useful empty columns.

These may improve search ordering.

They must not be treated as correctness rules.

---

# 52. Safe Search Ordering

Search ordering can prioritize likely-good moves without removing other legal branches.

This preserves correctness while improving time to first solution.

---

# 53. Move Categories for Search Ordering

**PROPOSED order candidate:**

1. Association-completing move.
2. Move revealing hidden card.
3. Association activation required for available Members.
4. Merge same-group stacks.
5. Move to Active Association.
6. Productive empty-column move.
7. Stock play.
8. Stock advance.
9. Restore.
10. Other reversible Tableau moves.

Final ordering should be benchmarked.

---

# 54. Avoiding Over-Prioritization

A greedy move such as immediate Association completion may occasionally block a better path only if game rules allow such interaction.

Therefore search ordering may prioritize but must not prune alternatives unless a proven dominance rule applies.

---

# 55. Association Slot Allocation Search

When multiple empty Slots exist, placing an Association into any empty Slot may be functionally equivalent if Slots have no different rules.

**PROPOSED**

Treat empty Slots as symmetric for Solver state canonicalization unless future locked/special Slot mechanics are introduced.

This can greatly reduce branching.

---

# 56. Active Association Slot Symmetry

If Slots are mechanically identical, state identity may depend on the set of active Associations rather than which visual Slot index they occupy.

This symmetry reduction is **PROPOSED**.

It must be disabled if future Slot-specific mechanics appear.

---

# 57. Stack Merge Equivalence

When two same-group Member Stacks merge, internal order is irrelevant.

Equivalent merge orderings should canonicalize to one Stack identity.

This is a major state-space reduction opportunity.

---

# 58. Association-Stack Lock Semantics

The Solver must correctly enforce:

`Association Card + Member Stack in Tableau`

becomes locked against additions.

It may still move as an atomic unit.

This state is distinct from:

- Active Association in Slot.
- Member Stack without Association Card.

---

# 59. Player Freedom

The Solver must model all legal player choices.

It must not silently remove legal but strategically poor moves from correctness search.

Heuristic search may deprioritize them.

Only mathematically proven dominated moves may be safely pruned.

---

# 60. Hint Definition

A Hint is:

- One recommended legal action.
- Not automatically executed.
- Derived from at least one winning continuation whenever a winning path exists.

---

# 61. Hint Safety

The safest Hint rule is:

Return a move that leads to a state the Solver has proven solvable within the remaining Move budget.

This is the preferred standard.

---

# 62. Hint Ranking

When multiple winning next moves exist, rank them for human usefulness.

**PROPOSED factors:**

- Completes an Association.
- Reveals a hidden card.
- Frees a Slot.
- Creates an empty column.
- Avoids unnecessary Stock cycling.
- Uses fewer future Moves.
- Avoids creating fragile forced states.

---

# 63. Hint Text Mapping

The Solver should return a structured move, not localized UI prose.

Example logical move:

- Source: Tableau Column 3
- Unit: Stack X
- Destination: Active Association Y

The UI/Localization layer converts that to Arabic.

This keeps Solver logic language-independent.

---

# 64. Hint Confidence

**PROPOSED**

Hint result may include confidence:

- Proven winning.
- Winning under current reference search.
- Best-known safe.

For production Hint, prefer only proven-winning moves where computationally feasible.

---

# 65. Hint When Multiple Equivalent Moves Exist

If several moves are strategically equivalent, choose one using deterministic ranking so the player receives stable guidance for the same state.

---

# 66. Hint and Neutral Moves

A Hint may recommend:

- Stock Advance.
- Restore.
- Empty-column move.

when that is the appropriate next step.

This is **CONFIRMED** in the product concept.

---

# 67. Hint After Player Deviates

After the player makes a different legal move:

- Re-run or incrementally update analysis.
- Do not keep recommending a stale move from an old state.

---

# 68. Dead-End Detection Trigger

**PROPOSED**

Run Dead-End analysis after impactful state-changing actions, especially:

- Tableau move.
- Stack merge.
- Association activation.
- Move into Active Association.
- Stock card removal.
- Stock Advance.
- Restore.

Performance may justify lightweight incremental checks on some actions.

---

# 69. Dead-End Detection Performance

Dead-End feedback should feel immediate enough not to interrupt flow.

If full deep search is expensive, consider:

- Cached state results.
- Incremental analysis.
- Fast first-pass proof.
- Background deeper confirmation.

But do not display a false Dead-End warning.

---

# 70. False Positive Requirement

Dead-End Detection must prioritize zero false positives.

Incorrectly telling the player a solvable state is dead would break trust.

A slow or missing warning is less damaging than a wrong warning.

---

# 71. False Negative Handling

A false negative means the player continues in a truly dead state until a later check.

This is undesirable but less severe than a false positive.

The QA target should still minimize both.

---

# 72. Initial Board Validation

Before presenting a board:

1. Build full state.
2. Run Solver.
3. Confirm logical solvability.
4. Confirm solution within fixed Move Limit.
5. Gather reference metrics.
6. Evaluate Board Difficulty.
7. Accept/reject.

No player resources or rescues should be required for acceptance.

---

# 73. Generation Rejection Reasons

Return explicit internal reason codes, such as:

- `UNSOLVABLE`
- `MOVE_LIMIT_EXCEEDED`
- `TOO_EASY`
- `TOO_HARD`
- `TOO_MANY_RESTORES`
- `EXCESSIVE_DEAD_END_PRESSURE`
- `COMPLETION_DELAY`
- `SOLVER_TIMEOUT`
- `INVALID_STATE`

Exact codes are **PROPOSED**.

---

# 74. Minimum vs Reference Solution

The Solver should distinguish:

## Proven Minimum
No shorter solution exists.

## Reference Solution
A valid solution found, but optimality not proven.

Difficulty Model must know which one it receives.

---

# 75. Minimum Move Importance

Minimum/reference Moves influence:

- Move Slack.
- Board Difficulty.
- Fixed Move Limit tuning.
- QA.

Exact optimality may not be necessary for every live Hint call.

---

# 76. Solver Search Depth Limit

Search depth is naturally bounded by:

- Move Limit in bounded mode.
- State deduplication.
- Optional technical cap.

In logical-solvability mode without Move Limit, explicit protections are required because Stock Restore is unlimited.

---

# 77. Move-Bounded Search

For generated board validation:

Search only paths with:

`moves_used <= level_move_limit`

This provides a finite practical bound.

---

# 78. Live Search Remaining Budget

For Hint/Dead-End:

Use:

`remaining_moves`

not original Level Move Limit.

This detects whether the player can still finish inside the current attempt.

---

# 79. Structural Solvability Search

For diagnostics, a second search may ignore remaining Move budget to tell the difference between:

- Bad strategic structure.
- Insufficient Moves remaining.

This distinction can improve rescue UX and analytics.

---

# 80. Solver Metrics for Difficulty

The Solver should expose at least:

- Reference Moves.
- Move Slack.
- Required Stock Advances.
- Required Restores.
- Initial valid move count.
- Safe Branch Ratio.
- Dead-End branch count.
- Forced-state count/ratio.
- Moves to first Association completion.
- States explored.
- Search depth.
- Solver duration.

Some metrics may initially be **P1** if expensive.

---

# 81. Safe Branch Ratio Computation

**PROPOSED**

For selected states:

`Safe Branch Ratio = count(valid moves whose resulting states are solvable) / count(valid moves)`

Computing this exhaustively at every state may be expensive.

Possible approaches:

- Sample key states.
- Compute along reference path.
- Use Deep Analysis mode only.

---

# 82. Dead-End Branch Count

**PROPOSED**

Count valid first-order or explored branches that eventually become unsolvable.

Useful for distinguishing:

- Flexible board.
- Trap-heavy board.

---

# 83. Forced-State Ratio

**PROPOSED**

Along a reference solution:

`Forced-State Ratio = states with exactly one safe continuation / analyzed states`

High values indicate constrained play.

---

# 84. Moves to First Completion

Measure how many Moves occur before the first Association completes on the reference path.

Useful for:

- Difficulty.
- Pacing quality.
- Level rejection.

---

# 85. Required Stock Advances

Track Stock Advance count on the reference solution.

This contributes directly to Move cost.

---

# 86. Required Restores

Track minimum/reference Restore count.

Excessive values should trigger quality review even if the board is solvable.

---

# 87. Solver Confidence

**PROPOSED**

Possible result classification:

- `EXACT`
- `PROVEN_SOLVABLE`
- `BEST_KNOWN`
- `TIME_LIMITED`
- `INCONCLUSIVE`

Production board acceptance should not accept `INCONCLUSIVE`.

---

# 88. Timeout Policy

Exact timeout/performance budgets remain intentional **TBD**.

Different contexts should have different budgets (guidance only until measured):

- Initial board generation: moderate short budget.
- Live Hint: short user-facing budget.
- Dead-End check: short/high-priority.
- Admin Deep Analysis: longer.
- Offline simulation: much longer.

---

# 89. Solver Cancellation

Solver calls should be cancellable.

Examples:

- Player exits level.
- New board generated.
- New move invalidates old Hint analysis.
- App enters background.

---

# 90. Incremental Solving

**PROPOSED**

Cache analysis from prior state and reuse it after player actions where possible.

Potential benefits:

- Faster Hint.
- Faster Dead-End.
- Lower battery/CPU.

Exact feasibility depends on algorithm.

---

# 91. Cache Scope

Potential cache layers:

- In-attempt state cache.
- Level-template cache.
- Pre-generated board cache.
- Shared transposition cache.

Never reuse cached results across incompatible:

- Rule versions.
- Solver versions.
- Content membership changes.
- Level configuration changes.

---

# 92. Solver Hash Key

**PROPOSED**

Hash should include all gameplay-relevant state:

- Canonical Tableau.
- Canonical Stock.
- Active Associations.
- Completed Associations.
- Remaining Move budget where result is move-bounded.
- Rules version.

---

# 93. State Compression

Potential optimizations:

- Bitsets for Member ownership.
- Integer Association IDs.
- Compact stack structures.
- Immutable/persistent state representation.
- Zobrist hashing or equivalent.

Exact implementation is **PROPOSED**.

---

# 94. Hidden Card Knowledge

For initial validation, Solver knows all hidden cards.

For live Hint/Dead-End, the game itself also knows hidden card identities because the board was generated internally.

Therefore the Solver may use full board knowledge.

This is allowed because Hint is an internal gameplay assistance system.

---

# 95. Player Information Fairness

Although Solver knows hidden cards, Hint should avoid revealing hidden content directly unless a future design explicitly allows it.

Hint should recommend legal current actions, not expose face-down identities.

---

# 96. Search With Hidden Information

From a game-state perspective, hidden cards are deterministic.

The Solver can plan through future reveals.

The player cannot see them, which creates strategic uncertainty, but the generated board remains fully known to the system.

---

# 97. Hint Fairness With Hidden Cards

**PROPOSED**

The Hint may use hidden information to choose a safe move but should phrase only the visible action.

Example:

Allowed:
`انقل المجموعة إلى العمود الفارغ.`

Not allowed:
`حرّكها لأن تحتها كارت فواكه مخفي.`

---

# 98. Search Terminal Win State

A state is terminal win when:

- All Tableau columns contain no cards.
- Stock contains no remaining playable/recyclable cards.
- All Associations are completed.
- All Association Slots are empty after automatic removals.

---

# 99. Search Terminal Failure State

Possible failure reasons:

- No legal winning continuation.
- Remaining Move budget exhausted before win.
- Invalid/corrupt state.
- Search timeout/inconclusive.

---

# 100. Search Action Representation

**PROPOSED**

A move object may include:

- `move_type`
- `source_type`
- `source_id`
- `target_type`
- `target_id`
- `movable_unit_id`
- `association_id`
- `move_cost = 1`

Possible move types:

- TableauToTableau
- TableauToEmpty
- TableauToAssociationSlot
- StockCardToTableau
- StockCardToAssociationSlot
- StockAdvance
- StockRestore
- TableauToActiveAssociation
- StockToActiveAssociation

Exact naming TBD.

---

# 101. Move Application

The Solver and Game Engine should ideally share a pure rule function:

`ApplyMove(state, move) -> new_state`

Responsibilities:

1. Validate move.
2. Deduct Move.
3. Move atomic unit.
4. Apply automatic reveal.
5. Apply Association completion.
6. Return canonical resulting state.

This reduces divergence.

---

# 102. Move Enumeration

Another shared/pure function:

`EnumerateLegalMoves(state)`

should return all currently legal actions.

The Solver can then search those actions.

---

# 103. Rule Engine Testing

Every move rule must have unit tests covering:

- Valid case.
- Invalid case.
- Boundary case.
- Stack case.
- Association Card case.
- Slot case.
- Empty Column case.
- Stock case.

---

# 104. Property-Based Testing

**PROPOSED**

Use property-based/randomized tests to assert invariants such as:

- Card conservation.
- One Association Card per Association.
- No stack contains mixed Association IDs.
- Association Stack cannot accept Member additions in Tableau.
- Completion removes exactly one full Association.
- Move counts never go negative unexpectedly.
- No card exists in two places simultaneously.

---

# 105. Solver Correctness Tests

Test categories:

- Known solvable handcrafted boards.
- Known unsolvable boards.
- Boards solvable exactly at Move Limit.
- Boards requiring Stock Restore.
- Boards requiring Association Card on Member Stack.
- Boards requiring Stack merge.
- Boards requiring empty column.
- Boards with slot pressure.
- Boards with multiple solution paths.
- Boards with tempting dead-end moves.

---

# 106. Golden Test Boards

**PROPOSED**

Maintain a versioned suite of canonical "golden" boards with known expected:

- Solvability.
- Minimum/reference Moves.
- Required key move.
- Hint.
- Dead-End behavior.

This protects against Solver regressions.

---

# 107. Differential Testing

**PROPOSED**

If two Solver implementations/prototypes exist, run them against the same generated boards and compare:

- Solvability.
- Move counts.
- Solution validity.

Useful during algorithm selection.

---

# 108. Solution Replay Validation

Every solution returned by Solver should be replayable through the authoritative Game Engine.

Pipeline:

`Solver solution`
→ `Game Engine replay`
→ Verify every move legal
→ Verify final win
→ Verify move count

Never trust Solver output without replay validation in QA/testing.

---

# 109. Hint Replay Validation

Hint move should be validated through the same rule engine before presentation.

If stale due to state change:

Discard and recompute.

---

# 110. Dead-End Validation Tests

For a state marked Dead End:

- Exhaustive/stronger Solver mode should confirm no solution for golden tests.
- Randomized regression tests should ensure no false-positive rate.

---

# 111. Board Generation Integration

Generator loop:

1. Shuffle.
2. Build Attempt state.
3. Solver Validate.
4. Difficulty Analyze.
5. Accept or reject.
6. Retry.

The Generator must not "repair" a rejected board silently unless the repair method is separately defined.

---

# 112. Generation Retry Strategy

**PROPOSED**

On rejection:

- Keep same Level content/config.
- Generate a new random shuffle.
- Re-run Solver.

Stop after technical maximum and invoke fallback policy.

---

# 113. Generation Fallback

Exact backend/generation fallback rules remain intentional **TBD**.

Guidance options (must remain Solver-valid):

- Use pre-generated validated Attempt.
- Use cached valid board for Level.
- Retry with larger time budget.
- Relax only non-core difficulty-window constraints.
- Never relax solvability or fixed Move Limit.
- Backend fallback available if needed.

---

# 114. Cached Valid Boards

**PROPOSED**

Maintain a small cache of validated Attempts per Level/config for:

- Slow devices.
- Emergency generation fallback.
- Faster first load.

Normal Restart can still request fresh generation when available.

---

# 115. Random Seed

The product does not require seed-history duplicate prevention.

However, **PROPOSED** engineering should retain a debug seed or equivalent shuffle reproduction token.

This is for:

- Bug reproduction.
- QA.
- Analytics investigation.

Not a player-facing feature.

---

# 116. Solver Determinism

Given:

- Same canonical state.
- Same Solver version.
- Same configuration.
- Same deterministic mode.

the Solver should ideally return the same chosen reference solution/hint.

This simplifies debugging.

---

# 117. Parallel Search

**PROPOSED**

For expensive analysis, candidate branches may be searched in parallel where platform/runtime permits.

Mobile battery/CPU impact must be considered.

---

# 118. Client vs Server Solver

**CONFIRMED** execution model: Hybrid.

- On-device Main Journey generation.
- On-device Hint/Dead-End where practical.
- Same Solver core reusable in CMS/CI/backend simulation (**Cloud Functions / Cloud Run** on Firebase/GCP).
- Backend fallback available if needed.

**CONFIRMED** implementation language: Pure Dart.

Whether native optimization is ever necessary remains intentional **TBD**.

Azure is **not** used for Solver backend simulation in MVP.

---

# 119. Solver Placement

**CONFIRMED**

Solver core is a Pure Dart library that can run:

- On-device (Main Journey generation; Hint/Dead-End where practical).
- In automated CMS/CI/backend simulation.
- With backend fallback when needed.

Exact composition, timeouts, and fallback rules remain intentional **TBD**.

---

# 120. Offline Requirements

**CONFIRMED**

Main Journey is fully playable offline once required content is downloaded.

- On-device Solver supports generation and Hint/Dead-End where practical.
- Offline Coin spending allowed against locally reconciled balance (queued idempotent transactions).
- Purchases and Rewarded Ads require network.

---

# 121. Performance Metrics

Track:

- Solver duration.
- States explored.
- Peak memory.
- Cache hit rate.
- Generation retries.
- Hint latency.
- Dead-End latency.
- Battery/CPU impact on device if local.

---

# 122. Proposed User-Facing Performance Goals

**PROPOSED, not final**

Target experience:

- Normal board generation feels near-instant.
- Hint response does not feel like a long blocking operation.
- Dead-End detection appears promptly after a decisive move.
- Solver never freezes drag/animation UI.

Numeric milliseconds require benchmarking before approval.

---

# 123. Async Execution

Solver should not block the UI thread.

Search should run asynchronously or on appropriate worker execution.

Exact threading model depends on client stack.

---

# 124. Progress Feedback

Do not expose Solver technical progress to normal players.

If generation takes unusually long, show generic loading rather than:

`Searching 57,232 states...`

Admin tools may expose technical diagnostics.

---

# 125. Memory Limits

Search must have bounded memory behavior.

If transposition table reaches limits:

Possible policies are **PROPOSED**:

- Evict least useful states.
- Switch to iterative deepening.
- Fail inconclusive and retry new board.
- Escalate to deeper/server analysis if available.

---

# 126. Search Termination Reasons

Recommended internal values:

- SOLVED
- UNSOLVABLE
- MOVE_LIMIT
- TIMEOUT
- MEMORY_LIMIT
- CANCELLED
- INVALID_STATE
- INTERNAL_ERROR

Exact enum names TBD.

---

# 127. Difficulty Integration

Solver metrics feed the Difficulty Model.

At minimum MVP should provide:

- Solvable.
- Reference Moves.
- Move Slack.
- Required Stock actions.
- Required Restores.
- Basic branch/dead-end metrics.
- Solver complexity metrics.

Semantic Difficulty comes from Content metadata, not Solver inference.

---

# 128. Solver Does Not Understand Arabic Meaning

The Solver does not need NLP to understand clue semantics.

The Content System already defines:

`Member Card → target Association`

Therefore semantic solving from the player's perspective is represented logically as known membership to the Solver.

This separation is intentional.

---

# 129. Solver and Semantic Ambiguity

Even when a Member appears semantically plausible for multiple clues:

- The Solver uses the approved target Association ID.
- The Game Engine rejects placement to any other Association.

Ambiguity affects player difficulty, not Solver legality.

---

# 130. Solver and Streak

Streak is not required for winning.

Therefore Solver search should not optimize Streak unless a future Hint mode explicitly wants to recommend higher-reward paths.

Current Hint priority is safe completion, not maximum Coins.

---

# 131. Optional Reward-Aware Hinting

**PROPOSED Post-MVP**

After basic Solver correctness is proven, Hint ranking could optionally prefer:

- Winning path.
- Then fewer Moves.
- Then better Streak opportunity.

This must never recommend a worse solvability path merely for Coins.

---

# 132. Solver and Economy

Board validation must ignore:

- Coin-funded Extra Moves.
- Ads.
- Rescue purchases.

A normal board is accepted only if solvable within its fixed Move Limit without monetization.

---

# 133. Solver and Restart

Restart creates a new random board.

Solver must run again.

A prior solution path cannot be reused unless the state is identical.

---

# 134. Solver and Daily Challenge

**CONFIRMED at launch**

Daily Challenge may use:

- Fixed content.
- Fixed shared/deterministic board per cohort.
- Fixed seed/config.

Solver can precompute:

- Solution.
- Reference Moves.
- Difficulty metrics.

This is useful for fairness.

---

# 135. Solver and Events/Packs

Same core rules should apply unless a future mode explicitly introduces a mechanic variant.

Do not fork Solver logic by content theme alone.

---

# 136. Admin Solver Tools

Admin/CMS should eventually expose:

- Validate Level.
- Generate sample Attempt.
- Show solvable/unsolvable.
- Show reference Move count.
- Show solution path.
- Show Difficulty metrics.
- Show rejection reason.
- Replay solution.
- Regenerate.

---

# 137. Solution Visualization

**PROPOSED**

Admin/debug UI may visualize moves:

1. Source.
2. Destination.
3. Move number.
4. Board state after move.
5. Association completions.
6. Stock actions.

Useful for QA and level tuning.

---

# 138. Solver Logs

Production logs should capture enough context to diagnose:

- Timeouts.
- Invalid states.
- Unexpected unsolvable boards.
- Hint failures.
- Dead-End false reports.

Avoid logging unnecessary personal data.

---

# 139. Analytics Fields

Recommended Solver analytics fields:

- `solver_version`
- `rules_version`
- `level_id`
- `attempt_id`
- `mode`
- `result`
- `duration_ms`
- `states_explored`
- `branches_explored`
- `reference_moves`
- `required_restores`
- `generation_retry_index`
- `rejection_reason`

---

# 140. Solver Versioning

Solver behavior must be versioned.

Changing:

- Search algorithm.
- Heuristic.
- Canonicalization.
- Pruning.
- Difficulty metric calculation.

may change output.

Store Solver version with generated Attempt analytics.

---

# 141. Rules Versioning

Solver must also receive a Game Rules version.

This protects future compatibility if gameplay rules change.

Example:

`rules_version = 1`

A Solver built for another rules version must not silently analyze incompatible states.

---

# 142. Backward Compatibility

If saved active sessions survive app updates:

- Solver must understand the state/rules version.
- Or the game must migrate/close incompatible sessions safely.

Exact migration policy belongs to Data/Architecture design.

---

# 143. Security Considerations

If Solver runs client-side:

- Do not treat Solver secrecy as a security boundary.
- Paid economy integrity must be protected elsewhere.
- Players may reverse engineer solution logic.

This is acceptable unless competitive Leaderboards later require stronger anti-cheat.

---

# 144. Competitive Integrity

If future Leaderboards compare Daily Challenge efficiency:

- Shared board.
- Server-validated result where necessary.
- Solver may be used internally for benchmark/reference.

No anti-cheat architecture is approved yet.

---

# 145. QA Simulation

Automated generation tests should repeatedly:

1. Generate board.
2. Solve.
3. Replay solution.
4. Verify final win.
5. Record metrics.
6. Verify difficulty window.
7. Repeat.

---

# 146. Simulation Scale

**CONFIRMED**

- Development: 1,000 Attempts/template (operational guidance).
- Release confidence: **10,000+ Attempts for critical Templates/Configs**.
- Smaller volumes allowed for simpler configurations.

---

# 147. Solver Regression Suite

Maintain tests for:

- Every core movement rule.
- Stock edge cases.
- Slot pressure.
- Association Stack rules.
- Empty columns.
- Unlimited Restore loops.
- Move-limit exact boundary.
- Multiple valid branches.
- Dead-End detection.
- Hint consistency.

---

# 148. Stock Edge Cases

Test at least:

- Stock with 1 card.
- Stock with 2 cards.
- Stock with 3 cards.
- Stock with >3 cards.
- Removing top exposes previous.
- Multiple playable removals.
- Restore after partial consumption.
- Repeated Restore.
- Restore loops.
- Stock empty.
- Stock card is Association Card.
- Stock card is Member Stack input candidate.

---

# 149. Association Edge Cases

Test:

- Association Card alone to Slot.
- Association Card on Member Card.
- Association Card on full Member Stack.
- Association Stack to Slot.
- Association Stack immediately completes.
- Association Stack partially fills.
- Attempt to add Member to Association Stack in Tableau → invalid.
- Attempt Member onto Association Card in Tableau → invalid.
- Complete Members in Tableau without Association Card → no completion.

---

# 150. Stack Edge Cases

Test:

- Single Member treated as movable unit.
- Merge 1+1.
- Merge 1+N.
- Merge N+M.
- Move full stack to empty column.
- Move full stack to active Association.
- No partial stack movement.
- Internal order invariance.

---

# 151. Slot Edge Cases

Test:

- No empty Slot.
- One empty Slot.
- Multiple empty Slots.
- Association completion frees Slot.
- Move Association Stack into empty Slot.
- Attempt wrong Association Member into active Slot.
- Multiple active Associations.

---

# 152. Move Limit Edge Cases

Test:

- Solve with exactly 0 Moves remaining.
- Reference Moves equals Move Limit.
- Solution exceeds Move Limit by one.
- Stock Restore consumes final Move.
- Completion occurs on final Move.
- Automatic completion costs no extra Move.

---

# 153. Dead-End Edge Cases

Test:

- Structural Dead End.
- Move-budget Dead End.
- State recoverable by Undo.
- State recoverable only by paid/ad rescue.
- False-looking trap that still has a solution.
- Dead End after Stock action.
- Dead End after Stack merge.

---

# 154. Hint Edge Cases

Test:

- One winning move.
- Multiple winning moves.
- Only Stock Advance is winning.
- Restore required.
- Empty-column move required.
- Association activation required.
- Hint after player state changed.
- Hint when already dead.
- Hint when 0 Moves remain.

---

# 155. Solver Acceptance Criteria — Functional

A production Solver must:

- Never return an illegal move.
- Never accept an unsolvable board as solved.
- Replay returned solution successfully.
- Respect Move Limit.
- Correctly model Stock.
- Correctly model atomic Stacks.
- Correctly model Association Card inactivity in Tableau.
- Correctly model automatic completion/removal.

---

# 156. Solver Acceptance Criteria — Hint

A production Hint must:

- Be legal in the current exact state.
- Not auto-execute.
- Lead to a proven/best-known winning continuation according to configured confidence policy.
- Not reveal hidden-card content in player-facing text.
- Recompute after state changes.

---

# 157. Solver Acceptance Criteria — Dead End

A Dead-End warning must:

- Be based on the exact current state.
- Avoid false positives.
- Distinguish timeout/inconclusive internally.
- Never show "dead end" merely because Solver timed out.

---

# 158. Solver Acceptance Criteria — Performance

Exact budgets are TBD.

Release validation must define:

- P50/P95 board-generation solve time.
- P50/P95 Hint time.
- Dead-End check time.
- Peak memory.
- Acceptable timeout/retry rate.

---

# 159. MVP Solver Scope

P0 Solver capabilities:

- Full Game Rules model.
- Solvability validation.
- Move-Limit validation.
- Reference solution.
- Hint generation.
- Dead-End detection.
- Replay validation.
- State hashing/canonicalization.
- Loop prevention.
- Basic difficulty metrics.
- Generation rejection reason.
- Automated simulation.

P1/Optimization:

- Proven exact minimum Moves for all boards.
- Deep branch statistics.
- Advanced safe-branch metrics.
- Aggressive incremental solving.
- Large persistent caches.
- Advanced admin visualization.

---

# 160. Proposed Technical Phases

**PROPOSED**

## Phase 1 — Correctness Prototype
- Implement state.
- Implement moves.
- DFS/BFS prototype.
- Golden boards.
- Solution replay.

## Phase 2 — Bounded Solver
- Move Limit.
- Memoization.
- Canonicalization.
- Stock loops.
- Hint.
- Dead End.

## Phase 3 — Performance
- Heuristics.
- Search ordering.
- Transposition optimization.
- State compression.
- Benchmarking.

## Phase 4 — Difficulty Metrics
- Reference Moves.
- Branch metrics.
- Restore metrics.
- Completion timing.

## Phase 5 — Production Integration
- Generator.
- Game client.
- CMS.
- Analytics.
- Simulation pipeline.

This implementation sequencing is proposed, not yet a delivery plan.

---

# 161. Solver Decision Register — Confirmed

The Solver must support these **CONFIRMED** product requirements:

1. Validate entire randomized board.
2. Validate Tableau + Stock + hidden reveals + Slots.
3. Confirm solvability.
4. Confirm solvability within fixed Move Limit.
5. Support Hint.
6. Support Dead-End Detection.
7. Respect atomic unsplittable Stacks.
8. Treat Association Card in Tableau as inactive.
9. Allow Association Card → same-group Member Stack.
10. Disallow Member Stack → Association Card in Tableau.
11. Lock Association Stack against further additions in Tableau.
12. Allow Association Stack → Slot.
13. Allow Member Stack → matching Active Association.
14. Respect Stock's three-visible/top-playable behavior.
15. Respect unlimited same-order Restore.
16. Count Stock Advance and Restore as Moves.
17. Treat every Stack move as one Move.
18. Apply automatic reveal.
19. Apply automatic Association completion.
20. Win only when all cards are cleared.
21. Re-run after every Restart because shuffle changes.
22. Hints must recommend but not execute.
23. Player remains free to ignore Hint and choose any legal move.
24. Implementation language: Pure Dart.
25. Search direction: hybrid search with canonicalization/memoization/bounded search.
26. Execution model: Hybrid — on-device Main Journey generation; on-device Hint/Dead-End where practical; same core in CMS/CI/backend; backend fallback available.
27. Release simulation: 10,000+ boards for critical Templates/Configs.
28. Main Journey fully playable offline once required content is downloaded.
29. Daily Challenge included at launch.

---

# 162. Solver Decision Register — Proposed / Requires Approval

The following remain **PROPOSED** or intentional **TBD**:

1. Solver execution modes.
2. Exact Solver algorithm composition after benchmarking (intentional TBD).
3. Canonical state representation details.
4. Empty Slot symmetry reduction.
5. Empty Column symmetry reduction.
6. Transposition-table strategy.
7. Dominance pruning.
8. Lower-bound heuristics.
9. Search move ordering.
10. Structural vs Move-Budget Dead-End distinction.
11. Hint ranking rules.
12. Hint confidence levels.
13. Incremental solving.
14. Cache policy.
15. Debug seed retention.
16. Cached valid boards.
17. Exact generation/backend fallback rules (intentional TBD).
18. Exact timeout/performance budgets (intentional TBD).
19. Whether native optimization is ever necessary (intentional TBD).
20. Exact minimum vs best-known policy.
21. Advanced difficulty metrics.
22. Reward-aware Hinting later (**DEFERRED Post-MVP**).

---

# 163. Recommended Approval Order

Before implementation architecture is frozen:

1. Approve Solver state model.
2. Approve exact Stock state semantics with Game Engine.
3. Approve structural vs Move-Budget Dead-End behavior.
4. Approve minimum-vs-reference requirement.
5. Build algorithm prototypes.
6. Benchmark representative Level sizes.
7. Select exact search algorithm composition (intentional TBD until then).
8. Approve canonicalization/pruning rules.
9. Approve Hint safety policy.
10. Define exact generation fallback rules (intentional TBD until then).
11. Define exact performance budgets (intentional TBD until then).
12. Integrate Difficulty metrics.

---

# 164. Open Questions Before Final Solver Implementation

The following still require explicit resolution (intentional TBD where noted):

1. Exact internal Stock cycle representation/transition semantics.
2. Whether Dead-End UI triggers on structural impossibility only or also insufficient remaining Moves.
3. Whether minimum Moves must be mathematically proven for every accepted board or reference-best-known is sufficient.
4. Exact Solver algorithm composition after benchmarking.
5. Exact timeout/performance budgets.
6. Whether native optimization is ever necessary.
7. Exact backend fallback rules.
8. Exact generation timeout/fallback policy.
9. Whether pre-generated cached boards are allowed as fallback.
10. Exact Difficulty metrics required in MVP.
11. Exact rescue-state transformation.

Hybrid placement (Pure Dart + hybrid execution) is **CONFIRMED** and no longer open.

---

# 165. Recommended MVP Solver Baseline

The safest MVP Solver baseline is:

- One Pure Dart canonical rule engine shared with gameplay.
- Full state search over Tableau, Stock, Slots, hidden cards, and atomic Stacks.
- Move-bounded solvability as a hard generation requirement.
- Reference solution retained for every accepted board.
- State hashing + dominance pruning.
- Explicit handling of unlimited Stock Restore cycles.
- Hint = next move from a verified winning continuation.
- Dead-End = no verified winning continuation from current state.
- Hybrid execution: on-device Main Journey gen; Hint/Dead-End on-device where practical; same core CMS/CI/backend; backend fallback available.
- Solver metrics recorded for Difficulty calibration.
- Every Solver solution replay-validated through Game Engine logic.
- No monetization/rescue assumed in initial-board solvability.
- 10,000+ simulation for critical Templates/Configs.

---

# 166. Dependencies

This Solver Specification directly feeds:

1. **Game Engine Technical Design**
2. **Level Generator Specification**
3. **Data Model**
4. **Software Architecture**
5. **Backend & Cloud Architecture**
6. **QA & Automated Game Validation Strategy**
7. **Analytics & KPI Specification**
8. **CMS Level Preview/Validation**

---

# 167. Baseline Status

This document is **Solver Specification v1.0** (Decision-Aligned to Final Decision Register v1.1).

It defines the functional responsibilities, state model, rule constraints, search requirements, Hint behavior, Dead-End behavior, difficulty outputs, QA expectations, and production integration boundaries for the Solver.

Register-approved Pure Dart / hybrid search / hybrid execution / simulation / offline decisions are **CONFIRMED**. Backend simulation and optional fallback use Firebase/GCP serverless (Cloud Functions / Cloud Run); Azure is **SUPERSEDED** for MVP. Exact algorithm composition, timeouts, native opt, and exact backend fallback rules remain intentional **TBD** (Register §14).

**End of Solver Specification v1.0**
