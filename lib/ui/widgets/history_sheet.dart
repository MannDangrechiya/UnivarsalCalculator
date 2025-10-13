import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/history_item.dart';
import '../../data/repositories/history_repository.dart';

class HistorySheet extends StatelessWidget {
  final String mode; // 'basic' or 'scientific'

  const HistorySheet({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final HistoryRepository repo = HistoryRepository(mode: mode);

    return StreamBuilder<List<HistoryItem>>(
      stream: repo.fetchHistoryStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final history = snapshot.data ?? [];
        if (history.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No history yet")),
          );
        }

        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header with Clear All button
              Row(
                children: [
                  Text(
                    mode == 'scientific'
                        ? "Scientific History"
                        : "Basic History",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await repo.clearAllHistory();
                      Get.back();
                      Get.snackbar(
                        "History Cleared",
                        mode == 'scientific'
                            ? "Scientific history cleared"
                            : "Basic history cleared",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                ],
              ),
              const Divider(),
              // List of history items with swipe-to-delete
              Expanded(
                child: ListView.builder(
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
