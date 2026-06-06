import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/notfication_model.dart';
import '../../domain/entity/notification_entity.dart';

/// Cache-first repository for notifications and incoming connection requests.
class NotificationRepository {
  NotificationRepository._internal();
  static final NotificationRepository instance =
      NotificationRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _notifCacheKey = 'notifications';
  static const _requestCacheKey = 'connection_requests_incoming';

  Future<List<NotificationEntity>> fetchNotifications() async {
    final isStale = await _db.isCacheStale(
      _notifCacheKey,
      maxAge: const Duration(minutes: 2),
    );

    if (!isStale) {
      final cached = await _getCachedNotifications();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/notifications');
      final raw = response['notifications'] as List<dynamic>;
      final models = raw
          .map((j) => NotificationModel.fromJson(j as Map<String, dynamic>))
          .toList();

      await _cacheNotifications(models);
      await _db.markCacheFresh(_notifCacheKey);
      return models;
    } catch (_) {
      return _getCachedNotifications();
    }
  }

  Future<List<ConnectionRequestEntity>> fetchIncomingRequests() async {
    // final isStale = await _db.isCacheStale(
    //   _requestCacheKey,
    //   maxAge: const Duration(minutes: 2),
    // );

    // if (!isStale) {
    //   final cached = await _getCachedRequests();
    //   if (cached.isNotEmpty) return cached;
    // }

    try {
      final response = await _api.get('/request/received-requests');
      //print("response");
      //print(response);
      final raw = response['data'] as List<dynamic>;
      final models = raw
          .map(
            (j) => ConnectionRequestModel.fromJson(j as Map<String, dynamic>),
          )
          .toList();

      //print("models");
      //print(models);

      await _cacheIncomingRequests(models);
      await _db.markCacheFresh(_requestCacheKey);
      return models;
    } catch (_) {
      return _getCachedRequests();
    }
  }

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
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    final db = await _db.database;
    await db.update('notifications', {'is_read': 1});
    try {
      await _api.put('/notifications/read-all');
    } catch (_) {}
  }

  Future<bool> acceptRequest(String requesterId) async {
    try {
      await _api.post(
        '/connection/accept-connection',
        body: {'acceptedId': requesterId},
      );
      await _db.invalidateCache(_requestCacheKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> declineRequest(String requesterId) async {
    try {
      await _api.post(
        '/connection/reject-connection',
        body: {'rejectedId': requesterId},
      );
      final db = await _db.database;
      await db.delete(
        'connection_requests',
        where: 'requester_id = ?',
        whereArgs: [requesterId],
      );
      await _db.invalidateCache(_requestCacheKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<int> getUnreadCount() async {
    final db = await _db.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE is_read = 0',
    );
    return result.first['count'] as int? ?? 0;
  }

  Future<List<NotificationEntity>> _getCachedNotifications() async {
    final db = await _db.database;
    final rows = await db.query(
      'notifications',
      where: "type != ?",
      whereArgs: ['connection_request'],
      orderBy: 'created_at DESC',
      limit: 50,
    );
    return rows.map(NotificationModel.fromDb).toList();
  }

  Future<void> _cacheNotifications(List<NotificationModel> models) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final n in models) {
      batch.insert(
        'notifications',
        n.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ConnectionRequestEntity>> _getCachedRequests() async {
    final db = await _db.database;
    final rows = await db.query(
      'connection_requests',
      orderBy: 'created_at DESC',
    );
    return rows.map(ConnectionRequestModel.fromDb).toList();
  }

  Future<void> _cacheIncomingRequests(
    List<ConnectionRequestModel> models,
  ) async {
    final db = await _db.database;
    await db.delete('connection_requests');
    final batch = db.batch();
    for (final r in models) {
      batch.insert(
        'connection_requests',
        r.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
