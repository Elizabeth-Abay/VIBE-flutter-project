import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './chat_bubble.dart';
import '../providers/message_provider.dart'; // ← Import your provider

class ScrollableChatMsgContainer extends ConsumerWidget {
  final String chatId;

  const ScrollableChatMsgContainer({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the correct family provider for this chat
    final asyncMessages = ref.watch(chatMessagesProvider(chatId));

    return asyncMessages.when(
      // ── 1. Loading State ───────────────────────────────────────────────────
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE186FF)),
          ),
        ),
      ),

      // ── 2. Error State ─────────────────────────────────────────────────────
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: ${error.toString()}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),

      // ── 3. Data Loaded Success State ───────────────────────────────────────
      data: (messages) {
        if (messages.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              // Giving it an alignment prevents the Center from collapsing completely during hit tests
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'No messages yet.',
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ),
            ),
          );
        } else {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            reverse: true, // ← Important for chat (newest at bottom)
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ChatBubble(
                  messageId: message.msgId,
                  text: message.text,
                  isMine: message.isMine, // ← Fixed: was .mine
                  chatId: chatId, // ← Required by ChatBubble
                ),
              );
            },
          );
        }
      },
    );
  }
}
