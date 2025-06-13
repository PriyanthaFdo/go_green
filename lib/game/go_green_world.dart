import 'dart:async';

import 'package:flame/components.dart';
import 'package:go_green/game/go_green_game.dart';
import 'package:go_green/sprites/black_hole.dart';
import 'package:go_green/sprites/player.dart';

class GoGreenWorld extends World with HasGameReference<GoGreenGame> {
  late final Player player;
  late final BlackHole blackHole;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    player = Player();
    blackHole = BlackHole();
    add(player);
    add(blackHole);
  }
}
