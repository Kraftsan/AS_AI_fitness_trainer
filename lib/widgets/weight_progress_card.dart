import 'package:flutter/material.dart';

class WeightProgressCard extends StatelessWidget {
  const WeightProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              "📊 Прогресс веса",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Expanded(
              child: Center(child: Text("Здесь будет график (fl_chart)")),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("➕ Вес")),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text("🎯 Цель"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
