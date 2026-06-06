import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_notifier.dart';
import '../providers/registration_session_notifier.dart';
import '../providers/user_name_unique_notifier.dart'; // ◄ New Import
import '../../domain/entities/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/action_button.dart';
import '../widgets/user_name_input.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController(); // ◄ Added Name controller
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
        context.go('/sign-up-email-enter');
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
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccount() async {
    setState(() => _errorMessage = null);

    final session = ref.read(registrationSessionProvider);
    final usernameState = ref.read(usernameCheckProvider);

    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = session.email ?? _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    // ── Pre-Submit Validation Validations ────────────────────────────────────
    if (!session.otpVerified) {
      setState(
        () =>
            _errorMessage = 'Please verify your email with the OTP code first.',
      );
      return;
    }

    if (usernameState is! UsernameAvailable) {
      setState(
        () => _errorMessage = 'Please choose an available unique username.',
      );
      return;
    }

    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
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

    // ── Trigger Endpoint /enter-user-info-first-time ─────────────────────────
    await ref
        .read(authNotifierProvider.notifier)
        .signUp(username: username, password: password, name: name);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(registrationSessionProvider);
    final usernameState = ref.watch(usernameCheckProvider);

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next is AuthStateAuthenticated) {
        ref.read(registrationSessionProvider.notifier).clear();
        ref.read(usernameCheckProvider.notifier).reset();
        FocusManager.instance.primaryFocus?.unfocus();

        // 🏠 Navigate here safely now that we KNOW registration succeeded
        if (context.mounted) {
          context.go('/interest-selection');
        }
      } else if (next is AuthStateError) {
        if (!context.mounted) return;
        setState(() => _errorMessage = next.message);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthStateLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join Vibe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Complete your Profile Setup',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white54),
              ),
              if (session.email != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      color: Colors.greenAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Verified: ${session.email}',
                      style: TextStyle(
                        color: Colors.green.shade300,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 40),

              // 📝 Name Input Box
              AuthTextField(
                label: 'Full Name',
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),

              // 🏷️ Username Input Box with Real-time Async Checking
              UsernameInputField(controller: _usernameController),

              // 🚦 Sub-Widget: Dynamic Username Feedback Builder
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Builder(
                  builder: (context) {
                    if (usernameState is UsernameChecking) {
                      return Row(
                        children: const [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Checking system availability...',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    }
                    if (usernameState is UsernameAvailable) {
                      return Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.greenAccent,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            usernameState.message,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }
                    if (usernameState is UsernameUnavailable) {
                      return Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            usernameState.message,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ✉️ Locked Verified Email Box
              AuthTextField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: _emailLocked,
              ),
              const SizedBox(height: 20),

              // 🔒 Password Input Box
              AuthTextField(
                label: 'Password',
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),

              // 🔒 Confirm Password Input Box
              AuthTextField(
                label: 'Confirm Password',
                isPassword: true,
                controller: _confirmPasswordController,
                errorText: _errorMessage,
              ),
              const SizedBox(height: 40),

              // 🚀 Submission Call Action Button
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF40E5),
                      ),
                    )
                  : ActionButton(
                      text: 'Create Account',
                      onPressed: _onCreateAccount,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
