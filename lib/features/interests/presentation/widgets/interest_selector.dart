import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/interests_notifier.dart';

class InterestSelectionBox extends ConsumerWidget {
  const InterestSelectionBox({super.key});

  static const _interests = [
    {'icon': Icons.music_note_rounded, 'title': 'Music'},
    {'icon': Icons.sports_soccer_rounded, 'title': 'Football'},
    {'icon': Icons.sports_basketball_rounded, 'title': 'Basketball'},
    {'icon': Icons.flight_takeoff_rounded, 'title': 'Travel'},
    {'icon': Icons.restaurant_rounded, 'title': 'Food'},
    {'icon': Icons.casino_rounded, 'title': 'Chess'},
    {'icon': Icons.sports_esports_rounded, 'title': 'Gaming'},
    {'icon': Icons.emoji_events_rounded, 'title': 'Hackathons'},
    {'icon': Icons.book_outlined, 'title': 'Books'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibes = ref.watch(selectedVibesProvider);
    final isSaving = ref.watch(interestsSavingProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "What's your vibe?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Tell us how you feel about each interest.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 15),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _interests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final item = _interests[index];
              final title = item['title'] as String;

              return _VibeCard(
                icon: item['icon'] as IconData,
                title: title,
                selected: vibes[title] ?? '',
                onSelect: (label) => ref
                    .read(selectedVibesProvider.notifier)
                    .setVibe(title, label),
              );
            },
          ),

          Center(
            child: GestureDetector(
              onTap: isSaving
                  ? null
                  : () async {
                      final ok = await ref
                          .read(interestsSavingProvider.notifier)
                          .update(vibes);
                      if (ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Interests successfully updated!'),
                          ),
                        );
                        Navigator.pop(context);
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to save interests'),
                          ),
                        );
                      }
                    },
              child: Container(
                width: 220,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE040FB), Color(0xFF448AFF)],
                  ),
                ),
                child: Center(
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// Keep your _VibeCard and _VibeButton classes unchanged
class _VibeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String selected;
  final ValueChanged<String> onSelect;

  const _VibeCard({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Love', 'Like', 'Neutral', 'Bothered', 'Hate']
                .map(
                  (label) => _VibeButton(
                    label: label,
                    isSelected: selected == label,
                    onTap: () => onSelect(label),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _VibeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VibeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF448AFF) : const Color(0xFF1A1F3D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          fontSize: 10,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    ),
  );
}
