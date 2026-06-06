import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);

    final sampleJson = {
      'id': 'user-001',
      'username': 'yada_dev',
      'email': 'yada@example.com',
      'bio': 'Flutter developer',
      'avatar_url': 'https://example.com/avatar.png',
      'created_at': testDate.toIso8601String(),
    };

    final sampleDbRow = {
      'id': 'user-001',
      'username': 'yada_dev',
      'email': 'yada@example.com',
      'bio': 'Flutter developer',
      'avatar_url': 'https://example.com/avatar.png',
      'created_at': testDate.toIso8601String(),
    };

    // ── fromJson ────────────────────────────────────────────────────────────

    group('fromJson()', () {
      test('parses all fields correctly', () {
        final model = UserModel.fromJson(sampleJson);

        expect(model.id, equals('user-001'));
        expect(model.username, equals('yada_dev'));
        expect(model.email, equals('yada@example.com'));
        expect(model.bio, equals('Flutter developer'));
        expect(model.avatarUrl, equals('https://example.com/avatar.png'));
        expect(model.createdAt, equals(testDate));
      });

      test('handles null optional fields (bio, avatarUrl)', () {
        final json = {
          'id': 'u2',
          'username': 'ghost',
          'email': 'ghost@vibe.io',
          'bio': null,
          'avatar_url': null,
          'created_at': testDate.toIso8601String(),
        };
        final model = UserModel.fromJson(json);

        expect(model.bio, isNull);
        expect(model.avatarUrl, isNull);
      });
    });

    // ── toJson ──────────────────────────────────────────────────────────────

    group('toJson()', () {
      test('produces correct map', () {
        final model = UserModel(
          id: 'user-001',
          username: 'yada_dev',
          email: 'yada@example.com',
          bio: 'Flutter developer',
          avatarUrl: 'https://example.com/avatar.png',
          createdAt: testDate,
        );

        final json = model.toJson();

        expect(json['id'], equals('user-001'));
        expect(json['username'], equals('yada_dev'));
        expect(json['email'], equals('yada@example.com'));
        expect(json['bio'], equals('Flutter developer'));
        expect(json['avatar_url'], equals('https://example.com/avatar.png'));
        expect(json['created_at'], equals(testDate.toIso8601String()));
      });
    });

    // ── fromDb ──────────────────────────────────────────────────────────────

    group('fromDb()', () {
      test('parses SQLite row correctly', () {
        final model = UserModel.fromDb(sampleDbRow);

        expect(model.id, equals('user-001'));
        expect(model.username, equals('yada_dev'));
        expect(model.email, equals('yada@example.com'));
        expect(model.bio, equals('Flutter developer'));
        expect(model.avatarUrl, equals('https://example.com/avatar.png'));
        expect(model.createdAt, equals(testDate));
      });
    });

    // ── toDb ────────────────────────────────────────────────────────────────

    group('toDb()', () {
      test('produces correct DB map', () {
        final model = UserModel(
          id: 'user-001',
          username: 'yada_dev',
          email: 'yada@example.com',
          bio: 'Flutter developer',
          avatarUrl: 'https://example.com/avatar.png',
          createdAt: testDate,
        );

        final db = model.toDb();

        expect(db['id'], equals('user-001'));
        expect(db['username'], equals('yada_dev'));
        expect(db['email'], equals('yada@example.com'));
        expect(db['bio'], equals('Flutter developer'));
        expect(db['avatar_url'], equals('https://example.com/avatar.png'));
        expect(db['created_at'], equals(testDate.toIso8601String()));
      });
    });

    // ── round-trip ──────────────────────────────────────────────────────────

    test('fromJson → toJson round-trip preserves data', () {
      final model = UserModel.fromJson(sampleJson);
      final roundTrip = model.toJson();

      expect(roundTrip['id'], equals(sampleJson['id']));
      expect(roundTrip['username'], equals(sampleJson['username']));
      expect(roundTrip['email'], equals(sampleJson['email']));
    });

    test('fromDb → toDb round-trip preserves data', () {
      final model = UserModel.fromDb(sampleDbRow);
      final roundTrip = model.toDb();

      expect(roundTrip['id'], equals(sampleDbRow['id']));
      expect(roundTrip['username'], equals(sampleDbRow['username']));
      expect(roundTrip['email'], equals(sampleDbRow['email']));
    });
  });
}
