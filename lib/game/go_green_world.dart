import 'dart:async';

import 'package:flame/components.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_game.dart';
import 'package:go_green/sprites/asteroid.dart';
import 'package:go_green/sprites/black_hole.dart';
import 'package:go_green/sprites/obstacle.dart';
import 'package:go_green/sprites/player.dart';

class GoGreenWorld extends World with HasGameReference<GoGreenGame> {
  late final Player player;
  late final BlackHole blackHole;
  late final List<Asteroid> asteroids;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    player = Player();
    blackHole = BlackHole();
    asteroids = List.generate(3, (_) => Asteroid());

    add(player);
    add(blackHole);
    add(JunkOne()..position = Vector2(0, 0));
    add(JunkTwo()..position = Vector2(gameWidth / 3, 0));
    add(JunkThree()..position = Vector2(-gameWidth / 3, 0));

    for (var asteroid in asteroids) {
      add(asteroid);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Remove destroyed/inactive asteroids from the list
    asteroids.removeWhere((asteroid) => asteroid.parent == null);

    // If there are less than 3, generate and add new asteroids
    int needed = Configs.asteroidCount - asteroids.length;
    for (int i = 0; i < needed; i++) {
      final newAsteroid = Asteroid();
      asteroids.add(newAsteroid);
      add(newAsteroid);
    }

    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.position.y -= (dt * Obstacle.spriteSpeed);

      if (obstacle.position.y < -(gameHeight / 2 + Obstacle.spriteHeight)) {
        obstacle.position.y = extendedHeight;
      }
    });
  }
}
