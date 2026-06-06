import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/message.dart';
import '../../data/repositories/message_repository.dart';

/// Repository provider
final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final repo = MessageRepository.instance;
  repo.setRef(ref);
  return repo;
});

final chatMessagesProvider = AsyncNotifierProvider.autoDispose
    .family<ChatMessagesNotifier, List<Message>, String>(
      ChatMessagesNotifier.new,
    );

// final chatMessagesProvider = FutureProvider.family<List<Message>, String>(
//   (ref, chatId) async {
//     final repo = ref.watch(messageRepositoryProvider);
//     return repo.fetchMessages(chatId);
//   },
// );

class ChatMessagesNotifier extends AsyncNotifier<List<Message>> {
  /// The chatId coming from the family parameter
  late final String currentChatId;

  /// Constructor that receives the family argument
  ChatMessagesNotifier(String chatId) : currentChatId = chatId;

  MessageRepository get _repository => ref.read(messageRepositoryProvider);

  @override
  Future<List<Message>> build() async {
    final messages = await _repository.fetchMessages(currentChatId);

    // If your API returns oldest first, reversing it makes index 0 the newest.
    // This matches your ListView.builder(reverse: true)
    return messages.toList();
  }

  // ─────────────────────────────────────────────────────────────
  //                    MUTATIONS
  // ─────────────────────────────────────────────────────────────

  Future<bool> sendMessage(String textContent, String type) async {
    if (textContent.trim().isEmpty) return false;

    final previousState = state.value ?? [];

    final optimisticMessage = Message(
      msgId: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      text: textContent.trim(),
      isMine: true,
      chatId: currentChatId,
    );

    // Optimistic update
    state = AsyncData([optimisticMessage, ...previousState]);

    final success = await _repository.sendMessage(
      chatId: currentChatId,
      text: textContent.trim(),
      type: type,
    );

    if (success) {
      ref.invalidateSelf(); // Refresh from source of truth
      return true;
    } else {
      state = AsyncData(previousState); // rollback
      return false;
    }
  }

  Future<bool> editMessage(String messageId, String updatedText) async {
    if (updatedText.trim().isEmpty || !state.hasValue) return false;

    final previousState = state.value!;

    state = AsyncData(
      previousState.map((msg) {
        if (msg.msgId == messageId) {
          return Message(
            msgId: msg.msgId,
            text: updatedText.trim(),
            isMine: msg.isMine,
            chatId: msg.chatId,
          );
        }
        return msg;
      }).toList(),
    );

    final success = await _repository.updateMessage(
      msgId: messageId,
      newMessage: updatedText.trim(),
      chatId: currentChatId,
    );

    if (!success) {
      state = AsyncData(previousState);
      return false;
    }
    return true;
  }

  Future<bool> deleteMessage(String messageId, String chatId) async {
    if (!state.hasValue) return false;

    final previousState = state.value!;

    state = AsyncData(
      previousState.where((msg) => msg.msgId != messageId).toList(),
    );

    final success = await _repository.deleteMessage(
      msgId: messageId,
      chatId: chatId,
    );

    if (!success) {
      state = AsyncData(previousState);
      return false;
    }
    return true;
  }
}
