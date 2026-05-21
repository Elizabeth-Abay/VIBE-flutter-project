import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/data/repositories/post_repository.dart';
import '../../../home/domain/entity/post_entity.dart';

// ─── State ────────────────────────────────────────────────────────────────────

sealed class CreatePostState { const CreatePostState(); }
class CreatePostIdle    extends CreatePostState { const CreatePostIdle(); }
class CreatePostLoading extends CreatePostState { const CreatePostLoading(); }
class CreatePostSuccess extends CreatePostState {
  final PostEntity post;
  const CreatePostSuccess(this.post);
}
class CreatePostError   extends CreatePostState {
  final String message;
  const CreatePostError(this.message);
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final createPostProvider =
    NotifierProvider<CreatePostNotifier, CreatePostState>(
        CreatePostNotifier.new);

// ─── Notifier ─────────────────────────────────────────────────────────────────

class CreatePostNotifier extends Notifier<CreatePostState> {
  final _repo = PostRepository.instance;

  @override
  CreatePostState build() => const CreatePostIdle();

  Future<void> submit({
    required String title,
    required String description,
    required String category,
    required List<String> tags,
    String? imageUrl,
  }) async {
    if (title.trim().isEmpty) {
      state = const CreatePostError('Please enter a title.');
      return;
    }
    if (description.trim().isEmpty) {
      state = const CreatePostError('Please enter a description.');
      return;
    }
    if (category.isEmpty) {
      state = const CreatePostError('Please select a category.');
      return;
    }

    state = const CreatePostLoading();
    try {
      final post = await _repo.createPost(
        title: title.trim(),
        description: description.trim(),
        category: category,
        tags: tags,
        imageUrl: imageUrl,
      );
      state = CreatePostSuccess(post);
    } catch (e) {
      state = CreatePostError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void reset() => state = const CreatePostIdle();
}
