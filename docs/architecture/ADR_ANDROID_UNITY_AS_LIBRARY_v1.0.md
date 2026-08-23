# ADR: Android Flutter ↔ Unity as a Library Integration v1.0

**Status:** APPROVED (Phase 3)  
**Date:** 2026-08-23  
**Context:** [`FLUTTER_UNITY_HYBRID_ARCHITECTURE_v1.0.md`](FLUTTER_UNITY_HYBRID_ARCHITECTURE_v1.0.md)

---

## Decision

Integrate Unity on Android using **official Unity as a Library (UaL)** with an **owned thin transport layer**:

| Layer | Responsibility |
|---|---|
| `packages/unity_bridge_contracts` | Versioned JSON envelopes, codecs |
| Dart `UnityBridgeCoordinator` + `GameplayController` | Authoritative rules, transitions |
| Flutter `AndroidUnityBridgeTransport` | MethodChannel / EventChannel adapter |
| Kotlin `UnityBridgePlugin`, `UnityMessageBroker`, `UnityRuntimeController` | Lifecycle + threading + transport validation only |
| Kotlin `UnityGameplayActivity` | Full-screen Unity player Activity |
| Unity `FlutterBridgeReceiver` + `NativeBridgeTransport` | Presentation + intents only |

**Rejected without approval:** `flutter_unity_widget` and other third-party wrappers.

---

## Topology

```text
┌─────────────────────────────────────────────────────────────┐
│ FlutterActivity (MainActivity)                               │
│  GameplayScreen / UnityRuntimeService                         │
│  UnityBridgeCoordinator ──► AndroidUnityBridgeTransport      │
└───────────────────────────┬─────────────────────────────────┘
                            │ MethodChannel + EventChannel
                            │ (cached FlutterEngine)
┌───────────────────────────▼─────────────────────────────────┐
│ UnityBridgePlugin / UnityMessageBroker (application scope)   │
└───────────────┬─────────────────────────────┬─────────────┘
                │ Intent                         │ UnitySendMessage
┌───────────────▼──────────────┐   ┌───────────▼──────────────┐
│ UnityGameplayActivity         │   │ unityLibrary (exported)   │
│  NativeBridgeTransport        │◄──│ FlutterBridgeReceiver     │
└───────────────────────────────┘   └──────────────────────────┘
```

Message envelope: existing `schemaVersion`, `messageId`, `sessionId`, `attemptId`, `levelDefinitionId`, `revision`, `type`, optional `requestId`, `payload`.

Unity receiver (fixed contract):

- **GameObject:** `FlutterBridgeReceiver`
- **Method:** `OnFlutterMessage(string jsonEnvelope)`

Unity outbound entry: `UnityMessageBroker.onUnityMessage(String json)` on the current Activity.

---

## Why this fits the existing architecture

- Dart engine/solver/generator remain authoritative; Android never parses `GameAction` legality.
- Flutter shell keeps journey, Firebase, economy, and fallback UI.
- Unity keeps presentation-only responsibilities from Phase 2.
- Reuses `UnityBridgeCoordinator` without bypass.
- Editor Mock Mode (`MockBridgeTransport` + Cairo fixture) stays isolated from production Android path.

---

## Generated vs tracked files

| Tracked (owned) | Generated (reproducible, not committed by default) |
|---|---|
| Unity export Editor script | `apps/mobile/android/unityLibrary/` full module |
| Kotlin bridge sources | Gradle caches, `.gradle/`, APK/AAB |
| Unity `FlutterBridgeReceiver`, `NativeBridgeTransport` | Unity `Library/`, `Temp/`, `Logs/` |
| Flutter transport + runtime service | Machine-specific export logs |
| ADR, runbook, tests | Large IL2CPP/native binaries |

**Policy:** `unityLibrary/` is gitignored unless explicitly approved for CI artifact storage (likely Git LFS or external artifact store). Owned adapter code lives in `apps/mobile/android/app/src/main/kotlin/.../unity/`.

---

## Unity export process

1. Menu: **Arab Solitaire > Build > Export Android Library**
2. Or batch: Unity `-batchmode -executeMethod ArabSolitaire.EditorTools.AndroidLibraryExporter.ExportFromCommandLine`
3. Output: `apps/mobile/android/unityLibrary/` (relative to repo root, no absolute paths stored)
4. Post-export: Gradle `include(":unityLibrary")` when directory exists
5. Flutter `BuildConfig.UNITY_LIBRARY_AVAILABLE` reflects presence

Export validates: Android target, required scenes (`Bootstrap`, `GameplayCore`, `Chapter_Cairo_Greybox`), portrait orientation, IL2CPP/ARM64 settings.

---

## Flutter engine lifecycle

- `MainActivity` caches `FlutterEngine` in `FlutterEngineCache` (`"main"`).
- `UnityGameplayActivity` uses broker singleton wired to cached engine's Dart isolate.
- Flutter UI pauses while Unity Activity is foreground; bridge callbacks continue on platform thread → Dart.
- On Unity exit, Activity result returns to Flutter; coordinator sends full `stateSnapshot` if needed.

---

## Unity Activity lifecycle

- `UnityGameplayActivity` extends `UnityPlayerGameActivity` when `unityLibrary` present; otherwise stub Activity reports failure.
- `onCreate`: read session Intent extras, init Unity, register broker.
- `onPause`/`onResume`: pause/resume Unity player + audio focus.
- `onDestroy`: shutdown broker queue, notify Flutter.
- Portrait locked; `configChanges` aligned with Unity requirements.
- Process death: Flutter restores attempt from Drift, re-opens Unity with fresh snapshot.

---

## Message routing and threading

- All Unity API calls on Android main/UI thread.
- Inbound Flutter→Unity queued until Unity player ready (bounded queue, default 32).
- Duplicate `messageId` suppressed at Android transport layer; authoritative dedupe remains in Dart.
- Stale `sessionId` rejected at Android layer; stale `revision` rejected in Dart.
- Shutdown clears pending queue safely.

---

## Failure fallback

| Condition | Player UX |
|---|---|
| `unityLibrary` absent | Arabic recoverable message; continue in Flutter 2D |
| Init timeout (30s default) | Retry Unity / Flutter 2D / exit |
| Unsupported schema | Flutter 2D fallback |
| Unity disconnect | Recoverable error + snapshot replay |
| Activity crash | Return to Journey; attempt persisted in Drift |

Never trap player on blank Unity screen.

---

## Gradle integration

- Conditional `include(":unityLibrary")` in `settings.gradle.kts`.
- `app` depends on `:unityLibrary` when present.
- ABI: `arm64-v8a` primary (Unity 6000 mobile default); configurable.
- Manifest merge for Unity Activity, hardware acceleration, large heap flag optional.
- ProGuard keep rules for `FlutterBridgeReceiver`, Unity player, broker classes.

---

## Known Unity as a Library limitations

- Large binary size; first export multi-GB workspace churn locally.
- Export is machine/Unity-version sensitive; reproducible via pinned Unity **6000.5.9f1**.
- Cannot run batch export while Unity Editor holds project lock.
- IL2CPP build time significant; not run in default CI without Unity license.
- Single Unity player instance per process; guard against double launch.

---

## Future iOS equivalent

Mirror topology:

- UnityFramework embedded in iOS runner
- `FlutterBridgeReceiver` contract unchanged
- Owned Swift broker + EventChannel
- Same JSON envelopes

Out of scope for Phase 3.

---

## Rejected alternatives

| Alternative | Reason |
|---|---|
| `flutter_unity_widget` | Third-party maintenance/version risk; not approved |
| Rules in Kotlin/C# | Violates architecture ownership |
| Cairo JSON fixture in production | Editor Mock Mode only |
| Commit full `unityLibrary` binary to git | Size + reproducibility; export script instead |
| Replace Flutter Android app structure | Existing flavors (dev/qa/staging/prod) must remain |
