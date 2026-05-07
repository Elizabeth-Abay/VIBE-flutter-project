import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String text;
  final String time;

  const NotificationCard({super.key, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text("$text • $time", style: const TextStyle(color: Colors.white)),
    );
  }
}
