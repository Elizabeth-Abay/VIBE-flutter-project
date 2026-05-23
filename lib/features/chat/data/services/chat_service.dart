import '../models/chat_user.dart';
import '../models/message.dart';
import '../repositories/chat_repository.dart';

/// Thin facade over [ChatRepository] for presentation layer.
class ChatService {
  ChatService._internal();
  static final ChatService instance = ChatService._internal();

  final _repo = ChatRepository.instance;

  Future<List<ChatUser>> getConversations() => _repo.fetchConversations();

  Future<List<Message>> getMessages(String conversationId) =>
      _repo.fetchMessages(conversationId);

  Future<Message?> sendMessage({
    required String conversationId,
    required String text,
  }) =>
      _repo.sendMessage(conversationId: conversationId, text: text);

  Future<List<Message>> getSavedMessages() => _repo.fetchSavedMessages();

  Future<void> saveMessage(String messageId) => _repo.saveMessage(messageId);
}
