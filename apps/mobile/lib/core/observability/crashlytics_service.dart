import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/app/config/app_config.dart';

/// Crash reporting + non-fatal recording with non-sensitive context keys.
///
/// Keys set here appear in every Crashlytics issue for this session.
/// Never include auth tokens, purchase receipts, or personal secrets.
final class CrashlyticsService {
  CrashlyticsService(this._config);

  final AppConfig _config;

  bool get _enabled =>
      _config.enableCrashlytics && _config.firebaseConfigured && !kDebugMode;

  /// Set session-level context keys that appear in every crash report.
  Future<void> setSessionKeys() async {
    if (!_enabled) {
      return;
    }
    try {
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCustomKey('app_version', _config.appVersion);
      await crashlytics.setCustomKey('build_number', _config.buildNumber);
      await crashlytics.setCustomKey('environment', _config.environment.label);
      await crashlytics.setCustomKey('rules_version', _config.rulesVersion);
      await crashlytics.setCustomKey('solver_version', _config.solverVersion);
      await crashlytics.setCustomKey(
        'generator_version',
        _config.generatorVersion,
      );
    } catch (_) {
      // Never throw — Crashlytics must not block app startup.
    }
  }

  /// Update per-attempt context keys (call when a new attempt starts).
  Future<void> setAttemptContext({
    required String levelDefinitionId,
    required String activeBundleVersion,
    required String contentHash,
    required String? boardFingerprint,
    required String authStateType,
  }) async {
    if (!_enabled) {
      return;
    }
    try {
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCustomKey(
        'active_bundle_version',
        activeBundleVersion,
      );
      await crashlytics.setCustomKey('content_hash', contentHash);
      await crashlytics.setCustomKey('level_definition_id', levelDefinitionId);
      if (boardFingerprint != null) {
        await crashlytics.setCustomKey('board_fingerprint', boardFingerprint);
      }
      await crashlytics.setCustomKey('auth_state_type', authStateType);
    } catch (_) {}
  }

  /// Record a non-fatal exception (e.g. sync failure, content validation error).
  Future<void> recordNonFatal(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
  }) async {
    if (!_enabled) {
      return;
    }
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      );
    } catch (_) {}
  }

  /// Route Flutter framework errors through Crashlytics.
  void attachFlutterErrorHandler() {
    if (!_enabled) {
      return;
    }
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
