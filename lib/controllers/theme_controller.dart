import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/theme/app_theme.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      Get.changeTheme(AppTheme.darkTheme);
    } else {
      themeMode.value = ThemeMode.light;
      Get.changeTheme(AppTheme.lightTheme);
    }
  }

  @override
  void onInit() {
    super.onInit();
    Get.changeTheme(AppTheme.lightTheme);
  }
}
