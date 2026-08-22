# Monetization Specification
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Game Economy Design v1.0 + related product/architecture specs  
**Important:** Economy amounts, ad rules, Remove Ads scope, Coin Pack ladder, IAP validation path, and ads mediation direction listed as **APPROVED** in Final Decision Register v1.1 are **CONFIRMED**. Exact real-money store prices and Firebase/GCP quotas/billing remain **TBD**. No Mid-Level Reshuffle in MVP. Azure always-on stack is **SUPERSEDED** for MVP.

---

# 1. Purpose

This document defines how the Arabic Solitaire Association game monetizes without making the core puzzle unfair or pay-to-win.

It covers:

- Rewarded Ads.
- Interstitial Ads.
- Remove Ads entitlement.
- Coin Packs.
- Contextual utility offers.
- Hint monetization.
- Extra Moves monetization.
- Dead-End Rescue monetization.
- Optional Coin rewards from ads.
- Shop structure.
- Purchase flow.
- Pricing principles.
- Offer eligibility.
- Frequency control.
- Economy integration.
- Analytics.
- Fraud/idempotency.
- Refund/revocation handling.
- Remote Config.
- A/B experimentation.
- Monetization guardrails.
- MVP vs Post-MVP scope.

The monetization system must support the product, not distort the game design.

---

# 2. Monetization Principles

The monetization design should follow these principles:

1. Core gameplay is always solvable without payment.
2. No board may require purchased Extra Moves to be valid.
3. No board may require a paid Hint to be solvable.
4. Rewarded Ads are always optional.
5. Interstitial Ads appear only at natural breaks.
6. No Lives/Energy gating.
7. No mandatory registration before purchase.
8. Remove Ads must be a durable entitlement.
9. Coin Packs must be additive convenience, not required progression.
10. Utility pricing must not exploit artificially tight Move Limits.
11. Rewarded Ad value must not destroy Coin economy.
12. Monetization should be configurable remotely.
13. All grants/spends must be idempotent.
14. Monetization analytics must include player-experience guardrails.
15. No premium currency is currently approved.
16. No loot-box/random-paid-reward mechanic is currently approved.

---

# 3. Confirmed Monetization Model

The following are **CONFIRMED**:

- Rewarded Ads are supported.
- Rewarded Ads may provide:
  - Extra Moves.
  - Hints.
  - Dead-End Rescue.
  - Coins.
- Interstitial Ads use adaptive frequency.
- Remove Ads is an approved IAP.
- Coin Packs are approved IAP.
- Coins may be spent on:
  - Hints.
  - Extra Moves.
  - Dead-End Rescue (Solver-Guided Recovery).
  - Cosmetics/Themes later (Post-MVP / DEFERRED).
- No separate Mid-Level Reshuffle in MVP.
- No Lives/Energy.
- No mandatory paywall.
- No approved premium Gems/Diamonds.
- No Starter Pack in MVP.
- No Subscription.
- No Premium Currency.
- No paid randomized reward system.

---

# 4. Monetization Surfaces

Core monetization appears in:

1. Shop.
2. Hint Acquisition Offer.
3. Out-of-Moves Offer.
4. Dead-End Rescue Offer.
5. Optional Coin Rewarded Ad.
6. Interstitial Ad breaks.
7. Remove Ads purchase.
8. Coin Pack purchase.
9. Future Cosmetics Shop.

---

# 5. Monetization Separation

The system should separate:

## Soft Currency Spend
Coins spent inside the game.

## Real-Money Purchase
StoreKit / Google Play purchase.

## Ad Exchange
Player voluntarily watches an ad for a deterministic reward.

Do not visually blur these into one price system.

---

# 6. Core Economy Currency

**CONFIRMED**

Primary soft currency:

`Coins`

No premium currency is required for MVP.

---

# 7. Coin Sources

Current/proposed Coin sources:

- Base Level completion.
- Remaining Moves bonus.
- Correct-action Streak reward.
- Daily Reward.
- Daily Challenge.
- Rewarded Ad.
- Coin Pack IAP.
- Future Events/Achievements.

Core confirmed Level reward formula:

`50 + (2 × remainingMoves) + streakCoins`

---

# 8. Coin Sinks

**CONFIRMED**

Coins may fund:

- Hint.
- Extra Moves.
- Dead-End Rescue.
- Cosmetics/Themes later (Post-MVP / DEFERRED).

Mid-Level Reshuffle is **not in MVP**.

---

# 9. Monetization Utility Categories

**PROPOSED terminology**

Utility monetization types:

- KNOWLEDGE_SUPPORT → Hint.
- ATTEMPT_EXTENSION → Extra Moves.
- STATE_RECOVERY → Dead-End Rescue.
- STATE_REFRESH → Reshuffle.
- SOFT_CURRENCY_TOPUP → Rewarded Coin Ad / Coin Pack.

These are internal categories only.

---

# 10. Hint Monetization

**CONFIRMED**

Hints:

- Do not consume Moves.
- Are limited by Hint balance.
- May be acquired via Coins.
- May be acquired via Rewarded Ad.

A Hint must:

- recommend one move.
- not auto-execute.

---

# 11. Hint Purchase Flow

```text
Hint balance = 0
→ Hint Offer
   ├─ Spend Coins
   ├─ Watch Rewarded Ad
   └─ Cancel
```

On success:

- grant/use Hint.
- request Solver recommendation.
- show hint.

If Solver fails/inconclusive:

- do not permanently consume user value without defined refund logic.

---

# 12. Confirmed Hint Economy Values

**CONFIRMED — Final Decision Register v1.1**

- Starting Hints = 3
- Hint Coin Price = 75 Coins
- Rewarded Ad = 1 Hint

---

# 13. Hint Price Principle

Hint pricing should be high enough to:

- preserve puzzle challenge.
- maintain Coin sinks.

but low enough that:

- users do not avoid the feature entirely.
- early players can recover from confusion.

Final value requires Economy simulation.

---

# 14. Extra Moves Monetization

**CONFIRMED**

When Moves reach zero:

Player may:

- buy Extra Moves with Coins.
- watch Rewarded Ad.
- restart/decline.

---

# 15. Extra Moves Grant

**CONFIRMED**

- `+5 Moves`

The grant must be explicit in UI before spend/ad.

---

# 16. Extra Moves Coin Pricing

**CONFIRMED — Final Decision Register v1.1**

- First rescue = 150 Coins.
- Second rescue = 250 Coins.
- Maximum two Extra-Move rescues per Attempt.

---

# 17. Escalating Extra Moves Pricing

**CONFIRMED**

Escalating price (150 then 250) is preferred over unlimited flat-price extension because it:

- prevents endlessly buying through a bad Attempt.
- protects difficulty integrity.
- creates a natural restart point.

---

# 18. Extra Moves Fairness Rule

Initial Level acceptance must ignore Extra Moves.

A Level must be Solver-valid within its fixed Move Limit.

Extra Moves exist only to compensate for player inefficiency or exploration.

---

# 19. Dead-End Rescue Monetization

**CONFIRMED concept**

When Solver detects no winning continuation:

Possible player options:

- Undo if available.
- Coin-funded Rescue.
- Rewarded Ad Rescue.
- Restart.

---

# 20. Rescue Definition

**CONFIRMED — Final Decision Register v1.1**

Dead-End Rescue is **Solver-Guided Recovery State**:

- preserve completed progress as much as possible.
- guarantee a winning continuation.
- cost: 200 Coins.
- max 1 rescue per Attempt.
- may also be acquired via Rewarded Ad.

Exact low-level board transformation details may still be tuned in implementation, but the product/economy rules above are approved.

---

# 21. Confirmed Rescue Price

**CONFIRMED**

- Dead-End Rescue = 200 Coins.
- Maximum one rescue/Attempt.

---

# 22. Mid-Level Reshuffle

**CONFIRMED — not in MVP**

There is **no separate Mid-Level Reshuffle** utility in MVP.

Dead-End recovery uses Solver-Guided Recovery (Section 20), not a Mid-Level Reshuffle Coin sink.

---

# 23. Rewarded Ads

**CONFIRMED**

Supported Rewarded Ad placements:

1. Hint.
2. Extra Moves.
3. Dead-End Rescue.
4. Coins.

Reward must always be deterministic and clearly stated.

---

# 24. Rewarded Ad UX Rules

Rewarded Ads must be:

- Player-initiated.
- Explicit about reward.
- Never disguised as a normal button.
- Never auto-started.
- Never required for first-time tutorial completion.
- Never the only path if Coins alternative is intended.
- Safe if ad fails.

---

# 25. Rewarded Ad Grant Integrity

Only grant reward after provider reports successful completion according to chosen integration policy.

Grant must be idempotent.

Never grant twice from duplicate callbacks.

---

# 26. Rewarded Ad Failure

If ad cannot load:

Show:

`الإعلان غير متاح حاليًا`

Then:

- keep player state unchanged.
- keep resource unchanged.
- allow Coin alternative where appropriate.
- allow retry later.

---

# 27. Rewarded Coin Ad

**CONFIRMED category**

Player may voluntarily watch ad for Coins.

---

# 28. Confirmed Rewarded Coin Amount

**CONFIRMED — Final Decision Register v1.1**

- 100 Coins per rewarded Coin ad.
- 3 rewarded Coin ads/day.

---

# 29. Rewarded Coin Daily Cap

**CONFIRMED**

Daily cap = **3** rewarded Coin ads/day to:

- prevent unlimited Coin inflation.
- limit farming.
- control ad load.

---

# 30. Rewarded Ad Placement Priority

**PROPOSED**

Priority in value/relevance:

1. Contextual Rescue.
2. Hint.
3. Extra Moves.
4. Optional Coin farming.

Coin-only Ads should not overwhelm gameplay-driven rewarded placements.

---

# 31. Rewarded Ad Cooldown

**PROPOSED**

May use cooldown by placement to prevent:

- repeated spam.
- rapid farming.
- poor ad UX.

Exact timing TBD.

---

# 32. Rewarded Ads After Remove Ads

**CONFIRMED**

Remove Ads should remove applicable Interstitial Ads.

Rewarded Ads remain available because they are optional and reward-based.

---

# 33. Interstitial Ads

**CONFIRMED**

Interstitials use adaptive frequency.

They are not fixed to:

- every Level.
- every N Levels permanently.

Exact adaptive logic remains TBD.

---

# 34. Interstitial Placement Rule

Interstitials may only appear at natural breaks.

Recommended valid points:

- after Level Complete.
- after returning to Home.
- between non-critical screens.

Never:

- mid-drag.
- mid-Level.
- during Association animation.
- immediately after failure.
- immediately after Rewarded Ad.
- immediately after purchase.
- during Tutorial.

---

# 35. Confirmed Interstitial Baseline

**CONFIRMED — Final Decision Register v1.1**

- Adaptive.
- Baseline around every **3–5** completed Levels.
- Max **3 Interstitials per session**.
- Not immediately after Rewarded Ad, purchase, tutorial, failure, Dead-End, or Out-of-Moves decline.

---

# 36. Adaptive Interstitial Inputs

**PROPOSED**

Potential factors:

- Levels since last Interstitial.
- Session length.
- Recent Rewarded Ad.
- Recent purchase.
- Tutorial state.
- failure/restart state.
- Remove Ads entitlement.
- user ad exposure this session.
- remote config.

---

# 37. Interstitial Session Cap

**CONFIRMED**

Max **3 Interstitials per session**.

---

# 38. Interstitial Cooldown

**PROPOSED**

Ensure minimum time between Interstitials.

Exact time TBD.

---

# 39. Ad Fatigue Guardrails

Monitor:

- session exits after ad.
- next-Level start rate.
- retention by exposure count.
- Remove Ads conversion.
- review/rating sentiment.

If ads increase revenue but materially reduce retention, cadence should be reduced.

---

# 40. Remove Ads Product

**CONFIRMED**

A real-money IAP permanently removes applicable Interstitial Ads.

---

# 41. Remove Ads Scope

**CONFIRMED — Final Decision Register v1.1**

Remove Ads removes **Interstitials only**.

It does not remove:

- optional Rewarded Ads.
- store products.
- content promos.

Exact real-money price remains **TBD**.

---

# 42. Remove Ads Persistence

Entitlement must survive:

- reinstall.
- device change after account/store restore.
- account linking.
- app update.

Use Store/backend validated entitlement.

---

# 43. Remove Ads Restore

Store screen/settings should support:

`Restore Purchases`

for eligible products.

---

# 44. Remove Ads Price

No real-money price is approved.

Price should be market-sensitive and configured in platform stores.

Do not hard-code display price.

Always load localized store price.

---

# 45. Coin Packs

**CONFIRMED**

Coin Pack IAP is approved.

---

# 46. Confirmed Coin Pack Ladder

**CONFIRMED — Final Decision Register v1.1**

- 1,000 Coins.
- 3,000 Coins.
- 7,000 Coins.
- 15,000 Coins.

Exact real-money prices remain **TBD** (market/store pricing research).

---

# 47. Coin Pack Design Principles

Pack ladder should provide:

- clear value progression.
- simple choice.
- no deceptive math.
- localized platform price.
- no excessive number of SKUs.

---

# 48. Best Value Labels

**PROPOSED**

Possible merchandising labels:

- الأكثر شيوعًا
- أفضل قيمة

Only use when mathematically defensible.

Do not create misleading discount claims.

---

# 49. Coin Pack Bonus Framing

**PROPOSED**

May display:

- total Coins.
- bonus percentage.

Example:
`+20%`

Only if compared against a clearly defined baseline.

---

# 50. Starter Pack

Not currently approved.

Do not add:

- starter bundle.
- first-purchase bundle.
- welcome sale.

without explicit product approval.

---

# 51. Subscription

No subscription is approved.

Do not assume:

- VIP.
- monthly pass.
- ad-free subscription.

---

# 52. Premium Currency

No premium currency is approved.

Do not add:

- Gems.
- Diamonds.
- Tokens.

without explicit approval.

---

# 53. Loot Boxes / Random Paid Rewards

Not part of current scope.

Do not add randomized paid reward mechanics.

---

# 54. Shop Information Architecture

MVP Shop should remain simple.

Sections:

1. Remove Ads.
2. Coin Packs.

Potential contextual items may deep-link to Shop, but Hints/Extra Moves should primarily remain in relevant gameplay flows.

---

# 55. Proposed Shop Layout

**PROPOSED**

Top:

- Coin balance.

Then:

- Remove Ads card.
- Coin Pack grid/list.

Future:

- Cosmetics section.

Avoid clutter with many banners/offers in MVP.

---

# 56. Contextual Offer vs Shop

Hint/Extra Moves/Rescue should be offered contextually.

Reason:

- player understands why the item matters.
- less navigation.
- clearer utility.

The Shop remains for general Coin top-up and Remove Ads.

---

# 57. Insufficient Coins Flow

When user tries a Coin purchase but balance is insufficient:

Offer:

- Coin Packs.
- Rewarded Coin Ad if available.
- Cancel.

Do not automatically open store purchase without user action.

---

# 58. Purchase Flow

```text
Select Product
→ Native Store Sheet
→ Purchase
→ Validation
→ Grant
→ Success
```

Failure:

- no grant.
- clear retry/close.

Pending:

- keep pending.
- reconcile later.

---

# 59. Store Price Display

Always use localized price from platform store.

Do not manually convert USD to EGP/AED/etc. in app.

---

# 60. Platform Product IDs

**PROPOSED**

Use stable SKU naming convention.

Example:

```text
remove_ads_lifetime
coins_1000
coins_3000
coins_7000
coins_15000
```

Exact IDs TBD.

---

# 61. Purchase Validation

**CONFIRMED — Final Decision Register v1.1**

IAP client: Flutter `in_app_purchase`.

Server-side validation through trusted **Cloud Functions / Cloud Run** for:

- Remove Ads.
- Coin Packs.

Client-only trust is not sufficient for durable value.

---

# 62. Purchase Idempotency

Each platform transaction ID must map to at most one internal grant.

Duplicate callbacks must not duplicate Coins/entitlements.

---

# 63. Purchase Pending State

App should support store transactions that remain pending.

Examples:

- parental approval.
- store processing.

Do not repeatedly prompt the player to purchase the same item while pending.

---

# 64. Refund Handling

Coin Pack refund policy depends on platform/store capabilities.

Backend should record:

- refund.
- revocation.

How previously spent Coins are handled requires product/legal decision.

---

# 65. Remove Ads Revocation

If platform reports valid entitlement revocation/refund:

Backend may update entitlement accordingly.

Exact behavior must align with store rules.

---

# 66. Purchase Restore

Restore flow should:

- query eligible purchases.
- validate.
- update entitlement.
- avoid duplicate Coin grants for consumable products.

Consumable Coin Pack restore behavior follows store semantics.

---

# 67. Purchase Error Categories

Internal categories:

- USER_CANCELLED
- STORE_UNAVAILABLE
- NETWORK_ERROR
- PENDING
- VALIDATION_FAILED
- ALREADY_OWNED
- PRODUCT_UNAVAILABLE
- UNKNOWN

Names are **PROPOSED**.

---

# 68. Economy Remote Config

Monetization/economy values should be remote-configurable where safe.

Examples:

- Hint Coin price.
- Extra Moves grant.
- Extra Moves Coin prices.
- Rescue cost.
- rewarded Coin amount.
- rewarded Coin daily cap.
- Interstitial eligibility.
- session cap.

---

# 69. What Must Not Be Arbitrarily Remote-Changed

Core rules should not be changed casually through monetization config.

Examples:

- Move cost.
- Stack legality.
- win condition.
- Association completion.

These require Rules versioning.

---

# 70. Economy Config Version

Each gameplay/economy transaction should be attributable to:

`economy_config_version`

where relevant.

This allows before/after analysis.

---

# 71. Ad Config Version

Ad exposure events should include:

`ad_config_version`

to analyze cadence experiments accurately.

---

# 72. Monetization Eligibility Service

**PROPOSED**

Central application service can answer:

- Can show Interstitial?
- Can offer Rewarded Ad?
- Can buy Extra Moves?
- Can use Rescue?
- Has Remove Ads?
- Has reached daily Coin-ad cap?

This avoids scattered monetization rules across UI screens.

---

# 73. Offer Context Model

Context may include:

- player ID.
- Attempt ID.
- Level.
- session ad count.
- recent ad timestamps.
- entitlement.
- Wallet balance.
- resource balance.
- remote config version.

---

# 74. Interstitial Eligibility

Conceptual:

```text
if remove_ads: false
if tutorial: false
if recent_rewarded_ad: false
if recent_purchase: false
if failure_moment: false
if session_cap_reached: false
if cooldown_not_met: false
else: eligible
```

Exact rules are **PROPOSED**.

---

# 75. Rewarded Ad Eligibility

Potential checks:

- placement enabled.
- provider available.
- daily/session cap not exceeded.
- current gameplay state eligible.
- reward not already granted for same token.

---

# 76. Offer Token

**PROPOSED**

Generate unique offer/grant token for transactional monetization interactions.

Useful for:

- rewarded Ads.
- Coin utility purchase.
- Extra Moves.
- Rescue.

Prevents double grant.

---

# 77. Ad Reward Transaction

Logical flow:

1. Create offer context.
2. Start ad.
3. Provider completes.
4. Validate completion policy.
5. Create idempotent RewardGrant.
6. Apply resource.
7. emit analytics.

---

# 78. Coin Utility Transaction

Logical flow:

1. Verify current price/config.
2. Verify Wallet balance.
3. create Wallet spend.
4. grant utility.
5. persist transaction.
6. update UI.

Spend + grant should be atomic or recoverably idempotent.

---

# 79. Hint Failure Refund

**PROPOSED**

If player pays for Hint but Solver cannot provide a valid Hint due to technical failure:

- restore consumed Hint/Coins.
- log error.

Do not charge for a failed technical response.

---

# 80. Extra Moves Failure Refund

If Coin spend succeeds but Moves cannot be granted due to state mismatch:

- transaction must roll back or compensating refund occurs.

---

# 81. Rescue Failure Refund

If rescue generation/validation fails:

- no Coin/ad reward should be consumed permanently.
- use rollback/compensation.

---

# 82. Monetization and Solver

Monetization must never influence initial Solver acceptance.

A board must pass:

- solvability.
- Move Limit.
- difficulty.

without:

- paid Extra Moves.
- paid Rescue.
- rewarded ad assistance.

---

# 83. Monetization and Difficulty

Difficulty tuning must be independent from revenue optimization.

Do not intentionally:

- tighten Move Limit to sell Extra Moves.
- increase ambiguous clues to sell Hints.
- create dead ends to sell Rescue.

This is a core product guardrail.

---

# 84. Monetization and Streak

Streak rewards are gameplay-earned Coins.

Do not reduce Streak reward dynamically based on payer status or ad status.

---

# 85. Monetization and Daily Rewards

Daily Rewards can generate Coins/Hints.

**CONFIRMED** 7-day repeating calendar and Streak milestones per Final Decision Register v1.1 / Game Economy Design.

Daily systems are **P0 at launch**. Continue measuring economy impact after soft launch.

---

# 86. Monetization and Daily Challenge

Daily Challenge reward may contribute to Coin income.

Do not make Daily Challenge rewards so large that Main Journey reward becomes irrelevant.

---

# 87. Monetization and Cosmetics

**CONFIRMED future sink category**

Cosmetics/Themes may use Coins.

Principle:

- cosmetic only.
- no gameplay advantage.

---

# 88. Paid Cosmetics

Not currently approved as real-money products.

If introduced later, separate approval required.

---

# 89. Event Monetization

No Event-specific paid pass is approved.

Events may use existing Coins/Ads/rewards unless future product decision adds more.

---

# 90. Pack Monetization

Permanent Special Packs exist in Full Product.

Whether Packs are:

- free.
- Coin-unlocked.
- paid.

is **TBD**.

Do not assume paid content Packs.

---

# 91. Leaderboard Monetization

No monetization should directly purchase leaderboard score.

Future competitive systems must remain fair.

---

# 92. Payer Segmentation

Analytics may segment:

- non-payer.
- Remove Ads purchaser.
- Coin Pack purchaser.
- repeat purchaser.

Do not change core Level rules based on payer status.

---

# 93. Personalized Offers

Not approved.

Do not implement player-specific prices/offers in MVP without explicit decision.

---

# 94. Dynamic Pricing

Not approved.

Store prices may vary by market automatically, but personalized dynamic pricing is out of scope.

---

# 95. Discounts

No discount strategy is approved.

Possible future:

- temporary Coin Pack sale.
- seasonal promotion.

Requires transparent store handling and approval.

---

# 96. First-Purchase Bonus

Not approved.

Do not implement without explicit approval.

---

# 97. Limited-Time Offers

Not approved for MVP.

Could be Post-MVP LiveOps feature.

---

# 98. Ad Mediation

**CONFIRMED direction — Final Decision Register v1.1**

Ads: **Google AdMob + Mediation**.

Final mediation network mix remains operational **TBD**.

---

# 99. Ad Provider Requirements

Must support:

- Rewarded Video.
- Interstitial.
- iOS/Android.
- MENA fill.
- consent/privacy integration.
- server-side callbacks where useful.
- stable Flutter/native SDK support if Flutter chosen.

---

# 100. Consent / Privacy

Ad and analytics SDKs must respect applicable consent/privacy requirements.

Exact consent framework depends on:

- launch markets.
- store policies.
- provider stack.

No consent implementation is selected here.

---

# 101. Child/Teen Consideration

Game audience is 13+.

Monetization should avoid manipulative mechanics targeted at minors.

No randomized paid reward system.

---

# 102. Purchase Confirmation UX

Before Coin spend:

Show:

- exact Coin cost.
- current balance.
- utility result.

Before real-money purchase:

Use platform-native purchase sheet with localized price.

---

# 103. No Silent Spending

Never automatically spend Coins for:

- Hint.
- Extra Moves.
- Rescue.

Player must explicitly confirm/select the action.

---

# 104. Post-Purchase Feedback

After success:

Show:

- product received.
- updated Coin balance or entitlement.
- clear success state.

Avoid excessive celebratory animation that delays returning to play.

---

# 105. Monetization Analytics Events

Core events:

- `shop_viewed`
- `product_viewed`
- `purchase_started`
- `purchase_completed`
- `purchase_failed`
- `purchase_pending`
- `purchase_restored`
- `rewarded_ad_offer_shown`
- `rewarded_ad_started`
- `rewarded_ad_completed`
- `rewarded_ad_failed`
- `rewarded_ad_reward_granted`
- `interstitial_eligible`
- `interstitial_shown`
- `interstitial_dismissed`
- `utility_offer_shown`
- `utility_purchased_coins`
- `utility_acquired_ad`

---

# 106. Monetization Event Properties

Include where relevant:

- product_id.
- price/local currency from store.
- placement.
- reward type.
- reward amount.
- Coin cost.
- Wallet balance before/after.
- Level.
- Attempt.
- Board Difficulty.
- Semantic Difficulty.
- economy_config_version.
- ad_config_version.
- Remove Ads entitlement.

---

# 107. Revenue KPIs

Track:

- gross IAP revenue.
- estimated net revenue.
- ad revenue.
- total revenue.
- ARPDAU.
- ARPU.
- ARPPU.
- payer conversion.
- purchase frequency.
- revenue per payer.

No target values approved.

---

# 108. Rewarded Ad KPIs

Track:

- offer rate.
- start rate.
- completion rate.
- grant success.
- ads/DAU.
- ads/session.
- placement mix.
- completion after utility reward.

---

# 109. Interstitial KPIs

Track:

- Interstitials/DAU.
- Interstitials/session.
- Levels between ads.
- exit after ad.
- next-Level start after ad.
- retention by ad exposure.

---

# 110. Remove Ads KPIs

Track:

- product impressions.
- Shop conversion.
- purchase conversion.
- restore success.
- user ad exposure before purchase.
- retention after purchase.

---

# 111. Coin Pack KPIs

Track:

- SKU views.
- conversion.
- revenue/SKU.
- repeat purchases.
- balance before purchase.
- balance after.
- sink usage after purchase.

---

# 112. Utility Monetization KPIs

Track:

- Hint Coin conversion.
- Hint Ad conversion.
- Extra Moves Coin conversion.
- Extra Moves Ad conversion.
- Rescue Coin conversion.
- Rescue Ad conversion.
- completion after utility.
- restart after utility.

---

# 113. Monetization Funnel

Conceptual:

```text
Offer Eligible
→ Offer Shown
→ CTA Selected
→ Transaction/Ad Started
→ Completed
→ Reward Granted
→ Gameplay Continued
→ Level Completed
```

Track loss at every stage.

---

# 114. Utility Value KPI

**PROPOSED**

`Utility Success Rate`

Percentage of utility grants followed by eventual Level completion.

Useful for assessing whether the utility actually helps.

---

# 115. Monetization Guardrails

Every monetization experiment must monitor:

- D1/D7 retention.
- session exits.
- Level completion.
- restart rate.
- Dead-End rate.
- Hint use.
- app review sentiment if available.
- crash rate.

---

# 116. Rewarded Ad Guardrail

If Rewarded Ad use increases but:

- Level completion falls.
- sessions shorten.
- frustration rises.

the feature may be compensating for unhealthy game tuning.

Investigate root cause.

---

# 117. Interstitial Guardrail

Do not increase frequency if:

- post-ad session exit rises materially.
- next-Level start declines.
- retention declines.

Revenue is not the only success criterion.

---

# 118. Coin Pack Guardrail

Coin Pack revenue should not depend on artificially starving players of normal earned Coins.

Monitor zero-balance rate and progression frustration.

---

# 119. Pricing Research

No pricing research has been approved or performed in this document.

When needed, evaluate:

- regional store pricing.
- competitor casual puzzle pricing.
- MENA purchasing power.
- Apple/Google price tiers.
- ad eCPM.
- payer behavior.

This may require fresh market research.

---

# 120. Localized Pricing

Platform stores handle local currency and tax display.

The backend/catalog should identify product, not manually calculate end-user price.

---

# 121. Egypt / GCC Pricing

No separate Egypt/GCC price strategy is approved.

Use platform price tiers initially unless product chooses manual regional pricing.

---

# 122. Purchase Currency

Real-money purchase reporting should store:

- local transaction currency.
- local amount.
- normalized reporting currency where analytics pipeline supports it.

Do not expose manual FX conversions to player.

---

# 123. Remote Monetization Configuration

**PROPOSED**

Potential keys:

```text
hint.coin_cost
hint.rewarded_enabled

extra_moves.amount
extra_moves.first_cost
extra_moves.second_cost
extra_moves.max_per_attempt
extra_moves.rewarded_enabled

rescue.coin_cost
rescue.max_per_attempt
rescue.rewarded_enabled

rewarded_coins.amount
rewarded_coins.daily_cap

interstitial.enabled
interstitial.min_levels
interstitial.session_cap
interstitial.cooldown_seconds
```

Exact names/values TBD.

---

# 124. Config Validation

Backend/client must validate monetization config:

- non-negative prices.
- sensible grants.
- max caps.
- compatible feature states.

Reject malformed Remote Config instead of applying dangerous values.

---

# 125. Config Rollback

Keep last-known valid configuration.

If new config causes issue:

- disable.
- rollback version.
- use safe bundled defaults.

---

# 126. Economy Simulation

Before finalizing prices:

Simulate:

- Coin income.
- Coin spend.
- Wallet distribution.
- Hint usage.
- Extra Moves.
- Rescue.
- Daily income.
- ad rewards.
- Coin Pack injection.

---

# 127. Economy Simulation Inputs

Need assumptions for:

- completion rate.
- Moves remaining.
- streak rewards.
- hints/player/day.
- retries.
- ad take rate.
- payer conversion.
- session frequency.

Values should come from playtest/live data.

---

# 128. Economy Health Outcome

Target concept:

Players should feel:

- Coins matter.
- Coins are earnable.
- spending decisions matter.
- occasional shortfall is understandable.
- purchase is optional convenience.

Avoid:

- permanent abundance.
- constant starvation.

---

# 129. Monetization Without Lives

Because there is no Lives/Energy:

Revenue relies more on:

- optional utility.
- ad engagement.
- Remove Ads.
- Coin Packs.
- future Cosmetics.

This keeps the product player-friendly but makes economy tuning more important.

---

# 130. No Forced Wait

Do not monetize by:

- timers.
- refill energy.
- forced wait after failure.

This is outside approved product direction.

---

# 131. No Forced Rewarded Ad

Rewarded Ad must not be mandatory to continue the core Journey.

Restart remains available.

---

# 132. No Pay-to-Solve

The game should not create paid exclusive solution information.

Hints are convenience, not required knowledge access.

---

# 133. No Pay-to-Unlock Main Journey

Main Journey level progression should not be hard-gated behind IAP under current scope.

---

# 134. Ad-Free Player Experience

Remove Ads player should still have full access to:

- Main Journey.
- Daily systems.
- optional Rewarded Ads.
- Shop.

No gameplay penalty for buying Remove Ads.

---

# 135. Payer Experience

Coin Pack buyer should not receive easier generated boards.

Payer status must not affect:

- Board Difficulty.
- Move Limit.
- content selection.
- Solver acceptance.

---

# 136. Rewarded Ad Revenue Attribution

Track by placement:

- Hint.
- Extra Moves.
- Rescue.
- Coins.

This reveals which ads are genuinely useful.

---

# 137. Interstitial Revenue Attribution

Track by:

- Level range.
- session.
- country.
- Remove Ads status.
- prior rewarded exposure.

Avoid overfitting early data.

---

# 138. Shop Exposure Rules

**PROPOSED**

Do not force-open Shop repeatedly.

Natural entry points:

- Home.
- insufficient Coins.
- Settings/Remove Ads.
- purchase contextual link.

---

# 139. Shop Badge

No aggressive notification badge is approved.

If used:

- only for meaningful new product/offer.
- not permanent red-dot pressure.

---

# 140. Purchase Confirmation After Coin Shortage

When balance insufficient:

Show choices clearly:

- Coin Pack.
- Rewarded Coin Ad if available.
- Cancel.

Avoid multiple stacked popups.

---

# 141. Ad Placement After Purchase

Do not show Interstitial immediately after IAP.

This would create poor perceived value.

---

# 142. Ad Placement After Rewarded Ad

Do not show Interstitial immediately after Rewarded Ad.

---

# 143. Ad Placement After Failure

Do not show Interstitial immediately after:

- Out-of-Moves decline.
- Dead-End.
- restart caused by failure.

Player is already in a frustration moment.

---

# 144. Ad Placement After Win

Natural candidate:

After Level Complete and reward presentation, before next Level.

But adaptive logic must still evaluate cooldown/cap.

---

# 145. Interstitial and Chapter Milestones

Potentially skip Interstitial on important milestone/chapter completion to preserve celebration.

**PROPOSED**

---

# 146. Ad-Free Purchase Trigger

Potential contextual surfaces:

- Shop.
- settings.
- after repeated Interstitial exposure.

Do not interrupt gameplay with aggressive Remove Ads upsell.

---

# 147. Remove Ads Offer Frequency

No repeated modal frequency approved.

Prefer persistent Shop option over repeated popups.

---

# 148. Economy and Ad Experimentation

Safe experiments:

- Hint Coin price.
- rewarded Coin amount.
- Extra Moves Coin price.
- Interstitial frequency.
- Shop layout.
- Coin Pack presentation.

Only after:

- Remote Config.
- event tracking.
- guardrails.

---

# 149. Experiment Prohibitions

Do not experiment without explicit approval on:

- whether a board is solvable.
- Move Limit secretly by payer.
- Hint quality by payer.
- intentional unfair dead ends.
- hidden personalized price discrimination.

---

# 150. Experiment Assignment

**PROPOSED**

Use stable player assignment.

Record:

- experiment_id.
- variant_id.
- exposure event.
- config version.

---

# 151. Experiment Metrics

For monetization tests:

Primary metric may be revenue/ad completion.

Mandatory guardrails:

- retention.
- level completion.
- session length.
- restart.
- crash rate.

---

# 152. Fraud & Abuse

Potential abuse:

- fake rewarded callbacks.
- purchase replay.
- duplicate Coin grant.
- modified client Wallet.
- clock manipulation for daily rewards.

Controls:

- server authority where appropriate.
- idempotency.
- store validation.
- server time.
- anomaly logging.

---

# 153. Ad Reward Fraud

If provider supports server-side verification:

Consider using it for:

- Coin reward.
- high-value utilities.

Final policy depends on provider and cost/complexity.

---

# 154. Offline Monetization

Core gameplay can be offline.

But:

- Ads require network.
- IAP requires store/network.
- server Wallet reconciliation may require network.

Offline fallback:

- Coin spend from locally trusted/reconciled balance if architecture allows.
- no fake ad availability.

Exact policy TBD.

---

# 155. Offline Hint

If Hint balance exists locally and Solver is local:

Hint can work offline.

Coin-funded Hint offline depends on Wallet authority/sync strategy.

---

# 156. Offline Extra Moves

Could work using locally available Coins if transaction reconciliation is safe.

Not yet approved technically.

---

# 157. Offline Purchase

Not supported in normal store flow.

UI should show unavailable state.

---

# 158. Customer Support

Support cases may include:

- purchase not granted.
- Remove Ads not restored.
- Coin balance mismatch.

Operational tools need:

- transaction lookup.
- entitlement lookup.
- idempotency reference.
- manual correction audit.

---

# 159. Manual Compensation

**PROPOSED**

Support may grant Coins via audited Wallet transaction.

Never directly edit balance without ledger/audit.

---

# 160. Purchase Reconciliation

Background job may reconcile:

- pending transactions.
- platform server notifications.
- entitlement state.

---

# 161. Monetization Logging

Structured logs for:

- purchase validation.
- reward grant.
- idempotency conflict.
- ad callback failure.
- Wallet spend failure.

Avoid storing unnecessary user-visible text.

---

# 162. Monetization Alerts

Critical:

- purchase success drops.
- validation failure spikes.
- duplicate grants.
- entitlement restore failures.

Product guardrail:

- session exits after ads spike.
- zero-coin rate sharply rises.

---

# 163. Monetization Dashboard

Recommended sections:

## Revenue
- IAP.
- Ads.
- ARPDAU.
- payer conversion.

## Ads
- rewarded funnel.
- interstitial frequency.
- exit guardrail.

## Economy
- sources/sinks.
- Wallet distribution.

## Utilities
- Hint.
- Extra Moves.
- Rescue.

## Store
- SKU conversion.
- Remove Ads.

---

# 164. Monetization Cohorts

Segment by:

- platform.
- country.
- Journey range.
- payer status.
- Remove Ads.
- new/returning user.
- difficulty exposure.
- acquisition source if available.

---

# 165. Payer Conversion Funnel

```text
Shop View
→ Product View
→ Purchase Start
→ Purchase Success
→ Repeat Purchase
```

Separate:

- Remove Ads.
- Coin Packs.

---

# 166. Ad Conversion Funnel

```text
Offer Shown
→ Ad Start
→ Ad Complete
→ Reward Grant
→ Utility Used
→ Level Completed
```

---

# 167. Utility Choice Split

Track when both Coins and Rewarded Ad are available:

- % Coin.
- % Ad.
- % decline.

This is a key economy signal.

---

# 168. Coin Value Calibration

If almost everyone chooses:

- Ads → Coin price may be too high.
- Coins → rewarded value may be weak or Coin supply too abundant.
- decline → utility may not feel valuable.

Interpret with context, not one metric.

---

# 169. Remove Ads Value Calibration

If users rarely buy Remove Ads:

Possible causes:

- low ad exposure.
- price too high.
- offer visibility low.
- users prefer rewarded-only model.

Do not automatically increase ad pressure to drive purchase.

---

# 170. Coin Pack Value Calibration

If Coin Packs underperform:

Investigate:

- whether Coins are unnecessary.
- pack values.
- prices.
- Shop visibility.
- utility relevance.

Do not intentionally create Coin starvation as first response.

---

# 171. Store Product Metadata

Store catalog should include:

- internal product ID.
- platform SKU.
- product type.
- Coin amount/entitlement.
- active status.
- sort order.
- presentation metadata.

Price comes from store.

---

# 172. Product Availability

If store product unavailable:

- hide or disable gracefully.
- do not display stale manual price.

---

# 173. Purchase State Recovery

On app launch:

- process pending store transactions.
- validate.
- grant exactly once.
- refresh entitlement/Wallet.

---

# 174. Monetization QA

Test:

- purchase success.
- purchase cancel.
- pending.
- validation failure.
- duplicate callback.
- restore.
- refund/revocation.
- Rewarded Ad success/failure.
- Interstitial gating.
- Remove Ads suppression.
- Coin spend atomicity.
- insufficient balance.
- offline states.

---

# 175. Sandbox Testing

Use Apple/Google sandbox/test tracks.

Never test production charges casually.

---

# 176. Ad QA

Test:

- no-fill.
- network error.
- completion.
- skip/not complete.
- duplicate callback.
- app background.
- Remove Ads entitlement.
- cooldown/session cap.

---

# 177. Economy QA

Verify:

- Coin sources.
- Coin sinks.
- no negative balance.
- idempotency.
- reward formula.
- Daily limits.
- config rollback.

---

# 178. Store Compliance

Final implementation must comply with:

- Apple App Store.
- Google Play.
- local consumer/privacy rules.

Policies should be checked again near launch because store requirements evolve.

---

# 179. Monetization MVP P0

P0:

- Rewarded Ad: Hint.
- Rewarded Ad: Extra Moves.
- Rewarded Ad: Dead-End Rescue.
- Rewarded Ad: Coins.
- Adaptive Interstitials.
- Remove Ads.
- Coin Packs.
- Shop.
- Coin-funded Hint.
- Coin-funded Extra Moves.
- Coin-funded Dead-End Rescue (no Mid-Level Reshuffle).
- Purchase validation via Cloud Functions / Cloud Run.
- entitlement persistence.
- monetization analytics.
- Remote Config.

---

# 180. Monetization P1

Potential P1:

- refined adaptive ad logic.
- improved Shop merchandising.
- Daily Reward economy tuning.
- Daily Challenge reward tuning.
- market-specific pricing experiments.

---

# 181. Monetization Post-MVP

Potential future:

- Coin-funded Cosmetics.
- special Pack monetization if approved.
- event offers if approved.
- cosmetic real-money products if approved.

Not currently approved:

- subscription.
- battle pass.
- premium currency.
- loot boxes.
- starter pack.
- randomized paid rewards.

---

# 182. Confirmed Economy Values Register

**CONFIRMED — Final Decision Register v1.1**

- Starting Coins: 300
- Starting Hints: 3
- Hint: 75 Coins
- Extra Moves: +5
- Extra Moves first price: 150 Coins
- Extra Moves second price: 250 Coins
- Max Extra Moves rescues: 2/Attempt
- Dead-End Rescue: 200 Coins
- Max Rescue: 1/Attempt
- Mid-Level Reshuffle: **not in MVP**
- Rewarded Coin Ad: 100 Coins
- Rewarded Coin Ads: 3/day
- Interstitial baseline: adaptive every 3–5 completed Levels; max 3/session
- Remove Ads: Interstitials only
- Coin Packs: 1k / 3k / 7k / 15k
- Real-money prices: **TBD**

---

# 183. Pricing Approval Requirements

Before locking any Coin price:

Need:

1. Level reward distribution.
2. average remaining Moves.
3. streak reward distribution.
4. Hint use.
5. failure rate.
6. Extra Moves demand.
7. Daily rewards.
8. rewarded ad use.
9. wallet balance simulation.
10. playtest feedback.

---

# 184. Real-Money Pricing Approval Requirements

Before locking Store pricing:

Need:

1. launch markets.
2. store price tiers.
3. competitor research.
4. ad eCPM expectations.
5. Coin utility value.
6. payer conversion testing.
7. tax/store commission assumptions.

---

# 185. Monetization Decision Register — Confirmed

The following are **CONFIRMED**:

1. Coins are the primary soft currency.
2. Level base reward = 50 Coins.
3. Remaining Moves reward = 2 Coins per Move.
4. Streak grants Coins.
5. Hint balance exists.
6. Hints may be acquired with Coins.
7. Hints may be acquired with Rewarded Ads.
8. Extra Moves can use Coins.
9. Extra Moves can use Rewarded Ads.
10. Dead-End Rescue can use Coins/Rewarded Ads.
11. Rewarded Ads can grant Coins.
12. Interstitial Ads are adaptive.
13. Remove Ads is an IAP.
14. Coin Packs are IAP.
15. No Lives/Energy.
16. Rewarded Ads are optional.
17. Coins may later buy Cosmetics/Themes.
18. No starter bundle currently approved.
19. No premium currency approved.
20. Remove Ads removes Interstitials only; Rewarded Ads remain.
21. Coin Pack ladder 1k/3k/7k/15k confirmed; real-money prices TBD.
22. IAP validation via Cloud Functions / Cloud Run.
23. Ads: Google AdMob + Mediation.
24. No Mid-Level Reshuffle in MVP.

---

# 186. Monetization Decision Register — Proposed / Requires Approval

The following remain **PROPOSED/TBD**:

1. All real-money prices (Remove Ads + Coin Packs).
2. Exact interstitial cooldown seconds (beyond confirmed caps/baseline).
3. Final ad mediation network mix (AdMob + Mediation confirmed; partners TBD).
4. Server-side rewarded verification depth/provider callbacks.
5. Personalized offers (not approved for MVP).
6. Discounts / limited-time offers (not approved for MVP).
7. Pack monetization model (free / Coin / real-money) — future.
8. Paid Cosmetics — DEFERRED.
9. Offline Coin-spend reconciliation edge cases (queued idempotent spend is approved direction).
10. Refund handling for consumed Coin Packs.
11. Exact Shop layout polish.
12. Utility offer eligibility micro-rules.
13. Firebase/GCP quotas/billing for purchase Functions/Run.

**CONFIRMED (no longer open):** starting Coins/Hints; Hint/Extra Moves/Rescue prices & caps; rewarded Coin amount/cap; interstitial baseline & session cap; Remove Ads = Interstitials only; Coin Pack ladder; no Mid-Level Reshuffle MVP; IAP validation via Cloud Functions/Cloud Run; AdMob + Mediation; Flutter `in_app_purchase`.

---

# 187. Recommended Approval Order

Before monetization implementation is frozen:

1. Approve rescue behavior.
2. Approve starting Coins/Hints.
3. Approve Hint price.
4. Approve Extra Moves quantity/pricing/cap.
5. Approve Rescue/Reshuffle price/cap.
6. Approve rewarded Coin amount/cap.
7. Approve Interstitial guardrail logic.
8. Approve Coin Pack ladder.
9. Run economy simulation.
10. choose Ads provider/mediation.
11. choose IAP validation architecture.
12. define Store SKUs.
13. set market prices.
14. soft-launch test.
15. tune from real data.

---

# 188. Recommended MVP Monetization Baseline

A conservative MVP baseline is:

- Optional Rewarded Ads.
- Contextual Hint/Extra Moves/Rescue offers.
- Adaptive Interstitials only between Levels.
- Remove Ads lifetime entitlement.
- 3–4 simple Coin Packs.
- No subscription.
- No premium currency.
- No starter bundle.
- No paywall.
- No paid random rewards.
- Server-validated IAP.
- Idempotent Wallet/reward transactions.
- Remote Config for tunable values.
- Monetization guardrails tied to retention/gameplay health.

Exact prices and frequencies should remain configurable until enough live data exists.

---

# 189. Dependencies

This Monetization Specification feeds:

1. **API Specification**
2. **Game Economy final balancing**
3. **Shop UI Specification**
4. **Cloud Save & Sync Specification**
5. **Backend purchase validation**
6. **Analytics & KPI dashboards**
7. **Remote Config specification**
8. **QA & Store Test Plan**
9. **MVP WBS / Product Backlog**
10. **Launch Readiness Checklist**

---

# 190. Baseline Status

This document is **Monetization Specification v1.0** — **Decision-Aligned** to **Final Decision Register v1.1** (Firebase-first).

It defines the monetization surfaces, utility offers, ad behavior, IAP structure, purchase/grant integrity, economy integration, analytics, experimentation, and guardrails for the Arabic Solitaire Association game.

Approved economy amounts, Remove Ads = Interstitials only, Coin Pack ladder, AdMob + Mediation, and Cloud Functions/Cloud Run IAP validation are **CONFIRMED**. Exact real-money prices and Firebase/GCP quotas/billing remain **TBD**.

**End of Monetization Specification v1.0**
