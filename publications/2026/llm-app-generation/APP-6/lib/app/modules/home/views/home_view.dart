import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spatial_measure/app/modules/home/controllers/home_controller.dart';
import 'package:spatial_measure/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spatial Measure'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SCANNING),
        child: const Icon(Icons.add),
      ),
    );
  }
}