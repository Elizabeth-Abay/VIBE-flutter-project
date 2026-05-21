import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/profile_notifier.dart';
import '../domain/entities/profile_entity.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  Map<String, String> _vibes = {};
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Pre-fill fields from loaded profile on first build.
  void _initFromProfile(ProfileEntity profile) {
    if (_initialized) return;
    _nameController = TextEditingController(text: profile.username);
    _bioController = TextEditingController(text: profile.bio ?? '');
    _vibes = Map.from(profile.vibes);
    _initialized = true;
  }

  Future<void> _onSave() async {
    await ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(
          username: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          vibes: _vibes,
        );
  }

  @override
  Widget build(BuildContext context) {
    // React to update outcome
    ref.listen<ProfileState>(profileNotifierProvider, (_, next) {
      if (next is ProfileUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else if (next is ProfileError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    final state = ref.watch(profileNotifierProvider);

    // Pre-fill when profile first loads
    if (state is ProfileLoaded && !_initialized) {
      _initFromProfile(state.profile);
    }

    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isLoading = state is ProfileLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // ── Avatar with edit icon ──────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white12,
                      backgroundImage:
                          ref
                                  .read(profileNotifierProvider.notifier)
                                  .currentProfile
                                  ?.avatarUrl !=
                              null
                          ? NetworkImage(
                              ref
                                  .read(profileNotifierProvider.notifier)
                                  .currentProfile!
                                  .avatarUrl!,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Tap to edit profile photo',
                style: TextStyle(
                  color: Colors.white60,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ── Name ──────────────────────────────────────────────────────
            _fieldLabel('Name'),
            _textField(_nameController),
            const SizedBox(height: 20),

            // ── Bio ───────────────────────────────────────────────────────
            _fieldLabel('Bio'),
            _textField(_bioController, maxLines: 4),
            const SizedBox(height: 30),

            // ── Vibe cards ────────────────────────────────────────────────
            _fieldLabel('Interests'),
            const SizedBox(height: 10),
            Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What's your vibe?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Tell us how you feel about each interest.',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    for (final entry in [
                      [Icons.music_note, 'Music'],
                      [Icons.sports_soccer, 'Football'],
                      [Icons.fastfood, 'Food'],
                      [Icons.explore, 'Travel'],
                      [Icons.menu_book, 'Books'],
                      [Icons.videogame_asset, 'Games'],
                    ]) ...[
                      _vibeCard(entry[0] as IconData, entry[1] as String),
                      const SizedBox(height: 15),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ── Save button ───────────────────────────────────────────────
            GestureDetector(
              onTap: isLoading ? null : _onSave,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE040FB), Color(0xFF448AFF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Update Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'Times New Roman',
      ),
    ),
  );

  Widget _textField(TextEditingController c, {int maxLines = 1}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextFormField(
      controller: c,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(border: InputBorder.none),
    ),
  );

  Widget _vibeCard(IconData icon, String title) {
    final current = _vibes[title];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Love', 'Like', 'Neutral', 'Bothered', 'Hate']
                .map(
                  (label) => _vibeButton(
                    label,
                    isSelected: current == label,
                    onTap: () => setState(() => _vibes[title] = label),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _vibeButton(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
