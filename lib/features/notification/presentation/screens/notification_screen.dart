import 'package:flutter/material.dart';
import '../widgets/notification_card.dart';
import '../widgets/request_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1333),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Notifications",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),

            const SizedBox(height: 20),

            Expanded(child: isUpdates ? buildUpdates() : buildRequests()),
          ],
        ),
      ),
    );
  }

  Widget buildUpdates() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        NotificationCard(text: "Abebe accepted your request", time: "2m ago"),
        NotificationCard(text: "Selam accepted your request", time: "3m ago"),
      ],
    );
  }

  Widget buildRequests() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        RequestCard(name: "Selam", time: "2m ago"),
        RequestCard(name: "Abebe", time: "10m ago"),
      ],
    );
  }
}
