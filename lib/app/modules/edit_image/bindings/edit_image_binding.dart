import 'package:get/get.dart';

import '../controllers/edit_image_controller.dart';

class EditImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditImageController>(
      () => EditImageController(),
    );
  }
}
