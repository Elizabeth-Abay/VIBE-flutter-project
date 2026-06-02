import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/profile_notifier.dart';

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Navigate to signin when account is deleted
    ref.listen<ProfileState>(profileNotifierProvider, (_, next) {
      if (next is ProfileDeleted) {
        context.go('/sign-in');
      } else if (next is ProfileError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    final isLoading = ref.watch(profileNotifierProvider) is ProfileLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: 24),
            const Text(
              'Delete your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Are you sure you want to delete your account? '
              'This action is permanent and cannot be undone. '
              'All your posts and connections will be removed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 17,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 60),

            // ── Confirm delete ────────────────────────────────────────────
            isLoading
                ? const CircularProgressIndicator()
                : GestureDetector(
                    onTap: () => _confirmDelete(context, ref),
                    child: Container(
                      width: 220,
                      height: 65,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),

            // ── Cancel ────────────────────────────────────────────────────
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3D),
        title: const Text(
          'Are you absolutely sure?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Type "DELETE" to confirm.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(profileNotifierProvider.notifier).deleteAccount();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
