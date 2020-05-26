import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  CustomFlatButton({
    this.onPressed,
    this.height: 50.0,
    this.boxShadowColor: const Color.fromRGBO(143, 148, 251, .3),
    @required this.label,
    this.buttonColors: const [
      Color.fromRGBO(98, 41, 253, .63),
      Color.fromRGBO(228, 170, 255, .33),
    ],
  });

  final VoidCallback onPressed;
  final double height;
  final Color boxShadowColor;
  final String label;
  final List<Color> buttonColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width / 1.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: buttonColors,
        ),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor,
            blurRadius: 20.0,
            offset: Offset(5, 12),
          )
        ],
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}
