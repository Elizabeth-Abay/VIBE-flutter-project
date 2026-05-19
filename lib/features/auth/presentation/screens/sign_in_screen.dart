import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_notifier.dart';
import '../../domain/entities/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/action_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    setState(() => _errorMessage = null);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email and password.');
      return;
    }

    await ref.read(authNotifierProvider.notifier).signIn(
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes and navigate when authenticated.
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next is AuthStateAuthenticated) {
        context.go('/home');
      } else if (next is AuthStateError) {
        setState(() => _errorMessage = next.message);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthStateLoading;

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

            AuthTextField(
              label: "Email",
              hintText: "Enter email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            AuthTextField(
              label: "Password",
              isPassword: true,
              controller: _passwordController,
              errorText: _errorMessage,
            ),
            const SizedBox(height: 40),

            // Show spinner while loading, button otherwise.
            isLoading
                ? const CircularProgressIndicator()
                : ActionButton(
                    text: "Sign in",
                    onPressed: _onSignIn,
                  ),

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
