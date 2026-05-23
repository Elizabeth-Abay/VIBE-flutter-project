import 'package:flutter/material.dart';
import '../../../../core/constants/post_categories.dart';
import 'category_pills.dart';

/// Horizontally scrollable category pill bar for the Create Post screen.
/// Fires [onSelectionChanged] with the newly selected list on every tap.
class CategoryBar extends StatefulWidget {
  final List<CategoryModel> categories;
  final ValueChanged<List<CategoryModel>> onSelectionChanged;

  const CategoryBar({
    super.key,
    required this.categories,
    required this.onSelectionChanged,
  });

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  // Single-select: only one index active at a time.
  int? _selectedIndex;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = _selectedIndex == index ? null : index;
    });
    widget.onSelectionChanged(
      _selectedIndex != null ? [widget.categories[_selectedIndex!]] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) => CategoryPill(
          category: widget.categories[index],
          isSelected: _selectedIndex == index,
          onTap: () => _onTap(index),
        ),
      ),
    );
  }
}
