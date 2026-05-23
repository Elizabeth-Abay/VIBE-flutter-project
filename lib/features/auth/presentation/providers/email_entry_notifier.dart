import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class EmailEntryState {
  const EmailEntryState();
}

class EmailEntryInitial extends EmailEntryState {
  const EmailEntryInitial();
}

class EmailEntryLoading extends EmailEntryState {
  const EmailEntryLoading();
}

/// OTP was sent successfully — carry the email forward to the verify screen.
class EmailEntrySuccess extends EmailEntryState {
  final String email;
  const EmailEntrySuccess(this.email);
}

class EmailEntryError extends EmailEntryState {
  final String message;
  const EmailEntryError(this.message);
}

// ── Provider ──────────────────────────────────────────────────────────────────

final emailEntryProvider =
    NotifierProvider<EmailEntryNotifier, EmailEntryState>(
      EmailEntryNotifier.new,
    );

// ── Notifier ──────────────────────────────────────────────────────────────────

class EmailEntryNotifier extends Notifier<EmailEntryState> {
  @override
  EmailEntryState build() => const EmailEntryInitial();

  /// Checks if the email is available and sends an OTP.
  Future<void> submitEmail(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      state = const EmailEntryError('Please enter a valid email address.');
      return;
    }

    state = const EmailEntryLoading();

    try {
      await ApiClient.instance.post(
        '/auth/send-otp',
        body: {'email': email},
        auth: false,
      );
      state = EmailEntrySuccess(email);
    } on ApiException catch (e) {
      if (e.statusCode == 409) {
        state = const EmailEntryError(
          'This account already exists. Try signing in.',
        );
      } else {
        state = EmailEntryError(e.message);
      }
    } catch (_) {
      state = const EmailEntryError('Network error. Please try again.');
    }
  }

  void reset() => state = const EmailEntryInitial();
}
