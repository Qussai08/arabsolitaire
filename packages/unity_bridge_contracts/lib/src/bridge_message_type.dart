/// Directional bridge message types (wire names match [name]).
enum BridgeMessageType {
  // Flutter / Dart → Unity
  initialize,
  loadLevel,
  stateSnapshot,
  transitionResult,
  hintResult,
  pause,
  resume,
  showStoryBeat,
  shutdown,
  fatalError,

  // Unity → Flutter / Dart
  unityReady,
  actionIntent,
  requestHint,
  requestRestart,
  requestExit,
  storyBeatSkipped,
  presentationCompleted,
  clientError;

  String get wireName => name;

  static BridgeMessageType parse(String raw) {
    for (final value in BridgeMessageType.values) {
      if (value.name == raw) return value;
    }
    throw FormatException('Unknown bridge message type: $raw');
  }
}
