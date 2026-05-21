import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Auth repository: single source of truth for sign-in, sign-up,
/// sign-out, and fetching the currently cached user.
///
/// Pattern:
///   1. Check local cache first (SQLite).
///   2. On cache miss → call network → store result → return.
class AuthRepository {
  AuthRepository._internal();
  static final AuthRepository instance = AuthRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;
  final _storage = const FlutterSecureStorage();

  static const _cacheKey = 'current_user';

  // ─── Sign In ─────────────────────────────────────────────────────────────

  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/login',
      body: {'email': email, 'password': password},
      auth: false,
    );
    final token = response['token'] as String;
    await _api.saveToken(token);
    final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
    await _cacheUser(user);
    return user;
  }

  // ─── Sign Up ─────────────────────────────────────────────────────────────

  Future<UserEntity> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/register',
      body: {'username': username, 'email': email, 'password': password},
      auth: false,
    );
    final token = response['token'] as String;
    await _api.saveToken(token);
    final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
    await _cacheUser(user);
    return user;
  }

  // ─── Sign Out ────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _api.clearToken();
    await _db.clearTable('users');
    await _db.invalidateCache(_cacheKey);
  }

  // ─── Get Current User (cache-first) ──────────────────────────────────────

  Future<UserEntity?> getCurrentUser() async {
    // 1. Try cache
    final db = await _db.database;
    final rows = await db.query('users', limit: 1);
    if (rows.isNotEmpty) return UserModel.fromDb(rows.first);

    // 2. Need a token to call network
    final token = await _api.getToken();
    if (token == null) return null;

    // 3. Network fallback
    try {
      final response = await _api.get('/auth/me');
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      await _cacheUser(user);
      return user;
    } catch (_) {
      return null;
    }
  }

  // ─── Token check ─────────────────────────────────────────────────────────

  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }

  // ─── Update Profile ────────────────────────────────────────────────────────

  Future<UserEntity> updateProfile({
    required String username,
    required String bio,
  }) async {
    final response = await _api.put(
      '/auth/profile',
      body: {'username': username, 'bio': bio},
    );
    final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
    await _cacheUser(user);
    return user;
  }

  // ─── Delete Account ────────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    try {
      await _api.delete('/auth/profile');
    } catch (_) {
      // Ignore API errors on fallback deletion
    }
    await signOut();
    
    // Clear other user tables locally
    final db = await _db.database;
    await db.delete('saved_messages');
    await db.delete('blocked_users');
    await db.delete('chat_messages');
    await db.delete('posts');
    await db.delete('connections');
    await db.delete('notifications');
  }

  // ─── Private helpers ─────────────────────────────────────────────────────

  Future<void> _cacheUser(UserModel user) async {
    final db = await _db.database;
    await db.insert(
      'users',
      user.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _db.markCacheFresh(_cacheKey);
  }
}
