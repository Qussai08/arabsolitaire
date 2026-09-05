# Architecture overview (Sprint 0)

```text
UI/Application (apps/mobile)
  Flutter shell + Flame 2.5D board
       ↓
Domain Packages
  game_engine
       ↑
  game_solver
       ↑
  level_generator
       ↓
External Data / Platform Adapters
  Drift/SQLite · Firebase skeletons · Analytics abstraction
```

## Hard boundaries

| Package | May depend on | Must not depend on |
|---------|---------------|--------------------|
| `game_engine` | Dart SDK only | Flutter, Firebase, Riverpod, UI |
| `game_solver` | `game_engine` | Flutter UI, Firebase |
| `level_generator` | `game_engine`, `game_solver` | Flutter UI, Firebase core generation |
| `apps/mobile` | all domain packages + Flutter/Flame/Firebase | putting rules inside renderers or widgets |

Automated check: `dart run scripts/check_dependency_boundaries.dart`

## Offline

Main Journey gameplay must not require a network roundtrip once content is available. Firebase init failure must not block local bootstrap.

## Gameplay presentation

The mobile MVP uses Flame as a presentation-only 2.5D renderer. Flutter owns
navigation, overlays, progression, economy, and accessibility. Flame converts
pointer intent to `GameAction`; `game_engine` remains the only rules authority.

See `ADR_FLAME_2_5D_FIRST_v1.0.md` for the migration boundary and future 3D path.
