import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';

/// Analytics abstraction — Sprint 0 events only.
abstract interface class AnalyticsService {
  Future<void> logAppStarted();
  Future<void> logBootstrapCompleted({required bool firebaseReady});
  Future<void> logBootstrapFailed({required String reason});
}

final class NoOpAnalyticsService implements AnalyticsService {
  @override
  Future<void> logAppStarted() async {}

  @override
  Future<void> logBootstrapCompleted({required bool firebaseReady}) async {}

  @override
  Future<void> logBootstrapFailed({required String reason}) async {}
}

final class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logAppStarted() {
    return _analytics.logEvent(name: 'app_started');
  }

  @override
  Future<void> logBootstrapCompleted({required bool firebaseReady}) {
    return _analytics.logEvent(
      name: 'bootstrap_completed',
      parameters: {'firebase_ready': firebaseReady ? 1 : 0},
    );
  }

  @override
  Future<void> logBootstrapFailed({required String reason}) {
    return _analytics.logEvent(
      name: 'bootstrap_failed',
      parameters: {
        'reason': reason.length > 100 ? reason.substring(0, 100) : reason,
      },
    );
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  if (!config.enableAnalytics || !config.firebaseConfigured) {
    logger.debug('Using NoOp analytics');
    return NoOpAnalyticsService();
  }

  try {
    return FirebaseAnalyticsService(FirebaseAnalytics.instance);
  } catch (error, stackTrace) {
    logger.warning(
      'Analytics unavailable — using NoOp',
      error: error,
      stackTrace: stackTrace,
    );
    return NoOpAnalyticsService();
  }
});
