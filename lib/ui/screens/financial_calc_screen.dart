import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class FinancialCalcScreen extends StatefulWidget {
  const FinancialCalcScreen({super.key});

  @override
  State<FinancialCalcScreen> createState() => _FinancialCalcScreenState();
}

class _FinancialCalcScreenState extends State<FinancialCalcScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController extraController = TextEditingController();

  String selectedCalc = "Simple Interest";
  double? result;

  final List<String> calcOptions = [
    "Simple Interest",
    "Compound Interest",
    "Loan / EMI",
    "SIP Investment",
    "Currency Converter",
  ];

  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  /// ------------------- CALCULATION LOGIC -------------------
  void calculate() {
    final double amount = double.tryParse(amountController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;
    final double time = double.tryParse(timeController.text) ?? 0;
    final double extra = double.tryParse(extraController.text) ?? 0;

    double res = 0;

    switch (selectedCalc) {
      case "Simple Interest":
        res = (amount * rate * time) / 100;
        break;

      case "Compound Interest":
        res = amount * pow((1 + rate / 100), time) - amount;
        break;

      case "Loan / EMI":
        final monthlyRate = rate / 12 / 100;
        final months = time * 12;
        if (monthlyRate == 0) {
          res = amount / months;
        } else {
          res =
              (amount * monthlyRate * pow(1 + monthlyRate, months)) /
              (pow(1 + monthlyRate, months) - 1);
        }
        break;

      case "SIP Investment":
        final monthlyRate = rate / 12 / 100;
        final months = time * 12;
        if (monthlyRate == 0) {
          res = extra * months;
        } else {
          res =
              extra *
              ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
              (1 + monthlyRate);
        }
        break;

      case "Currency Converter":
        res = amount * (extra > 0 ? extra : 83.0);
        break;
    }

    setState(() => result = res);
  }

  /// ------------------- UI -------------------
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
      filled: true,
      fillColor: isDark ? Colors.grey[850] : Colors.white,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Calculators"),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Dropdown for calculator type
            DropdownButtonFormField<String>(
              initialValue: selectedCalc,
              items: calcOptions
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedCalc = val!;
                  result = null;
                  amountController.clear();
                  rateController.clear();
                  timeController.clear();
                  extraController.clear();
                });
              },
              decoration: inputDecoration("Select Calculator Type"),
              dropdownColor: isDark ? Colors.deepPurple[800] : Colors.white,
            ),
            const SizedBox(height: 20),

            /// Amount input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(
                selectedCalc == "Currency Converter"
                    ? "Amount (Base Currency)"
                    : "Principal Amount (₹)",
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 12),

            /// Rate & Time input
            if (selectedCalc != "Currency Converter")
              Column(
                children: [
                  TextField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration("Interest Rate (%)"),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration("Time (Years)"),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),

            /// Extra input
            if (selectedCalc == "SIP Investment") ...[
              const SizedBox(height: 12),
              TextField(
                controller: extraController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Monthly Investment (₹)"),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ],
            if (selectedCalc == "Currency Converter") ...[
              const SizedBox(height: 12),
              TextField(
                controller: extraController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Conversion Rate (e.g., ₹ to USD)"),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ],

            const SizedBox(height: 24),

            /// Calculate Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Calculate",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Result Display
            if (result != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.deepPurple[800]
                        : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Result",
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedCalc == "Loan / EMI"
                            ? "${formatter.format(result)} / month"
                            : formatter.format(result),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    rateController.dispose();
    timeController.dispose();
    extraController.dispose();
    super.dispose();
  }
}
