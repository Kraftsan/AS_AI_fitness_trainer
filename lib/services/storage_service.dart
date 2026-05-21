import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _key = 'user_data';

  // -------- SAVE --------
  static Future<void> save(Map<String, dynamic> data) async {
    final jsonString = jsonEncode(data);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonString);

    // принудительный flush через повторное чтение
    await prefs.reload();
  }

  // -------- LOAD --------
  static Future<Map<String, dynamic>?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_key);

      if (data == null || data.isEmpty) return null;

      final decoded = jsonDecode(data);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      return null;
    }
  }

  // -------- CLEAR --------
  static Future<void> clear() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
      return;
    }

    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  // -------- FILE (ONLY NON-WEB) --------
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_data.json');
  }
}
