import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/widgets/action_button.dart';

/// Welcome hub: Start Now → email entry, Sign In → login.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VibeColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(flex: 2),
              ShaderMask(
                shaderCallback: (bounds) =>
                    VibeColors.primaryGradient.createShader(bounds),
                child: const Text(
                  'Vibe',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Connect through what you love',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: VibeColors.textMuted,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 3),
              ActionButton(
                text: 'Start Now',
                onPressed: () => context.push('/sign-up-email-enter'),
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: 'Sign In',
                onPressed: () => context.push('/sign-in'),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
