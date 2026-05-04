import 'package:flutter/material.dart';

class PersonRecommendationCard extends StatelessWidget {
  final String userId;
  final String name;
  final String? userProfileImageUrl;

  const PersonRecommendationCard({
    required this.userId,
    required this.name,
    this.userProfileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // We "watch" the state of this specific user from the controller
    final userStatus = context.watch<UserProvider>().getStatus(userId);

    return Row(
      children: [
        Text(name),
        const Spacer(),
        ElevatedButton(
          onPressed: (userStatus == Status.loading || userStatus == Status.sent)
              ? null
              : () => context.read<UserProvider>().connect(userId),
          child: _buildButtonContent(userStatus),
        ),
      ],
    );
  }

  // Helper to keep the build method clean
  Widget _buildButtonContent(Status status) {
    if (status == Status.loading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (status == Status.sent) {
      return const Text("Requested");
    }
    return const Text("Connect");
  }
}

class ConnectButton extends StatefulWidget {
  final String userId;
  final Future<void> Function(String) onConnect; // Function from Provider

  const ConnectButton({
    super.key,
    required this.userId,
    required this.onConnect,
  });

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  bool _localLoading = false;
  bool _isSent = false;

  void _handleTap() async {
    setState(() => _localLoading = true);

    try {
      // The widget triggers the logic, but the Provider OWNS the logic
      await widget.onConnect(widget.userId);

      setState(() {
        _localLoading = false;
        _isSent = true;
      });
    } catch (e) {
      setState(() => _localLoading = false);
      // Handle error...
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSent)
      return const Text("Requested", style: TextStyle(color: Colors.grey));

    return ElevatedButton(
      onPressed: _localLoading ? null : _handleTap,
      child: _localLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(),
            )
          : const Text("Connect"),
    );
  }
}
