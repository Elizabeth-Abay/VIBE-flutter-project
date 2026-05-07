import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcome2Screen extends StatelessWidget {
  const Welcome2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F2C), // dark blue background
      body: GestureDetector(
        onTap: () => context.push('/welcome3'),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔹 TOP IMAGE
              Image.asset('assets/images/image2.png', height: 220),

              const SizedBox(height: 40),

              /// 🔹 TITLE
              const Text(
                "Real Connections",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              /// 🔹 SUBTITLE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Building genuine relationships with people who truly get your vibe.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),

              const SizedBox(height: 60),

              /// 🔹 DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(false),
                  _dot(true), // active page
                  _dot(false),
                  _dot(false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 DOT WIDGET
  Widget _dot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.purple : Colors.white38,
        shape: BoxShape.circle,
      ),
    );
  }
}
