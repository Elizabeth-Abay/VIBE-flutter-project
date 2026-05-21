import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notification_notifier.dart';
import '../widgets/notification_card.dart';
import '../widgets/request_card.dart';

/// Notifications screen — fully wired to live providers.
/// Tab 'updates' shows activity, tab 'requests' shows incoming connection requests.
class NotificationScreen extends ConsumerWidget {
  final String activeTab;

  const NotificationScreen({super.key, this.activeTab = 'updates'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1333),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Notifications',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            _buildToggle(context),
            const SizedBox(height: 20),
            Expanded(
              child: activeTab == 'updates' ? _UpdatesList() : _RequestsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => context.go('/notifications'),
          child: Text(
            'Updates',
            style: TextStyle(
              color: activeTab == 'updates'
                  ? const Color(0xFFBB86FC)
                  : Colors.grey,
              fontWeight:
                  activeTab == 'updates' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        TextButton(
          onPressed: () => context.go('/notifications/requests'),
          child: Text(
            'Requests',
            style: TextStyle(
              color: activeTab == 'requests'
                  ? const Color(0xFFBB86FC)
                  : Colors.grey,
              fontWeight:
                  activeTab == 'requests' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Updates tab ─────────────────────────────────────────────────────────────

class _UpdatesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsProvider);

    return switch (state) {
      NotificationsLoading() =>
        const Center(child: CircularProgressIndicator()),
      NotificationsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white38, size: 40),
              const SizedBox(height: 8),
              Text(message,
                  style: const TextStyle(color: Colors.white38, fontSize: 13)),
              TextButton(
                onPressed: () =>
                    ref.read(notificationsProvider.notifier).fetch(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      NotificationsLoaded(:final items) when items.isEmpty => const Center(
          child: Text('No notifications yet',
              style: TextStyle(color: Colors.white38)),
        ),
      NotificationsLoaded(:final items) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final n = items[index];
            return NotificationCard(
              text: n.message,
              time: _timeAgo(n.createdAt),
              isRead: n.isRead,
              onTap: () =>
                  ref.read(notificationsProvider.notifier).markRead(n.id),
            );
          },
        ),
      _ => const SizedBox.shrink(),
    };
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ─── Requests tab ─────────────────────────────────────────────────────────────

class _RequestsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(incomingRequestsProvider);

    return switch (state) {
      RequestsLoading() => const Center(child: CircularProgressIndicator()),
      RequestsError(:final message) => Center(
          child: Text(message,
              style: const TextStyle(color: Colors.white38, fontSize: 13)),
        ),
      RequestsLoaded(:final requests) when requests.isEmpty => const Center(
          child: Text('No connection requests',
              style: TextStyle(color: Colors.white38)),
        ),
      RequestsLoaded(:final requests) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final r = requests[index];
            return RequestCard(
              name: r.name,
              time: _timeAgo(r.createdAt),
              profileImage: r.profileImage,
            );
          },
        ),
      _ => const SizedBox.shrink(),
    };
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
