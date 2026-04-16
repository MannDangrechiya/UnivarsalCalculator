import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class GraphController extends GetxController {
  var expression = ''.obs;
  var points = <FlSpot>[].obs;

  final Parser parser = Parser();

  void updateExpression(String exp) {
    expression.value = exp;
    generateGraph();
  }

  void generateGraph() {
    try {
      Expression exp = parser.parse(expression.value);
      ContextModel cm = ContextModel();

      List<FlSpot> tempPoints = [];

      for (double x = -10; x <= 10; x += 0.5) {
        cm.bindVariable(Variable('x'), Number(x));

        double y = exp.evaluate(EvaluationType.REAL, cm);

        if (y.isFinite) {
          tempPoints.add(FlSpot(x, y));
        }
      }

      points.value = tempPoints;
    } catch (e) {
      points.clear();
    }
  }

  void clear() {
    expression.value = '';
    points.clear();
  }
}