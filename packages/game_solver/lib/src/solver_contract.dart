import 'package:game_engine/game_engine.dart';

/// Placeholder solver boundary for Sprint 0.
///
/// Real Hint / Dead-End evaluation is implemented in Sprint 2 and must
/// remain Engine-authoritative via shared rule primitives.
abstract interface class SolverContract {
  /// Returns the linked `game_engine` package version for wiring checks.
  String get enginePackageVersion;
}

/// Minimal Sprint 0 stub proving the package can depend on `game_engine`.
final class PlaceholderSolver implements SolverContract {
  @override
  String get enginePackageVersion => gameEnginePackageVersion;
}
