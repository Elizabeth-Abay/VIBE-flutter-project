import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/auth/domain/entities/auth_state.dart';

void main() {
  group('AuthState sealed classes', () {
    // ── identity checks ──────────────────────────────────────────────────────

    test('AuthStateInitial is an AuthState', () {
      const state = AuthStateInitial();
      expect(state, isA<AuthState>());
      expect(state, isA<AuthStateInitial>());
    });

    test('AuthStateLoading is an AuthState', () {
      const state = AuthStateLoading();
      expect(state, isA<AuthState>());
      expect(state, isA<AuthStateLoading>());
    });

    test('AuthStateAuthenticated is an AuthState', () {
      const state = AuthStateAuthenticated();
      expect(state, isA<AuthState>());
      expect(state, isA<AuthStateAuthenticated>());
    });

    test('AuthStateUnauthenticated is an AuthState', () {
      const state = AuthStateUnauthenticated();
      expect(state, isA<AuthState>());
      expect(state, isA<AuthStateUnauthenticated>());
    });

    test('AuthStateError carries a message', () {
      const state = AuthStateError('Invalid email or password.');
      expect(state, isA<AuthState>());
      expect(state, isA<AuthStateError>());
      expect(state.message, equals('Invalid email or password.'));
    });

    // ── distinctness ─────────────────────────────────────────────────────────

    test('states are not equal to each other', () {
      const AuthState initial = AuthStateInitial();
      const AuthState loading = AuthStateLoading();
      const AuthState auth = AuthStateAuthenticated();
      const AuthState unauth = AuthStateUnauthenticated();
      const AuthState error = AuthStateError('oops');

      expect(initial, isNot(equals(loading)));
      expect(auth, isNot(equals(unauth)));
      expect(error, isNot(equals(initial)));
    });

    // ── pattern matching ─────────────────────────────────────────────────────

    test('switch exhaustively matches all states', () {
      final states = <AuthState>[
        const AuthStateInitial(),
        const AuthStateLoading(),
        const AuthStateAuthenticated(),
        const AuthStateUnauthenticated(),
        const AuthStateError('err'),
      ];

      for (final state in states) {
        // If any state is missing the switch would throw — so this verifies
        // our sealed hierarchy is complete.
        final label = switch (state) {
          AuthStateInitial() => 'initial',
          AuthStateLoading() => 'loading',
          AuthStateAuthenticated() => 'authenticated',
          AuthStateUnauthenticated() => 'unauthenticated',
          AuthStateError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });

    // ── error message ────────────────────────────────────────────────────────

    test('AuthStateError stores exactly the message passed in', () {
      const msg = 'Network timeout after 30 seconds';
      const state = AuthStateError(msg);
      expect(state.message, equals(msg));
    });

    test('Two AuthStateErrors with same message are logically equal in message',
        () {
      const a = AuthStateError('same');
      const b = AuthStateError('same');
      expect(a.message, equals(b.message));
    });
  });
}
