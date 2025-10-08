import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final List<String> buttons;
  final Function(String) onPressed;

  const Keypad({super.key, required this.buttons, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 buttons per row
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.1, // makes buttons slightly taller
      ),
      itemBuilder: (context, index) {
        final value = buttons[index];

        // Different colors for operators, equal, clear
        Color bgColor;
        if (value == '=') {
          bgColor = Colors.green;
        } else if (value == 'C')
          bgColor = Colors.redAccent;
        else if ([
          '/',
          '*',
          '-',
          '+',
          '^',
          'sin(',
          'cos(',
          'tan(',
          'log(',
          '√(',
          'π',
          'e',
        ].contains(value))
          bgColor = Colors.deepPurple.shade700;
        else
          bgColor = Colors.deepPurple;

        return ElevatedButton(
          onPressed: () => onPressed(value),
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
