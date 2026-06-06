import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Modernized Tags Collection State Notifier ───────────────────────────────
final createPostTagsProvider =
    NotifierProvider<CreatePostTagsNotifier, List<String>>(
      CreatePostTagsNotifier.new,
    );

class CreatePostTagsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => const []; // Start with an empty list of strings

  void add(String rawTag) {
    final clean = rawTag.trim().toLowerCase();
    if (state.contains(clean) || state.length >= 8) return;
    state = [...state, clean];
  }

  void remove(String targetTag) {
    state = state.where((tag) => tag != targetTag).toList();
  }
}

// ─── Tag Input Widget ────────────────────────────────────────────────────────
/// Tag input chip row — uses Riverpod Notifier methods (no legacy .state =).
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

    // 🎯 Read current length to firmly enforce your layout max limit
    final currentTags = ref.read(createPostTagsProvider);
    if (currentTags.length >= 8) return;

    ref.read(createPostTagsProvider.notifier).add(raw);
    _controller.clear();
  }

  void _removeTag(String tag) {
    ref.read(createPostTagsProvider.notifier).remove(tag);
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(createPostTagsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tags',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

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
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white54,
                      ),
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
                      color: Colors.white24,
                      fontSize: 14,
                    ),
                    prefixText: '# ',
                    prefixStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  enabled: tags.length < 8,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: tags.length >= 8
                    ? null
                    : _addTag, // Disables click handler gracefully when full
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
