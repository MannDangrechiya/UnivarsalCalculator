import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import '../data/repositories/history_repository.dart';

class CalcController extends GetxController {
  // Basic calculator
  var basicDisplay = ''.obs;
  var basicResult = ''.obs;

  // Scientific calculator
  var scientificDisplay = ''.obs;
  var scientificResult = ''.obs;

  // History repositories
  late final HistoryRepository basicHistoryRepo;
  late final HistoryRepository scientificHistoryRepo;

  @override
  void onInit() {
    super.onInit();
    basicHistoryRepo = HistoryRepository(mode: 'basic');
    scientificHistoryRepo = HistoryRepository(mode: 'scientific');
  }

  void append(String value, {String type = 'basic'}) {
    final display = type == 'basic' ? basicDisplay : scientificDisplay;

    if (display.value == 'Error') display.value = '';

    if (_isOperator(value)) {
      if (display.value.isEmpty) return;
      if (_isOperator(display.value.characters.last)) return;
    }

    if (value == '.' && _isLastNumberHasDecimal(display.value)) return;

    display.value += value;
  }

  void clear({String type = 'basic'}) {
    if (type == 'basic') {
      basicDisplay.value = '';
      basicResult.value = '';
    } else {
      scientificDisplay.value = '';
      scientificResult.value = '';
    }
  }

  void backspace({String type = 'basic'}) {
    final display = type == 'basic' ? basicDisplay : scientificDisplay;
    if (display.value.isNotEmpty) {
      display.value = display.value.substring(0, display.value.length - 1);
    }
  }

  Future<void> calculate({String type = 'basic'}) async {
    try {
      final display = type == 'basic' ? basicDisplay : scientificDisplay;
      if (display.value.isEmpty) return;

      String expString = display.value
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('√', 'sqrt')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString());

      Parser parser = Parser();
      Expression exp = parser.parse(expString);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      final resultStr = _formatResult(eval);

      if (type == 'basic') {
        basicResult.value = resultStr;
        await basicHistoryRepo.addToHistory(display.value, resultStr);
      } else {
        scientificResult.value = resultStr;
        await scientificHistoryRepo.addToHistory(display.value, resultStr);
      }
    } catch (e) {
      if (type == 'basic') {
        basicResult.value = 'Error';
      } else {
        scientificResult.value = 'Error';
      }
    }
  }

  Future<void> scientificCalc(String func) async {
    final display = scientificDisplay;
    display.value += '$func(';

    try {
      double value =
          double.tryParse(display.value.replaceAll('$func(', '')) ?? 0.0;
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

      scientificResult.value = _formatResult(res);
      await scientificHistoryRepo.addToHistory(
        '$func($value)',
        scientificResult.value,
      );
      scientificDisplay.value = scientificResult.value;
    } catch (_) {
      scientificResult.value = 'Error';
    }
  }

  bool _isOperator(String value) =>
      ['+', '-', '*', '/', '×', '÷', '%', '^'].contains(value);

  bool _isLastNumberHasDecimal(String display) {
    final parts = display.split(RegExp(r'[\+\-\*/×÷%]'));
    final last = parts.isNotEmpty ? parts.last : '';
    return last.contains('.');
  }

  String _formatResult(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value
        .toStringAsFixed(6)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
