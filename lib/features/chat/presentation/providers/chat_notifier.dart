import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/chat_repository.dart';
import '../../data/models/chat_user.dart';

/// Repository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository.instance;
});

// ─────────────────────────────────────────────────────────────
// 1. All Chats / Conversations List
// ─────────────────────────────────────────────────────────────

final allChatsProvider =
    AsyncNotifierProvider<AllChatsNotifier, List<ChatUser>>(
      AllChatsNotifier.new,
    );

final selfChatNotifierProvider = AsyncNotifierProvider<SelfChatNotifier, Map<String , String>>(
      SelfChatNotifier.new,
    );



class AllChatsNotifier extends AsyncNotifier<List<ChatUser>> {
  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  @override
  Future<List<ChatUser>> build() async {
    print("running get all");
    return _repository.getAllChats();
  }

  /// Optional: Manual refresh
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getAllChats());
  }
}

// ─────────────────────────────────────────────────────────────
// 2. Single Chat Details (Family Provider) - Matching your style
// ─────────────────────────────────────────────────────────────

final singleChatProvider = AsyncNotifierProvider.autoDispose
    .family<SingleChatNotifier, Map<String, dynamic>, String>(
      SingleChatNotifier.new,
    );

class SingleChatNotifier extends AsyncNotifier<Map<String, dynamic>> {
  /// The chatWith ID passed from the family
  late final String currentChatWith;

  /// Constructor that receives the family argument
  SingleChatNotifier(String chatWith) : currentChatWith = chatWith;

  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  @override
  Future<Map<String, dynamic>> build() async {
    return _fetchSingleChat(currentChatWith);
  }

  Future<Map<String, dynamic>> _fetchSingleChat(String chatWith) async {
    final result = await _repository.getASingleChat(chatWith);

    if (result.isEmpty) {
      throw Exception('Failed to load single chat details');
    }

    // Convert Set<dynamic> returned by repository into a clean Map
    return {
      'chatId': result.elementAt(0),
      'otherUserProfile': result.elementAt(1),
    };
  }
}

class SelfChatNotifier extends AsyncNotifier<Map<String, String>> {
  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  @override
  Future<Map<String, String>> build() async {
    print("running get all");
    return _repository.getASelfChat();
  }
}
