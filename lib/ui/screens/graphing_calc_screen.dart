import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class GraphingCalcScreen extends StatefulWidget {
  const GraphingCalcScreen({super.key});

  @override
  State<GraphingCalcScreen> createState() => _GraphingCalcScreenState();
}

class _GraphingCalcScreenState extends State<GraphingCalcScreen> {
  final TextEditingController controller = TextEditingController(
    text: "sin(x)",
  );
  List<FlSpot> points = [];

  void plotFunction() {
    final text = controller.text.trim().toLowerCase();
    if (text.isEmpty) return;

    try {
      // Prepare parser
      Parser parser = Parser();
      String exprStr = text.replaceAll('y=', '').replaceAll('^', '^');
      Expression exp = parser.parse(exprStr);
      ContextModel cm = ContextModel();

      // Generate points from -10 to +10
      List<FlSpot> tempPoints = [];
      for (double x = -10; x <= 10; x += 0.1) {
        cm.bindVariableName('x', Number(x));
        double y = exp.evaluate(EvaluationType.REAL, cm);
        if (y.isFinite) tempPoints.add(FlSpot(x, y));
      }

      setState(() => points = tempPoints);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid function!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Graphing Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter function (e.g. y=sin(x), x^2, e^x)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => plotFunction(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: plotFunction,
              icon: const Icon(Icons.show_chart),
              label: const Text("Plot Graph"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: points.isEmpty
                    ? const Center(child: Text("Enter a function to plot"))
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: LineChart(
                          LineChartData(
                            minX: -10,
                            maxX: 10,
                            minY: -10,
                            maxY: 10,
                            lineBarsData: [
                              LineChartBarData(
                                spots: points,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                              ),
                              // X-axis (y = 0)
                              LineChartBarData(
                                spots: List.generate(201, (i) {
                                  double x = -10 + i * 0.1;
                                  return FlSpot(x, 0);
                                }),
                                color: Colors.black,
                                barWidth: 1.2,
                              ),
                              // Y-axis (x = 0)
                              LineChartBarData(
                                spots: List.generate(201, (i) {
                                  double y = -10 + i * 0.1;
                                  return FlSpot(0, y);
                                }),
                                color: Colors.black,
                                barWidth: 1.2,
                              ),
                            ],
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              verticalInterval: 1,
                              horizontalInterval: 1,
                              getDrawingHorizontalLine: (_) => FlLine(
                                color: Colors.grey.withOpacity(0.3),
                                strokeWidth: 1,
                              ),
                              getDrawingVerticalLine: (_) => FlLine(
                                color: Colors.grey.withOpacity(0.3),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 2,
                                  reservedSize: 30,
                                  getTitlesWidget: (val, _) =>
                                      Text(val.toInt().toString()),
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 2,
                                  reservedSize: 35,
                                  getTitlesWidget: (val, _) =>
                                      Text(val.toInt().toString()),
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
