import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userVibesProvider = StateNotifierProvider<UserVibesNotifier, Map<String, String>>((ref) {
  return UserVibesNotifier();
});

class UserVibesNotifier extends StateNotifier<Map<String, String>> {
  final _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_vibes_map';

  UserVibesNotifier() : super({}) {
    loadVibes();
  }

  Future<void> loadVibes() async {
    try {
      final data = await _storage.read(key: _storageKey);
      if (data != null) {
        final decoded = jsonDecode(data) as Map<String, dynamic>;
        state = decoded.map((key, value) => MapEntry(key, value.toString()));
      } else {
        // Defaults if none set yet
        state = {
          'Programming': 'Love',
          'Robotics': 'Love',
        };
      }
    } catch (_) {
      state = {};
    }
  }

  Future<void> saveVibes(Map<String, String> vibes) async {
    state = vibes;
    await _storage.write(key: _storageKey, value: jsonEncode(vibes));
  }

  Future<void> clearVibes() async {
    state = {};
    await _storage.delete(key: _storageKey);
  }
}
