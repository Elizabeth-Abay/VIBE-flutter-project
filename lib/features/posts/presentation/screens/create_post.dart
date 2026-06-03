import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/post_provider.dart'; 
import '../providers/image_provider.dart';
import '../widgets/image_picker_sheet.dart';
import '../widgets/image_preview.dart';
import '../widgets/tag_input.dart';
import '../widgets/post_btn.dart';
import '../widgets/category_bar.dart';
import '../widgets/post_caption.dart';
import '../widgets/post_content.dart';
import '../widgets/post_title.dart';
import '../../../../core/constants/post_categories.dart';
import '../../../../features/auth/presentation/providers/auth_notifier.dart';
import '../../../../features/auth/domain/entities/auth_state.dart';
import '../widgets/image_add_btn.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void deactivate() {
    // 🎯 Drops old inputs out of memory stream on exit to avoid leakage
    ref.invalidate(createPostNotifierProvider);
    super.deactivate();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String get _userName {
    final s = ref.read(authNotifierProvider);
    // 🎯 Safely unwraps user profile details from active Auth session state
    // if (s is AuthStateAuthenticated) {
    //   return s.user.name;
    // }
    return 'You';
  }

  String? get _userAvatar {
    final s = ref.read(authNotifierProvider);
    // 🎯 Wireframe safely passes down network avatar url pointers
    // if (s is AuthStateAuthenticated) {
    //   return s.user.avatarUrl;
    // }
    return null;
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _onPost() async {
    final selectedCat = ref.read(selectedCategoryProvider);
    print("selected category $selectedCat");
    final selectedFile = ref.read(pickedImageProvider);

    // 🎯 Passes all dynamic data fields cleanly to your unified multipart request handler
    await ref
        .read(createPostNotifierProvider.notifier)
        .handleMakePost(
          title: _titleController.text.trim(),
          content: _descriptionController.text.trim(),
          category: selectedCat.isEmpty ? 'General' : selectedCat,
          imageFile: selectedFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    // ── React to state changes ───────────────────────────────────────────────
    ref.listen<AsyncValue<bool>>(createPostNotifierProvider, (_, next) {
      next.whenOrNull(
        data: (success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Post published!'),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
            // Resets chosen image container back to clear state before pop out
            ref.read(pickedImageProvider.notifier).clearImage();
            context.pop();
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.toString()),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
      );
    });

    final postState = ref.watch(createPostNotifierProvider);
    final isLoading = postState.isLoading;
    final selectedCat = ref.watch(selectedCategoryProvider);
    final isUploading = ref.watch(imageUploadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: Cancel | Username | Post ──────────────────────────
            PostCaptionHeader(
              userName: _userName,
              profileImageUrl: _userAvatar,
              onCancel: () => context.pop(),
              onPost: (isLoading || isUploading) ? () {} : _onPost,
            ),

            const Divider(color: Colors.white10, height: 1),

            // ── Scrollable body ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    PostTitleField(controller: _titleController),

                    // Category pills (single-select)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CategoryBar(
                        categories: postAppCategories,
                        onSelectionChanged: (selected) {
                          final label = selected.isNotEmpty
                              ? selected.first.name
                              : '';
                          ref
                              .read(selectedCategoryProvider.notifier)
                              .updateCategory(label);
                        },
                      ),
                    ),

                    // Selected category badge
                    if (selectedCat.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.label_outline,
                              color: Colors.white38,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selectedCat,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Image preview (shows after pick)
                    const ImagePreviewWidget(),

                    // Description / body
                    SizedBox(
                      height: 160,
                      child: PostTextField(
                        controller: _descriptionController,
                        hintText: "What's on your mind?",
                      ),
                    ),

                    // Tag input
                    const TagInputField(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom action bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image button (left)
                  ImageAddButton(isUploading: isUploading),

                  // Post button (right)
                  isLoading
                      ? const SizedBox(
                          width: 120,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : VibePostButton(onTap: _onPost),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
