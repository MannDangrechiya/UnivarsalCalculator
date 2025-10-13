import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class GraphingCalcScreen extends StatefulWidget {
  const GraphingCalcScreen({super.key});

  @override
  State<GraphingCalcScreen> createState() => _GraphingCalcScreenState();
}

class _GraphingCalcScreenState extends State<GraphingCalcScreen> {
  final List<TextEditingController> functionControllers = [
    TextEditingController(text: "sin(x)"),
  ];

  List<List<FlSpot>> allPoints = [];
  double minX = -10, maxX = 10;
  double minY = -10, maxY = 10;

  void plotFunctions() {
    List<List<FlSpot>> tempAllPoints = [];
    double tempMinY = double.infinity;
    double tempMaxY = double.negativeInfinity;

    for (var controller in functionControllers) {
      final text = controller.text.trim();
      if (text.isEmpty) continue;

      try {
        Parser parser = Parser();
        Expression exp = parser.parse(text.replaceAll('y=', ''));
        ContextModel cm = ContextModel();

        List<FlSpot> points = [];
        for (double x = minX; x <= maxX; x += 0.05) {
          cm.bindVariableName('x', Number(x));
          double y = exp.evaluate(EvaluationType.REAL, cm);
          if (y.isFinite) {
            points.add(FlSpot(x, y));
            tempMinY = y < tempMinY ? y : tempMinY;
            tempMaxY = y > tempMaxY ? y : tempMaxY;
          }
        }

        if (points.isNotEmpty) tempAllPoints.add(points);
      } catch (_) {
        _showError("Invalid function: $text");
      }
    }

    if (tempAllPoints.isNotEmpty) {
      setState(() {
        allPoints = tempAllPoints;
        minY = tempMinY - 1;
        maxY = tempMaxY + 1;
      });
    }
  }

  void addFunctionField() {
    setState(() {
      functionControllers.add(TextEditingController());
    });
  }

  void removeFunctionField(int index) {
    if (functionControllers.length > 1) {
      setState(() {
        functionControllers.removeAt(index);
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    for (var c in functionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Graphing Calculator"),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: functionControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: functionControllers[index],
                            decoration: InputDecoration(
                              labelText: "y = f(x) #${index + 1}",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            onSubmitted: (_) => plotFunctions(),
                          ),
                        ),
                        if (functionControllers.length > 1)
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed: () => removeFunctionField(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: addFunctionField,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Function"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: plotFunctions,
                  icon: const Icon(Icons.show_chart),
                  label: const Text("Plot Graph"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: allPoints.isEmpty
                    ? const Center(child: Text("Enter functions to plot"))
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: LineChart(
                          LineChartData(
                            minX: minX,
                            maxX: maxX,
                            minY: minY,
                            maxY: maxY,
                            gridData: FlGridData(
                              show: true,
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
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: (maxY - minY) / 10,
                                  reservedSize: 35,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: (maxX - minX) / 10,
                                  reservedSize: 30,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              ...allPoints.asMap().entries.map((entry) {
                                int idx = entry.key;
                                List<FlSpot> points = entry.value;
                                return LineChartBarData(
                                  spots: points,
                                  isCurved: true,
                                  barWidth: 2,
                                  dotData: FlDotData(show: false),
                                  color: Colors
                                      .primaries[idx % Colors.primaries.length],
                                );
                              }),
                              // X-axis
                              LineChartBarData(
                                spots: List.generate(
                                  201,
                                  (i) =>
                                      FlSpot(minX + i * (maxX - minX) / 200, 0),
                                ),
                                color: isDark ? Colors.white : Colors.black,
                                barWidth: 1,
                              ),
                              // Y-axis
                              LineChartBarData(
                                spots: List.generate(
                                  201,
                                  (i) =>
                                      FlSpot(0, minY + i * (maxY - minY) / 200),
                                ),
                                color: isDark ? Colors.white : Colors.black,
                                barWidth: 1,
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.grey.withOpacity(0.7),
                              ),
                            ),
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
