import 'package:flutter/material.dart';

class Rectangle {
  // position in the board
  double position;
  // current value
  double value;
  // length of the rectangle maximum value is 1
  double length;
  // color of the rectangle
  Color color;
  // max value of all the rectangles
  double maxValue;
  // label of the rectangle, (text writen in the left)
  String label;
  // the label to be shown for the current state
  String stateLabel;

  final double borderRadius; // Add border radius property



  Rectangle({
    required this.position,
    required this.length,
    required this.color,
    required this.value,
    required this.maxValue,
    required this.label,
    required this.stateLabel,
    this.borderRadius = 0.0, // Default to no border radius

  });
}
