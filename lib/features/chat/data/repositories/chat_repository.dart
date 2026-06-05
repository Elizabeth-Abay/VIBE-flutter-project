import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

/// Cache-first repository for conversations and messages.
class ChatRepository {
  ChatRepository._internal();
  static final ChatRepository instance = ChatRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _conversationsKey = 'chat_conversations';
  static const _messagesKeyPrefix = 'chat_messages_';

  // ─── Conversations (cache-first) ─────────────────────────────────────────

  Future<List<ChatUser>> fetchConversations() async {
    final isStale = await _db.isCacheStale(_conversationsKey);
    if (!isStale) {
      final cached = await _getCachedConversations();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/chats');
      final raw = response['conversations'] as List<dynamic>;
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

  Future<List<Message>> fetchMessages(String conversationId) async {
    final cacheKey = '$_messagesKeyPrefix$conversationId';
    final isStale = await _db.isCacheStale(cacheKey);
    if (!isStale) {
      final cached = await _getCachedMessages(conversationId);
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/chat/get-single-chat/$conversationId');
      final raw = response['messages'] as List<dynamic>;
      final currentUser = await AuthRepository.instance.getCurrentUser();
      final myId = currentUser?.id ?? 'me';

      final messages = raw
          .map(
            (j) => Message.fromJson(
              j as Map<String, dynamic>,
              conversationId: conversationId,
              currentUserId: myId,
            ),
          )
          .toList();

      await _cacheMessages(conversationId, messages);
      await _db.markCacheFresh(cacheKey);
      return messages;
    } catch (_) {
      return _getCachedMessages(conversationId);
    }
  }

  Future<Message?> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final response = await _api.post(
      '/chats/$conversationId/messages',
      body: {'text': text},
    );
    final raw = response['message'] as Map<String, dynamic>;
    final currentUser = await AuthRepository.instance.getCurrentUser();
    final myId = currentUser?.id ?? 'me';

    final message = Message.fromJson(
      raw,
      conversationId: conversationId,
      currentUserId: myId,
    );

    final db = await _db.database;
    await db.insert(
      'messages',
      message.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _db.invalidateCache('$_messagesKeyPrefix$conversationId');
    await _db.invalidateCache(_conversationsKey);
    return message;
  }

  // ─── Saved messages (cache-first) ──────────────────────────────────────────

  Future<List<Message>> fetchSavedMessages() async {
    const cacheKey = 'chat_saved_messages';
    final isStale = await _db.isCacheStale(cacheKey);
    if (!isStale) {
      final cached = await _getCachedSavedMessages();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/chats/saved');
      final raw = response['messages'] as List<dynamic>;
      final messages = raw.map((j) {
        final m = j as Map<String, dynamic>;
        final msg = Message.fromJson(
          m,
          conversationId: m['conversation_id'] as String,
          currentUserId: '',
        );
        return Message(
          id: msg.id,
          conversationId: msg.conversationId,
          senderId: msg.senderId,
          text: msg.text,
          createdAt: msg.createdAt,
          isSaved: true,
        );
      }).toList();

      await _cacheSavedMessages(messages);
      await _db.markCacheFresh(cacheKey);
      return messages;
    } catch (_) {
      return _getCachedSavedMessages();
    }
  }

  Future<void> saveMessage(String messageId) async {
    await _api.post('/chats/messages/$messageId/save');
    final db = await _db.database;
    await db.update(
      'messages',
      {'is_saved': 1},
      where: 'id = ?',
      whereArgs: [messageId],
    );
    await _db.invalidateCache('chat_saved_messages');
  }

  // ─── SQLite helpers ────────────────────────────────────────────────────────

  Future<List<ChatUser>> _getCachedConversations() async {
    final db = await _db.database;
    final rows = await db.query(
      'conversations',
      orderBy: 'updated_at DESC',
    );
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

  Future<void> _cacheMessages(String conversationId, List<Message> messages) async {
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
