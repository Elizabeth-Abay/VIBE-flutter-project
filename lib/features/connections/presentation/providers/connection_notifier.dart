import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/connection_repository.dart';
import '../../domain/entity/connected_user.dart';

final _connectionRepo = ConnectionRepository.instance;

// ─── 1. Fetch Existing Connections Stream ────────────────────────────────────
/// Automatically pulls and caches your list of active friends/connections.
/// Invalidate this provider to pull a fresh list instantly after mutating states.
final connectionsFeedProvider = FutureProvider<List<ConnectedUser>>((
  ref,
) async {
  return await _connectionRepo.getAllConnections();
});

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  // Return your instance here
  return ConnectionRepository.instance;
});

final peopleNotifierProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.read(connectionRepositoryProvider);

  return await repository.getMatchedUsers();
});

// ─── 2. Global Action State Notifier ─────────────────────────────────────────
/// Manages async network transitions (idle, loading, success, error) when
/// executing actions like sending, accepting, or rejecting requests.
final connectionActionProvider =
    NotifierProvider<ConnectionActionNotifier, AsyncValue<void>>(
      ConnectionActionNotifier.new,
    );

class ConnectionActionNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null); // Initial idle state
  }

  // ─── Send Connection Request ───────────────────────────────────────────────
  Future<bool> sendRequest(String connectToId) async {
    state = const AsyncLoading();

    try {
      final success = await _connectionRepo.requestConnection(connectToId);
      if (success) {
        state = const AsyncData(null);
        return true;
      }
      state = AsyncValue.error(
        'Failed to send connection request.',
        StackTrace.current,
      );
      return false;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // ─── Accept Incoming Connection ────────────────────────────────────────────
  Future<bool> acceptRequest(String senderId) async {
    state = const AsyncLoading();

    try {
      final success = await _connectionRepo.acceptConnection(senderId);
      if (success) {
        state = const AsyncData(null);
        // Refresh your active connection feed instantly so the new friend pops up
        ref.invalidate(connectionsFeedProvider);
        return true;
      }
      state = AsyncValue.error(
        'Could not accept connection.',
        StackTrace.current,
      );
      return false;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // ─── Reject Incoming Connection ────────────────────────────────────────────
  Future<bool> rejectRequest(String senderId) async {
    state = const AsyncLoading();

    try {
      final success = await _connectionRepo.rejectConnection(senderId);
      if (success) {
        state = const AsyncData(null);
        return true;
      }
      state = AsyncValue.error('Could not reject request.', StackTrace.current);
      return false;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // ─── Disconnect / Unfriend User ────────────────────────────────────────────
  Future<bool> removeConnection(String targetUserId) async {
    state = const AsyncLoading();

    try {
      final success = await _connectionRepo.disconnectUser(targetUserId);
      if (success) {
        state = const AsyncData(null);
        // Drop the unbefriended user out of the cache list instantly
        ref.invalidate(connectionsFeedProvider);
        return true;
      }
      state = AsyncValue.error(
        'Failed to remove connection.',
        StackTrace.current,
      );
      return false;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
