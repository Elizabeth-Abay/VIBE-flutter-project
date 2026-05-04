import 'package:flutter/material.dart';
import '../../domain/entity/recommended_people_fetch_obj.dart';
import '../widgets/recommended_person_card.dart';
import '../../domain/entity/connection_request_sending_result.dart';

// Dummy data list based on your PeopleRecommended entity
final List<PeopleRecommended> mockRecommendedPeople = [
  PeopleRecommended(
    userId: '1',
    displayName: 'Lisa Carter',
    username: 'Lisa123',
    userProfileImageUrl: 'https://i.pravatar.cc/150?u=lisa',
  ),
  PeopleRecommended(userId: '2', displayName: 'Helen', username: 'Helen_Tech'),
  PeopleRecommended(
    userId: '3',
    displayName: 'Abebe Kebede',
    username: 'abe123',
  ),
  PeopleRecommended(userId: '4', displayName: 'Tom Adams', username: 'Tomm'),
  PeopleRecommended(
    userId: '5',
    displayName: 'Netsanet Belay',
    username: 'Netsi',
    userProfileImageUrl: 'https://i.pravatar.cc/150?u=netsi',
  ),
];

class RecommendedConnectionsList extends StatelessWidget {
  const RecommendedConnectionsList({super.key});

  /// This function now correctly returns a ConnectResult object
  /// using the constructor we just defined.
  Future<ConnectResult> _dummyOnConnect(String userId) async {
    // Simulating the delay of your Node.js/Express backend
    await Future.delayed(const Duration(seconds: 1));

    // Returning a successful status code (200) and a message
    return ConnectResult(statusCode: 200, message: "Request Sent");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
            // BouncingScrollPhysics gives a better feel on mobile
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: mockRecommendedPeople.length,
            itemBuilder: (context, index) {
              final person = mockRecommendedPeople[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: UserConnectionCard(
                  userId: person.userId,
                  displayName: person.displayName,
                  username: person.username,
                  userProfileImageUrl: person.userProfileImageUrl,
                  onConnect: _dummyOnConnect,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
