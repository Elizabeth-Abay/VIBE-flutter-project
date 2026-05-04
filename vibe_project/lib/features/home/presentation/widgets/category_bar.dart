import 'package:flutter/material.dart';
import '../../../../core/constants/post_categories.dart'; // Your constants file             // Your provider
import 'category_pill.dart';                          // Your pill widget

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    // We watch the provider to see which category the user clicks
    // final homeProvider = context.watch<HomeProvider>();

    return Container(
      height: 60, // Fixed height for the bar
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Use the constant list length
        itemCount: postAppCategories.length,
        itemBuilder: (context, index) {
          final category = postAppCategories[index];
          
          return CategoryPill(
            label: category.name,
            icon: category.icon,
            // Check if this pill matches the selected state in the provider
            // isSelected: homeProvider.selectedCategory == category.name,
            onTap: () {
              // 1. Update the UI selection
              // 2. Trigger the Node.js backend request
              // homeProvider.selectCategory(category.name);
            },
          );
        },
      ),
    );
  }
}