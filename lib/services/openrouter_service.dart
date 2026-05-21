import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static Future<bool> validateKey(String apiKey) async {
    try {
      final response = await http
          .get(
            Uri.parse("https://openrouter.ai/api/v1/models"),
            headers: {"Authorization": "Bearer $apiKey"},
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<String> askTrainer({
    required String apiKey,
    required String question,
    required Map<String, dynamic> profile,
    Map<String, dynamic>? measurements,
  }) async {
    try {
      //
      String context = "";

      if (profile['first_name'] != null) {
        context += "Имя: ${profile['first_name']}\n";
      }

      if (profile['height'] != null) {
        context += "Рост: ${profile['height']} см\n";
      }

      if (profile['weight'] != null) {
        context += "Вес: ${profile['weight']} кг\n";
      }

      if (measurements?['target_weight'] != null) {
        context += "Цель: ${measurements!['target_weight']} кг\n";
      }

      // 📊 динамика веса (если есть история)
      final history = measurements?['weight_history'];
      if (history != null && history is List && history.length >= 2) {
        final last = history.last['value'];
        final prev = history[history.length - 2]['value'];
        final change = last - prev;

        if (change != 0) {
          context += "Изменение веса: ${change > 0 ? '+$change' : change} кг\n";
        }
      }

      const systemPrompt = """
Ты дружелюбный фитнес-тренер.

Правила:
- отвечай по-русски
- максимум 3–4 предложения
- 1–2 конкретных совета
- будь мотивирующим, мягким
- без длинных лекций
""";

      final response = await http
          .post(
            Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
            headers: {
              "Authorization": "Bearer $apiKey",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "model": "deepseek/deepseek-chat-v3-0324",
              "messages": [
                {"role": "system", "content": systemPrompt},
                {"role": "user", "content": "$context\nВопрос: $question"},
              ],
              "temperature": 0.8,
              "max_tokens": 300,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        return "Ошибка API: ${response.statusCode}";
      }

      final data = jsonDecode(response.body);

      String answer = data['choices'][0]['message']['content'] ?? "Нет ответа";

      // 🧼 защита от обрезанного текста
      if (answer.isNotEmpty &&
          !answer.endsWith('.') &&
          !answer.endsWith('!') &&
          !answer.endsWith('?')) {
        answer += "...";
      }

      return answer;
    } catch (e) {
      return "Ошибка сети или API";
    }
  }
}
