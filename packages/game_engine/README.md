# game_engine

Pure Dart authoritative game rules for **سوليتير العرب: أسطورة المعاني**.

## Public API

```dart
const engine = GameEngine();
final transition = engine.applyAction(state, action);
```

- No Flutter / Firebase / Riverpod / Drift dependencies.
- Deterministic `GameState + GameAction → GameTransition`.
- Serialization: `GameStateCodec` / `ActionCodec`.
- Replay: `GameReplay.run`.

## Rules version

- `gameEngineRulesVersion` = `1.0.0`
- `gameEngineSaveSchemaVersion` = `1`

## Stock model (Sprint 1)

- `undealt` draw pile + `waste` cycle.
- Advance draws one card onto waste.
- Visible window = last up to 3 waste cards; playable = last.
- Restore available when undealt is empty and waste is not; preserves order.
