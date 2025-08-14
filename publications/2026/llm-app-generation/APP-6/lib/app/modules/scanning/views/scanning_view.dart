import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spatial_measure/app/modules/scanning/controllers/scanning_controller.dart';

class ScanningView extends GetView<ScanningController> {
  const ScanningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanning'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ScanningView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}