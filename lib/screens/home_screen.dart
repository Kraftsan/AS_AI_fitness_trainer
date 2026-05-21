import 'package:flutter/material.dart';
import '../widgets/workout_selector.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  Map<String, dynamic> userData = {};
  List<String> workouts = [];
  List<String> selectedWorkouts = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // LOAD
  void loadUser() async {
    final data = await StorageService.load();

    if (data == null) return;

    setState(() {
      userData = data;

      final profile = data['profile'] ?? {};

      nameController.text = profile['first_name'] ?? "";
      heightController.text = (profile['height'] ?? "").toString();
      weightController.text = (profile['weight'] ?? "").toString();

      workouts = List<String>.from(data['workouts'] ?? []);
    });
  }

  // SAVE PROFILE
  void saveUser() async {
    userData['profile'] = {
      "first_name": nameController.text,
      "height": int.tryParse(heightController.text) ?? 0,
      "weight": double.tryParse(weightController.text) ?? 0,
    };

    await StorageService.save(userData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Сохранено")));
  }

  // SAVE WORKOUTS
  void saveWorkouts(List<String> selected) async {
    userData['workouts'] = selected;

    await StorageService.save(userData);

    setState(() {
      workouts = selected;
      selectedWorkouts = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Fitness Trainer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Имя"),
            ),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: "Рост"),
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: "Вес"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: saveUser, child: const Text("Сохранить")),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: WorkoutSelector(
                  initialItems: workouts,
                  onSave: saveWorkouts,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
