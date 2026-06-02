import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/registration_storage.dart';
import '../models/verify_email_result.dart';

export '../models/verify_email_result.dart';

/// Calls POST /auth/verify-email and persists the session id on success.
class EmailVerificationRepository {
  EmailVerificationRepository._internal();
  static final EmailVerificationRepository instance =
      EmailVerificationRepository._internal();

  final _storage = RegistrationStorage.instance;

  Future<VerifyEmailResult> verifyEmail(String email) async {
    try {
      final VerifyEmailResult result;
      // if (ApiConfig.useMockBackend) {
      //   // result = await MockApiBackend.verifyEmail(email);
      // } else {

      // }

      result = await _verifyEmailProduction(email);

      if (result is VerifyEmailSuccess) {
        await _storage.saveVerificationSession(
          sessionId: result.sessionId,
          email: result.email,
        );
      }
      return result;
    } on http.ClientException {
      return const VerifyEmailNetworkError(
        'No internet connection. Please check your network and try again.',
      );
    } catch (_) {
      return const VerifyEmailNetworkError(
        'Something went wrong. Please try again.',
      );
    }
  }

  Future<VerifyEmailResult> _verifyEmailProduction(String email) async {
    final response = await http
        .post(
          Uri.parse('${ApiClient.baseUrl}/auth/verify-email'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        )
        .timeout(const Duration(seconds: 30));

    Map<String, dynamic>? body;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } catch (_) {}

    switch (response.statusCode) {
      case 201:
        final id = body?['id'] as String?;
        if (id == null || id.isEmpty) {
          return const VerifyEmailNetworkError(
            'Invalid server response. Please try again.',
          );
        }
        return VerifyEmailSuccess(sessionId: id, email: email);
      case 400:
        return const VerifyEmailUserExists();
      case 500:
        return const VerifyEmailServerError();
      default:
        return VerifyEmailNetworkError(
          body?['message'] as String? ??
              'Request failed (${response.statusCode}). Please try again.',
        );
    }
  }
}
