import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/settings_notifier.dart';
import '../widgets/settings_item.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: switch (state) {
        SettingsLoading() => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        SettingsError(:final message) => Center(
            child: Text(message, style: const TextStyle(color: Colors.white70)),
          ),
        SettingsLoaded(
          :final pushNotifications,
          :final darkMode,
          :final profilePrivate,
        ) =>
          ListView(
            children: [
              SettingsItem(
                title: 'Push notifications',
                trailing: Switch(
                  value: pushNotifications,
                  onChanged: (v) =>
                      ref.read(settingsNotifierProvider.notifier).togglePush(v),
                ),
              ),
              SettingsItem(
                title: 'Dark mode',
                trailing: Switch(
                  value: darkMode,
                  onChanged: (v) => ref
                      .read(settingsNotifierProvider.notifier)
                      .toggleDarkMode(v),
                ),
              ),
              SettingsItem(
                title: 'Private profile',
                trailing: Switch(
                  value: profilePrivate,
                  onChanged: (v) => ref
                      .read(settingsNotifierProvider.notifier)
                      .toggleProfilePrivate(v),
                ),
              ),
              SettingsItem(
                title: 'Blocked users',
                onTap: () => context.push('/blocked'),
              ),
            ],
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
