import 'package:flutter/material.dart';
import './category_pills.dart';
import '../../../../core/constants/post_categories.dart';

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
  final Set<int> _selectedIndices = {};

  void _handlePillTap(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
    // Notify parent of the updated list of selected category objects
    widget.onSelectionChanged(
      _selectedIndices.map((i) => widget.categories[i]).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45, // Defined height prevents layout "smudging"
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return CategoryPill(
            category: widget.categories[index],
            isSelected: _selectedIndices.contains(index),
            onTap: () => _handlePillTap(index),
          );
        },
      ),
    );
  }
}