import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/entity/recommended_people_fetch_obj.dart';

/// Cache-first repository for posts and recommended people.
///
/// Flow:
///   1. Check if cache is fresh (< 5 min old).
///   2. Cache HIT  → return rows from SQLite immediately.
///   3. Cache MISS → call API → store rows → return fresh data.
class PostRepository {
  PostRepository._internal();
  static final PostRepository instance = PostRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _postsCacheKey = 'posts';
  static const _peopleCacheKey = 'recommended_people';

  // ─── Fetch Posts (cache-first) ───────────────────────────────────────────

  Future<List<PostEntity>> fetchPosts({String? category}) async {
    final cacheKey =
        category != null ? '${_postsCacheKey}_$category' : _postsCacheKey;

    // 1. Cache HIT?
    final isStale = await _db.isCacheStale(cacheKey);
    if (!isStale) {
      final cached = await _getCachedPosts(category: category);
      if (cached.isNotEmpty) return cached;
    }

    // 2. Network call
    try {
      final path = category != null ? '/posts?category=$category' : '/posts';
      final response = await _api.get(path);
      final List<dynamic> raw = response['posts'] as List<dynamic>;
      final posts = raw
          .map((j) => PostModel.fromJson(j as Map<String, dynamic>))
          .toList();

      // 3. Store in cache
      await _cachePosts(posts);
      await _db.markCacheFresh(cacheKey);

      return posts;
    } catch (_) {
      // Network failed — return whatever is in cache (stale is better than nothing)
      return _getCachedPosts(category: category);
    }
  }

  // ─── Create Post ─────────────────────────────────────────────────────────

  Future<PostEntity> createPost({
    required String title,
    required String description,
    required String category,
    required List<String> tags,
    String? imageUrl,
  }) async {
    final response = await _api.post('/posts', body: {
      'title': title,
      'description': description,
      'category': category,
      'tags': tags,
      if (imageUrl != null) 'image_url': imageUrl,
    });

    final post = PostModel.fromJson(response['post'] as Map<String, dynamic>);

    // Insert new post into cache and invalidate list cache
    await _insertPost(post);
    await _db.invalidateCache(_postsCacheKey);

    return post;
  }

  // ─── Recommended People (cache-first) ───────────────────────────────────

  Future<List<PeopleRecommended>> fetchRecommendedPeople() async {
    // Recommended people use the users table filtered by a flag.
    // For simplicity, this always fetches from network and caches in memory.
    final isStale = await _db.isCacheStale(_peopleCacheKey);
    if (!isStale) {
      final cached = await _getCachedPeople();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final response = await _api.get('/users/recommended');
      final List<dynamic> raw = response['users'] as List<dynamic>;
      final people = raw.map((j) {
        final m = j as Map<String, dynamic>;
        return PeopleRecommended(
          userId: m['id'] as String,
          displayName: m['display_name'] as String,
          username: m['username'] as String,
          userProfileImageUrl: m['avatar_url'] as String?,
        );
      }).toList();

      await _cachePeople(people);
      await _db.markCacheFresh(_peopleCacheKey);
      return people;
    } catch (_) {
      return _getCachedPeople();
    }
  }

  // ─── SQLite helpers ──────────────────────────────────────────────────────

  Future<List<PostEntity>> _getCachedPosts({String? category}) async {
    final db = await _db.database;
    final rows = category != null
        ? await db.query('posts',
            where: 'category = ?',
            whereArgs: [category],
            orderBy: 'created_at DESC')
        : await db.query('posts', orderBy: 'created_at DESC');
    return rows.map(PostModel.fromDb).toList();
  }

  Future<void> _cachePosts(List<PostModel> posts) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final post in posts) {
      batch.insert('posts', post.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _insertPost(PostModel post) async {
    final db = await _db.database;
    await db.insert('posts', post.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PeopleRecommended>> _getCachedPeople() async {
    final db = await _db.database;
    // We store recommended people in the users table.
    final rows = await db.query('users', limit: 20);
    return rows.map((r) {
      return PeopleRecommended(
        userId: r['id'] as String,
        displayName: r['username'] as String,
        username: r['username'] as String,
        userProfileImageUrl: r['avatar_url'] as String?,
      );
    }).toList();
  }

  Future<void> _cachePeople(List<PeopleRecommended> people) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final p in people) {
      batch.insert(
        'users',
        {
          'id': p.userId,
          'username': p.username,
          'email': '',
          'avatar_url': p.userProfileImageUrl,
          'created_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
