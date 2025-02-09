import 'package:flutter/material.dart';

class Obstacle {
  double left;
  double top;

  Obstacle({required this.left, required this.top});

  void moveLeft() {
    left -= 5;
  }

  Widget buildWidget() {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 20,
        height: 20,
        color: Colors.pink,
      ),
    );
  }
}
