// home/presentation/providers/post_notifier.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/post_repository.dart';
import '../../domain/entity/post_entity.dart';


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

/// Automatically tracks, requests, caches, and updates the UI matching selectedCategoryProvider
final postsFeedProvider = FutureProvider<List<PostEntity>>((ref) async {
  // Watches our modern category notifier provider cleanly
  final category = ref.watch(selectedCategoryProvider);
  return PostRepository.instance.getPostsInACategory(category);
});


/// Tracks standard async compilation state transitions when writing mutations to the database
final createPostNotifierProvider =
    NotifierProvider<CreatePostNotifier, AsyncValue<bool>>(
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
      final success = await PostRepository.instance.createPost(
        title: title,
        content: content,
        category: category,
        imageFile: imageFile,
      );

      if (success) {
        state = const AsyncData(true);

        // Invalidates the list view feed if the updated content matches the active filter pill
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
