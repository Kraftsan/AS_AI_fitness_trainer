import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/openrouter_service.dart';
import '../../services/storage_service.dart';
import 'pin_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = TextEditingController();
  final pinController = TextEditingController();
  final repeatController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    try {
      final key = controller.text.trim();
      final pin = pinController.text.trim();
      final repeat = repeatController.text.trim();

      if (key.isEmpty) {
        showError("Введите API ключ");
        return;
      }

      if (pin.length < 4) {
        showError("PIN минимум 4 цифры");
        return;
      }

      if (pin != repeat) {
        showError("PIN не совпадает");
        return;
      }

      final provider = AuthService.detectProvider(key);

      if (provider == "unknown") {
        showError("Неверный ключ");
        return;
      }

      final valid = await OpenRouterService.validateKey(key);

      if (!valid) {
        showError("Ключ невалидный");
        return;
      }

      final data = {"provider": provider, "api_key": key, "pin": pin};

      await StorageService.save(data);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PinScreen()),
      );
    } catch (e) {
      showError("Ошибка: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "API KEY"),
            ),
            TextField(
              controller: pinController,
              decoration: const InputDecoration(labelText: "PIN"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repeatController,
              decoration: const InputDecoration(labelText: "Повтор PIN"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : register,
              child: const Text("Создать аккаунт"),
            ),
          ],
        ),
      ),
    );
  }
}
