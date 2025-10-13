import 'package:flutter/material.dart';
import '../../utils/math_utils.dart';

class FunCalcScreen extends StatefulWidget {
  const FunCalcScreen({super.key});

  @override
  State<FunCalcScreen> createState() => _FunCalcScreenState();
}

class _FunCalcScreenState extends State<FunCalcScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // -------------------- Controllers --------------------
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  // -------------------- Calculated Values --------------------
  double _calculatedTip = 0.0;
  double _finalPrice = 0.0;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fun / Misc Calculator'),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.yellow,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(
              child: Text('Tip', style: TextStyle(color: Colors.white)),
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

  // -------------------- Tip Calculator --------------------
  Widget _tipCalculatorTab() {
    return _buildTabContainer(
      children: [
        _numberInputField(_amountController, 'Bill Amount'),
        _numberInputField(_tipController, 'Tip %'),
        _calcButton('Calculate Tip', () {
          double amount = double.tryParse(_amountController.text) ?? 0;
          double tipPercent = double.tryParse(_tipController.text) ?? 0;
          setState(() {
            _calculatedTip = MathUtils.calculateTip(amount, tipPercent);
          });
        }),
        _resultText('Tip Amount: $_calculatedTip'),
      ],
    );
  }

  // -------------------- Discount / GST --------------------
  Widget _discountGstTab() {
    return _buildTabContainer(
      children: [
        _numberInputField(_priceController, 'Original Price'),
        _numberInputField(_discountController, 'Discount %'),
        _numberInputField(_gstController, 'GST %'),
        _calcButton('Calculate Price', () {
          double price = double.tryParse(_priceController.text) ?? 0;
          double discount = double.tryParse(_discountController.text) ?? 0;
          double gst = double.tryParse(_gstController.text) ?? 0;
          setState(() {
            _finalPrice = MathUtils.calculateDiscountGST(price, discount, gst);
          });
        }),
        _resultText('Final Price: $_finalPrice'),
      ],
    );
  }

  // -------------------- Date Difference --------------------
  Widget _dateDifferenceTab() {
    return _buildTabContainer(
      children: [
        _textInputField(_startDateController, 'Start Date (YYYY-MM-DD)'),
        _textInputField(_endDateController, 'End Date (YYYY-MM-DD)'),
        _calcButton('Calculate Difference', () {
          try {
            DateTime start = DateTime.parse(_startDateController.text.trim());
            DateTime end = DateTime.parse(_endDateController.text.trim());
            setState(() {
              _dateDifference = MathUtils.calculateDateDifference(start, end);
            });
          } catch (_) {
            _showError('Invalid Date Format');
          }
        }),
        _resultText('Days Difference: $_dateDifference'),
      ],
    );
  }

  // -------------------- Age & Zodiac --------------------
  Widget _ageZodiacTab() {
    return _buildTabContainer(
      children: [
        _textInputField(_birthdateController, 'Birthdate (YYYY-MM-DD)'),
        _calcButton('Calculate Age & Zodiac', () {
          try {
            DateTime birthDate = DateTime.parse(
              _birthdateController.text.trim(),
            );
            setState(() {
              _calculatedAge = MathUtils.calculateAge(birthDate);
              _zodiacSign = MathUtils.getZodiacSign(birthDate);
            });
          } catch (_) {
            _showError('Invalid Date Format');
          }
        }),
        _resultText('Age: $_calculatedAge years'),
        _resultText('Zodiac Sign: $_zodiacSign'),
      ],
    );
  }

  // -------------------- Reusable Widgets --------------------
  Widget _buildTabContainer({required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...children, const SizedBox(height: 20)],
      ),
    );
  }

  Widget _numberInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget _textInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _calcButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }

  Widget _resultText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
