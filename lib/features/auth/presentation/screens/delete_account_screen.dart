import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Increased leadingWidth to make the logo large as requested
        leadingWidth: 200, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Image.asset(
            'assets/images/image.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.orangeAccent),
          SizedBox(width: 15),
          Icon(Icons.person, color: Colors.blue),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Delete  your  account ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Are you sure you want to delete your account? Please be aware that this action is permanent and cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                // FIXED: Using withValues() instead of withOpacity()
                color: Colors.white.withValues(alpha: 0.7), 
                fontSize: 18,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 220,
                height: 65,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 4, 
        onTap: (index) {},
      ),
    );
  }
}