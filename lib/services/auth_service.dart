import 'dart:math';

class AuthService {
  static String detectProvider(String key) {
    if (key.startsWith("sk-or-v1-")) {
      return "openrouter";
    }

    if (key.startsWith("sk-or-vv-")) {
      return "vsegpt";
    }

    return "unknown";
  }

  static bool isValidPin(String pin) {
    final trimmed = pin.trim();

    // только цифры + минимум 4 символа
    final isDigits = int.tryParse(trimmed) != null;
    return trimmed.length >= 4 && isDigits;
  }
}
