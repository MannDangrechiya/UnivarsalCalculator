import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/calc_controller.dart';

class CalcDisplay extends StatelessWidget {
  final String type;
  const CalcDisplay({super.key, this.type = 'basic'});

  @override
  Widget build(BuildContext context) {
    final CalcController controller = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final display = type == 'basic'
        ? controller.basicDisplay
        : controller.scientificDisplay;
    final result = type == 'basic'
        ? controller.basicResult
        : controller.scientificResult;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(
              () => Text(
                display.value,
                style: TextStyle(
                  fontSize: 28,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                result.value,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
