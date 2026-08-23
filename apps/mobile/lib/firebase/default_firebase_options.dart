import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Commit-safe Firebase options for local end-user play against emulators.
///
/// Uses the demo project id from `firebase/.firebaserc` (`demo-arabsolitaire`).
/// These values are **not** production secrets — they only work with the
/// Firebase Emulator Suite (or a real project that happens to match, which
/// this repo does not ship).
///
/// Real env credentials stay gitignored as `firebase_options.dart` per
/// `docs/firebase/SETUP.md`.
abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      TargetPlatform.macOS => macos,
      TargetPlatform.windows => windows,
      TargetPlatform.linux => linux,
      TargetPlatform.fuchsia => throw UnsupportedError(
        'Fuchsia is not a supported Firebase target.',
      ),
    };
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:100000000000:web:demoarabsolitaireweb',
    messagingSenderId: '100000000000',
    projectId: 'demo-arabsolitaire',
    authDomain: 'demo-arabsolitaire.firebaseapp.com',
    storageBucket: 'demo-arabsolitaire.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:100000000000:android:demoarabsolitaireand',
    messagingSenderId: '100000000000',
    projectId: 'demo-arabsolitaire',
    storageBucket: 'demo-arabsolitaire.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:100000000000:ios:demoarabsolitaireios',
    messagingSenderId: '100000000000',
    projectId: 'demo-arabsolitaire',
    storageBucket: 'demo-arabsolitaire.appspot.com',
    iosBundleId: 'com.arabsolitaire.app.dev',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:100000000000:ios:demoarabsolitairemac',
    messagingSenderId: '100000000000',
    projectId: 'demo-arabsolitaire',
    storageBucket: 'demo-arabsolitaire.appspot.com',
    iosBundleId: 'com.arabsolitaire.app.dev',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:100000000000:web:demoarabsolitairewin',
    messagingSenderId: '100000000000',
    projectId: 'demo-arabsolitaire',
    authDomain: 'demo-arabsolitaire.firebaseapp.com',
    storageBucket: 'demo-arabsolitaire.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:100000000000:web:demoarabsolitairelin',
    messagingSenderId: '100000000000',
    projectId: 'demo-arabsolitaire',
    authDomain: 'demo-arabsolitaire.firebaseapp.com',
    storageBucket: 'demo-arabsolitaire.appspot.com',
  );
}
