import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/auth/presentation/providers/email_entry_notifier.dart';

void main() {
  group('EmailEntryState', () {
    // ── type checks ──────────────────────────────────────────────────────────

    test('EmailEntryInitial is an EmailEntryState', () {
      const s = EmailEntryInitial();
      expect(s, isA<EmailEntryState>());
      expect(s, isA<EmailEntryInitial>());
    });

    test('EmailEntryLoading is an EmailEntryState', () {
      const s = EmailEntryLoading();
      expect(s, isA<EmailEntryState>());
      expect(s, isA<EmailEntryLoading>());
    });

    test('EmailEntrySuccess carries email and id', () {
      const s = EmailEntrySuccess(email: 'a@b.com', id: 'sess-42');
      expect(s, isA<EmailEntryState>());
      expect(s.email, equals('a@b.com'));
      expect(s.id, equals('sess-42'));
    });

    test('EmailEntryError carries a message', () {
      const s = EmailEntryError('User already exists');
      expect(s, isA<EmailEntryState>());
      expect(s.message, equals('User already exists'));
    });

    // ── email validation logic (mirrored from notifier) ─────────────────────

    group('email validation', () {
      bool isValid(String email) =>
          email.isNotEmpty && email.contains('@');

      test('empty string is invalid', () {
        expect(isValid(''), isFalse);
      });

      test('string without @ is invalid', () {
        expect(isValid('notanemail'), isFalse);
      });

      test('string with @ is valid', () {
        expect(isValid('user@vibe.io'), isTrue);
      });

      test('@ at start is accepted by contains-check', () {
        // The notifier uses !email.contains('@') — so '@' alone passes
        expect(isValid('@'), isTrue);
      });

      test('proper email format passes', () {
        expect(isValid('yada@example.com'), isTrue);
      });
    });

    // ── pattern matching ─────────────────────────────────────────────────────

    test('switch covers every EmailEntryState variant', () {
      final states = <EmailEntryState>[
        const EmailEntryInitial(),
        const EmailEntryLoading(),
        const EmailEntrySuccess(email: 'x@y.com', id: '1'),
        const EmailEntryError('err'),
      ];

      for (final s in states) {
        final tag = switch (s) {
          EmailEntryInitial() => 'initial',
          EmailEntryLoading() => 'loading',
          EmailEntrySuccess() => 'success',
          EmailEntryError() => 'error',
        };
        expect(tag, isNotEmpty);
      }
    });
  });
}
