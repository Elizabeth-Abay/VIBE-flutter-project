import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/profile_notifier.dart';

class ProfileViewScreen extends ConsumerWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: switch (state) {
        ProfileLoading() => const Center(child: CircularProgressIndicator()),
        ProfileError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white38, size: 40),
              const SizedBox(height: 12),
              Text(message, style: const TextStyle(color: Colors.white38)),
              TextButton(
                onPressed: () =>
                    ref.read(profileNotifierProvider.notifier).loadProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        ProfileLoaded(:final profile) ||
        ProfileUpdated(:final profile) => _ProfileBody(profile: profile),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final profile;
  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ── Avatar ────────────────────────────────────────────────────
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white12,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Text(
                          profile.username.isNotEmpty
                              ? profile.username[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Username ──────────────────────────────────────────────────
            Center(
              child: Text(
                '@${profile.username}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Bio ───────────────────────────────────────────────────────
            const Text(
              'Bio',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.purple.shade200.withOpacity(0.5),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                profile.bio ?? 'No bio yet. Tap Edit Profile to add one.',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),

            // ── Interests / vibes ─────────────────────────────────────────
            if (profile.vibes.isNotEmpty) ...[
              const Divider(color: Colors.white24, height: 40, thickness: 1),
              const Text(
                'Interests',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: profile.vibes.entries
                    .map((e) => _interestChip('${e.key} (${e.value})'))
                    .toList(),
              ),
            ],

            const Divider(color: Colors.white24, height: 60, thickness: 1),

            // ── Actions ───────────────────────────────────────────────────
            _actionButton(
              text: 'Edit Profile',
              isGradient: true,
              onTap: () => context.push('/profile/edit'),
            ),
            const SizedBox(height: 16),
            _actionButton(
              text: 'Delete Account',
              isGradient: false,
              onTap: () => context.push('/profile/delete'),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _interestChip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white10),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white70,
        fontFamily: 'Times New Roman',
        fontSize: 14,
      ),
    ),
  );

  Widget _actionButton({
    required String text,
    required bool isGradient,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: isGradient
            ? const LinearGradient(
                colors: [Color(0xFFE040FB), Color(0xFF448AFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        border: !isGradient
            ? Border.all(color: Colors.white38, width: 1.5)
            : null,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Times New Roman',
        ),
      ),
    ),
  );
}
