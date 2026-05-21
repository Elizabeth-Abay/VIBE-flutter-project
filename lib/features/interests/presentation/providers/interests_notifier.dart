import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profiles/presentation/providers/profile_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks vibe selections during the interest selection flow.
/// On submit, persists to the profile repository via ProfileNotifier.
final selectedVibesProvider = StateProvider<Map<String, String>>((ref) => {});

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
