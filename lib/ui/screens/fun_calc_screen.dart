import 'package:flutter/material.dart';
import '../../utils/math_utils.dart';

class FunCalcScreen extends StatefulWidget {
  const FunCalcScreen({super.key});

  @override
  State<FunCalcScreen> createState() => _FunCalcScreenState();
}

class _FunCalcScreenState extends State<FunCalcScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for inputs
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final TextEditingController _birthdateController = TextEditingController();

  // Calculated results
  double _calculatedTip = 0.0;
  double _calculatedDiscount = 0.0;
  int _dateDifference = 0;
  int _calculatedAge = 0;
  String _zodiacSign = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _tipController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _gstController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fun / Misc Calculator'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              child: Text(
                'Tip Calculator',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Discount / GST',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Date Difference',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Age / Zodiac',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _tipCalculatorTab(),
          _discountGstTab(),
          _dateDifferenceTab(),
          _ageZodiacTab(),
        ],
      ),
    );
  }

  /// Tip Calculator
  Widget _tipCalculatorTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Bill Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _tipController,
            decoration: const InputDecoration(
              labelText: 'Tip %',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(_amountController.text) ?? 0;
              double tipPercent = double.tryParse(_tipController.text) ?? 0;
              setState(() {
                _calculatedTip = MathUtils.calculateTip(amount, tipPercent);
              });
            },
            child: const Text('Calculate Tip'),
          ),
          const SizedBox(height: 20),
          Text(
            'Tip Amount: $_calculatedTip',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Discount / GST Calculator
  Widget _discountGstTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Original Price',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _discountController,
            decoration: const InputDecoration(
              labelText: 'Discount %',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _gstController,
            decoration: const InputDecoration(
              labelText: 'GST %',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              double price = double.tryParse(_priceController.text) ?? 0;
              double discount = double.tryParse(_discountController.text) ?? 0;
              double gst = double.tryParse(_gstController.text) ?? 0;
              setState(() {
                _calculatedDiscount = MathUtils.calculateDiscountGST(
                  price,
                  discount,
                  gst,
                );
              });
            },
            child: const Text('Calculate Price'),
          ),
          const SizedBox(height: 20),
          Text(
            'Final Price: $_calculatedDiscount',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Date Difference Calculator
  Widget _dateDifferenceTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _startDateController,
            decoration: const InputDecoration(
              labelText: 'Start Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _endDateController,
            decoration: const InputDecoration(
              labelText: 'End Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              try {
                DateTime start = DateTime.parse(
                  _startDateController.text.trim(),
                );
                DateTime end = DateTime.parse(_endDateController.text.trim());
                setState(() {
                  _dateDifference = MathUtils.calculateDateDifference(
                    start,
                    end,
                  );
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Date Format')),
                );
              }
            },
            child: const Text('Calculate Difference'),
          ),
          const SizedBox(height: 20),
          Text(
            'Days Difference: $_dateDifference',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Age & Zodiac Calculator
  Widget _ageZodiacTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _birthdateController,
            decoration: const InputDecoration(
              labelText: 'Birthdate (YYYY-MM-DD)',
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
                  _zodiacSign = MathUtils.getZodiacSign(birthDate);
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Date Format')),
                );
              }
            },
            child: const Text('Calculate Age & Zodiac'),
          ),
          const SizedBox(height: 20),
          Text(
            'Age: $_calculatedAge years',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Zodiac Sign: $_zodiacSign',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
