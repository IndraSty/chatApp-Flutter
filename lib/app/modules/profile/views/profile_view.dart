import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constant.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../screens/alert_dialog_widget.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  final themeC = Get.find<ThemeController>();
  List<String> popList = ["Light", "Dark"];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back,
              )),
          actions: [
            IconButton(
                onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialogWidget(),
                );
              },
                icon: const Icon(
                  Icons.logout,
                ))
          ],
        ),
        body: Column(children: [
          Obx(
            () => AvatarGlow(
              endRadius: 110,
              glowColor: themeC.isDarkMode.isTrue ? Colors.white : Colors.black,
              duration: Duration(seconds: 2),
              child: Container(
                margin: const EdgeInsets.all(15),
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: authC.user.value.img! == "NoImage"
                      ? Image.asset(
                          "assets/icon/man.png",
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          authC.user.value.img!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          Obx(() => Text(
                authC.user.value.name!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )),
          Text(
            authC.user.value.email!,
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                    leading: const Icon(Icons.note_add_outlined),
                    title: const Text(
                      "Update Status",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                    leading: const Icon(Icons.person),
                    title: const Text(
                      "Ubah Profile",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.color_lens),
                    title: const Text(
                      "Light dan Dark Theme",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing:  Obx(() => Switch(
                      value: themeC.isDarkMode.value,
                      onChanged: (value) {
                        themeC.changeTheme();
                      },
                    )),
    
                       
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Chat App",
                ),
                Text(
                  "v.1.0.1",
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
