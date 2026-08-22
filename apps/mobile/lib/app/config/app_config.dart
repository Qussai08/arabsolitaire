import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/level_generator.dart';
import 'package:mobile/app/config/app_environment.dart';

/// Typed runtime configuration for the selected [AppEnvironment].
final class AppConfig {
  const AppConfig({
    required this.environment,
    required this.enableCrashlytics,
    required this.enableAnalytics,
    required this.firebaseConfigured,
    required this.appVersion,
    required this.buildNumber,
    required this.rulesVersion,
    required this.solverVersion,
    required this.generatorVersion,
  });

  factory AppConfig.forEnvironment(AppEnvironment environment) {
    return AppConfig(
      environment: environment,
      enableCrashlytics: environment != AppEnvironment.dev,
      enableAnalytics: environment != AppEnvironment.dev,
      // Becomes true only after real Firebase options are provided locally.
      firebaseConfigured: false,
      appVersion: '1.0.0',
      buildNumber: '1',
      rulesVersion: gameEngineRulesVersion,
      solverVersion: gameSolverPackageVersion,
      generatorVersion: levelGeneratorVersion,
    );
  }

  final AppEnvironment environment;
  final bool enableCrashlytics;
  final bool enableAnalytics;
  final bool firebaseConfigured;

  // ── Version metadata (exposed to diagnostics + Crashlytics) ──────────────
  final String appVersion;
  final String buildNumber;
  final String rulesVersion;
  final String solverVersion;
  final String generatorVersion;
}
