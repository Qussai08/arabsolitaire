# Architecture overview (Sprint 0)

```text
UI/Application (apps/mobile)
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
| `apps/mobile` | all domain packages + Flutter/Firebase | putting rules inside widgets |

Automated check: `dart run scripts/check_dependency_boundaries.dart`

## Offline

Main Journey gameplay must not require a network roundtrip once content is available. Firebase init failure must not block local bootstrap.
