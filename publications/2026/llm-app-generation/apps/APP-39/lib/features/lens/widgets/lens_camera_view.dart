import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class LensCameraView extends StatelessWidget {
  final CameraController controller;
  final VoidCallback onCapture;

  const LensCameraView({
    super.key,
    required this.controller,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onCapture,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize!.height,
            height: controller.value.previewSize!.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}