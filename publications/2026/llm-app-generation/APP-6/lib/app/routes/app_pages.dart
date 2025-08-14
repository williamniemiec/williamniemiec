import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/model_viewer/bindings/model_viewer_binding.dart';
import '../modules/model_viewer/views/model_viewer_view.dart';
import '../modules/scanning/bindings/scanning_binding.dart';
import '../modules/scanning/views/scanning_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SCANNING,
      page: () => const ScanningView(),
      binding: ScanningBinding(),
    ),
    GetPage(
      name: _Paths.MODEL_VIEWER,
      page: () => const ModelViewerView(),
      binding: ModelViewerBinding(),
    ),
  ];
}