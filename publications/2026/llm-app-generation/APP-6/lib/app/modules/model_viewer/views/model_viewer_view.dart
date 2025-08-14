import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spatial_measure/app/modules/model_viewer/controllers/model_viewer_controller.dart';

class ModelViewerView extends GetView<ModelViewerController> {
  const ModelViewerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Viewer'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ModelViewerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}