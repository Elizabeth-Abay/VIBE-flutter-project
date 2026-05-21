import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/notification_repository.dart';
import '../../domain/entity/notification_entity.dart';

// ─── Notifications (Updates tab) ──────────────────────────────────────────────

sealed class NotificationsState {
  const NotificationsState();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> items;
  const NotificationsLoaded(this.items);
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, NotificationsState>(
        NotificationsNotifier.new);

class NotificationsNotifier extends Notifier<NotificationsState> {
  final _repo = NotificationRepository.instance;

  @override
  NotificationsState build() {
    fetch();
    return const NotificationsLoading();
  }

  Future<void> fetch() async {
    state = const NotificationsLoading();
    try {
      final items = await _repo.fetchNotifications();
      state = NotificationsLoaded(items);
    } catch (e) {
      state = NotificationsError(e.toString());
    }
  }

  Future<void> markRead(String id) async {
    await _repo.markRead(id);
    final current = state;
    if (current is NotificationsLoaded) {
      state = NotificationsLoaded(
        current.items
            .map((n) => n.id == id
                ? NotificationEntity(
                    id: n.id,
                    type: n.type,
                    message: n.message,
                    isRead: true,
                    createdAt: n.createdAt,
                  )
                : n)
            .toList(),
      );
    }
  }
}

// ─── Incoming connection requests (Requests tab) ──────────────────────────────

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

final incomingRequestsProvider =
    NotifierProvider<IncomingRequestsNotifier, RequestsState>(
        IncomingRequestsNotifier.new);

class IncomingRequestsNotifier extends Notifier<RequestsState> {
  final _repo = NotificationRepository.instance;

  @override
  RequestsState build() {
    fetch();
    return const RequestsLoading();
  }

  Future<void> fetch() async {
    state = const RequestsLoading();
    try {
      final requests = await _repo.fetchIncomingRequests();
      state = RequestsLoaded(requests);
    } catch (e) {
      state = RequestsError(e.toString());
    }
  }
}
