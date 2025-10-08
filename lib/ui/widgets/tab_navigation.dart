import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tab_controller.dart';

class TabNavigation extends StatelessWidget {
  const TabNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final tabCtrl = Get.find<TabControllerApp>();
    return Obx(
      () => BottomNavigationBar(
        currentIndex: tabCtrl.tabIndex.value,
        onTap: tabCtrl.changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Basic'),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Scientific',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Converter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Financial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'Programmer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Health',
          ),
        ],
      ),
    );
  }
}
