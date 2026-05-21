import 'package:flutter/material.dart';
import './category_pills.dart';
import '../../../../core/constants/post_categories.dart';

/// Horizontally scrollable category pill bar.
///
/// The existing [CategoryBar] used multi-select with a Set<int>.
/// This version keeps all the original UI but also fires
/// [onSelectionChanged] with the newly selected list on every tap
/// so the parent (CreatePostPage) can read it via Riverpod.
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
    widget.onSelectionChanged(
      _selectedIndices.map((i) => widget.categories[i]).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return CategoryPill(
            category:   widget.categories[index],
            isSelected: _selectedIndices.contains(index),
            onTap:      () => _handlePillTap(index),
          );
        },
      ),
    );
  }
}
