import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_notifier.dart';
import '../../domain/entities/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/action_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccount() async {
    setState(() => _errorMessage = null);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    // ── Local validation ──────────────────────────────────────────────────
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'All fields are required.');
      return;
    }
    if (password.length < 8) {
      setState(
          () => _errorMessage = 'Password must have at least 8 characters.');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    await ref.read(authNotifierProvider.notifier).signUp(
          username: username,
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Navigate on success, show error on failure.
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next is AuthStateAuthenticated) {
        context.go('/interest-selection');
      } else if (next is AuthStateError) {
        setState(() => _errorMessage = next.message);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthStateLoading;

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
              "Sign Up",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              label: "User Name",
              controller: _usernameController,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              label: "Email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              label: "Password",
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              label: "Confirm Password",
              isPassword: true,
              controller: _confirmPasswordController,
              errorText: _errorMessage,
            ),
            const SizedBox(height: 40),
            isLoading
                ? const CircularProgressIndicator()
                : ActionButton(
                    text: "Create Account",
                    onPressed: _onCreateAccount,
                  ),
          ],
        ),
      ),
    );
  }
}
