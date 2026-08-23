import 'package:game_engine/game_engine.dart';
import 'package:unity_bridge_contracts/src/bridge_constants.dart';
import 'package:unity_bridge_contracts/src/bridge_envelope.dart';
import 'package:unity_bridge_contracts/src/bridge_errors.dart';
import 'package:unity_bridge_contracts/src/bridge_message_type.dart';
import 'package:unity_bridge_contracts/src/payloads.dart';
import 'package:unity_bridge_contracts/src/transition_result_codec.dart';

/// Result of handling an inbound Unity action intent.
sealed class BridgeIntentHandleResult {
  const BridgeIntentHandleResult();
}

final class BridgeIntentApplied extends BridgeIntentHandleResult {
  const BridgeIntentApplied({
    required this.action,
    required this.transition,
    required this.newRevision,
    required this.response,
  });

  final GameAction action;
  final GameTransition transition;
  final int newRevision;
  final BridgeEnvelope response;
}

final class BridgeIntentRejected extends BridgeIntentHandleResult {
  const BridgeIntentRejected({required this.error, this.response});

  final BridgeError error;
  final BridgeEnvelope? response;
}

/// Pure Dart coordinator helpers: revision + dedupe bookkeeping.
///
/// Does not mutate [GameState]. Callers supply Engine transitions.
final class BridgeSession {
  BridgeSession({
    required this.sessionId,
    required this.attemptId,
    required this.levelDefinitionId,
    int initialRevision = 0,
  }) : _revision = initialRevision;

  final String sessionId;
  final String attemptId;
  final String levelDefinitionId;

  int _revision;
  int _messageCounter = 0;
  final Set<String> _seenMessageIds = <String>{};
  final Set<String> _seenRequestIds = <String>{};

  int get revision => _revision;

  void restoreRevision(int revision) {
    _revision = revision;
  }

  String nextMessageId(String prefix) {
    _messageCounter += 1;
    return '$prefix-$_messageCounter';
  }

  BridgeEnvelope buildOutbound({
    required BridgeMessageType type,
    required Map<String, Object?> payload,
    String? requestId,
    int? revision,
  }) {
    return BridgeEnvelope(
      schemaVersion: kBridgeSchemaVersion,
      messageId: nextMessageId('dart'),
      sessionId: sessionId,
      attemptId: attemptId,
      levelDefinitionId: levelDefinitionId,
      revision: revision ?? _revision,
      type: type,
      requestId: requestId,
      payload: payload,
    );
  }

  BridgeEnvelope snapshotEnvelope(GameState state) {
    return buildOutbound(
      type: BridgeMessageType.stateSnapshot,
      payload: BridgePayloads.stateSnapshot(state: state, revision: _revision),
    );
  }

  /// Validates revision / dedupe, then applies [apply] without mutating state here.
  BridgeIntentHandleResult handleActionIntent({
    required BridgeEnvelope envelope,
    required GameTransition Function(GameAction action) apply,
  }) {
    if (envelope.type != BridgeMessageType.actionIntent) {
      return BridgeIntentRejected(
        error: UnknownMessageTypeError(envelope.type.wireName),
      );
    }

    if (_seenMessageIds.contains(envelope.messageId)) {
      return BridgeIntentRejected(
        error: DuplicateMessageError(envelope.messageId),
      );
    }
    final requestId = envelope.requestId;
    if (requestId != null && _seenRequestIds.contains(requestId)) {
      return BridgeIntentRejected(error: DuplicateMessageError(requestId));
    }

    if (envelope.revision != _revision) {
      return BridgeIntentRejected(
        error: StaleRevisionError(
          incoming: envelope.revision,
          authoritative: _revision,
        ),
      );
    }

    late final GameAction action;
    try {
      action = BridgePayloads.parseActionIntent(envelope.payload);
    } catch (e) {
      return BridgeIntentRejected(
        error: MissingRequiredFieldError('payload.action ($e)'),
      );
    }

    _seenMessageIds.add(envelope.messageId);
    if (requestId != null) {
      _seenRequestIds.add(requestId);
    }

    final transition = apply(action);
    // Authoritative revision advances for applied Engine evaluations
    // (accepted or rejected), matching GameplayController behavior.
    _revision += 1;

    final payload = TransitionResultPayload.fromTransition(
      transition: transition,
      newRevision: _revision,
    );

    final response = buildOutbound(
      type: BridgeMessageType.transitionResult,
      requestId: requestId,
      revision: _revision,
      payload: TransitionResultCodec.encode(payload),
    );

    return BridgeIntentApplied(
      action: action,
      transition: transition,
      newRevision: _revision,
      response: response,
    );
  }
}
