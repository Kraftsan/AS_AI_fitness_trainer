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

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonString);
      return;
    }

    final file = await _getFile();
    await file.writeAsString(jsonString);
  }

  // -------- LOAD --------
  static Future<Map<String, dynamic>?> load() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final data = prefs.getString(_key);
        if (data == null) return null;
        return jsonDecode(data);
      }

      final file = await _getFile();
      if (!await file.exists()) return null;

      final text = await file.readAsString();
      return jsonDecode(text);
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
