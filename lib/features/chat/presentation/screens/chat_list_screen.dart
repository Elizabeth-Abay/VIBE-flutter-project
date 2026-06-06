import 'package:flutter/material.dart';
import '../widgets/chat_slot_holder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_notifier.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watches the AsyncNotifier provider, triggering the API/cache call automatically on load
    final asyncChats = ref.watch(allChatsProvider);
    print("running the build of ChatLists");

    return Scaffold(
      backgroundColor: const Color(0xFF050517),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050517),
        title: const Text('Chats', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: asyncChats.when(
        // ── Loading State ──
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFBB86FC)),
        ),

        // ── Error State ──
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
                const Text(
                  'Failed to load chats',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(allChatsProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),

        // ── Success State (Data Loaded) ──
        data: (conversations) {
          if (conversations.isEmpty) {
            return const Center(
              child: Text(
                'No conversations yet.',
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Crucial constraint: allows swiping even if list doesn't fill the screen space
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final singleUser = conversations[index];

                // Pass the single item from the array into your row widget card
                return ChatSlotHolder(userInfo: singleUser);
              },
            );
          }
        },
      ),
    );
  }
}
