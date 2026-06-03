import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

/// Tracks the selected category pill value (defaults to 'books')
final selectedCategoryProvider = StateProvider<String>((ref) => 'books');

/// Automatically fires off a GET request when the selected category modifications change
final postsFeedProvider = FutureProvider<List<dynamic>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  final api = ApiClient.instance;
  
  final response = await api.get('/post/get-post-given-category/${Uri.encodeComponent(category)}');
  return response['posts'] as List<dynamic>? ?? [];
});