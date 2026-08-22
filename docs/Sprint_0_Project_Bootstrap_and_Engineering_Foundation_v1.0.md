# Sprint 0 — Project Bootstrap & Engineering Foundation
## سوليتير العرب: أسطورة المعاني

**Version:** 1.0  
**Status:** READY FOR IMPLEMENTATION  
**Sprint Type:** Technical Foundation / Bootstrap  
**Primary Tooling:** Cursor + Flutter + Dart + Firebase + GitHub Actions  
**Master Context:** `CURSOR_PROJECT_CONTEXT.md`  
**Rules:** `CURSOR_RULES.md` + `.cursor/rules/*.mdc`

---

# 1. Sprint 0 Objective

Create a production-grade engineering foundation for **سوليتير العرب: أسطورة المعاني** before implementing gameplay features.

Sprint 0 must establish:

- repository structure;
- Flutter application bootstrap;
- pure-Dart domain package boundaries;
- Riverpod baseline;
- Drift/SQLite baseline;
- Firebase initialization skeleton;
- DEV / TEST / STAGING / PROD environment separation;
- code quality and linting;
- automated testing baseline;
- GitHub Actions CI;
- local developer setup;
- logging/crash baseline;
- dependency boundaries;
- initial architectural verification.

Sprint 0 should **not** implement the full game.

The main deliverable is a clean, testable, extensible codebase ready for:

> **Sprint 1 — Game Engine Rules v1**

---

# 2. Sprint 0 Success Criteria

Sprint 0 is complete only when:

1. Project builds successfully on Android.
2. Project builds successfully on iOS.
3. Flutter app launches to a minimal Arabic-first bootstrap screen.
4. RTL works from first launch.
5. DEV / TEST / STAGING / PROD configuration structure exists.
6. `game_engine` pure-Dart package compiles independently.
7. `game_solver` pure-Dart package compiles independently.
8. `level_generator` pure-Dart package compiles independently.
9. Package dependency direction is valid.
10. Riverpod is configured in application layer only.
11. Drift database initializes and migration strategy exists.
12. Firebase bootstrap exists without blocking offline app startup.
13. Static analysis passes.
14. Unit test command passes.
15. GitHub Actions runs analysis + tests + build validation.
16. Secrets are not committed.
17. README contains local setup instructions.
18. Cursor rules/context are committed at repository root.
19. No unapproved gameplay behavior is introduced.
20. No Azure / always-on backend infrastructure is added.

---

# 3. Target Repository Structure

Recommended initial repository:

```text
/
├── apps/
│   ├── mobile/
│   │   ├── android/
│   │   ├── ios/
│   │   ├── lib/
│   │   │   ├── app/
│   │   │   │   ├── bootstrap/
│   │   │   │   ├── config/
│   │   │   │   ├── navigation/
│   │   │   │   └── app.dart
│   │   │   │
│   │   │   ├── core/
│   │   │   │   ├── error/
│   │   │   │   ├── logging/
│   │   │   │   ├── localization/
│   │   │   │   ├── storage/
│   │   │   │   ├── analytics/
│   │   │   │   └── feature_flags/
│   │   │   │
│   │   │   └── features/
│   │   │       └── bootstrap/
│   │   │
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   └── admin/
│       └── README.md
│
├── packages/
│   ├── game_engine/
│   ├── game_solver/
│   └── level_generator/
│
├── firebase/
│   ├── functions/
│   ├── firestore/
│   ├── storage/
│   ├── rules/
│   └── indexes/
│
├── docs/
│   ├── product/
│   ├── gameplay/
│   ├── architecture/
│   ├── narrative/
│   ├── qa/
│   └── decisions/
│
├── scripts/
│
├── .cursor/
│   └── rules/
│
├── .github/
│   └── workflows/
│
├── CURSOR_PROJECT_CONTEXT.md
├── CURSOR_RULES.md
├── README.md
├── analysis_options.yaml
└── .gitignore
```

Notes:

- `apps/admin` is a placeholder only during Sprint 0.
- Do not create the Angular CMS implementation yet.
- Do not create additional packages unless a real boundary exists.

---

# 4. Sprint 0 Work Breakdown Structure

---

## EPIC S0.1 — Repository Foundation

### S0.1.1 Initialize Repository Structure

Create:

- `apps/mobile`
- `apps/admin`
- `packages/game_engine`
- `packages/game_solver`
- `packages/level_generator`
- `firebase`
- `docs`
- `scripts`
- `.github/workflows`
- `.cursor/rules`

### Acceptance Criteria

- Directory structure matches approved architecture.
- Repository can be cloned and understood without tribal knowledge.
- No gameplay feature code exists yet.

---

### S0.1.2 Add Master Context & Cursor Rules

Commit:

- `CURSOR_PROJECT_CONTEXT.md`
- `CURSOR_RULES.md`
- `.cursor/rules/*.mdc`

### Acceptance Criteria

- Files exist at documented paths.
- README tells contributors/agents to read them first.
- Rules are committed to source control.

---

### S0.1.3 Root Git Hygiene

Configure:

- `.gitignore`
- editor/temp exclusions;
- Flutter/Dart generated files;
- Firebase local artifacts;
- environment/secrets exclusions;
- IDE-generated files where appropriate.

### Acceptance Criteria

No secrets or local generated credentials are tracked.

---

# 5. EPIC S0.2 — Flutter Mobile Bootstrap

## S0.2.1 Create Flutter Application

Create Flutter app under:

```text
apps/mobile/
```

Approved baseline:

- Flutter stable compatible with current project tooling;
- Dart null safety;
- iOS minimum 15;
- Android minimum API 26;
- portrait orientation.

### Acceptance Criteria

- `flutter pub get` succeeds.
- Android debug build succeeds.
- iOS simulator build succeeds on macOS environment.
- Portrait orientation enforced.

---

## S0.2.2 App Bootstrap Layer

Create:

```text
lib/app/bootstrap/
lib/app/config/
lib/app/navigation/
```

Bootstrap order:

1. Widgets binding.
2. environment load.
3. logging.
4. Firebase initialization.
5. Crashlytics initialization.
6. Drift initialization.
7. local config/content metadata.
8. Remote Config safe initialization.
9. Authentication state.
10. repositories.
11. analytics.
12. app shell.

### Important

Firebase failure must not prevent local bootstrap where the game can operate offline.

---

## S0.2.3 Minimal Application Shell

Create only a technical startup shell.

Required:

- Material app;
- Arabic locale baseline;
- RTL;
- placeholder Home/Bootstrap screen;
- no final art;
- no gameplay implementation.

Suggested temporary text:

```text
سوليتير العرب
أسطورة المعاني
```

### Acceptance Criteria

- App renders RTL correctly.
- No English-first layout assumptions.
- Bootstrap screen works on phone and tablet emulator sizes.

---

# 6. EPIC S0.3 — Environment Configuration

## S0.3.1 Define Environments

Required:

- DEV
- TEST
- STAGING
- PROD

Use typed environment representation.

Example conceptual model:

```dart
enum AppEnvironment {
  dev,
  test,
  staging,
  prod,
}
```

Do not hard-code production behavior throughout the codebase.

---

## S0.3.2 Environment Entry Points

Recommended:

```text
lib/main_dev.dart
lib/main_test.dart
lib/main_staging.dart
lib/main_prod.dart
```

or an equivalent flavor-based approach.

### Acceptance Criteria

Each environment can be selected explicitly.

---

## S0.3.3 Flutter Flavors / Application IDs

Prepare separate package/application identifiers where practical.

Example structure only:

```text
DEV      com.<company>.solitaire.dev
TEST     com.<company>.solitaire.test
STAGING  com.<company>.solitaire.staging
PROD     com.<company>.solitaire
```

**Important:** exact reverse-domain/company identifier is a repository/config decision and must use the real approved organization identifier, not this placeholder.

### Cursor Rule

If the final identifier is unavailable:

- use a clearly marked placeholder;
- do not silently lock it.

---

# 7. EPIC S0.4 — Pure Dart Package Bootstrap

## S0.4.1 `game_engine`

Create a pure Dart package.

Initial contents should be minimal:

```text
lib/
  game_engine.dart
  src/
    version/
```

Do **not** implement full gameplay rules in Sprint 0.

### Required

- package compiles without Flutter;
- unit test runs;
- no Flutter/Firebase/Riverpod imports.

---

## S0.4.2 `game_solver`

Create pure Dart package.

Allowed dependency:

```text
game_solver -> game_engine
```

### Required

- no Flutter dependency;
- no UI dependency;
- initial placeholder contract only.

---

## S0.4.3 `level_generator`

Create pure Dart package.

Allowed dependencies:

```text
level_generator -> game_engine
level_generator -> game_solver
```

### Required

- no Flutter UI dependency;
- no Firebase dependency for core generation logic.

---

## S0.4.4 Dependency Direction

Approved direction:

```text
game_engine
    ↑
game_solver
    ↑
level_generator
```

Application may depend on all three.

The reverse is prohibited.

### Acceptance Criteria

A dependency graph review confirms no invalid imports.

---

# 8. EPIC S0.5 — Riverpod Baseline

## S0.5.1 Install Riverpod

Add approved Riverpod packages appropriate for Flutter application state.

Use Riverpod for:

- bootstrap state;
- application orchestration;
- UI state;
- repository injection.

Do not place gameplay rules in providers.

---

## S0.5.2 Root Provider Scope

App root must include ProviderScope.

Keep provider overrides possible for:

- tests;
- environments;
- mock repositories.

---

## S0.5.3 Initial Bootstrap Provider

Create a simple bootstrap/application readiness state.

Example conceptual states:

```text
initializing
ready
recoverableError
fatalError
```

Do not overbuild state machines before actual requirements appear.

---

# 9. EPIC S0.6 — Drift / SQLite Baseline

## S0.6.1 Add Drift

Configure:

- Drift;
- SQLite backend;
- code generation;
- migration support.

---

## S0.6.2 Initial Database

Create local DB skeleton.

Suggested initial technical tables:

### `app_metadata`

Fields may include:

- key;
- value;
- updated_at.

### `schema_metadata`

Track:

- schema version;
- migration metadata.

Do not create full gameplay schema yet unless required by the latest Data Model specification.

---

## S0.6.3 Migration Strategy

Required:

- explicit schema version;
- upgrade hooks;
- migration tests;
- no destructive fallback in production.

### Acceptance Criteria

- DB opens.
- DB closes cleanly.
- migration test exists.
- data is not wiped during normal schema migration.

---

# 10. EPIC S0.7 — Firebase Bootstrap

## S0.7.1 Firebase Projects

Prepare environment mapping for:

- DEV;
- TEST;
- STAGING;
- PROD.

If actual Firebase projects are not created yet:

- configure structure/placeholders;
- document exact manual setup required;
- do not invent credentials.

---

## S0.7.2 Firebase Core

Add:

- Firebase Core.

Initialize safely.

### Requirement

If Firebase initialization fails in a recoverable offline scenario:

- log;
- continue local bootstrap where safe.

---

## S0.7.3 Firebase Authentication Skeleton

Prepare Firebase Auth integration.

MVP identity direction:

- Anonymous-first.
- Google linking later.
- Apple linking later.

Sprint 0 only requires:

- service/repository boundary;
- initialization capability;
- no complete account UX.

---

## S0.7.4 Firestore Skeleton

Create repository/data-source boundaries only.

Do not implement per-Move persistence.

Do not trust Firestore client writes for authoritative economy operations.

---

## S0.7.5 Firebase Storage Skeleton

Prepare configuration only.

Use later for:

- content bundles;
- approved remote assets.

---

## S0.7.6 Remote Config Skeleton

Implement safe fetch/activate wrapper.

Rules:

- application must have defaults;
- Remote Config failure cannot break core launch;
- sensitive authoritative config stays backend-controlled.

---

## S0.7.7 Crashlytics

Initialize Crashlytics.

Configure:

- Flutter framework error capture;
- uncaught async errors;
- environment metadata.

Do not log sensitive/private user data.

---

## S0.7.8 Analytics

Create analytics abstraction.

Sprint 0 event examples only:

- `app_started`
- `bootstrap_completed`
- `bootstrap_failed`

Avoid implementing full event taxonomy yet.

---

# 11. EPIC S0.8 — Logging & Error Foundation

## S0.8.1 Logging Abstraction

Create application logger abstraction.

Support:

- debug;
- info;
- warning;
- error.

No direct uncontrolled `print()` calls in production code.

---

## S0.8.2 Error Model

Create minimal application failure model.

Suggested conceptual distinction:

```text
RecoverableFailure
FatalFailure
```

Do not create hundreds of error classes prematurely.

---

## S0.8.3 Global Error Capture

Capture:

- Flutter errors;
- uncaught zone errors;
- async bootstrap errors.

Send to Crashlytics when enabled.

---

# 12. EPIC S0.9 — Localization & RTL Baseline

## S0.9.1 Arabic-First Localization

Configure Flutter localization tooling.

Default locale:
- Arabic.

Secondary English support may exist structurally if already approved, but Arabic must be first-class.

---

## S0.9.2 RTL Verification

Verify:

- app bar direction;
- text direction;
- padding/alignment;
- navigation;
- icon mirroring where appropriate.

### Acceptance Criteria

No core bootstrap UI depends on LTR assumptions.

---

# 13. EPIC S0.10 — Navigation Baseline

Create lightweight routing.

Do not over-engineer navigation.

Required temporary routes:

```text
/
bootstrap
home
```

Only add more when actual feature implementation begins.

---

# 14. EPIC S0.11 — Static Analysis / Coding Standards

## S0.11.1 `analysis_options.yaml`

Configure strict enough rules for production work.

Target:

- no ignored analyzer warnings without reason;
- avoid dynamic where strong typing is practical;
- enforce unused/import cleanup;
- favor immutable state.

---

## S0.11.2 Formatting

Use Dart formatter.

CI must fail if formatting policy is violated where practical.

---

## S0.11.3 Generated Files

Document which generated files are:

- committed;
- ignored;
- regenerated in CI.

Keep policy consistent.

---

# 15. EPIC S0.12 — Testing Foundation

## S0.12.1 Unit Test Baseline

Create at least one test per pure Dart package.

Purpose:
- confirm packages resolve;
- confirm CI sees tests.

---

## S0.12.2 Flutter Test Baseline

Create:

- application bootstrap test;
- basic RTL rendering test;
- dependency override test where useful.

---

## S0.12.3 Drift Migration Test

Required before Sprint 0 closes.

---

## S0.12.4 Test Helpers

Create minimal test utilities only when repeated use justifies them.

Do not build an oversized test framework in Sprint 0.

---

# 16. EPIC S0.13 — CI/CD Foundation

## S0.13.1 GitHub Actions — Pull Request Validation

Create workflow:

```text
PR Validation
```

Steps:

1. checkout;
2. install Flutter;
3. resolve dependencies;
4. format check;
5. analyze;
6. Dart package tests;
7. Flutter tests;
8. debug build validation.

---

## S0.13.2 Package Tests

CI must explicitly test:

- `game_engine`;
- `game_solver`;
- `level_generator`.

---

## S0.13.3 Build Validation

Minimum:

- Android build.

If macOS runner budget/workflow is acceptable:
- iOS build validation.

If iOS CI cost is intentionally deferred:
- document it explicitly;
- do not pretend it is covered.

---

## S0.13.4 Environment Deployment

Sprint 0 does **not** require automated production deployment.

Prepare workflow structure only.

No automatic PROD deployment.

---

# 17. EPIC S0.14 — Firebase Security Baseline

## S0.14.1 Firestore Rules

Create safe initial rules.

Rules must not use unrestricted production wildcard access.

If no collections exist yet:
- deny by default.

---

## S0.14.2 Storage Rules

Default deny where no approved access path exists.

---

## S0.14.3 Secrets

Secrets must not exist in source files.

Use:

- Firebase platform config files where expected by SDK;
- CI secrets;
- environment configuration;
- local uncommitted files as applicable.

Server secrets belong in trusted server environment.

---

# 18. EPIC S0.15 — Documentation

## S0.15.1 Root README

Must include:

- project description;
- prerequisites;
- Flutter version expectation;
- setup;
- environment selection;
- Firebase setup;
- code generation commands;
- test commands;
- build commands;
- architecture overview;
- Cursor context/rules notice.

---

## S0.15.2 Architecture README

Document:

```text
UI/Application
       ↓
Domain Packages
       ↓
External Data/Platform Adapters
```

Explicitly state:
- Game Engine does not depend on Flutter/Firebase.
- Solver depends on Game Engine contracts.
- Generator depends on Engine + Solver.

---

## S0.15.3 Firebase Setup Guide

Document manual steps:

- project creation;
- Android app registration;
- iOS app registration;
- Auth enablement;
- Firestore;
- Storage;
- Remote Config;
- Analytics;
- Crashlytics.

Do not place secret credentials in docs.

---

# 19. EPIC S0.16 — Dependency Boundary Verification

Add one of:

- architectural tests;
- CI grep/script;
- package-level dependency validation;
- documented enforced review gate.

At minimum verify:

```text
game_engine !-> Flutter
game_engine !-> Firebase
game_engine !-> Riverpod

game_solver !-> Flutter UI
game_solver !-> Firebase

level_generator !-> Flutter UI
```

Automated check preferred.

---

# 20. EPIC S0.17 — Developer Experience

## Commands

Provide simple documented commands for:

```bash
flutter pub get
flutter analyze
flutter test
dart test
dart run build_runner build
```

If monorepo tooling is introduced, only do so if it simplifies the repository materially.

Do not introduce Melos or another workspace tool solely because it is fashionable.

If used, document why.

---

# 21. Sprint 0 Non-Goals

Do NOT implement in this sprint:

- complete Game Engine;
- Solver algorithm;
- Level Generator algorithm;
- final gameplay screen;
- final animations;
- Tutorial;
- 250 Levels;
- final narrative scenes;
- Wallet;
- Coin purchases;
- Rewarded Ads;
- Interstitials;
- Daily Reward;
- Daily Challenge;
- Daily Streak;
- CMS;
- full cloud sync;
- content publishing pipeline;
- Player XP;
- Leaderboards;
- Achievements.

Small interface placeholders are allowed only where they unblock architecture.

---

# 22. Suggested Sprint 0 Commit Sequence

Recommended commits:

### Commit 1
```text
chore: initialize repository structure and cursor context
```

### Commit 2
```text
chore: bootstrap flutter mobile application
```

### Commit 3
```text
chore: add pure dart engine solver generator packages
```

### Commit 4
```text
chore: add environment and flavor foundation
```

### Commit 5
```text
feat: add riverpod application bootstrap
```

### Commit 6
```text
feat: add drift local database foundation
```

### Commit 7
```text
feat: add firebase bootstrap and observability
```

### Commit 8
```text
feat: add arabic localization and rtl baseline
```

### Commit 9
```text
test: establish unit widget and migration test foundations
```

### Commit 10
```text
ci: add github actions validation pipeline
```

### Commit 11
```text
docs: add local setup architecture and firebase guides
```

---

# 23. Sprint 0 Definition of Done

Sprint 0 is DONE only if all of the following are true:

- [ ] Repository structure created.
- [ ] Cursor Master Context committed.
- [ ] Cursor Rules committed.
- [ ] Flutter mobile app created.
- [ ] Android min API 26 configured.
- [ ] iOS minimum 15 configured.
- [ ] Portrait mode configured.
- [ ] Arabic default locale works.
- [ ] RTL verified.
- [ ] DEV environment exists.
- [ ] TEST environment exists.
- [ ] STAGING environment exists.
- [ ] PROD environment exists.
- [ ] `game_engine` package exists.
- [ ] `game_engine` has no Flutter dependency.
- [ ] `game_solver` package exists.
- [ ] `game_solver` depends only on approved lower layers.
- [ ] `level_generator` package exists.
- [ ] package dependency direction verified.
- [ ] Riverpod configured.
- [ ] Drift configured.
- [ ] Drift migration test passes.
- [ ] Firebase Core configured structurally.
- [ ] Auth skeleton exists.
- [ ] Firestore skeleton exists.
- [ ] Storage skeleton exists.
- [ ] Remote Config wrapper exists.
- [ ] Analytics abstraction exists.
- [ ] Crashlytics initialized.
- [ ] Logging foundation exists.
- [ ] Global error capture exists.
- [ ] static analysis passes.
- [ ] tests pass.
- [ ] GitHub Actions PR validation exists.
- [ ] Firestore rules are deny-by-default/safe baseline.
- [ ] Storage rules are safe baseline.
- [ ] secrets are excluded.
- [ ] README is complete enough for another engineer to run project.
- [ ] No unapproved gameplay mechanics were implemented.
- [ ] No superseded Azure/.NET/PostgreSQL infrastructure was added.

---

# 24. Cursor Execution Prompt — Sprint 0

Use the following as the implementation prompt after the project context and rules are present:

> Implement **Sprint 0 — Project Bootstrap & Engineering Foundation** for `سوليتير العرب: أسطورة المعاني`.
>
> Before changing code, read:
>
> - `CURSOR_PROJECT_CONTEXT.md`
> - `CURSOR_RULES.md`
> - `.cursor/rules/*`
> - this Sprint 0 document
>
> Work incrementally and preserve the approved architecture.
>
> Do not implement Game Engine gameplay rules yet beyond package/bootstrap contracts.
>
> Build the repository foundation with:
>
> - Flutter mobile bootstrap;
> - Arabic-first RTL shell;
> - iOS 15+;
> - Android API 26+;
> - DEV/TEST/STAGING/PROD configuration;
> - pure-Dart `game_engine`, `game_solver`, `level_generator` packages;
> - Riverpod baseline;
> - Drift baseline + migration test;
> - Firebase Core/Auth/Firestore/Storage/Remote Config/Analytics/Crashlytics structural integration;
> - logging/error foundation;
> - static analysis;
> - unit/widget test baseline;
> - GitHub Actions CI;
> - safe Firebase rules;
> - root README/setup documentation;
> - dependency-boundary validation.
>
> Do not invent missing product decisions.
>
> Do not add Azure, ASP.NET Core, PostgreSQL, Kubernetes, Redis, or always-on backend infrastructure.
>
> Keep Game Engine and Solver framework-independent.
>
> At the end, report:
>
> 1. files created/changed;
> 2. architecture decisions actually implemented;
> 3. commands run;
> 4. test/build results;
> 5. remaining manual setup;
> 6. any blockers or decisions that require approval.
>
> Stop rather than guessing if an unapproved permanent decision is required.

---

# 25. Next Sprint

After Sprint 0 passes its Definition of Done:

# **Sprint 1 — Game Engine Rules v1**

Sprint 1 should implement the authoritative deterministic gameplay domain before the full gameplay UI.

Expected Sprint 1 focus:

- Card/domain IDs;
- GameState;
- GameAction;
- GameTransition;
- Tableau;
- Stock;
- Association Slots;
- atomic stacks;
- move validation;
- Move accounting;
- automatic reveal;
- completion;
- streak;
- Undo;
- Win state;
- serialization/replay;
- comprehensive rule tests.

---

**End of Sprint 0 — Project Bootstrap & Engineering Foundation v1.0**
