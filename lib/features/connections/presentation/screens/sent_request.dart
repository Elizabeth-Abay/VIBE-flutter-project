import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_notifier.dart';
import '../widgets/sent_request_holder.dart';

/// Sent requests list — driven by SentRequestNotifier (cache-first).
class SentRequestsListContainer extends ConsumerWidget {
  const SentRequestsListContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sentRequestNotifierProvider);

    return switch (state) {
      SentRequestLoading() => const Center(child: CircularProgressIndicator()),
      SentRequestError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white38, size: 36),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(sentRequestNotifierProvider.notifier).fetchSent(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      SentRequestLoaded(:final requests) when requests.isEmpty => const Center(
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
      ),
      SentRequestLoaded(:final requests) => ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: requests.length,
        itemBuilder: (context, index) =>
            SentRequestHolderCell(request: requests[index]),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
