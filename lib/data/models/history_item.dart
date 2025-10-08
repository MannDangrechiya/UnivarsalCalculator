import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryItem {
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryItem({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {'expression': expression, 'result': result, 'timestamp': timestamp};
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      expression: map['expression'] ?? '',
      result: map['result'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
