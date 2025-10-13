import 'package:flutter/material.dart';
import '../../services/unit_conversion_service.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final UnitConversionService converter = UnitConversionService();
  final TextEditingController inputController = TextEditingController();
  double result = 0.0;

  String selectedConversion = 'm → km';
  final conversions = ['m → km', 'km → m', '°C → °F', '°F → °C'];

  void convert() {
    double val = double.tryParse(inputController.text) ?? 0;
    switch (selectedConversion) {
      case 'm → km':
        result = converter.metersToKilometers(val);
        break;
      case 'km → m':
        result = converter.kilometersToMeters(val);
        break;
      case '°C → °F':
        result = converter.celsiusToFahrenheit(val);
        break;
      case '°F → °C':
        result = converter.fahrenheitToCelsius(val);
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[850] : Colors.grey[100];
    final cardColor = isDark ? Colors.grey[800] : Colors.deepPurple.shade50;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit Converter"),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Input field
              TextField(
                controller: inputController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: textColor, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Enter value',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: bgColor,
                ),
              ),
              const SizedBox(height: 32),

              // Dropdown + Convert button
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedConversion,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: bgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: conversions
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedConversion = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: convert,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Convert',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 54),

              // Result display
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Result: $result',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
