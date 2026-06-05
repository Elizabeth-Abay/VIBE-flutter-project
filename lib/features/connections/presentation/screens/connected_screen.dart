import 'package:flutter/material.dart';
import '../../domain/entity/connected_user.dart';
import '../widgets/holder_cell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_notifier.dart';

class ConnectionsListContainer extends ConsumerWidget {
  const ConnectionsListContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectionsFeedProvider);

    return state.when(
      data: (people) {
        if (people.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No connections yet.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ),
          );
        }

        return ListView.builder(
          // Prevents the list from trying to take up infinite height
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: people.length,
          itemBuilder: (context, index) {
            final user = people[index];

            // Return the cell and pass the specific user object
            return ConnectionHolderCell(user: user);
          },
        );
      },
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
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE186FF)),
          ),
        ),
      ),
    );
  }
}
