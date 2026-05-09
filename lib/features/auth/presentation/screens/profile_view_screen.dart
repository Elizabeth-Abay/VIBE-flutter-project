import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      extendBody: true, // Allows the body to flow behind the floating nav bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Expanded width to allow the Vibe logo to be significantly larger
        leadingWidth: 500, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 12),
          child: Image.asset(
            'assets/images/image.png',
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.orangeAccent, size: 28),
          SizedBox(width: 15),
          Icon(Icons.person, color: Colors.blue, size: 28),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.purpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 80,
                    // Network image to avoid local asset web errors
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Bio",
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.purple.shade200.withValues(alpha: 0.5), 
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  "Passionate about robotics and programming, with a strong interest in building intelligent systems",
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const Divider(color: Colors.white24, height: 40, thickness: 1),
              const Text(
                "Interests",
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _interestChip("Programming"),
                  const SizedBox(width: 12),
                  _interestChip("Robotics"),
                ],
              ),
              const Divider(color: Colors.white24, height: 60, thickness: 1),
              _actionButton(
                text: "Edit Profile",
                isGradient: true,
                onTap: () => context.push('/edit-profile'),
              ),
              const SizedBox(height: 16),
              _actionButton(
                text: "Delete Account",
                isGradient: false,
                onTap: () => context.push('/delete-account'),
              ),
              const SizedBox(height: 120), // Extra space so content doesn't hide behind nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 4,
        onTap: (index) {
          // Navigation logic handled by GoRouter
        },
      ),
    );
  }

  Widget _interestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        "$label  X",
        style: const TextStyle(
          color: Colors.white70,
          fontFamily: 'Times New Roman',
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required bool isGradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isGradient
              ? const LinearGradient(
                  colors: [Color(0xFFE040FB), Color(0xFF448AFF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          border: !isGradient ? Border.all(color: Colors.white38, width: 1.5) : null,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Times New Roman',
          ),
        ),
      ),
    );
  }
}