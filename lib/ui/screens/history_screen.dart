import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/history_item.dart';
import '../../data/repositories/history_repository.dart';

class HistoryScreen extends StatelessWidget {
  final String mode; // 'basic' or 'scientific'

  const HistoryScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final HistoryRepository repo = HistoryRepository(mode: mode);

    return Scaffold(
      appBar: AppBar(
        title: Text("${mode.capitalizeFirst} History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () async {
              await repo.clearAllHistory();
              Get.snackbar(
                'History',
                '${mode.capitalizeFirst} history cleared',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<HistoryItem>>(
        stream: repo.fetchHistoryStream(),
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
              return Dismissible(
                key: Key(item.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) async {
                  await repo.deleteHistoryItem(item.id);
                  Get.snackbar(
                    "Deleted",
                    "History item removed",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: ListTile(
                  title: Text(item.expression),
                  subtitle: Text(item.result),
                  trailing: Text(
                    "${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
