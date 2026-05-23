import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/email_entry_notifier.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/action_button.dart';

class EmailEntryScreen extends ConsumerStatefulWidget {
  const EmailEntryScreen({super.key});

  @override
  ConsumerState<EmailEntryScreen> createState() => _EmailEntryScreenState();
}

class _EmailEntryScreenState extends ConsumerState<EmailEntryScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    ref.read(emailEntryProvider.notifier).reset();
    super.dispose();
  }

  Future<void> _onNext() async {
    await ref
        .read(emailEntryProvider.notifier)
        .submitEmail(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    // Navigate to verify screen when OTP is sent successfully.
    ref.listen<EmailEntryState>(emailEntryProvider, (_, next) {
      if (next is EmailEntrySuccess) {
        // Pass the email as a query param so VerificationScreen can use it.
        context.push('/verify?email=${Uri.encodeComponent(next.email)}');
      }
    });

    final state = ref.watch(emailEntryProvider);
    final isLoading = state is EmailEntryLoading;
    final errorText = state is EmailEntryError ? state.message : null;

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
            const SizedBox(height: 8),
            const Text(
              "Enter your email to get started",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 40),

            AuthTextField(
              label: "Email Address",
              hintText: "you@example.com",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: errorText,
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: isLoading
                  ? const SizedBox(
                      width: 60,
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ActionButton(text: "", isArrow: true, onPressed: _onNext),
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
