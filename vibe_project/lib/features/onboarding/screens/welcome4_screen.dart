import 'package:flutter/material.dart';

class Welcome4Screen extends StatelessWidget {
  const Welcome4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F2C),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🔹 LOCK IMAGE
            Image.asset(
              'assets/images/image4.png', // your lock image
              height: 200,
            ),

            const SizedBox(height: 40),

            /// 🔹 TITLE
            const Text(
              "Safe & Secure",
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
                "Your privacy and safety are our top priorities",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

            const SizedBox(height: 60),

            /// 🔹 START BUTTON
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: navigate to home/login
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Colors.pink, Colors.purple, Colors.blue],
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(minHeight: 50),
                    child: const Text(
                      "Start Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
