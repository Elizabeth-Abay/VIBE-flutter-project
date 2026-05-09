import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/action_button.dart';

class EmailEntryScreen extends StatelessWidget {
  const EmailEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Join Vibe",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 40),
            const AuthTextField(
              label: "Email Address",
              errorText: "The account is already exists try to sign in",
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ActionButton(
                text: "",
                isArrow: true,
                onPressed: () => context.push('/verify'),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => context.push('/signin'),
              child: const Text(
                "Already have account? Sign in",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
