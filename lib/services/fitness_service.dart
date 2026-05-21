import 'storage_service.dart';

class FitnessService {
  static Future<String> getDailyTip(Map<String, dynamic> user) async {
    final data = await StorageService.load() ?? {};

    final today = DateTime.now().toIso8601String().split("T")[0];

    final lastDate = data['daily_tip']?['date'];

    // 🟡 если уже был сегодня — не дергаем AI
    if (lastDate == today && data['daily_tip']?['text'] != null) {
      return data['daily_tip']['text'];
    }

    // 🤖 простой AI-совет (можно потом заменить на OpenRouter)
    final tips = [
      "Пей больше воды 💧",
      "Добавь 20 минут ходьбы 🚶",
      "Сделай лёгкую разминку сегодня",
      "Сконцентрируйся на технике, не на весе",
      "Белок после тренировки обязателен 💪",
    ];

    final tip = (tips..shuffle()).first;

    data['daily_tip'] = {"date": today, "text": tip};

    await StorageService.save(data);

    return tip;
  }
}
