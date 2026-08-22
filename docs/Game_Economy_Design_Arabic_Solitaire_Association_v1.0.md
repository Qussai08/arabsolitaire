# Game Economy Design
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Economy Design Baseline — Decision-Aligned / Approved  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0  
**Important:** Economy rules listed as **APPROVED/CONFIRMED** in Final Decision Register v1.1 are baseline product rules. Real-money SKU prices and any values still marked **TBD** remain open. Progression formulas beyond Chapter rewards belong to Progression Design (`Progression_Design_Arabic_Solitaire_Association_v1.0.md`).

---

# 1. Purpose

This document defines the economy model for the Arabic Solitaire Association game.

The economy must support four goals simultaneously:

1. Reward skilled play.
2. Give players optional recovery tools without introducing Lives/Energy.
3. Support sustainable monetization through Ads and IAP.
4. Avoid inflation, frustration, and pay-to-win pressure.

The game must remain fully playable without spending real money.

---

# 2. Economy Design Principles

## 2.1 Skill Should Generate Value

The player should earn more Coins by:

- Completing levels.
- Finishing with Moves remaining.
- Maintaining correct-action streaks.
- Participating consistently.
- Completing Daily content.

The economy therefore rewards both progression and efficient play.

## 2.2 Failure Must Not Block Play

**CONFIRMED:** There is no Lives or Energy system.

A failed player may restart without waiting.

Monetization should therefore be based on:

- Convenience.
- Recovery.
- Optional acceleration.
- Ads.
- Coin Packs.
- Remove Ads.

## 2.3 Paid Advantage Must Be Bounded

Players may buy utility, but money should not bypass the core puzzle indefinitely.

Coins may help with:

- Hints.
- Extra Moves.
- Dead-End Rescue (Solver-Guided Recovery).

MVP does **not** include a separate Mid-Level Reshuffle Coin sink.

They must not:

- Automatically solve levels.
- Reveal every answer permanently.
- Make impossible content trivially auto-complete.

## 2.4 Economy Values Must Be Tunable

All balancing values should be remotely configurable where technically practical.

This includes:

- Starting balance.
- Hint cost.
- Extra Moves cost.
- Rescue cost.
- Rewarded-Ad grants.
- Daily reward values.
- Coin Pack amounts.
- Interstitial rules.

---

# 3. Economy Resources

## 3.1 Coins

**CONFIRMED**

Coins are the primary soft currency.

Coins are used for:

- Hints.
- Extra Moves.
- Dead-End Rescue (Solver-Guided Recovery).
- Cosmetics/Themes in the Full Product (Post-MVP / DEFERRED unless later approved).

MVP priority sinks:

- Hints.
- Extra Moves.
- Dead-End Rescue.

## 3.2 Hint Inventory

**CONFIRMED**

Hints exist as a consumable resource.

A Hint:

- Does not cost a Move.
- Gives a recommended action.
- Does not perform the action automatically.
- Consumes one Hint resource.

Hints may be acquired using:

- Coins.
- Rewarded Ads.

## 3.3 Premium Currency

**CONFIRMED — No Premium Currency**

No separate premium currency (Gems/Diamonds or equivalent).

One soft currency (Coins) is the approved model.

---

# 4. Confirmed Coin Sources

## 4.1 Base Level Completion Reward

**CONFIRMED**

Each completed level awards:

`50 Coins`

## 4.2 Remaining Moves Reward

**CONFIRMED**

Each Move remaining at level completion awards:

`2 Coins`

Formula:

`Remaining Move Reward = Remaining Moves × 2`

Example:

`12 Remaining Moves = 24 Coins`

## 4.3 Correct-Move Streak Rewards

**CONFIRMED**

### Tier 1
`3 correct actions → 3 Coins`

### Tier 2
After Tier 1 is achieved:

`4 correct actions → 4 Coins`

### Tier 3
After Tier 2 is achieved:

`5 correct actions → 5 Coins`

### Persistent Tier
After reaching Tier 5:

`Every 5 correct actions → 5 Coins`

A mistake resets only the current streak counter.

The player's unlocked tier does not go backwards.

---

# 5. Confirmed Correct / Neutral / Wrong Economy Actions

## 5.1 Correct Actions

Each counts as `+1` toward the current correct-action streak:

- Member Card → compatible Member Card.
- Member Stack → compatible Member Card/Stack.
- Association Card → compatible Member Stack.
- Association Card → Association Slot.
- Member Card/Stack → Active Association.
- Association Stack → Association Slot.

A full Stack counts as one correct action.

## 5.2 Neutral Actions

Do not increase or reset the streak:

- Stock cycle.
- Restore Stock.
- Move Card/Stack to an empty Tableau column.

## 5.3 Wrong Action

An invalid move attempt:

- Consumes no Move.
- Resets the current correct-action streak.
- Does not reduce the unlocked streak tier.

---

# 6. Average Level Reward Model

A completed level produces:

`Total Level Coins = Base Reward + Remaining Move Reward + Streak Rewards`

Example only:

- Base = 50
- 10 Moves remaining = 20
- Streak rewards during play = 12

Total:

`50 + 20 + 12 = 82 Coins`

This means normal level income will naturally vary based on player skill.

This is desirable.

The economy should not guarantee the same reward for every player.

---

# 7. Economy Balance Target

**CONFIRMED reward structure** (simulation target for tuning)

For a normal successful Main Journey level, average total reward from the confirmed formula (50 base + remaining Moves × 2 + streak) typically falls approximately within:

`65–95 Coins`

depending on:

- Level difficulty.
- Player efficiency.
- Streak performance.

This range is a balancing observation for simulation, not a separate reward rule.

---

# 8. Starting Economy

The player should begin with enough resources to understand Hints and Rescue without immediately feeling monetization pressure.

## 8.1 Starting Coins

**CONFIRMED**

`300 Coins`

## 8.2 Starting Hints

**CONFIRMED**

`3 Free Hints`

This lets the tutorial introduce the feature without immediately requiring Coins or Ads.

---

# 9. Hint Economy

## 9.1 Hint Purchase

**CONFIRMED:** Hints can be obtained with Coins or Rewarded Ads.

### Coin Cost

**CONFIRMED**

`75 Coins per Hint`

Desired relationship:

A player should normally need roughly one strong level reward to purchase one Hint.

## 9.2 Rewarded Ad Hint

**CONFIRMED**

`1 Rewarded Ad → 1 Hint`

## 9.3 Hint Price Scaling

**CONFIRMED for MVP**

MVP uses a fixed Hint price rather than dynamic price escalation.

Post-MVP experimentation may evaluate session-based price escalation if required.

---

# 10. Extra Moves Economy

Extra Moves are offered when the Move counter reaches zero.

## 10.1 Extra Moves Package

**CONFIRMED**

`+5 Moves`

## 10.2 Coin Price

**CONFIRMED**

Escalating Coin cost:

- First rescue: `150 Coins → +5 Moves`
- Second rescue: `250 Coins → +5 Moves`

## 10.3 Rewarded Ad Option

**CONFIRMED**

Rewarded Ads are supported for Extra Moves (`1 Rewarded Ad → +5 Moves` grant model).

## 10.4 Repeated Purchases

**CONFIRMED**

Maximum:

`2 Extra Move rescues per Attempt`

Reason:

Unlimited Extra Moves could destroy the Move-Limit challenge and turn every level into a guaranteed completion.

---

# 11. Dead-End Rescue Economy

**CONFIRMED:** Dead-End Rescue exists and may use Coins or Rewarded Ads.

Approved rescue model:

- **Solver-Guided Recovery State.**
- Preserve completed progress as much as possible.
- Guarantee a winning continuation.

Economically, the rescue costs more than a Hint because it repairs a strategically failed state.

## 11.1 Coin Cost

**CONFIRMED**

`200 Coins`

## 11.2 Rewarded Ad Rescue

**CONFIRMED**

`1 Rewarded Ad → 1 Dead-End Rescue`

## 11.3 Rescue Limit

**CONFIRMED**

`1 Dead-End Rescue per Attempt`

After use, if another dead end occurs:

- Undo if available.
- Otherwise Restart.

This protects puzzle integrity.

---

# 12. Reshuffle Economy

Two distinct meanings must be kept separate:

### Restart Shuffle
**CONFIRMED**
Free and unlimited.
Starts a new attempt from the beginning.

### Mid-Level Rescue Reshuffle
**DEFERRED — Post-MVP / Not in MVP**

There is **no separate Mid-Level Reshuffle** utility in MVP.

Dead-End recovery uses Solver-Guided Recovery (Section 11), not a Mid-Level Reshuffle Coin sink.

---

# 13. Undo Economy

**CONFIRMED**

Basic Undo has **no Coin cost**.

Reason:

- Undo is limited to one eligible previous action.
- It cannot chain.
- It cannot undo completed Associations.
- It improves fairness.

---

# 14. Daily Reward Economy

Daily Reward is **APPROVED** for launch (P0 with Daily Challenge and Daily Streak).

## 14.1 Confirmed 7-Day Calendar

**CONFIRMED** — 7-day repeating calendar:

| Day | Reward |
|---|---:|
| Day 1 | 100 Coins |
| Day 2 | 125 Coins |
| Day 3 | 150 Coins |
| Day 4 | 1 Hint |
| Day 5 | 175 Coins |
| Day 6 | 200 Coins |
| Day 7 | 300 Coins + 1 Hint |

Total weekly Coin value:

`1,050 Coins`

plus:

`2 Hints`

## 14.2 Missed Day Behavior

**CONFIRMED**

Missing a day does **not** reset Daily Reward calendar progression.

(Daily Streak is separate and **does** break on a missed day — see Section 15.)

Backend is authoritative for Daily time/eligibility; reset/claim day uses validated player-local timezone.

---

# 15. Daily Streak Economy

Daily Streak exists separately from the in-level correct-action streak.

## 15.1 Confirmed Milestones

**CONFIRMED**

Daily Streak breaks after a missed day.

Milestone rewards:

- 3 days → 100 Coins
- 7 days → 250 Coins
- 14 days → 400 Coins
- 30 days → 750 Coins

No Streak Freeze is required for MVP.

---

# 16. Daily Challenge Economy

Daily Challenge is **APPROVED** for launch (P0).

## 16.1 Completion Reward

**CONFIRMED**

`150 Coins`

Auto-granted on **first completion** of the valid day.

## 16.2 Board and Timing

**CONFIRMED**

- Fixed deterministic board per challenge cohort.
- Unlimited retries during the valid day.
- Reset: `00:00` validated player-local timezone.
- Backend authoritative for Daily time/eligibility.

## 16.3 Efficiency Bonus

**Not approved** — no separate remaining-Move Coin bonus for Daily Challenge beyond the confirmed 150 Coins first-completion grant.

## 16.4 Retry Cost

**CONFIRMED**

Retries are free (unlimited during the valid day).

---

# 17. Chapter Rewards

**CONFIRMED**

Every standard 50-level Chapter awards on completion:

`500 Coins + 2 Hints`

Further progression formulas and wave presentation belong to Progression Design (`Progression_Design_Arabic_Solitaire_Association_v1.0.md`) — this document does not invent additional progression rules.

---

# 18. Coin Sink Hierarchy

The economy should intentionally create spending choices.

Approved hierarchy:

1. Hint — lowest-cost utility.
2. Extra Moves — medium cost.
3. Dead-End Rescue (Solver-Guided Recovery) — higher cost.
4. Cosmetics/Themes — Post-MVP / DEFERRED discretionary sink.

This hierarchy communicates:

`Information < Recovery < State Repair < Collection`

---

# 19. Confirmed Utility Prices

**CONFIRMED**

| Utility | Coin Cost |
|---|---:|
| Hint | 75 |
| +5 Moves — First Rescue | 150 |
| +5 Moves — Second Rescue | 250 |
| Dead-End Rescue | 200 |

Mid-Level Reshuffle: **not in MVP** (DEFERRED / Post-MVP).

---

# 20. Rewarded Ad Economy

Rewarded Ads should provide a meaningful alternative to Coin spending.

## 20.1 Approved Reward Categories

**CONFIRMED**

Rewarded Ads may provide:

- Hints.
- Extra Moves.
- Dead-End Rescue.
- Coins.

## 20.2 Confirmed Grants

**CONFIRMED**

| Rewarded Ad Placement | Grant |
|---|---:|
| Hint | 1 Hint |
| Out of Moves | +5 Moves |
| Dead End | 1 Rescue |
| Optional Coin Ad | 100 Coins |

## 20.3 Coin Ad Frequency

**CONFIRMED**

`3 Coin Ads per day` maximum.

This prevents Ads from becoming an unlimited Coin faucet.

Purchases and Rewarded Ads require network. Offline Coin spending against locally reconciled balance is allowed with queued idempotent reconciliation (see architecture/offline policy).

---

# 21. Interstitial Ad Economy

**CONFIRMED:** Adaptive Interstitial Ads are part of the product.

Interstitials are not direct economy rewards but influence monetization pressure.

## 21.1 Confirmed Frequency

**CONFIRMED**

- Adaptive.
- Baseline around every **3–5** completed Levels.
- Max **3 Interstitials per session**.

Do not show an Interstitial immediately after:

- A Rewarded Ad.
- An IAP purchase.
- Tutorial.
- Failure.
- Dead-End.
- Out-of-Moves decline.

---

# 22. Remove Ads

**CONFIRMED IAP**

Remove Ads removes **Interstitials only**.

- Rewarded Ads remain available voluntarily.
- Core gameplay unchanged.

Exact real-money price is **TBD** (market/store pricing research).

---

# 23. Coin Pack IAP

Coin Packs are approved IAP.

**CONFIRMED** purchase validation path (Final Decision Register v1.1 §9):
client Flutter `in_app_purchase`; server-side validation via trusted
Cloud Functions / Cloud Run.

## 23.1 Confirmed Pack Ladder (Amounts)

**CONFIRMED amounts**

| Pack | Coin Amount | Position |
|---|---:|---|
| Small | 1,000 | Entry |
| Medium | 3,000 | Core |
| Large | 7,000 | Value |
| XL | 15,000 | Heavy user |

**No Starter Pack** in MVP.  
**No Subscription.**  
**No Premium Currency.**  
**No paid randomized reward system.**

## 23.2 Real-Money Pricing

**TBD**

Exact real-money prices for all Coin Packs (and Remove Ads) remain open pending market/store pricing research.

Visible value bonuses versus the Small Pack baseline may be merchandised once prices are set; they are not separate currency rules.

---

# 24. Economy Without Real-Money Spending

A non-paying player must be able to:

- Continue Main Journey indefinitely.
- Restart indefinitely.
- Earn Coins from play.
- Earn Hints through Coins/Ads.
- Obtain Extra Moves through Coins/Ads.
- Recover from some Dead Ends through Coins/Ads.

No level should require a purchase to continue.

---

# 25. Expected Spend Pressure

The economy should create moments of choice rather than permanent scarcity.

Typical desired tension:

- Good players accumulate Coins.
- Average players spend some Coins on Hints/Extra Moves.
- Struggling players can use Rewarded Ads rather than being blocked.
- Highly engaged players may purchase Coin Packs for convenience.
- Remove Ads serves players who value uninterrupted play.

---

# 26. Anti-Inflation Strategy

Because players earn Coins every level, inflation is a significant risk.

The economy should be monitored using:

`Coins Earned per Active Player`
versus
`Coins Spent per Active Player`

Desired long-term state:

Healthy circulation rather than constant accumulation.

Potential balancing levers:

- Utility prices.
- Daily reward values.
- Streak rewards.
- Rewarded-Ad Coin grants.
- Cosmetic sinks.
- Event sinks.
- New utility features.

Confirmed base level rewards should not be changed casually because they are part of the approved core design.

---

# 27. Economy Segments

Players may naturally fall into groups:

## Efficient Solver
High completion rate.
High remaining Moves.
Low Hint usage.
High Coin accumulation.

## Normal Player
Occasional Hints.
Occasional Extra Moves.
Balanced Coin flow.

## Struggling Player
Frequent Hints.
Frequent Extra Moves.
Potential Rewarded-Ad user.

## Convenience Buyer
Pays for Coins to avoid Ads or grinding.

## Ads-Averse Buyer
Purchases Remove Ads.

Economy tuning should avoid making any one segment feel punished.

---

# 28. Economy Difficulty Interaction

Higher-difficulty levels naturally create:

- More Hint demand.
- More Extra Move demand.
- More rescue demand.

The difficulty system must not intentionally create impossible or unfair situations simply to increase monetization.

Solver-validated fairness is a hard requirement.

---

# 29. New Player Protection

**CONFIRMED suppression rules** (aligned with Interstitial policy)

During Tutorial and very early levels:

- Do not show Interstitial Ads.
- Do not aggressively sell Coin Packs.
- Allow free Tutorial Hints where tutorial design requires.
- Teach Coins through earned rewards first.

Exact first Interstitial eligibility level threshold remains a tuning parameter (Remote Config).

---

# 30. First-Time Utility Education

Recommended sequence:

1. Player encounters first difficult move.
2. Tutorial introduces Hint.
3. First Hint is free.
4. Later, player encounters Move shortage.
5. Extra Moves concept is introduced.
6. Coin/Rewarded options appear only after the player understands the benefit.

The economy should be taught through gameplay context.

---

# 31. Economy UX

Every Coin spend must clearly show:

- Cost.
- Current balance.
- Exact reward.
- Confirmation for significant purchases where appropriate.

Rewarded Ads must clearly show:

- The reward before viewing.
- Successful reward delivery after completion.

Real-money purchases must clearly show store pricing.

---

# 32. Economy Remote Configuration

Recommended configurable keys:

- `starting_coins`
- `starting_hints`
- `hint_coin_cost`
- `extra_moves_amount`
- `extra_moves_cost_1`
- `extra_moves_cost_2`
- `dead_end_rescue_cost`
- `rewarded_hint_amount`
- `rewarded_extra_moves_amount`
- `rewarded_coin_amount`
- `rewarded_coin_daily_cap`
- `daily_reward_calendar`
- `daily_streak_rewards`
- `daily_challenge_reward`
- `interstitial_min_levels_between`
- `interstitial_session_cap`

Core confirmed reward constants may also be represented in configuration for operational safety, but changes require explicit product approval.

---

# 33. Economy Analytics Events

Required events include:

- `coin_earned`
- `coin_spent`
- `coin_balance_changed`
- `hint_used`
- `hint_purchased`
- `extra_moves_offered`
- `extra_moves_purchased`
- `dead_end_rescue_offered`
- `dead_end_rescue_used`
- `rewarded_ad_offered`
- `rewarded_ad_started`
- `rewarded_ad_completed`
- `rewarded_ad_reward_granted`
- `interstitial_shown`
- `shop_opened`
- `iap_started`
- `iap_completed`
- `iap_failed`
- `remove_ads_purchased`
- `daily_reward_claimed`
- `daily_challenge_rewarded`
- `daily_streak_rewarded`

Every Coin source/sink event should include:

- Source/sink type.
- Amount.
- Balance before.
- Balance after.
- Level ID where applicable.
- Session ID.
- Relevant offer ID.

---

# 34. Economy KPIs

Key launch KPIs:

## Currency
- Coins earned per DAU.
- Coins spent per DAU.
- Average Coin balance.
- Median Coin balance.
- Earn/spend ratio.
- Percentage of players with near-zero balance.
- Percentage of players accumulating very high balances.

## Utility
- Hint usage per level.
- Extra Moves usage rate.
- Dead-End Rescue usage rate.
- Coin vs Ad choice rate.

## Monetization
- Rewarded Ad views per DAU.
- Interstitial impressions per DAU.
- Remove Ads conversion.
- Coin Pack conversion.
- ARPDAU.
- Payer conversion.

## Retention Impact
- Completion rate before/after rescue.
- Churn after Out-of-Moves.
- Churn after Dead End.
- Retention by Coin balance cohort.

---

# 35. Economy Health Thresholds

Exact thresholds require live data.

Warning signs include:

### Excess Inflation
Players accumulate Coins continuously and rarely need to spend.

Possible response:

- Add sinks.
- Increase utility value/cost carefully.
- Add cosmetics/events.

### Excess Scarcity
Players frequently reach zero Coins and cannot recover without Ads.

Possible response:

- Increase free rewards.
- Reduce utility costs.
- Increase daily grants.

### Excess Ad Dependence
Too many players use Ads for every utility action.

Possible response:

- Improve Coin earning.
- Increase utility affordability.
- Rebalance Rewarded grants.

### Weak Monetization
Players have excessive free utility and no reason to purchase.

Possible response:

- Improve Store value.
- Add long-term cosmetic sinks.
- Tune balance without creating frustration.

---

# 36. Economy Simulation Model

Before launch, the team should simulate multiple player profiles.

Suggested profiles:

### Skilled
- 90% completion.
- High remaining Moves.
- Rare Hint.
- Rare Rescue.

### Average
- 75% completion.
- Moderate Hint use.
- Occasional Extra Moves.

### Struggling
- 55% completion.
- Frequent Hint.
- Frequent rescue.

### Ad User
Prefers Rewarded Ads over Coin spending.

### Buyer
Occasionally purchases Coin Packs.

Simulate at least:

- 10 levels.
- 50 levels.
- 250 levels.
- 30 days.

Outputs:

- Coin balance trajectory.
- Hint consumption.
- Rescue usage.
- Rewarded Ads.
- Estimated purchase pressure.

---

# 37. MVP Economy Baseline

**APPROVED / CONFIRMED** initial MVP economy (Final Decision Register v1.1):

### Confirmed
- 50 Coins base win reward.
- 2 Coins per remaining Move.
- Correct-action streak rewards.
- Coins as main soft currency.
- Starting Coins: 300.
- Starting Hints: 3.
- Hint: 75 Coins.
- Extra Moves: +5; first rescue 150 Coins; second rescue 250 Coins; max 2 per Attempt.
- Dead-End Rescue: Solver-Guided Recovery; 200 Coins; max 1 per Attempt.
- No Mid-Level Reshuffle in MVP.
- Rewarded Hint: 1; Rewarded Extra Moves: +5; Rewarded Dead-End Rescue: 1.
- Rewarded Coin grant: 100 Coins; cap 3/day.
- Interstitials: adaptive ~3–5 levels; max 3/session; suppressions as defined.
- Remove Ads = Interstitials only.
- Coin Pack amounts: 1,000 / 3,000 / 7,000 / 15,000 (real-money prices TBD).
- Daily Reward 7-day calendar values; miss does not reset calendar.
- Daily Streak milestones 3/7/14/30 = 100/250/400/750; streak breaks on miss.
- Daily Challenge: 150 Coins; unlimited retries; deterministic board; auto-grant first completion; 00:00 local; backend authoritative.
- Chapter completion: 500 Coins + 2 Hints.
- No Lives/Energy.
- No Starter Pack / Subscription / Premium Currency.

---

# 38. Full Product Economy Expansion

Post-MVP / DEFERRED economy can add (when approved):

- Cosmetics.
- Themes.
- Collection completion rewards.
- Achievement rewards.
- Event currencies.
- Event Shops.
- Permanent Pack unlocks.
- Limited-time Coin sinks.
- Badge-related rewards.
- XP progression rewards.
- Mid-Level Reshuffle (if later approved separately from Dead-End Rescue).

Any additional currency should require a separate economy decision.

---

# 39. Items Explicitly Not Included

The economy does not currently include:

- Lives.
- Energy.
- Mandatory cooldowns.
- Premium Gems / Premium Currency.
- Subscriptions.
- Starter Pack (MVP).
- Mid-Level Reshuffle (MVP).
- Loot boxes.
- Random paid rewards.
- PvP entry fees.
- Gambling mechanics.
- Mandatory paid level unlocks.
- Paid auto-solve.

---

# 40. Economy Decision Register

The following are **CONFIRMED / APPROVED** (Final Decision Register v1.1):

1. Coins are the main soft currency; no Premium Currency.
2. Base level win reward = 50 Coins.
3. Remaining Move reward = 2 Coins per Move.
4. Correct-action streak rewards = 3/4/5 structure.
5. Starting Coins = 300; Starting Hints = 3.
6. Hint price = 75 Coins; fixed price in MVP; Rewarded Ad → 1 Hint.
7. Extra Moves = +5; 150 then 250 Coins; max 2 rescues per Attempt; Rewarded Ads supported.
8. Dead-End Rescue = Solver-Guided Recovery; 200 Coins; max 1 per Attempt; Rewarded Ads supported.
9. No Mid-Level Reshuffle in MVP.
10. Rewarded Coin Ad = 100 Coins; cap 3/day.
11. Interstitials adaptive ~3–5 levels; max 3/session; suppressions as defined.
12. Remove Ads removes Interstitials only; Rewarded Ads remain.
13. Coin Pack amounts = 1,000 / 3,000 / 7,000 / 15,000.
14. No Starter Pack / Subscription / paid randomized rewards.
15. Daily Reward 7-day calendar values; miss does not reset calendar.
16. Daily Streak milestones and break-on-miss.
17. Daily Challenge 150 Coins; unlimited retries; deterministic board; auto-grant first completion; 00:00 local; backend authoritative.
18. Chapter completion = 500 Coins + 2 Hints.
19. Undo has no Coin cost.
20. There is no Lives/Energy system.

The following remain **TBD** (intentionally open):

1. Real-money prices for Remove Ads and all Coin Packs.
2. Future Pack monetization model (free / Coin unlock / real-money) — no paid Pack at initial introduction.
3. Analytics cost thresholds that trigger retention-policy review (operations).

---

# 41. Remaining Commercial Decisions

Before store listing finalization, decide:

1. Remove Ads real-money price.
2. Coin Pack real-money prices (localized).
3. Pack merchandising presentation once prices are set.

Soft-currency balance rules above are already approved and should not be reopened casually.

---

# 42. Baseline Status

This document is **Game Economy Design v1.0**, aligned with **Final Decision Register v1.1**.

Approved numeric economy rules are baseline product rules.

Items still marked **TBD** (especially real-money prices) remain intentionally open.

Economy balancing should remain data-driven and remotely tunable after launch within approved categories.

Progression detail beyond Chapter rewards is owned by Progression Design (`Progression_Design_Arabic_Solitaire_Association_v1.0.md`) — not by inventing extra rules here.

**End of Game Economy Design v1.0**
