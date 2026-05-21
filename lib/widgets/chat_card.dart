import 'package:flutter/material.dart';
import '../services/openrouter_service.dart';
import '../services/storage_service.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({super.key});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final TextEditingController controller = TextEditingController();

  final List<Map<String, String>> messages = [
    {"role": "assistant", "text": "Привет! Я твой AI тренер"},
  ];

  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // загрузка пользователя из JSON
  void loadUser() async {
    final data = await StorageService.load();

    setState(() {
      userData = data ?? {};
    });
  }

  // отправка сообщения в AI
  void sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    controller.clear();

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    final response = await OpenRouterService.askTrainer(
      apiKey: userData['api_key'] ?? "",
      question: text,
      profile: userData['profile'] ?? {},
      measurements: userData['measurements'] ?? {},
    );

    setState(() {
      messages.add({"role": "assistant", "text": response});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Чат с тренером",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // сообщения
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Align(
                  alignment: msg["role"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg["role"] == "user"
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["text"] ?? ""),
                  ),
                );
              },
            ),
          ),

          // input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Спросите тренера...",
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}
