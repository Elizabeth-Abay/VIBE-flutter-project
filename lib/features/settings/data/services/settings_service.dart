import '../repositories/settings_repository.dart';

/// Thin facade over [SettingsRepository] for presentation layer.
class SettingsService {
  SettingsService._internal();
  static final SettingsService instance = SettingsService._internal();

  final _repo = SettingsRepository.instance;

  Future<Map<String, bool>> getSettings() => _repo.getSettings();

  Future<void> setPushNotifications(bool enabled) =>
      _repo.updateSetting(SettingsRepository.keyPushNotifications, enabled);

  Future<void> setDarkMode(bool enabled) =>
      _repo.updateSetting(SettingsRepository.keyDarkMode, enabled);

  Future<void> setProfilePrivate(bool enabled) =>
      _repo.updateSetting(SettingsRepository.keyProfilePrivate, enabled);
}
