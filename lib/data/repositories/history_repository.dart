import 'package:universal_calculator/services/history_service.dart';

import '../models/history_item.dart';

class HistoryRepository {
  final HistoryService _service;

  HistoryRepository({required String mode})
    : _service = HistoryService(
        collectionName: mode == 'scientific'
            ? 'scientific_history'
            : 'basic_history',
      );

  Future<void> addToHistory(String expression, String result) async {
    final item = HistoryItem(
      id: '', // will be assigned by Firestore
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );
    await _service.addHistory(item);
  }

  Stream<List<HistoryItem>> fetchHistoryStream() => _service.getHistory();

  Future<void> clearAllHistory() => _service.clearHistory();

  Future<void> deleteHistoryItem(String id) => _service.deleteHistoryItem(id);
}
