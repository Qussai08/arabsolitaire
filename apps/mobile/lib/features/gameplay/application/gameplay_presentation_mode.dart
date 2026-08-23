/// Gameplay presentation backend selection.
enum GameplayPresentationMode {
  /// Existing Flutter 2D board (default until Unity is proven).
  flutter2d,

  /// Unity 3D presentation via bridge (falls back if Unity is unavailable).
  unity3d,
}
