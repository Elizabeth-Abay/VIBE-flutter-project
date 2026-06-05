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
      '/interest/put-in-interests',
      body: {'interestedIn': formattedVibesList},
    );

    return response['success'];
  }

  Future<bool> getInterests() async {

    final response = await _api.get(
      '/interest/get-interests'
    );

    return response['success'];
  }
}
