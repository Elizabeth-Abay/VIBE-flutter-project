import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_client.dart';
import '../model/post_model.dart'; // 🎯 Import the model now!
import '../../domain/entity/post_entity.dart';

class PostRepository {
  PostRepository._internal();
  static final PostRepository instance = PostRepository._internal();

  final _api = ApiClient.instance;

  // ─── GET: Fetch Posts In A Specific Category ──────────────────────────────
  Future<List<PostEntity>> getPostsInACategory(String category) async {
    final encodedCategory = Uri.encodeComponent(category.toLowerCase());

    final response = await _api.get(
      '/post/get-post-given-category/$encodedCategory',
    );

    // Dynamic extraction supporting both variants from your Node controller response
    final List<dynamic> rawList = response['posts'] ?? response['result'] ?? [];

    return rawList
        .map(
          (json) => PostModel.fromJson(json as Map<String, dynamic>),
        ) // 🎯 Parses using Model
        .toList(); // Automatically upcasts down to List<PostEntity>
  }

  // ─── POST: Create A Post (Handles Text & Image Binary Upload) ──────────────
  Future<bool> createPost({
    required String title,
    required String content,
    required String category,
    File? imageFile,
  }) async {
    if (imageFile != null) {
      final multipartRequest = _api.createMultipartRequest(
        'POST',
        '/post/make-post',
      );

      // Maps directly to your Express: let { categorySelected, postTitle, postContent } = req.body;
      multipartRequest.fields['postTitle'] = title;
      multipartRequest.fields['postContent'] = content;
      multipartRequest.fields['categorySelected'] = category;

      // Maps directly to your Express: uploads.single('postPic')
      multipartRequest.files.add(
        await http.MultipartFile.fromPath('postPic', imageFile.path),
      );

      final response = await _api.sendMultipartRequest(multipartRequest);
      return response['success'] == true;
    }

    // Fallback JSON POST if no media attachment is added
    final response = await _api.post(
      '/post/make-post',
      body: {
        'postTitle': title,
        'postContent': content,
        'categorySelected': category,
        'postPic': null,
      },
    );

    return response['success'] == true;
  }
}
