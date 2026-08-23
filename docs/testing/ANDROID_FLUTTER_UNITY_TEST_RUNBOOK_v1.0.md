# Android Flutter ↔ Unity Test Runbook v1.0

**Phase:** 3 — Android integration  
**Date:** 2026-08-23

---

## Prerequisites

| Tool | Version / note |
|---|---|
| Flutter SDK | repo-pinned (see `apps/mobile/pubspec.yaml`) |
| Android SDK | API 26+; ARM64 emulator or device |
| JDK | 17 |
| Unity | **6000.5.9f1** at `unity/ArabSolitaireUnity` |
| Unity export | optional for Flutter 2D builds; required for Unity 3D |

---

## 1. Dart / Flutter validation (always)

From repo root:

```bash
dart test packages/unity_bridge_contracts
dart test packages/game_engine
dart test apps/mobile/test/features/gameplay/unity_bridge_fallback_test.dart
dart test apps/mobile/test/features/gameplay/unity_bridge_coordinator_test.dart
flutter analyze apps/mobile
```

Expected: all tests pass; analyze has no errors.

---

## 2. Android native unit tests

From `apps/mobile/android`:

```bash
./gradlew :app:testDevDebugUnitTest
```

Covers `UnityMessageBroker` ordering, duplicate suppression, stale session, queue limits.

---

## 3. Unity EditMode / PlayMode

Close Unity Editor before batchmode export/tests.

```bash
"<Unity.exe>" -batchmode -nographics -projectPath unity/ArabSolitaireUnity \
  -runTests -testPlatform EditMode -testResults unity/EditModeResults.xml -quit

"<Unity.exe>" -batchmode -nographics -projectPath unity/ArabSolitaireUnity \
  -runTests -testPlatform PlayMode -testResults unity/PlayModeResults.xml -quit
```

Or use Unity Test Runner GUI while developing.

---

## 4. Unity Android library export

**Menu:** Arab Solitaire > Build > Export Android Library

**Batchmode:**

```bash
"<Unity.exe>" -batchmode -nographics -projectPath unity/ArabSolitaireUnity \
  -executeMethod ArabSolitaire.EditorTools.AndroidLibraryExporter.ExportFromCommandLine -quit
```

Output: `apps/mobile/android/unityLibrary/` (gitignored by default).

Verify `apps/mobile/android/unityLibrary.README.md` is regenerated.

---

## 5. Flutter Android builds

Without export (Flutter 2D only — expected in CI):

```bash
cd apps/mobile
flutter build apk --flavor dev --debug
```

With export present (Unity 3D available):

```bash
cd apps/mobile
flutter build apk --flavor dev --debug
```

Verify logcat tag `UnityMessageBroker` shows no unhandled exceptions during launch.

---

## 6. Manual device E2E checklist (Unity 3D)

1. Launch dev flavor; sign in anonymously (dev config).
2. Journey → Cairo level.
3. Enable `unity3d` presentation flag (dev toggle / provider override).
4. Open gameplay → Unity Activity foreground.
5. Confirm real generated Arabic board (not Cairo JSON fixture).
6. Accepted move round-trip.
7. Rejected move round-trip.
8. Hint request.
9. Advance / restore stock.
10. Background + resume → authoritative snapshot replay.
11. Back → safe return to Journey; attempt persisted.
12. Reopen attempt → state restored.
13. Switch to `flutter2d` → existing board still works.

Capture `adb logcat` for bridge tags if diagnosing transport issues.

---

## 7. CI strategy

| Job | Runs | Blocker? |
|---|---|---|
| Dart bridge tests | every PR | yes |
| Android unit tests | Android workflow | yes |
| Flutter 2D APK dev debug | every PR | yes |
| Unity export + IL2CPP | manual / licensed runner | no (documented only) |

Do **not** store Unity license in repo. Do **not** add permanently failing Unity CI job.

---

## 8. Known blockers

- Unity export absent → Unity 3D reports unavailable; Flutter 2D remains playable.
- No ARM64 emulator → use physical device for Unity E2E.
- Unity Editor open → batchmode export/tests may fail with project lock.
