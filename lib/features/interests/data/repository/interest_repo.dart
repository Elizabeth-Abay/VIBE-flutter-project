import '../../../../core/network/api_client.dart';

class InterestsRepository {
  InterestsRepository._internal();
  static final InterestsRepository instance = InterestsRepository._internal();

  final _api = ApiClient.instance;

  /// Sends the formatted array of interest scores straight to the server
  Future<bool> saveInterests(List<Map<String, int>> formattedVibesList) async {
    //print("Foramated interests $formattedVibesList");

    final response = await _api.post(
      '/interest/put-in-interests',
      body: {'interestedIn': formattedVibesList},
    );

    return response['success'];
  }

  Future<bool> updateInterests(
    List<Map<String, int>> formattedVibesList,
  ) async {
    //print("Foramated interests $formattedVibesList");

    final response = await _api.post(
      '/interest/update-interests',
      body: {'interestedIn': formattedVibesList},
    );

    return response['success'];
  }

  Future<List<Map<String, dynamic>>> fetchAvailableInterests() async {
    final response = await ApiClient.instance.get('/interest/get-interests');
    if (response['success'] == true && response['data'] != null) {
      return List<Map<String, dynamic>>.from(response['data']);
    }
    return [];
  }
}
