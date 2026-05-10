import 'package:flutter/material.dart';
import '../../../../core/constants/post_categories.dart'; // Your constants file
import 'category_pill.dart';                          // Your pill widget

class CategoryBar extends StatefulWidget {
  const CategoryBar({super.key});

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
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
            isSelected: selectedCategory == category.name,
            onTap: () {
              setState(() {
                selectedCategory = category.name;
              });
              // Here you can add additional functionality like:
              // - Filter posts by category
              // - Navigate to category-specific page
              // - Make API call to get posts for this category
              print('Selected category: ${category.name}');
            },
          );
        },
      ),
    );
  }
}