import 'package:math_expressions/math_expressions.dart';

class Point {
  final double x;
  final double y;
  Point(this.x, this.y);
}

class FunctionParser {
  static List<Point> parse(String input) {
    try {
      // Clean input (remove 'y=' or 'Y=' if present)
      input = input.toLowerCase().replaceAll('y=', '').trim();

      final parser = Parser();
      final exp = parser.parse(input);
      final cm = ContextModel();

      List<Point> points = [];
      for (double x = -10; x <= 10; x += 0.1) {
        cm.bindVariableName('x', Number(x));
        double y = exp.evaluate(EvaluationType.REAL, cm);
        if (y.isFinite) {
          points.add(Point(x, y));
        }
      }
      return points;
    } catch (e) {
      return [];
    }
  }
}
