import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/history_item.dart';
import '../../data/repositories/history_repository.dart';

class HistorySheet extends StatelessWidget {
  HistorySheet({super.key});
  final HistoryRepository repo = HistoryRepository();

  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  const Text(
                    "History",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await repo.clearAllHistory();
                      Get.back();
                      Get.snackbar(
                        "History Cleared",
                        "All calculation history has been removed",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      title: Text(item.expression),
                      subtitle: Text(item.result),
                      trailing: Text(
                        "${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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
