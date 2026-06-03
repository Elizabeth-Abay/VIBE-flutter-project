import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/profile_repository.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../interests/data/repository/interest_repo.dart'; // 🎯 Clean Architecture cross-feature import

// ─── Profile state ────────────────────────────────────────────────────────────

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  const ProfileLoaded(this.profile);
}

class ProfileUpdated extends ProfileState {
  final ProfileEntity profile;
  const ProfileUpdated(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final profileNotifierProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ProfileNotifier extends Notifier<ProfileState> {
  final _profileRepo = ProfileRepository.instance;
  final _interestsRepo =
      InterestsRepository.instance; // 🎯 Standalone Data Access Layer

  @override
  ProfileState build() {
    loadProfile();
    return const ProfileLoading();
  }

  // ── Load ────────────────────────────────────────────────────────────────

  Future<void> loadProfile() async {
    state = const ProfileLoading();
    try {
      final profile = await _profileRepo.getProfile();
      if (profile != null) {
        state = ProfileLoaded(profile);
      } else {
        state = const ProfileError('Could not load profile.');
      }
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  // ── Update ───────────────────────────────────────────────────────────────

  Future<void> updateProfile({
    required String username,
    required String bio,
    String? avatarUrl,
    Map<String, String>? vibes,
  }) async {
    state = const ProfileLoading();
    try {
      final updated = await _profileRepo.updateProfile(
        username: username,
        bio: bio,
        avatarUrl: avatarUrl,
        vibes: vibes,
      );
      state = ProfileUpdated(updated);
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  // ─── Save / Update Interests ─────────────────────────────────────────────

  Future<void> updateInterests(Map<String, String> vibes) async {
    // 1. Map labels to backend numeric strings (matching your schema layout)
    final Map<String, int> scoreMapping = {
      'Love': 10,
      'Like': 8,
      'Neutral': 5,
      'Bothered': 1,
      'Hate': 0,
    };

    // Format into what your backend expects: [{"interest": "Music", "score": "10"}, ...]
    final List<Map<String, int>> formattedList = vibes.entries.map((entry) {
      return {entry.key: scoreMapping[entry.value] ?? 0};
    }).toList();

    try {
      // 3. Fire payload out to your standalone network API client layer
      await _interestsRepo.updateInterests(formattedList);

      // 5. Instantly alert state stream listeners for zero-latency screen UI re-renders
      final current = state;
      if (current is ProfileLoaded) {
        state = ProfileLoaded(current.profile.copyWith(vibes: vibes));
      } else if (current is ProfileUpdated) {
        state = ProfileUpdated(current.profile.copyWith(vibes: vibes));
      }
    } catch (e) {
      // ⚠️ DO NOT set the state to ProfileError here!
      // If you do, the entire selection screen UI will crash and disappear.
      // Instead, we rethrow the network exception up to InterestsSavingNotifier so the snackbar catches it.
      rethrow;
    }
  }

  // ── Delete account ───────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    state = const ProfileLoading();
    try {
      await _profileRepo.deleteAccount();
      // Sign the user out in the auth notifier too
      await ref.read(authNotifierProvider.notifier).signOut();
      state = const ProfileDeleted();
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  ProfileEntity? get currentProfile {
    final s = state;
    if (s is ProfileLoaded) return s.profile;
    if (s is ProfileUpdated) return s.profile;
    return null;
  }
}

// ─── Blocked users ────────────────────────────────────────────────────────────

final blockedUsersProvider = FutureProvider<List<Map<String, String>>>((
  ref,
) async {
  return ProfileRepository.instance.fetchBlockedUsers();
});
