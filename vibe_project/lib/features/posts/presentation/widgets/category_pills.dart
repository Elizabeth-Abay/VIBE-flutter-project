import 'package:flutter/material.dart';
import '../../../../core/constants/post_categories.dart';

class CategoryPillsWidget extends StatefulWidget {
  final List<CategoryModel> categories;
  final ValueChanged<List<CategoryModel>> onSelectionChanged;

  const CategoryPillsWidget({
    super.key,
    required this.categories,
    required this.onSelectionChanged,
  });

  @override
  State<CategoryPillsWidget> createState() => _CategoryPillsWidgetState();
}

class _CategoryPillsWidgetState extends State<CategoryPillsWidget> {
  final Set<int> _selectedIndices = {};

  void _toggle(int index) {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(widget.categories.length, (i) {
          final cat = widget.categories[i];
          final isSelected = _selectedIndices.contains(i);

          return GestureDetector(
            onTap: () => _toggle(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFD98BF5), Color(0xFF7B72EF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: isSelected ? null : const Color(0xFF1E2D3D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat.icon,
                    size: 15,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.55),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.name,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.55),
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
