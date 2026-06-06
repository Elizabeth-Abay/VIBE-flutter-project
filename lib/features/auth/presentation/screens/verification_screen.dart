import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/utils/safe_navigation.dart';
import '../providers/registration_session_notifier.dart';
import '../providers/verification_notifier.dart';
import '../widgets/action_button.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  /// The email to verify — passed as a query param from EmailEntryScreen.
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  // One controller per OTP digit.
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationSessionProvider.notifier).setEmail(widget.email);
    });
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _onVerify() async {
    await ref
        .read(verificationProvider.notifier)
        .verifyOtp(email: widget.email, otp: _otp);
  }

  Future<void> _onResend() async {
    await ref.read(verificationProvider.notifier).resendOtp(widget.email);
  }

  // Auto-focus the next box when a digit is typed.
  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // Auto-submit when last digit filled.
    if (index == 5 && value.isNotEmpty) {
      _onVerify();
    }
  }

  // Move back on delete.
  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<VerificationState>(verificationProvider, (_, next) {
      if (next is VerificationSuccess) {
        ref.read(registrationSessionProvider.notifier).markOtpVerified();
        unfocusAndNavigate(context, (router) {
          router.go(
            '/enter-user-info-first?email=${Uri.encodeComponent(widget.email)}',
          );
        });
      } else if (next is VerificationResent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code resent! Check your inbox.')),
        );
      }
    });

    final state = ref.watch(verificationProvider);
    final isLoading = state is VerificationLoading;
    final errorText = state is VerificationError ? state.message : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verify your Email",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "We sent a 6-digit code to\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            if (ApiConfig.useMockBackend) ...[
              const SizedBox(height: 8),
              Text(
                '',
                style: TextStyle(color: Colors.purple.shade200, fontSize: 12),
              ),
            ],
            const SizedBox(height: 40),

            // ── OTP boxes ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) => _onKeyEvent(event, index),
                  child: SizedBox(
                    width: 42,
                    height: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      maxLength: 1,
                      onChanged: (v) => _onDigitChanged(v, index),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: errorText != null
                            ? Colors.red.withOpacity(0.15)
                            : Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: errorText != null
                              ? const BorderSide(color: Colors.red)
                              : BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF40E5),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            // ── Error message ─────────────────────────────────────────────
            if (errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],

            const SizedBox(height: 40),

            // ── Verify button ─────────────────────────────────────────────
            isLoading
                ? const CircularProgressIndicator()
                : ActionButton(text: "Verify Email", onPressed: _onVerify),

            // ── Resend link ───────────────────────────────────────────────
            TextButton(
              onPressed: isLoading ? null : _onResend,
              child: const Text(
                "Resend Code",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
