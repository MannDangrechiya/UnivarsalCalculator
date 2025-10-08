import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_calculator/data/models/history_item.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addHistory(HistoryItem item) async {
    await _firestore.collection('history').add(item.toMap());
  }

  Stream<List<HistoryItem>> getHistory() {
    return _firestore
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HistoryItem.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> clearHistory() async {
    final snapshot = await _firestore.collection('history').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
