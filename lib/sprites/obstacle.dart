import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_game.dart';

class Obstacle extends SpriteComponent with HasGameReference<GoGreenGame>, CollisionCallbacks {
  static const spriteHeight = 200.0;
  static const spriteWidth = 200.0;
  static const spriteSpeed = 200.0;

  final spriteRotation = Random().nextDouble() * 2 - 1;
  final String spritePath;

  Obstacle(this.spritePath);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(spritePath);
    size = Vector2(spriteWidth, spriteHeight);
    anchor = Anchor.center;
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    angle += (dt * spriteRotation);
    super.update(dt);
  }
}

class JunkOne extends Obstacle {
  JunkOne() : super(ImageSrc.junk1);
}

class JunkTwo extends Obstacle {
  JunkTwo() : super(ImageSrc.junk2);
}

class JunkThree extends Obstacle {
  JunkThree() : super(ImageSrc.junk3);
}
