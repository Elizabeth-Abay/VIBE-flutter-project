import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton that owns the SQLite connection and all table schemas.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;
  static const int _dbVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (kIsWeb) {
      _database = await _openInMemory();
      return _database!;
    }

    try {
      _database = await _initFileDatabase();
    } catch (e) {
      debugPrint('Vibe DB: opening in-memory ($e)');
      _database = await _openInMemory();
    }
    return _database!;
  }

  Future<Database> _openInMemory() => openDatabase(
        inMemoryDatabasePath,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

  Future<Database> _initFileDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vibe.db');
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createUsersTable);
    await db.execute(_createPostsTable);
    await db.execute(_createConnectionsTable);
    await db.execute(_createNotificationsTable);
    await db.execute(_createConnectionRequestsTable);
    await db.execute(_createRecommendedUsersTable);
    await db.execute(_createConversationsTable);
    await db.execute(_createMessagesTable);
    await db.execute(_createAppSettingsTable);
    await db.execute(_createCacheMetaTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN vibes TEXT');
      await db.execute('ALTER TABLE posts ADD COLUMN user_name TEXT');
      await db.execute(
        'ALTER TABLE posts ADD COLUMN user_profile_image_url TEXT',
      );
      await db.execute('ALTER TABLE connections ADD COLUMN target_name TEXT');
      await db.execute(
        'ALTER TABLE connections ADD COLUMN target_username TEXT',
      );
      await db.execute(
        'ALTER TABLE connections ADD COLUMN target_avatar TEXT',
      );
      await db.execute(
        'ALTER TABLE notifications ADD COLUMN requester_id TEXT',
      );
      await db.execute('ALTER TABLE notifications ADD COLUMN username TEXT');
      await db.execute(
        'ALTER TABLE notifications ADD COLUMN profile_image_url TEXT',
      );
      await db.execute(_createConnectionRequestsTable);
      await db.execute(_createRecommendedUsersTable);
      await db.execute(_createConversationsTable);
      await db.execute(_createMessagesTable);
      await db.execute(_createAppSettingsTable);
    }
  }

  static const _createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id          TEXT PRIMARY KEY,
      username    TEXT NOT NULL,
      email       TEXT NOT NULL,
      bio         TEXT,
      avatar_url  TEXT,
      vibes       TEXT,
      created_at  TEXT NOT NULL
    )
  ''';

  static const _createPostsTable = '''
    CREATE TABLE IF NOT EXISTS posts (
      id                       TEXT PRIMARY KEY,
      user_id                  TEXT NOT NULL,
      title                    TEXT NOT NULL,
      description              TEXT NOT NULL,
      image_url                TEXT,
      tags                     TEXT,
      category                 TEXT,
      user_name                TEXT,
      user_profile_image_url   TEXT,
      created_at               TEXT NOT NULL,
      cached_at                TEXT NOT NULL
    )
  ''';

  static const _createConnectionsTable = '''
    CREATE TABLE IF NOT EXISTS connections (
      id              TEXT PRIMARY KEY,
      user_id         TEXT NOT NULL,
      target_id       TEXT NOT NULL,
      status          TEXT NOT NULL,
      target_name     TEXT,
      target_username TEXT,
      target_avatar   TEXT,
      created_at      TEXT NOT NULL
    )
  ''';

  static const _createNotificationsTable = '''
    CREATE TABLE IF NOT EXISTS notifications (
      id                  TEXT PRIMARY KEY,
      type                TEXT NOT NULL,
      message             TEXT NOT NULL,
      is_read             INTEGER NOT NULL DEFAULT 0,
      requester_id        TEXT,
      username            TEXT,
      profile_image_url   TEXT,
      created_at          TEXT NOT NULL,
      cached_at           TEXT NOT NULL
    )
  ''';

  static const _createConnectionRequestsTable = '''
    CREATE TABLE IF NOT EXISTS connection_requests (
      requester_id        TEXT PRIMARY KEY,
      name                TEXT NOT NULL,
      username            TEXT NOT NULL,
      profile_image_url   TEXT,
      created_at          TEXT NOT NULL,
      cached_at           TEXT NOT NULL
    )
  ''';

  static const _createRecommendedUsersTable = '''
    CREATE TABLE IF NOT EXISTS recommended_users (
      user_id       TEXT PRIMARY KEY,
      display_name  TEXT NOT NULL,
      username      TEXT NOT NULL,
      avatar_url    TEXT,
      cached_at     TEXT NOT NULL
    )
  ''';

  static const _createConversationsTable = '''
    CREATE TABLE IF NOT EXISTS conversations (
      id                  TEXT PRIMARY KEY,
      participant_id      TEXT NOT NULL,
      participant_name    TEXT NOT NULL,
      participant_avatar  TEXT,
      last_message        TEXT,
      updated_at          TEXT NOT NULL,
      cached_at           TEXT NOT NULL
    )
  ''';

  static const _createMessagesTable = '''
    CREATE TABLE IF NOT EXISTS messages (
      id                TEXT PRIMARY KEY,
      conversation_id   TEXT NOT NULL,
      sender_id         TEXT NOT NULL,
      text              TEXT NOT NULL,
      created_at        TEXT NOT NULL,
      is_saved          INTEGER NOT NULL DEFAULT 0,
      cached_at         TEXT NOT NULL
    )
  ''';

  static const _createAppSettingsTable = '''
    CREATE TABLE IF NOT EXISTS app_settings (
      key     TEXT PRIMARY KEY,
      value   TEXT NOT NULL
    )
  ''';

  static const _createCacheMetaTable = '''
    CREATE TABLE IF NOT EXISTS cache_meta (
      key         TEXT PRIMARY KEY,
      fetched_at  TEXT NOT NULL
    )
  ''';

  Future<bool> isCacheStale(
    String key, {
    Duration maxAge = const Duration(minutes: 5),
  }) async {
    try {
      final db = await database;
      final rows = await db.query(
        'cache_meta',
        where: 'key = ?',
        whereArgs: [key],
      );
      if (rows.isEmpty) return true;
      final fetchedAt = DateTime.parse(rows.first['fetched_at'] as String);
      return DateTime.now().difference(fetchedAt) > maxAge;
    } catch (_) {
      return true;
    }
  }

  Future<void> markCacheFresh(String key) async {
    try {
      final db = await database;
      await db.insert(
        'cache_meta',
        {'key': key, 'fetched_at': DateTime.now().toIso8601String()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}
  }

  Future<void> invalidateCache(String key) async {
    try {
      final db = await database;
      await db.delete('cache_meta', where: 'key = ?', whereArgs: [key]);
    } catch (_) {}
  }

  Future<void> clearTable(String table) async {
    try {
      final db = await database;
      await db.delete(table);
    } catch (_) {}
  }

  Future<void> clearAllUserData() async {
    for (final table in [
      'users',
      'posts',
      'connections',
      'notifications',
      'connection_requests',
      'recommended_users',
      'conversations',
      'messages',
      'app_settings',
      'cache_meta',
    ]) {
      await clearTable(table);
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
