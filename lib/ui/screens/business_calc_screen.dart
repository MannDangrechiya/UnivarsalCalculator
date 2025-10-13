import 'package:flutter/material.dart';
import 'dart:math';

class BusinessCalcScreen extends StatefulWidget {
  const BusinessCalcScreen({super.key});

  @override
  State<BusinessCalcScreen> createState() => _BusinessCalcScreenState();
}

class _BusinessCalcScreenState extends State<BusinessCalcScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Controllers
  final emiPrincipalController = TextEditingController();
  final emiRateController = TextEditingController();
  final emiTenureController = TextEditingController();
  double? emiResult;

  final taxIncomeController = TextEditingController();
  double? taxResult;

  final savingsPrincipalController = TextEditingController();
  final savingsRateController = TextEditingController();
  final savingsYearsController = TextEditingController();
  double? savingsResult;

  final costController = TextEditingController();
  final sellingController = TextEditingController();
  String? profitLossResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    emiPrincipalController.dispose();
    emiRateController.dispose();
    emiTenureController.dispose();
    taxIncomeController.dispose();
    savingsPrincipalController.dispose();
    savingsRateController.dispose();
    savingsYearsController.dispose();
    costController.dispose();
    sellingController.dispose();
    super.dispose();
  }

  // ----- Calculations -----
  void calculateEMI() {
    final P = double.tryParse(emiPrincipalController.text) ?? 0;
    final R = double.tryParse(emiRateController.text) ?? 0;
    final N = double.tryParse(emiTenureController.text) ?? 0;
    if (P > 0 && R > 0 && N > 0) {
      final r = R / 1200;
      final n = N * 12;
      emiResult = (P * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
      setState(() {});
    }
  }

  void calculateTax() {
    final income = double.tryParse(taxIncomeController.text) ?? 0;
    double tax = 0;
    if (income <= 250000) {
      tax = 0;
    } else if (income <= 500000)
      tax = (income - 250000) * 0.05;
    else if (income <= 1000000)
      tax = 12500 + (income - 500000) * 0.2;
    else
      tax = 112500 + (income - 1000000) * 0.3;

    taxResult = tax;
    setState(() {});
  }

  void calculateSavings() {
    final P = double.tryParse(savingsPrincipalController.text) ?? 0;
    final R = double.tryParse(savingsRateController.text) ?? 0;
    final N = double.tryParse(savingsYearsController.text) ?? 0;
    if (P > 0 && R > 0 && N > 0) {
      savingsResult = P * pow(1 + R / 100, N);
      setState(() {});
    }
  }

  void calculateProfitLoss() {
    final cost = double.tryParse(costController.text) ?? 0;
    final selling = double.tryParse(sellingController.text) ?? 0;
    if (cost > 0 && selling > 0) {
      if (selling > cost) {
        profitLossResult = 'Profit: ₹${(selling - cost).toStringAsFixed(2)}';
      } else if (selling < cost)
        profitLossResult = 'Loss: ₹${(cost - selling).toStringAsFixed(2)}';
      else
        profitLossResult = 'No Profit, No Loss';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey.shade100;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final resultColor = Colors.greenAccent.shade400;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Business Calculator'),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(
              child: Text('EMI', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Tax', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Savings', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Profit/Loss', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEMITab(cardColor!, textColor, resultColor),
          _buildTaxTab(cardColor, textColor, resultColor),
          _buildSavingsTab(cardColor, textColor, resultColor),
          _buildProfitLossTab(cardColor, textColor, resultColor),
        ],
      ),
    );
  }

  // ---------- Tabs ----------
  Widget _buildEMITab(Color cardColor, Color textColor, Color resultColor) {
    return _buildCalcTab(
      cardColor,
      children: [
        _input(emiPrincipalController, 'Principal Amount', textColor),
        _input(emiRateController, 'Annual Interest Rate (%)', textColor),
        _input(emiTenureController, 'Tenure (years)', textColor),
        _button('Calculate EMI', calculateEMI),
        if (emiResult != null)
          _resultCard(
            'Monthly EMI',
            '₹${emiResult!.toStringAsFixed(2)}',
            resultColor,
          ),
      ],
    );
  }

  Widget _buildTaxTab(Color cardColor, Color textColor, Color resultColor) {
    return _buildCalcTab(
      cardColor,
      children: [
        _input(taxIncomeController, 'Income (₹)', textColor),
        _button('Calculate Tax', calculateTax),
        if (taxResult != null)
          _resultCard(
            'Tax Payable',
            '₹${taxResult!.toStringAsFixed(2)}',
            resultColor,
          ),
      ],
    );
  }

  Widget _buildSavingsTab(Color cardColor, Color textColor, Color resultColor) {
    return _buildCalcTab(
      cardColor,
      children: [
        _input(savingsPrincipalController, 'Principal Amount', textColor),
        _input(savingsRateController, 'Annual Interest Rate (%)', textColor),
        _input(savingsYearsController, 'Years', textColor),
        _button('Calculate Maturity', calculateSavings),
        if (savingsResult != null)
          _resultCard(
            'Maturity Amount',
            '₹${savingsResult!.toStringAsFixed(2)}',
            resultColor,
          ),
      ],
    );
  }

  Widget _buildProfitLossTab(
    Color cardColor,
    Color textColor,
    Color resultColor,
  ) {
    return _buildCalcTab(
      cardColor,
      children: [
        _input(costController, 'Cost Price (₹)', textColor),
        _input(sellingController, 'Selling Price (₹)', textColor),
        _button('Calculate', calculateProfitLoss),
        if (profitLossResult != null)
          _resultCard('Profit/Loss', profitLossResult!, resultColor),
      ],
    );
  }

  // ---------- Shared Widgets ----------
  Widget _buildCalcTab(Color cardColor, {required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children
            .map(
              (w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: w,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label,
    Color textColor,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _button(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _resultCard(String title, String value, Color resultColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calculate, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: resultColor,
            ),
          ),
        ],
      ),
    );
  }
}
