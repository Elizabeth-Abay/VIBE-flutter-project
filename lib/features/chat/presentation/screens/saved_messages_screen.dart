import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class SavedMessagesScreen extends StatelessWidget {
  const SavedMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Internal Header for Saved Messages
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              const Expanded(
                child: Text(
                  'Saved Messages',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Serif',
                  ),
                ),
              ),
              const SizedBox(width: 20), // Balance the back button
            ],
          ),
        ),
        const Divider(color: Colors.white24, height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              _bubble("I have to submit the figma design", "2:45 AM", true, null),
              _bubble("I have to Study OS", "4:45 PM", true, null),
              _bubble("Fully Funded Robotics Training", "1:56 AM", false, 'https://i.pravatar.cc/150?u=robotics'),
              _bubble("Attending robotics Training", "3:55 PM", true, null),
              _bubble("Os lab assignment", "3:55 PM", true, null),
              _bubble("ALX Hackaton Register Now", "5:26 AM", false, 'https://i.pravatar.cc/150?u=alx'),
            ],
          ),
        ),
        _inputArea(),
      ],
    );
  }

  Widget _bubble(String text, String time, bool isMe, String? avatar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(avatar ?? 'https://i.pravatar.cc/150?u=default'),
            ),
            const SizedBox(width: 10),
          ],
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 240),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isMe ? const LinearGradient(
                    colors: [Color(0xFFAC5AF7), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ) : null,
                  color: isMe ? null : const Color(0xFF33384D),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  time,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        children: [
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23283B),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(color: Colors.white60, fontSize: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Transform.rotate(
                angle: -0.4,
                child: const Icon(Icons.send_outlined, color: Colors.white, size: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}