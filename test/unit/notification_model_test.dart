import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/notification/data/models/notfication_model.dart';

void main() {
  group('NotificationModel', () {
    final testDate = DateTime(2024, 3, 20, 8, 0, 0);

    final sampleJson = {
      'id': 'notif-001',
      'type': 'connection_request',
      'message': 'Yada wants to connect with you.',
      'is_read': false,
      'created_at': testDate.toIso8601String(),
    };

    final sampleDbRow = {
      'id': 'notif-001',
      'type': 'connection_request',
      'message': 'Yada wants to connect with you.',
      'is_read': 0, // SQLite stores booleans as int
      'created_at': testDate.toIso8601String(),
    };

    // ── fromJson ─────────────────────────────────────────────────────────────

    group('fromJson()', () {
      test('parses all fields correctly', () {
        final model = NotificationModel.fromJson(sampleJson);

        expect(model.id, equals('notif-001'));
        expect(model.type, equals('connection_request'));
        expect(model.message, equals('Yada wants to connect with you.'));
        expect(model.isRead, isFalse);
        expect(model.createdAt, equals(testDate));
      });

      test('is_read = true maps to true', () {
        final json = Map<String, dynamic>.from(sampleJson)
          ..['is_read'] = true;
        final model = NotificationModel.fromJson(json);
        expect(model.isRead, isTrue);
      });

      test('is_read = 1 (int) maps to true', () {
        final json = Map<String, dynamic>.from(sampleJson)
          ..['is_read'] = 1;
        final model = NotificationModel.fromJson(json);
        expect(model.isRead, isTrue);
      });

      test('is_read = false maps to false', () {
        final json = Map<String, dynamic>.from(sampleJson)
          ..['is_read'] = false;
        final model = NotificationModel.fromJson(json);
        expect(model.isRead, isFalse);
      });
    });

    // ── fromDb ───────────────────────────────────────────────────────────────

    group('fromDb()', () {
      test('parses SQLite row correctly', () {
        final model = NotificationModel.fromDb(sampleDbRow);

        expect(model.id, equals('notif-001'));
        expect(model.type, equals('connection_request'));
        expect(model.isRead, isFalse); // is_read = 0 → false
        expect(model.createdAt, equals(testDate));
      });

      test('is_read = 1 maps to true in DB row', () {
        final row = Map<String, dynamic>.from(sampleDbRow)..['is_read'] = 1;
        final model = NotificationModel.fromDb(row);
        expect(model.isRead, isTrue);
      });
    });

    // ── toDb ─────────────────────────────────────────────────────────────────

    group('toDb()', () {
      test('serialises isRead = false as 0', () {
        final model = NotificationModel.fromDb(sampleDbRow);
        final db = model.toDb();
        expect(db['is_read'], equals(0));
      });

      test('serialises isRead = true as 1', () {
        final model = NotificationModel.fromDb(
          Map<String, dynamic>.from(sampleDbRow)..['is_read'] = 1,
        );
        final db = model.toDb();
        expect(db['is_read'], equals(1));
      });

      test('includes cached_at timestamp', () {
        final model = NotificationModel.fromDb(sampleDbRow);
        final db = model.toDb();
        expect(db.containsKey('cached_at'), isTrue);
        expect(db['cached_at'], isA<String>());
      });

      test('contains all required DB columns', () {
        final model = NotificationModel.fromDb(sampleDbRow);
        final db = model.toDb();
        for (final key in ['id', 'type', 'message', 'is_read', 'created_at']) {
          expect(db.containsKey(key), isTrue,
              reason: 'Missing key: $key');
        }
      });
    });
  });
}
