# Firebase setup

## Local end-user play (DEV + emulators)

This is the supported path to experience the game as a player without real cloud credentials.

### 1. Start emulators + publish content

```bash
cd firebase
npm run emulators
# other terminal:
npm run content:publish
```

Emulator UI: http://127.0.0.1:4000  
Demo project id: `demo-arabsolitaire`

### 2. Run the DEV app

```bash
cd apps/mobile
flutter run --flavor dev -t lib/main_dev.dart
```

- Windows / iOS Simulator / Chrome: uses `127.0.0.1` for emulators  
- Android Emulator: uses `10.0.2.2` automatically  
- Override host: `--dart-define=FIREBASE_EMULATOR_HOST=192.168.x.x` (physical device)

DEV now sets `firebaseConfigured: true` and initializes with commit-safe
`lib/firebase/default_firebase_options.dart`, then:

1. Connects Auth / Firestore / Storage / Functions emulators  
2. Signs in anonymously  
3. Loads bundled content, then checks the remote content pointer  

### 3. Optional dart-defines

| Define | Effect |
|--------|--------|
| `USE_FIREBASE_EMULATOR=true` | Force emulator connect |
| `USE_FIREBASE_EMULATOR=false` | Skip emulators (needs real project) |
| `FIREBASE_EMULATOR_HOST=…` | Emulator host override |

---

## Real cloud projects (TEST / STAGING / PROD)

Do **not** commit secrets or download credentials into git.

### Projects

| App env | Suggested Firebase project name |
|--------|----------------------------------|
| DEV     | `solitaire-al-arab-dev`         |
| TEST    | `solitaire-al-arab-test`        |
| STAGING | `solitaire-al-arab-staging`     |
| PROD    | `solitaire-al-arab-prod`        |

Exact names are an ops decision.

### Register apps

For each environment:

1. Android app with the matching application id placeholder (or final approved id):
   - DEV `com.arabsolitaire.app.dev`
   - TEST `com.arabsolitaire.app.test`
   - STAGING `com.arabsolitaire.app.staging`
   - PROD `com.arabsolitaire.app`
2. iOS app with matching bundle id (configure in Xcode when flavors/schemes are finalized).
3. Download `google-services.json` / `GoogleService-Info.plist` into **local untracked** paths only.
4. Run FlutterFire configure (or equivalent) to generate `firebase_options.dart` locally — file is gitignored.

### Enable products

- Authentication (Anonymous first; Google/Apple linking later)
- Cloud Firestore
- Storage
- Remote Config
- Analytics
- Crashlytics

### Wire the app

When real options exist:

1. DEV already works via `DefaultFirebaseOptions` + emulators.
2. For TEST/STAGING/PROD, set `firebaseConfigured: true` in `AppConfig.forEnvironment` and point `Firebase.initializeApp` at the generated (gitignored) `firebase_options.dart`.
3. Apply Android Google Services Gradle plugin only once `google-services.json` is present for that flavor.
4. Deploy rules from `firebase/rules/` (deny-by-default baseline).

### Security

- Server secrets belong in Cloud Functions / CI secrets only.
- Client must never hold privileged service accounts.
- Do not relax Firestore/Storage to public write for convenience.
