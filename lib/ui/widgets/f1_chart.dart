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

    double minX = points.first.x;
    double maxX = points.last.x;
    double minY = points.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    double maxY = points.map((p) => p.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
