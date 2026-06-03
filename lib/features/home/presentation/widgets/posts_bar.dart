import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../posts/presentation/providers/post_provider.dart'; // 🎯 Updated to point to your central provider file
import 'post_card.dart';

/// Live horizontal post feed — all mock data removed.
/// Reads directly from postsFeedProvider and auto-reacts to category shifts.
class HorizontalPostFeed extends ConsumerWidget {
  const HorizontalPostFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 Watch the centralized reactive future provider
    final state = ref.watch(postsFeedProvider);

    // 🚀 Riverpod's built-in .when perfectly maps Loading, Error, and Data states
    return state.when(
      // ── 1. Loading State ───────────────────────────────────────────────────
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE186FF)),
        ),
      ),

      // ── 2. Error State ─────────────────────────────────────────────────────
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white24, size: 36),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            TextButton(
              onPressed: () => ref.invalidate(
                postsFeedProvider,
              ), // 🎯 Forces a fresh network request
              child: const Text(
                'Retry',
                style: TextStyle(color: Color(0xFFE186FF)),
              ),
            ),
          ],
        ),
      ),

      data: (posts) {
        if (posts.isEmpty) {
          return const Center(
            child: Text(
              'No posts yet.',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: SocialPostWidget(
                title: post.title,
                imageUrl: post.imageUrl ?? '',
                description: post.description,
                tags: [], // Falls back to safe empty array if null
                userName: post.userName ?? 'Anonymous',
                userProfileImageUrl: post.userProfileImageUrl,
              ),
            );
          },
        );
      },
    );
  }
}
