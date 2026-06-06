import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/profile_model.dart';
import '../../data/repository/profile_repository.dart';

/// Repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository.instance;
});

/// Global provider for the UI to consume using AsyncNotifier
final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileModel?>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<ProfileModel?> {
  // Access the repository using the modern ref.read pattern
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  /// The build method replaces your initial fetch logic.
  /// Riverpod calls this automatically when the provider is first read/watched.
  @override
  Future<ProfileModel?> build() async {
    print("Running initial profile fetch...");
    return _repository.getProfile();
  }

  /// Manual refresh logic using AsyncValue.guard
  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.getProfile());
  }

  /// Updates profile information and updates the local state
  Future<void> updateProfile({
    required String name,
    required String bio
  }) async {
    // Optional: Capture previous state if you want fallback capabilities
    final previousData = state.value;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await _repository.updateNameAndBio(
        name: name,
        bio: bio // Pass current vibes along safely
      );
    });
  }

  /// Updates vibes/interests and applies changes instantly to local state
  Future<void> updateInterests(List<Map<String, String>> vibesList) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Run the remote API call via repository
      await _repository.updateInterests(vibesList);

      // 2. Reconstruct map locally to sync UI without another network fetch
      final Map<String, String> reconstructedMap = {
        for (var item in vibesList) item['interest']!: item['score']!,
      };

      // 3. Update local state using copyWith if previous data exists
      if (state.value != null) {
        return state.value!.copyWith(vibes: reconstructedMap);
      }
      return null;
    });
  }
}
