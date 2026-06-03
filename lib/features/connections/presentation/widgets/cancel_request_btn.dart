import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/request_provider.dart';

/// Cancel Button widget handling outgoing request mutations dynamically.
class CancelRequestButton extends ConsumerWidget {
  /// The unique database target user ID field (`user_id`).
  final String userId;

  const CancelRequestButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 Watches action loading state to throttle multi-taps cleanly
    final actionState = ref.watch(requestActionNotifierProvider);
    final isLoading = actionState.isLoading;

    return GestureDetector(
      onTap: isLoading
          ? null // Freeze button interactions while network requests are flying
          : () async {
              final success = await ref
                  .read(requestActionNotifierProvider.notifier)
                  .cancelExistingRequest(userId);

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connection request withdrawn successfully.'),
                    backgroundColor: Color(0xFF6E85E3),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
      child: Opacity(
        opacity: isLoading ? 0.6 : 1.0,
        child: Container(
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [Color(0xFFE186FF), Color(0xFF6E85E3)],
            ),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
