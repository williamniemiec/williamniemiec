import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodePainter extends CustomPainter {
  BarcodePainter({
    required this.barcodes,
    required this.scannedCodes,
    required this.imageSize,
  });

  final List<Barcode> barcodes;
  final Set<String> scannedCodes;
  final Size imageSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (final Barcode barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null) {
        if (scannedCodes.contains(code)) {
          paint.color = Colors.yellow;
        } else {
          paint.color = Colors.green;
        }
      } else {
        paint.color = Colors.red;
      }

      final Rect rect = Rect.fromLTRB(
        barcode.boundingBox.left,
        barcode.boundingBox.top,
        barcode.boundingBox.right,
        barcode.boundingBox.bottom,
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(BarcodePainter oldDelegate) {
    return oldDelegate.barcodes != barcodes ||
        oldDelegate.scannedCodes != scannedCodes;
  }
}