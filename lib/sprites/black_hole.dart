import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_game.dart';
import 'package:go_green/utils/functions.dart';

class BlackHole extends SpriteComponent with HasGameReference<GoGreenGame> {
  static const blackHoleHeight = 150.0;
  static const blackHoleWidth = 150.0;
  static const blackHoleSpeed = 250.0;

  final _random = Random();

  late final double top;
  late final double bottom;
  late final double left;
  late final double right;

  late Vector2 direction;

  @override
  FutureOr<void> onLoad() async {
    top = -(game.size.y / 2) + (blackHoleHeight / 3.5);
    bottom = (game.size.y / 2) - (blackHoleHeight / 3.5);
    left = -(game.size.x / 2) + (blackHoleWidth / 3.5);
    right = (game.size.x / 2) - (blackHoleWidth / 3.5);

    sprite = await Sprite.load(ImageSrc.blackHole);
    size = Vector2(blackHoleWidth, blackHoleHeight);
    position = Vector2(randomBetween(left, right), randomBetween(bottom, top));
    anchor = Anchor.center;
    direction = Vector2(0, -1);
    direction.rotate(randomBetween(0, pi * 2));

    add(
      CircleHitbox.relative(
        0.6,
        parentSize: size,
        position: size / 2,
        anchor: Anchor.center,
      )
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = direction.normalized() * (dt * blackHoleSpeed);
    Vector2 newPosition = position + velocity;

    // Check collision with bounds and reflect
    if (newPosition.y < top) {
      direction = _reflectWithRandomness(direction, Vector2(0, 1));
      newPosition.y = top;
    } else if (newPosition.y > bottom) {
      direction = _reflectWithRandomness(direction, Vector2(0, -1));
      newPosition.y = bottom;
    }

    if (newPosition.x < left) {
      direction = _reflectWithRandomness(direction, Vector2(1, 0));
      newPosition.x = left;
    } else if (newPosition.x > right) {
      direction = _reflectWithRandomness(direction, Vector2(-1, 0));
      newPosition.x = right;
    }

    position = newPosition;
  }

  Vector2 _reflectWithRandomness(Vector2 dir, Vector2 normal) {
    // Reflect the vector across the wall normal
    Vector2 reflected = dir.reflected(normal).normalized();

    // Apply a random small angle deviation (e.g., ±20 degrees)
    double angleInRadians = (_random.nextDouble() * pi / 2) - (pi / 4);
    reflected.rotate(angleInRadians);

    return reflected;
  }

  void move(Vector2 delta) {
    position += delta;
  }
}
