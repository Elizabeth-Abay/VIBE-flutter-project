import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We wrap the entire body in a GestureDetector to detect touches
      body: GestureDetector(
        onTap: () {
          // 🔗 Navigates to the next screen on touch
          context.push('/welcome1');
        },
        child: Stack(
          children: [
            /// 🔹 Background Image (The only visible element)
            Positioned.fill(
              child: Image.asset('assets/images/vibe.jpg', fit: BoxFit.cover),
            ),

            /// 🔹 Transparent Overlay (Optional)
            /// I kept this but made it very subtle so the image is clear,
            /// but it ensures the tap is registered across the whole screen.
            Positioned.fill(child: Container(color: Colors.transparent)),
          ],
        ),
      ),
    );
  }
}
