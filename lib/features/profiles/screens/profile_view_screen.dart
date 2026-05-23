import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../presentation/providers/profile_notifier.dart';

class ProfileViewScreen extends ConsumerWidget {
  /// When true, shown inside [MainNavigation] without a nested [Scaffold].
  final bool embedded;

  const ProfileViewScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);

    final body = switch (state) {
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
      ProfileUpdated(:final profile) =>
        _ProfileBody(profile: profile),
      _ => const SizedBox.shrink(),
    };

    if (embedded) {
      return ColoredBox(
        color: const Color(0xFF0A0E21),
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: body,
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final dynamic profile;
  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: UserAvatar(
                imageUrl: profile.avatarUrl,
                name: profile.username as String,
                radius: 64,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '@${profile.username}',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                profile.bio ?? 'No bio yet. Tap Edit Profile to add one.',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            if (profile.vibes.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Interests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (profile.vibes as Map<String, String>)
                    .entries
                    .map((e) => Chip(
                          label: Text('${e.key} (${e.value})'),
                          backgroundColor: Colors.white10,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 32),
            _actionButton(
              context,
              text: 'Edit Profile',
              filled: true,
              onTap: () => context.push('/profile/edit'),
            ),
            const SizedBox(height: 12),
            _actionButton(
              context,
              text: 'Settings',
              filled: false,
              onTap: () => context.push('/settings'),
            ),
            const SizedBox(height: 12),
            _actionButton(
              context,
              text: 'Delete Account',
              filled: false,
              onTap: () => context.push('/profile/delete'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String text,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: filled ? const Color(0xFF7C3AED) : Colors.transparent,
          foregroundColor: Colors.white,
          side: filled ? null : const BorderSide(color: Colors.white38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
