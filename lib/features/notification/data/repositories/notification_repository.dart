import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entity/notification_entity.dart';

/// Cache-first repository for notifications and incoming connection requests.
class NotificationRepository {
  NotificationRepository._internal();
  static final NotificationRepository instance =
      NotificationRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _notifKey = 'notifications';
  static const _requestKey = 'connection_requests';

  // ─── Fetch Notifications (cache-first) ───────────────────────────────────

  Future<List<NotificationEntity>> fetchNotifications() async {
    final isStale =
        await _db.isCacheStale(_notifKey, maxAge: const Duration(minutes: 2));
    if (!isStale) {
      final cached = await _getCachedNotifications();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/notifications');
      final List<dynamic> raw = response['notifications'] as List<dynamic>;
      final notifs = raw.map((j) {
        final m = j as Map<String, dynamic>;
        return NotificationEntity(
          id: m['id'] as String,
          type: m['type'] as String,
          message: m['message'] as String,
          isRead: (m['is_read'] as int?) == 1,
          createdAt: DateTime.parse(m['created_at'] as String),
        );
      }).toList();

      await _cacheNotifications(notifs);
      await _db.markCacheFresh(_notifKey);
      return notifs;
    } catch (_) {
      return _getCachedNotifications();
    }
  }

  // ─── Fetch Incoming Requests (cache-first) ───────────────────────────────

  Future<List<ConnectionRequestEntity>> fetchIncomingRequests() async {
    final isStale =
        await _db.isCacheStale(_requestKey, maxAge: const Duration(minutes: 2));
    if (!isStale) {
      final cached = await _getCachedRequests();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/connections/incoming');
      final List<dynamic> raw = response['requests'] as List<dynamic>;
      final requests = raw.map((j) {
        final m = j as Map<String, dynamic>;
        return ConnectionRequestEntity(
          requesterId: m['user_id'] as String,
          name: m['display_name'] as String,
          profileImage: m['avatar_url'] as String?,
          createdAt: DateTime.parse(m['created_at'] as String),
        );
      }).toList();

      await _cacheRequests(requests);
      await _db.markCacheFresh(_requestKey);
      return requests;
    } catch (_) {
      return _getCachedRequests();
    }
  }

  // ─── Mark as read ────────────────────────────────────────────────────────

  Future<void> markRead(String notificationId) async {
    final db = await _db.database;
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
    try {
      await _api.put('/notifications/$notificationId/read');
    } catch (_) {
      // Best-effort — local mark is enough for UX
    }
  }

  // ─── SQLite helpers ──────────────────────────────────────────────────────

  Future<List<NotificationEntity>> _getCachedNotifications() async {
    final db = await _db.database;
    final rows =
        await db.query('notifications', orderBy: 'created_at DESC', limit: 50);
    return rows
        .map((r) => NotificationEntity(
              id: r['id'] as String,
              type: r['type'] as String,
              message: r['message'] as String,
              isRead: (r['is_read'] as int) == 1,
              createdAt: DateTime.parse(r['created_at'] as String),
            ))
        .toList();
  }

  Future<void> _cacheNotifications(List<NotificationEntity> notifs) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final n in notifs) {
      batch.insert(
        'notifications',
        {
          'id': n.id,
          'type': n.type,
          'message': n.message,
          'is_read': n.isRead ? 1 : 0,
          'created_at': n.createdAt.toIso8601String(),
          'cached_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ConnectionRequestEntity>> _getCachedRequests() async {
    // Incoming requests are not in the notifications table — we return empty
    // on cache miss to force a network call next time.
    return [];
  }

  Future<void> _cacheRequests(List<ConnectionRequestEntity> requests) async {
    // Store incoming requests as notification rows with type = 'connection_request'
    final db = await _db.database;
    final batch = db.batch();
    for (final r in requests) {
      batch.insert(
        'notifications',
        {
          'id': 'req_${r.requesterId}',
          'type': 'connection_request',
          'message': '${r.name} wants to connect',
          'is_read': 0,
          'created_at': r.createdAt.toIso8601String(),
          'cached_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
