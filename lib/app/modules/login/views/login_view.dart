import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../constant.dart';
import '../../../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  child: Lottie.asset("assets/icon/auth/login.json"),
                ),
                const Text("Lorem Ipsum", style: TextStyle(color: Constant.txtButton, fontSize: 25, fontWeight: FontWeight.bold),),
                const SizedBox(height: 100,),
                ElevatedButton(
                  onPressed: () => authC.login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Constant.primaryColor, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icon/auth/ic_google.svg"),
                      const SizedBox(width: 20,),
                      const Text("Masuk dengan Google", style: TextStyle(color: Constant.txtButton, fontSize: 15),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
