import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_notifier.dart';
import '../providers/registration_session_notifier.dart';
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
  bool _emailLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _applyHeldEmail());
  }

  void _applyHeldEmail() {
    final session = ref.read(registrationSessionProvider);
    final fromRoute =
        GoRouterState.of(context).uri.queryParameters['email'] ?? '';

    final email = (session.email ?? fromRoute).trim();
    if (email.isEmpty) {
      if (!session.otpVerified) {
        context.go('/login-email');
      }
      return;
    }

    if (session.email == null || session.email!.isEmpty) {
      ref.read(registrationSessionProvider.notifier).setEmail(email);
    }

    _emailController.text = email;
    setState(() => _emailLocked = true);
  }

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

    final session = ref.read(registrationSessionProvider);
    final username = _usernameController.text.trim();
    final email = session.email ?? _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (!session.otpVerified) {
      setState(
        () => _errorMessage =
            'Please verify your email with the OTP code first.',
      );
      return;
    }

    if (session.email != null && session.email != email) {
      setState(
        () => _errorMessage = 'Email must match the address you verified.',
      );
      return;
    }

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'All fields are required.');
      return;
    }
    if (password.length < 8) {
      setState(
        () => _errorMessage = 'Password must have at least 8 characters.',
      );
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
    final session = ref.watch(registrationSessionProvider);

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next is AuthStateAuthenticated) {
        ref.read(registrationSessionProvider.notifier).clear();
        FocusManager.instance.primaryFocus?.unfocus();
        // GoRouter redirect in auth_guard sends authenticated users to /home.
      } else if (next is AuthStateError) {
        if (!context.mounted) return;
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
              'Join Vibe',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            if (session.email != null) ...[
              const SizedBox(height: 8),
              Text(
                'Verified: ${session.email}',
                style: TextStyle(color: Colors.green.shade300, fontSize: 12),
              ),
            ],
            const SizedBox(height: 40),
            AuthTextField(label: 'User Name', controller: _usernameController),
            const SizedBox(height: 20),
            AuthTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              readOnly: _emailLocked,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              label: 'Password',
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              label: 'Confirm Password',
              isPassword: true,
              controller: _confirmPasswordController,
              errorText: _errorMessage,
            ),
            const SizedBox(height: 40),
            isLoading
                ? const CircularProgressIndicator()
                : ActionButton(
                    text: 'Create Account',
                    onPressed: _onCreateAccount,
                  ),
          ],
        ),
      ),
    );
  }
}
