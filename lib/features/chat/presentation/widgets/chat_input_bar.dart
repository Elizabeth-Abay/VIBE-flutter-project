import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/message_provider.dart'; // ← Import your message provider file

class ChatInputBar extends ConsumerStatefulWidget {
  final String chatId;

  const ChatInputBar({super.key, required this.chatId});

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear(); // Clear instantly for better UX

    // ✅ Use the correct family provider
    final success = await ref
        .read(chatMessagesProvider(widget.chatId).notifier)
        .sendMessage(text);

    if (!success) {
      // Optional: You can show a snackbar or restore the message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Failed to send message')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
      child: Row(
        children: [
          // Plus Media Attachment Button
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.rectangle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),

          // Text Input Field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E30),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _submitMessage(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Send Button
          IconButton(
            icon: const Icon(
              Icons.send_sharp,
              color: Color(0xFFD1B2FF),
              size: 28,
            ),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
