import 'package:flutter/material.dart';
import 'point_model.dart';

class Line {
  final List<Point> points;
  final Color color;
  final double strokeWidth;

  Line({
    required this.points,
    this.color = Colors.black,
    this.strokeWidth = 4.0,
  });
}