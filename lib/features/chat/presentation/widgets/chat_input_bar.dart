import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/message_repository.dart';
import '../providers/message_provider.dart';

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

  Future<void> _submitMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear(); // Clear input immediately

    try {
      final success = await MessageRepository.instance.sendMessage(
        chatId: widget.chatId,
        text: text,
      );

      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send message')),
          );
        }
      }
      // No need to do anything else — the repository will invalidate the provider
      // → ScrollableChatMsgContainer will automatically update
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
      child: Row(
        children: [
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
