import 'dart:convert';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entity/profile_entity.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/entity/recommended_people_fetch_obj.dart';

class PostRepository {
  PostRepository._internal();
  static final PostRepository instance = PostRepository._internal();

  // ─── POSTS ─────────────────────────────────────────────

  Future<List<PostEntity>> fetchPosts({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return <PostEntity>[];
  }

  // ─── RECOMMENDED PEOPLE ───────────────────────────────

  Future<List<PeopleRecommended>> fetchRecommendedPeople() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return <PeopleRecommended>[];
  }
}

/// Cache-first profile repository.
///
/// Flow:
///   GET  → SQLite first → network fallback → store → return
///   PUT  → network first → update SQLite → return
///   DELETE → network → clear SQLite → clear token
class ProfileRepository {
  ProfileRepository._internal();
  static final ProfileRepository instance = ProfileRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const _cacheKey = 'profile';

  // ─── Get profile (cache-first) ───────────────────────────────────────────

  Future<ProfileEntity?> getProfile() async {
    // 1. Try SQLite cache first
    final isStale = await _db.isCacheStale(
      _cacheKey,
      maxAge: const Duration(minutes: 10),
    );
    if (!isStale) {
      final cached = await _getCachedProfile();
      if (cached != null) return cached;
    }

    // 2. Network fallback
    try {
      final response = await _api.get('/profile/me');
      final profile = _fromJson(response['profile'] as Map<String, dynamic>);
      await _cacheProfile(profile);
      return profile;
    } catch (_) {
      return _getCachedProfile(); // Return stale cache if network fails
    }
  }

  // ─── Update profile ──────────────────────────────────────────────────────

  Future<ProfileEntity> updateProfile({
    required String username,
    required String bio,
    String? avatarUrl,
    Map<String, String>? vibes,
  }) async {
    final response = await _api.put(
      '/profile/me',
      body: {
        'username': username,
        'bio': bio,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (vibes != null) 'vibes': vibes,
      },
    );

    final updated = _fromJson(response['profile'] as Map<String, dynamic>);
    await _cacheProfile(updated);
    return updated;
  }

  // ─── Save interests (called after interest selection screen) ─────────────

  Future<void> saveInterests(Map<String, String> vibes) async {
    await _api.put('/profile/interests', body: {'vibes': vibes});
    // Update the cached profile's vibes map
    final cached = await _getCachedProfile();
    if (cached != null) {
      await _cacheProfile(cached.copyWith(vibes: vibes));
    }
  }

  // ─── Delete account ──────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    await _api.delete('/auth/account');
    // Wipe everything locally
    await _db.clearTable('users');
    await _db.clearTable('posts');
    await _db.clearTable('connections');
    await _db.clearTable('notifications');
    await _db.clearTable('cache_meta');
    await ApiClient.instance.clearToken();
  }

  // ─── Block / unblock user ────────────────────────────────────────────────

  Future<void> blockUser(String targetId) async {
    await _api.post('/users/$targetId/block');
  }

  Future<void> unblockUser(String targetId) async {
    await _api.delete('/users/$targetId/block');
  }

  Future<List<Map<String, String>>> fetchBlockedUsers() async {
    final response = await _api.get('/users/blocked');
    final List<dynamic> raw = response['users'] as List<dynamic>;
    return raw.map((u) {
      final m = u as Map<String, dynamic>;
      return {
        'id': m['id'] as String,
        'name': m['display_name'] as String,
        'avatar': m['avatar_url'] as String? ?? '',
      };
    }).toList();
  }

  // ─── SQLite helpers ──────────────────────────────────────────────────────

  Future<ProfileEntity?> _getCachedProfile() async {
    final db = await _db.database;
    final rows = await db.query('users', limit: 1);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return ProfileEntity(
      id: r['id'] as String,
      username: r['username'] as String,
      email: r['email'] as String,
      bio: r['bio'] as String?,
      avatarUrl: r['avatar_url'] as String?,
    );
  }

  Future<void> _cacheProfile(ProfileEntity profile) async {
    final db = await _db.database;
    await db.insert('users', {
      'id': profile.id,
      'username': profile.username,
      'email': profile.email,
      'bio': profile.bio,
      'avatar_url': profile.avatarUrl,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await _db.markCacheFresh(_cacheKey);
  }

  ProfileEntity _fromJson(Map<String, dynamic> json) {
    Map<String, String> parseVibes(dynamic raw) {
      if (raw == null) return {};
      if (raw is Map) {
        return raw.map((k, v) => MapEntry(k as String, v as String));
      }
      try {
        final m = jsonDecode(raw as String) as Map;
        return m.map((k, v) => MapEntry(k as String, v as String));
      } catch (_) {
        return {};
      }
    }

    return ProfileEntity(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      vibes: parseVibes(json['vibes']),
    );
  }
}
