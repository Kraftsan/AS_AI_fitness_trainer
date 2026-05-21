import 'package:flutter/material.dart';

class WorkoutSelector extends StatefulWidget {
  final Function(List<String>) onSave;
  final List<String> initialItems;

  const WorkoutSelector({
    super.key,
    required this.onSave,
    required this.initialItems,
  });

  @override
  State<WorkoutSelector> createState() => _WorkoutSelectorState();
}

class _WorkoutSelectorState extends State<WorkoutSelector> {
  final TextEditingController controller = TextEditingController();

  late List<String> workouts;

  @override
  void initState() {
    super.initState();
    workouts = List.from(widget.initialItems);
  }

  // CREATE
  void addWorkout() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      workouts.add(text);
      controller.clear();
    });

    widget.onSave(workouts);
  }

  // DELETE
  void deleteWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });

    widget.onSave(workouts);
  }

  // UPDATE
  void editWorkout(int index) {
    final editController = TextEditingController(text: workouts[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Редактировать тренировку"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: "Новое название"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () {
                final newText = editController.text.trim();
                if (newText.isEmpty) return;

                setState(() {
                  workouts[index] = newText;
                });

                widget.onSave(workouts);
                Navigator.pop(context);
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
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

        // INPUT + ADD
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Добавьте тренировку",
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: addWorkout),
          ],
        ),

        const SizedBox(height: 10),

        // LIST (READ)
        Expanded(
          child: ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(workouts[index]),

                  // ACTIONS (CRUD)
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editWorkout(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteWorkout(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
