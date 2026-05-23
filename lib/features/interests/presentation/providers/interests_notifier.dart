import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profiles/presentation/providers/profile_notifier.dart';

// ─── Riverpod 3: StateProvider removed — use Notifier ────────────────────────

final selectedVibesProvider =
    NotifierProvider<SelectedVibesNotifier, Map<String, String>>(
      SelectedVibesNotifier.new,
    );

class SelectedVibesNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => {};

  void setVibe(String interest, String label) {
    state = {...state, interest: label};
  }

  void clear() => state = {};
}

// ─── Saving state ─────────────────────────────────────────────────────────────

final interestsSavingProvider = NotifierProvider<InterestsSavingNotifier, bool>(
  InterestsSavingNotifier.new,
);

class InterestsSavingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<bool> save(Map<String, String> vibes) async {
    state = true;
    try {
      await ref.read(profileNotifierProvider.notifier).saveInterests(vibes);
      state = false;
      return true;
    } catch (_) {
      state = false;
      return false;
    }
  }
}
