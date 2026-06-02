import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';
import 'mock_api_backend.dart';

/// Centralised HTTP client.
/// All repositories use [ApiClient.instance] to make authenticated requests.
///
/// In debug mode [ApiConfig.useMockBackend] routes auth and other calls through
/// [MockApiBackend] so the app works without api.vibe.app deployed.
class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  static const String baseUrl = ApiConfig.testBaseUrl;

  final _storage = const FlutterSecureStorage();

  // ─── Token helpers ───────────────────────────────────────────────────────

  Future<String?> getToken() => _storage.read(key: 'auth_token');

  Future<void> saveToken(String token) =>
      _storage.write(key: 'auth_token', value: token);

  Future<void> clearToken() => _storage.delete(key: 'auth_token');

  // ─── Base headers ────────────────────────────────────────────────────────

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ─── HTTP verbs ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> get(String path) async {
    if (ApiConfig.useMockBackend) {
      final normalized = path.split('?').first;
      if (normalized == '/auth/me') {
        final token = await getToken();
        return MockApiBackend.userForToken(token);
      }
      if (normalized == '/profile/me') {
        final token = await getToken();
        final user =
            MockApiBackend.userForToken(token)['user'] as Map<String, dynamic>;
        return {
          'profile': {
            ...user,
            'vibes': user['vibes'] ?? <String, String>{},
          },
        };
      }
      return MockApiBackend.get(path);
    }
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
  
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(auth: auth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    if (ApiConfig.useMockBackend) {
      return MockApiBackend.put(path, body: body);
    }
    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    if (ApiConfig.useMockBackend) {
      return MockApiBackend.delete(path);
    }
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  // ─── Response handler ────────────────────────────────────────────────────

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Invalid server response',
      );
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(
      statusCode: response.statusCode,
      message: body['message'] as String? ?? 'Unknown error',
    );
  }

  /// Whether the app is using the in-memory / ReqRes dev backend.
  static bool get isMockMode => ApiConfig.useMockBackend;

  /// Log mock mode once at startup (debug only).
  static void logBackendMode() {
    if (kDebugMode) {
      debugPrint(
        ApiConfig.useMockBackend
            ? '🧪 Vibe API: MOCK mode (OTP ${ApiConfig.mockOtpCode}, '
                'password ${ApiConfig.mockPassword}, '
                'ReqRes ${ApiConfig.reqresDemoEmail})'
            : '🌐 Vibe API: $baseUrl',
      );
    }
  }
}

// ─── Exception ───────────────────────────────────────────────────────────────

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
