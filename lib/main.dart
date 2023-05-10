import 'package:chatapps/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/controllers/auth_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authCtrl = Get.put(AuthController(), permanent: true);
  final _themeC = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(
            () => GetMaterialApp(
              title: "Chats",
              theme: ThemeData(
                appBarTheme: AppBarTheme(color: _themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor),
              ),
              darkTheme: ThemeData.dark(),
              themeMode:
                  _themeC.isDarkMode.isTrue ? ThemeMode.dark : ThemeMode.light,
              initialRoute: authCtrl.isSkipIntro.isTrue
                  ? authCtrl.isAuth.isTrue
                      ? Routes.HOME
                      : Routes.LOGIN
                  : Routes.INTRODUCTION,
              getPages: AppPages.routes,
            ),
          );
        }
        return FutureBuilder(
          future: authCtrl.firstInitialized(),
          builder: (context, snapshot) => const SplashScreen(),
        );
      },
    );
  }
}
