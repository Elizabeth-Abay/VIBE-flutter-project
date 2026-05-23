import 'package:flutter/material.dart';
import '../widgets/connection_toggle.dart';
import './connected_screen.dart';
import './sent_request.dart';

/// Connections main layout — removes ALL mock data.
/// Content is fully driven by Riverpod providers.
class ConnectionsMainLayout extends StatefulWidget {
  const ConnectionsMainLayout({super.key});

  @override
  State<ConnectionsMainLayout> createState() => _ConnectionsMainLayoutState();
}

class _ConnectionsMainLayoutState extends State<ConnectionsMainLayout> {
  int _activeTab = 0; // 0 = Connected, 1 = Sent-Requests

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

            // Toggle (Connected | Sent-Requests)
            ConnectionsToggle(
              onToggle: (index) => setState(() => _activeTab = index),
            ),

            const SizedBox(height: 10),

            // Live content — no more mock lists
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _activeTab == 0
                    ? const ConnectionsListContainer() // ← live from Riverpod
                    : const SentRequestsListContainer(), // ← live from Riverpod
              ),
            ),
          ],
        ),
      ),
    );
  }
}
