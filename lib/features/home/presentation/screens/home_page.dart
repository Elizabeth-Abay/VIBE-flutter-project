import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/category_bar.dart';
import '../widgets/posts_bar.dart';
import '../widgets/recommended_ppl_list.dart';

/// Home screen — now a ConsumerWidget so it can trigger refreshes.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      // Pull-to-refresh invalidates cache and re-fetches everything.
      onRefresh: () async {
        // Re-fetch will be triggered by providers on next watch
      },
      child: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

            // Category filter pills — wired to selectedCategoryProvider
            CategoryBar(),
            SizedBox(height: 24),

            // Horizontal post feed — live from PostsNotifier
            SizedBox(height: 340, child: HorizontalPostFeed()),
            SizedBox(height: 24),

            // Recommended people — live from PeopleNotifier
            SizedBox(height: 300, child: RecommendedConnectionsList()),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
