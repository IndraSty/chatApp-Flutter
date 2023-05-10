import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapps/app/controllers/auth_controller.dart';
import 'package:chatapps/app/controllers/theme_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constant.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authC = Get.find<AuthController>();
  final themeC = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    controller.emailC.text = authC.user.value.email!;
    controller.namaC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status!;
    return Obx(() => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          backgroundColor: themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor,
          title: const Text('Change Profile'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              AvatarGlow(
                endRadius: 75,
                glowColor: themeC.isDarkMode.isTrue ? Colors.white : Colors.black,
                duration: const Duration(seconds: 2),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Stack(
                    children: [
                      Obx(() => ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: authC.user.value.img! == "NoImage"
                                ? Image.asset(
                                    "assets/icon/man.png",
                                    fit: BoxFit.cover,
                                  )
                                : controller.isEdit.isTrue
                                    ? Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(controller.image_!.path),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Image.network(
                                        authC.user.value.img!,
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                      ),
                          )),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            controller.showSelectPhotoOptions(context);
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 2, color: Colors.white),
                                color: Constant.primaryColor),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.emailC,
                readOnly: true,
                textInputAction: TextInputAction.next,
                cursorColor: Constant.primaryColor,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    focusColor: Constant.primaryColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.namaC,
                textInputAction: TextInputAction.next,
                cursorColor: Constant.primaryColor,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    focusColor: Constant.primaryColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.statusC,
                textInputAction: TextInputAction.done,
                cursorColor: Constant.primaryColor,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    focusColor: Constant.primaryColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Constant.primaryColor)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
              ),
              const SizedBox(
                height: 10,
              ),
              
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.changeProfile(
                        controller.namaC.text, controller.statusC.text);
                    controller.uploadImg().then((hasil) => {
                          if (hasil != null) {authC.uploadImgUrl(hasil)}
                        });
                    Get.back();
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
