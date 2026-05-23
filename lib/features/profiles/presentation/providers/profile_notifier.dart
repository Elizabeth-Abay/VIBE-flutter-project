import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/profile_repository.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

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
  final _repo = ProfileRepository.instance;

  @override
  ProfileState build() {
    loadProfile();
    return const ProfileLoading();
  }

  // ── Load ────────────────────────────────────────────────────────────────

  Future<void> loadProfile() async {
    state = const ProfileLoading();
    try {
      final profile = await _repo.getProfile();
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
      final updated = await _repo.updateProfile(
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

  // ── Save interests ───────────────────────────────────────────────────────

  Future<void> saveInterests(Map<String, String> vibes) async {
    try {
      await _repo.saveInterests(vibes);
      final current = state;
      if (current is ProfileLoaded) {
        state = ProfileLoaded(current.profile.copyWith(vibes: vibes));
      }
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  // ── Delete account ───────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    state = const ProfileLoading();
    try {
      await _repo.deleteAccount();
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
