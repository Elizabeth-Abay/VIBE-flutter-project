import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/message_provider.dart'; // ← Make sure this imports your provider file

class ChatBubble extends ConsumerWidget {
  final String messageId;
  final String text;
  final bool isMine;
  final String chatId; // ← Important: We need this to target the right chat

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
      // ✅ Correct way using your family provider
      ref.read(chatMessagesProvider(chatId).notifier).deleteMessage(messageId);
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
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                // ✅ Correct way using family provider + notifier
                ref
                    .read(chatMessagesProvider(chatId).notifier)
                    .editMessage(messageId, controller.text.trim());
              }
              Navigator.pop(context);
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
