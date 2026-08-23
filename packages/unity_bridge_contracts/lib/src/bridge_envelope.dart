import 'package:unity_bridge_contracts/src/bridge_constants.dart';
import 'package:unity_bridge_contracts/src/bridge_errors.dart';
import 'package:unity_bridge_contracts/src/bridge_message_type.dart';

/// Versioned JSON envelope shared by Flutter and Unity.
final class BridgeEnvelope {
  const BridgeEnvelope({
    required this.schemaVersion,
    required this.messageId,
    required this.sessionId,
    required this.attemptId,
    required this.levelDefinitionId,
    required this.revision,
    required this.type,
    required this.payload,
    this.requestId,
  });

  final int schemaVersion;
  final String messageId;
  final String sessionId;
  final String attemptId;
  final String levelDefinitionId;
  final int revision;
  final BridgeMessageType type;
  final String? requestId;
  final Map<String, Object?> payload;

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'messageId': messageId,
    'sessionId': sessionId,
    'attemptId': attemptId,
    'levelDefinitionId': levelDefinitionId,
    'revision': revision,
    'type': type.wireName,
    if (requestId != null) 'requestId': requestId,
    'payload': payload,
  };

  static BridgeEnvelope fromJson(Map<String, Object?> json) {
    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int) {
      throw MissingRequiredFieldError('schemaVersion');
    }
    if (schemaVersion != kBridgeSchemaVersion) {
      throw UnknownSchemaVersionError(schemaVersion);
    }

    String requireString(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw MissingRequiredFieldError(key);
      }
      return value;
    }

    final revision = json['revision'];
    if (revision is! int) {
      throw MissingRequiredFieldError('revision');
    }

    final typeRaw = json['type'];
    if (typeRaw is! String || typeRaw.isEmpty) {
      throw MissingRequiredFieldError('type');
    }

    late final BridgeMessageType type;
    try {
      type = BridgeMessageType.parse(typeRaw);
    } on FormatException {
      throw UnknownMessageTypeError(typeRaw);
    }

    final payloadRaw = json['payload'];
    if (payloadRaw is! Map) {
      throw MissingRequiredFieldError('payload');
    }

    final requestId = json['requestId'];
    return BridgeEnvelope(
      schemaVersion: schemaVersion,
      messageId: requireString('messageId'),
      sessionId: requireString('sessionId'),
      attemptId: requireString('attemptId'),
      levelDefinitionId: requireString('levelDefinitionId'),
      revision: revision,
      type: type,
      requestId: requestId is String && requestId.isNotEmpty ? requestId : null,
      payload: Map<String, Object?>.from(payloadRaw),
    );
  }
}
