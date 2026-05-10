import 'package:flutter/material.dart';
import '../../domain/entity/sent_request_user.dart';
import '../widgets/sent_request_holder.dart';

class SentRequestsListContainer extends StatelessWidget {
  final List<SentRequestUser> requests;

  const SentRequestsListContainer({
    super.key,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Padding matches the visual spacing in image_930a1d.png
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return SentRequestHolderCell(request: request);
      },
    );
  }
}