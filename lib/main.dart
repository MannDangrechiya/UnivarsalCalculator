import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:universal_calculator/bindings/initial_binding.dart';
import 'package:universal_calculator/controllers/tab_controller.dart';
import 'package:universal_calculator/controllers/theme_controller.dart';
import 'package:universal_calculator/controllers/calc_controller.dart';
import 'package:universal_calculator/ui/screens/home_screen.dart';
import 'package:universal_calculator/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize controllers
  Get.put(CalcController());
  Get.put(TabControllerApp());
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Universal Calculator',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        initialBinding: InitialBinding(),
        home: const HomeScreen(),
      ),
    );
  }
}
