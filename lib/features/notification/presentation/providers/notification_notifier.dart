import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/notification_repository.dart';
import '../../domain/entity/notification_entity.dart';
import '../../../connections/presentation/providers/connection_notifier.dart';

// ─── Notifications state (Updates tab) ───────────────────────────────────────

sealed class NotificationsState {
  const NotificationsState();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> items;
  final int unreadCount;
  const NotificationsLoaded(this.items) : unreadCount = 0; // computed below
  const NotificationsLoaded.withCount(this.items, this.unreadCount);
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
}

// ─── Notifications provider ───────────────────────────────────────────────────

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, NotificationsState>(
      NotificationsNotifier.new,
    );

class NotificationsNotifier extends Notifier<NotificationsState> {
  final _repo = NotificationRepository.instance;

  @override
  NotificationsState build() {
    fetch();
    return const NotificationsLoading();
  }

  // ── Fetch ────────────────────────────────────────────────────────────────

  Future<void> fetch() async {
    state = const NotificationsLoading();
    try {
      final items = await _repo.fetchNotifications();
      final unread = items.where((n) => !n.isRead).length;
      state = NotificationsLoaded.withCount(items, unread);
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }

  // ── Mark single read (optimistic) ────────────────────────────────────────

  Future<void> markRead(String id) async {
    // Optimistic update first — UI reacts instantly
    final current = state;
    if (current is NotificationsLoaded) {
      final updated = current.items
          .map((n) => n.id == id ? n.markAsRead() : n)
          .toList();
      final unread = updated.where((n) => !n.isRead).length;
      state = NotificationsLoaded.withCount(updated, unread);
    }
    // Then persist to SQLite + network
    await _repo.markRead(id);
  }

  // ── Mark all read ────────────────────────────────────────────────────────

  Future<void> markAllRead() async {
    final current = state;
    if (current is NotificationsLoaded) {
      final updated = current.items.map((n) => n.markAsRead()).toList();
      state = NotificationsLoaded.withCount(updated, 0);
    }
    await _repo.markAllRead();
  }

  // ── Unread count helper ───────────────────────────────────────────────────

  int get unreadCount {
    final s = state;
    if (s is NotificationsLoaded) return s.unreadCount;
    return 0;
  }
}

// ─── Incoming requests state (Requests tab) ───────────────────────────────────

sealed class RequestsState {
  const RequestsState();
}

class RequestsLoading extends RequestsState {
  const RequestsLoading();
}

class RequestsLoaded extends RequestsState {
  final List<ConnectionRequestEntity> requests;
  const RequestsLoaded(this.requests);
}

class RequestsError extends RequestsState {
  final String message;
  const RequestsError(this.message);
}

// ─── Incoming requests provider ───────────────────────────────────────────────

final incomingRequestsProvider =
    NotifierProvider<IncomingRequestsNotifier, RequestsState>(
      IncomingRequestsNotifier.new,
    );

class IncomingRequestsNotifier extends Notifier<RequestsState> {
  final _repo = NotificationRepository.instance;

  @override
  RequestsState build() {
    fetch();
    return const RequestsLoading();
  }

  // ── Fetch ────────────────────────────────────────────────────────────────

  Future<void> fetch() async {
    state = const RequestsLoading();
    try {
      final requests = await _repo.fetchIncomingRequests();
      //print("requests being printed");
      //print(requests);
      state = RequestsLoaded(requests);
    } catch (e) {
      state = RequestsError(e.toString());
    }
  }

  // ── Accept (removes card optimistically) ─────────────────────────────────

  Future<bool> acceptRequest(String requesterId) async {
    final ok = await _repo.acceptRequest(requesterId);
    if (ok) {
      _removeFromList(requesterId);
      ref.invalidate(connectionsFeedProvider);
    }
    return ok;
  }

  // ── Decline (removes card optimistically) ────────────────────────────────

  Future<bool> declineRequest(String requesterId) async {
    final ok = await _repo.declineRequest(requesterId);
    if (ok) _removeFromList(requesterId);
    return ok;
  }

  void _removeFromList(String requesterId) {
    final current = state;
    if (current is RequestsLoaded) {
      state = RequestsLoaded(
        current.requests.where((r) => r.requesterId != requesterId).toList(),
      );
    }
  }

  // ── Helper ───────────────────────────────────────────────────────────────

  int get pendingCount {
    final s = state;
    return s is RequestsLoaded ? s.requests.length : 0;
  }
}

// ─── Convenience provider: total badge count (notifications + requests) ───────

final notificationBadgeCountProvider = Provider<int>((ref) {
  final unread = ref.watch(notificationsProvider);
  final pending = ref.watch(incomingRequestsProvider);

  final unreadCount = unread is NotificationsLoaded ? unread.unreadCount : 0;
  final pendingCount = pending is RequestsLoaded ? pending.requests.length : 0;

  return unreadCount + pendingCount;
});
