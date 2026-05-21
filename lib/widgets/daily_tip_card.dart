import 'package:flutter/material.dart';
import '../services/fitness_service.dart';

class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

class _DailyTipCardState extends State<DailyTipCard> {
  final FitnessService service = FitnessService();
  String tip = "Нажмите кнопку для совета";

  void loadTip() async {
    final result = await FitnessService.getDailyTip({});
    setState(() => tip = result);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              "💡 Совет дня",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Text(tip, textAlign: TextAlign.center),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: loadTip,
              child: const Text("Получить совет"),
            ),
          ],
        ),
      ),
    );
  }
}
