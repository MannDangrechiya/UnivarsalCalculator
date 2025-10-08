import 'package:universal_calculator/services/history_service.dart';
import '../models/history_item.dart';

class HistoryRepository {
  final HistoryService _service = HistoryService();

  Future<void> addToHistory(String expression, String result) async {
    final item = HistoryItem(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );
    await _service.addHistory(item); // save to Firebase
  }

  // Stream for real-time updates
  Stream<List<HistoryItem>> fetchHistoryStream() {
    return _service.getHistory();
  }

  Future<void> clearAllHistory() async {
    await _service.clearHistory();
  }
}
