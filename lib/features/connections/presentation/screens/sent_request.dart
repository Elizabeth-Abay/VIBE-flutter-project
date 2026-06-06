import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/request_provider.dart';
import '../widgets/sent_request_holder.dart';

/// Sent requests list — dynamically handles async states via standard AsyncValue matching.
class SentRequestsListContainer extends ConsumerWidget {
  const SentRequestsListContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 FIX: Changed variable target name to match your exact provider name 'sentRequestsProvider'
    final state = ref.watch(sentRequestsProvider);

    return state.when(
      // ── 1. Loading State ───────────────────────────────────────────────────
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE186FF)),
        ),
      ),

      // ── 2. Error State ─────────────────────────────────────────────────────
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white38, size: 36),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: Colors.white38, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              // 🎯 FIX: Updated the invalidation target to clear the correct cache stream
              onPressed: () => ref.invalidate(sentRequestsProvider),
              child: const Text(
                'Retry',
                style: TextStyle(color: Color(0xFFBB86FC)),
              ),
            ),
          ],
        ),
      ),

      // ── 3. Data Loaded Success State ───────────────────────────────────────
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.send_outlined, color: Colors.white24, size: 48),
                SizedBox(height: 12),
                Text(
                  'No sent requests',
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 20,
            left: 16,
            right: 16,
          ),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return SentRequestHolderCell(request: requests[index]);
          },
        );
      },
    );
  }
}
