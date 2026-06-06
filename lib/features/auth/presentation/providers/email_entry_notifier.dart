import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/storage/registration_storage.dart';

//  State - used to communicate to the ui

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
  final String id;
  const EmailEntrySuccess({required this.email, required this.id});
}

class EmailEntryError extends EmailEntryState {
  final String message;
  const EmailEntryError(this.message);
}

//  Provider - translate the backend result into the state

final emailEntryProvider =
    NotifierProvider<EmailEntryNotifier, EmailEntryState>(
      EmailEntryNotifier.new,
    );

//  Notifier

// 🔐 Provide your custom registration storage instead of raw FlutterSecureStorage
final registrationStorageProvider = Provider(
  (ref) => RegistrationStorage.instance,
);

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
      final response = await ApiClient.instance.post(
        '/auth/create-a-user',
        body: {'email': email},
        auth: false,
      );

      final String backendId = response['id'];

      // 3. Silently save it to your device's local secure storage keychain
      await ref
          .read(registrationStorageProvider)
          .saveVerificationSession(userId: backendId, email: email);

      //Update state to notify the UI screen to change pages
      state = EmailEntrySuccess(id: backendId, email: email);
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        const backendReason = 'User already exists';

        // means user Already exists

        // 3. Emit the error state using the exact message from the backend!
        state = const EmailEntryError(backendReason);
      } else {
        state = EmailEntryError(e.message);
      }
    } catch (errror) {
      //print("Error is ${errror}");
      state = const EmailEntryError('Network error. Please try again.');
    }
  }

  void reset() => state = const EmailEntryInitial();
}
