import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../models/chat_users_info.dart';
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

  Future<List<ChatUser>> getAllChats() async {
    final isStale = await _db.isCacheStale(_conversationsKey);
    if (!isStale) {
      final cached = await _getCachedConversations();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/chat/get-all');
      final raw = response['data'] as List<dynamic>;
      print("raw");
      print(raw);
      final users = raw
          .map((j) => ChatUser.fromJson(j as Map<String, dynamic>))
          .toList();

      print("users");

      print(users);
      // await _cacheConversations(users);
      // await _db.markCacheFresh(_conversationsKey);
      return users;
    } catch (e) {
      print("Error");
      print(e);
      return _getCachedConversations();
    }
  }

  // this will be called when the chat_detail_screen_first loads
  Future<Set<dynamic>> getASingleChat(String chatWith) async {
    // final isStale = await _db.isCacheStale(_conversationsKey);
    // if (!isStale) {
    //   final cached = await _getCachedConversations();
    //   if (cached.isNotEmpty) return cached;
    // }

    try {
      final response = await _api.get('/chat/get-single-chat/$chatWith');
      final raw = response['data'];
      final chatId = raw['_id'];
      //print("chatId");

      //print(chatId);
      final userInfo = raw['otherUserProfile'];

      //print("userinfo");
      //print(userInfo);

      // here chat_id , and the otherUser's info info will be sent
      final usersInfoDisplayed = ChatUserInfo.fromJson(
        userInfo as Map<String, dynamic>,
      );

      //print("usersInfoDisplayed");
      //print(usersInfoDisplayed);
      await _db.markCacheFresh(_conversationsKey);
      return {chatId, usersInfoDisplayed};
    } catch (err) {
      //print("Error ");
      //print(err);
      return {};
    }
  }

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
