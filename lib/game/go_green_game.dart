import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_world.dart';

class GoGreenGame extends FlameGame<GoGreenWorld> with HorizontalDragDetector, VerticalDragDetector, KeyboardEvents, HasCollisionDetection {
  int _playerScore = 0;
  final Set<LogicalKeyboardKey> keysHeld = {};

  GoGreenGame()
    : super(
        world: GoGreenWorld(),
        camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ),
      );

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    debugMode = Configs.isDebugMode;
  }

  @override
  Color backgroundColor() {
    return Configs.backgroundColor;
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    world.player.move(info.delta.global);
    super.onHorizontalDragUpdate(info);
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    world.player.move(info.delta.global);
    super.onVerticalDragUpdate(info);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final key = event.logicalKey;

    if (event is KeyDownEvent) {
      keysHeld.add(key);
    } else if (event is KeyUpEvent) {
      keysHeld.remove(key);
    }

    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);

    const double speed = 220.0;
    Vector2 direction = Vector2.zero();

    if (keysHeld.contains(LogicalKeyboardKey.arrowLeft)) {
      direction.x -= 1;
    }
    if (keysHeld.contains(LogicalKeyboardKey.arrowRight)) {
      direction.x += 1;
    }
    if (keysHeld.contains(LogicalKeyboardKey.arrowUp)) {
      direction.y -= 1;
    }
    if (keysHeld.contains(LogicalKeyboardKey.arrowDown)) {
      direction.y += 1;
    }

    if (direction != Vector2.zero()) {
      direction.normalize();
      world.player.move(direction * speed * dt);
    }
  }

  void incrementPlayerScore() {
    _playerScore++;
    print('Player score +1: $_playerScore');
  }

  void decrementPlayerScore() {
    _playerScore--;
    print('Player score -1: $_playerScore');
  }
}
