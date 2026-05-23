import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_client.dart';

/// Simulates the Vibe REST API for local / web development.
/// OTP is always [ApiConfig.mockOtpCode]; sign-in also supports ReqRes demo user.
class MockApiBackend {
  MockApiBackend._();

  static final Map<String, String> _otpByEmail = {};
  static final Set<String> _verifiedEmails = {};
  static final Map<String, Map<String, dynamic>> _usersByToken = {};

  static String _normalizePath(String path) => path.split('?').first;

  static Future<Map<String, dynamic>> get(String path) async {
    await _delay();
    return _handle('GET', _normalizePath(path), null);
  }

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    await _delay();
    final normalized = _normalizePath(path);
    if (normalized == '/auth/login' && _shouldUseReqres(body)) {
      return _reqresLogin(body!);
    }
    return _handle('POST', normalized, body);
  }

  static Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    await _delay();
    return _handle('PUT', _normalizePath(path), body);
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    await _delay();
    return _handle('DELETE', _normalizePath(path), null);
  }

  static Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 350));

  static bool _shouldUseReqres(Map<String, dynamic>? body) {
    if (body == null) return false;
    return body['email'] == ApiConfig.reqresDemoEmail &&
        body['password'] == ApiConfig.reqresDemoPassword;
  }

  /// Real network call to ReqRes (online placeholder for login).
  static Future<Map<String, dynamic>> _reqresLogin(
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.reqresBaseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': body['email'],
        'password': body['password'],
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Invalid ReqRes credentials.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = _buildUser(
      id: 'reqres_${body['email']}',
      email: body['email'] as String,
      username: 'eve_holt',
    );
    _usersByToken[token] = user;
    return {'token': token, 'user': user};
  }

  static Future<Map<String, dynamic>> _handle(
    String method,
    String path,
    Map<String, dynamic>? body,
  ) async {
    switch (path) {
      // ─── Auth ──────────────────────────────────────────────────────────
      case '/auth/send-otp':
        return _sendOtp(body!);

      case '/auth/verify-otp':
        return _verifyOtp(body!);

      case '/auth/login':
        return _login(body!);

      case '/auth/register':
        return _register(body!);

      case '/auth/me':
        return _me(method);

      case '/auth/account':
        return {'message': 'Account deleted'};

      // ─── Profile ───────────────────────────────────────────────────────
      case '/profile/me':
        if (method == 'GET') return {'profile': _defaultProfile()};
        if (method == 'PUT') {
          return {'profile': {..._defaultProfile(), ...?body}};
        }
        break;

      case '/profile/interests':
        return {'message': 'Interests saved'};

      // ─── Lists (empty placeholders) ────────────────────────────────────
      case '/posts':
        return {'posts': _samplePosts()};

      case '/users/recommended':
        return {'users': _sampleRecommended()};

      case '/notifications':
        return {'notifications': _sampleNotifications()};

      case '/connections/incoming':
        return {'requests': []};

      case '/connections/connected':
        return {'connections': []};

      case '/connections/sent':
        return {'requests': []};

      case '/users/blocked':
        return {'users': []};

      case '/chats':
        return {'conversations': _sampleChats()};

      case '/chats/saved':
        return {'messages': []};

      case '/settings':
        return {
          'settings': {
            'push_notifications': true,
            'dark_mode': true,
            'profile_private': false,
          },
        };
    }

    // Dynamic paths: /chats/:id/messages, /connections/request, etc.
    if (path.startsWith('/chats/') && path.endsWith('/messages')) {
      if (method == 'GET') return {'messages': _sampleMessages()};
      if (method == 'POST') {
        return {
          'message': {
            'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
            'sender_id': 'me',
            'text': body?['text'] ?? '',
            'created_at': DateTime.now().toIso8601String(),
          },
        };
      }
    }

    if (path == '/connections/request' ||
        path.startsWith('/connections/accept') ||
        path.startsWith('/connections/request/') ||
        path.startsWith('/notifications/') ||
        path.startsWith('/users/') && path.contains('/block') ||
        path == '/posts' && method == 'POST') {
      return {'message': 'ok'};
    }

    if (path == '/media/upload') {
      return {'url': 'https://picsum.photos/seed/vibe/400/300'};
    }

    return {'message': 'ok'};
  }

  static Map<String, dynamic> _sendOtp(Map<String, dynamic> body) {
    final email = body['email'] as String;
    if (email == 'taken@vibe.dev') {
      throw const ApiException(
        statusCode: 409,
        message: 'This account already exists. Try signing in.',
      );
    }
    _otpByEmail[email] = ApiConfig.mockOtpCode;
    return {
      'message': 'OTP sent (dev mode: use ${ApiConfig.mockOtpCode})',
    };
  }

  static Map<String, dynamic> _verifyOtp(Map<String, dynamic> body) {
    final email = body['email'] as String;
    final otp = body['otp'] as String;
    if (_otpByEmail[email] != otp && otp != ApiConfig.mockOtpCode) {
      throw const ApiException(
        statusCode: 400,
        message: 'Invalid or expired code.',
      );
    }
    _verifiedEmails.add(email);
    return {'message': 'Verified', 'email': email};
  }

  static Map<String, dynamic> _login(Map<String, dynamic> body) {
    final email = body['email'] as String;
    final password = body['password'] as String;
    if (password != ApiConfig.mockPassword) {
      throw const ApiException(
        statusCode: 401,
        message:
            'Invalid password. Dev mode: use "${ApiConfig.mockPassword}" or ReqRes demo user.',
      );
    }
    final token = 'mock_token_${email.hashCode}';
    final user = _buildUser(
      id: 'user_${email.hashCode}',
      email: email,
      username: email.split('@').first,
    );
    _usersByToken[token] = user;
    return {'token': token, 'user': user};
  }

  static Map<String, dynamic> _register(Map<String, dynamic> body) {
    final email = body['email'] as String;
    if (!_verifiedEmails.contains(email)) {
      throw const ApiException(
        statusCode: 403,
        message:
            'Email not verified. Complete OTP verification before signing up.',
      );
    }
    final token = 'mock_token_${email.hashCode}';
    final user = _buildUser(
      id: 'user_${email.hashCode}',
      email: email,
      username: body['username'] as String,
    );
    _usersByToken[token] = user;
    _verifiedEmails.remove(email);
    return {'token': token, 'user': user};
  }

  static Map<String, dynamic> _me(String method) {
    // Token lookup happens in ApiClient via Authorization header mock:
    // For mock, /auth/me returns default profile if no token context.
    return {'user': _defaultProfile()};
  }

  static Map<String, dynamic> userForToken(String? token) {
    if (token != null && _usersByToken.containsKey(token)) {
      return {'user': _usersByToken[token]!};
    }
    return {'user': _defaultProfile()};
  }

  static Map<String, dynamic> _buildUser({
    required String id,
    required String email,
    required String username,
  }) =>
      {
        'id': id,
        'username': username,
        'email': email,
        'bio': 'Vibe dev account',
        'avatar_url': '',
        'created_at': DateTime.now().toIso8601String(),
      };

  static Map<String, dynamic> _defaultProfile() => _buildUser(
        id: 'user_dev',
        email: 'dev@vibe.app',
        username: 'vibe_dev',
      );

  static List<Map<String, dynamic>> _sampleNotifications() => [
        {
          'id': 'notif_1',
          'type': 'like',
          'message': 'Alex liked your post',
          'is_read': 0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 'notif_2',
          'type': 'comment',
          'message': 'Sam commented on your vibe',
          'is_read': 0,
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
        },
      ];

  static List<Map<String, dynamic>> _samplePosts() => [
        {
          'id': 'post_1',
          'user_id': 'user_dev',
          'title': 'Welcome to Vibe',
          'description': 'Mock feed — connect your real API when ready.',
          'image_url': 'https://picsum.photos/seed/post1/600/400',
          'tags': ['dev', 'mock'],
          'category': 'General',
          'user_name': 'Vibe Dev',
          'user_profile_image_url': '',
          'created_at': DateTime.now().toIso8601String(),
        },
      ];

  static List<Map<String, dynamic>> _sampleRecommended() => [
        {
          'id': 'rec_1',
          'display_name': 'Alex Chen',
          'username': 'alexc',
          'avatar_url': '',
        },
      ];

  static List<Map<String, dynamic>> _sampleChats() => [
        {
          'id': 'chat_1',
          'participant_name': 'Alex Chen',
          'participant_avatar': '',
          'last_message': 'Hey! This is mock chat data.',
        },
      ];

  static List<Map<String, dynamic>> _sampleMessages() => [
        {
          'id': 'm1',
          'sender_id': 'other',
          'text': 'Hello from mock backend 👋',
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String(),
        },
        {
          'id': 'm2',
          'sender_id': 'me',
          'text': 'Hi! Running in dev mock mode.',
          'created_at': DateTime.now().toIso8601String(),
        },
      ];
}
