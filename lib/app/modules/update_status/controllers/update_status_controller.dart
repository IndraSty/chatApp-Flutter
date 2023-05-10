import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  late TextEditingController statusC;

  @override
  void onInit() {
    statusC = TextEditingController(text: "Bored");
    super.onInit();
  }
  
  @override
  void onClose() {
    statusC.dispose();
    super.onClose();
  }
}
