import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:universal_calculator/data/repositories/history_repository.dart';
import 'dart:math' as math;

class CalcController extends GetxController {
  var display = ''.obs;
  var result = ''.obs;

  final HistoryRepository _historyRepo = HistoryRepository();

  /// Append value to display
  void append(String value) {
    if (display.value == 'Error') display.value = '';
    display.value += value;
  }

  /// Clear both display and result
  void clear() {
    display.value = '';
    result.value = '';
  }

  /// Delete last character
  void delete() {
    if (display.value.isNotEmpty) {
      display.value = display.value.substring(0, display.value.length - 1);
    }
  }

  /// Reset everything (call this when switching calculators)
  void reset() {
    clear();
  }

  /// Basic calculation
  Future<void> calculate() async {
    try {
      String expString = display.value
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('√', 'sqrt')
          .replaceAll('^', '^')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString());

      Parser parser = Parser();
      Expression exp = parser.parse(expString);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      result.value = eval.toString();
      await _historyRepo.addToHistory(display.value, result.value);
    } catch (e) {
      result.value = 'Error';
    }
  }

  /// Scientific calculation
  Future<void> scientificCalc(String func) async {
    try {
      double value = double.tryParse(display.value) ?? 0.0;
      double res = 0.0;

      switch (func) {
        case 'sin':
          res = math.sin(value);
          break;
        case 'cos':
          res = math.cos(value);
          break;
        case 'tan':
          res = math.tan(value);
          break;
        case 'log':
          res = math.log(value);
          break;
        case '√':
          res = math.sqrt(value);
          break;
        default:
          res = value;
      }

      result.value = res.toString();
      await _historyRepo.addToHistory('$func($value)', result.value);
    } catch (e) {
      result.value = 'Error';
    }
  }
}
