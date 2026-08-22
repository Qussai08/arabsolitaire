import 'package:mobile/app/config/app_environment.dart';

/// Typed runtime configuration for the selected [AppEnvironment].
final class AppConfig {
  const AppConfig({
    required this.environment,
    required this.enableCrashlytics,
    required this.enableAnalytics,
    required this.firebaseConfigured,
  });

  factory AppConfig.forEnvironment(AppEnvironment environment) {
    return AppConfig(
      environment: environment,
      enableCrashlytics: environment != AppEnvironment.dev,
      enableAnalytics: environment != AppEnvironment.dev,
      // Becomes true only after real Firebase options are provided locally.
      firebaseConfigured: false,
    );
  }

  final AppEnvironment environment;
  final bool enableCrashlytics;
  final bool enableAnalytics;
  final bool firebaseConfigured;
}
