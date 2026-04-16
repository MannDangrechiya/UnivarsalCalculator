import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dark Mode toggle
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              trailing: Obx(
                () => Switch(
                  value: themeController.themeMode.value == ThemeMode.dark,
                  onChanged: (v) => themeController.toggleTheme(),
                ),
              ),
            ),
            const Divider(),

            // App Version
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("App Version"),
              subtitle: Text("1.0.0"),
            ),

            const Spacer(), // pushes the name to the bottom
            // Your name section
            Column(
              children: const [
                Divider(),
                SizedBox(height: 8),
                Text(
                  "Developed by Mann Dangrechiya",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
