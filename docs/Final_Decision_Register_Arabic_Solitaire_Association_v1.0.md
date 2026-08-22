# Final Decision Register

## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision Baseline After Product/Architecture Closure  
**Purpose:** Consolidate all major project decisions into three groups: **APPROVED**, **DEFERRED**, and **STILL TBD** before updating the project artifacts.

---

# 1. APPROVED — Core Product & Gameplay

- Product direction: inspired-by + develop the concept with original Arabic identity/content/assets.
- Audience: General 13+.
- Market: Arab world.
- Language: simplified modern Arabic with controlled dialect influence.
- Main Journey: evergreen-first.
- Temporary/current/trending content belongs primarily to Events/Packs.
- Core gameplay uses Association Cards inside the deck.
- Association Cards are inactive in Tableau and active only in Association Slots.
- Association Card may be placed on a same-group Member Stack in Tableau.
- Member Stack → Association Card in Tableau is invalid.
- Combined Association Stack is atomic and cannot receive more cards until moved to Slot.
- Member stacks are atomic and cannot split.
- Same-group stacks may merge.
- Empty Tableau column accepts any movable unit.
- Automatic reveal of newly exposed Tableau card.
- Stock shows up to last 3 visible cards; only top/final visible is playable.
- Unlimited Restore Stock; remaining order preserved; Restore costs 1 Move.
- Every valid gameplay move costs exactly 1 Move.
- Invalid attempts cost 0 Moves and reset current streak counter.
- Hint costs no Move and suggests but does not execute.
- Undo: one eligible move only; no consecutive Undo; restores Move; cannot Undo a completion/removal move.
- Win requires clearing all cards.
- Fixed visible Move Limit per Level.
- Restart uses a new random shuffle while preserving Level configuration/content.
- Initial Tableau has exactly one face-up card per column.
- Association Slots start empty.
- All cards are fully randomized across Tableau + Stock.
- Board generation must be Solver-valid within the fixed Move Limit.
- Player freedom: any rule-valid move is allowed even if strategically bad.
- Automatic Dead-End detection exists.
- Dead-End rescue exists.
- No Lives/Energy.

---



# 2. APPROVED — Rewards, Economy & Monetization

- Base Level completion reward: 50 Coins.
- Remaining Moves reward: 2 Coins per remaining Move.
- Correct-action streak:
  - 3 correct → +3 Coins.
  - 4 correct → +4 Coins.
  - 5-tier reached → every subsequent 5-correct streak grants +5 Coins.
- Starting Coins: 300.
- Starting Hints: 3.
- Hint price: 75 Coins.
- Extra Moves grant: +5 Moves.
- Extra Moves pricing:
  - first rescue: 150 Coins.
  - second rescue: 250 Coins.
  - max 2 Extra-Move rescues per Attempt.
- Dead-End Rescue:
  - Solver-Guided Recovery State.
  - preserve completed progress as much as possible.
  - guarantee a winning continuation.
  - cost: 200 Coins.
  - max 1 rescue per Attempt.
- No separate Mid-Level Reshuffle in MVP.
- Rewarded Coin Ad: 100 Coins.
- Rewarded Coin Ads cap: 3/day.
- Rewarded Ads supported for:
  - Hints.
  - Extra Moves.
  - Dead-End Rescue.
  - Coins.
- Interstitials:
  - adaptive.
  - baseline around every 3–5 completed Levels.
  - max 3/session.
  - not immediately after Rewarded Ad, purchase, tutorial, failure, Dead-End, or Out-of-Moves decline.
- Remove Ads removes Interstitials only.
- Optional Rewarded Ads remain after Remove Ads.
- Coin Pack ladder:
  - 1,000.
  - 3,000.
  - 7,000.
  - 15,000 Coins.
- No Starter Pack in MVP.
- No Subscription.
- No Premium Currency.
- No paid randomized reward system.

---



# 3. APPROVED — Progression & Launch Content

- Endless numerical Main Journey.
- Standard Chapter size: 50 Levels.
- Launch content: 5 Chapters = 250 Level Definitions.
- Difficulty structure: 10-Level Wave × 5 per Chapter.
- Long-term difficulty rises while local waves provide relief.
- Two difficulty axes:
  - Board Difficulty.
  - Semantic Difficulty.
- Group-size progression:
  - groups of 3 first.
  - groups of 4 become standard.
  - groups of 5/mixed introduced later.
- Sequential unlocking:
  - complete Level N to unlock Level N+1.
- Same Association Clue reuse cooldown: at least 20 Levels.
- Exact same Variant cannot repeat inside the same Chapter.
- Text remains dominant content type.
- Early/mid Levels: max one visual Association per Level.
- Illustration content introduced gradually after tutorial/early Levels.
- Chapter completion reward: 500 Coins + 2 Hints.

---



# 4. APPROVED — Daily Systems

- Daily Reward: 7-day repeating calendar.
- Missing a day does not reset Daily Reward progression.
- Daily Streak breaks after a missed day.
- Daily Reward values:
  - Day 1: 100 Coins.
  - Day 2: 125 Coins.
  - Day 3: 150 Coins.
  - Day 4: 1 Hint.
  - Day 5: 175 Coins.
  - Day 6: 200 Coins.
  - Day 7: 300 Coins + 1 Hint.
- Daily Streak milestone rewards:
  - 3 days: 100 Coins.
  - 7 days: 250 Coins.
  - 14 days: 400 Coins.
  - 30 days: 750 Coins.
- Daily Challenge reward: 150 Coins.
- Daily Challenge retries: unlimited during the valid day.
- Daily Challenge board: fixed deterministic board per challenge cohort.
- Daily Challenge reward auto-granted on first completion.
- Daily Challenge reset: 00:00 validated player-local timezone.
- Backend is authoritative for Daily time/eligibility.
- Initial launch includes:
  - P0.
  - Daily Reward.
  - Daily Challenge.
  - Daily Streak.
- Smart Notification infrastructure is included at launch.
- Initially active notification types:
  - Daily Challenge.
  - Streak Risk.
- Notification quiet hours: 22:00–09:00 player-local time.

---



# 5. APPROVED — Client Architecture

- Mobile framework: Flutter.
- State management: Riverpod.
- Local database: Drift / SQLite.
- Orientation: Portrait only.
- Minimum iOS: iOS 15.
- Minimum Android: Android 8 / API 26.
- Tablet support: responsive support from the same app.
- Game Engine is framework-independent from UI/state management.
- Solver implementation: Pure Dart.
- Solver search direction: hybrid search with canonicalization/memoization/bounded search.
- Solver execution model: Hybrid:
  - on-device Main Journey generation.
  - on-device Hint/Dead-End where practical.
  - same Solver core reusable in CMS/CI/backend simulation.
  - backend fallback available if needed.

---



# 6. APPROVED — Backend & Cloud

- Backend: ASP.NET Core.
- Backend architecture: Modular Monolith initially.
- Primary DB: PostgreSQL.
- Cloud provider: Azure.
- Hosting: Azure Container Apps.
- Database: Azure Database for PostgreSQL Flexible Server.
- Content/object storage: Azure Blob Storage.
- Delivery/CDN: Azure Front Door/CDN.
- Container Registry: Azure Container Registry.
- Secrets: Azure Key Vault.
- IaC: Bicep.
- CI/CD: GitHub Actions.
- Environments:
  - DEV.
  - TEST.
  - STAGING.
  - PROD.
- Single primary Azure region at launch + DR plan.
- No Kubernetes in MVP by default.
- No Redis in MVP by default.
- No Message Broker in MVP by default.
- Background worker + DB-backed jobs are sufficient initially.
- Managed PostgreSQL backups + PITR + regular restore drills.

---



# 7. APPROVED — Identity, Cloud Save & Offline

- Anonymous-first identity.
- Local anonymous ID created first.
- Cloud anonymous profile created at first connection.
- Optional Apple/Google linking.
- Provider links to the same player_id.
- If provider is already linked elsewhere, use explicit conflict flow; no automatic merge.
- Active Attempt persistence: Local-first.
- Durable cloud state includes progression/economy.
- Cloud conflict policy is domain-specific:
  - Progression → merge to highest valid progression.
  - Wallet → server-authoritative ledger.
  - Purchases/Entitlements → store/backend authoritative.
  - Settings → latest revision.
  - Active Attempt → local/device-specific.
- Main Journey fully playable offline once required content is downloaded.
- Offline Coin spending allowed against locally reconciled balance.
- Offline spend uses queued idempotent transactions for later reconciliation.
- Purchases and Rewarded Ads require network.

---



# 8. APPROVED — Content Delivery & Content Operations

- Hybrid content delivery:
  - bundled base content.
  - remote versioned content bundles.
- Content activation:
  - download.
  - validate hash.
  - validate schema.
  - validate rules compatibility.
  - atomic activation.
- Keep last-known-valid bundle for rollback.
- AI creates Draft content only.
- Human Arabic + semantic approval mandatory.
- Production content approval is separate from Publisher action.
- Publisher/Admin can immediately disable problematic content without app release.
- Main Journey includes a simple “Report a problem” action from launch.

---



# 9. APPROVED — Analytics, Ads, IAP & Notifications

- Product analytics: Firebase Analytics.
- BigQuery export enabled.
- Raw analytics retention baseline: 14 months, then cost review.
- Mobile crash reporting: Firebase Crashlytics.
- Backend observability:
  - Azure Application Insights.
  - Azure Monitor.
- Ads: Google AdMob + Mediation.
- IAP client: Flutter `in_app_purchase`.
- IAP validation: server-side.
- Push notifications: Firebase Cloud Messaging.
- Client-facing Remote Config: Firebase Remote Config.
- Authoritative backend config/versioning remains server-controlled.

---



# 10. APPROVED — Admin / CMS

- CMS frontend: Angular.
- Admin authentication: Microsoft Entra ID.
- MFA for privileged access.
- Production publish permission separated from ordinary content editing.
- Broad Economy / Notification changes require:
  - re-authentication.
  - explicit confirmation.
- Audit log retention: 2 years.
- Admin/CMS must support:
  - Content authoring/review.
  - Level configuration.
  - Solver validation.
  - publishing/rollback.
  - economy/configuration.
  - audit.
  - essential player support.

---



# 11. APPROVED — QA & Security

- Severity model:
  - S0 Blocker.
  - S1 Critical.
  - S2 Major.
  - S3 Minor.
  - S4 Trivial.
- Release blocked by:
  - any S0.
  - any unresolved S1 affecting core path.
- Release simulation:
  - 10,000+ boards for critical Templates/Configs.
  - smaller volumes allowed for simpler configurations.
- Test coverage:
  - no vanity overall percentage.
  - full critical Game Engine rule-path coverage.
  - mandatory automated coverage for Solver, Economy, Purchases.
- Pre-launch security:
  - automated security checks.
  - focused external/manual penetration test for backend/Admin/purchase flows.
- Solver/Game Engine parity is release-critical.
- Accepted unsolvable board is a release blocker.

---



# 12. APPROVED — LiveOps & Rollout

- Temporary Events: Post-launch.
- First Event only after Daily systems and core metrics are stable.
- Initially max one major Event active at a time.
- First Event:
  - 10 Levels.
  - core rules only.
  - no new currency.
  - no leaderboard.
- Launch strategy:
  - staged / limited production rollout.
  - then expand across Arab markets.
  - not a long Egypt-only launch.

---



# 13. DEFERRED — Explicitly Post-MVP

- Player XP / Player Level.
- Achievements.
- Badges.
- Collections.
- Permanent Special Packs.
- Leaderboards.
- richer Smart Notification types beyond Daily Challenge/Streak Risk.
- major temporary Event system until post-launch.
- paid Cosmetics unless later approved.
- advanced LiveOps/event economy.
- Redis unless justified by real load/use case.
- Message Broker unless justified by decoupling/scale.
- Kubernetes unless future scale/operational requirements justify it.

---



# 14. STILL TBD — Decisions Intentionally Left Open



## Commercial

- Exact real-money prices for:
  - Remove Ads.
  - Coin Pack 1,000.
  - Coin Pack 3,000.
  - Coin Pack 7,000.
  - Coin Pack 15,000.
- Pricing must be decided after market/store pricing research.



## Packs

- Future Pack monetization:
  - free.
  - Coin unlock.
  - real-money unlock.
- No paid Pack at initial introduction.



## Solver / Technical Tuning

- Exact Solver algorithm composition after benchmarking.
- Exact timeout/performance budgets.
- Whether native optimization is ever necessary.
- Exact backend fallback rules.



## Delivery / Staffing

- Final team size.
- final role allocation.
- final hourly rates.
- final calendar dates.
- final commercial budget.
- final P0/P1 delivery dates.



## Production Operations

- Exact DR RPO/RTO values.
- exact autoscaling thresholds.
- detailed Azure sizing/SKUs.
- final ad mediation network mix.
- final penetration-test vendor.
- exact analytics cost thresholds that trigger retention-policy review.

---



# 15. CLOSED DECISION STATUS

At this point, the major product, gameplay, architecture, cloud, economy, progression, Daily, monetization, CMS, analytics, QA, security, and LiveOps baseline decisions required to update the existing project documents are substantially closed.

Remaining TBD items are mostly:

- commercial pricing.
- infrastructure sizing.
- measured performance thresholds.
- staffing/calendar.
- future Post-MVP monetization choices.

These do **not** block updating the current product/specification documents to a new approved baseline.

---



# 16. Next Step

Perform one controlled update pass across all affected project artifacts:

1. Full Product Scope.
2. MVP Scope.
3. Game Economy Design.
4. Progression Design.
5. Screen Inventory & User Flows.
6. Content Design System.
7. Arabic Content Guidelines.
8. Level Design Framework.
9. Difficulty Model.
10. Solver Specification.
11. Game Engine Technical Design.
12. Data Model.
13. Software Architecture.
14. Backend & Cloud Architecture.
15. Analytics & KPI Specification.
16. Monetization Specification.
17. LiveOps & Events Design.
18. Admin/CMS Specification.
19. QA & Automated Game Validation Strategy.
20. MVP Product Backlog / WBS.
21. Estimation & Delivery Roadmap.

The update pass should convert now-approved items from **PROPOSED/TBD** to **APPROVED/CONFIRMED**, remove superseded proposals, and recalculate the planning spreadsheets where decisions changed scope or estimates.

**End of Final Decision Register v1.0**