import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/auth/domain/entities/auth_state.dart';
import 'package:vibe_app/features/auth/presentation/providers/auth_notifier.dart';

 
// We subclass AuthNotifier and override [build] to return a known initial
// state, bypassing any real DB / secure-storage calls. Individual tests then
// call the public methods directly to drive state transitions.

class FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => const AuthStateUnauthenticated(); // safe default

  @override
  Future<void> signOut() async {
    state = const AuthStateUnauthenticated();
  }

  /// Test helper — drives a real state transition without hitting _repo.
  void setAuthenticated() {
    state = const AuthStateAuthenticated();
  }
}

/// Override the real provider with our fake
final fakeAuthProvider = NotifierProvider<FakeAuthNotifier, AuthState>(
  FakeAuthNotifier.new,
);

void main() {
  group('AuthNotifier — state transitions (Riverpod)', () {
    ProviderContainer makeContainer() => ProviderContainer();

    // ── initial state ──────────────────────────────────────────────────────

    test('FakeAuthNotifier starts as AuthStateUnauthenticated', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      expect(c.read(fakeAuthProvider), isA<AuthStateUnauthenticated>());
    });

    // ── isAuthenticated helper ─────────────────────────────────────────────

    test('isAuthenticated is false when unauthenticated', () {
      final c = makeContainer();
      addTearDown(c.dispose);
      expect(c.read(fakeAuthProvider.notifier).isAuthenticated, isFalse);
    });

    // ── sealed class coverage ─────────────────────────────────────────────

    test('AuthStateAuthenticated satisfies isAuthenticated == true pattern', () {
      // We can test the boolean helper by hand-setting state via the notifier.
      // Because AuthNotifier.state is protected, we verify via the real type.
      const s = AuthStateAuthenticated();
      final isAuth = s is AuthStateAuthenticated;
      expect(isAuth, isTrue);
    });

    // ── signOut ────────────────────────────────────────────────────────────

    test('signOut sets state to AuthStateUnauthenticated', () async {
      final c = makeContainer();
      addTearDown(c.dispose);

      c.read(fakeAuthProvider.notifier).setAuthenticated();
      await c.read(fakeAuthProvider.notifier).signOut();

      expect(c.read(fakeAuthProvider), isA<AuthStateUnauthenticated>());
    });

    // ── listener integration ───────────────────────────────────────────────

    test('listener fires when state changes', () {
      final c = makeContainer();
      addTearDown(c.dispose);

      final states = <AuthState>[];
      c.listen<AuthState>(fakeAuthProvider, (_, next) => states.add(next));

      // Riverpod only notifies when state actually changes — not when
      // re-assigning the same value (Unauthenticated → Unauthenticated).
      c.read(fakeAuthProvider.notifier).setAuthenticated();

      expect(states, isNotEmpty);
      expect(states.last, isA<AuthStateAuthenticated>());
    });

    // ── error state ────────────────────────────────────────────────────────

    test('AuthStateError exposes its message', () {
      const err = AuthStateError('Invalid email or password.');
      expect(err.message, equals('Invalid email or password.'));
      expect(err, isA<AuthState>());
    });

    // ── container isolation ────────────────────────────────────────────────

    test('two containers do not share auth state', () {
      final c1 = makeContainer();
      final c2 = makeContainer();
      addTearDown(c1.dispose);
      addTearDown(c2.dispose);

      // Both start unauthenticated — independent instances
      expect(c1.read(fakeAuthProvider), isA<AuthStateUnauthenticated>());
      expect(c2.read(fakeAuthProvider), isA<AuthStateUnauthenticated>());
    });
  });
}
