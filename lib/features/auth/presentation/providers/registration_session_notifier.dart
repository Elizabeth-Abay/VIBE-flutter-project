import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds email + OTP verification across create-account screens.
class RegistrationSession {
  final String? email;
  final bool otpVerified;

  const RegistrationSession({this.email, this.otpVerified = false});

  RegistrationSession copyWith({String? email, bool? otpVerified}) {
    return RegistrationSession(
      email: email ?? this.email,
      otpVerified: otpVerified ?? this.otpVerified,
    );
  }
}

final registrationSessionProvider =
    NotifierProvider<RegistrationSessionNotifier, RegistrationSession>(
  RegistrationSessionNotifier.new,
);

class RegistrationSessionNotifier extends Notifier<RegistrationSession> {
  @override
  RegistrationSession build() => const RegistrationSession();

  void setEmail(String email) {
    state = RegistrationSession(email: email.trim());
  }

  void markOtpVerified() {
    if (state.email == null) return;
    state = state.copyWith(otpVerified: true);
  }

  void clear() => state = const RegistrationSession();

  bool get canSignUp => state.email != null && state.otpVerified;
}
