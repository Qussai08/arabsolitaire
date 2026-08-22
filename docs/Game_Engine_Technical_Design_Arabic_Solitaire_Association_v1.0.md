# Game Engine Technical Design
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source Documents:** Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Screen Inventory & User Flows v1.0 + Content Design System v1.0 + Arabic Content Guidelines v1.0 + Level Design Framework v1.0 + Difficulty Model v1.0 + Solver Specification v1.0 + Final Decision Register v1.1  
**Important:** Register-approved items are **APPROVED/CONFIRMED** (Engine independent of UI/state management; Pure Dart Solver; Flutter/Riverpod/Drift client stack; identity/offline/conflict per Register §7). Exact rescue transform remains intentional **TBD**. Module naming, performance budgets, and similar engineering details stay **PROPOSED/TBD** until calibrated.

---

# 1. Purpose

This document defines the technical design of the runtime Game Engine that executes the Solitaire Association gameplay.

The Game Engine is responsible for:

- Loading a Level Attempt.
- Representing gameplay state.
- Validating and applying player Moves.
- Managing Tableau, Stock, Stacks, and Association Slots.
- Updating Move count.
- Updating in-level streak state.
- Applying automatic reveals.
- Completing Associations.
- Detecting win/failure states.
- Integrating with Solver for Hint and Dead-End checks.
- Producing deterministic state transitions.
- Supporting Restart.
- Supporting Undo.
- Supporting persistence/resume.
- Emitting analytics events.
- Providing a stable API to the UI layer.

The Game Engine must remain independent from visual layout, animation, Arabic text rendering, Ads, Store UI, and other presentation concerns.

---

# 2. Engine Design Goals

The engine should be:

- Deterministic.
- Testable.
- UI-independent.
- Platform-independent where practical.
- Serializable.
- Replayable.
- Solver-compatible.
- Resistant to invalid state creation.
- Suitable for automated simulation.
- Efficient enough for mobile gameplay.

---

# 3. Engine Responsibilities

The Game Engine owns:

1. Game state.
2. Core rules.
3. Move legality.
4. Move execution.
5. Move accounting.
6. Atomic stack behavior.
7. Tableau reveal.
8. Stock transitions.
9. Association activation.
10. Association completion.
11. Win detection.
12. Undo snapshot/state restoration.
13. Attempt lifecycle.
14. Runtime integration hooks for Solver.
15. Gameplay events.

---

# 4. Engine Non-Responsibilities

The Game Engine should not own:

- Arabic localization strings.
- UI rendering.
- Animations.
- Ad SDK logic.
- Native store purchase logic.
- Cloud authentication.
- CMS authoring.
- Remote notification scheduling.
- Semantic interpretation of Arabic clues.
- AI content generation.
- Real-money economy logic.

It may expose hooks/events consumed by those systems.

---

# 5. Architectural Principle

**PROPOSED**

Use a pure-state-transition architecture:

`GameState + GameAction -> GameStateTransition`

Where a transition returns:

- New State.
- Validation result.
- Gameplay Events.
- Move cost.
- Optional Solver-trigger requirement.

This allows:

- Deterministic tests.
- Replays.
- Solver reuse.
- Undo.
- Save/resume.
- Analytics consistency.

---

# 6. Core Engine Modules

**PROPOSED**

Recommended internal modules:

1. `GameState`
2. `RuleEngine`
3. `MoveGenerator`
4. `MoveExecutor`
5. `TableauEngine`
6. `StockEngine`
7. `AssociationEngine`
8. `StackEngine`
9. `MoveCounter`
10. `StreakEngine`
11. `UndoEngine`
12. `AttemptLifecycle`
13. `WinEvaluator`
14. `DeadEndCoordinator`
15. `HintCoordinator`
16. `SolverAdapter`
17. `StateSerializer`
18. `ReplayEngine`
19. `GameplayEventBus`
20. `Diagnostics`

Exact class names are TBD.

---

# 7. Shared Rule Model

The Game Engine and Solver should share the same authoritative rule primitives where possible.

For example:

- `EnumerateLegalMoves(state)`
- `ValidateMove(state, action)`
- `ApplyMove(state, action)`
- `NormalizeState(state)`

This reduces the risk of:

- Solver accepting illegal moves.
- UI allowing moves Solver rejects.
- Different Stack semantics in client and simulation.

---

# 8. Game State

A full Game State should include:

- Attempt ID.
- Level ID.
- Rules Version.
- Level Configuration.
- Move Limit.
- Moves Remaining.
- Tableau.
- Stock.
- Association Slots.
- Completed Association IDs.
- Current Streak state.
- Undo state.
- Attempt status.
- Attempt metadata.
- Optional last action metadata.

---

# 9. Attempt Status

**PROPOSED**

Suggested states:

- `INITIALIZING`
- `READY`
- `ACTIVE`
- `PAUSED`
- `DEAD_END`
- `OUT_OF_MOVES`
- `COMPLETING_ASSOCIATION`
- `WON`
- `FAILED`
- `RESTARTING`
- `ABANDONED`

Only some need to exist in the pure domain model; UI-only transient states may remain outside the engine.

---

# 10. Card Model

Each physical card instance should include:

- `card_id`
- `card_kind`
- `association_id`
- `content_id`
- `content_type`

`card_kind`:

- `ASSOCIATION`
- `MEMBER`

The engine must never rely on display text to determine compatibility.

---

# 11. Association Definition Runtime Model

Per Level/Attempt, each Association should include:

- `association_id`
- `required_member_count`
- `member_card_ids`
- `association_card_id`

The runtime engine only needs membership and completion information.

Semantic metadata remains in the Content layer.

---

# 12. Movable Unit Model

A Movable Unit may be:

- Single Member Card.
- Single Association Card.
- Member Stack.
- Association Stack.

Suggested fields:

- `unit_id`
- `association_id`
- `member_card_ids`
- `association_card_id?`
- `contains_association_card`
- `unit_type`

---

# 13. Atomic Stack Rule

**CONFIRMED**

Once cards are stacked, the Stack cannot be split.

The Engine must enforce this invariant in:

- Move generation.
- Drag/drop validation.
- Solver.
- Undo.
- Serialization.
- Replay.

---

# 14. Stack Internal Order

**CONFIRMED**

Internal Stack order is not gameplay-relevant.

The Engine may preserve visual insertion order for animation/UI if desired, but rule logic must treat the Stack as an atomic same-Association unit.

---

# 15. Member Stack

A Member Stack:

- Contains only Member Cards.
- All Cards share one `association_id`.
- Can accept same-Association Members/Member Stacks.
- Can receive its Association Card.
- Can move as one unit.
- Can move to an empty Tableau column.
- Can move into matching Active Association.

---

# 16. Association Stack

An Association Stack in Tableau:

- Contains one Association Card.
- May contain zero or more matching Members.
- Is inactive.
- Cannot accept new Member Cards while in Tableau.
- Moves as one unit.
- Can move to an empty Tableau column.
- Can move to an empty Association Slot.

---

# 17. Tableau Model

A Tableau contains a variable number of Columns.

Each Column should logically contain:

- Hidden cards in deterministic order.
- One exposed movable unit, or
- Empty state.

The engine should separate:

- Hidden card sequence.
- Exposed unit.

This simplifies reveal logic.

---

# 18. Tableau Column Invariant

At runtime, a non-empty column must have exactly one exposed top-level movable unit.

When it moves away:

- Next hidden Card becomes exposed automatically.
- If no hidden Card remains, the column becomes Empty.

---

# 19. Empty Column Rule

**CONFIRMED**

Any valid movable unit can be moved into an Empty Tableau column.

That includes:

- Member Card.
- Association Card.
- Member Stack.
- Association Stack.

---

# 20. Tableau Placement Validation

The Rule Engine must evaluate:

## Member → Member/Member Stack
Valid only if same `association_id`.

## Member Stack → Member/Member Stack
Valid only if same `association_id`.

## Association Card → Member/Member Stack
Valid only if same `association_id`.

## Member/Stack → Association Card in Tableau
Invalid.

## Member/Stack → Association Stack in Tableau
Invalid.

## Any movable unit → Empty Tableau
Valid.

---

# 21. Tableau Merge Result

When same-Association Member units merge:

- A new atomic Member Stack is formed.
- All Members are preserved.
- No duplicate Card IDs.
- Association ID remains unchanged.
- Internal order remains non-semantic.

---

# 22. Association Card Joining a Member Stack

When an Association Card is moved onto a compatible Member Card/Stack:

- Result becomes Association Stack.
- Association Stack becomes locked against new additions while in Tableau.
- Existing Members remain attached.
- Entire unit moves together.

---

# 23. Association Slot Model

A Slot is either:

- Empty.
- Active Association.

Active Association state:

- `association_id`
- `association_card_id`
- `member_card_ids`
- `required_member_count`

---

# 24. Association Activation

**CONFIRMED**

An Association becomes active only when its Association Card is placed in an Empty Association Slot.

Association Card in Tableau remains inactive.

---

# 25. Association Stack Activation

When an Association Stack moves to an Empty Slot:

- Association becomes active.
- All attached Members immediately count toward progress.
- The move costs exactly one Move.
- Completion is checked immediately.

---

# 26. Member to Active Association

A single Member Card may move to a matching Active Association.

Valid only when:

`member.association_id == active_association.association_id`

---

# 27. Stack to Active Association

A full Member Stack may move to a matching Active Association.

All Members transfer in one Move.

The Stack cannot split before or during transfer.

---

# 28. Completion Rule

**CONFIRMED**

When:

`active_member_count == required_member_count`

the Association completes automatically.

Automatic transition:

1. Remove Association Card.
2. Remove Member Cards.
3. Mark Association Complete.
4. Free Slot.
5. Emit completion event.
6. Check Win.

No extra Move is consumed.

---

# 29. Completion Undo Restriction

**CONFIRMED**

If the last Move caused Association completion/removal:

Undo is unavailable for that Move.

The engine must record whether the last action created irreversible completion.

---

# 30. Stock Model

The Stock must represent:

- Ordered remaining/recyclable Cards.
- Current exposed state.
- Playable top Card.
- Restore/cycle state.

The exact internal representation must match the approved observable behavior.

---

# 31. Stock Observable Behavior

**CONFIRMED**

- Up to the last 3 exposed Stock cards are visible.
- Only the final/top exposed Card is playable.
- Removing it makes the previous exposed Card playable.
- Advance costs 1 Move.
- Restore costs 1 Move.
- Restore is unlimited.
- Restore keeps the same order of remaining Stock cards.
- Restore does not shuffle.

---

# 32. Stock Engine Requirement

The Stock Engine must provide deterministic operations equivalent to:

- `CanAdvance`
- `Advance`
- `GetPlayableCard`
- `RemovePlayableCard`
- `CanRestore`
- `Restore`
- `GetVisibleWindow`

Exact names TBD.

---

# 33. Stock Visible Window

The engine should expose:

`visible_stock_cards`

ordered according to UI display requirements.

The UI shows at most three.

Only one card should be flagged:

`is_playable = true`

---

# 34. Stock Removal

When the playable Stock Card is moved:

- Remove it from Stock ownership.
- Promote previous exposed card to playable if applicable.
- Do not spend an additional Move for the promotion.
- Spend one Move for the actual move destination action.

---

# 35. Stock Advance Move

A Stock Advance:

- Is a legal Engine Action.
- Costs one Move.
- Does not increase or reset correct-action streak.
- May cause Out-of-Moves if it spends the final Move without winning.

---

# 36. Restore Stock Move

Restore:

- Is a legal Engine Action.
- Costs one Move.
- Is neutral for streak.
- Preserves remaining card order.
- May be used repeatedly.

---

# 37. Move Model

**PROPOSED**

A Game Action should be a typed command.

Potential types:

- `MoveTableauUnitToTableau`
- `MoveTableauUnitToSlot`
- `MoveTableauUnitToActiveAssociation`
- `MoveStockCardToTableau`
- `MoveStockCardToSlot`
- `MoveStockCardToActiveAssociation`
- `AdvanceStock`
- `RestoreStock`
- `Undo`
- `Restart`
- `Pause`
- `Resume`

Not all lifecycle commands need to be Rule Engine actions.

---

# 38. Move Cost

**CONFIRMED**

All core gameplay moves cost exactly 1 Move:

- Stock Advance.
- Restore.
- Card move.
- Stack move.
- Association activation.
- Member transfer to Active Association.
- Association Stack to Slot.

No move has variable cost based on stack size.

---

# 39. Invalid Move

**CONFIRMED**

Invalid Move:

- Is rejected.
- Does not mutate state.
- Does not consume Move.
- Resets current correct-action streak.
- Does not reduce unlocked streak tier.

The Engine should emit an `InvalidMove` event even though the board state remains unchanged.

---

# 40. Valid Move Transition Order

**PROPOSED**

Recommended deterministic sequence:

1. Validate action.
2. Capture undo snapshot if eligible.
3. Apply move.
4. Deduct Move.
5. Apply automatic reveal.
6. Apply Association progress.
7. Apply Association completion.
8. Update Streak.
9. Evaluate Win.
10. Evaluate Out-of-Moves.
11. Emit gameplay events.
12. Request Dead-End analysis if still active.

This sequence should be frozen and tested because event ordering matters.

---

# 41. Correct-Action Streak

**CONFIRMED**

Tier sequence:

- 3 correct → +3 Coins.
- Then 4 correct → +4 Coins.
- Then 5 correct → +5 Coins.
- Remain at 5/5 thereafter.

Wrong action resets current counter only.

Tier never downgrades inside the Level.

---

# 42. Correct Streak Actions

**CONFIRMED**

Examples:

- Member → same-group Member/Stack.
- Stack → same-group Stack.
- Association Card → correct Member Stack.
- Association Card → Association Slot.
- Member/Stack → matching Active Association.
- Association Stack → Association Slot.

Each successful action = +1 streak progress.

---

# 43. Neutral Streak Actions

**CONFIRMED**

- Stock Advance.
- Restore Stock.
- Move unit to Empty Tableau column.

Neutral actions:

- Cost Moves normally.
- Do not increase streak.
- Do not break streak.

---

# 44. Wrong Streak Action

**CONFIRMED**

Any invalid rejected action:

- Resets current streak counter.
- Does not alter tier.

---

# 45. Streak State Model

Suggested fields:

- `tier_requirement` ∈ {3,4,5}
- `current_count`
- `coins_earned_from_streak`

When requirement reached:

- Emit reward event.
- Add Coins through Economy integration.
- Upgrade requirement 3→4→5.
- Reset current_count to 0.

---

# 46. Economy Boundary

The Engine may calculate gameplay-earned Coin rewards but should not directly own the global Wallet implementation.

Recommended boundary:

Engine emits:

- `StreakCoinsEarned(amount)`
- `LevelRewardCalculated(...)`

Economy/Wallet service persists Coin balance.

---

# 47. Level Completion Reward

**CONFIRMED**

On Win:

`Total = 50 Base + (Remaining Moves × 2) + Streak Coins already earned`

The Engine should expose a deterministic reward breakdown.

---

# 48. Move Counter Model

State includes:

- `move_limit`
- `moves_remaining`

On valid Move:

`moves_remaining -= 1`

Invalid Move leaves it unchanged.

Undo restores one consumed Move.

---

# 49. Final-Move Win

If the player performs a valid winning Move when:

`moves_remaining == 1`

the Move is applied:

`moves_remaining -> 0`

then completion/win is processed.

Win takes precedence over Out-of-Moves failure.

---

# 50. Out-of-Moves Rule

If after a valid move:

- `moves_remaining == 0`
- and Board is not won

the Engine status becomes:

`OUT_OF_MOVES`

UI may offer Extra Moves.

---

# 51. Extra Moves Integration

**CONFIRMED**

- Extra Moves grant: +5 Moves.
- Max 2 Extra-Move rescues per Attempt.
- Pricing: first rescue 150 Coins; second rescue 250 Coins.
- Rewarded Ads supported for Extra Moves.

Extra Moves are granted outside normal core solving.

The Engine should support:

`GrantExtraMoves(amount)`

subject to validated Economy/UI flow.

This operation:

- Does not count as a gameplay Move.
- Does not affect streak.
- Returns attempt status to Active if appropriate.
- Must enforce max 2 grants per Attempt.

---

# 52. Dead-End Integration

The Engine itself may not perform deep solvability search.

Recommended:

- Engine produces current canonical state.
- Dead-End Coordinator calls Solver.
- Solver returns result.
- Coordinator updates gameplay status if confirmed.

---

# 53. Dead-End Status

**PROPOSED**

Internally distinguish:

- Structural Dead End.
- Move-Budget Dead End.

Whether both appear as the same UI state is TBD.

---

# 54. Dead-End False Positive Rule

The engine/UI must never mark state as Dead End merely because Solver timed out.

Only a confirmed result may transition to Dead-End status.

---

# 55. Hint Integration

Flow:

1. UI requests Hint.
2. Resource layer checks Hint availability.
3. Engine exports exact current state.
4. Solver returns recommended structured Move.
5. Engine revalidates Move against current state.
6. UI shows textual/highlight hint.
7. Player chooses whether to execute.

Hint never auto-executes.

---

# 56. Hint Staleness

If Game State changes after Hint request:

- Returned Hint must be discarded if state version no longer matches.

Recommended:

Include `state_revision` in Solver request/response.

---

# 57. State Revision

**PROPOSED**

Increment `state_revision` after every committed state mutation.

Use it for:

- Hint staleness.
- Dead-End result staleness.
- Async race prevention.
- Save conflict diagnostics.

---

# 58. Undo State

Undo supports only the most recent eligible Move.

Suggested data:

- `previous_state_snapshot`
- `undo_available`
- `last_move_was_undo`
- `last_move_caused_completion`

Only one snapshot is required.

---

# 59. Undo Eligibility

Undo is available if:

- There was an eligible previous Move.
- Last Move was not Undo.
- Last Move did not complete an Association.
- Attempt is still in a state that allows Undo.

---

# 60. Undo Execution

Undo:

1. Restore previous state snapshot.
2. Restore spent Move automatically as part of snapshot.
3. Preserve no second-level undo history.
4. Mark `last_move_was_undo = true`.
5. Disable Undo until next new Move.

---

# 61. Undo and Streak

The exact approved behavior only specifies Move restoration and one-step Undo.

How Undo affects streak state should follow the restored snapshot for deterministic rollback.

**PROPOSED**

Undo should restore the full gameplay state including streak counter/tier to the exact pre-Move state.

This is the technically consistent approach but requires explicit approval if product wants different behavior.

---

# 62. Restart Lifecycle

**CONFIRMED**

Restart:

- Same Level Configuration.
- Same Level content.
- Same Move Limit.
- New full shuffle.
- New Solver validation.

Attempt-specific state resets.

Persistent Wallet/resources already spent do not automatically refund unless product rules explicitly say so.

---

# 63. Restart Engine Boundary

The current Engine should close old Attempt and receive a newly generated Attempt definition/state from Level Generator.

Recommended:

`AttemptLifecycle.Restart()` should not directly implement random shuffle logic.

Level Generator owns generation.

---

# 64. Initial Attempt Loading

Engine input should be a validated Attempt containing:

- Selected content.
- Card distribution.
- Hidden order.
- Stock state.
- Empty Association Slots.
- Move Limit.
- Solver validation metadata.

The Engine should still run structural sanity checks.

---

# 65. Engine Structural Validation

Before entering READY:

Verify:

- All expected Cards exist exactly once.
- No duplicate Card ownership.
- Every Member belongs to valid Association.
- Exactly one Association Card per Association.
- Tableau/Stock totals match.
- Slots start valid.
- Move Limit > 0.
- No invalid Stack composition.

---

# 66. Card Conservation Invariant

At all times, every non-completed Card must exist in exactly one location:

- Hidden Tableau.
- Exposed Tableau Unit.
- Stock.
- Active Association.

Completed cards exist only in completion history/metadata, not active board containers.

---

# 67. Association Conservation

Each Association has one Association Card.

Its lifecycle is exactly one of:

- In Tableau.
- In Stock.
- In Active Slot.
- Completed.

Never two locations simultaneously.

---

# 68. Member Conservation

Each Member Card has one active location or is Completed.

No Member may exist in:

- Tableau and Slot simultaneously.
- Two Stacks.
- Stock and Tableau simultaneously.

---

# 69. State Immutability

**PROPOSED**

Prefer immutable or copy-on-write Game State transitions.

Benefits:

- Undo.
- Solver compatibility.
- Replay.
- Testing.
- Async safety.

If mutable implementation is chosen for performance, externally observable transitions should still behave atomically.

---

# 70. State Snapshot

A snapshot should be serializable and contain all gameplay-relevant state.

Potential uses:

- Undo.
- Save/resume.
- Crash recovery.
- Replay.
- Debugging.

---

# 71. Serialization

Game State should be serializable with:

- Schema version.
- Rules version.
- Attempt ID.
- Level version.
- Content IDs.
- Board state.
- Moves.
- Streak.
- Undo metadata if persistence requires it.

Exact format is TBD.

---

# 72. Active Session Persistence

**CONFIRMED** (Final Decision Register v1.1 §7)

Active Attempt persistence is **local-first in Drift / SQLite**.

Active Attempt is device-specific under the domain-specific cloud conflict policy.

Durable cloud state includes progression/economy; Active Attempt remains local/device-specific.

Cloud sync must minimize Firestore reads/writes and avoid per-Move cloud traffic.

---

# 73. Local Save Timing

**PROPOSED**

Persist active attempt after:

- Every committed Move, or
- Debounced short interval with immediate flush on background.

Exact strategy depends on performance.

---

# 74. Crash Recovery

On relaunch:

- Load latest valid local snapshot.
- Validate schema/rules version.
- Validate state invariants.
- Resume or safely restart Level if snapshot incompatible/corrupt.

Never restore an invalid board silently.

---

# 75. Replay Engine

**PROPOSED**

Store action log for debug/replay purposes:

- Initial Attempt state.
- Sequence of Game Actions.
- Outcome.

This enables deterministic reproduction.

Player-facing replay is not required.

---

# 76. Deterministic Replay

Given:

- Same initial Attempt.
- Same rules version.
- Same action sequence.

the Engine should reach identical final state.

This is a core testability target.

---

# 77. Gameplay Event Model

The Engine should emit structured domain events.

Examples:

- `MoveAccepted`
- `MoveRejected`
- `CardRevealed`
- `StackCreated`
- `StackMerged`
- `AssociationActivated`
- `AssociationProgressed`
- `AssociationCompleted`
- `SlotFreed`
- `StockAdvanced`
- `StockRestored`
- `StreakProgressed`
- `StreakRewardEarned`
- `UndoApplied`
- `MovesExhausted`
- `LevelWon`

---

# 78. Event Ordering

Events from a single action must have deterministic ordering.

Example final Association move:

1. MoveAccepted
2. MovesChanged
3. AssociationProgressed
4. AssociationCompleted
5. SlotFreed
6. LevelWon
7. RewardCalculated

UI animation orchestration can consume these in sequence.

---

# 79. UI Animation Boundary

The Engine does not wait for animations to complete before computing state.

UI may queue animations from emitted events.

This prevents rules from being tied to frame timing.

---

# 80. Input Locking

The UI layer should temporarily lock conflicting drag input during critical animation transitions such as Association removal if necessary.

The Engine should remain authoritative regardless of UI lock timing.

---

# 81. Interaction Validation

UI may perform optimistic target highlighting, but only Engine validation determines whether a drop is legal.

Do not duplicate full rules only in UI.

---

# 82. Drag Source Model

UI should refer to a domain `MovableUnitId`.

It should not reconstruct Stack membership from rendered cards.

---

# 83. Drag Destination Model

Potential domain destination types:

- Tableau Column.
- Association Slot.
- Active Association.
- Invalid/none.

The UI maps physical drop coordinates to one of these domain targets.

---

# 84. Validation Result

**PROPOSED**

Move validation returns structured result:

- `is_valid`
- `reason_code`
- `move_category`
- `streak_effect`
- `move_cost`

Reason codes help:

- UI feedback.
- Analytics.
- Tests.

---

# 85. Invalid Reason Codes

Possible internal codes:

- `WRONG_ASSOCIATION`
- `TARGET_LOCKED_ASSOCIATION_STACK`
- `MEMBER_TO_INACTIVE_ASSOCIATION`
- `SLOT_OCCUPIED`
- `NO_EMPTY_SLOT`
- `INVALID_SOURCE`
- `STOCK_CARD_NOT_PLAYABLE`
- `STACK_SPLIT_NOT_ALLOWED`

Names are proposed.

---

# 86. Stack Split Protection

The engine must reject any action targeting only part of an existing Stack.

UI should never offer partial drag handles.

Solver must never enumerate partial moves.

---

# 87. Automatic Reveal

When top exposed unit leaves a Tableau column:

- Engine reveals exactly the next hidden Card.
- That Card becomes a new single exposed unit.
- No Move cost.
- Emit `CardRevealed`.

---

# 88. Reveal Chain

Only one card is automatically revealed per emptied top unit because only the next hidden card becomes topmost.

No cascade reveal beyond this unless future rules change.

---

# 89. Win Evaluation

After every committed Move and automatic completion:

Check:

- All Tableau empty.
- Stock empty/no remaining cards.
- All Associations completed.

If true:

`status = WON`

---

# 90. Win Precedence

Win evaluation occurs before Out-of-Moves failure.

This ensures final-Move wins are valid.

---

# 91. Failure Evaluation

Normal gameplay failure states:

- Out of Moves.
- Confirmed Dead End.
- Player abandons/restarts.

The Engine should distinguish them internally for analytics.

---

# 92. Pause State

Pause is mostly presentation/session lifecycle.

No gameplay state mutation should occur while paused.

Solver jobs may be cancelled or suspended depending implementation.

---

# 93. Backgrounding

**PROPOSED**

On app background:

- Persist snapshot.
- Cancel stale UI-only async tasks.
- Preserve Attempt.
- Resume safely later.

---

# 94. Concurrency Model

**PROPOSED**

Game State mutations should be serialized through one authoritative action queue.

Avoid simultaneous mutations from:

- UI drag.
- Solver callback.
- Ad rescue grant.
- Cloud sync.
- Lifecycle event.

Only one domain action should commit at a time.

---

# 95. Single Writer Principle

Recommended:

One Engine controller owns Game State writes.

Other systems:

- Read snapshots.
- Submit commands.
- Receive events.

This avoids race conditions.

---

# 96. Solver Async Coordination

Solver must analyze immutable snapshot/state revision.

If response revision != current revision:

Discard response.

Do not mutate board from Solver directly.

---

# 97. Dead-End Check Scheduling

**PROPOSED**

After a committed Move:

- Engine emits state.
- Coordinator schedules Solver check.
- UI remains responsive.
- If confirmed dead, transition to Dead-End overlay.

Potential optimization: skip checks when win/out-of-moves already resolved.

---

# 98. State Hash

**PROPOSED**

Maintain canonical gameplay state hash for:

- Solver cache.
- Debugging.
- Replay verification.
- Dead-End result cache.

Hash excludes UI/economy metadata not affecting rules.

---

# 99. Content Independence

Engine compatibility depends only on IDs and relation membership.

It does not care whether Member Card displays:

- Arabic text.
- Emoji.
- Number.
- Symbol.
- Illustration.

All content types use the same rules.

---

# 100. RTL Independence

The Game Engine is coordinate/layout-independent.

RTL only affects:

- Visual ordering.
- Text rendering.
- Drag layout.

It must not affect logical column identity or rules.

---

# 101. Level Configuration Input

The Engine should receive configuration including:

- Association count.
- Group sizes.
- Tableau columns.
- Column sizes.
- Stock size.
- Association Slot count.
- Move Limit.
- Rules profile/version.

Difficulty/content-selection metadata may be present but not required at runtime for core move logic.

---

# 102. Rules Profile

**PROPOSED**

Use explicit `rules_version` or `rules_profile_id`.

This enables future compatibility if mechanics change.

Current MVP should have one canonical rules profile.

---

# 103. Feature Flags

Core gameplay rules should not be casually changed via live feature flag.

Safe flags may control:

- UI.
- Optional systems.
- Logging.
- Experimental non-core helpers.

A rule change requires versioned compatibility.

---

# 104. Locked/Crown Mechanics

**CONFIRMED deferred**

Locked Slots, Crowns, Keys, and similar mechanics are not part of the current core Engine baseline.

Do not implement them as hidden assumptions.

Future mechanics should extend the rules model explicitly.

---

# 105. Lives/Energy

**CONFIRMED absent**

No Engine state for Lives/Energy is required.

Restart is not blocked by an Energy resource.

---

# 106. Ads Integration Boundary

The Engine never invokes ad SDKs directly.

Instead:

- Engine reaches Out-of-Moves/Dead-End.
- UI/Economy chooses Rewarded Ad path.
- Ad layer completes.
- Engine receives a validated grant command such as `GrantExtraMoves` or `ApplyRescueResult`.

---

# 107. IAP Boundary

Real-money purchase logic is outside Engine.

The Engine only consumes resulting entitlements/resources where gameplay requires them.

---

# 108. Rescue Integration

**CONFIRMED** Dead-End Rescue constraints:

- Solver-Guided Recovery State.
- Preserve completed progress as much as possible.
- Guarantee a winning continuation.
- Cost: 200 Coins.
- Max 1 rescue per Attempt.
- Rewarded Ads supported for Dead-End Rescue.

Exact rescue transformation remains intentional **TBD**.

Engine should support a generic validated replacement/transition mechanism.

Any rescue-produced state must:

- Preserve Card conservation.
- Match Level content.
- Be Solver-valid.
- Preserve current Attempt identity or create a clearly tracked rescue revision.

---

# 109. Rescue State Application

**PROPOSED**

Use:

`ApplyValidatedRescueState(rescue_state, rescue_metadata)`

rather than allowing arbitrary UI-level card rearrangement.

---

# 110. Mid-Level Reshuffle

**CONFIRMED:** No separate Mid-Level Reshuffle in MVP (**DEFERRED** / out of MVP).

If approved later:

- Game Engine should not invent reshuffle rules.
- Rescue service/generator produces candidate state.
- Solver validates.
- Engine applies atomically.

---

# 111. Analytics Boundary

Engine emits structured gameplay events.

Analytics layer maps them to product analytics events.

Do not place SDK-specific analytics calls deep inside rule logic.

---

# 112. Required Gameplay Analytics

Engine should expose enough data for:

- Level start.
- Move count.
- Invalid moves.
- Stock actions.
- Stack merges.
- Association activation/completion.
- Hint request context.
- Undo.
- Dead End.
- Out-of-Moves.
- Win.
- Remaining Moves.
- Streak rewards.

---

# 113. Diagnostics

Internal diagnostics should capture:

- State revision.
- Attempt ID.
- Last action.
- Rules version.
- State hash.
- Invariant violations.
- Solver correlation IDs.

Avoid sensitive data.

---

# 114. Invariant Checker

**PROPOSED**

Provide a debug/test-only `ValidateInvariants(state)` function after every transition.

Check:

- Card conservation.
- Association membership.
- Stack homogeneity.
- Slot validity.
- Moves non-negative.
- No duplicate ownership.
- Completed cards absent from active containers.

May be enabled selectively in production diagnostics.

---

# 115. Property-Based Tests

Recommended invariants:

- Applying invalid Move does not change board.
- Valid Move reduces Moves by exactly 1.
- Stack never splits.
- Completion always frees a Slot.
- Automatic reveal preserves card count.
- Association Stack never accepts new Members in Tableau.
- Win implies zero active cards.
- Restart state contains exactly the configured cards.

---

# 116. Unit Test Areas

Test modules independently:

- StackEngine.
- TableauEngine.
- StockEngine.
- AssociationEngine.
- MoveCounter.
- StreakEngine.
- UndoEngine.
- WinEvaluator.
- Serialization.

---

# 117. Integration Tests

Test end-to-end actions:

- Tableau → Tableau.
- Association Card → Member Stack.
- Association Stack → Slot.
- Stock → Active Association.
- Stock restore sequence.
- Final Move completion.
- Undo.
- Dead-End callback.
- Extra Moves grant.

---

# 118. Golden Scenario Tests

Maintain fixed gameplay scenarios with expected states after each action.

Examples:

- Simple Association activation.
- Stack merge.
- Association completion.
- Stock 3-card visibility.
- Restore loop.
- Out-of-Moves.
- Final-Move Win.
- Undo blocked after completion.

---

# 119. Engine/Solver Parity Test

For every legal Move enumerated by Solver:

- Game Engine must accept it.

For every Engine-valid Move:

- Solver move generator should include equivalent action in search.

This parity test is critical.

---

# 120. Replay Validation

Solver solution and stored action logs should replay successfully through Engine.

This is a release gate.

---

# 121. Performance Goals

Exact numeric budgets are TBD.

Engine should target:

- Immediate move validation.
- Immediate state mutation.
- No frame-blocking heavy search.
- Efficient serialization.
- Low GC/memory churn.
- Smooth Stack handling on mobile.

---

# 122. UI Thread Rule

**PROPOSED**

Core Move validation/application should be lightweight enough for near-immediate dispatch.

Heavy Solver work should not execute on the UI thread.

---

# 123. Memory Model

Avoid duplicating huge state unnecessarily.

However, because board sizes are moderate, correctness and immutability may be more valuable than aggressive micro-optimization early.

Benchmark before over-optimizing.

---

# 124. Snapshot Cost

Undo only requires one prior snapshot.

This keeps memory bounded.

If active-session persistence uses snapshots, serialization size should be measured.

---

# 125. Engine Portability

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §§5–6)

Game Engine is framework-independent from UI and state management.

Domain logic must avoid framework-specific UI types.

**CONFIRMED** benefits / placement:

- Reuse in Flutter client (Riverpod bridges UI ↔ Engine; Engine does not depend on Riverpod).
- Same Pure Dart rules shared with Solver.
- Reuse in CMS/CI/backend simulation on Firebase/GCP serverless.
- Easier testing without launching the app.

Client stack is **APPROVED**: Flutter + Riverpod + Drift / SQLite. Engine remains UI-independent.

---

# 126. Client Stack Context

**APPROVED** product client:

- Flutter (portrait; iOS 15+; Android 8 / API 26+; responsive tablet from same app).
- Riverpod for application/UI state.
- Drift / SQLite for local persistence (Active Attempt local-first).

The Engine must not depend on Flutter widgets, Riverpod, Ads, IAP, or network SDKs.

---

# 127. Server Reuse

**CONFIRMED** hybrid model: same rules/Solver core reusable in CMS/CI and Cloud Functions / Cloud Run simulation or fallback when needed. Exact backend fallback rules remain intentional **TBD**.

---

# 128. Versioning

Version:

- Game Rules.
- Engine schema.
- Saved state.
- Level configuration.
- Solver.

This enables controlled migration.

---

# 129. Saved-State Migration

If state schema changes:

- Migrate when safe.
- Or invalidate active session and restart current Level safely.
- Never corrupt Wallet/progression.

Exact migration policy TBD.

---

# 130. Engine Error Model

**PROPOSED**

Internal errors may include:

- Invalid state.
- Illegal action.
- Serialization failure.
- Rule version mismatch.
- Rescue state invalid.
- Solver state mismatch.

Player-facing messages should remain generic where possible.

---

# 131. Fail-Safe Rule

If Engine detects impossible invariant violation:

- Stop mutating current state.
- Preserve diagnostic snapshot.
- Prevent reward duplication.
- Recover to safe restart/home flow.

Do not attempt silent arbitrary repair.

---

# 132. State Machine

**PROPOSED**

Primary Attempt state machine:

`INITIALIZING`
→ `READY`
→ `ACTIVE`

From ACTIVE:

- `PAUSED`
- `DEAD_END`
- `OUT_OF_MOVES`
- `WON`
- `RESTARTING`
- `ABANDONED`

Rescue/Extra Moves may transition:

`DEAD_END / OUT_OF_MOVES → ACTIVE`

---

# 133. Action Acceptance by Status

Example:

## ACTIVE
Accept gameplay Moves.

## PAUSED
Reject gameplay Moves.

## OUT_OF_MOVES
Only lifecycle/rescue grants.

## DEAD_END
Only Undo/Rescue/Restart.

## WON
No further gameplay Moves.

This protects state consistency.

---

# 134. Move Transaction

**PROPOSED**

Treat each move as an atomic transaction.

Either:

- Entire transition succeeds.

or:

- State remains exactly unchanged.

This is especially important for:

- Card transfer.
- Move deduction.
- Completion.
- Streak.

---

# 135. Event Transaction Boundary

Events should only be published after state commit succeeds.

If validation fails, publish only rejection event.

---

# 136. Coin Reward Transaction Boundary

Engine reward event and Wallet update need idempotency.

Recommended:

- Include unique reward transaction ID.
- Wallet layer prevents duplicate credit.

Exact implementation belongs to Economy/Backend design.

---

# 137. Level Win Idempotency

Win reward must not be claimable twice due to:

- Reopen.
- Retry callback.
- Crash.
- Duplicate event.

Engine should emit one win event per Attempt.

Persistence/backend must enforce reward idempotency.

---

# 138. Association Completion Idempotency

A completed Association should never re-complete due to duplicate animation callbacks or async events.

Completion is state-based, not UI callback-based.

---

# 139. Stock Action Idempotency

UI double-tap on Stock should not accidentally consume two Moves unless two separate actions are intentionally accepted.

Action queue/input debounce should prevent accidental duplicate submission.

---

# 140. Input Debounce

**PROPOSED**

UI may debounce repeated Stock/Restore taps while previous action is processing.

Domain engine remains correct even if duplicate commands arrive; commands are validated against current state.

---

# 141. State Exposure to UI

Expose read-only presentation model or immutable snapshot.

UI should not mutate domain collections directly.

---

# 142. Presentation Adapter

**PROPOSED**

A separate adapter maps domain state into:

- Visible card list.
- Tableau coordinates/order.
- Slot progress.
- Stock visible window.
- Move count.
- Streak display state.
- Control enabled/disabled state.

---

# 143. Control Availability

Engine-derived states should inform:

- Undo enabled.
- Hint request allowed.
- Restore available.
- Stock Advance available.
- Drag unit movable.
- Slot available.

---

# 144. Animation Event Examples

Domain events may include enough payload for animations:

`AssociationCompleted`
- association_id
- slot_id
- removed_card_ids

`CardRevealed`
- column_id
- card_id

`StackMerged`
- source_unit
- target_unit
- resulting_unit

---

# 145. Haptics/Audio Boundary

Audio/haptics subscribe to domain/UI events.

Game Engine should not call device haptic APIs directly.

---

# 146. Accessibility Boundary

Accessibility metadata comes from UI/Content layer.

Engine may expose logical state labels but does not render accessibility semantics.

---

# 147. Localization Boundary

Engine error/reason codes should be localization-independent.

UI maps them to Arabic/other language strings.

---

# 148. Main Journey Integration

Flow:

1. Progression selects current Level.
2. Level Generator generates Attempt.
3. Solver validates.
4. Engine loads Attempt.
5. Gameplay occurs.
6. Engine emits Win.
7. Progression unlocks next Level.
8. Rewards persist.

---

# 149. Daily Challenge Integration

**CONFIRMED at launch**

Same Engine.

Differences come from Attempt configuration:

- Shared/deterministic board per cohort.
- Fixed Move Limit.
- Separate reward/progression rules (150 Coins; unlimited retries during valid day; backend authoritative for Daily eligibility).

No separate Daily Challenge game engine.

---

# 150. Tutorial Integration

Tutorial may wrap normal Engine with a Tutorial Controller.

Tutorial Controller may:

- Restrict allowed Moves.
- Highlight expected targets.
- Provide scripted states.

Core rule execution still uses Engine where possible.

---

# 151. Tutorial Exceptions

If tutorial needs intentionally fixed setup or forced moves:

Keep these restrictions outside base Main Journey rules.

Do not contaminate normal Rule Engine with tutorial-only exceptions unless behind explicit mode/config.

---

# 152. Events/Packs Integration

Events/Packs should reuse same Engine unless future mechanics explicitly alter rules.

Content theme alone must not fork Engine behavior.

---

# 153. Future Rule Extensibility

**PROPOSED**

Use explicit rule interfaces/configuration to permit future additions such as:

- Special Slots.
- Locked mechanics.
- New board elements.

But do not over-engineer features not approved.

---

# 154. Anti-Overengineering Principle

MVP Engine should solve current rules cleanly.

Avoid speculative complexity for:

- PvP.
- Friends.
- Keys.
- Crowns.
- Lives.
- Multiplayer.

These are not current core scope.

---

# 155. Engine API Surface — Conceptual

**PROPOSED**

Possible public API:

- `LoadAttempt(attempt)`
- `GetState()`
- `ValidateAction(action)`
- `Dispatch(action)`
- `CanUndo()`
- `Undo()`
- `GrantExtraMoves(amount)`
- `ApplyValidatedRescue(state)`
- `Serialize()`
- `Restore(snapshot)`
- `GetSolverSnapshot()`

Exact signatures depend on language/framework.

---

# 156. Engine Transition Result

Potential structure:

- `success`
- `new_state`
- `events`
- `rejection_reason`
- `requires_dead_end_check`
- `state_revision`

---

# 157. Move Validation Pipeline

**PROPOSED**

1. Check Attempt status.
2. Validate source exists.
3. Validate source is movable.
4. Validate Stock playability if source is Stock.
5. Validate target type.
6. Validate Association compatibility.
7. Validate Stack constraints.
8. Return typed valid Move.

---

# 158. Move Execution Pipeline

**PROPOSED**

1. Snapshot pre-state for Undo.
2. Remove unit from source.
3. Add/merge unit at target.
4. Deduct Move.
5. Reveal next Tableau Card if applicable.
6. Apply Association completion.
7. Update streak.
8. Evaluate Win.
9. Evaluate Out-of-Moves.
10. Commit.
11. Emit events.
12. Trigger async Dead-End analysis.

---

# 159. Invalid Action Pipeline

1. Validate.
2. No board mutation.
3. No Move deduction.
4. Reset current streak.
5. Increment state revision only if streak state changes.
6. Emit rejection/streak-reset events.

Important: invalid action can mutate streak state even though board does not change.

---

# 160. Invalid Move and Undo

**PROPOSED**

Because invalid attempts consume no Move and do not alter board, they should not create an Undo snapshot.

They may alter streak counter only.

This is consistent with current design.

---

# 161. Solver Snapshot

The Engine should export a canonical, presentation-free state.

It should include:

- Tableau.
- Stock.
- Slots.
- Completed Associations.
- Remaining Moves.
- Rules version.

No UI coordinates.

---

# 162. Canonicalization Ownership

Game Engine may provide normalized state primitives.

Solver may perform additional canonicalization for search symmetry.

Avoid modifying gameplay-visible ordering unless rules allow.

---

# 163. Debug Snapshot

**PROPOSED**

For support/debugging include:

- Level ID.
- Attempt ID.
- Rule version.
- Engine version.
- Solver version.
- State hash.
- Current Move count.
- Serialized board.
- Last N actions, where privacy-safe.

---

# 164. Engine Version

Track an Engine schema/version independently from app version when useful.

This helps:

- Replay.
- Save migration.
- Regression analysis.

---

# 165. Performance Instrumentation

Measure:

- Move validation time.
- Move commit time.
- Serialization time.
- Snapshot size.
- Event processing time.
- Solver handoff latency.

---

# 166. Engine QA Release Gate

Before release:

- Rule tests pass.
- Solver parity passes.
- Golden scenarios pass.
- Property-based invariants pass.
- Save/restore passes.
- Crash recovery passes.
- Final Move Win passes.
- Undo restrictions pass.
- Stock edge cases pass.
- **10,000+ simulation** path replay for critical Templates/Configs where practical.

---

# 167. Engine Security Considerations

Engine state on client should not be considered secure against tampering.

Critical economy/progression integrity may require server validation.

Core gameplay correctness remains local/domain responsibility.

---

# 168. Anti-Cheat Considerations

No competitive system is MVP-critical.

Do not burden core engine with heavy anti-cheat prematurely.

Future Daily Challenge Leaderboards may add server-side verification.

---

# 169. Offline Behavior

**CONFIRMED**

Main Journey is fully playable offline once required content is downloaded.

- Engine must function offline.
- Active Attempt persists local-first.
- On-device Solver supports generation and Hint/Dead-End where practical.
- Offline Coin spending allowed against locally reconciled balance (queued idempotent transactions).
- Purchases and Rewarded Ads require network.

---

# 170. Network Independence

**APPROVED / CONFIRMED** (Final Decision Register v1.1 §§6–7)

A valid gameplay Move must not require a network roundtrip.

Cloud sync must minimize Firestore reads/writes and avoid per-Move cloud traffic.

---

# 171. Engine Decision Register — Confirmed

The following are **CONFIRMED**:

1. Association Cards are deck Cards.
2. Association Slots start empty.
3. Tableau initial top Card is face-up.
4. Hidden Cards auto-reveal.
5. Same-group Members can stack.
6. Stacks are atomic and cannot split.
7. Internal Stack order does not affect rules.
8. Association Card in Tableau is inactive.
9. Association Card can join a matching Member Stack.
10. Member Stack cannot be placed onto Tableau Association Card.
11. Association Stack cannot receive new Members in Tableau.
12. Association Stack can move to a Slot.
13. Active Association accepts matching Member Cards/Stacks.
14. Completion only occurs in Slot.
15. Completion is automatic.
16. Completion frees Slot.
17. Stock shows last up-to-3, top only playable.
18. Restore Stock is unlimited and same-order.
19. Stock Advance and Restore cost Moves.
20. Every Stack move costs 1 Move.
21. Invalid Move costs no Move.
22. Invalid Move resets current streak counter.
23. Move Limit is fixed.
24. Undo is one step and cannot chain.
25. Completion Move cannot be undone.
26. Hint does not auto-execute.
27. Dead-End detection is Solver-driven.
28. Win requires all Cards cleared.
29. Restart creates a new shuffle.
30. No Lives/Energy.
31. Extra Moves: +5, max 2 per Attempt.
32. No separate Mid-Level Reshuffle in MVP.
33. Active Attempt persistence: local-first / device-specific.
34. Main Journey fully playable offline once required content is downloaded.
35. Dead-End Rescue: Solver-Guided Recovery; preserve completed progress as much as possible; guarantee winning continuation; max 1 per Attempt; cost 200 Coins.
36. Daily Challenge included at launch.
37. Game Engine independent of UI / Riverpod; Flutter + Riverpod + Drift are the approved client stack.
38. Pure Dart Solver; hybrid execution; no per-Move network requirement.
39. Identity/offline/conflict policy per Final Decision Register v1.1 §7.

---

# 172. Engine Decision Register — Proposed / Requires Approval

The following remain **PROPOSED/TBD**:

1. Pure-state-transition architecture.
2. Exact module/class boundaries.
3. Immutable Game State.
4. State revision counter.
5. Exact event ordering.
6. Undo restoring streak snapshot.
7. Save frequency.
8. Single-writer action queue.
9. State hash strategy.
10. Exact rescue transformation (intentional TBD; constraints CONFIRMED).
11. Presentation adapter pattern.
12. Engine public API shape.
13. Invalid-move state revision behavior.
14. ~~Network-independent gameplay as hard requirement~~ → **CONFIRMED** (no per-Move network).
15. Client/server shared engine library packaging details (hybrid reuse CONFIRMED; packaging TBD).
16. Debug replay/action-log retention.
17. Exact performance budgets.
18. Saved-state migration strategy.
19. Structural vs Move-Budget Dead-End status mapping.

---

# 173. Recommended Approval Order

Before coding the production Engine:

1. Approve domain state model.
2. Approve exact Stock transition model.
3. Approve Move transaction order.
4. Approve Undo restoration semantics.
5. Approve state serialization/resume behavior (Active Attempt local-first CONFIRMED).
6. Approve Solver integration contract.
7. Approve Dead-End status semantics.
8. Define exact Rescue transformation (intentional TBD; constraints CONFIRMED).
9. Approve event model.
10. Approve performance targets.
11. Freeze Rules v1.

---

# 174. Recommended MVP Engine Baseline

A safe MVP baseline is:

- One authoritative Game State.
- Shared core Rule Engine with Pure Dart Solver.
- Typed Actions.
- Atomic state transitions.
- Deterministic Move cost.
- Immutable/serializable snapshots where practical.
- One-step Undo snapshot.
- Async Solver integration (on-device where practical).
- Domain events for UI/analytics.
- Active Attempt local-first persistence.
- Offline Main Journey once content is downloaded.
- Extra Moves +5 max 2; Dead-End Rescue max 1; no Mid-Level Reshuffle.
- No UI-specific logic in core rules.
- No Ad/IAP SDK logic in Engine.
- No semantic NLP in Engine.
- No speculative future mechanics.

---

# 175. Dependencies

This design directly feeds:

1. **Data Model**
2. **Software Architecture**
3. **Backend & Cloud Architecture**
4. **Gameplay Interaction Specification**
5. **QA & Automated Game Validation Strategy**
6. **Analytics & KPI Specification**
7. **Level Generator Specification**
8. **MVP WBS / Product Backlog**

---

# 176. Baseline Status

This document is **Game Engine Technical Design v1.0** (Decision-Aligned to Final Decision Register v1.1).

It defines the runtime domain model, state transitions, gameplay rule boundaries, Engine/Solver integration, Undo, Streak, Stock, Association, persistence, events, QA, and extensibility expectations for the game.

Register-approved Extra Moves / Rescue / no Mid-Level Reshuffle / local-first Active Attempt / offline Main Journey / UI-independent Engine / Flutter+Riverpod+Drift client / no per-Move network decisions are **CONFIRMED**. Exact rescue transform remains intentional **TBD**.

**End of Game Engine Technical Design v1.0**
