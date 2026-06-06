import 'dart:convert';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/profile_entity.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  ProfileRepository._internal();
  static final ProfileRepository instance = ProfileRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;

  static const String _cacheKey = 'profile';

  // ─── Get Profile (Cache-First) ───────────────────────────────────────────

  Future<ProfileModel?> getProfile() async {
    try {
      // Try API first
      final response = await _api.get('/profile/my-profile');

      if (response['success'] == false) {
        throw Exception(response['message'] ?? "Failed to fetch profile");
      }

      final profile = ProfileModel.fromJson(
        response['data'][0] as Map<String, dynamic>,
      );

      await _cacheProfile(profile);
      return profile;
    } catch (err) {
      print("API Error while fetching profile → Loading cache: $err");
      return await _getCachedProfile();
    }
  }

  // ─── Update Full Profile ─────────────────────────────────────────────────

  Future<ProfileModel> updateProfile({
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

    final updated = ProfileModel.fromJson(
      response['profile'] as Map<String, dynamic>,
    );

    await _cacheProfile(updated);
    return updated;
  }

  // ─── Update Interests ───────────────────────────────────────────────────

  Future<void> updateInterests(List<Map<String, String>> vibesList) async {
    await _api.post(
      '/interest/update-interests',
      body: {'interestedIn': vibesList},
    );

    // Reconstruct map for local cache
    final Map<String, String> vibesMap = {
      for (var item in vibesList) item['interest']!: item['score']!,
    };

    final cached = await _getCachedProfile();
    if (cached != null) {
      await _cacheProfile(cached.copyWith(vibes: vibesMap));
    }
  }

  // ─── Update Name & Bio (Lightweight) ─────────────────────────────────────

  Future<bool> updateNameAndBio({
    required String name
  }) async {
    try {
      print("calling update naem");
      final response = await _api.post(
        '/profile/set-bio-and-name',
        body: {'name': name},
      );

      if (response['success'] == true) {
        final updatedProfile = await getProfile(); // Refresh from cache/API
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating name and bio: $e");
      rethrow; // Let the caller (Notifier) handle the error
    }
  }

  // ─── Delete Account ──────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    await _api.delete('/auth/account');
    await _db.clearAllUserData();
    await ApiClient.instance.clearToken();
  }

  // ─── Block / Unblock ─────────────────────────────────────────────────────

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

  // ─── Cache Helpers ───────────────────────────────────────────────────────

  Future<ProfileModel?> _getCachedProfile() async {
    try {
      final db = await _db.database;
      final rows = await db.query('users', limit: 1);
      if (rows.isEmpty) return null;

      return ProfileModel.fromJson(rows.first);
    } catch (e) {
      print("Cache read error: $e");
      return null;
    }
  }

  Future<void> _cacheProfile(ProfileModel profile) async {
    try {
      final db = await _db.database;

      await db.insert('users', {
        'id': profile.userId,
        'username': profile.userName,
        'email': profile.email,
        'bio': profile.bio,
        'avatar_url': profile.profileUrl,
        'vibes': profile.vibes.isEmpty ? null : jsonEncode(profile.vibes),
        'created_at': DateTime.now().toIso8601String(),
        // Add other fields you need
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      await _db.markCacheFresh(_cacheKey);
    } catch (e) {
      print("Cache write error: $e");
    }
  }
}
