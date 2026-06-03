import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/post_repository.dart';
import '../../domain/entity/post_entity.dart';

final _repository = PostRepository.instance;

// ─── 1. Holds Selected Category State ────────────────────────────────────────
/// Tracks the active selection pill state layout value (defaults to 'books')
final selectedCategoryProvider = NotifierProvider<CategoryNotifier, String>(
  CategoryNotifier.new,
);

class CategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'books'; // Your clean default fallback category selection
  }

  void updateCategory(String newCategory) {
    state = newCategory;
  }
}

// ─── 2. Automagically Watches Category & Fetches Feed ────────────────────────
/// Automatically tracks, requests, caches, and updates the UI matching selectedCategoryProvider.
/// To trigger a refresh here, you just call ref.invalidate(postsFeedProvider).
final postsFeedProvider = FutureProvider<List<PostEntity>>((ref) async {
  // 🚀 MAGIC: Because this WATCHES selectedCategoryProvider, the moment the 
  // user taps a new category pill, this feed auto-fetches the new network data!
  final category = ref.watch(selectedCategoryProvider);
  return _repository.getPostsInACategory(category);
});

// ─── 3. Handles Creating a Single New Post Mutation ──────────────────────────
/// Tracks standard async compilation state transitions when writing mutations to the database
final createPostNotifierProvider = NotifierProvider<CreatePostNotifier, AsyncValue<bool>>(
  CreatePostNotifier.new,
);

class CreatePostNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() {
    return const AsyncData(false); // Initial idle state
  }

  Future<bool> handleMakePost({
    required String title,
    required String content,
    required String category,
    File? imageFile,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();

    try {
      final success = await _repository.createPost(
        title: title,
        content: content,
        category: category,
        imageFile: imageFile,
      );

      if (success) {
        state = const AsyncData(true);

        // 🎯 If the new post matches what the user is looking at right now, 
        // clear the old list cache and reload the feed seamlessly.
        final currentFilter = ref.read(selectedCategoryProvider).toLowerCase();
        if (currentFilter == category.toLowerCase()) {
          ref.invalidate(postsFeedProvider);
        }
        return true;
      } else {
        state = AsyncValue.error(
          'Could not post item, check inputs',
          StackTrace.current,
        );
        return false;
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}