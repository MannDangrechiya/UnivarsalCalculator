import 'package:flutter/material.dart';
import 'dart:math';

class FinancialCalcScreen extends StatefulWidget {
  const FinancialCalcScreen({super.key});

  @override
  State<FinancialCalcScreen> createState() => _FinancialCalcScreenState();
}

class _FinancialCalcScreenState extends State<FinancialCalcScreen> {
  final amountController = TextEditingController();
  final rateController = TextEditingController();
  final timeController = TextEditingController();
  final extraController = TextEditingController(); // for SIP or currency

  String selectedCalc = "Simple Interest";
  double? result;

  final List<String> calcOptions = [
    "Simple Interest",
    "Compound Interest",
    "Loan / EMI",
    "SIP Investment",
    "Currency Converter",
  ];

  void calculate() {
    final amount = double.tryParse(amountController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;
    final time = double.tryParse(timeController.text) ?? 0;
    final extra = double.tryParse(extraController.text) ?? 0;

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
        res =
            (amount * monthlyRate * pow(1 + monthlyRate, months)) /
            (pow(1 + monthlyRate, months) - 1);
        break;

      case "SIP Investment":
        final monthlyRate = rate / 12 / 100;
        res =
            extra *
            ((pow(1 + monthlyRate, time * 12) - 1) / monthlyRate) *
            (1 + monthlyRate);
        break;

      case "Currency Converter":
        // Assume extraController = conversion rate
        res = amount * (extra > 0 ? extra : 83.0); // ₹ → USD example
        break;
    }

    setState(() => result = res);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
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
            // Dropdown
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
              dropdownColor: isDark ? Colors.deepPurple[800] : Colors.white,
              decoration: inputDecoration("Select Calculator Type"),
            ),
            const SizedBox(height: 20),

            // Common inputs
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration("Principal / Amount (₹)"),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 12),

            if (selectedCalc != "Currency Converter")
              TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Interest Rate (%)"),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            if (selectedCalc != "Currency Converter")
              const SizedBox(height: 12),

            if (selectedCalc != "Currency Converter")
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Time (Years)"),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            if (selectedCalc != "Currency Converter")
              const SizedBox(height: 12),

            // Extra input (for SIP or currency)
            if (selectedCalc == "SIP Investment")
              TextField(
                controller: extraController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Monthly Investment (₹)"),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            if (selectedCalc == "Currency Converter")
              TextField(
                controller: extraController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Conversion Rate (e.g., ₹ to USD)"),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),

            const SizedBox(height: 20),

            // Calculate button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? Colors.deepPurple[700]
                      : Colors.deepPurple,
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
            const SizedBox(height: 20),

            // Result display
            if (result != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.deepPurple[800]
                        : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Result:",
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedCalc == "Loan / EMI"
                            ? "₹${result!.toStringAsFixed(2)} / month"
                            : "₹${result!.toStringAsFixed(2)}",
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
}
