import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProgrammerCalcScreen extends StatefulWidget {
  const ProgrammerCalcScreen({super.key});

  @override
  State<ProgrammerCalcScreen> createState() => _ProgrammerCalcScreenState();
}

class _ProgrammerCalcScreenState extends State<ProgrammerCalcScreen> {
  String input = '';
  String selectedType = 'Decimal';

  String binary = '';
  String octal = '';
  String decimal = '';
  String hex = '';

  final List<String> hexButtons = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'CA',
  ];

  void _append(String value) {
    setState(() {
      input += value;
      _convert();
    });
  }

  void _clear() {
    setState(() {
      input = '';
      binary = '';
      octal = '';
      decimal = '';
      hex = '';
    });
  }

  void _convert() {
    try {
      int value;
      switch (selectedType) {
        case 'Decimal':
          value = int.parse(input);
          break;
        case 'Binary':
          value = int.parse(input, radix: 2);
          break;
        case 'Octal':
          value = int.parse(input, radix: 8);
          break;
        case 'Hex':
          value = int.parse(input, radix: 16);
          break;
        default:
          value = int.parse(input);
      }
      setState(() {
        decimal = value.toString();
        binary = value.toRadixString(2);
        octal = value.toRadixString(8);
        hex = value.toRadixString(16).toUpperCase();
      });
    } catch (e) {
      setState(() {
        decimal = binary = octal = hex = 'Invalid';
      });
    }
  }

  Widget calcButton(String text, {Color? color}) {
    final theme = Theme.of(context);
    color ??= theme.primaryColor;
    final textColor = Colors.white;

    return ElevatedButton(
      onPressed: () {
        if (text == 'CA') {
          _clear();
        } else {
          _append(text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(0),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget numberSystemSelector() {
    final theme = Theme.of(context);
    final types = ['Decimal', 'Binary', 'Octal', 'Hex'];
    return Wrap(
      spacing: 6,
      children: types.map((type) {
        final selected = selectedType == type;
        return ChoiceChip(
          label: Text(type),
          selected: selected,
          onSelected: (_) {
            setState(() {
              selectedType = type;
              _convert();
            });
          },
          selectedColor: theme.primaryColor,
          backgroundColor: theme.dividerColor.withOpacity(0.3),
          labelStyle: TextStyle(
            color: selected ? Colors.white : theme.textTheme.bodyMedium!.color,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }

  Widget outputRow(String title, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: theme.dividerColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyMedium!.color,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, size: 20, color: theme.iconTheme.color),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('$title copied!')));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Programmer Calculator"),
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.deepPurple[900]
            : Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
                child: Text(
                  input.isEmpty ? '0' : input,
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 8),
              numberSystemSelector(),
              const SizedBox(height: 8),
              outputRow("Decimal", decimal),
              outputRow("Binary", binary),
              outputRow("Octal", octal),
              outputRow("Hex", hex),
              const SizedBox(height: 8),
              Expanded(
                flex: 3,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: screenWidth / (screenHeight * 0.215),
                  ),
                  itemCount: hexButtons.length,
                  itemBuilder: (context, index) {
                    String btn = hexButtons[index];
                    Color? color = (btn == 'CA') ? Colors.red : null;
                    return calcButton(btn, color: color);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
