import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notification_notifier.dart';
import '../widgets/notification_card.dart';
import '../widgets/request_card.dart';

/// Fully live notification screen.
/// Replaces ALL hardcoded strings with data from Riverpod providers.
///
/// [activeTab] is driven by the router:
///   '/notifications'          → 'updates'
///   '/notifications/requests' → 'requests'
class NotificationScreen extends ConsumerWidget {
  final String activeTab;

  const NotificationScreen({super.key, this.activeTab = 'updates'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Badge counts for the tab labels
    final notificationsState = ref.watch(notificationsProvider);
    final requestsState = ref.watch(incomingRequestsProvider);

    final unreadCount = notificationsState is NotificationsLoaded
        ? notificationsState.unreadCount
        : 0;

    final pendingCount = requestsState is RequestsLoaded
        ? requestsState.requests.length
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1333),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ── Title row ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                        onPressed: () => context.pop(),
                      ),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Mark all read — only visible on updates tab
                  if (activeTab == 'updates' && unreadCount > 0)
                    TextButton.icon(
                      onPressed: () {
                        ref.read(notificationsProvider.notifier).markAllRead();
                      },
                      icon: const Icon(
                        Icons.done_all,
                        size: 16,
                        color: Color(0xFFBB86FC),
                      ),
                      label: const Text(
                        'Mark all read',
                        style: TextStyle(
                          color: Color(0xFFBB86FC),
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab toggle ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _TabButton(
                      label: 'Updates',
                      count: unreadCount,
                      isActive: activeTab == 'updates',
                      onTap: () => context.go('/notifications'),
                    ),
                    _TabButton(
                      label: 'Requests',
                      count: pendingCount,
                      isActive: activeTab == 'requests',
                      onTap: () => context.go('/notifications/requests'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Live content ────────────────────────────────────────────
            Expanded(
              child: activeTab == 'updates'
                  ? const _UpdatesList()
                  : const _RequestsList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Updates tab ─────────────────────────────────────────────────

class _UpdatesList extends ConsumerWidget {
  const _UpdatesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsProvider);

    if (state is NotificationsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFBB86FC)),
      );
    }

    if (state is NotificationsError) {
      return _ErrorView(
        message: state.message,
        onRetry: () {
          ref.read(notificationsProvider.notifier).fetch();
        },
      );
    }

    if (state is NotificationsLoaded) {
      if (state.items.isEmpty) {
        return const _EmptyView(
          icon: Icons.notifications_none_outlined,
          message: "You're all caught up!",
          subtitle: 'No new notifications.',
        );
      }

      return RefreshIndicator(
        color: const Color(0xFFBB86FC),
        onRefresh: () async {
          await ref.read(notificationsProvider.notifier).fetch();
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          itemCount: state.items.length,
          itemBuilder: (_, i) {
            return NotificationCard(notification: state.items[i]);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ─── Requests tab ────────────────────────────────────────────────

class _RequestsList extends ConsumerWidget {
  const _RequestsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(incomingRequestsProvider);

    if (state is RequestsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFBB86FC)),
      );
    }

    if (state is RequestsError) {
      return _ErrorView(
        message: state.message,
        onRetry: () {
          ref.read(incomingRequestsProvider.notifier).fetch();
        },
      );
    }

    if (state is RequestsLoaded) {
      if (state.requests.isEmpty) {
        return const _EmptyView(
          icon: Icons.person_add_outlined,
          message: 'No pending requests',
          subtitle: "When someone wants to connect, they'll show up here.",
        );
      }

      return RefreshIndicator(
        color: const Color(0xFFBB86FC),
        onRefresh: () async {
          await ref.read(incomingRequestsProvider.notifier).fetch();
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          itemCount: state.requests.length,
          itemBuilder: (_, i) {
            return RequestCard(request: state.requests[i]);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ─── Shared helper widgets ───────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFBB86FC) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white54,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),

                // Badge
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white.withOpacity(0.3)
                          : const Color(0xFFBB86FC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;

  const _EmptyView({
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white12, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_outlined, color: Colors.white24, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, color: Color(0xFFBB86FC), size: 18),
            label: const Text(
              'Retry',
              style: TextStyle(color: Color(0xFFBB86FC)),
            ),
          ),
        ],
      ),
    );
  }
}
