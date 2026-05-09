import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/action_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Vibe",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
              ),
            ),
            const Text("Sign in", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            const AuthTextField(label: "Email", hintText: "Enter email"),
            const SizedBox(height: 20),
            const AuthTextField(
              label: "Password",
              isPassword: true,
              errorText: "Incorrect email or password",
            ),
            const SizedBox(height: 40),
            ActionButton(text: "Sign in", onPressed: () {}),
            TextButton(
              onPressed: () => context.push('/login-email'),
              child: const Text(
                "Don't have account? Create Account",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
