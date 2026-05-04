import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts.dart';
import '../../core/errors/failures.dart';

class PostProvider extends ChangeNotifier {
  final GetPosts getPosts;
  
  PostProvider({required this.getPosts});

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getPosts(NoParams());
    
    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (posts) {
        _posts = posts;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case NetworkFailure:
        return 'No internet connection';
      default:
        return 'Unexpected error occurred';
    }
  }

  void refresh() {
    fetchPosts();
  }
}
