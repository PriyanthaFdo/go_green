import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_green/constants.dart';
import 'package:go_green/game/go_green_game.dart';
import 'package:go_green/utils/extensions/color_extension.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoGreenGame game;

  @override
  void initState() {
    super.initState();
    game = GoGreenGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.green.darken(0.4)),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: FittedBox(
              child: SizedBox(
                height: gameHeight,
                width: gameWidth,
                child: GameWidget(game: game),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
