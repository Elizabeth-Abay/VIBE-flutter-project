import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

/// Cache-first repository for conversations and messages.
class MessageRepository {
  MessageRepository._internal();
  static final MessageRepository instance = MessageRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _conversationsKey = 'chat_conversations';
  static const _messagesKeyPrefix = 'chat_messages_';

  // ─── Conversations (cache-first) ─────────────────────────────────────────

  Future<List<ChatUser>> fetchMessagesOfThisChat(String chatId) async {
    final isStale = await _db.isCacheStale(chatId);
    if (!isStale) {
      final cached = await _getCachedConversations();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/message/get-messages/$chatId');
      final raw = response['data'] as List<dynamic>;
      final users = raw
          .map((j) => ChatUser.fromJson(j as Map<String, dynamic>))
          .toList();

      await _cacheConversations(users);
      await _db.markCacheFresh(_conversationsKey);
      return users;
    } catch (_) {
      return _getCachedConversations();
    }
  }

  // ─── Messages (cache-first) ────────────────────────────────────────────────

  Future<List<Message>> fetchMessages(String chatId) async {
    final cacheKey = '$_messagesKeyPrefix$chatId';
    final isStale = await _db.isCacheStale(cacheKey);
    if (!isStale) {
      final cached = await _getCachedMessages(chatId);
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/message/get-messages/$chatId');
      final raw = response['data'] as List<dynamic>;

      final messages = raw
          .map((j) => Message.fromJson(j as Map<String, dynamic>))
          .toList();

      await _cacheMessages(chatId, messages);
      await _db.markCacheFresh(cacheKey);
      return messages;
    } catch (_) {
      return _getCachedMessages(chatId);
    }
  }

  // ─── Mutative Database Cache Handlers ─────────────────────────────────────

  Future<bool> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      final response = await _api.post(
        '/message/send-message',
        body: {'chatId': chatId, 'message': text, 'type': 'chat'},
      );

      if (response['success'] == true) {
        // Parse the full message payload returned from your server architecture
        // (This contains server elements like generated DB 'id' and 'created_at')
        final serverMessageData = response['data'] ?? response['message'];
        if (serverMessageData != null) {
          final newMessage = Message.fromJson(
            serverMessageData as Map<String, dynamic>,
          );

          // Instantly insert it directly into your message history cache
          final db = await _db.database;
          await db.insert(
            'messages',
            newMessage.toDb(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteMessage({
    required String msgId,
    required String chatId,
  }) async {
    try {
      final response = await _api.delete('/message/delete-message/$msgId');

      if (response['success'] == true) {
        final db = await _db.database;

        // Evict the single target record matching your primary key structural constraint
        await db.delete('messages', where: 'id = ?', whereArgs: [msgId]);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateMessage({
    required String msgId,
    required String newMessage,
    required String chatId,
  }) async {
    try {
      final response = await _api.post(
        '/message/update-message',
        body: {'chatId': chatId, 'msgId': msgId, 'newMessage': newMessage},
      );

      if (response['success'] == true) {
        final db = await _db.database;

        // Apply targeted SQL table content modifications locally
        await db.update(
          'messages',
          {
            'text': newMessage,
          }, // Adjust key name to match your specific DB column constraints
          where: 'id = ?',
          whereArgs: [msgId],
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ─── SQLite helpers ────────────────────────────────────────────────────────

  Future<List<ChatUser>> _getCachedConversations() async {
    final db = await _db.database;
    final rows = await db.query('conversations', orderBy: 'updated_at DESC');
    return rows.map(ChatUser.fromDb).toList();
  }

  Future<void> _cacheConversations(List<ChatUser> users) async {
    final db = await _db.database;
    await db.delete('conversations');
    final batch = db.batch();
    for (final u in users) {
      batch.insert(
        'conversations',
        u.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Message>> _getCachedMessages(String conversationId) async {
    final db = await _db.database;
    final rows = await db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'created_at ASC',
    );
    return rows.map(Message.fromDb).toList();
  }

  Future<void> _cacheMessages(
    String conversationId,
    List<Message> messages,
  ) async {
    final db = await _db.database;
    await db.delete(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
    );
    final batch = db.batch();
    for (final m in messages) {
      batch.insert(
        'messages',
        m.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Message>> _getCachedSavedMessages() async {
    final db = await _db.database;
    final rows = await db.query(
      'messages',
      where: 'is_saved = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return rows.map(Message.fromDb).toList();
  }

  Future<void> _cacheSavedMessages(List<Message> messages) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final m in messages) {
      batch.insert(
        'messages',
        m.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
