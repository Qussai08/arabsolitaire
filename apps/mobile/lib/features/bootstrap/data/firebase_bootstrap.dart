import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';

/// Safe Firebase Core bootstrap.
///
/// When platform options are not configured yet, initialization is skipped
/// and the app continues offline-capable local bootstrap.
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
        await Firebase.initializeApp();
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
}

final firebaseBootstrapProvider = Provider<FirebaseBootstrap>(
  FirebaseBootstrap.new,
);
