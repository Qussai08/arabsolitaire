// Sprint 10 — Content bundle analytics events.
// Reports bundle lifecycle events to Firebase Analytics.

import 'package:firebase_analytics/firebase_analytics.dart';

class ContentAnalytics {
  const ContentAnalytics({FirebaseAnalytics? analytics})
    : _analytics = analytics; // ignore: prefer_initializing_formals

  final FirebaseAnalytics? _analytics;

  FirebaseAnalytics get _fa => _analytics ?? FirebaseAnalytics.instance;

  Future<void> logBundleCheck({
    required String bundleVersion,
    required int schemaVersion,
    required String contentHash,
  }) => _fa.logEvent(
    name: 'content_bundle_check',
    parameters: {
      'bundle_version': bundleVersion,
      'schema_version': schemaVersion,
      'content_hash': contentHash.substring(0, contentHash.length.clamp(0, 36)),
    },
  );

  Future<void> logDownloadStarted(String bundleVersion) => _fa.logEvent(
    name: 'content_bundle_download_started',
    parameters: {'bundle_version': bundleVersion},
  );

  Future<void> logDownloadCompleted(String bundleVersion, int durationMs) =>
      _fa.logEvent(
        name: 'content_bundle_download_completed',
        parameters: {
          'bundle_version': bundleVersion,
          'duration_ms': durationMs,
        },
      );

  Future<void> logValidationFailed(String bundleVersion, String errorCode) =>
      _fa.logEvent(
        name: 'content_bundle_validation_failed',
        parameters: {'bundle_version': bundleVersion, 'error_code': errorCode},
      );

  Future<void> logActivated({
    required String bundleVersion,
    required int schemaVersion,
    required String contentHash,
  }) => _fa.logEvent(
    name: 'content_bundle_activated',
    parameters: {
      'bundle_version': bundleVersion,
      'schema_version': schemaVersion,
      'content_hash': contentHash.substring(0, contentHash.length.clamp(0, 36)),
    },
  );

  Future<void> logRollback(String toVersion) => _fa.logEvent(
    name: 'content_bundle_rollback',
    parameters: {'to_version': toVersion},
  );

  Future<void> logDisabledContentEncountered(
    String contentId,
    String contentType,
  ) => _fa.logEvent(
    name: 'content_disabled_encountered',
    parameters: {'content_id': contentId, 'content_type': contentType},
  );
}
