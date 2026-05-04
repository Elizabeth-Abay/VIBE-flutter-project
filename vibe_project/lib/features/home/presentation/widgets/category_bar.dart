import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import 'category_pill.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    // We watch the provider to know which category is currently selected
    final homeProvider = context.watch<HomeProvider>();

    // This is your constant list of categories
    final categories = homeProvider.categories;

    return SizedBox(
      height: 50, // Set a fixed height for the horizontal bar
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];

          return CategoryPill(
            label: category.name,
            icon: category.icon,
            // The Provider tells us if this specific pill is the active one
            isSelected: homeProvider.selectedCategory == category.name,
            onTap: () {
              // Trigger the backend request via the Provider
              homeProvider.selectCategory(category.name);
            },
          );
        },
      ),
    );
  }
}
