import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spatial_measure/app/routes/app_pages.dart';
import 'package:spatial_measure/app/theme/app_theme.dart';

void main() {
  runApp(const SpatialMeasureApp());
}

class SpatialMeasureApp extends StatelessWidget {
  const SpatialMeasureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Spatial Measure",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
