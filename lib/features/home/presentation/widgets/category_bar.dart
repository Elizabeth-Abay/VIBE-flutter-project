import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/post_categories.dart';
import '../../../posts/presentation/providers/post_provider.dart'; // 🎯 Centered import to access post_notifier shared states
import 'category_pill.dart';

/// Category filter bar wired to selectedCategoryProvider (Riverpod Notifier).
class CategoryBar extends ConsumerWidget {
  // 🎯 Added constructor configuration profiles to make this component modular
  final List<dynamic> categories = postAppCategories;
  final Function(List<dynamic>)? onSelectionChanged;

  const CategoryBar({super.key, this.onSelectionChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the active selected string tag state (e.g. 'Academics', 'Dating', etc.)
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selected == category.name;

          return CategoryPill(
            label: category.name,
            icon: category.icon,
            isSelected: isSelected,

            onTap: () {
              final nextLabel = isSelected
                  ? 'books'
                  : category
                        .name; // Keep 'books' as your default fallback asset
              ref
                  .read(selectedCategoryProvider.notifier)
                  .updateCategory(nextLabel);
              // 🎯 Boom! postsFeedProvider watches this value, catches the update,
              // and loads your fresh network data stream immediately.
            },
          );
        },
      ),
    );
  }
}
