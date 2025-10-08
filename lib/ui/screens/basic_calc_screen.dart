import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_calculator/controllers/calc_controller.dart';
import 'package:universal_calculator/ui/widgets/history_sheet.dart';
import '../widgets/calc_display.dart';

class BasicCalcScreen extends StatelessWidget {
  const BasicCalcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalcController calcController = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Set operator colors dynamically
    Color operatorColor = isDark
        ? Colors.deepPurpleAccent
        : Colors.deepPurple.shade700;

    // Button text color
    Color textColor = Colors.white;

    // Use these in your calcButton:
    Widget calcButton(String text, {Color? color, int flex = 1}) {
      color ??= operatorColor; // background
      return Expanded(
        flex: flex,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () {
              if (text == 'C') {
                calcController.clear();
              } else if (text == '=')
                calcController.calculate();
              else
                calcController.append(text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor, // text
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic Calculator"),
        backgroundColor: isDark ? Colors.black : Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => HistorySheet(),
              );
            },
          ),
        ],
      ),
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Expanded(flex: 4, child: CalcDisplay()),
            const SizedBox(height: 12),

            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: calcButton('C', color: Colors.red)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('+/-', color: operatorColor)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('%', color: operatorColor)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('/', color: operatorColor)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(child: calcButton('7', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('8', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('9', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('*', color: operatorColor)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(child: calcButton('4', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('5', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('6', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('-', color: operatorColor)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(child: calcButton('1', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('2', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('3', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('+', color: operatorColor)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: calcButton('0', color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('.', color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(child: calcButton('=', color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
