import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/registration_storage.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class VerificationState {
  const VerificationState();
}

class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

/// OTP verified — user may now proceed to sign up.
class VerificationSuccess extends VerificationState {
  const VerificationSuccess();
}

class VerificationResent extends VerificationState {
  const VerificationResent();
}

class VerificationError extends VerificationState {
  final String message;
  const VerificationError(this.message);
}

// ── Provider ──────────────────────────────────────────────────────────────────

final registrationStorageProvider = Provider<RegistrationStorage>((ref) {
  return RegistrationStorage.instance;
});

final verificationProvider =
    NotifierProvider<VerificationNotifier, VerificationState>(
      VerificationNotifier.new,
    );

// ── Notifier ──────────────────────────────────────────────────────────────────

class VerificationNotifier extends Notifier<VerificationState> {
  @override
  VerificationState build() => const VerificationInitial();

  /// Submits the 6-digit OTP for the given [email].
  Future<void> verifyOtp({required String email, required String otp}) async {
    if (otp.length != 6) {
      state = const VerificationError('Please enter the full 6-digit code.');
      return;
    }

    state = const VerificationLoading();

    try {
      final String? userId = await ref
          .read(registrationStorageProvider)
          .getVerificationSessionId();

      // 🛑 3. Safety Check: If for some reason storage cleared out, handle it gracefully
      if (userId == null) {
        state = const VerificationError(
          'Session expired. Please re-enter your email.',
        );
        return;
      }
      await ApiClient.instance.post(
        '/auth/verify-user-otp',
        body: {'id': userId, 'OTP': otp},
        auth: false,
      );
      state = const VerificationSuccess();
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        print(e);
        state = const VerificationError('Invalid or expired code. Try again.');
      } else {
        state = VerificationError(e.message);
      }
    } catch (err) {
      print(err);
      state = const VerificationError('Network error. Please try again.');
    }
  }

  /// Resends the OTP to [email].
  Future<void> resendOtp(String email) async {
    state = const VerificationLoading();
    try {
      await ApiClient.instance.post(
        '/auth/send-otp',
        body: {'email': email},
        auth: false,
      );
      state = const VerificationResent();
    } catch (_) {
      state = const VerificationError('Could not resend code. Try again.');
    }
  }

  void reset() => state = const VerificationInitial();
}
