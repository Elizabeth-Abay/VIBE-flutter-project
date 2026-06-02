import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user_entity.dart';

/// The single Riverpod provider the entire app uses for auth.
/// Screens call: ref.watch(authNotifierProvider) to read state.
/// Screens call: ref.read(authNotifierProvider.notifier).signIn(...) to act.
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Manages the full authentication lifecycle.
class AuthNotifier extends Notifier<AuthState> {
  final _repo = AuthRepository.instance;

  @override
  AuthState build() {
    // On first build, asynchronously check if a user is already logged in.
    _checkExistingSession();
    return const AuthStateInitial();
  }

  // ─── Check session on app start ──────────────────────────────────────────

  Future<void> _checkExistingSession() async {
    state = const AuthStateLoading();
    try {
      final user = await _repo.getCurrentUser();
      if (user != null) {
        state = AuthStateAuthenticated();
      } else {
        state = const AuthStateUnauthenticated();
      }
    } catch (_) {
      state = const AuthStateUnauthenticated();
    }
  }

  // ─── Sign In ─────────────────────────────────────────────────────────────

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthStateLoading();
    try {
      final user = await _repo.signIn(email: email, password: password);

      if (user == false) {
        AuthStateUnauthenticated();
        return;
      }
      AuthStateUnauthenticated();

      state = AuthStateAuthenticated();
    } on Exception catch (e) {
      state = AuthStateError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ─── Sign Up ─────────────────────────────────────────────────────────────

  Future<void> signUp({
    required String username,
    required String password,
    required String name,
  }) async {
    state = const AuthStateLoading();
    try {
      final user = await _repo.signUp(
        username: username,
        password: password,
        name: name,
      );
      // user - true or false

      if (user == false) {
        AuthStateUnauthenticated();
        return;
      }

      state = AuthStateAuthenticated();
    } on Exception catch (e) {
      state = AuthStateError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ─── Sign Out ────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthStateUnauthenticated();
  }

  // UserEntity? get currentUser {
  //   final s = state;
  //   return s is AuthStateAuthenticated ? s.user : null;
  // }

  bool get isAuthenticated => state is AuthStateAuthenticated;
}
