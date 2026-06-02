import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists registration / email-verification session data securely.
class RegistrationStorage {
  RegistrationStorage._internal();
  static final RegistrationStorage instance = RegistrationStorage._internal();

  static const _verificationSessionIdKey = 'verification_session_id';
  static const _verificationEmailKey = 'verification_email';

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


}
