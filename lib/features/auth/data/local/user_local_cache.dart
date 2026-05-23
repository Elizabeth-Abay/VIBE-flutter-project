import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Persists the logged-in user on Web (SharedPreferences).
/// Mobile/desktop still use SQLite via [AuthRepository].
class UserLocalCache {
  UserLocalCache._();
  static const _key = 'cached_user_json';

  static Future<void> save(UserModel user) async {
    if (!kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
  }

  static Future<UserEntity?> read() async {
    if (!kIsWeb) return null;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> clear() async {
    if (!kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
