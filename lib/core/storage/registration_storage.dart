import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists registration / email-verification session data securely.
class RegistrationStorage {
  RegistrationStorage._internal();
  static final RegistrationStorage instance = RegistrationStorage._internal();

  static const _verificationSessionIdKey = 'verification_session_id';
  static const _verificationEmailKey = 'verification_email';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final _storage = const FlutterSecureStorage();

  Future<void> saveVerificationSession({
    required String userId,
    required String email,
  }) async {
    await _storage.write(key: _verificationSessionIdKey, value: userId);
    await _storage.write(key: _verificationEmailKey, value: email);
  }

  Future<String?> getVerificationSessionId() =>
      _storage.read(key: _verificationSessionIdKey);

  Future<String?> getVerificationEmail() =>
      _storage.read(key: _verificationEmailKey);

  Future<void> clearVerificationSession() async {
    await _storage.delete(key: _verificationSessionIdKey);
    await _storage.delete(key: _verificationEmailKey);
  }

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// Reads the active accessToken for intercepting API header insertions
  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  /// Reads the active refreshToken to pass down during token refresh cycles
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  /// Completely signs the user out by deleting active credentials
  Future<void> clearAuthTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
