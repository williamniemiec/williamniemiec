import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/drawing_notifier.dart';
import '../models/line_model.dart';
import '../models/point_model.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingNotifier>(
      builder: (context, notifier, child) {
        return GestureDetector(
          onPanStart: (details) {
            notifier.startDrawing(details.localPosition);
          },
          onPanUpdate: (details) {
            notifier.draw(details.localPosition);
          },
          child: CustomPaint(
            painter: _DrawingPainter(lines: notifier.lines),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Line> lines;

  _DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final line in lines) {
      paint.color = line.color;
      paint.strokeWidth = line.strokeWidth;

      final path = Path();
      if (line.points.isNotEmpty) {
        path.moveTo(line.points.first.offset.dx, line.points.first.offset.dy);
        for (var i = 1; i < line.points.length; i++) {
          path.lineTo(line.points[i].offset.dx, line.points[i].offset.dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}