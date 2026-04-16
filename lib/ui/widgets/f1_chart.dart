import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class F1Chart extends StatelessWidget {
  final List<FlSpot> points;

  const F1Chart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(child: Text("No data"));
    }

    // Safe min/max calculation
    final minX = points.first.x;
    final maxX = points.last.x;

    final minY = points
        .map((p) => p.y)
        .reduce((a, b) => a < b ? a : b);

    final maxY = points
        .map((p) => p.y)
        .reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,

        gridData: const FlGridData(show: true),

        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),

        borderData: FlBorderData(show: true),

        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            barWidth: 3,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}