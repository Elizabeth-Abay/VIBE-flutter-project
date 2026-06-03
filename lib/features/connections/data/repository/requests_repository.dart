// used to get all the requests sent to u
// and all request u have sent out to ppl
// and also cancel the requests
import 'dart:developer' as developer;
import '../../data/models/request_sent_model.dart';
import '../../../../core/network/api_client.dart';

/// Standalone Repository handling incoming and outgoing connection requests.
/// Interfaces with Express endpoints protected by TokenDecode middleware.
class RequestRepository {
  // Private constructor for enforcing the singleton pattern
  RequestRepository._internal();
  static final RequestRepository instance = RequestRepository._internal();

  // Mocking your standard global core API service instance
  // Replace this with your actual network runner dependency (e.g., DioClient, ApiService)
  final _api = ApiClient.instance;

  /// ─── 1. GET: Fetch Pending Incoming Requests ──────────────────────────────
  /// Endpoint: GET `/connection/received-requests`
  /// Fetches users who have sent a connection request to the logged-in student.
  Future<List<RequestsSentToUserModel>> getReceivedRequests() async {
    try {
      final response = await _api.get('/request/received-requests');

      final List<dynamic> dataList = response as List<dynamic>;

      print(" getReceivedRequest  $dataList");

      return dataList
          .map(
            (json) =>
                RequestsSentToUserModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching received requests from repository',
        error: e,
        stackTrace: stackTrace,
        name: 'RequestRepository',
      );
      throw Exception(
        'Failed to load incoming connection requests. Please try again.',
      );
    }
  }

  /// ─── 2. GET: Fetch Pending Outgoing Requests ──────────────────────────────
  /// Endpoint: GET `/connection/sent-requests`
  /// Fetches connection requests sent by the logged-in student that are still awaiting a response.
  Future<List<RequestsSentToUserModel>> getSentRequests() async {
    try {
      final response = await _api.get('/request/sent-requests');

      final List<dynamic> dataList = response as List<dynamic>;

      print(" getSentRequests  $dataList");

      return dataList
          .map(
            (json) =>
                RequestsSentToUserModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching sent requests from repository',
        error: e,
        stackTrace: stackTrace,
        name: 'RequestRepository',
      );
      throw Exception(
        'Failed to load sent connection requests. Please try again.',
      );
    }
  }

  /// ─── 3. POST: Cancel Outgoing Connection Request ──────────────────────────
  /// Endpoint: POST `/connection/cancel-request`
  /// Revokes an outgoing pending connection request before the target user accepts or rejects it.
  /// Expects JSON payload matching your Joi schema constraint: `{ "cancelledId": "userId" }`
  Future<bool> cancelRequest(String targetUserId) async {
    try {
      final response = await _api.post(
        '/request/cancel-request',
        body: {
          'canceled':
              targetUserId, // Matches RequestSchema.cancelRequest Joi key
        },
      );

      print("cancelRequest  $response");

      // Robust check supporting both structural formats: plain boolean or map payload status checks

      return response['success'] == true;
    } catch (e, stackTrace) {
      developer.log(
        'Error cancelling connection request for user: $targetUserId',
        error: e,
        stackTrace: stackTrace,
        name: 'RequestRepository',
      );
      return false;
    }
  }
}
