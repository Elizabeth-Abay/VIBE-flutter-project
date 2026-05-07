import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String text;
  final String time;

  const NotificationCard({super.key, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xff1B1E4A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purple.withOpacity(.35)),
      ),
      child: Text(
        "$text • $time",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
