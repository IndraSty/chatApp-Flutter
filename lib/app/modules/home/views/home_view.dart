import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constant.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  final themeC = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          backgroundColor: themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor,
          title: const Text(
            "Chatty",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Get.toNamed(Routes.PROFILE),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10,)
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10,),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.chatStream(authC.user.value.email!),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.active) {
                    var listDocChats = snapshot1.data!.docs;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listDocChats.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: controller
                              .friendStream(listDocChats[index]["connection"]),
                          builder: (context, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.active) {
                              var data = snapshot2.data!.data();
                              return data!["status"] == ""
                                  ? ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 0),
                                      onTap: () => controller.goToChatRoom(
                                          listDocChats[index].id,
                                          authC.user.value.email!,
                                          listDocChats[index]["connection"]),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: data["img"] == "NoImage"
                                              ? Image.asset(
                                                  "assets/icon/man.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  data["img"],
                                                  fit: BoxFit.cover,
                                                  height: 75,
                                                  width: 75,
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        "${data["name"]}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing:
                                          listDocChats[index]["total_unread"] == 0
                                              ? const SizedBox()
                                              : Chip(
                                                  backgroundColor:
                                                      Constant.primaryColor,
                                                  label: Text(
                                                    "${listDocChats[index]["total_unread"]}",
                                                    style: const TextStyle(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                ),
                                    )
                                  : ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 0),
                                      onTap: () => controller.goToChatRoom(
                                          listDocChats[index].id,
                                          authC.user.value.email!,
                                          listDocChats[index]["connection"]),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: data["img"] == "NoImage"
                                              ? Image.asset(
                                                  "assets/icon/man.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  data["img"],
                                                  fit: BoxFit.cover,
                                                  height: 75,
                                                  width: 75,
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        "${data["name"]}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${data["status"]}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing:
                                          listDocChats[index]["total_unread"] == 0
                                              ? const SizedBox()
                                              : Chip(
                                                  backgroundColor:
                                                      Constant.primaryColor,
                                                  label: Text(
                                                    "${listDocChats[index]["total_unread"]}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                    );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.black12,
        floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: () => Get.toNamed(Routes.SEARCH),
            backgroundColor: themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor,
            child: const Icon(Icons.chat_rounded, color: Colors.white,),
          ),
        ),
      ),
    );
  }
}
