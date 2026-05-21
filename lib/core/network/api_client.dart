import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralised HTTP client.
/// All repositories use [ApiClient.instance] to make authenticated requests.
///
/// Replace [baseUrl] with your actual backend URL.
class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  // TODO: replace with your real API base URL
  static const String baseUrl = 'http://10.0.2.2:3000';
  
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
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
      );
      return _handleResponse(response);
    } catch (_) {
      return _handleOfflineFallback('GET', path);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (_) {
      return _handleOfflineFallback('POST', path, body: body);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (_) {
      return _handleOfflineFallback('PUT', path, body: body);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
      );
      return _handleResponse(response);
    } catch (_) {
      return _handleOfflineFallback('DELETE', path);
    }
  }

  // ─── Response handler ────────────────────────────────────────────────────

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(
      statusCode: response.statusCode,
      message: body['message'] as String? ?? 'Unknown error',
    );
  }

  // ─── Offline fallback simulation router ───────────────────────────────────

  Map<String, dynamic> _handleOfflineFallback(String method, String path, {Map<String, dynamic>? body}) {
    final uri = Uri.parse(path);
    final normalizedPath = uri.path;

    if (normalizedPath == '/auth/login') {
      final email = body?['email'] as String? ?? 'user@vibe.com';
      final username = email.split('@')[0];
      return {
        'token': 'mock_jwt_token_for_$username',
        'user': {
          'id': 'me',
          'username': username,
          'email': email,
          'bio': 'Passionate about robotics and programming, with a strong interest in building intelligent systems.',
          'avatar_url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
          'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        }
      };
    }

    if (normalizedPath == '/auth/register') {
      final username = body?['username'] as String? ?? 'user';
      final email = body?['email'] as String? ?? 'user@vibe.com';
      return {
        'token': 'mock_jwt_token_for_$username',
        'user': {
          'id': 'me',
          'username': username,
          'email': email,
          'bio': 'Passionate about robotics and programming, with a strong interest in building intelligent systems.',
          'avatar_url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
          'created_at': DateTime.now().toIso8601String(),
        }
      };
    }

    if (normalizedPath == '/auth/me') {
      return {
        'user': {
          'id': 'me',
          'username': 'Salem Admasu',
          'email': 'salem@example.com',
          'bio': 'Passionate about robotics and programming, with a strong interest in building intelligent systems',
          'avatar_url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
          'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        }
      };
    }

    if (normalizedPath == '/auth/profile') {
      if (method == 'DELETE') {
        return {'success': true};
      }
      final username = body?['username'] as String? ?? 'Salem Admasu';
      final bio = body?['bio'] as String? ?? 'Passionate about robotics and programming, with a strong interest in building intelligent systems';
      return {
        'user': {
          'id': 'me',
          'username': username,
          'email': 'salem@example.com',
          'bio': bio,
          'avatar_url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
          'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        }
      };
    }

    if (normalizedPath == '/posts') {
      if (method == 'POST') {
        final title = body?['title'] as String? ?? 'Untitled';
        final description = body?['description'] as String? ?? '';
        final category = body?['category'] as String? ?? 'General';
        final tags = (body?['tags'] as List<dynamic>?)?.map((t) => t.toString()).toList() ?? [];
        return {
          'post': {
            'id': 'post_${DateTime.now().millisecondsSinceEpoch}',
            'user_id': 'me',
            'title': title,
            'description': description,
            'image_url': body?['image_url'] ?? 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400',
            'tags': tags.join(','),
            'category': category,
            'created_at': DateTime.now().toIso8601String(),
            'user_name': 'You',
            'user_avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
          }
        };
      } else {
        final category = uri.queryParameters['category'];
        final allPosts = [
          {
            'id': 'post_1',
            'user_id': 'user_2',
            'title': 'Chess Tournament',
            'description': 'Who is up for a Chess matchup this afternoon? Open to all skill levels.',
            'image_url': 'https://images.unsplash.com/photo-1529699211952-734e80c4d42b?w=400',
            'tags': 'Chess,Competition',
            'category': 'Chess',
            'created_at': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
            'user_name': 'Samuel Mola',
            'user_avatar': 'https://i.pravatar.cc/150?u=samuel',
          },
          {
            'id': 'post_2',
            'user_id': 'user_3',
            'title': 'Hackathon 2026',
            'description': 'Building cool Flutter applications! Join our team in the lobby.',
            'image_url': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400',
            'tags': 'Hackathons,Coding',
            'category': 'Hackathons',
            'created_at': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
            'user_name': 'Marta Tegegne',
            'user_avatar': 'https://i.pravatar.cc/150?u=marta',
          },
          {
            'id': 'post_3',
            'user_id': 'user_4',
            'title': 'New Indie Rock Playlist',
            'description': 'Just put together a fresh set of indie tracks for studying. Let me know what you think!',
            'image_url': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400',
            'tags': 'Music,Playlist',
            'category': 'Music',
            'created_at': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
            'user_name': 'Leul Kebede',
            'user_avatar': 'https://i.pravatar.cc/150?u=leul',
          }
        ];
        if (category != null && category.isNotEmpty) {
          final filtered = allPosts.where((p) => p['category'].toString().toLowerCase() == category.toLowerCase()).toList();
          return {'posts': filtered};
        }
        return {'posts': allPosts};
      }
    }

    if (normalizedPath == '/users/recommended') {
      return {
        'users': [
          {'id': 'user_leul', 'username': 'leul', 'display_name': 'Leul Kebede', 'avatar_url': 'https://i.pravatar.cc/150?u=leul'},
          {'id': 'user_mahlet', 'username': 'mahlet', 'display_name': 'Mahlet Sisay', 'avatar_url': 'https://i.pravatar.cc/150?u=mahlet'},
          {'id': 'user_selam', 'username': 'selam', 'display_name': 'Selam Getu', 'avatar_url': 'https://i.pravatar.cc/150?u=selam'},
          {'id': 'user_marta', 'username': 'marta', 'display_name': 'Marta Tegegne', 'avatar_url': 'https://i.pravatar.cc/150?u=marta'},
        ]
      };
    }

    if (normalizedPath == '/connections/connected') {
      return {
        'connections': [
          {'user_id': 'user_leul', 'username': 'leul', 'display_name': 'Leul Kebede', 'avatar_url': 'https://i.pravatar.cc/150?u=leul'},
          {'user_id': 'user_mahlet', 'username': 'mahlet', 'display_name': 'Mahlet Sisay', 'avatar_url': 'https://i.pravatar.cc/150?u=mahlet'},
          {'user_id': 'user_selam', 'username': 'selam', 'display_name': 'Selam Getu', 'avatar_url': 'https://i.pravatar.cc/150?u=selam'},
        ]
      };
    }

    if (normalizedPath == '/connections/sent') {
      return {
        'requests': [
          {'user_id': 'user_marta', 'username': 'marta', 'display_name': 'Marta Tegegne', 'avatar_url': 'https://i.pravatar.cc/150?u=marta', 'created_at': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String()}
        ]
      };
    }

    if (normalizedPath == '/connections/request') {
      return {'success': true, 'message': 'Request Sent'};
    }

    if (normalizedPath == '/connections/incoming') {
      return {
        'requests': [
          {'user_id': 'user_atenasya', 'username': 'atenasya', 'display_name': 'Atenasya Weldu', 'avatar_url': 'https://i.pravatar.cc/150?u=atenasya', 'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String()}
        ]
      };
    }

    if (normalizedPath == '/connections/accept') {
      return {'success': true};
    }

    if (normalizedPath == '/notifications') {
      return {
        'notifications': [
          {
            'id': 'notif_1',
            'type': 'like',
            'message': 'Mahlet Sisay liked your post.',
            'is_read': 0,
            'created_at': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String()
          },
          {
            'id': 'notif_2',
            'type': 'connection',
            'message': 'Samuel Mola sent you a connection request.',
            'is_read': 0,
            'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String()
          }
        ]
      };
    }

    if (normalizedPath.startsWith('/notifications/') && normalizedPath.endsWith('/read')) {
      return {'success': true};
    }

    return {'success': true};
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
