
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  void changeTheme() {
    isDarkMode.value = !isDarkMode.value;
  }


}
