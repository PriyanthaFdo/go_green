import 'dart:async';

import 'package:flame/components.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_game.dart';

class Player extends SpriteComponent with HasGameReference<GoGreenGame> {
  late final double top;
  late final double bottom;
  late final double left;
  late final double right;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(ImageSrc.player);
    size = Vector2.all(playerSize);
    position = Vector2(0, (gameHeight / 2) - (playerSize / 2));
    anchor = Anchor.center;

    top = -(game.size.y / 2) + (playerSize / 2);
    bottom = (game.size.y / 2) - (playerSize / 2);
    left = -(game.size.x / 2) + (playerSize / 2);
    right = (game.size.x / 2) - (playerSize / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    double newY = position.y - (dt * playerSpeed);
    double newX = position.x - (dt * playerSpeed);

    // bounding
    if (newY < top) {
      newY = top;
    }

    if (newY > bottom) {
      newY = bottom;
    }

    if (newX < left) {
      newX = left;
    }

    if (newX > right) {
      newX = right;
    }

    position.y = newY;
    position.x = newX;
  }
}
