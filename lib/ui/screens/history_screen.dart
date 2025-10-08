import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/history_item.dart';
import '../../data/repositories/history_repository.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final HistoryRepository _repo = HistoryRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await _repo.clearAllHistory();
              Get.snackbar(
                'History',
                'All history cleared',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<HistoryItem>>(
        stream: _repo.fetchHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data ?? [];
          if (history.isEmpty) {
            return const Center(child: Text("No history yet"));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text(item.expression),
                subtitle: Text(item.result),
                trailing: Text(
                  "${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
