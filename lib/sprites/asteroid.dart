import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_game.dart';
import 'package:go_green/utils/functions.dart';

class Asteroid extends SpriteComponent with HasGameReference<GoGreenGame>, CollisionCallbacks {
  final Vector2? initialPosition;

  Asteroid({this.initialPosition});

  static const spriteHeight = 50.0;
  static const spriteWidth = 50.0;
  static const speed = 300.0;

  final _random = Random();

  late final double top;
  late final double bottom;
  late final double left;
  late final double right;

  late Vector2 direction;

  bool hasEnteredPlayArea = false;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(ImageSrc.asteroid);
    size = Vector2(spriteWidth, spriteHeight);
    anchor = Anchor.center;

    // Define spawn area (outside the screen)
    double spawnMargin = 100.0; // How far outside the screen to spawn
    double spawnX, spawnY;

    // Randomly select one of four sides to spawn from
    int side = _random.nextInt(4); // 0: top, 1: right, 2: bottom, 3: left
    switch (side) {
      case 0: // Top
        spawnX = randomBetween(-game.size.x / 2, game.size.x / 2);
        spawnY = -(game.size.y / 2) - spawnMargin;
        break;
      case 1: // Right
        spawnX = (game.size.x / 2) + spawnMargin;
        spawnY = randomBetween(-game.size.y / 2, game.size.y / 2);
        break;
      case 2: // Bottom
        spawnX = randomBetween(-game.size.x / 2, game.size.x / 2);
        spawnY = (game.size.y / 2) + spawnMargin;
        break;
      case 3: // Left
        spawnX = -(game.size.x / 2) - spawnMargin;
        spawnY = randomBetween(-game.size.y / 2, game.size.y / 2);
        break;
      default:
        spawnX = 0;
        spawnY = 0;
    }

    position = initialPosition ?? Vector2(spawnX, spawnY);

    // Direction toward center or random point in play area
    final Vector2 targetPoint = Vector2(
      randomBetween(-game.size.x / 3, game.size.x / 3),
      randomBetween(-game.size.y / 3, game.size.y / 3),
    );
    direction = (targetPoint - position).normalized();

    // Set the screen bounds for bounce reflection
    top = -(game.size.y / 2) + (spriteHeight / 3.5);
    bottom = (game.size.y / 2) - (spriteHeight / 3.5);
    left = -(game.size.x / 2) + (spriteWidth / 3.5);
    right = (game.size.x / 2) - (spriteWidth / 3.5);

    add(CircleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is! Asteroid) {
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = direction.normalized() * (dt * speed);
    Vector2 newPosition = position + velocity;

    // Check if the asteroid has entered the play area for the first time
    if (!hasEnteredPlayArea && newPosition.x > left && newPosition.x < right && newPosition.y > top && newPosition.y < bottom) {
      hasEnteredPlayArea = true;
    }

    if (hasEnteredPlayArea) {
      // Bounce off edges
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
