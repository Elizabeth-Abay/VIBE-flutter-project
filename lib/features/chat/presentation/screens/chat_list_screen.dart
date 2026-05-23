import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../providers/chat_notifier.dart';
import '../../data/models/chat_user.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListNotifierProvider);

    return switch (state) {
      ChatListLoading() => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ChatListError(:final message) => Center(
          child: Text(message, style: const TextStyle(color: Colors.white70)),
        ),
      ChatListLoaded(:final conversations) => _ConversationList(
          conversations: conversations,
          onRefresh: () =>
              ref.read(chatListNotifierProvider.notifier).refresh(),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ConversationList extends StatelessWidget {
  final List<ChatUser> conversations;
  final Future<void> Function() onRefresh;

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
      onRefresh: onRefresh,
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final user = conversations[index];
          return GestureDetector(
            onTap: () => context.push('/chat-detail/${user.id}'),
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
                    imageUrl: user.avatar,
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
                        if (user.lastMessage.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            user.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
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
                  _iconButton(context, Icons.block, Colors.redAccent, '/blocked'),
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
