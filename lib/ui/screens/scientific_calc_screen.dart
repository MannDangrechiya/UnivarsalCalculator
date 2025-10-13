import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_calculator/controllers/calc_controller.dart';
import '../widgets/calc_display.dart';
import '../widgets/history_sheet.dart';

class ScientificCalcScreen extends StatelessWidget {
  const ScientificCalcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalcController calcController = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final operatorColor = isDark ? Colors.deepPurpleAccent : Colors.deepPurple;
    final numberColor = isDark ? Colors.grey : Colors.black87;
    const textColor = Colors.white;

    Widget calcButton(String text, {Color? color, int flex = 1}) {
      color ??= operatorColor;
      return Expanded(
        flex: flex,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () {
              if (text == 'C') {
                calcController.clear(type: 'scientific');
              } else if (text == '⌫') {
                calcController.backspace(type: 'scientific');
              } else if (text == '=') {
                calcController.calculate(type: 'scientific');
              } else if (['sin', 'cos', 'tan', 'log', '√'].contains(text)) {
                calcController.append(
                  text == '√' ? '√(' : '$text(',
                  type: 'scientific',
                );
              } else {
                calcController.append(text, type: 'scientific');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    }

    final buttonRows = [
      ['C', '(', ')', '⌫'],
      ['sin', 'cos', 'tan', '√'],
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', 'π', '+'],
      ['e', '^', 'log', '='],
    ];

    return WillPopScope(
      onWillPop: () async {
        calcController.clear(type: 'scientific');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scientific Calculator'),
          backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => const HistorySheet(mode: 'scientific'),
              ),
            ),
          ],
        ),
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF9F9F9),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Expanded(flex: 2, child: CalcDisplay(type: 'scientific')),
              const SizedBox(height: 20),
              Expanded(
                flex: 5,
                child: Column(
                  children: buttonRows.map((row) {
                    return Row(
                      children: row.map((text) {
                        Color color = numberColor;
                        if ([
                          '(',
                          ')',
                          '+',
                          '-',
                          '×',
                          '÷',
                          'π',
                          'e',
                          '^',
                          'sin',
                          'cos',
                          'tan',
                          'log',
                          '√',
                        ].contains(text)) {
                          color = operatorColor;
                        } else if (text == 'C') {
                          color = Colors.red;
                        } else if (text == '⌫') {
                          color = Colors.orange;
                        } else if (text == '=') {
                          color = Colors.green;
                        }
                        // '0' spans 2 columns
                        //int flex = text == '0' ? 2 : 1;
                        return calcButton(text, color: color);
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
