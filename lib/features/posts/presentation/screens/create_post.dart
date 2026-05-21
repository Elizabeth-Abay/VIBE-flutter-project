import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/post_categories.dart';
import '../providers/create_post_notifier.dart';
import '../widgets/post_btn.dart';
import '../widgets/post_caption.dart';
import '../widgets/post_content.dart';
import '../widgets/post_title.dart';
import '../widgets/category_bar.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../auth/domain/entities/auth_state.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _titleController = TextEditingController();
  final _captionController = TextEditingController();

  // Tracks which categories the user selected in the bar
  final List<String> _selectedTags = [];
  String _selectedCategory = '';

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    ref.read(createPostProvider.notifier).reset();
    super.dispose();
  }

  Future<void> _onPost() async {
    await ref.read(createPostProvider.notifier).submit(
          title: _titleController.text,
          description: _captionController.text,
          category: _selectedCategory,
          tags: _selectedTags,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Navigate back and refresh feed on success
    ref.listen<CreatePostState>(createPostProvider, (_, next) {
      if (next is CreatePostSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post published!'),
            backgroundColor: Color(0xFF7C3AED),
          ),
        );
        context.go('/home');
      } else if (next is CreatePostError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final postState = ref.watch(createPostProvider);
    final isLoading = postState is CreatePostLoading;

    // Get current user name for the header
    final authState = ref.watch(authNotifierProvider);
    final userName =
        authState is AuthStateAuthenticated ? authState.user.username : 'You';

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // Header: Cancel | UserName | Post button
            PostCaptionHeader(
              userName: userName,
              onCancel: () => context.pop(),
              onPost: isLoading ? () {} : _onPost,
            ),

            const Divider(color: Colors.white10, height: 1),

            // Title field
            PostTitleField(controller: _titleController),

            // Category picker
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CategoryBar(
                categories: postAppCategories,
                onSelectionChanged: (selected) {
                  setState(() {
                    _selectedTags
                      ..clear()
                      ..addAll(selected.map((c) => c.name));
                    _selectedCategory =
                        selected.isNotEmpty ? selected.first.name : '';
                  });
                },
              ),
            ),

            // Description field
            Expanded(
              child: PostTextField(
                controller: _captionController,
                hintText: "What's on your mind?",
              ),
            ),

            // Large post button or loading spinner
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : VibePostButton(onTap: _onPost),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Image picker — Step 7 extension
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image upload coming in next step!')),
          );
        },
        backgroundColor: const Color(0xFF7B72EF),
        child:
            const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
      ),
    );
  }
}
