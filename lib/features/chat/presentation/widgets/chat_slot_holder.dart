import 'package:flutter/material.dart';
import '../../../connections/presentation/widgets/message_button.dart';
import '../../data/models/chat_user.dart';

class ChatSlotHolder extends StatelessWidget {
  final ChatUser userInfo;

  const ChatSlotHolder({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A33), // Matches your list card background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05), // Soft subtle border
        ),
      ),
      child: Row(
        children: [
          // ✅ Wrap the Column inside Expanded so it pushes the button to the far right
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                // 1. Display Name
                Text(
                  userInfo.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(
                  height: 4,
                ), // Small spacing between name and username
                // 2. Username
                Text(
                  '@${userInfo.userName}', // prepends an '@' symbol automatically
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withOpacity(
                      0.5,
                    ), // Muted color for subtext
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ✅ Your custom MessageButton
          MessageButton(userId: userInfo.chatWith),
        ],
      ),
    );
  }
}

