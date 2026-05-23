import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/message.dart';
import '../providers/chat_notifier.dart';

class SavedMessagesScreen extends ConsumerWidget {
  final bool embedded;

  const SavedMessagesScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedMessagesNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Saved Messages',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Divider(color: Colors.white24, height: 1),
        Expanded(child: _buildBody(state)),
      ],
    );
  }

  Widget _buildBody(SavedMessagesState state) {
    return switch (state) {
      SavedMessagesLoading() => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      SavedMessagesError(:final message) => Center(
          child: Text(message, style: const TextStyle(color: Colors.white70)),
        ),
      SavedMessagesLoaded(:final messages) => messages.isEmpty
          ? const Center(
              child: Text(
                'No saved messages',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) => _bubble(messages[i]),
            ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _bubble(Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFAC5AF7), Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                message.displayTime,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
