import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/entity/recommended_people_fetch_obj.dart';
import '../models/post_model.dart';
import '../models/recommended_user_model.dart';

/// Cache-first repository for posts feed and recommended people.
class PostRepository {
  PostRepository._internal();
  static final PostRepository instance = PostRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _postsCacheKey = 'posts';
  static const _recommendedCacheKey = 'recommended_people';

  // ─── Fetch posts (cache-first) ───────────────────────────────────────────

  Future<List<PostEntity>> fetchPosts({String? category}) async {
    final cacheKey =
        category != null ? '${_postsCacheKey}_$category' : _postsCacheKey;

    final isStale = await _db.isCacheStale(cacheKey);
    if (!isStale) {
      final cached = await _getCachedPosts(category: category);
      if (cached.isNotEmpty) return cached;
    }

    try {
      final path = category != null
          ? '/posts?category=${Uri.encodeQueryComponent(category)}'
          : '/posts';
      final response = await _api.get(path);
      final raw = response['posts'] as List<dynamic>;
      final models = raw
          .map((j) => PostModel.fromJson(j as Map<String, dynamic>))
          .toList();

      await _cachePosts(models, category: category);
      await _db.markCacheFresh(cacheKey);
      return models;
    } catch (_) {
      return _getCachedPosts(category: category);
    }
  }

  // ─── Create post (network-first) ─────────────────────────────────────────

  Future<void> createPost({
    required String title,
    required String description,
    required String category,
    required List<String> tags,
    String? imageUrl,
  }) async {
    await _api.post(
      '/posts',
      body: {
        'title': title,
        'description': description,
        'category': category,
        'tags': tags,
        if (imageUrl != null) 'image_url': imageUrl,
      },
    );
    await _db.invalidateCache(_postsCacheKey);
    await _db.invalidateCache('${_postsCacheKey}_$category');
  }

  // ─── Recommended people (cache-first) ────────────────────────────────────

  Future<List<PeopleRecommended>> fetchRecommendedPeople() async {
    final isStale = await _db.isCacheStale(_recommendedCacheKey);
    if (!isStale) {
      final cached = await _getCachedRecommended();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/users/recommended');
      final raw = response['users'] as List<dynamic>;
      final people = raw
          .map(
            (j) => RecommendedUserModel.fromJson(j as Map<String, dynamic>),
          )
          .toList();

      await _cacheRecommended(people);
      await _db.markCacheFresh(_recommendedCacheKey);
      return people;
    } catch (_) {
      return _getCachedRecommended();
    }
  }

  // ─── SQLite helpers ──────────────────────────────────────────────────────

  Future<List<PostEntity>> _getCachedPosts({String? category}) async {
    final db = await _db.database;
    final rows = category != null
        ? await db.query(
            'posts',
            where: 'category = ?',
            whereArgs: [category],
            orderBy: 'created_at DESC',
          )
        : await db.query('posts', orderBy: 'created_at DESC');
    return rows.map(PostModel.fromDb).toList();
  }

  Future<void> _cachePosts(List<PostModel> posts, {String? category}) async {
    final db = await _db.database;
    if (category != null) {
      await db.delete('posts', where: 'category = ?', whereArgs: [category]);
    } else {
      await db.delete('posts');
    }
    final batch = db.batch();
    for (final p in posts) {
      batch.insert(
        'posts',
        p.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<PeopleRecommended>> _getCachedRecommended() async {
    final db = await _db.database;
    final rows = await db.query('recommended_users');
    return rows.map(RecommendedUserModel.fromDb).toList();
  }

  Future<void> _cacheRecommended(List<RecommendedUserModel> users) async {
    final db = await _db.database;
    await db.delete('recommended_users');
    final batch = db.batch();
    for (final u in users) {
      batch.insert(
        'recommended_users',
        u.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
