import 'package:game_engine/game_engine.dart';
import 'package:unity_bridge_contracts/src/transition_result_codec.dart';

/// Typed helpers for common bridge payloads.
abstract final class BridgePayloads {
  static Map<String, Object?> initialize({
    required String presentationMode,
    Map<String, Object?>? extras,
  }) {
    return {
      'presentationMode': presentationMode,
      if (extras != null) ...extras,
    };
  }

  static Map<String, Object?> loadLevel({
    required Map<String, Object?> levelDefinition,
  }) {
    return {'levelDefinition': levelDefinition};
  }

  static Map<String, Object?> stateSnapshot({
    required GameState state,
    required int revision,
  }) {
    return {'revision': revision, 'gameState': GameStateCodec.encode(state)};
  }

  static Map<String, Object?> transitionResult(TransitionResultPayload result) {
    return TransitionResultCodec.encode(result);
  }

  static Map<String, Object?> hintResult({
    required bool available,
    GameAction? action,
    String? reason,
  }) {
    return {
      'available': available,
      if (action != null) 'action': ActionCodec.encode(action),
      if (reason != null) 'reason': reason,
    };
  }

  static Map<String, Object?> actionIntent({required GameAction action}) {
    return {'action': ActionCodec.encode(action)};
  }

  static GameAction parseActionIntent(Map<String, Object?> payload) {
    final raw = payload['action'];
    if (raw is! Map) {
      throw const FormatException('actionIntent.payload.action is required');
    }
    return ActionCodec.decode(Map<String, Object?>.from(raw));
  }

  static Map<String, Object?> showStoryBeat({
    required String beatId,
    required String textAr,
    bool skippable = true,
  }) {
    return {'beatId': beatId, 'textAr': textAr, 'skippable': skippable};
  }

  static Map<String, Object?> fatalError({
    required String code,
    required String message,
  }) {
    return {'code': code, 'message': message};
  }

  static Map<String, Object?> clientError({
    required String code,
    required String message,
  }) {
    return {'code': code, 'message': message};
  }
}
