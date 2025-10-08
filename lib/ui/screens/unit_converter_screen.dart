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
    return Scaffold(
      appBar: AppBar(title: const Text("Unit Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: selectedConversion,
              items: conversions
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c, style: const TextStyle(fontSize: 18)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedConversion = v!),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: convert,
              child: const Text('Convert', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 24),
            Text('Result: $result', style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
