import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

// ── Username Check State ───────────────────────────────────────────────────
sealed class UsernameCheckState {
  const UsernameCheckState();
}

class UsernameInitial extends UsernameCheckState {
  const UsernameInitial();
}

class UsernameChecking extends UsernameCheckState {
  const UsernameChecking();
}

class UsernameAvailable extends UsernameCheckState {
  final String message;
  const UsernameAvailable(this.message);
}

class UsernameUnavailable extends UsernameCheckState {
  final String message;
  const UsernameUnavailable(this.message);
}

// ── Notifier
final usernameCheckProvider =
    NotifierProvider<UsernameCheckNotifier, UsernameCheckState>(
      UsernameCheckNotifier.new,
    );

class UsernameCheckNotifier extends Notifier<UsernameCheckState> {
  Timer? _debounceTimer;

  @override
  UsernameCheckState build() {
    // Clean up timer if provider is disposed
    ref.onDispose(() => _debounceTimer?.cancel());
    return const UsernameInitial();
  }

  /// Debounces input changes so we only hit the backend after the user stops typing
  void checkUsernameDebounced(String username) {
    _debounceTimer?.cancel();

    final cleanUsername = username.trim();
    if (cleanUsername.length < 3) {
      state = const UsernameInitial();
      return;
    }

    state = const UsernameChecking();

    _debounceTimer = Timer(const Duration(seconds: 3), () async {
      try {
        final response = await ApiClient.instance.post(
          '/profile/check-unique-username',
          body: {'userName': cleanUsername},
          auth: false,
        );

        // Expecting response format: { success: true, message: "Username available" }
        if (response['success'] == true) {
          state = UsernameAvailable(
            response['message'] ?? 'Username available',
          );
        } else {
          state = UsernameUnavailable(response['reason'] ?? 'Username taken');
        }
      } on ApiException catch (e) {
        state = UsernameUnavailable(e.message);
      } catch (_) {
        state = const UsernameUnavailable('Error verifying connection.');
      }
    });
  }

  void reset() {
    _debounceTimer?.cancel();
    state = const UsernameInitial();
  }
}
