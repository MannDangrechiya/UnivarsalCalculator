import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_calculator/controllers/calc_controller.dart';

class CalcDisplay extends StatelessWidget {
  const CalcDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final CalcController calcController = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Expression Text
          Obx(
            () => Text(
              calcController.display.value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          const SizedBox(height: 8),

          // Result Text
          Obx(
            () => Text(
              calcController.result.value,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
