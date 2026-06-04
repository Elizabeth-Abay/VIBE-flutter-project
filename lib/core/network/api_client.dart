import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';
import 'mock_api_backend.dart';
import '../storage/registration_storage.dart';

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

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      // 🎯 Ask your central storage for the token instead of doing it locally!
      final token = await RegistrationStorage.instance.getAccessToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) => RegistrationStorage.instance.saveAuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );

  Future<void> clearToken() => RegistrationStorage.instance.clearAuthTokens();

  Future<String?> getToken() => RegistrationStorage.instance.getAccessToken();

  // ─── HTTP verbs

  Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );

    final bodyElt = response.body;
    // it is an array

    print("bodyElt is $bodyElt");
    if (path == '/connection/matched-users'){
      return _handleResponseForMatched(response);
    }

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

  http.MultipartRequest createMultipartRequest(String method, String path) {
    final url = Uri.parse('$baseUrl$path');
    final request = http.MultipartRequest(method, url);

    final _token = getToken();

    // Automatically inject your bearer access token if it exists

    request.headers['Authorization'] = 'Bearer $_token';

    // Express 'multer' middleware expects standard multipart content type headers
    request.headers['Accept'] = 'application/json';

    return request;
  }

  // ─── 2. Send Multipart Request Helper ──────────────────────────────────────
  /// Sends the streamed multipart payload and processes it using the standard client parser.
  Future<Map<String, dynamic>> sendMultipartRequest(
    http.MultipartRequest request,
  ) async {
    try {
      // 1. Sends the request down the pipeline stream
      final streamedResponse = await request.send();

      // 2. Converts the http.StreamedResponse into a standard http.Response object
      final response = await http.Response.fromStream(streamedResponse);

      // 3. Passes it down to your unified error handler method!
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponseForMatched(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
      print("body after decoding $body");
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

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
      print("body after decoding $body");
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

// ─── Exception ─────

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
