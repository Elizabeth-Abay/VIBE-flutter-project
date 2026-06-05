import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;

import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../../presentation/providers/message_provider.dart';

class MessageRepository {
  MessageRepository._internal();
  static final MessageRepository instance = MessageRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  // Hold ref to invalidate providers after mutations
  Ref? _ref;

  void setRef(Ref ref) {
    _ref = ref;
  }

  // ─────────────────────────────────────────────────────────────
  // Conversations
  // ─────────────────────────────────────────────────────────────

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
      await _db.markCacheFresh('chat_conversations');
      return users;
    } catch (_) {
      return _getCachedConversations();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Messages (Main one used in chat screen)
  // ─────────────────────────────────────────────────────────────

  Future<List<Message>> fetchMessages(String chatId) async {
    final cacheKey = 'chat_messages_$chatId';
    final isStale = await _db.isCacheStale(cacheKey);

    if (!isStale) {
      final cached = await _getCachedMessages(chatId);
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/message/get-messages/$chatId');
      final raw = response['data'] as List<dynamic>;

      // print("fetch Messages");
      // print(raw);

      final messages = raw
          .map((j) => Message.fromJson(j as Map<String, dynamic>))
          .toList();

      return messages;

      // await _cacheMessages(chatId, messages);
      // await _db.markCacheFresh(cacheKey);
    } catch (_) {
      return _getCachedMessages(chatId);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Mutative Operations (with UI refresh)
  // ─────────────────────────────────────────────────────────────

  Future<bool> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      print("sending message");
      print(chatId);
      print(text);
      final response = await _api.post(
        '/message/send-message',
        body: {'chatId': chatId, 'message': text, 'type': 'chat'},
      );

      // print("response");
      print(response);

      if (response['success'] == true) {
        final serverMessageData = response['data'];
        print("serverMessageData");
        print(serverMessageData);

        if (serverMessageData != null) {
          final newMessage = Message.fromJson(
            serverMessageData as Map<String, dynamic>,
          );

          print("new Message");
          print(newMessage);

          // final db = await _db.database;
          // await db.insert(
          //   'messages',
          //   newMessage.toDb(),
          //   conflictAlgorithm: ConflictAlgorithm.replace,
          // );

          // Refresh the specific chat messages
          _ref?.invalidate(chatMessagesProvider(chatId));
        }
        return true;
      }
      return false;
    } catch (e) {
      print("error sending message");
      print(e);
      return false;
    }
  }

  Future<bool> deleteMessage({
    required String msgId,
    required String chatId, // ← Must pass chatId
  }) async {
    try {
      // print("chat and message id on delter");
      // print(msgId);
      // print(chatId);
      final response = await _api.get('/message/delete-message/$msgId');

      // print("response for deler");
      // print(response);

      if (response['success'] == true) {
        final db = await _db.database;
        await db.delete('messages', where: 'id = ?', whereArgs: [msgId]);

        // Refresh UI immediately
        _ref?.invalidate(chatMessagesProvider(chatId));
        return true;
      }
      return false;
    } catch (err) {
      // print("error while delete");
      // print(err);
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
        await db.update(
          'messages',
          {'text': newMessage},
          where: 'id = ?',
          whereArgs: [msgId],
        );

        _ref?.invalidate(chatMessagesProvider(chatId));
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SQLite Helpers
  // ─────────────────────────────────────────────────────────────

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
}
