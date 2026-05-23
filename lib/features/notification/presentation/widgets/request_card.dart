import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/notification_entity.dart';
import '../providers/notification_notifier.dart';

/// Replaces the old hardcoded `RequestCard(name:, time:)`.
/// Driven by a real [ConnectionRequestEntity] from Riverpod.
/// Shows Accept + Decline buttons that call the repository.
class RequestCard extends ConsumerStatefulWidget {
  final ConnectionRequestEntity request;

  const RequestCard({super.key, required this.request});

  @override
  ConsumerState<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<RequestCard> {
  _CardAction _action = _CardAction.idle;

  Future<void> _onAccept() async {
    setState(() => _action = _CardAction.accepting);
    final ok = await ref
        .read(incomingRequestsProvider.notifier)
        .acceptRequest(widget.request.requesterId);
    if (mounted) {
      setState(() => _action = ok ? _CardAction.accepted : _CardAction.idle);
    }
  }

  Future<void> _onDecline() async {
    setState(() => _action = _CardAction.declining);
    final ok = await ref
        .read(incomingRequestsProvider.notifier)
        .declineRequest(widget.request.requesterId);
    if (mounted) {
      setState(() => _action = ok ? _CardAction.declined : _CardAction.idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: _action == _CardAction.accepted
          ? _ResultRow(
              icon: Icons.check_circle_outline,
              color: Colors.green,
              message: 'You are now connected with ${widget.request.name}',
            )
          : _action == _CardAction.declined
          ? _ResultRow(
              icon: Icons.cancel_outlined,
              color: Colors.redAccent,
              message: 'Request from ${widget.request.name} declined',
            )
          : _MainContent(
              request: widget.request,
              isLoading: _action != _CardAction.idle,
              onAccept: _onAccept,
              onDecline: _onDecline,
            ),
    );
  }

  Color get _cardColor => switch (_action) {
    _CardAction.accepted => Colors.green.withOpacity(0.1),
    _CardAction.declined => Colors.red.withOpacity(0.08),
    _ => Colors.white.withOpacity(0.06),
  };
}

// ── Internal sub-widgets ──────────────────────────────────────────────────────

class _MainContent extends StatelessWidget {
  final ConnectionRequestEntity request;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _MainContent({
    required this.request,
    required this.isLoading,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Avatar + name row ─────────────────────────────────────────────
        Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF6A4C9C).withOpacity(0.4),
              backgroundImage: request.profileImageUrl != null
                  ? NetworkImage(request.profileImageUrl!)
                  : null,
              child: request.profileImageUrl == null
                  ? Text(
                      request.name.isNotEmpty
                          ? request.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Name + username + time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (request.username.isNotEmpty)
                    Text(
                      '@${request.username}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  Text(
                    _timeAgo(request.createdAt),
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ── Action buttons ────────────────────────────────────────────────
        isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Row(
                children: [
                  // Accept
                  Expanded(
                    child: GestureDetector(
                      onTap: onAccept,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFBB86FC), Color(0xFF6200EE)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Center(
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Decline
                  Expanded(
                    child: GestureDetector(
                      onTap: onDecline,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Center(
                          child: Text(
                            'Decline',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;

  const _ResultRow({
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message, style: TextStyle(color: color, fontSize: 14)),
        ),
      ],
    );
  }
}

// ── Enum for card action state ────────────────────────────────────────────────

enum _CardAction { idle, accepting, declining, accepted, declined }
