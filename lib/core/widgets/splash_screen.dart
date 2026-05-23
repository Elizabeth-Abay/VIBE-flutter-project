import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shown while AuthNotifier checks for a saved token in secure storage.
/// Prevents a flash of the sign-in screen on app launch.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VibeColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / wordmark
            ShaderMask(
              shaderCallback: (bounds) =>
                  VibeColors.primaryGradient.createShader(bounds),
              child: const Text(
                'Vibe',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                  color: Colors.white, // masked by gradient
                ),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(VibeColors.primary),
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
