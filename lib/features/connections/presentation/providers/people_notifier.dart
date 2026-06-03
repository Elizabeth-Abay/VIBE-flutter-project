import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/connection_repository.dart';
import '../../domain/entity/matched_user.dart';

enum ConnectStatus { idle, loading, success }

class PeopleState {
  final List<MatchedUser> users;
  final Map<String, ConnectStatus> buttonStatuses;

  const PeopleState({required this.users, required this.buttonStatuses});

  PeopleState copyWith({
    List<MatchedUser>? users,
    Map<String, ConnectStatus>? buttonStatuses,
  }) {
    return PeopleState(
      users: users ?? this.users,
      buttonStatuses: buttonStatuses ?? this.buttonStatuses,
    );
  }
}

final peopleNotifierProvider =
    StateNotifierProvider<PeopleNotifier, AsyncValue<PeopleState>>((ref) {
      return PeopleNotifier();
    });

class PeopleNotifier extends StateNotifier<AsyncValue<PeopleState>> {
  PeopleNotifier() : super(const AsyncLoading()) {
    fetchMatches();
  }

  final _repo = ConnectionRepository.instance;

  Future<void> fetchMatches() async {
    state = const AsyncLoading();
    try {
      final list = await _repo.getMatchedUsers();
      state = AsyncValue.data(PeopleState(users: list, buttonStatuses: {}));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> connectWithUser(String userId) async {
    final currentAsync = state;
    if (currentAsync is! AsyncData) return;
    final current = currentAsync.value;

    // Set clicked button to spinning wheel
    state = AsyncValue.data(
      current.copyWith(
        buttonStatuses: Map.from(current.buttonStatuses)
          ..[userId] = ConnectStatus.loading,
      ),
    );

    try {
      final isSuccessful = await _repo.requestConnection(userId);

      if (isSuccessful) {
        // Change color state tracking variable to success (Green)
        state = AsyncValue.data(
          state.value!.copyWith(
            buttonStatuses: Map.from(state.value!.buttonStatuses)
              ..[userId] = ConnectStatus.success,
          ),
        );

        // Wait 2 seconds, then remove the card item completely from memory
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          state = AsyncValue.data(
            state.value!.copyWith(
              users: state.value!.users.where((u) => u.id != userId).toList(),
              buttonStatuses: Map.from(state.value!.buttonStatuses)
                ..remove(userId),
            ),
          );
        }
      } else {
        _resetButton(userId);
      }
    } catch (_) {
      _resetButton(userId);
    }
  }

  void _resetButton(String userId) {
    if (mounted && state is AsyncData) {
      state = AsyncValue.data(
        state.value!.copyWith(
          buttonStatuses: Map.from(state.value!.buttonStatuses)
            ..[userId] = ConnectStatus.idle,
        ),
      );
    }
  }
}
