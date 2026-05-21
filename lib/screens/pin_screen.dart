import 'package:flutter/material.dart';

import '../../services/storage_service.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final controller = TextEditingController();

  Future<void> login() async {
    final data = await StorageService.load();

    if (data == null) return;

    final storedPin = data['pin'].toString().trim();
    final inputPin = controller.text.trim();

    if (inputPin == storedPin) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Неверный PIN")));
    }
  }

  Future<void> resetKey() async {
    await StorageService.clear();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Введите PIN")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "PIN"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Войти")),
            TextButton(onPressed: resetKey, child: const Text("Сбросить ключ")),
          ],
        ),
      ),
    );
  }
}
