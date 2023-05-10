import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constant.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  UpdateStatusView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  final themeC = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    controller.statusC.text = authC.user.value.status!;
    return Obx(() => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          backgroundColor: themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor,
          title: const Text('Update Status'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: controller.statusC,
                textInputAction: TextInputAction.done,
                onEditingComplete: (){
                  authC.onUpdateStatus(controller.statusC.text);
                },
                cursorColor: Constant.primaryColor,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    focusColor: Constant.primaryColor,
                    labelText: "Status",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.onUpdateStatus(controller.statusC.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  ),
                  child: const Text(
                    "UPDATE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
