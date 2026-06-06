import 'package:flutter/foundation.dart';

/// Toggle mock backend while [ApiClient.baseUrl] is unavailable.
///
/// When [useMockBackend] is true:
/// - OTP flow is simulated locally (code **123456**).
/// - Sign-in accepts any email with password **password123**, or ReqRes test user.
/// - Other endpoints return realistic placeholder JSON (no real server required).
class ApiConfig {
  /// `true` in debug builds; set to `false` when your real API is deployed.
  static bool useMockBackend = kDebugMode;

  static const String testBaseUrl = 'http://127.0.0.1:3000';

  static const String productionBaseUrl = 'https://api.vibe.app/v1';

  /// ReqRes public test API (real HTTP, CORS-friendly for web).
  static const String reqresBaseUrl = 'https://reqres.in/api';

  /// Demo account on ReqRes (documented on reqres.in).
  static const String reqresDemoEmail = 'eve.holt@reqres.in';
  static const String reqresDemoPassword = 'cityslicka';

  /// Mock OTP accepted on verify screen.
  static const String mockOtpCode = '123456';

  /// Mock sign-in / sign-up password when not using ReqRes demo user.
  static const String mockPassword = 'password123';
}
