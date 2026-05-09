import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final String name;
  final String time;

  const RequestCard({super.key, required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text("$name • $time", style: const TextStyle(color: Colors.white)),
    );
  }
}
