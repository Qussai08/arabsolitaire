/// Gameplay presentation backend selection.
enum GameplayPresentationMode {
  /// Flame-rendered 2.5D board used by the mobile MVP.
  flame2d5,

  /// Existing Flutter widget board kept as a lightweight fallback.
  flutter2d,

  /// Paused Unity experiment, retained for a future full-3D evaluation.
  unity3d,
}
