import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_notifier.dart';
import '../widgets/holder_cell.dart';

/// Shows the list of connected users — fully live via Riverpod.
class ConnectedScreen extends ConsumerWidget {
  const ConnectedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectedNotifierProvider);

    return switch (state) {
      ConnectedLoading() => const Center(child: CircularProgressIndicator()),

      ConnectedError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white38, size: 40),
              const SizedBox(height: 12),
              Text(message,
                  style: const TextStyle(color: Colors.white38, fontSize: 13)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    ref.read(connectedNotifierProvider.notifier).fetchConnected(),
                child: const Text('Retry',
                    style: TextStyle(color: Color(0xFFBB86FC))),
              ),
            ],
          ),
        ),

      ConnectedLoaded(:final users) when users.isEmpty => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, color: Colors.white24, size: 56),
              SizedBox(height: 12),
              Text('No connections yet',
                  style: TextStyle(color: Colors.white38, fontSize: 15)),
            ],
          ),
        ),

      ConnectedLoaded(:final users) => ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ConnectionHolderCell(
              user: user,
              // Heart tap goes to the notifier — state updates everywhere
              onHeartTap: () => ref
                  .read(connectedNotifierProvider.notifier)
                  .toggleLike(user.userId),
            );
          },
        ),

      _ => const SizedBox.shrink(),
    };
  }
}
