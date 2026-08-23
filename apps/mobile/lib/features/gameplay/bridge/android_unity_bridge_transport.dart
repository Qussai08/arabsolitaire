import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

import 'unity_bridge_transport.dart';

/// Android MethodChannel + EventChannel transport.
final class AndroidUnityBridgeTransport implements UnityBridgeTransport {
  AndroidUnityBridgeTransport({
    MethodChannel? methodChannel,
    EventChannel? eventChannel,
  }) : _methods = methodChannel ?? const MethodChannel(_channelName),
       _events = eventChannel ?? const EventChannel(_eventChannelName);

  static const _channelName = 'com.arabsolitaire/unity_bridge';
  static const _eventChannelName = 'com.arabsolitaire/unity_bridge/events';

  final MethodChannel _methods;
  final EventChannel _events;
  StreamSubscription<dynamic>? _subscription;
  final _inboundController = StreamController<BridgeEnvelope>.broadcast();
  var _disposed = false;

  static Future<bool> isNativeAvailable() async {
    const channel = MethodChannel(_channelName);
    try {
      final available = await channel.invokeMethod<bool>('isAvailable');
      return available ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Stream<BridgeEnvelope> get inbound => _inboundController.stream;

  @override
  Future<void> send(BridgeEnvelope envelope) async {
    if (_disposed) {
      throw StateError('Transport disposed');
    }

    await _methods.invokeMethod<void>('sendToUnity', <String, Object?>{
      'json': jsonEncode(envelope.toJson()),
    });
  }

  Future<void> startListening() async {
    await _subscription?.cancel();
    _subscription = _events.receiveBroadcastStream().listen(
      (dynamic event) {
        if (_disposed || event is! String) {
          return;
        }
        try {
          final decoded = jsonDecode(event) as Map<String, dynamic>;
          _inboundController.add(BridgeEnvelope.fromJson(decoded));
        } catch (_) {
          // Malformed payloads are surfaced by coordinator fatal handling.
        }
      },
      onError: _inboundController.addError,
    );
  }

  Future<void> openGameplay({
    required String sessionId,
    required String attemptId,
    required String levelDefinitionId,
    required String chapterId,
  }) async {
    await _methods.invokeMethod<void>('openGameplay', <String, Object?>{
      'sessionId': sessionId,
      'attemptId': attemptId,
      'levelDefinitionId': levelDefinitionId,
      'chapterId': chapterId,
    });
  }

  Future<void> pauseUnity() => _methods.invokeMethod<void>('pauseUnity');

  Future<void> resumeUnity() => _methods.invokeMethod<void>('resumeUnity');

  Future<void> shutdownUnity() => _methods.invokeMethod<void>('shutdownUnity');

  Future<void> finishUnityActivity() =>
      _methods.invokeMethod<void>('finishUnityActivity');

  @override
  Future<void> dispose() async {
    _disposed = true;
    await _subscription?.cancel();
    await _inboundController.close();
  }
}
