# ADR: Flame 2.5D First

**Status:** Accepted  
**Date:** 2026-09-05

## Context

The mobile MVP needs a polished, portrait association-solitaire board with
depth, shadows, card motion, particles, and fixed-camera chapter atmosphere.
Running an embedded Unity activity adds build, platform, bridge, and iteration
cost before the product requires a freely navigable 3D world.

## Decision

Use Flutter + Flame for the MVP gameplay presentation.

- Flutter owns navigation, app UI, overlays, accessibility, and product systems.
- Flame renders the fixed-camera 2.5D board and translates pointer intent into
  `GameAction` values.
- `game_engine` remains the only authority for legality and state transitions.
- `game_solver` and `level_generator` remain presentation-independent.
- The previous Flutter widget board remains a diagnostic fallback.
- Unity code and contracts remain in the repository but are paused.

## 2.5D boundary

The first renderer may use perspective staging, parallax, layered shadows,
card tilt, particles, and chapter set dressing. It must not add camera roaming,
3D physics, or presentation-owned gameplay rules.

## Future 3D path

A future Unity, Godot, or other 3D renderer must integrate through the same
immutable snapshot and intent boundary:

```text
GameState snapshot -> renderer
player intent -> GameAction -> GameEngine -> next GameState
```

This makes a later 3D phase a renderer replacement instead of a rules rewrite.

## Consequences

- Faster mobile iteration and one primary Dart/Flutter toolchain for MVP.
- Smaller runtime and platform integration surface than the embedded Unity path.
- Full 3D still requires a deliberate renderer implementation later; it is not
  an automatic conversion from Flame.
