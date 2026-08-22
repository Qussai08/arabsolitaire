/// Minimal application failure model for Sprint 0.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class RecoverableFailure extends AppFailure {
  const RecoverableFailure(super.message);
}

final class FatalFailure extends AppFailure {
  const FatalFailure(super.message);
}
