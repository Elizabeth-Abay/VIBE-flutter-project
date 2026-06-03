import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/people_notifier.dart';

/// Heart button — now wired to ConnectedNotifier so toggling
/// updates the shared Riverpod state instead of local StatefulWidget state.
class HeartButton extends ConsumerWidget {
  final String userId;
  final bool initialIsLiked;

  const HeartButton({
    super.key,
    required this.userId,
    required this.initialIsLiked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read current like status from provider state (keeps it in sync).
    final state = ref.watch(connectedNotifierProvider);
    bool isLiked = initialIsLiked;

    if (state is ConnectedLoaded) {
      final match = state.users.where((u) => u.userId == userId);
      if (match.isNotEmpty) isLiked = match.first.isLiked;
    }

    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.blue : Colors.white,
        size: 32,
      ),
      onPressed: () =>
          ref.read(connectedNotifierProvider.notifier).toggleLike(userId),
    );
  }
}
