import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_calculator/data/models/history_item.dart';

class HistoryService {
  final String collectionName;
  final _firestore = FirebaseFirestore.instance;

  HistoryService({required this.collectionName});

  Future<void> addHistory(HistoryItem item) async {
    await _firestore.collection(collectionName).add(item.toMap());
  }

  Stream<List<HistoryItem>> getHistory() {
    return _firestore
        .collection(collectionName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HistoryItem.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> clearHistory() async {
    final snapshot = await _firestore.collection(collectionName).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteHistoryItem(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
