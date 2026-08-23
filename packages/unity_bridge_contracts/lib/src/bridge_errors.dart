/// Typed bridge parse / validation failures.
sealed class BridgeError implements Exception {
  const BridgeError(this.message);
  final String message;

  @override
  String toString() => 'BridgeError: $message';
}

final class UnknownSchemaVersionError extends BridgeError {
  UnknownSchemaVersionError(int version)
    : super('Unsupported schemaVersion: $version');
}

final class UnknownMessageTypeError extends BridgeError {
  UnknownMessageTypeError(String type) : super('Unknown message type: $type');
}

final class MissingRequiredFieldError extends BridgeError {
  MissingRequiredFieldError(String field)
    : super('Missing required field: $field');
}

final class StaleRevisionError extends BridgeError {
  StaleRevisionError({required this.incoming, required this.authoritative})
    : super('Stale revision: incoming=$incoming authoritative=$authoritative');

  final int incoming;
  final int authoritative;
}

final class DuplicateMessageError extends BridgeError {
  DuplicateMessageError(String id) : super('Duplicate message/request id: $id');
}
