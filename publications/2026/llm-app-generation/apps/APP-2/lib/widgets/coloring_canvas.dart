import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/coloring_page.dart';
import '../providers/coloring_provider.dart';
import '../constants/app_constants.dart';

class ColoringCanvas extends StatefulWidget {
  final ColoringPage page;
  final Function(int) onRegionTapped;

  const ColoringCanvas({
    super.key,
    required this.page,
    required this.onRegionTapped,
  });

  @override
  State<ColoringCanvas> createState() => _ColoringCanvasState();
}

class _ColoringCanvasState extends State<ColoringCanvas> {
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColoringProvider>(
      builder: (context, coloringProvider, child) {
        return Container(
          color: Colors.white,
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: AppConstants.minZoom,
            maxScale: AppConstants.maxZoom,
            onInteractionUpdate: (details) {
              // Update provider with current transformation
              coloringProvider.updateZoom(_transformationController.value.getMaxScaleOnAxis());
            },
            child: Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.textLight, width: 1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: CustomPaint(
                  painter: ColoringPagePainter(
                    page: widget.page,
                    coloringProvider: coloringProvider,
                    onRegionTapped: widget.onRegionTapped,
                  ),
                  child: GestureDetector(
                    onTapDown: (details) {
                      _handleTap(details.localPosition, coloringProvider);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset position, ColoringProvider provider) {
    // Convert tap position to region
    // In a real implementation, you would use the actual SVG path data
    // For now, we'll simulate region detection based on position
    final regionNumber = _getRegionAtPosition(position);
    if (regionNumber != null) {
      widget.onRegionTapped(regionNumber);
    }
  }

  int? _getRegionAtPosition(Offset position) {
    // Simulate region detection
    // In a real app, this would use proper hit testing with SVG paths
    final x = position.dx;
    final y = position.dy;
    
    // Simple grid-based region detection for demo
    final gridX = (x / 50).floor();
    final gridY = (y / 50).floor();
    final regionNumber = gridY * 8 + gridX + 1;
    
    if (regionNumber > 0 && regionNumber <= widget.page.regions.length) {
      return regionNumber;
    }
    
    return null;
  }
}

class ColoringPagePainter extends CustomPainter {
  final ColoringPage page;
  final ColoringProvider coloringProvider;
  final Function(int) onRegionTapped;

  ColoringPagePainter({
    required this.page,
    required this.coloringProvider,
    required this.onRegionTapped,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Draw regions
    for (final region in page.regions) {
      final regionColor = coloringProvider.getRegionColor(region.number);
      
      if (regionColor != null) {
        // Region is colored or highlighted
        paint.color = regionColor;
        _drawRegion(canvas, region, paint, size);
      }
      
      // Draw region outline
      paint
        ..color = AppConstants.textLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      _drawRegion(canvas, region, paint, size);
      
      // Draw region number if not colored
      if (!coloringProvider.isRegionColored(region.number)) {
        _drawRegionNumber(canvas, region, size);
      }
    }

    // Highlight selected regions
    for (final regionNumber in coloringProvider.highlightedRegions) {
      final region = page.regions.firstWhere((r) => r.number == regionNumber);
      paint
        ..color = Colors.yellow.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      _drawRegion(canvas, region, paint, size);
    }
  }

  void _drawRegion(Canvas canvas, ColorRegion region, Paint paint, Size size) {
    // In a real implementation, you would draw the actual SVG path
    // For demo purposes, we'll draw simple rectangles
    final gridX = ((region.number - 1) % 8) * (size.width / 8);
    final gridY = ((region.number - 1) ~/ 8) * (size.height / 8);
    
    final rect = Rect.fromLTWH(
      gridX,
      gridY,
      size.width / 8,
      size.height / 8,
    );
    
    if (paint.style == PaintingStyle.fill) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRect(rect, paint);
    }
  }

  void _drawRegionNumber(Canvas canvas, ColorRegion region, Size size) {
    final gridX = ((region.number - 1) % 8) * (size.width / 8);
    final gridY = ((region.number - 1) ~/ 8) * (size.height / 8);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: region.number.toString(),
        style: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final offset = Offset(
      gridX + (size.width / 8 - textPainter.width) / 2,
      gridY + (size.height / 8 - textPainter.height) / 2,
    );
    
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(ColoringPagePainter oldDelegate) {
    return oldDelegate.page != page ||
           oldDelegate.coloringProvider != coloringProvider;
  }
}