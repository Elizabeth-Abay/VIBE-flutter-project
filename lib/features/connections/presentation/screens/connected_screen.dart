import 'package:flutter/material.dart';
import '../../domain/entity/connected_user.dart';
import '../widgets/holder_cell.dart';


class ConnectionsListContainer extends StatelessWidget {
  final List<ConnectedUser> connections;

  const ConnectionsListContainer({super.key, required this.connections});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Prevents the list from trying to take up infinite height
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: connections.length,
      itemBuilder: (context, index) {
        final user = connections[index];

        // Return the cell and pass the specific user object
        return ConnectionHolderCell(user: user);
      },
    );
  }
}
