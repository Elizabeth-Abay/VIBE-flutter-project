import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entity/connected_user.dart';
import '../../domain/entity/sent_request_user.dart';

// ─── Connection Model ────────────────────────────

class ConnectionModel {
  final String id;
  final String userId;
  final String targetId;
  final String status; // 'connected' | 'pending' | 'cancelled'
  final String createdAt;

  const ConnectionModel({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.status,
    required this.createdAt,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) =>
      ConnectionModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        targetId: json['target_id'] as String,
        status: json['status'] as String,
        createdAt: json['created_at'] as String,
      );

  factory ConnectionModel.fromDb(Map<String, dynamic> row) => ConnectionModel(
    id: row['id'] as String,
    userId: row['user_id'] as String,
    targetId: row['target_id'] as String,
    status: row['status'] as String,
    createdAt: row['created_at'] as String,
  );

  Map<String, dynamic> toDb() => {
    'id': id,
    'user_id': userId,
    'target_id': targetId,
    'status': status,
    'created_at': createdAt,
  };
}

// ─── Connection Repository ───────────────────────────────────────────────────

/// Cache-first repository for all connection actions.
class ConnectionRepository {
  ConnectionRepository._internal();
  static final ConnectionRepository instance = ConnectionRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _connectedKey = 'connections_connected';
  static const _sentKey = 'connections_sent';

  // ── Fetch Connected Users (cache-first) ───────────────────────────────────

  Future<List<ConnectedUser>> fetchConnectedUsers() async {
    final isStale = await _db.isCacheStale(_connectedKey);
    if (!isStale) {
      final cached = await _getCachedConnectedUsers();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/connections/connected');
      final List<dynamic> raw = response['connections'] as List<dynamic>;
      final users = raw.map((j) {
        final m = j as Map<String, dynamic>;
        return ConnectedUser(
          userId: m['user_id'] as String,
          name: m['display_name'] as String,
          username: m['username'] as String,
          profileImage: m['avatar_url'] as String? ?? '',
        );
      }).toList();

      await _cacheConnectedUsers(users);
      await _db.markCacheFresh(_connectedKey);
      return users;
    } catch (_) {
      return _getCachedConnectedUsers();
    }
  }

  // ── Fetch Sent Requests (cache-first) ────────────

  Future<List<SentRequestUser>> fetchSentRequests() async {
    final isStale = await _db.isCacheStale(_sentKey);
    if (!isStale) {
      final cached = await _getCachedSentRequests();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/connections/sent');
      final List<dynamic> raw = response['requests'] as List<dynamic>;
      final requests = raw.map((j) {
        final m = j as Map<String, dynamic>;
        return SentRequestUser(
          userId: m['user_id'] as String,
          name: m['display_name'] as String,
          profileImage: m['avatar_url'] as String? ?? '',
          timestamp: m['created_at'] as String,
        );
      }).toList();

      await _cacheSentRequests(requests);
      await _db.markCacheFresh(_sentKey);
      return requests;
    } catch (_) {
      return _getCachedSentRequests();
    }
  }

  // ── Send Connection Request ───────────────────────────────────────────────

  Future<bool> sendRequest(String targetId) async {
    try {
      await _api.post('/connections/request', body: {'target_id': targetId});
      await _db.invalidateCache(_sentKey);
      return true;
    } catch (_) {
      return false;
    }
  }
  // ── Cancel Sent Request ───────────────────────────────────────────────────
  Future<bool> cancelRequest(String targetId) async {
    try {
      await _api.delete('/connections/request/$targetId');
      // Remove from local cache immediately for instant UI feedback
      final db = await _db.database;
      await db.delete(
        'connections',
        where: 'target_id = ? AND status = ?',
        whereArgs: [targetId, 'pending'],
      );
      await _db.invalidateCache(_sentKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Accept Incoming Request ───────────────────────────────────────────────

  Future<bool> acceptRequest(String requesterId) async {
    try {
      await _api.post(
        '/connections/accept',
        body: {'requester_id': requesterId},
      );
      await _db.invalidateCache(_connectedKey);
      return true;
    } catch (_) {
      return false;
    }
  }
  // ─── SQLite helpers ──────────────────────────────────────────────────────

  Future<List<ConnectedUser>> _getCachedConnectedUsers() async {
    final db = await _db.database;
    final rows = await db.query(
      'connections',
      where: 'status = ?',
      whereArgs: ['connected'],
    );
    // Map each connection row to a ConnectedUser using joined user data
    return rows
        .map(
          (r) => ConnectedUser(
            userId: r['target_id'] as String,
            name: r['target_id'] as String,
            username: '',
            profileImage: '',
          ),
        )
        .toList();
  }

  Future<void> _cacheConnectedUsers(List<ConnectedUser> users) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final u in users) {
      batch.insert('connections', {
        'id': '${u.userId}_connected',
        'user_id': 'me',
        'target_id': u.userId,
        'status': 'connected',
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<SentRequestUser>> _getCachedSentRequests() async {
    final db = await _db.database;
    final rows = await db.query(
      'connections',
      where: 'status = ?',
      whereArgs: ['pending'],
    );
    return rows
        .map(
          (r) => SentRequestUser(
            userId: r['target_id'] as String,
            name: r['target_id'] as String,
            profileImage: '',
            timestamp: r['created_at'] as String,
          ),
        )
        .toList();
  }
  Future<void> _cacheSentRequests(List<SentRequestUser> requests) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final r in requests) {
      batch.insert('connections', {
        'id': '${r.userId}_pending',
        'user_id': 'me',
        'target_id': r.userId,
        'status': 'pending',
        'created_at': r.timestamp,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
