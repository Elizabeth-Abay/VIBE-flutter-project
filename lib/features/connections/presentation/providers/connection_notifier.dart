import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/connection_model.dart';
import '../../domain/entity/connected_user.dart';
import '../../domain/entity/sent_request_user.dart';
import '../../../../features/home/domain/entity/connection_request_sending_result.dart';

// ─── Connected users state & provider ────────────────────────────────────────

sealed class ConnectedState {
  const ConnectedState();
}

class ConnectedLoading extends ConnectedState {
  const ConnectedLoading();
}

class ConnectedLoaded extends ConnectedState {
  final List<ConnectedUser> users;
  const ConnectedLoaded(this.users);
}

class ConnectedError extends ConnectedState {
  final String message;
  const ConnectedError(this.message);
}

final connectedNotifierProvider =
    NotifierProvider<ConnectedNotifier, ConnectedState>(ConnectedNotifier.new);

class ConnectedNotifier extends Notifier<ConnectedState> {
  final _repo = ConnectionRepository.instance;

  @override
  ConnectedState build() {
    fetchConnected();
    return const ConnectedLoading();
  }

  Future<void> fetchConnected() async {
    state = const ConnectedLoading();
    try {
      final users = await _repo.fetchConnectedUsers();
      state = ConnectedLoaded(users);
    } catch (e) {
      state = ConnectedError(e.toString());
    }
  }

  /// Toggles the heart/like on a connected user (local only).
  void toggleLike(String userId) {
    final current = state;
    if (current is ConnectedLoaded) {
      final updated = current.users.map((u) {
        if (u.userId == userId) {
          return ConnectedUser(
            userId: u.userId,
            name: u.name,
            username: u.username,
            profileImage: u.profileImage,
            isLiked: !u.isLiked,
          );
        }
        return u;
      }).toList();
      state = ConnectedLoaded(updated);
    }
  }
}

// ─── Sent requests state & provider ──────────────────────────────────────────

sealed class SentRequestState {
  const SentRequestState();
}

class SentRequestLoading extends SentRequestState {
  const SentRequestLoading();
}

class SentRequestLoaded extends SentRequestState {
  final List<SentRequestUser> requests;
  const SentRequestLoaded(this.requests);
}

class SentRequestError extends SentRequestState {
  final String message;
  const SentRequestError(this.message);
}

final sentRequestNotifierProvider =
    NotifierProvider<SentRequestNotifier, SentRequestState>(
        SentRequestNotifier.new);

class SentRequestNotifier extends Notifier<SentRequestState> {
  final _repo = ConnectionRepository.instance;

  @override
  SentRequestState build() {
    fetchSent();
    return const SentRequestLoading();
  }

  Future<void> fetchSent() async {
    state = const SentRequestLoading();
    try {
      final requests = await _repo.fetchSentRequests();
      state = SentRequestLoaded(requests);
    } catch (e) {
      state = SentRequestError(e.toString());
    }
  }

  /// Cancels a request and removes it from state immediately (optimistic UI).
  Future<void> cancelRequest(String targetId) async {
    final current = state;
    if (current is SentRequestLoaded) {
      // Optimistic removal
      state = SentRequestLoaded(
        current.requests
            .map((r) => r.userId == targetId
                ? SentRequestUser(
                    userId: r.userId,
                    name: r.name,
                    profileImage: r.profileImage,
                    timestamp: r.timestamp,
                    isCancelled: true,
                  )
                : r)
            .toList(),
      );
      await _repo.cancelRequest(targetId);
    }
  }
}

// ─── Send connection (used from home recommended list) ────────────────────────

final sendConnectionProvider =
    NotifierProvider<SendConnectionNotifier, AsyncValue<ConnectResult?>>(
        SendConnectionNotifier.new);

class SendConnectionNotifier extends Notifier<AsyncValue<ConnectResult?>> {
  final _repo = ConnectionRepository.instance;

  @override
  AsyncValue<ConnectResult?> build() => const AsyncValue.data(null);

  Future<ConnectResult> sendRequest(String targetId) async {
    state = const AsyncValue.loading();
    final success = await _repo.sendRequest(targetId);
    final result = ConnectResult(
      statusCode: success ? 200 : 500,
      message: success ? 'Request Sent' : 'Failed to send request',
    );
    state = AsyncValue.data(result);
    return result;
  }
}
