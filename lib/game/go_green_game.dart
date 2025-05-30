import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/player.dart';

class GoGreenGame extends FlameGame {
  GoGreenGame()
    : super(
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
  FutureOr<void> onLoad() {
    super.onLoad();

    world.add(
      Player(
        position: Vector2(0, 0),
        radius: 50,
      ),
    );

    world.add(
      Player(
        position: Vector2(0, 100),
        radius: 20,
        color: Colors.red,
      ),
    );
  }
}
