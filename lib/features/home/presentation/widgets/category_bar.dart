import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/post_categories.dart';
import '../providers/post_notifier.dart';
import 'category_pill.dart';

/// Category filter bar — now wired to selectedCategoryProvider.
/// Selecting a pill re-fetches posts filtered by that category.
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
          return CategoryPill(
            label: category.name,
            icon: category.icon,
            isSelected: selected == category.name,
            onTap: () {
              final newCategory =
                  selected == category.name ? null : category.name;
              ref.read(selectedCategoryProvider.notifier).state = newCategory;
              ref
                  .read(postsNotifierProvider.notifier)
                  .fetchPosts(category: newCategory);
            },
          );
        },
      ),
    );
  }
}
