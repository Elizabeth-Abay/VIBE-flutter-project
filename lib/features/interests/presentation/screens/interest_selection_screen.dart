import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/interests_notifier.dart';

class InterestSelectionScreen extends ConsumerWidget {
  const InterestSelectionScreen({super.key});

  static const _interests = [
    {'icon': Icons.music_note,          'title': 'Music'},
    {'icon': Icons.sports_soccer,       'title': 'Football'},
    {'icon': Icons.airplanemode_active, 'title': 'Travel'},
    {'icon': Icons.extension,           'title': 'Chess'},
    {'icon': Icons.emoji_events,        'title': 'Hackathons'},
    {'icon': Icons.restaurant,          'title': 'Food-contents'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibes    = ref.watch(selectedVibesProvider);
    final isSaving = ref.watch(interestsSavingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Interest Selection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
              ),
              const SizedBox(height: 30),

              // ── Vibe cards ────────────────────────────────────────────────
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("What's your vibe?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const Text(
                          'Tell us how you feel about each interest.',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 14)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _interests.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final item = _interests[index];
                            final title = item['title'] as String;
                            return _VibeCard(
                              icon:      item['icon'] as IconData,
                              title:     title,
                              selected:  vibes[title] ?? '',
                              onSelect:  (label) => ref
                                  .read(selectedVibesProvider.notifier)
                                  .state = {...vibes, title: label},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ── Submit ────────────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: isSaving
                      ? null
                      : () async {
                          final ok = await ref
                              .read(interestsSavingProvider.notifier)
                              .save(vibes);
                          if (ok && context.mounted) context.go('/home');
                        },
                  child: Container(
                    width: 220,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE040FB), Color(0xFF448AFF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Center(
                      child: isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text('Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable vibe card ───────────────────────────────────────────────────────

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
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Love', 'Like', 'Neutral', 'Bothered', 'Hate']
                .map((label) => _VibeButton(
                      label: label,
                      isSelected: selected == label,
                      onTap: () => onSelect(label),
                    ))
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
            color: isSelected
                ? const Color(0xFF448AFF)
                : const Color(0xFF1A1F3D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      );
}
