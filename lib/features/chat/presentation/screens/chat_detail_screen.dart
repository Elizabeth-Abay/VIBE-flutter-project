import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/message.dart';
import '../providers/chat_notifier.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatDetailScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = ref.watch(conversationTitleProvider(widget.conversationId));

    return ProviderScope(
      overrides: [
        conversationIdProvider.overrideWithValue(widget.conversationId),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(chatThreadNotifierProvider);

          return Scaffold(
            backgroundColor: VibeColors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
                onPressed: () => context.pop(),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: Column(
              children: [
                const Divider(color: Colors.white24, height: 1),
                Expanded(child: _buildBody(state)),
                _inputArea(ref),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(ChatThreadState state) {
    return switch (state) {
      ChatThreadLoading() => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ChatThreadError(:final message) => Center(
          child: Text(message, style: const TextStyle(color: Colors.white70)),
        ),
      ChatThreadLoaded(:final messages, :final currentUserId) =>
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: messages.length,
          itemBuilder: (_, i) => _bubble(
            messages[i],
            currentUserId: currentUserId,
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _bubble(Message message, {String? currentUserId}) {
    final isMe = currentUserId != null && message.isFromMe(currentUserId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 18, color: Colors.white54),
            ),
            const SizedBox(width: 10),
          ],
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  gradient: isMe ? VibeColors.messageGradient : null,
                  color: isMe ? null : const Color(0xFF2C3149),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                  ),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Text(
                  message.displayTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputArea(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2235),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onSubmitted: (text) => _send(ref, text),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _send(ref, _controller.text),
            child: Transform.rotate(
              angle: -0.5,
              child: const Icon(Icons.send_sharp, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send(WidgetRef ref, String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();
    await ref.read(chatThreadNotifierProvider.notifier).sendMessage(text);
  }
}
