# سوليتير العرب: أسطورة المعاني

**Solitaire Al-Arab: The Legend of Meanings**

Arabic-first association solitaire. This repository is a Flutter + pure-Dart monorepo with a Firebase-first cloud baseline.

## Read first (required for contributors and agents)

1. [`CURSOR_PROJECT_CONTEXT.md`](CURSOR_PROJECT_CONTEXT.md) — master implementation context
2. [`CURSOR_RULES.md`](CURSOR_RULES.md) — non-negotiable coding rules
3. [`.cursor/rules/`](.cursor/rules/) — always-applied Cursor rules
4. Sprint docs under [`docs/`](docs/) — start with Sprint 0 / Sprint 1 as relevant

Do not invent product decisions. Do not add Azure / ASP.NET / PostgreSQL / K8s / Redis for MVP.

## Repository layout

```text
apps/mobile          Flutter application (Arabic RTL shell)
apps/admin           CMS placeholder (Angular later)
packages/game_engine Pure Dart rules (no Flutter/Firebase/Riverpod)
packages/game_solver Pure Dart solver → game_engine
packages/level_generator Pure Dart generator → engine + solver
firebase/            Rules, indexes, functions placeholder
docs/                Product & technical specifications
scripts/             Developer / CI helpers
```

## Architecture (Sprint 0)

```text
UI / Application (Flutter + Riverpod)
        ↓
Domain packages (game_engine → game_solver → level_generator)
        ↓
Platform adapters (Drift, Firebase skeletons)
```

- Game Engine does **not** depend on Flutter or Firebase.
- Solver depends on Game Engine contracts only.
- Generator depends on Engine + Solver.
- Melos is **not** used; Dart pub **workspace** + path deps.

## Prerequisites

- Flutter **stable** (repo developed on Flutter 3.44.x / Dart 3.12.x)
- Android SDK (min API **26**)
- Xcode 15+ on macOS for iOS (deployment target **iOS 15**)
- Optional: Firebase CLI for rules deploy after projects exist

## Setup

```bash
# From repository root
dart pub get

cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Environments

| Env     | Dart entry              | Android flavor |
|---------|-------------------------|----------------|
| DEV     | `lib/main_dev.dart`     | `dev`          |
| TEST    | `lib/main_test.dart`    | `qa` (Android forbids flavor name `test`) |
| STAGING | `lib/main_staging.dart` | `staging`      |
| PROD    | `lib/main_prod.dart`    | `prod`         |

```bash
cd apps/mobile
flutter run --flavor dev -t lib/main_dev.dart
```

**Application IDs** currently use placeholder `com.arabsolitaire.app[.dev|.test|.staging]`. Replace with the approved organization reverse-domain before store submission (`PLACEHOLDER_ORG_ID`).

## Firebase

Firebase is wired structurally but **does not block offline bootstrap**.

Until real projects exist:

- keep `AppConfig.firebaseConfigured = false` (default)
- do not commit `google-services.json` / `GoogleService-Info.plist` / generated `firebase_options.dart`

See [`docs/firebase/SETUP.md`](docs/firebase/SETUP.md).

Firestore / Storage rules ship as **deny-by-default** under [`firebase/rules/`](firebase/rules/).

## Code generation

```bash
cd apps/mobile
dart run build_runner build --delete-conflicting-outputs
# Localization ARB → flutter gen-l10n (runs with flutter pub get / build)
```

Generated Drift files (`*.g.dart`) are produced locally/CI and are gitignored via analyzer exclude; prefer regenerating rather than hand-editing.

## Tests

```bash
# Dependency boundaries
dart run scripts/check_dependency_boundaries.dart

# Packages
cd packages/game_engine && dart test
cd packages/game_solver && dart test
cd packages/level_generator && dart test

# Mobile
cd apps/mobile
flutter test
```

## Builds

```bash
cd apps/mobile
flutter build apk --debug --flavor dev -t lib/main_dev.dart

# iOS (macOS only) — CI iOS build is intentionally deferred
flutter build ios --no-codesign -t lib/main_dev.dart
```

## Analysis / format

```bash
dart format .
cd apps/mobile && flutter analyze
```

## Sprint 0 scope

Foundation only: monorepo, Arabic RTL shell, Riverpod, Drift skeleton, Firebase skeletons, CI. **No gameplay rules** yet — that is Sprint 1 (`game_engine`).
