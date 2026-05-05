import 'package:flutter/material.dart';
import '../widgets/post_btn.dart';
import '../widgets/category_bar.dart';
import '../widgets/post_caption.dart';
import '../widgets/post_content.dart';
import '../widgets/post_title.dart';
import '../../../../core/constants/post_categories.dart';


class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Matching your app theme
      body: SafeArea(
        child: Column(
          children: [
            // 1. Caption Header (Cancel, User Info, Post Button)
            PostCaptionHeader(
              userName: "Elizabeth",
              onCancel: () => Navigator.pop(context),
              onPost: () {
                // Trigger BLoC event here
              },
            ),

            const Divider(color: Colors.white10, height: 1),


            PostTitleField(
              controller:  _titleController
              ),

            // 2. Category Bar (Scrollable Pills)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CategoryBar(
                categories: postAppCategories, // From your constants
                onSelectionChanged: (selected) {
                  // Handle category selection
                },
              ),
            ),

            // 3. Text Input (Expanded to fill space)
            Expanded(
              child: PostTextField(
                controller: _captionController,
                hintText: "What's on your mind?",
              ),
            ),

            // 4. Large Gradient Post Button at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: VibePostButton(
                onTap: () {
                   // Logic for the large button
                },
              ),
            ),
          ],
        ),
      ),

      // 5. Floating Plus Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Additional action like adding an image
        },
        backgroundColor: const Color(0xFF7B72EF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}