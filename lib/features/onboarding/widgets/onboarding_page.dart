import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onNext;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1333),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: Colors.white),
            const SizedBox(height: 40),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: onNext, child: const Text("Next")),
          ],
        ),
      ),
    );
  }
}
