import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/utils/safe_navigation.dart';
import '../providers/email_entry_notifier.dart';
import '../providers/registration_session_notifier.dart';
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
        ref.read(registrationSessionProvider.notifier).setEmail(next.email);
        unfocusAndNavigate(context, (router) {
          router.push('/verify?email=${Uri.encodeComponent(next.email)}');
        });
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
            if (ApiClient.isMockMode) ...[
              const SizedBox(height: 8),
              Text(
                'Dev mode: OTP is ${ApiConfig.mockOtpCode}',
                style: TextStyle(
                  color: Colors.purple.shade200,
                  fontSize: 12,
                ),
              ),
            ],
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
