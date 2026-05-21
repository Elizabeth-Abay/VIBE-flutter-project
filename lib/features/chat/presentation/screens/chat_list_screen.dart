// lib/features/chat/presentation/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  final List<Map<String, String>> users = const [
    {'name': 'Leul Kebede', 'avatar': 'https://i.pravatar.cc/150?u=leul'},
    {'name': 'Mahlet sisay', 'avatar': 'https://i.pravatar.cc/150?u=mahlet'},
    {'name': 'Selam getu', 'avatar': 'https://i.pravatar.cc/150?u=selam'},
    {'name': 'Marta tegegne', 'avatar': 'https://i.pravatar.cc/150?u=marta'},
    {'name': 'Samuel mola', 'avatar': 'https://i.pravatar.cc/150?u=samuel'},
    {
      'name': 'Atenasya weldu',
      'avatar': 'https://i.pravatar.cc/150?u=atenasya'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          onTap: () => context.push('/chat/${user['name']}'),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF161A33), // Matching figma card color
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user['avatar']!),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    user['name']!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                _iconButton(
                    context, Icons.chat_bubble_outline, Colors.grey, null),
                const SizedBox(width: 12),
                _iconButton(context, Icons.block, Colors.redAccent, '/blocked'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _iconButton(
      BuildContext context, IconData icon, Color color, String? route) {
    return GestureDetector(
      onTap: route != null ? () => context.push(route) : null,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
