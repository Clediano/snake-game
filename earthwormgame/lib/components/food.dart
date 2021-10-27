import 'package:earthwormgame/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Food extends StatelessWidget {
  const Food({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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