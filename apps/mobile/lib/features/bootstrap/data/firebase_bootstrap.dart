import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/app/config/app_environment.dart';
import 'package:mobile/core/logging/app_logger.dart';
import 'package:mobile/firebase/default_firebase_options.dart';

/// Safe Firebase Core bootstrap.
///
/// DEV uses commit-safe demo options + the Emulator Suite so the app can be
/// played as an end user without real cloud credentials.
final class FirebaseBootstrap {
  FirebaseBootstrap(this._ref);

  final Ref _ref;

  Future<bool> initializeSafely() async {
    final logger = _ref.read(appLoggerProvider);
    final config = _ref.read(appConfigProvider);

    if (!config.firebaseConfigured) {
      logger.info(
        'Firebase options not configured — skipping Firebase init '
        '(see docs/firebase/SETUP.md)',
      );
      return false;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      if (_shouldUseEmulators(config.environment)) {
        await _connectEmulators(logger);
      }

      if (config.enableCrashlytics && !kIsWeb) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
        await FirebaseCrashlytics.instance.setCustomKey(
          'environment',
          config.environment.label,
        );
      }

      logger.info('Firebase initialized');
      return true;
    } catch (error, stackTrace) {
      logger.warning(
        'Firebase init failed — continuing local bootstrap',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  bool _shouldUseEmulators(AppEnvironment environment) {
    const raw = String.fromEnvironment(
      'USE_FIREBASE_EMULATOR',
      defaultValue: '',
    );
    if (raw == 'true') return true;
    if (raw == 'false') return false;
    // DEV local play always uses emulators so we never hit real cloud.
    return environment == AppEnvironment.dev && !kReleaseMode;
  }

  Future<void> _connectEmulators(AppLogger logger) async {
    final host = _emulatorHost();
    try {
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8088);
      await FirebaseStorage.instance.useStorageEmulator(host, 9199);
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
      logger.info('Connected to Firebase emulators at $host');
    } catch (error, stackTrace) {
      logger.warning(
        'Firebase emulator connect failed — using default endpoints',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Android emulator loopback is 10.0.2.2; desktop / iOS simulator use localhost.
  String _emulatorHost() {
    const override = String.fromEnvironment(
      'FIREBASE_EMULATOR_HOST',
      defaultValue: '',
    );
    if (override.isNotEmpty) return override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return '10.0.2.2';
    }
    return '127.0.0.1';
  }
}

final firebaseBootstrapProvider = Provider<FirebaseBootstrap>(
  FirebaseBootstrap.new,
);
