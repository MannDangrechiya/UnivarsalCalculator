import 'package:flutter/material.dart';
import 'dart:math';

class BusinessCalcScreen extends StatefulWidget {
  const BusinessCalcScreen({super.key});

  @override
  State<BusinessCalcScreen> createState() => _BusinessCalcScreenState();
}

class _BusinessCalcScreenState extends State<BusinessCalcScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ----- EMI Controllers -----
  final emiPrincipalController = TextEditingController();
  final emiRateController = TextEditingController();
  final emiTenureController = TextEditingController();
  double? emiResult;

  // ----- Tax Controllers -----
  final taxIncomeController = TextEditingController();
  double? taxResult;

  // ----- Savings Controllers -----
  final savingsPrincipalController = TextEditingController();
  final savingsRateController = TextEditingController();
  final savingsYearsController = TextEditingController();
  double? savingsResult;

  // ----- Profit/Loss Controllers -----
  final costController = TextEditingController();
  final sellingController = TextEditingController();
  String? profitLossResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  // ----- EMI Calculation -----
  void calculateEMI() {
    final P = double.tryParse(emiPrincipalController.text) ?? 0;
    final R = double.tryParse(emiRateController.text) ?? 0;
    final N = double.tryParse(emiTenureController.text) ?? 0;

    if (P > 0 && R > 0 && N > 0) {
      final r = R / (12 * 100);
      final n = N * 12;
      final calculatedEMI = (P * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
      setState(() {
        emiResult = calculatedEMI;
      });
    }
  }

  // ----- Tax Calculation -----
  void calculateTax() {
    final income = double.tryParse(taxIncomeController.text) ?? 0;
    double calculatedTax = 0;

    if (income <= 250000) {
      calculatedTax = 0;
    } else if (income <= 500000) {
      calculatedTax = (income - 250000) * 0.05;
    } else if (income <= 1000000) {
      calculatedTax = 12500 + (income - 500000) * 0.2;
    } else {
      calculatedTax = 112500 + (income - 1000000) * 0.3;
    }

    setState(() {
      taxResult = calculatedTax;
    });
  }

  // ----- Savings Calculation -----
  void calculateSavings() {
    final P = double.tryParse(savingsPrincipalController.text) ?? 0;
    final R = double.tryParse(savingsRateController.text) ?? 0;
    final N = double.tryParse(savingsYearsController.text) ?? 0;

    if (P > 0 && R > 0 && N > 0) {
      final calculated = P * pow(1 + R / 100, N);
      setState(() {
        savingsResult = calculated;
      });
    }
  }

  // ----- Profit/Loss Calculation -----
  void calculateProfitLoss() {
    final cost = double.tryParse(costController.text) ?? 0;
    final selling = double.tryParse(sellingController.text) ?? 0;

    if (cost > 0 && selling > 0) {
      if (selling > cost) {
        profitLossResult = 'Profit: ₹${(selling - cost).toStringAsFixed(2)}';
      } else if (selling < cost) {
        profitLossResult = 'Loss: ₹${(cost - selling).toStringAsFixed(2)}';
      } else {
        profitLossResult = 'No Profit, No Loss';
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Calculator'),
        bottom: TabBar(
          controller: _tabController,
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
          // ---------- EMI Tab ----------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emiPrincipalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Principal Amount',
                  ),
                ),
                TextField(
                  controller: emiRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Annual Interest Rate (%)',
                  ),
                ),
                TextField(
                  controller: emiTenureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tenure (years)',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calculateEMI,
                  child: const Text('Calculate EMI'),
                ),
                const SizedBox(height: 16),
                if (emiResult != null)
                  Text(
                    'Monthly EMI: ₹${emiResult!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          // ---------- Tax Tab ----------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: taxIncomeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Income (₹)'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calculateTax,
                  child: const Text('Calculate Tax'),
                ),
                const SizedBox(height: 16),
                if (taxResult != null)
                  Text(
                    'Tax Payable: ₹${taxResult!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          // ---------- Savings Tab ----------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: savingsPrincipalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Principal Amount',
                  ),
                ),
                TextField(
                  controller: savingsRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Annual Interest Rate (%)',
                  ),
                ),
                TextField(
                  controller: savingsYearsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Years'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calculateSavings,
                  child: const Text('Calculate Maturity'),
                ),
                const SizedBox(height: 16),
                if (savingsResult != null)
                  Text(
                    'Maturity Amount: ₹${savingsResult!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          // ---------- Profit/Loss Tab ----------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cost Price (₹)',
                  ),
                ),
                TextField(
                  controller: sellingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Selling Price (₹)',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calculateProfitLoss,
                  child: const Text('Calculate'),
                ),
                const SizedBox(height: 16),
                if (profitLossResult != null)
                  Text(
                    profitLossResult!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
