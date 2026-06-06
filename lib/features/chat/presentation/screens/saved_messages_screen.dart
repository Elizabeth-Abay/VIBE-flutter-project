import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/scrollable_chat_msg_container.dart';
import '../providers/chat_notifier.dart';

class SelfChat extends ConsumerWidget {
  const SelfChat({super.key});

  // the flow is the moment this opens it will do a get request
  // to receive the chat id

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the single chat family provider
    final asyncChatState = ref.watch(selfChatNotifierProvider);
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

            // then have the messages be fetched

            return Column(
              children: [
                // ─── Header ─────────────────────────────────────────────────
                const Divider(color: Colors.white10, thickness: 1),

                // ─── Messages Area ──────────────────────────────────────────
                Expanded(
                  flex: 1,
                  child: ScrollableChatMsgContainer(chatId: chatId), // explicit
                ),

                // ─── Input Bar ──────────────────────────────────────────────
                SizedBox(
                  height: 120,
                  child: ChatInputBar(chatId: chatId, type: 'self'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
