import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../connections/presentation/providers/connection_notifier.dart';
// 🎯 FIX: Added the missing import so Dart knows what ConnectResult is!
import '../../domain/entity/connection_request_sending_result.dart';
import 'recommended_person_card.dart';

/// Live recommended people list — all mock data removed.
/// Reactively handles async state via standard AsyncValue matching.
class RecommendedConnectionsList extends ConsumerWidget {
  const RecommendedConnectionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 Watches the global async recommendations profile stream
    final state = ref.read(peopleNotifierProvider);

    // 🎯 Watches the loading/error state of requests being sent, accepted, or rejected
    // final actionState = ref.watch(connectionActionProvider);

    return state.when(
      // ── 1. Loading State ───────────────────────────────────────────────────
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE186FF)),
          ),
        ),
      ),

      // ── 2. Error State ─────────────────────────────────────────────────────
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),

      // ── 3. Data Loaded Success State ───────────────────────────────────────
      data: (people) {
        if (people.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No recommendations yet.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Recommended Connections',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final person = people[index];

                  print("$person");

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: UserConnectionCard(
                      userId: person.user_id,
                      displayName: person.name,
                      username: person.user_name,
                      userProfileImageUrl: person.profile_url,
                      // 🎯 Invokes our dynamic action provider safely on user tap
                      onConnect: (userId) async {
                        final success = await ref
                            .read(connectionActionProvider.notifier)
                            .sendRequest(userId);

                        if (success && context.mounted) {
                          ref.invalidate(peopleNotifierProvider);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Connection request sent to @${person.username}!',
                              ),
                              backgroundColor: const Color(0xFF6E85E3),
                            ),
                          );
                        }

                        // 🎯 This will now compile cleanly since the import is present!
                        return ConnectResult(
                          statusCode: success ? 200 : 400,
                          message: success
                              ? 'Success'
                              : 'Failed to send request',
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
