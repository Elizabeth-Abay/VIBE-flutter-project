import 'package:flutter/material.dart';
import '../../../../core/theme/vibe_theme.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            'Delete your account ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Text(
              'Are you sure you want to delete your account?\nPlease be aware that this action is permanent and cannot be undone.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 80),
          // Red Delete Button
          Center(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: VibeColors.card,
                    title: const Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
                    content: const Text('This action cannot be undone.', style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: 260,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFAC0000), // Darker red as in image
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(flex: 3), 
        ],
      ),
    );
  }
}
