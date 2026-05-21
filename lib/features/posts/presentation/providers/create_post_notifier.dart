import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/image_upload_service.dart';
import '../../../home/data/repositories/post_repository.dart';
import '../../../home/presentation/providers/post_notifier.dart';

// ─── Image picking state (separate from post submission) ─────────────────────

/// Holds the locally-picked image file before it gets uploaded.
final pickedImageProvider = StateProvider<File?>((ref) => null);

/// True while the image is being uploaded to the server.
final imageUploadingProvider = StateProvider<bool>((ref) => false);

/// The CDN URL returned after a successful image upload.
final uploadedImageUrlProvider = StateProvider<String?>((ref) => null);

// ─── Selected category (single-select for post) ───────────────────────────────

final createPostCategoryProvider = StateProvider<String>((ref) => '');

// ─── Tags state ───────────────────────────────────────────────────────────────

final createPostTagsProvider = StateProvider<List<String>>((ref) => []);

// ─── Post submission state ────────────────────────────────────────────────────

sealed class CreatePostState { const CreatePostState(); }

class CreatePostInitial extends CreatePostState {
  const CreatePostInitial();
}

class CreatePostLoading extends CreatePostState {
  const CreatePostLoading();
}

class CreatePostSuccess extends CreatePostState {
  const CreatePostSuccess();
}

class CreatePostError extends CreatePostState {
  final String message;
  const CreatePostError(this.message);
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final createPostProvider =
    NotifierProvider<CreatePostNotifier, CreatePostState>(
  CreatePostNotifier.new,
);

// ─── Notifier ─────────────────────────────────────────────────────────────────

class CreatePostNotifier extends Notifier<CreatePostState> {
  final _repo          = PostRepository.instance;
  final _imageService  = ImageUploadService.instance;

  @override
  CreatePostState build() => const CreatePostInitial();

  // ── Pick image from gallery ───────────────────────────────────────────────

  Future<void> pickFromGallery() async {
    final file = await _imageService.pickFromGallery();
    if (file != null) {
      ref.read(pickedImageProvider.notifier).state = file;
      // Auto-upload immediately after picking
      await _uploadPickedImage(file);
    }
  }

  // ── Pick image from camera ────────────────────────────────────────────────

  Future<void> pickFromCamera() async {
    final file = await _imageService.pickFromCamera();
    if (file != null) {
      ref.read(pickedImageProvider.notifier).state = file;
      await _uploadPickedImage(file);
    }
  }

  // ── Internal: upload the picked file ─────────────────────────────────────

  Future<void> _uploadPickedImage(File file) async {
    ref.read(imageUploadingProvider.notifier).state = true;
    try {
      final url = await _imageService.uploadImage(file);
      ref.read(uploadedImageUrlProvider.notifier).state = url;
    } catch (e) {
      // Upload failed — clear the picked file so the user sees no preview
      ref.read(pickedImageProvider.notifier).state = null;
      state = CreatePostError('Image upload failed. Try again.');
    } finally {
      ref.read(imageUploadingProvider.notifier).state = false;
    }
  }

  // ── Remove selected image ─────────────────────────────────────────────────

  void clearImage() {
    ref.read(pickedImageProvider.notifier).state      = null;
    ref.read(uploadedImageUrlProvider.notifier).state = null;
  }

  // ── Submit post ───────────────────────────────────────────────────────────

  Future<void> submitPost({
    required String title,
    required String description,
  }) async {
    // ── Local validation ──────────────────────────────────────────────────
    if (title.trim().isEmpty) {
      state = const CreatePostError('Title cannot be empty.');
      return;
    }
    if (description.trim().isEmpty) {
      state = const CreatePostError('Description cannot be empty.');
      return;
    }
    final category = ref.read(createPostCategoryProvider);
    if (category.isEmpty) {
      state = const CreatePostError('Please select a category.');
      return;
    }

    final tags      = ref.read(createPostTagsProvider);
    final imageUrl  = ref.read(uploadedImageUrlProvider);

    // Block submission while image is still uploading
    if (ref.read(imageUploadingProvider)) {
      state = const CreatePostError(
          'Image is still uploading. Please wait.');
      return;
    }

    state = const CreatePostLoading();

    try {
      await _repo.createPost(
        title:       title.trim(),
        description: description.trim(),
        category:    category,
        tags:        tags,
        imageUrl:    imageUrl,
      );

      // Invalidate home feed so it refreshes with the new post
      ref.invalidate(postsNotifierProvider);

      // Reset all form state
      _resetForm();

      state = const CreatePostSuccess();
    } on Exception catch (e) {
      state = CreatePostError(
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  void _resetForm() {
    ref.read(pickedImageProvider.notifier).state      = null;
    ref.read(uploadedImageUrlProvider.notifier).state = null;
    ref.read(createPostCategoryProvider.notifier).state = '';
    ref.read(createPostTagsProvider.notifier).state  = [];
  }

  void resetState() {
    _resetForm();
    state = const CreatePostInitial();
  }
}
