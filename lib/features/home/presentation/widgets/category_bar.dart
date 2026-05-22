import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/post_categories.dart';
import '../providers/post_notifier.dart';
import 'category_pill.dart';

/// Category filter bar — wired to selectedCategoryProvider.
/// Selecting a pill fetches posts filtered by that category.
class CategoryBar extends ConsumerWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: postAppCategories.length,
        itemBuilder: (context, index) {
          final category = postAppCategories[index];
          final isSelected = selected == category.name;

          return CategoryPill(
            label: category.name,
            icon: category.icon,
            isSelected: isSelected,
            onTap: () {
              // Toggle: tap selected → deselect (show all)
              final next = isSelected ? null : category.name;
              ref.read(selectedCategoryProvider.notifier).state = next;
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
