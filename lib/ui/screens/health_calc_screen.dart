import 'package:flutter/material.dart';
import 'dart:math';

class HealthCalcScreen extends StatefulWidget {
  const HealthCalcScreen({super.key});

  @override
  State<HealthCalcScreen> createState() => _HealthCalcScreenState();
}

class _HealthCalcScreenState extends State<HealthCalcScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = "Male";

  double? _bmi;
  double? _bmr;
  double? _bodyFat;
  double? _idealWeight;
  double? _dailyCalories;

  void _calculateAll() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);
    final int? age = int.tryParse(_ageController.text);

    if (height == null || weight == null || age == null || height <= 0) return;

    final bmi = weight / pow(height / 100, 2);

    double bmr;
    if (_selectedGender == "Male") {
      bmr = 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age);
    } else {
      bmr = 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age);
    }

    double bodyFat;
    if (_selectedGender == "Male") {
      bodyFat = (1.20 * bmi) + (0.23 * age) - 16.2;
    } else {
      bodyFat = (1.20 * bmi) + (0.23 * age) - 5.4;
    }

    double idealWeight;
    if (_selectedGender == "Male") {
      idealWeight = 50 + 0.9 * (height - 152);
    } else {
      idealWeight = 45.5 + 0.9 * (height - 152);
    }

    double dailyCalories = bmr * 1.375;

    setState(() {
      _bmi = bmi;
      _bmr = bmr;
      _bodyFat = bodyFat;
      _idealWeight = idealWeight;
      _dailyCalories = dailyCalories;
    });
  }

  String _bmiStatus(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey.shade50;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final borderColor = isDark ? Colors.grey[700] : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black87;
    final valueColor = Colors.deepPurpleAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Health Calculator"),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Gender & Age Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                    ],
                    onChanged: (v) => setState(() => _selectedGender = v!),
                    decoration: InputDecoration(
                      labelText: "Gender",
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.white,
                    ),
                    style: TextStyle(color: textColor),
                    dropdownColor: cardColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    "Age (years)",
                    _ageController,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField("Height (cm)", _heightController, isDark),
            const SizedBox(height: 16),
            _buildInputField("Weight (kg)", _weightController, isDark),
            const SizedBox(height: 24),
            // Calculate button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _calculateAll,
                icon: const Icon(Icons.fitness_center),
                label: const Text(
                  "Calculate Metrics",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Result Cards
            if (_bmi != null)
              Column(
                children: [
                  _buildCard(
                    title: "BMI",
                    value: "${_bmi!.toStringAsFixed(2)} — ${_bmiStatus(_bmi!)}",
                    icon: Icons.monitor_weight,
                    cardColor: cardColor!,
                    borderColor: borderColor!,
                    textColor: textColor,
                    valueColor: valueColor,
                  ),
                  _buildCard(
                    title: "BMR",
                    value: "${_bmr!.toStringAsFixed(0)} kcal/day",
                    icon: Icons.local_fire_department,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    valueColor: valueColor,
                  ),
                  _buildCard(
                    title: "Body Fat %",
                    value: "${_bodyFat!.toStringAsFixed(1)}%",
                    icon: Icons.percent,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    valueColor: valueColor,
                  ),
                  _buildCard(
                    title: "Ideal Weight",
                    value: "${_idealWeight!.toStringAsFixed(1)} kg",
                    icon: Icons.monitor_weight_outlined,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    valueColor: valueColor,
                  ),
                  _buildCard(
                    title: "Daily Calories",
                    value: "${_dailyCalories!.toStringAsFixed(0)} kcal/day",
                    icon: Icons.restaurant,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    valueColor: valueColor,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    bool isDark,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.white,
      ),
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color valueColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
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
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade100,
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
