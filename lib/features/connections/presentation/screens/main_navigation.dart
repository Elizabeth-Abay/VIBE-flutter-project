import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_notifier.dart';
import '../widgets/connection_toggle.dart';
import 'connected_screen.dart';
import 'sent_request.dart';

/// Connections main layout — replaces all mock data with live providers.
/// Tab 0 = Connected users, Tab 1 = Sent requests.
class ConnectionsMainLayout extends ConsumerStatefulWidget {
  const ConnectionsMainLayout({super.key});

  @override
  ConsumerState<ConnectionsMainLayout> createState() =>
      _ConnectionsMainLayoutState();
}

class _ConnectionsMainLayoutState
    extends ConsumerState<ConnectionsMainLayout> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050517),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Title
            const Text(
              'Connections',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Toggle bar (Connected / Sent-Requests)
            ConnectionsToggle(
              onToggle: (index) => setState(() => _activeTab = index),
            ),

            const SizedBox(height: 10),

            // Live content area
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _activeTab == 0
                    ? const ConnectedScreen(key: ValueKey('connected'))
                    : const SentRequestScreen(key: ValueKey('sent')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
