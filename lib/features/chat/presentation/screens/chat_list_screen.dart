import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/user_avatar.dart';
import '../../data/models/chat_user.dart';
import '../providers/chat_notifier.dart'; // ← Make sure this import is correct

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncChats = ref.watch(allChatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF050517),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050517),
        title: const Text('Chats', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: asyncChats.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFBB86FC)),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load chats',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => ref.refresh(allChatsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (conversations) => _ConversationList(
          conversations: conversations,
          onRefresh: () => ref.refresh(allChatsProvider),
        ),
      ),
    );
  }
}

class _ConversationList extends StatelessWidget {
  final List<ChatUser> conversations;
  final VoidCallback onRefresh;

  const _ConversationList({
    required this.conversations,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return const Center(
        child: Text(
          'No conversations yet',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final user = conversations[index];
          return GestureDetector(
            onTap: () => context.push('/chat-detail/${user.chatWith}'),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF161A33),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  UserAvatar(
                    imageUrl: user.profileUrl,
                    name: user.name,
                    radius: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _iconButton(
                    context,
                    Icons.chat_bubble_outline,
                    Colors.grey,
                    null,
                  ),
                  const SizedBox(width: 12),
                  _iconButton(
                    context,
                    Icons.block,
                    Colors.redAccent,
                    '/blocked',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconButton(
    BuildContext context,
    IconData icon,
    Color color,
    String? route,
  ) {
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
