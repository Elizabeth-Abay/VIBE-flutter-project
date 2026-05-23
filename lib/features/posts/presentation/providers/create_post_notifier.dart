import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/image_upload_service.dart';
import '../../../home/data/repositories/post_repository.dart';
import '../../../home/presentation/providers/post_notifier.dart';

// ─── Riverpod 3: replace all StateProvider with Notifier ─────────────────────

// Picked image file
final pickedImageProvider = NotifierProvider<PickedImageNotifier, File?>(
  PickedImageNotifier.new,
);

class PickedImageNotifier extends Notifier<File?> {
  @override
  File? build() => null;
  void set(File? f) => state = f;
  void clear() => state = null;
}

// Upload in-progress flag
final imageUploadingProvider = NotifierProvider<ImageUploadingNotifier, bool>(
  ImageUploadingNotifier.new,
);

class ImageUploadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool v) => state = v;
}

// CDN URL after upload
final uploadedImageUrlProvider =
    NotifierProvider<UploadedImageUrlNotifier, String?>(
      UploadedImageUrlNotifier.new,
    );

class UploadedImageUrlNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? url) => state = url;
  void clear() => state = null;
}

// Selected category string
final createPostCategoryProvider =
    NotifierProvider<CreatePostCategoryNotifier, String>(
      CreatePostCategoryNotifier.new,
    );

class CreatePostCategoryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String v) => state = v;
  void clear() => state = '';
}

// Tags list
final createPostTagsProvider =
    NotifierProvider<CreatePostTagsNotifier, List<String>>(
      CreatePostTagsNotifier.new,
    );

class CreatePostTagsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];
  void set(List<String> v) => state = v;
  void add(String tag) {
    if (!state.contains(tag) && state.length < 8) {
      state = [...state, tag];
    }
  }

  void remove(String tag) => state = state.where((t) => t != tag).toList();
  void clear() => state = [];
}

// ─── Post submission state ────────────────────────────────────────────────────

sealed class CreatePostState {
  const CreatePostState();
}

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

// ─── Main provider ────────────────────────────────────────────────────────────

final createPostProvider =
    NotifierProvider<CreatePostNotifier, CreatePostState>(
      CreatePostNotifier.new,
    );

class CreatePostNotifier extends Notifier<CreatePostState> {
  final _repo = PostRepository.instance;
  final _imageService = ImageUploadService.instance;

  @override
  CreatePostState build() => const CreatePostInitial();

  // ── Pick from gallery ──────────────────────────────────────────────────────

  Future<void> pickFromGallery() async {
    final file = await _imageService.pickFromGallery();
    if (file != null) {
      ref.read(pickedImageProvider.notifier).set(file);
      await _uploadPickedImage(file);
    }
  }

  // ── Pick from camera ───────────────────────────────────────────────────────

  Future<void> pickFromCamera() async {
    final file = await _imageService.pickFromCamera();
    if (file != null) {
      ref.read(pickedImageProvider.notifier).set(file);
      await _uploadPickedImage(file);
    }
  }

  // ── Upload ─────────────────────────────────────────────────────────────────

  Future<void> _uploadPickedImage(File file) async {
    ref.read(imageUploadingProvider.notifier).set(true);
    try {
      final url = await _imageService.uploadImage(file);
      ref.read(uploadedImageUrlProvider.notifier).set(url);
    } catch (_) {
      ref.read(pickedImageProvider.notifier).clear();
      state = const CreatePostError('Image upload failed. Try again.');
    } finally {
      ref.read(imageUploadingProvider.notifier).set(false);
    }
  }

  // ── Clear image ────────────────────────────────────────────────────────────

  void clearImage() {
    ref.read(pickedImageProvider.notifier).clear();
    ref.read(uploadedImageUrlProvider.notifier).clear();
  }

  // ── Submit post ────────────────────────────────────────────────────────────

  Future<void> submitPost({
    required String title,
    required String description,
  }) async {
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
    if (ref.read(imageUploadingProvider)) {
      state = const CreatePostError('Image still uploading. Please wait.');
      return;
    }

    final tags = ref.read(createPostTagsProvider);
    final imageUrl = ref.read(uploadedImageUrlProvider);

    state = const CreatePostLoading();
    try {
      await _repo.createPost(
        title: title.trim(),
        description: description.trim(),
        category: category,
        tags: tags,
        imageUrl: imageUrl,
      );
      ref.invalidate(postsNotifierProvider);
      _resetForm();
      state = const CreatePostSuccess();
    } on Exception catch (e) {
      state = CreatePostError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ── Reset ──────────────────────────────────────────────────────────────────

  void _resetForm() {
    ref.read(pickedImageProvider.notifier).clear();
    ref.read(uploadedImageUrlProvider.notifier).clear();
    ref.read(createPostCategoryProvider.notifier).clear();
    ref.read(createPostTagsProvider.notifier).clear();
  }

  void resetState() {
    _resetForm();
    state = const CreatePostInitial();
  }
}
