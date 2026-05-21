import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/post_repository.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/entity/recommended_people_fetch_obj.dart';

// ─── Posts state ─────────────────────────────────────────────────────────────

sealed class PostsState {
  const PostsState();
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;
  const PostsLoaded(this.posts);
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);
}

// ─── Posts provider ───────────────────────────────────────────────────────────

final postsNotifierProvider =
    NotifierProvider<PostsNotifier, PostsState>(PostsNotifier.new);

class PostsNotifier extends Notifier<PostsState> {
  final _repo = PostRepository.instance;

  @override
  PostsState build() {
    // Auto-load posts when the provider is first read.
    fetchPosts();
    return const PostsLoading();
  }

  Future<void> fetchPosts({String? category}) async {
    state = const PostsLoading();
    try {
      final posts = await _repo.fetchPosts(category: category);
      state = PostsLoaded(posts);
    } catch (e) {
      state = PostsError(e.toString());
    }
  }

  Future<void> refresh() => fetchPosts();
}

// ─── Recommended people state ─────────────────────────────────────────────────

sealed class PeopleState {
  const PeopleState();
}

class PeopleInitial extends PeopleState {
  const PeopleInitial();
}

class PeopleLoading extends PeopleState {
  const PeopleLoading();
}

class PeopleLoaded extends PeopleState {
  final List<PeopleRecommended> people;
  const PeopleLoaded(this.people);
}

class PeopleError extends PeopleState {
  final String message;
  const PeopleError(this.message);
}

// ─── Recommended people provider ──────────────────────────────────────────────

final peopleNotifierProvider =
    NotifierProvider<PeopleNotifier, PeopleState>(PeopleNotifier.new);

class PeopleNotifier extends Notifier<PeopleState> {
  final _repo = PostRepository.instance;

  @override
  PeopleState build() {
    fetchPeople();
    return const PeopleLoading();
  }

  Future<void> fetchPeople() async {
    state = const PeopleLoading();
    try {
      final people = await _repo.fetchRecommendedPeople();
      state = PeopleLoaded(people);
    } catch (e) {
      state = PeopleError(e.toString());
    }
  }
}

// ─── Selected category provider ───────────────────────────────────────────────

/// Tracks which category pill is selected on the home screen.
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
