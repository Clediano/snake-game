import 'package:earthwormgame/style.dart';
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}