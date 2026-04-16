import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/f1_chart.dart';
import '../../controllers/graph_controller.dart';

class GraphingCalcScreen extends StatelessWidget {
  const GraphingCalcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GraphController controller = Get.put(GraphController());
    final TextEditingController inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Graph Calculator"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              inputController.clear();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // INPUT FIELD
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: "Enter equation (e.g. x^2, sin(x))",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                controller.updateExpression(value);
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                controller.updateExpression(inputController.text);
              },
              child: const Text("Plot Graph"),
            ),

            const SizedBox(height: 10),

            // GRAPH
            Expanded(
              child: Obx(() => F1Chart(points: controller.points.toList())),
            ),
          ],
        ),
      ),
    );
  }
}