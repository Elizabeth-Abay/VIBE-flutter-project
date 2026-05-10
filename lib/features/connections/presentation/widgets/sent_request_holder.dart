import 'package:flutter/material.dart';
import '../../domain/entity/sent_request_user.dart';
import './cancel_request_btn.dart';


class SentRequestHolderCell extends StatelessWidget {
  final SentRequestUser request;

  const SentRequestHolderCell({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16162E), // Card color from image
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage(request.profileImage),
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
          CancelRequestButton(
            userId: request.userId,
            initialStatus: request.isCancelled,
          ),
        ],
      ),
    );
  }
}