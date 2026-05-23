import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/notification_entity.dart';
import '../providers/notification_notifier.dart';

/// Replaces the old hardcoded `NotificationCard(text:, time:)`.
/// Now driven by a real [NotificationEntity] from Riverpod.
/// Tapping marks the notification as read (optimistic + API call).
class NotificationCard extends ConsumerWidget {
  final NotificationEntity notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          ref.read(notificationsProvider.notifier).markRead(notification.id);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notification.isRead
                ? Colors.transparent
                : const Color(0xFFBB86FC).withOpacity(0.45),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type icon ───────────────────────────────────────────────
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _iconBackground(notification.type),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconFor(notification.type),
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),

            // ── Message + time ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: notification.isRead
                          ? FontWeight.w400
                          : FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            // ── Unread dot ───────────────────────────────────────────────
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4, left: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFBB86FC),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  IconData _iconFor(String type) {
    return switch (type) {
      'connection_accepted' => Icons.people_alt_outlined,
      'connection_request' => Icons.person_add_outlined,
      'post_like' => Icons.favorite_border,
      'mention' => Icons.alternate_email,
      'post_comment' => Icons.chat_bubble_outline,
      _ => Icons.notifications_outlined,
    };
  }

  Color _iconBackground(String type) {
    return switch (type) {
      'connection_accepted' => const Color(0xFF3D5A99),
      'connection_request' => const Color(0xFF6A4C9C),
      'post_like' => const Color(0xFF9C2F5B),
      'mention' => const Color(0xFF2F7B6B),
      'post_comment' => const Color(0xFF5A3E8C),
      _ => const Color(0xFF3A3A5C),
    };
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
