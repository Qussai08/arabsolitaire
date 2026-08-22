import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/config/app_environment.dart';
import 'package:mobile/core/error/app_failure.dart';
import 'package:mobile/core/logging/app_logger.dart';

/// Boots platform services then runs the Arabic-first application shell.
Future<void> bootstrapAndRun(AppEnvironment environment) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final config = AppConfig.forEnvironment(environment);
      final logger = AppLogger(environment: environment);

      FlutterError.onError = (details) {
        logger.error(
          'Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
        );
        FlutterError.presentError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        logger.error(
          'Uncaught platform error',
          error: error,
          stackTrace: stack,
        );
        return true;
      };

      runApp(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            appLoggerProvider.overrideWithValue(logger),
          ],
          child: const SolitaireAlArabApp(),
        ),
      );
    },
    (error, stack) {
      // Last-resort zone handler before ProviderScope exists.
      debugPrint('Fatal bootstrap zone error: $error\n$stack');
    },
  );
}

/// Shared config provider — overridden in [bootstrapAndRun].
final appConfigProvider = Provider<AppConfig>((ref) {
  throw const FatalFailure(
    'AppConfig was not provided. Use bootstrapAndRun entry points.',
  );
});

/// Shared logger provider — overridden in [bootstrapAndRun].
final appLoggerProvider = Provider<AppLogger>((ref) {
  throw const FatalFailure(
    'AppLogger was not provided. Use bootstrapAndRun entry points.',
  );
});
