import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/connection_toggle.dart';
import './connected_screen.dart';
import './sent_request.dart';
import '../providers/connection_notifier.dart';

class ConnectionsMainLayout extends ConsumerStatefulWidget {
  const ConnectionsMainLayout({super.key});

  @override
  ConsumerState<ConnectionsMainLayout> createState() =>
      _ConnectionsMainLayoutState();
}

class _ConnectionsMainLayoutState extends ConsumerState<ConnectionsMainLayout> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    // Watches the existing cached list or initiates the initial build fetch
    final connectionsAsync = ref.watch(connectionsFeedProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF050517),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              'Connections',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            ConnectionsToggle(
              onToggle: (index) {
                setState(() => _activeTab = index);

                // ─── Trigger Fetch on Tab Click ─────────────────────────────
                // If the user clicks the "Connections" tab (index 0),
                // bypass the cache and force a new network request.
                if (index == 0) {
                  ref.refresh(connectionsFeedProvider);
                }
              },
            ),

            const SizedBox(height: 10),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _activeTab == 0
                    ? const ConnectionsListContainer()
                    : const SentRequestsListContainer(
                        key: ValueKey('sent_requests'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
