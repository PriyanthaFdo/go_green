import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_world.dart';

class GoGreenGame extends FlameGame<GoGreenWorld> with HorizontalDragDetector, VerticalDragDetector, KeyboardEvents {
  GoGreenGame()
    : super(
        world: GoGreenWorld(),
        camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ),
      );

  @override
  Color backgroundColor() {
    return Colors.green;
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
    const keyEventSpeed = 20.0;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        world.player.move(Vector2(-keyEventSpeed, 0));
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        world.player.move(Vector2(keyEventSpeed, 0));
        return KeyEventResult.handled;
      }

      if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        world.player.move(Vector2(0, -keyEventSpeed));
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        world.player.move(Vector2(0, keyEventSpeed));
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }
}
