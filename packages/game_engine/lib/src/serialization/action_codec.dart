import 'package:game_engine/src/action/game_action.dart';

abstract final class ActionCodec {
  static Map<String, Object?> encode(GameAction action) => action.toJson();

  static GameAction decode(Map<String, Object?> json) =>
      GameAction.fromJson(json);
}
