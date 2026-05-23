import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_notifier.dart';

/// Cancel / Request-Again button — wired to SentRequestNotifier.
/// Uses optimistic UI: state updates immediately, network call follows.
class CancelRequestButton extends ConsumerWidget {
  final String userId;
  final bool initialStatus; // true = already cancelled

  const CancelRequestButton({
    super.key,
    required this.userId,
    required this.initialStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Derive current cancelled status from live provider state.
    final state = ref.watch(sentRequestNotifierProvider);
    bool isCancelled = initialStatus;

    if (state is SentRequestLoaded) {
      final match = state.requests.where((r) => r.userId == userId);
      if (match.isNotEmpty) isCancelled = match.first.isCancelled;
    }

    return GestureDetector(
      onTap: () =>
          ref.read(sentRequestNotifierProvider.notifier).cancelRequest(userId),
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
          child: Text(
            isCancelled ? 'Request-Again' : 'Cancel',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
