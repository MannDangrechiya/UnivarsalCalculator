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

    // Mode
    Map<double, int> freq = {};
    for (var n in numbers) {
      freq[n] = (freq[n] ?? 0) + 1;
    }
    double mode = freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Standard Deviation
    num sumSquaredDiffs = numbers
        .map((n) => pow(n - mean, 2))
        .reduce((a, b) => a + b);
    double stdDev = sqrt(sumSquaredDiffs / numbers.length);

    _mean = mean.toStringAsFixed(2);
    _median = median.toStringAsFixed(2);
    _mode = mode.toStringAsFixed(2);
    _stdDev = stdDev.toStringAsFixed(2);
  }

  Widget _buildNumberButton(String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentInput += label;
        });
      },
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Current input display
            Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              color: Colors.grey[200],
              child: Text(
                currentInput,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Entered numbers display
            if (numbers.isNotEmpty)
              Wrap(
                spacing: 8,
                children: numbers
                    .map((n) => Chip(label: Text(n.toString())))
                    .toList(),
              ),
            const SizedBox(height: 12),

            // Number pad
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  ...List.generate(9, (i) => _buildNumberButton('${i + 1}')),
                  _buildNumberButton('0'),
                  _buildNumberButton('.'),
                  ElevatedButton(
                    onPressed: _delete,
                    child: const Text('DEL', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addNumber,
                    child: const Text('Add Number'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearAll,
                    child: const Text('Clear All'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats display
            if (numbers.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mean: $_mean'),
                  Text('Median: $_median'),
                  Text('Mode: $_mode'),
                  Text('Std Dev: $_stdDev'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
