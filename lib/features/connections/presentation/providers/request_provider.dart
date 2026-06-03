import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/requests_repository.dart';
import '../../domain/entity/requests_sent_to_user.dart';

final _requestRepo = RequestRepository.instance;

// ─── 1. Outgoing Sent Requests Data Cache Stream 
/// Watches and caches pending outgoing requests sent to other students.
final sentRequestsProvider = FutureProvider<List<RequestsSentToUser>>((
  ref,
) async {
  return await _requestRepo.getSentRequests();
});

// ─── 2. Incoming Received Requests Data Cache Stream 
/// Watches and caches pending incoming requests received from other students.
final receivedRequestsProvider = FutureProvider<List<RequestsSentToUser>>((
  ref,
) async {
  return await _requestRepo.getReceivedRequests();
});

// ─── 3. Dynamic Network Mutation Actions Notifier 
/// Tracks asynchronous states (Idle, Loading, Error, Success) during mutations.
final requestActionNotifierProvider =
    NotifierProvider<RequestActionNotifier, AsyncValue<void>>(
      RequestActionNotifier.new,
    );

class RequestActionNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null); // Default idle state layout
  }

  /// Fires a network request to cancel a pending invitation.
  /// Automatically updates and syncs the UI on completion.
  Future<bool> cancelExistingRequest(String targetUserId) async {
    state = const AsyncLoading();

    try {
      final success = await _requestRepo.cancelRequest(targetUserId);
      if (success) {
        state = const AsyncData(null);

        // 🎯 Optimistic UI Refresh: Invalidate cache so the cell
        // vanishes instantly from the current view.
        ref.invalidate(sentRequestsProvider);
        return true;
      }

      state = AsyncValue.error('Could not cancel request.', StackTrace.current);
      return false;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
