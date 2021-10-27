import 'package:earthwormgame/style.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  const Square({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}