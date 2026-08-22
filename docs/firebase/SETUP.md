# Firebase setup (manual)

Sprint 0 prepares structure only. Do **not** commit secrets or download credentials into git.

## Projects

Create four Firebase projects (or clearly named environments):

| App env | Suggested Firebase project name |
|---------|----------------------------------|
| DEV     | `solitaire-al-arab-dev`         |
| TEST    | `solitaire-al-arab-test`        |
| STAGING | `solitaire-al-arab-staging`     |
| PROD    | `solitaire-al-arab-prod`        |

Exact names are an ops decision.

## Register apps

For each environment:

1. Android app with the matching application id placeholder (or final approved id):
   - DEV `com.arabsolitaire.app.dev`
   - TEST `com.arabsolitaire.app.test`
   - STAGING `com.arabsolitaire.app.staging`
   - PROD `com.arabsolitaire.app`
2. iOS app with matching bundle id (configure in Xcode when flavors/schemes are finalized).
3. Download `google-services.json` / `GoogleService-Info.plist` into **local untracked** paths only.
4. Run FlutterFire configure (or equivalent) to generate `firebase_options.dart` locally — file is gitignored.

## Enable products

- Authentication (Anonymous first; Google/Apple linking later)
- Cloud Firestore
- Storage
- Remote Config
- Analytics
- Crashlytics

## Wire the app

When options exist:

1. Commit-safe code already skips Firebase when `AppConfig.firebaseConfigured` is false.
2. After local options are generated, set `firebaseConfigured: true` per environment in `AppConfig.forEnvironment` (or load from a non-secret flag).
3. Apply Android Google Services Gradle plugin only once `google-services.json` is present for that flavor.
4. Deploy rules from `firebase/rules/` (deny-by-default baseline).

## Security

- Server secrets belong in Cloud Functions / CI secrets only.
- Client must never hold privileged service accounts.
- Do not relax Firestore/Storage to public write for convenience.
