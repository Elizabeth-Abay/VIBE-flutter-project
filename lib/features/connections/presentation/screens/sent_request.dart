import 'package:flutter/material.dart';
import '../../domain/entity/sent_request_user.dart';

import 'package:flutter/material.dart';

class SentRequestScreen extends StatelessWidget {
  const SentRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Sent Requests Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

/// A single sent-request card with live Cancel / Request-Again button.
class SentRequestHolderCell extends StatelessWidget {
  final SentRequestUser request;
  final VoidCallback onCancel;
  final VoidCallback onRequestAgain;

  const SentRequestHolderCell({
    super.key,
    required this.request,
    required this.onCancel,
    required this.onRequestAgain,
  });

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
              // Avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF7C3AED).withOpacity(0.3),
                backgroundImage: request.profileImage.startsWith('http')
                    ? NetworkImage(request.profileImage)
                    : null,
                child: !request.profileImage.startsWith('http')
                    ? Text(
                        request.name.isNotEmpty
                            ? request.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
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
              Text(
                request.timestamp,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Cancel / Request-Again button — reads state from entity
          GestureDetector(
            onTap: request.isCancelled ? onRequestAgain : onCancel,
            child: Container(
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE186FF), Color(0xFF6E85E3)],
                ),
              ),
              child: Center(
                child: Text(
                  request.isCancelled ? 'Request-Again' : 'Cancel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
