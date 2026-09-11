# Flutter + Unity Hybrid Architecture v1.0

**Status:** SUPERSEDED for MVP by `ADR_FLAME_2_5D_FIRST_v1.0.md`
**Product:** سوليتير العرب: أسطورة المعاني  
**Approving decision:** Explicit Phase 1 hybrid implementation request (this workstream).  
**Supersedes for presentation runtime:** older “Flutter-only MVP baseline / Unity not selected” notes in architecture docs — Flutter remains the application shell; Unity is an optional presentation runtime only.

---

## 1. Ownership boundaries

| Concern | Owner | Must not |
|---|---|---|
| Application bootstrap, auth, Firebase | Flutter | — |
| Content bundles, journey, settings, non-gameplay UI | Flutter | — |
| Progression, economy, monetization, analytics orchestration | Flutter | — |
| Navigation into/out of gameplay | Flutter | — |
| Authoritative rules, transitions, hints, generation | Pure Dart (`game_engine`, `game_solver`, `level_generator`) | Depend on Flutter/Unity/Firebase SDKs |
| 3D board, cards, animation, VFX, lighting, camera, chapter environments, Shiboub presentation, in-runtime cinematics | Unity | Implement or validate gameplay rules |
| Bridge message schemas | `packages/unity_bridge_contracts` (pure Dart) + mirrored C# DTOs | Drift from Engine codecs |

**Authoritative flow**

```text
Unity GameAction intent
  → Dart GameplayController / GameEngine
  → GameTransition
  → authoritative GameState + events
  → Unity presentation
```

Never create a second rules engine in C#.

---

## 2. Runtime lifecycle

1. Flutter starts the attempt (generate/resume via Drift).
2. If presentation mode is `unity3d` and Unity becomes ready, Flutter sends `initialize` then `loadLevel` / `stateSnapshot`.
3. Unity emits `unityReady`, then only `actionIntent` / control requests.
4. Dart validates revision + dedupes IDs, applies action, returns `transitionResult` or full `stateSnapshot` after recovery.
5. On exit/shutdown Flutter sends `shutdown`; Unity tears down presentation only.
6. If Unity is unavailable, Flutter keeps `flutter2d` gameplay.

---

## 3. Message flow

Versioned JSON envelopes (`schemaVersion`, `messageId`, `sessionId`, `attemptId`, `levelDefinitionId`, `revision`, `type`, optional `requestId`, `payload`).

**Flutter → Unity:** `initialize`, `loadLevel`, `stateSnapshot`, `transitionResult`, `hintResult`, `pause`, `resume`, `showStoryBeat`, `shutdown`, `fatalError`.

**Unity → Flutter:** `unityReady`, `actionIntent`, `requestHint`, `requestRestart`, `requestExit`, `storyBeatSkipped`, `presentationCompleted`, `clientError`.

Payloads reuse Engine codecs:

- `GameStateCodec`
- `ActionCodec`
- `GameEvent.toJson()`

Stale intents (`revision` mismatch) and duplicate `messageId`/`requestId` are rejected without advancing the authoritative revision incorrectly.

---

## 4. Failure recovery

- Unity disconnect / process death: Flutter keeps the active attempt in Drift; on reconnect send full `stateSnapshot`.
- Parse/schema errors: Flutter sends `fatalError` or forces `flutter2d` fallback; never trust Unity-mutated state.
- Rejected moves: still persist Engine `nextState` when streak resets; Unity plays reject feedback from events/state.
- Never save gameplay state to Firebase per move.

---

## 5. Pause / resume / background

- App background → Flutter sends `pause`; Unity freezes presentation clocks/input.
- Foreground → `resume`; if Unity missed messages, resync via `stateSnapshot`.
- OS process recreation: Flutter restores attempt from Drift, then re-initializes Unity.

---

## 6. Bridge versioning

- `schemaVersion` is required on every envelope.
- Unknown schema or type → typed error; do not best-effort apply.
- Additive payload fields allowed within a major schema; breaking changes bump schema version and require coordinated Dart + C# updates.

---

## 7. Android and iOS integration direction

**Phase 1:** contracts + Editor Mock Mode + Unity vertical slice. No production native embed package yet.

**Next native direction (Android first):**

1. Prefer official **Unity as a Library** with a thin owned Android bridge.
2. Mirror a thin iOS bridge after Android path is proven.
3. Consider a third-party Flutter↔Unity wrapper only if actively maintained and compatible with the installed Flutter + Unity LTS versions.

Until native embed is reliable (init, round-trip, pause/resume, process recreation, performance, tests), default presentation remains `flutter2d`.

---

## 8. Editor Mock Mode

Unity Play Mode can run without Flutter:

- Loads JSON fixtures produced from real Dart `GameStateCodec` snapshots (Cairo fixture).
- Accepts intents and returns **deterministic mock** `transitionResult` / snapshots for accepted/rejected moves, stock advance/restore, undo, hint highlight, win.
- Mock Mode is a development transport only — not a C# rules engine.

---

## 9. Testing strategy

- Dart: envelope round-trips, Arabic UTF-8, schema/type validation, stale revision, duplicate IDs, accepted/rejected transitions, Flutter 2D fallback, Unity-unavailable fallback.
- Flutter: controller compatibility; mock transport tests.
- Unity EditMode: DTO validation, stale revision, board mapping, Arabic strings, event→animation command mapping.
- Unity PlayMode: Cairo fixture load, card count, intent emit, accept/reject board updates, completion VFX, recoverable mock disconnect.

---

## 10. Why Dart remains authoritative

Engine ↔ Solver ↔ Generator parity is release-critical. UI convenience (Flutter or Unity) must never change legality. A C# rules fork would diverge from Solver acceptance and offline Main Journey generation.

---

## 11. Flutter 2D fallback

`GameplayPresentationMode.flutter2d` is the default until Unity is confirmed ready. Existing 2D widgets remain fully functional. `unity3d` is feature-flagged and must fall back when Unity is not ready.

---

## 12. Known content blocker

`apps/mobile/assets/content/bundle/story_beats.json` still contains Layla/ليلى copy that conflicts with the approved Narrative Canon (Shiboub / Dar Al-Rawabit). Do **not** author final Unity cinematics from that file until content is corrected.
