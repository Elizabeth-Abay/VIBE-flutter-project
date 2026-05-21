import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_post_notifier.dart';

/// Tag input chip row — type a word and press Enter or the + button to add it.
/// Tags are stored in [createPostTagsProvider].
class TagInputField extends ConsumerStatefulWidget {
  const TagInputField({super.key});

  @override
  ConsumerState<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends ConsumerState<TagInputField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag() {
    final raw = _controller.text.trim().replaceAll('#', '');
    if (raw.isEmpty) return;

    final current = ref.read(createPostTagsProvider);
    if (!current.contains(raw) && current.length < 8) {
      ref.read(createPostTagsProvider.notifier).state = [...current, raw];
    }
    _controller.clear();
  }

  void _removeTag(String tag) {
    final current = ref.read(createPostTagsProvider);
    ref.read(createPostTagsProvider.notifier).state =
        current.where((t) => t != tag).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(createPostTagsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label ─────────────────────────────────────────────────────────
          const Text(
            'Tags',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // ── Existing tags as chips ─────────────────────────────────────────
          if (tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: tags
                  .map(
                    (tag) => Chip(
                      label: Text(
                        '#$tag',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      deleteIcon: const Icon(Icons.close,
                          size: 14, color: Colors.white54),
                      onDeleted: () => _removeTag(tag),
                      backgroundColor: const Color(0xFF2A1F5E),
                      side: const BorderSide(color: Color(0xFF7B72EF)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 8),

          // ── Type new tag ───────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onSubmitted: (_) => _addTag(),
                  decoration: InputDecoration(
                    hintText: tags.length >= 8
                        ? 'Max 8 tags'
                        : 'Add a tag (e.g. flutter)',
                    hintStyle: const TextStyle(
                        color: Colors.white24, fontSize: 14),
                    prefixText: '# ',
                    prefixStyle:
                        const TextStyle(color: Colors.white38, fontSize: 14),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  enabled: tags.length < 8,
                ),
              ),
              const SizedBox(width: 8),
              // + button
              GestureDetector(
                onTap: _addTag,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE186FF), Color(0xFF6E85E3)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
