import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/post_categories.dart';
import '../providers/post_notifier.dart';
import 'category_pill.dart';

/// Category filter bar wired to selectedCategoryProvider (Riverpod 3 Notifier).
class CategoryBar extends ConsumerWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: postAppCategories.length,
        itemBuilder: (context, index) {
          final category = postAppCategories[index];
          final isSelected = selected == category.name;

          return CategoryPill(
            label: category.name,
            icon: category.icon,
            isSelected: isSelected,
            onTap: () {
              final next = isSelected ? null : category.name;
              // Use .select() — StateProvider.state setter no longer exists
              ref.read(selectedCategoryProvider.notifier).select(next);
              ref
                  .read(postsNotifierProvider.notifier)
                  .fetchPosts(category: next);
            },
          );
        },
      ),
    );
  }
}
