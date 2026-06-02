import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../data/models/chat_user.dart';
import '../../data/models/message.dart';
import '../../data/repositories/chat_repository.dart';

/// Set via [ProviderScope] override in [ChatDetailScreen].
final conversationIdProvider = Provider<String>(
  (ref) => throw UnimplementedError('conversationIdProvider must be overridden'),
);

// ─── Conversation list ───────────────────────────────────────────────────────

sealed class ChatListState {
  const ChatListState();
}

class ChatListInitial extends ChatListState {
  const ChatListInitial();
}

class ChatListLoading extends ChatListState {
  const ChatListLoading();
}

class ChatListLoaded extends ChatListState {
  final List<ChatUser> conversations;
  const ChatListLoaded(this.conversations);
}

class ChatListError extends ChatListState {
  final String message;
  const ChatListError(this.message);
}

final chatListNotifierProvider =
    NotifierProvider<ChatListNotifier, ChatListState>(ChatListNotifier.new);

class ChatListNotifier extends Notifier<ChatListState> {
  final _repo = ChatRepository.instance;

  @override
  ChatListState build() {
    loadConversations();
    return const ChatListLoading();
  }

  Future<void> loadConversations() async {
    state = const ChatListLoading();
    try {
      final list = await _repo.fetchConversations();
      state = ChatListLoaded(list);
    } catch (e) {
      state = ChatListError(e.toString());
    }
  }

  Future<void> refresh() => loadConversations();
}

// ─── Message thread ──────────────────────────────────────────────────────────

sealed class ChatThreadState {
  const ChatThreadState();
}

class ChatThreadInitial extends ChatThreadState {
  const ChatThreadInitial();
}

class ChatThreadLoading extends ChatThreadState {
  const ChatThreadLoading();
}

class ChatThreadLoaded extends ChatThreadState {
  final List<Message> messages;
  final String? currentUserId;
  const ChatThreadLoaded({required this.messages, this.currentUserId});
}

class ChatThreadError extends ChatThreadState {
  final String message;
  const ChatThreadError(this.message);
}

final chatThreadNotifierProvider =
    NotifierProvider<ChatThreadNotifier, ChatThreadState>(ChatThreadNotifier.new);

class ChatThreadNotifier extends Notifier<ChatThreadState> {
  final _repo = ChatRepository.instance;

  String get _conversationId => ref.read(conversationIdProvider);

  @override
  ChatThreadState build() {
    loadMessages();
    return const ChatThreadLoading();
  }

  Future<void> loadMessages() async {
    state = const ChatThreadLoading();
    try {
      final auth = ref.read(authNotifierProvider);
      //  auth is AuthStateAuthenticated ? auth.user.id : 
      final userId = null;
      final messages = await _repo.fetchMessages(_conversationId);
      state = ChatThreadLoaded(
        messages: messages,
        currentUserId: userId,
      );
    } catch (e) {
      state = ChatThreadError(e.toString());
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    try {
      final sent = await _repo.sendMessage(
        conversationId: _conversationId,
        text: text.trim(),
      );
      if (sent == null) return;
      final current = state;
      if (current is ChatThreadLoaded) {
        state = ChatThreadLoaded(
          messages: [...current.messages, sent],
          currentUserId: current.currentUserId,
        );
      } else {
        await loadMessages();
      }
    } catch (e) {
      state = ChatThreadError(e.toString());
    }
  }
}

// ─── Saved messages ──────────────────────────────────────────────────────────

sealed class SavedMessagesState {
  const SavedMessagesState();
}

class SavedMessagesInitial extends SavedMessagesState {
  const SavedMessagesInitial();
}

class SavedMessagesLoading extends SavedMessagesState {
  const SavedMessagesLoading();
}

class SavedMessagesLoaded extends SavedMessagesState {
  final List<Message> messages;
  const SavedMessagesLoaded(this.messages);
}

class SavedMessagesError extends SavedMessagesState {
  final String message;
  const SavedMessagesError(this.message);
}

final savedMessagesNotifierProvider =
    NotifierProvider<SavedMessagesNotifier, SavedMessagesState>(
  SavedMessagesNotifier.new,
);

class SavedMessagesNotifier extends Notifier<SavedMessagesState> {
  final _repo = ChatRepository.instance;

  @override
  SavedMessagesState build() {
    loadSaved();
    return const SavedMessagesLoading();
  }

  Future<void> loadSaved() async {
    state = const SavedMessagesLoading();
    try {
      final messages = await _repo.fetchSavedMessages();
      state = SavedMessagesLoaded(messages);
    } catch (e) {
      state = SavedMessagesError(e.toString());
    }
  }
}

final conversationTitleProvider =
    Provider.family<String, String>((ref, conversationId) {
  final listState = ref.watch(chatListNotifierProvider);
  if (listState is ChatListLoaded) {
    final match =
        listState.conversations.where((c) => c.id == conversationId).toList();
    if (match.isNotEmpty) return match.first.name;
  }
  return 'Chat';
});
