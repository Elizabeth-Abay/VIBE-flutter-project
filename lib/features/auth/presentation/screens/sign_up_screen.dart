import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/action_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Column(
          children: [
            const Text(
              "Join Vibe",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Sign UP",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            const AuthTextField(
              label: "User Name",
              successText: "selu1255 is available",
            ),
            const SizedBox(height: 20),
            const AuthTextField(label: "Password", isPassword: true),
            const SizedBox(height: 20),
            const AuthTextField(
              label: "Confirm Password",
              isPassword: true,
              errorText: "password must have at least 8 characters",
            ),
            const SizedBox(height: 40),
            ActionButton(text: "Create Account", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
