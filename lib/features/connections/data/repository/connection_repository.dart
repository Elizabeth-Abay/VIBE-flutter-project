import '../../../../core/network/api_client.dart';
import '../../domain/entity/matched_user.dart';
import '../../domain/entity/connected_user.dart';

// this repo is used to make all connection related requests
class ConnectionRepository {
  ConnectionRepository._internal();
  static final ConnectionRepository instance = ConnectionRepository._internal();

  final _api = ApiClient.instance;

  // ─── GET: Fetch Matched Recommendations ──────────────────────────────────
  Future<List<MatchedUser>> getMatchedUsers() async {
    print('Hellooo');
    final response = await _api.get('/connection/matched-users');
    final dataList = response['data'];
    final List<dynamic> data = dataList as List<dynamic>;

    print("getMatchedUsers  $data");

    return data
        .map((json) => MatchedUser.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // ─── GET: Fetch Existing Friends/Connections ─────────────────────────────
  Future<List<ConnectedUser>> getAllConnections() async {
    final response = await _api.get('/connection/all-connections');
    final List<dynamic> data = response as List<dynamic>;

    print(" getAllConnections  $data");
    return data
        .map((json) => ConnectedUser.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // ─── POST: Send Connection Request ───────────────────────────────────────
  Future<bool> requestConnection(String connectToId) async {
    final response = await _api.post(
      '/connection/request-connection',
      body: {'connectToId': connectToId},
    );

    print("requestConnection  $response");
    return response['success'] == true;
  }

  // ─── POST: Accept Incoming Connection ────────────────────────────────────
  Future<bool> acceptConnection(String senderId) async {
    final response = await _api.post(
      '/connection/accept-connection',
      body: {'acceptedId': senderId}, // Matches your Node Joi schema field name
    );

    print(" acceptconnectUser  $response");

    return response['success'] == true;
  }

  // ─── POST: Reject Incoming Connection ────────────────────────────────────
  Future<bool> rejectConnection(String senderId) async {
    final response = await _api.post(
      '/connection/reject-connection',
      body: {'rejectedId': senderId},
    );

    print("reject connectUser  $response");
    return response['success'] == true;
  }

  // ─── POST: Disconnect / Unfriend User ────────────────────────────────────
  Future<bool> disconnectUser(String targetUserId) async {
    final response = await _api.post(
      '/connection/disconnect-user',
      body: {'disconnectedId': targetUserId},
    );

    print(" disconnectUser  $response");
    return response['success'] == true;
  }
}
