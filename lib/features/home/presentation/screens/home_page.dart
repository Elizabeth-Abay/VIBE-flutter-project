import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/post_categories.dart'; // Ensure this points to postAppCategories
import '../../../posts/presentation/providers/post_provider.dart'; // Handles your feed updates centrally
import '../../../connections/presentation/providers/people_notifier.dart'; // Handles your connection streams
import '../widgets/posts_bar.dart';
import '../widgets/category_bar.dart'; // 🎯 FIX: Added missing horizontal feed widget import
import '../widgets/recommended_ppl_list.dart';

/// Home screen — ConsumerWidget driving unified pull-to-refresh.
/// All data is live from reactive Riverpod providers.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: const Color(0xFFBB86FC),
      onRefresh: () async {
        // 🎯 FIX: Dump the active list caches to trigger a fresh network pull across the app
        ref.invalidate(postsFeedProvider);
        ref.invalidate(peopleNotifierProvider);

        // Small delays ensure smooth UI scroll return physics
        await Future.delayed(const Duration(milliseconds: 300));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            CategoryBar(),

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
