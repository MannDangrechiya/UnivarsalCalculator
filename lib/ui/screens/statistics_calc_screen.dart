import 'package:flutter/material.dart';
import 'dart:math';

class StatisticsCalcScreen extends StatefulWidget {
  const StatisticsCalcScreen({super.key});

  @override
  State<StatisticsCalcScreen> createState() => _StatisticsCalcScreenState();
}

class _StatisticsCalcScreenState extends State<StatisticsCalcScreen> {
  List<double> numbers = [];
  String currentInput = '';

  String _mean = '';
  String _median = '';
  String _mode = '';
  String _stdDev = '';

  void _addNumber() {
    if (currentInput.isEmpty) return;

    double? value = double.tryParse(currentInput);
    if (value != null) {
      setState(() {
        numbers.add(value);
        currentInput = '';
        _calculateStats();
      });
    }
  }

  void _delete() {
    if (currentInput.isNotEmpty) {
      setState(() {
        currentInput = currentInput.substring(0, currentInput.length - 1);
      });
    }
  }

  void _clearAll() {
    setState(() {
      numbers.clear();
      currentInput = '';
      _mean = '';
      _median = '';
      _mode = '';
      _stdDev = '';
    });
  }

  void _calculateStats() {
    if (numbers.isEmpty) return;

    // Mean
    double mean = numbers.reduce((a, b) => a + b) / numbers.length;

    // Median
    List<double> sorted = [...numbers]..sort();
    double median = sorted.length % 2 == 1
        ? sorted[sorted.length ~/ 2]
        : (sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) / 2;

    // Mode (handle multiple modes)
    Map<double, int> freq = {};
    for (var n in numbers) {
      freq[n] = (freq[n] ?? 0) + 1;
    }
    int maxFreq = freq.values.reduce(max);
    List<double> modes = freq.entries
        .where((e) => e.value == maxFreq)
        .map((e) => e.key)
        .toList();
    String modeText = modes.join(', ');

    // Standard Deviation
    num sumSquaredDiffs = numbers
        .map((n) => pow(n - mean, 2))
        .reduce((a, b) => a + b);
    double stdDev = sqrt(sumSquaredDiffs / numbers.length);

    setState(() {
      _mean = mean.toStringAsFixed(2);
      _median = median.toStringAsFixed(2);
      _mode = modeText;
      _stdDev = stdDev.toStringAsFixed(2);
    });
  }

  Widget _buildNumberButton(String label) {
    return ElevatedButton(
      onPressed: () => setState(() => currentInput += label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildStatText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics Calculator'),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Current input display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                currentInput.isEmpty ? '0' : currentInput,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Entered numbers display
            if (numbers.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: numbers
                      .map(
                        (n) => Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Chip(
                            label: Text(n.toString()),
                            backgroundColor: isDark
                                ? Colors.grey[700]
                                : Colors.grey[300],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            const SizedBox(height: 12),

            // Number pad
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  ...List.generate(9, (i) => _buildNumberButton('${i + 1}')),
                  _buildNumberButton('0'),
                  _buildNumberButton('.'),
                  ElevatedButton(
                    onPressed: _delete,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('DEL', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),

            // Stats display
            if (numbers.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatText('Mean', _mean),
                    _buildStatText('Median', _median),
                    _buildStatText('Mode', _mode),
                    _buildStatText('Std Dev', _stdDev),
                  ],
                ),
              ),

            const SizedBox(height: 60),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addNumber,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Add Number', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Clear All', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
