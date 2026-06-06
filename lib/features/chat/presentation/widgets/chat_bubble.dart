import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/message_repository.dart';
import '../providers/message_provider.dart';

class ChatBubble extends ConsumerWidget {
  final String messageId;
  final String text;
  final bool isMine;
  final String chatId;

  const ChatBubble({
    super.key,
    required this.messageId,
    required this.text,
    required this.isMine,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myBubbleColor = const Color(0xFF6A1B9A);
    final theirBubbleColor = const Color(0xFF1E1E38);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: GestureDetector(
          onTapDown: (details) =>
              _showContextMenu(context, ref, details.globalPosition),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMine ? myBubbleColor : theirBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMine ? 16 : 2),
                bottomRight: Radius.circular(isMine ? 2 : 16),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(
    BuildContext context,
    WidgetRef ref,
    Offset tapPosition,
  ) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 40, 40),
      Offset.zero & overlay.size,
    );

    final selectedAction = await showMenu<String>(
      context: context,
      position: position,
      color: const Color(0xFF151530),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.white70, size: 18),
              SizedBox(width: 10),
              Text('Edit Message', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
              SizedBox(width: 10),
              Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    );

    if (selectedAction == 'edit') {
      _promptEditDialog(context, ref);
    } else if (selectedAction == 'delete') {
      _deleteMessage(context, ref);
    }
  }

  Future<void> _deleteMessage(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151530),
        title: const Text(
          'Delete Message',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this message?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await MessageRepository.instance.deleteMessage(
        msgId: messageId,
        chatId: chatId, // ← Required for invalidation
      );

      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete message')),
        );
      }
      // No need to do anything else — repository invalidates the provider
    }
  }

  void _promptEditDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151530),
        title: const Text(
          'Edit Message',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6A1B9A)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFBB86FC)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newText = controller.text.trim();
              if (newText.isNotEmpty && newText != text) {
                final success = await MessageRepository.instance.updateMessage(
                  msgId: messageId,
                  newMessage: newText,
                  chatId: chatId,
                );

                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update message')),
                  );
                }
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFFBB86FC)),
            ),
          ),
        ],
      ),
    );
  }
}
