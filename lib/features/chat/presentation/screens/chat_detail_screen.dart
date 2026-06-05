import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            final otherUserProfile = chatData['otherUserProfile'];

            // Extract user name safely
            final String otherUserName = _getOtherUserName(otherUserProfile);

            return Column(
              children: [
                // ─── Header ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white12,
                        child: Text(
                          otherUserName.isNotEmpty
                              ? otherUserName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          otherUserName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10, thickness: 1),

                // ─── User Info Holder ───────────────────────────────────────
                UserInfoHolder(userInfo: otherUserProfile),

                // ─── Messages Area ──────────────────────────────────────────
                Expanded(child: ScrollableChatMsgContainer(chatId: chatId)),

                // ─── Input Bar ──────────────────────────────────────────────
                ChatInputBar(chatId: chatId),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper to safely extract user name
  String _getOtherUserName(dynamic userInfo) {
    if (userInfo == null) return '';
    if (userInfo is List && userInfo.isNotEmpty) {
      return userInfo.first['name']?.toString() ?? '';
    }
    if (userInfo is Map) {
      return userInfo['name']?.toString() ?? '';
    }
    return '';
  }
}
