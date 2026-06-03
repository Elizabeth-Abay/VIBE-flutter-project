import 'package:flutter/material.dart';
import '../../domain/entity/requests_sent_to_user.dart';
import 'cancel_request_btn.dart';

/// A single sent-request row — avatar, name, timestamp, cancel button.
class SentRequestHolderCell extends StatelessWidget {
  final RequestsSentToUser request;

  const SentRequestHolderCell({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16162E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Network image with initial fallback (no AssetImage)
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white12,
                backgroundImage: request.profileImg != ''
                    ? NetworkImage(request.profileImg!)
                    : null,
                child: request.profileImg != ''
                    ? Text(
                        request.name.isNotEmpty
                            ? request.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  request.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Cancel button now talks to SentRequestNotifier
          CancelRequestButton(userId: request.userId),
        ],
      ),
    );
  }
}
