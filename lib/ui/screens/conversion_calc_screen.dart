import 'package:flutter/material.dart';
import 'package:universal_calculator/services/currency_service.dart';
import '../../utils/math_utils.dart';

class ConversionCalcScreen extends StatefulWidget {
  const ConversionCalcScreen({super.key});

  @override
  State<ConversionCalcScreen> createState() => _ConversionCalcScreenState();
}

class _ConversionCalcScreenState extends State<ConversionCalcScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for inputs
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  // Dropdown values
  String _lengthFrom = 'Meter', _lengthTo = 'Kilometer';
  String _weightFrom = 'Kilogram', _weightTo = 'Gram';
  String _volumeFrom = 'Liter', _volumeTo = 'Milliliter';
  String _tempFrom = 'Celsius', _tempTo = 'Fahrenheit';

  // Converted results
  double _convertedLength = 0.0;
  double _convertedWeight = 0.0;
  double _convertedVolume = 0.0;
  double _convertedTemp = 0.0;
  double _convertedSpeed = 0.0;
  int _calculatedAge = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lengthController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _tempController.dispose();
    _distanceController.dispose();
    _timeController.dispose();
    _birthdateController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversion Calculator'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              child: Text('Length', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Weight', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Volume', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Temperature', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Speed/Time', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Date/Age', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Currency', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // -------------------- LENGTH --------------------
          _conversionTab(
            controller: _lengthController,
            fromValue: _lengthFrom,
            toValue: _lengthTo,
            items: const [
              'Meter',
              'Kilometer',
              'Centimeter',
              'Millimeter',
              'Mile',
              'Yard',
              'Foot',
              'Inch',
            ],
            onFromChanged: (val) => setState(() => _lengthFrom = val!),
            onToChanged: (val) => setState(() => _lengthTo = val!),
            onConvert: () {
              double value = double.tryParse(_lengthController.text) ?? 0;
              setState(() {
                _convertedLength = MathUtils.convertLength(
                  value,
                  _lengthFrom,
                  _lengthTo,
                );
              });
            },
            convertedValue: _convertedLength,
            unit: _lengthTo,
          ),

          // -------------------- WEIGHT --------------------
          _conversionTab(
            controller: _weightController,
            fromValue: _weightFrom,
            toValue: _weightTo,
            items: const ['Kilogram', 'Gram', 'Milligram', 'Pound', 'Ounce'],
            onFromChanged: (val) => setState(() => _weightFrom = val!),
            onToChanged: (val) => setState(() => _weightTo = val!),
            onConvert: () {
              double value = double.tryParse(_weightController.text) ?? 0;
              setState(() {
                _convertedWeight = MathUtils.convertWeight(
                  value,
                  _weightFrom,
                  _weightTo,
                );
              });
            },
            convertedValue: _convertedWeight,
            unit: _weightTo,
          ),

          // -------------------- VOLUME --------------------
          _conversionTab(
            controller: _volumeController,
            fromValue: _volumeFrom,
            toValue: _volumeTo,
            items: const [
              'Liter',
              'Milliliter',
              'Gallon',
              'Quart',
              'Pint',
              'Cup',
            ],
            onFromChanged: (val) => setState(() => _volumeFrom = val!),
            onToChanged: (val) => setState(() => _volumeTo = val!),
            onConvert: () {
              double value = double.tryParse(_volumeController.text) ?? 0;
              setState(() {
                _convertedVolume = MathUtils.convertVolume(
                  value,
                  _volumeFrom,
                  _volumeTo,
                );
              });
            },
            convertedValue: _convertedVolume,
            unit: _volumeTo,
          ),

          // -------------------- TEMPERATURE --------------------
          _conversionTab(
            controller: _tempController,
            fromValue: _tempFrom,
            toValue: _tempTo,
            items: const ['Celsius', 'Fahrenheit', 'Kelvin'],
            onFromChanged: (val) => setState(() => _tempFrom = val!),
            onToChanged: (val) => setState(() => _tempTo = val!),
            onConvert: () {
              double value = double.tryParse(_tempController.text) ?? 0;
              setState(() {
                _convertedTemp = MathUtils.convertTemperature(
                  value,
                  _tempFrom,
                  _tempTo,
                );
              });
            },
            convertedValue: _convertedTemp,
            unit: _tempTo,
          ),

          // -------------------- SPEED / TIME --------------------
          _speedTimeTab(),

          // -------------------- DATE / AGE --------------------
          _dateAgeTab(),

          // -------------------- CURRENCY --------------------
          _currencyTab(),
        ],
      ),
    );
  }

  // -------------------- Generic Conversion Tab --------------------
  Widget _conversionTab({
    required TextEditingController controller,
    required String fromValue,
    required String toValue,
    required List<String> items,
    required Function(String?) onFromChanged,
    required Function(String?) onToChanged,
    required VoidCallback onConvert,
    required double convertedValue,
    required String unit,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Value',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: fromValue,
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onFromChanged,
              ),
              const Icon(Icons.arrow_forward),
              DropdownButton<String>(
                value: toValue,
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onToChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onConvert, child: const Text('Convert')),
          const SizedBox(height: 20),
          Text(
            'Converted: $convertedValue $unit',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // -------------------- SPEED / TIME --------------------
  Widget _speedTimeTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _distanceController,
            decoration: const InputDecoration(
              labelText: 'Distance',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _timeController,
            decoration: const InputDecoration(
              labelText: 'Time',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              double distance = double.tryParse(_distanceController.text) ?? 0;
              double time = double.tryParse(_timeController.text) ?? 1;
              setState(() {
                _convertedSpeed = MathUtils.calculateSpeed(distance, time);
              });
            },
            child: const Text('Calculate Speed'),
          ),
          const SizedBox(height: 20),
          Text(
            'Speed: $_convertedSpeed m/s',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // -------------------- DATE / AGE --------------------
  Widget _dateAgeTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _birthdateController,
            decoration: const InputDecoration(
              labelText: 'Enter Birthdate (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              try {
                DateTime birthDate = DateTime.parse(_birthdateController.text);
                setState(() {
                  _calculatedAge = MathUtils.calculateAge(birthDate);
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Date Format')),
                );
              }
            },
            child: const Text('Calculate Age'),
          ),
          const SizedBox(height: 20),
          Text(
            'Age: $_calculatedAge years',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// -------------------- CURRENCY --------------------
  Widget _currencyTab() {
    final TextEditingController currencyAmountController =
        TextEditingController();
    String fromCurrency = 'USD';
    String toCurrency = 'INR';
    double convertedCurrency = 0.0;
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: currencyAmountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: fromCurrency,
                    items:
                        [
                              'USD',
                              'INR',
                              'EUR',
                              'GBP',
                              'JPY',
                              'AUD',
                              'CAD',
                              'CHF',
                              'CNY',
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => fromCurrency = val!),
                  ),
                  const Icon(Icons.arrow_forward),
                  DropdownButton<String>(
                    value: toCurrency,
                    items:
                        [
                              'USD',
                              'INR',
                              'EUR',
                              'GBP',
                              'JPY',
                              'AUD',
                              'CAD',
                              'CHF',
                              'CNY',
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => toCurrency = val!),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  double amount =
                      double.tryParse(currencyAmountController.text) ?? 0;
                  if (amount <= 0) return;

                  setState(() => isLoading = true);

                  try {
                    final result = await CurrencyService().convertCurrency(
                      fromCurrency,
                      toCurrency,
                      amount,
                    );
                    setState(() {
                      convertedCurrency = result;
                      isLoading = false;
                    });
                  } catch (e) {
                    setState(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Conversion Failed: $e')),
                    );
                  }
                },
                child: const Text('Convert'),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Converted: $convertedCurrency $toCurrency',
                      style: const TextStyle(fontSize: 16),
                    ),
            ],
          ),
        );
      },
    );
  }

  // -------------------- Currency Conversion Method --------------------
}
