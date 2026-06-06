import '../entities/user_entity.dart';

/// All possible states for authentication.
/// The UI listens to this and reacts accordingly.
sealed class AuthState {
  const AuthState();
}

/// App just launched, checking if a token exists.
class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

/// Waiting for a network call to complete.
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

/// User is fully logged in.
class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated();
}

/// No token found, or user explicitly signed out.
class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

/// Something went wrong (wrong password, network error, etc).
class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}
