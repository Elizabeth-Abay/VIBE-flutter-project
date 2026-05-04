import '../../domain/entity/post_fetch_obj.dart';
import 'package:flutter/material.dart';
import '../widgets/post_card.dart';


final List<PostFetchObj> mockPosts = [
  PostFetchObj(
    title: 'Enjoying an outdoor concert',
    imageUrl: 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4',
    description: 'The energy at this concert is amazing!',
    tags: ['Music', 'Concert'],
    userName: 'Emily Davis',
  ),
  PostFetchObj(
    title: 'At a tech meet-up',
    imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87',
    description: 'Great insights during the meeting!',
    tags: ['Tech', 'Networking'],
    userName: 'James Brown',
  ),
  PostFetchObj(
    title: 'Morning Hike',
    imageUrl: 'https://images.unsplash.com/photo-1551632432-c7360b7f0187',
    description: 'Breathtaking views from the top.',
    tags: ['Nature', 'Hike'],
    userName: 'Sarah Lee',
  ),
];

class HorizontalPostFeed extends StatelessWidget {
  const HorizontalPostFeed({super.key});

  Widget build(BuildContext context) {
    return SizedBox(
      // Reduced height from 480 to 380 for a more compact look
      height: 380, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: mockPosts.length,
        itemBuilder: (context, index) {
          final post = mockPosts[index];
          
          return Container(
            // Reduced width from 320 to 260 so the next card is partially visible
            width: 260, 
            margin: const EdgeInsets.only(right: 12),
            child: SocialPostWidget(
              title: post.title,
              imageUrl: post.imageUrl ?? 'https://via.placeholder.com/200',
              description: post.description,
              tags: post.tags ?? [],
              userName: post.userName,
              userProfileImageUrl: post.userProfileImageUrl,
            ),
          );
        },
      ),
    );
  }
}
