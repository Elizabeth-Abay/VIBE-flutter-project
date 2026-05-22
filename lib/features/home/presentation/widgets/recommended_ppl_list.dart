import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_notifier.dart';
import '../../../connections/presentation/providers/connection_notifier.dart';
import '../../domain/entity/connection_request_sending_result.dart';
import 'recommended_person_card.dart';

/// Live recommended people list — all mock data removed.
/// Reads from PeopleNotifier which uses SQLite cache-first.
class RecommendedConnectionsList extends ConsumerWidget {
  const RecommendedConnectionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(peopleNotifierProvider);

    return switch (state) {
      PeopleLoading() => const Center(child: CircularProgressIndicator()),
      PeopleError(:final message) => Center(
          child: Text(message,
              style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ),
      PeopleLoaded(:final people) when people.isEmpty => const Center(
          child: Text('No recommendations yet.',
              style: TextStyle(color: Colors.white38)),
        ),
      PeopleLoaded(:final people) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Recommended Connections',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final person = people[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: UserConnectionCard(
                      userId: person.userId,
                      displayName: person.displayName,
                      username: person.username,
                      userProfileImageUrl: person.userProfileImageUrl,
                      onConnect: (userId) async {
                        final result = await ref
                            .read(sendConnectionProvider.notifier)
                            .sendRequest(userId);
                        return ConnectResult(
                          statusCode: result.statusCode,
                          message: result.message,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
