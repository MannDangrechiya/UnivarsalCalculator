import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_calculator/controllers/calc_controller.dart';
import '../widgets/calc_display.dart';
import '../widgets/history_sheet.dart';

class BasicCalcScreen extends StatelessWidget {
  const BasicCalcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalcController calcController = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final operatorColor = isDark ? Colors.deepPurpleAccent : Colors.deepPurple;
    final numberColor = isDark ? Colors.grey : Colors.black87;
    const textColor = Colors.white;

    // Calculator button
    Widget calcButton(String text, {Color? color, int flex = 1}) {
      color ??= operatorColor;
      return Expanded(
        flex: flex,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () {
              switch (text) {
                case 'C':
                  calcController.clear(type: 'basic');
                  break;
                case '⌫':
                  calcController.backspace(type: 'basic');
                  break;
                case '=':
                  calcController.calculate(type: 'basic');
                  break;
                default:
                  calcController.append(text, type: 'basic');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    Widget buildButtonRow(List<String> texts) {
      return Row(
        children: texts.map((t) {
          Color color = numberColor;
          if (['/', '*', '-', '+', '%'].contains(t)) color = operatorColor;
          if (t == 'C') color = Colors.red;
          if (t == '⌫') color = Colors.orange;
          if (t == '=') color = Colors.green;
          return calcButton(t, color: color, flex: t == '0' ? 2 : 1);
        }).toList(),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        calcController.clear(type: 'basic');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Basic Calculator"),
          backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (_) => const HistorySheet(mode: 'basic'),
                );
              },
            ),
          ],
        ),
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF9F9F9),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(flex: 2, child: CalcDisplay(type: 'basic')),
              const SizedBox(height: 12),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButtonRow(['C', '%', '/', '⌫']),
                    buildButtonRow(['7', '8', '9', '*']),
                    buildButtonRow(['4', '5', '6', '-']),
                    buildButtonRow(['1', '2', '3', '+']),
                    buildButtonRow(['0', '.', '=']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
