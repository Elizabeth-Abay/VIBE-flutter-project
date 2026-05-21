import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Incoming connection request card with Accept / Decline actions.
class RequestCard extends ConsumerStatefulWidget {
  final String name;
  final String time;
  final String? profileImage;

  const RequestCard({
    super.key,
    required this.name,
    required this.time,
    this.profileImage,
  });

  @override
  ConsumerState<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<RequestCard> {
  bool _acted = false;
  String _actionLabel = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _acted
          // After acting: show confirmation message
          ? Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _actionLabel,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            )
          : Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF7C3AED).withOpacity(0.3),
                  backgroundImage:
                      widget.profileImage != null &&
                          widget.profileImage!.startsWith('http')
                      ? NetworkImage(widget.profileImage!)
                      : null,
                  child:
                      widget.profileImage == null ||
                          !widget.profileImage!.startsWith('http')
                      ? Text(
                          widget.name.isNotEmpty
                              ? widget.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // Name + time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        widget.time,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Accept button
                TextButton(
                  onPressed: _onAccept,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED).withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Color(0xFFBB86FC)),
                  ),
                ),
                const SizedBox(width: 6),

                // Decline button
                TextButton(
                  onPressed: _onDecline,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
              ],
            ),
    );
  }

  void _onAccept() {
    setState(() {
      _acted = true;
      _actionLabel = 'You are now connected with ${widget.name}';
    });
  }

  void _onDecline() {
    setState(() {
      _acted = true;
      _actionLabel = 'Request from ${widget.name} declined';
    });
  }
}
