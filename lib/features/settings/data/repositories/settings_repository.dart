import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';

/// User preferences — cache-first via SQLite, synced to backend when online.
class SettingsRepository {
  SettingsRepository._internal();
  static final SettingsRepository instance = SettingsRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _cacheKey = 'app_settings';

  static const keyPushNotifications = 'push_notifications';
  static const keyDarkMode = 'dark_mode';
  static const keyProfilePrivate = 'profile_private';

  Future<Map<String, bool>> getSettings() async {
    final isStale = await _db.isCacheStale(
      _cacheKey,
      maxAge: const Duration(hours: 24),
    );
    if (!isStale) {
      final cached = await _readLocal();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/settings');
      final raw = response['settings'] as Map<String, dynamic>;
      final settings = _parseSettings(raw);
      await _writeLocal(settings);
      await _db.markCacheFresh(_cacheKey);
      return settings;
    } catch (_) {
      return _readLocal();
    }
  }

  Future<void> updateSetting(String key, bool value) async {
    await _setLocal(key, value);
    try {
      await _api.put('/settings', body: {key: value});
      await _db.markCacheFresh(_cacheKey);
    } catch (_) {}
  }

  Map<String, bool> _parseSettings(Map<String, dynamic> raw) {
    return {
      keyPushNotifications: raw[keyPushNotifications] == true,
      keyDarkMode: raw[keyDarkMode] == true,
      keyProfilePrivate: raw[keyProfilePrivate] == true,
    };
  }

  Future<Map<String, bool>> _readLocal() async {
    final db = await _db.database;
    final rows = await db.query('app_settings');
    if (rows.isEmpty) {
      return {
        keyPushNotifications: true,
        keyDarkMode: true,
        keyProfilePrivate: false,
      };
    }
    return {
      for (final r in rows)
        r['key'] as String: (r['value'] as String) == 'true',
    };
  }

  Future<void> _writeLocal(Map<String, bool> settings) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final entry in settings.entries) {
      batch.insert(
        'app_settings',
        {'key': entry.key, 'value': entry.value.toString()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> _setLocal(String key, bool value) async {
    final db = await _db.database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value.toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
