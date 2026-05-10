import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcome3Screen extends StatelessWidget {
  const Welcome3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F2C),
      body: GestureDetector(
        onTap: () => context.push('/welcome4'),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔹 STAR IMAGE (replace icon)
              Image.asset('assets/images/image3.png', height: 200),

              const SizedBox(height: 40),

              /// 🔹 TITLE
              const Text(
                "Interest - Based",
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
                  "Connect over what you love- from hobbies to passions",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),

              const SizedBox(height: 60),

              /// 🔹 DOT INDICATOR (3rd active)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(false),
                  _dot(false),
                  _dot(true), // active page
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
