import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chat_users_info.dart';
import '../widgets/user_info_holder.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/scrollable_chat_msg_container.dart';
import '../providers/chat_notifier.dart';

class ChatDetailScreen extends ConsumerWidget {
  final String chatWith; // User ID / chatWith ID from route

  const ChatDetailScreen({super.key, required this.chatWith});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the single chat family provider
    final asyncChatState = ref.watch(singleChatProvider(chatWith));
    //print("asyncChatState");
    //print(asyncChatState);

    return Scaffold(
      backgroundColor: const Color(0xFF050517),
      body: SafeArea(
        child: asyncChatState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFFBB86FC)),
          ),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading chat: $error',
                style: const TextStyle(color: Colors.white54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (chatData) {
            // Extract data from the provider
            final String chatId = chatData['chatId'] as String;
            final otherUserProfileRaw = chatData['otherUserProfile'];

            // Extract user profile safely
            final ChatUserInfo otherUserProfile = _getOtherUserInfo(
              otherUserProfileRaw,
            );
            final String otherUserName = otherUserProfile.name;

            return Column(
              children: [
                // ─── Header ─────────────────────────────────────────────────
                const Divider(color: Colors.white10, thickness: 1),

                // ─── User Info Holder ───────────────────────────────────────
                SizedBox(
                  height: 80,
                  child: UserInfoHolder(userInfo: otherUserProfile),
                ),

                // ─── Messages Area ──────────────────────────────────────────
                Expanded(
                  flex: 1,
                  child: ScrollableChatMsgContainer(chatId: chatId), // explicit
                ),
                // ─── Input Bar ──────────────────────────────────────────────
                SizedBox(
                  height: 120,
                  child: ChatInputBar(chatId: chatId, type: 'chat'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper to safely extract user profile
  ChatUserInfo _getOtherUserInfo(dynamic userInfo) {
    if (userInfo is ChatUserInfo) {
      return userInfo;
    }
    if (userInfo is Iterable && userInfo.isNotEmpty) {
      final first = userInfo.first;
      if (first is ChatUserInfo) return first;
      if (first is Map) {
        return ChatUserInfo.fromJson(Map<String, dynamic>.from(first));
      }
    }
    if (userInfo is Map) {
      return ChatUserInfo.fromJson(Map<String, dynamic>.from(userInfo));
    }
    return const ChatUserInfo(name: '', userName: '', profileUrl: '');
  }
}
