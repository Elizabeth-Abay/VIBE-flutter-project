import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/settings_service.dart';

sealed class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final bool pushNotifications;
  final bool darkMode;
  final bool profilePrivate;

  const SettingsLoaded({
    required this.pushNotifications,
    required this.darkMode,
    required this.profilePrivate,
  });

  SettingsLoaded copyWith({
    bool? pushNotifications,
    bool? darkMode,
    bool? profilePrivate,
  }) {
    return SettingsLoaded(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      darkMode: darkMode ?? this.darkMode,
      profilePrivate: profilePrivate ?? this.profilePrivate,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
}

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<SettingsState> {
  final _service = SettingsService.instance;

  @override
  SettingsState build() {
    loadSettings();
    return const SettingsLoading();
  }

  Future<void> loadSettings() async {
    state = const SettingsLoading();
    try {
      final map = await _service.getSettings();
      state = SettingsLoaded(
        pushNotifications: map['push_notifications'] ?? true,
        darkMode: map['dark_mode'] ?? true,
        profilePrivate: map['profile_private'] ?? false,
      );
    } catch (e) {
      state = SettingsError(e.toString());
    }
  }

  Future<void> togglePush(bool value) async {
    await _service.setPushNotifications(value);
    final current = state;
    if (current is SettingsLoaded) {
      state = current.copyWith(pushNotifications: value);
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    await _service.setDarkMode(value);
    final current = state;
    if (current is SettingsLoaded) {
      state = current.copyWith(darkMode: value);
    }
  }

  Future<void> toggleProfilePrivate(bool value) async {
    await _service.setProfilePrivate(value);
    final current = state;
    if (current is SettingsLoaded) {
      state = current.copyWith(profilePrivate: value);
    }
  }
}
