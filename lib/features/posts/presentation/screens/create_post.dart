import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/create_post_notifier.dart';
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
    ref.read(createPostProvider.notifier).resetState();
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
    //  s is AuthStateAuthenticated ?  find a way to put thus
    return 'You';
  }

  String? get _userAvatar {
    final s = ref.read(authNotifierProvider);
    // s is AuthStateAuthenticated ? s.user.avatarUrl : 
    return  null;
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _onPost() async {
    await ref
        .read(createPostProvider.notifier)
        .submitPost(
          title: _titleController.text,
          description: _descriptionController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    // ── React to state changes ───────────────────────────────────────────────
    ref.listen<CreatePostState>(createPostProvider, (_, next) {
      if (next is CreatePostSuccess) {
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
        context.pop();
      } else if (next is CreatePostError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    final postState = ref.watch(createPostProvider);
    final isLoading = postState is CreatePostLoading;
    final selectedCat = ref.watch(createPostCategoryProvider);
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
                          // Use the first selected category (single-select)
                          ref.read(createPostCategoryProvider.notifier).state =
                              selected.isNotEmpty ? selected.first.name : '';
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
                  _ImageAddButton(isUploading: isUploading),

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

// ─── Image add button with upload spinner ─────────────────────────────────────

class _ImageAddButton extends ConsumerWidget {
  final bool isUploading;

  const _ImageAddButton({required this.isUploading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPicked = ref.watch(pickedImageProvider) != null;

    return GestureDetector(
      onTap: isUploading ? null : () => ImagePickerSheet.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasPicked
              ? const Color(0xFF2A1F5E)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasPicked ? const Color(0xFF7B72EF) : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE186FF),
                      ),
                    ),
                  )
                : Icon(
                    hasPicked
                        ? Icons.check_circle_outline
                        : Icons.add_photo_alternate_outlined,
                    color: hasPicked ? const Color(0xFF7B72EF) : Colors.white54,
                    size: 20,
                  ),
            const SizedBox(width: 8),
            Text(
              isUploading
                  ? 'Uploading...'
                  : hasPicked
                  ? 'Change Photo'
                  : 'Add Photo',
              style: TextStyle(
                color: hasPicked ? const Color(0xFF7B72EF) : Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
