import 'dart:async';

import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

/// Abstraction over Flutter↔Unity transport (native embed later).
abstract interface class UnityBridgeTransport {
  Stream<BridgeEnvelope> get inbound;

  Future<void> send(BridgeEnvelope envelope);

  Future<void> dispose();
}

/// In-memory transport for Flutter tests and Editor-style development.
final class MockUnityBridgeTransport implements UnityBridgeTransport {
  final List<BridgeEnvelope> sent = <BridgeEnvelope>[];
  final _inboundController = StreamController<BridgeEnvelope>.broadcast();

  bool disposed = false;
  bool simulateUnavailable = false;

  @override
  Stream<BridgeEnvelope> get inbound => _inboundController.stream;

  @override
  Future<void> send(BridgeEnvelope envelope) async {
    if (simulateUnavailable) {
      throw StateError('Unity runtime unavailable');
    }
    if (disposed) {
      throw StateError('Transport disposed');
    }
    sent.add(envelope);
  }

  /// Inject a message as if it came from Unity.
  void emitFromUnity(BridgeEnvelope envelope) {
    if (!disposed) {
      _inboundController.add(envelope);
    }
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await _inboundController.close();
  }
}
