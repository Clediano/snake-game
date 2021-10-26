import 'dart:math';

import 'package:earthwormgame/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int foodIndex = 310;
  int wormIndex = 110;
  int score = 0;
  bool isDarkTheme = false;
  static const int totalItemCount = 840;

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
                fontWeight: FontWeight.bold),
          ),
          Text(
            "SCORE: $score",
            style: const TextStyle(
                color: secondaryColor,
                fontSize: 34,
                fontWeight: FontWeight.bold),
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
                  children: List.generate(totalItemCount, (int index) {
                    if (index == foodIndex) {
                      return getFoodWidget();
                    }
                    if (index == wormIndex) {
                      return getWormWidget();
                    }
                    return getSquareWidget();
                  }),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  bool _canMoveToLeft() {
    return (wormIndex % 35 != 0) && (wormIndex - 1) > -1;
  }

  bool _canMoveToRight() {
    return ((wormIndex + 1) % 35 != 0) && (wormIndex + 1) < totalItemCount;
  }

  void _handleKeyEvent(RawKeyEvent keyEvent) {
    int newWormIndex = wormIndex;
    if (keyEvent.runtimeType.toString() == 'RawKeyDownEvent') {
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        newWormIndex = (wormIndex - 35) > -1 ? (wormIndex - 35) : wormIndex;
      }
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        newWormIndex =
            (wormIndex + 35) < totalItemCount ? (wormIndex + 35) : wormIndex;
      }
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
        newWormIndex = _canMoveToRight() ? (wormIndex + 1) : wormIndex;
      }
      if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
        newWormIndex = _canMoveToLeft() ? wormIndex - 1 : wormIndex;
      }
      setState(() => wormIndex = newWormIndex);
      _verifyFoodMatch();
    }
  }

  void _verifyFoodMatch() {
    if (wormIndex == foodIndex) {
      setState(() {
        score += 1;
        foodIndex = _generateRandomPosition();
      });
    }
  }

  int _generateRandomPosition() {
    return Random().nextInt(totalItemCount - 1);
  }

  Container getSquareWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Container getWormWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: const BoxDecoration(
            color: wormColor,
          ),
        ),
      )),
    );
  }

  Container getFoodWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SvgPicture.asset("images/pear.svg", color: fruitkColor),
        ),
      ),
    );
  }
}
