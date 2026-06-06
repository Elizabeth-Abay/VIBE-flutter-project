import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/posts/data/model/post_model.dart';

void main() {
  group('PostModel', () {
    final sampleJson = {
      'post_id': 'post-123',
      'title': 'Best Flutter Books 2024',
      'content': 'Here are the top picks...',
      'category': 'books',
      'post_image': 'https://cdn.vibe.io/img.jpg',
      'author_id': 'user-001',
      'user_name': 'yada_dev',
      'name': 'Yada',
      'author_profile_picture': 'https://cdn.vibe.io/av.jpg',
    };

    // ── fromJson ─────────────────────────────────────────────────────────────

    group('fromJson()', () {
      test('maps all standard fields correctly', () {
        final model = PostModel.fromJson(sampleJson);

        expect(model.id, equals('post-123'));
        expect(model.title, equals('Best Flutter Books 2024'));
        expect(model.description, equals('Here are the top picks...'));
        expect(model.category, equals('books'));
        expect(model.imageUrl, equals('https://cdn.vibe.io/img.jpg'));
        expect(model.userId, equals('user-001'));
        expect(model.userName, equals('yada_dev'));
        expect(model.name, equals('Yada'));
        expect(model.userProfileImageUrl, equals('https://cdn.vibe.io/av.jpg'));
      });

      test('defaults title to "Untitled" when missing', () {
        final json = Map<String, dynamic>.from(sampleJson);
        json.remove('title');
        final model = PostModel.fromJson(json);
        expect(model.title, equals('Untitled'));
      });

      test('defaults description to empty string when missing', () {
        final json = Map<String, dynamic>.from(sampleJson);
        json.remove('content');
        final model = PostModel.fromJson(json);
        expect(model.description, equals(''));
      });

      test('defaults category to empty string when missing', () {
        final json = Map<String, dynamic>.from(sampleJson);
        json.remove('category');
        final model = PostModel.fromJson(json);
        expect(model.category, equals(''));
      });

      test('handles null imageUrl gracefully', () {
        final json = Map<String, dynamic>.from(sampleJson);
        json['post_image'] = null;
        final model = PostModel.fromJson(json);
        expect(model.imageUrl, isNull);
      });

      test('handles null userProfileImageUrl gracefully', () {
        final json = Map<String, dynamic>.from(sampleJson);
        json['author_profile_picture'] = null;
        final model = PostModel.fromJson(json);
        expect(model.userProfileImageUrl, isNull);
      });
    });

    // ── toDb ─────────────────────────────────────────────────────────────────

    group('toDb()', () {
      test('maps to correct SQLite column names', () {
        final model = PostModel.fromJson(sampleJson);
        final db = model.toDb();

        expect(db['id'], equals('post-123'));
        expect(db['user_id'], equals('user-001'));
        expect(db['title'], equals('Best Flutter Books 2024'));
        expect(db['description'], equals('Here are the top picks...'));
        expect(db['image_url'], equals('https://cdn.vibe.io/img.jpg'));
        expect(db['category'], equals('books'));
        expect(db['user_name'], equals('yada_dev'));
        expect(db['user_profile_image_url'], equals('https://cdn.vibe.io/av.jpg'));
      });
    });

    // ── toJson ───────────────────────────────────────────────────────────────

    group('toJson()', () {
      test('serialises back to a valid map', () {
        final model = PostModel.fromJson(sampleJson);
        final json = model.toJson();

        expect(json['id'], equals('post-123'));
        expect(json['user_id'], equals('user-001'));
        expect(json['title'], equals('Best Flutter Books 2024'));
        expect(json['category'], equals('books'));
      });
    });

    // ── inheritance ──────────────────────────────────────────────────────────

    test('PostModel is a PostEntity', () {
      final model = PostModel.fromJson(sampleJson);
      expect(model, isA<PostModel>());
      // PostModel extends PostEntity, so accessing entity fields works
      expect(model.id, isNotEmpty);
    });
  });
}
