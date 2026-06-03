import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/interest_repo.dart';

// ─── 1. Keeps track of what the user is clicking on screen ─────────────────
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

// ─── 2. Controls the rolling circle loading indicator on Submit ──────────────
final interestsSavingProvider = NotifierProvider<InterestsSavingNotifier, bool>(
  InterestsSavingNotifier.new,
);

class InterestsSavingNotifier extends Notifier<bool> {
  final _repo = InterestsRepository.instance;

  @override
  bool build() => false; // Starts false (not loading)

  Future<bool> save(Map<String, String> userSelections) async {
    // Prevent double clicking while spinning
    if (state) return false;

    state = true; // ⏳ Starts the rotating circle button layout!

    // Map labels to backend numeric strings
    final Map<String, int> scoreMapping = {
      'Love': 10,
      'Like': 8,
      'Neutral': 5,
      'Bothered': 1,
      'Hate': 0,
    };

    // Format into what your backend expects: [{"interest": "Music", "score": "10"}, ...]
    final List<Map<String, int>> formattedList = userSelections.entries.map((
      entry,
    ) {
      return {entry.key: scoreMapping[entry.value] ?? 0};
    }).toList();

    try {
      // Send payload down to data layer
      final bool savedInterest = await _repo.saveInterests(formattedList);

      print("Result from the backend $savedInterest") ;
      state = false;
      return savedInterest;
    } catch (e) {
      state = false;
      return false;
    }
  }
}
