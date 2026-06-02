import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;
import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../local/user_local_cache.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Auth repository: single source of truth for sign-in, sign-up,
/// sign-out, and fetching the currently cached user.
class AuthRepository {
  AuthRepository._internal();
  static final AuthRepository instance = AuthRepository._internal();

  final _db = DatabaseHelper.instance;
  final _api = ApiClient.instance;
  // final _storage = const FlutterSecureStorage();

  static const _cacheKey = 'current_user';

  Future<bool> signIn({required String email, required String password}) async {
    final response = await _api.post(
      '/auth/login',
      body: {'email': email, 'password': password},
      auth: false,
    );

    if (!response['success']) return false;

    final tokens = response['data'] as Map<String, String>;
    // bc it is { accessToken , refreshToken }

    final accessToken = tokens['accessToken'];
    final refreshToken = tokens['refreshToken'];
    await _api.saveToken(accessToken : accessToken! , refreshToken:  refreshToken!);
    
    return true;
  }

  Future<bool> signUp({
    required String username,
    required String password,
    required String name,
  }) async {
    final response = await _api.post(
      '/profile/enter-user-info-first-time',
      body: {'userName': username, 'password': password, 'name': name},
      auth: true,
    );

    // final token = response['token'] as String;
    // await _api.saveToken(token);

    if (response['success']) return true;

    return false;
  }

  Future<void> signOut() async {
    await _api.clearToken();
    await UserLocalCache.clear();
    if (kIsWeb) return;
    try {
      await _db.clearAllUserData();
    } catch (_) {}
  }

  Future<UserEntity?> getCurrentUser() async {
    if (kIsWeb) {
      final webCached = await UserLocalCache.read();
      if (webCached != null) return webCached;
    } else {
      try {
        final db = await _db.database;
        final rows = await db.query('users', limit: 1);
        if (rows.isNotEmpty) return UserModel.fromDb(rows.first);
      } catch (_) {}
    }

    final token = await _api.getToken();
    if (token == null) return null;

    try {
      final response = await _api.get('/auth/me');
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      await _cacheUser(user);
      return user;
    } catch (_) {
      return kIsWeb ? await UserLocalCache.read() : null;
    }
  }

  Future<bool> hasToken() async {
    final token = await _api.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _cacheUser(UserModel user) async {
    await UserLocalCache.save(user);
    if (kIsWeb) return;
    try {
      final db = await _db.database;
      await db.insert(
        'users',
        user.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _db.markCacheFresh(_cacheKey);
    } catch (_) {}
  }
}
