import 'package:flutter/material.dart';
import '../models/line_model.dart';
import '../models/point_model.dart';

class DrawingNotifier extends ChangeNotifier {
  final List<Line> _lines = [];
  List<Line> get lines => _lines;

  void startDrawing(Offset offset) {
    _lines.add(Line(points: [Point(offset: offset)]));
    notifyListeners();
  }

  void draw(Offset offset) {
    if (_lines.isNotEmpty) {
      _lines.last.points.add(Point(offset: offset));
      notifyListeners();
    }
  }
}