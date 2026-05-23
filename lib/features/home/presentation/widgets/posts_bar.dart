import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_notifier.dart';
import 'post_card.dart';

/// Live horizontal post feed — all mock data removed.
/// Reads from PostsNotifier which uses SQLite cache-first.
class HorizontalPostFeed extends ConsumerWidget {
  const HorizontalPostFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postsNotifierProvider);

    return switch (state) {
      PostsLoading() => const Center(child: CircularProgressIndicator()),

      PostsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white24, size: 36),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(postsNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),

      PostsLoaded(:final posts) when posts.isEmpty => const Center(
        child: Text('No posts yet.', style: TextStyle(color: Colors.white38)),
      ),

      PostsLoaded(:final posts) => ListView.builder(
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
              tags: post.tags,
              userName: post.userName,
              userProfileImageUrl: post.userProfileImageUrl,
            ),
          );
        },
      ),

      _ => const SizedBox.shrink(),
    };
  }
}
