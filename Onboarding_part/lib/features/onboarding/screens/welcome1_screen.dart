import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcome1Screen extends StatelessWidget {
  const Welcome1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1333), // dark blue background
      body: GestureDetector(
        onTap: () => context.push('/welcome2'),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 🔹 TOP SPACE
              const SizedBox(height: 40),

              /// 🔹 ICON SECTION (center)
              Column(
                children: [Image.asset('assets/images/image1.png', width: 200)],
              ),

              /// 🔹 TEXT SECTION
              Column(
                children: const [
                  Text(
                    "Smart Matching",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "our algorithm matches you based on shared interest and compatibility scores",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),

              /// 🔹 DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDot(true),
                  buildDot(false),
                  buildDot(false),
                  buildDot(false),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 DOT BUILDER
  static Widget buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.purple : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
