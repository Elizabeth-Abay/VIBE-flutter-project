import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_notifier.dart';
import '../widgets/category_bar.dart';
import '../widgets/posts_bar.dart';
import '../widgets/recommended_ppl_list.dart';

/// Home screen — ConsumerWidget so it can drive pull-to-refresh.
/// All data is live from Riverpod providers (SQLite cache-first).
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: const Color(0xFFBB86FC),
      onRefresh: () async {
        ref.invalidate(postsNotifierProvider);
        ref.invalidate(peopleNotifierProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const CategoryBar(),
            const SizedBox(height: 24),
            const SizedBox(height: 340, child: HorizontalPostFeed()),
            const SizedBox(height: 24),
            const SizedBox(height: 300, child: RecommendedConnectionsList()),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
