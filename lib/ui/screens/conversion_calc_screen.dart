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
  late final TabController _tabController;

  // Controllers
  final _lengthCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _volumeCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _distanceCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _birthdateCtrl = TextEditingController();
  final _currencyAmountCtrl = TextEditingController();

  // Dropdown selections
  String _lengthFrom = 'Meter', _lengthTo = 'Kilometer';
  String _weightFrom = 'Kilogram', _weightTo = 'Gram';
  String _volumeFrom = 'Liter', _volumeTo = 'Milliliter';
  String _tempFrom = 'Celsius', _tempTo = 'Fahrenheit';
  String _currencyFrom = 'USD', _currencyTo = 'INR';

  // Results
  double _lenRes = 0,
      _wtRes = 0,
      _volRes = 0,
      _tempRes = 0,
      _speedRes = 0,
      _currencyRes = 0,
      _conversionRate = 0;
  int _ageRes = 0;

  // Currency API
  final CurrencyService _currencyService = CurrencyService();
  bool _loadingCurrency = false, _loadingCurrencyList = true;
  List<String> _currencies = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    try {
      final symbols = await _currencyService.getAvailableCurrencies();
      final currencyList = symbols.keys.toList();
      currencyList.sort();
      setState(() => _currencies = currencyList);
      if (_currencies.isNotEmpty) {
        _currencyFrom = _currencies.first;
        _currencyTo = _currencies[1];
      }
    } catch (e) {
      _showSnack('Failed to load currencies. Check internet connection.');
    } finally {
      setState(() => _loadingCurrencyList = false);
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _convertCurrency() async {
    final amount = double.tryParse(_currencyAmountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      _showSnack('Enter a valid amount');
      return;
    }
    setState(() => _loadingCurrency = true);
    try {
      final res = await _currencyService.convertCurrency(
        _currencyFrom,
        _currencyTo,
        amount,
      );
      setState(() {
        _currencyRes = res['converted'];
        _conversionRate = res['rate'];
      });
    } catch (e) {
      _showSnack('Conversion failed: $e');
    } finally {
      setState(() => _loadingCurrency = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lengthCtrl.dispose();
    _weightCtrl.dispose();
    _volumeCtrl.dispose();
    _tempCtrl.dispose();
    _distanceCtrl.dispose();
    _timeCtrl.dispose();
    _birthdateCtrl.dispose();
    _currencyAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey[200];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Conversion Calculator'),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.amber,
          tabAlignment: TabAlignment.start,
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
          _conversionTab(
            controller: _lengthCtrl,
            from: _lengthFrom,
            to: _lengthTo,
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
            onFromChanged: (v) => setState(() => _lengthFrom = v!),
            onToChanged: (v) => setState(() => _lengthTo = v!),
            convert: () {
              final val = double.tryParse(_lengthCtrl.text) ?? 0;
              setState(
                () => _lenRes = MathUtils.convertLength(
                  val,
                  _lengthFrom,
                  _lengthTo,
                ),
              );
            },
            result: _lenRes,
            unit: _lengthTo,
          ),
          _conversionTab(
            controller: _weightCtrl,
            from: _weightFrom,
            to: _weightTo,
            items: const ['Kilogram', 'Gram', 'Milligram', 'Pound', 'Ounce'],
            onFromChanged: (v) => setState(() => _weightFrom = v!),
            onToChanged: (v) => setState(() => _weightTo = v!),
            convert: () {
              final val = double.tryParse(_weightCtrl.text) ?? 0;
              setState(
                () => _wtRes = MathUtils.convertWeight(
                  val,
                  _weightFrom,
                  _weightTo,
                ),
              );
            },
            result: _wtRes,
            unit: _weightTo,
          ),
          _conversionTab(
            controller: _volumeCtrl,
            from: _volumeFrom,
            to: _volumeTo,
            items: const [
              'Liter',
              'Milliliter',
              'Gallon',
              'Quart',
              'Pint',
              'Cup',
            ],
            onFromChanged: (v) => setState(() => _volumeFrom = v!),
            onToChanged: (v) => setState(() => _volumeTo = v!),
            convert: () {
              final val = double.tryParse(_volumeCtrl.text) ?? 0;
              setState(
                () => _volRes = MathUtils.convertVolume(
                  val,
                  _volumeFrom,
                  _volumeTo,
                ),
              );
            },
            result: _volRes,
            unit: _volumeTo,
          ),
          _conversionTab(
            controller: _tempCtrl,
            from: _tempFrom,
            to: _tempTo,
            items: const ['Celsius', 'Fahrenheit', 'Kelvin'],
            onFromChanged: (v) => setState(() => _tempFrom = v!),
            onToChanged: (v) => setState(() => _tempTo = v!),
            convert: () {
              final val = double.tryParse(_tempCtrl.text) ?? 0;
              setState(
                () => _tempRes = MathUtils.convertTemperature(
                  val,
                  _tempFrom,
                  _tempTo,
                ),
              );
            },
            result: _tempRes,
            unit: _tempTo,
          ),
          _speedTab(),
          _ageTab(),
          _currencyTab(),
        ],
      ),
    );
  }

  // Generic conversion tab
  Widget _conversionTab({
    required TextEditingController controller,
    required String from,
    required String to,
    required List<String> items,
    required Function(String?) onFromChanged,
    required Function(String?) onToChanged,
    required VoidCallback convert,
    required double result,
    required String unit,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Value',
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: from,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onFromChanged,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: to,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onToChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: convert,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Convert',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Converted: ${result.toStringAsFixed(2)} $unit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _speedTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _distanceCtrl,
            decoration: InputDecoration(
              labelText: 'Distance (m)',
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _timeCtrl,
            decoration: InputDecoration(
              labelText: 'Time (s)',
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final d = double.tryParse(_distanceCtrl.text) ?? 0;
              final t = double.tryParse(_timeCtrl.text) ?? 1;
              setState(() => _speedRes = MathUtils.calculateSpeed(d, t));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Calculate Speed',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Speed: ${_speedRes.toStringAsFixed(2)} m/s',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ageTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _birthdateCtrl,
            decoration: InputDecoration(
              labelText: 'Birthdate (YYYY-MM-DD)',
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              try {
                final date = DateTime.parse(_birthdateCtrl.text);
                setState(() => _ageRes = MathUtils.calculateAge(date));
              } catch (_) {
                _showSnack('Invalid date format');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Calculate Age',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Age: $_ageRes years',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currencyTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_loadingCurrencyList)
      return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _currencyAmountCtrl,
            decoration: InputDecoration(
              labelText: 'Amount',
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _currencyFrom,
                  decoration: InputDecoration(
                    labelText: 'From',
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: _currencies
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _currencyFrom = v!),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _currencyTo,
                  decoration: InputDecoration(
                    labelText: 'To',
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: _currencies
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _currencyTo = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loadingCurrency ? null : _convertCurrency,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _loadingCurrency
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Convert',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 16),
          Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Rate: 1 $_currencyFrom = ${_conversionRate.toStringAsFixed(4)} $_currencyTo\nConverted: ${_currencyRes.toStringAsFixed(2)} $_currencyTo',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
