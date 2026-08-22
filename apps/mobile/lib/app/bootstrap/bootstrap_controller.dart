import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/core/analytics/analytics_service.dart';
import 'package:mobile/core/error/app_failure.dart';
import 'package:mobile/core/feature_flags/remote_config_service.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/bootstrap/data/auth_skeleton.dart';
import 'package:mobile/features/bootstrap/data/firebase_bootstrap.dart';
import 'package:mobile/features/bootstrap/data/firestore_skeleton.dart';
import 'package:mobile/features/bootstrap/data/storage_skeleton.dart';
import 'package:mobile/features/content/application/content_providers.dart';

/// High-level bootstrap readiness for the application shell.
enum BootstrapStatus { initializing, ready, recoverableError, fatalError }

final class BootstrapState {
  const BootstrapState({
    required this.status,
    this.message,
    this.firebaseReady = false,
  });

  final BootstrapStatus status;
  final String? message;
  final bool firebaseReady;

  BootstrapState copyWith({
    BootstrapStatus? status,
    String? message,
    bool? firebaseReady,
  }) {
    return BootstrapState(
      status: status ?? this.status,
      message: message ?? this.message,
      firebaseReady: firebaseReady ?? this.firebaseReady,
    );
  }
}

final bootstrapControllerProvider =
    AsyncNotifierProvider<BootstrapController, BootstrapState>(
      BootstrapController.new,
    );

final class BootstrapController extends AsyncNotifier<BootstrapState> {
  @override
  Future<BootstrapState> build() async {
    final logger = ref.read(appLoggerProvider);
    final config = ref.read(appConfigProvider);
    final analytics = ref.read(analyticsServiceProvider);

    await analytics.logAppStarted();

    try {
      logger.info('Bootstrap starting (${config.environment.label})');

      final firebase = ref.read(firebaseBootstrapProvider);
      final firebaseReady = await firebase.initializeSafely();

      if (firebaseReady) {
        final uid =
            await ref.read(authSkeletonProvider).ensureAnonymousSession();
        logger.info(
          uid == null
              ? 'Anonymous auth skipped/failed — content sync may be limited'
              : 'Anonymous session ready ($uid)',
        );
      }

      final database = await ref.read(appDatabaseProvider.future);
      await database.ensureInitialized();

      final remoteConfig = ref.read(remoteConfigServiceProvider);
      await remoteConfig.initializeSafely();

      // Auth / Firestore / Storage skeletons are constructed for boundaries only.
      ref.read(authSkeletonProvider);
      ref.read(firestoreSkeletonProvider);
      ref.read(storageSkeletonProvider);

      // Load journey content (bundled + optional remote pointer).
      final snapshot = await ref.read(contentSnapshotProvider.future);
      logger.info(
        'Content loaded: ${snapshot.associations.length} associations, '
        '${snapshot.levels.length} levels '
        '(${snapshot.source.name}/${snapshot.bundleVersion})',
      );

      if (firebaseReady) {
        // Background remote update — never blocks Home.
        ref.read(contentManagerProvider).checkForUpdate().then((result) {
          logger.info('Content update check: ${result.runtimeType}');
        }).ignore();
      }

      await analytics.logBootstrapCompleted(firebaseReady: firebaseReady);
      logger.info('Bootstrap completed (firebaseReady=$firebaseReady)');

      return BootstrapState(
        status: BootstrapStatus.ready,
        firebaseReady: firebaseReady,
      );
    } on FatalFailure catch (error, stackTrace) {
      logger.error(
        'Fatal bootstrap failure',
        error: error,
        stackTrace: stackTrace,
      );
      await analytics.logBootstrapFailed(reason: error.message);
      return BootstrapState(
        status: BootstrapStatus.fatalError,
        message: error.message,
      );
    } catch (error, stackTrace) {
      logger.error(
        'Recoverable bootstrap failure',
        error: error,
        stackTrace: stackTrace,
      );
      await analytics.logBootstrapFailed(reason: error.toString());
      return BootstrapState(
        status: BootstrapStatus.recoverableError,
        message: error.toString(),
      );
    }
  }
}
