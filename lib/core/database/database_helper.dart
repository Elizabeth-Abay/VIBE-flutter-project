import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton that owns the SQLite connection and all table schemas.
/// Every repository accesses the DB through [DatabaseHelper.instance].
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // ─── Init ────────────────────────────────────────────────────────────────

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vibe.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createUsersTable);
    await db.execute(_createPostsTable);
    await db.execute(_createConnectionsTable);
    await db.execute(_createNotificationsTable);
    await db.execute(_createCacheMetaTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migration logic goes here.
  }

  // ─── Table DDL ───────────────────────────────────────────────────────────

  static const _createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id          TEXT PRIMARY KEY,
      username    TEXT NOT NULL,
      email       TEXT NOT NULL,
      bio         TEXT,
      avatar_url  TEXT,
      created_at  TEXT NOT NULL
    )
  ''';

  static const _createPostsTable = '''
    CREATE TABLE IF NOT EXISTS posts (
      id          TEXT PRIMARY KEY,
      user_id     TEXT NOT NULL,
      title       TEXT NOT NULL,
      description TEXT NOT NULL,
      image_url   TEXT,
      tags        TEXT,
      category    TEXT,
      created_at  TEXT NOT NULL,
      cached_at   TEXT NOT NULL
    )
  ''';

  static const _createConnectionsTable = '''
    CREATE TABLE IF NOT EXISTS connections (
      id          TEXT PRIMARY KEY,
      user_id     TEXT NOT NULL,
      target_id   TEXT NOT NULL,
      status      TEXT NOT NULL,
      created_at  TEXT NOT NULL
    )
  ''';

  static const _createNotificationsTable = '''
    CREATE TABLE IF NOT EXISTS notifications (
      id          TEXT PRIMARY KEY,
      type        TEXT NOT NULL,
      message     TEXT NOT NULL,
      is_read     INTEGER NOT NULL DEFAULT 0,
      created_at  TEXT NOT NULL,
      cached_at   TEXT NOT NULL
    )
  ''';

  /// Tracks when each data type was last fetched from the network.
  /// Key examples: 'posts', 'notifications', 'connections'.
  static const _createCacheMetaTable = '''
    CREATE TABLE IF NOT EXISTS cache_meta (
      key         TEXT PRIMARY KEY,
      fetched_at  TEXT NOT NULL
    )
  ''';

  // ─── Cache-staleness helpers ─────────────────────────────────────────────

  /// Returns true if the cache for [key] is older than [maxAge] (or missing).
  Future<bool> isCacheStale(String key,
      {Duration maxAge = const Duration(minutes: 5)}) async {
    final db = await database;
    final rows = await db.query(
      'cache_meta',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (rows.isEmpty) return true;
    final fetchedAt = DateTime.parse(rows.first['fetched_at'] as String);
    return DateTime.now().difference(fetchedAt) > maxAge;
  }

  /// Records a successful network fetch for [key].
  Future<void> markCacheFresh(String key) async {
    final db = await database;
    await db.insert(
      'cache_meta',
      {'key': key, 'fetched_at': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Clears the cache timestamp so the next read forces a network call.
  Future<void> invalidateCache(String key) async {
    final db = await database;
    await db.delete('cache_meta', where: 'key = ?', whereArgs: [key]);
  }

  // ─── Generic helpers ─────────────────────────────────────────────────────

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
