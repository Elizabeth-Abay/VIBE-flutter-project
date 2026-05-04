import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/person.dart';




// this is the connect requirerer
// the connect btn is stateful
class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback? onConnect;
  // this will be filled by the parent widget 
  // this is a stateless dumb widget

  const PersonCard({
    Key? key,
    required this.person,
    this.onConnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Profile image
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              backgroundImage: person.profileImageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(person.profileImageUrl)
                  : null,
              child: person.profileImageUrl.isEmpty
                  ? Icon(Icons.person, color: Colors.grey[600])
                  : null,
            ),
            const SizedBox(width: 12),
            // Person info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '@${person.username}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  if (person.bio.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      person.bio,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Connect button
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: person.isFollowing ? Colors.grey[300] : Colors.blue,
                foregroundColor: person.isFollowing ? Colors.black87 : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                person.isFollowing ? 'Following' : 'Connect',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
