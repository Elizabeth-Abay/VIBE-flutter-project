import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/notification_card.dart';
import '../widgets/request_card.dart';

class NotificationScreen extends StatelessWidget {
  final String activeTab; // 'updates' or 'requests'

  const NotificationScreen({super.key, this.activeTab = 'updates'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1333),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Notifications",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            // The toggle widget would go here
            _buildToggle(context),
            const SizedBox(height: 20),
            Expanded(
              child: activeTab == 'updates'
                  ? _buildUpdates()
                  : _buildRequests(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(BuildContext context) {
    // You can use GoRouter to switch tabs here
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => context.go('/notifications'),
          child: Text(
            "Updates",
            style: TextStyle(
              color: activeTab == 'updates' ? Colors.purple : Colors.grey,
            ),
          ),
        ),
        TextButton(
          onPressed: () => context.go('/notifications/requests'),
          child: Text(
            "Requests",
            style: TextStyle(
              color: activeTab == 'requests' ? Colors.purple : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdates() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        NotificationCard(text: "Abebe accepted your request", time: "2m ago"),
        NotificationCard(text: "Selam accepted your request", time: "3m ago"),
      ],
    );
  }

  Widget _buildRequests() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        RequestCard(name: "Selam", time: "2m ago"),
        RequestCard(name: "Abebe", time: "10m ago"),
      ],
    );
  }
}
