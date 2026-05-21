import 'package:flutter/material.dart';

class WorkoutSelector extends StatefulWidget {
  final Function(List<String>) onSave;
  final List<dynamic> workouts;

  const WorkoutSelector({
    super.key,
    required this.onSave,
    required this.workouts,
  });

  @override
  State<WorkoutSelector> createState() => _WorkoutSelectorState();
}

class _WorkoutSelectorState extends State<WorkoutSelector> {
  final List<String> options = [
    "Бег",
    "Ходьба",
    "Пресс",
    "Отжимания",
    "Приседания",
    "Планка",
    "Велотренажёр",
  ];

  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    loadTodayWorkouts();
  }

  void loadTodayWorkouts() {
    final today = DateTime.now().toIso8601String().split("T")[0];

    final todayData = widget.workouts.firstWhere(
      (w) => w['date'] == today,
      orElse: () => null,
    );

    if (todayData != null) {
      selected = List<String>.from(todayData['items'] ?? []);
    }
  }

  void toggle(String item) {
    setState(() {
      if (selected.contains(item)) {
        selected.remove(item);
      } else {
        selected.add(item);
      }
    });

    widget.onSave(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Тренировки на сегодня",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          children: options.map((item) {
            final isSelected = selected.contains(item);

            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => toggle(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
