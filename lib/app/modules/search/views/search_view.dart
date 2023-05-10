import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../constant.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  SearchView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  final themeC = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: AppBar(
            backgroundColor: themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor,
            title: const Text('Search'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  controller: controller.searchC,
                  onChanged: (value) =>
                      controller.searchFriend(value, authC.user.value.email!),
                  cursorColor: Constant.primaryColor,
                  style: TextStyle(
                      color:
                          themeC.isDarkMode.isTrue ? Colors.black : Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white, width: 1),
                    ),
                    hintText: "Cari Kontak...",
                    hintStyle: TextStyle(
                        color: themeC.isDarkMode.isTrue
                            ? Colors.black
                            : Colors.black),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: const Icon(
                        Icons.search,
                        color: Constant.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Obx(
          () => controller.tempSearch.isEmpty
              ? Center(
                  child: Container(
                    width: Get.width * 0.7,
                    height: Get.height * 0.7,
                    child: Lottie.asset("assets/icon/empty.json"),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.tempSearch.length,
                  itemBuilder: (context, index) => ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    leading: CircleAvatar(
                      radius: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: controller.tempSearch[index]["img"] == "NoImage"
                            ? Image.asset(
                                "assets/icon/man.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                controller.tempSearch[index]["img"],
                                fit: BoxFit.cover,
                                height: 75,
                                width: 75,
                              ),
                      ),
                    ),
                    title: Text(
                      "${controller.tempSearch[index]["name"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "${controller.tempSearch[index]["status"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: GestureDetector(
                      child: const Chip(label: Text("Message")),
                      onTap: () => authC.addNewConnection(
                          controller.tempSearch[index]["email"]),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
