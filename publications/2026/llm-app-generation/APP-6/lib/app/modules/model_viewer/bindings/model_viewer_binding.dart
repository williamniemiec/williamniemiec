import 'package:get/get.dart';

import '../controllers/model_viewer_controller.dart';

class ModelViewerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModelViewerController>(
      () => ModelViewerController(),
    );
  }
}