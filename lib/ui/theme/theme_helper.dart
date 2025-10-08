import 'package:flutter/material.dart';

class ThemeHelper {
  static Color getButtonColor(BuildContext context, {bool isAction = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isAction) {
      return isDark ? Colors.redAccent.shade200 : Colors.red;
    }
    return isDark ? Colors.deepPurple.shade400 : Colors.deepPurple;
  }

  static Color getButtonTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.white;
  }

  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey.shade900 : Colors.grey.shade200;
  }

  static Color getContainerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey.shade800 : Colors.grey.shade100;
  }
}
