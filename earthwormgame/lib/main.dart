import 'dart:convert';
import 'dart:math';

import 'package:earthwormgame/components/food.dart';
import 'package:earthwormgame/components/player.dart';
import 'package:earthwormgame/components/square.dart';
import 'package:earthwormgame/models/game.dart';
import 'package:earthwormgame/setting.dart';
import 'package:earthwormgame/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.quanticoTextTheme(),
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int playerIndex = Random().nextInt(totalItemCount - 1);
  int foodIndex = Random().nextInt(totalItemCount - 1);
  int score = 0;

  final WebSocketChannel channel = IOWebSocketChannel.connect(urlWebSocket);

  @override
  void initState() {
    _register();
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  _register() {
    channel.stream.listen((dynamic data) {
      Game game = Game.fromJson(data.toString());

      setState(() {
        foodIndex = game.foodIndex;
        playerIndex = game.playerIndex;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "WORM GAME",
              style: TextStyle(
                color: secondaryColor,
                fontSize: 54,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "SCORE: ${score}",
              style: const TextStyle(
                color: secondaryColor,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: _handleKeyEvent,
              child: Container(
                height: 742,
                width: 1075,
                color: primaryDarkColor,
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 35,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      totalItemCount,
                      (int index) {
                        if (index == foodIndex) {
                          return const Food();
                        }
                        if (index == playerIndex) {
                          return const Player();
                        }
                        return const Square();
                      },
                    ),
                  ),
                ),
              ),
            ),
            // StreamBuilder(
            //   stream: widget.channel.stream,
            //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //     if (snapshot.hasData) {
            //       print(snapshot.data.toString());
            //     }
            //     return Container();
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  bool _canMoveToLeft() {
    return (playerIndex % 35 != 0) && (playerIndex - 1) > -1;
  }

  bool _canMoveToRight() {
    return ((playerIndex + 1) % 35 != 0) &&
        (playerIndex + 1) < totalItemCount;
  }

  void _handleKeyEvent(RawKeyEvent keyEvent) {
    int newWormIndex = playerIndex;
    if (keyEvent.runtimeType.toString() == 'RawKeyDownEvent') {
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        channel.sink.add(LogicalKeyboardKey.arrowUp.keyLabel);

        newWormIndex = (playerIndex - 35) > -1
            ? (playerIndex - 35)
            : playerIndex;
      }
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        channel.sink.add(LogicalKeyboardKey.arrowDown.keyLabel);
        newWormIndex = (playerIndex + 35) < totalItemCount
            ? (playerIndex + 35)
            : playerIndex;
      }
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
        channel.sink.add(LogicalKeyboardKey.arrowRight.keyLabel);
        newWormIndex =
            _canMoveToRight() ? (playerIndex + 1) : playerIndex;
      }
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
        channel.sink.add(LogicalKeyboardKey.arrowLeft.keyLabel);
        newWormIndex =
            _canMoveToLeft() ? playerIndex - 1 : playerIndex;
      }
      setState(() => playerIndex = newWormIndex);
      _verifyFoodMatch();
    }
  }

  void _verifyFoodMatch() {
    if (playerIndex == playerIndex) {
      setState(() {
        score += 1;
        playerIndex = generateNewIndex();
      });
    }
  }

  int generateNewIndex() {
    return Random().nextInt(totalItemCount - 1);
  }

}
