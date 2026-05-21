import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import '../../../../core/network/api_client.dart';

/// Handles image picking from gallery/camera and uploading to the server.
/// Returns the CDN URL string on success, or throws on failure.
class ImageUploadService {
  ImageUploadService._();
  static final ImageUploadService instance = ImageUploadService._();

  final _picker = ImagePicker();

  // ─── Pick from gallery ───────────────────────────────────────────────────

  Future<File?> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,   // Compress to 85% to save bandwidth
      maxWidth: 1280,
      maxHeight: 1280,
    );
    return picked != null ? File(picked.path) : null;
  }

  // ─── Pick from camera ────────────────────────────────────────────────────

  Future<File?> pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    return picked != null ? File(picked.path) : null;
  }

  // ─── Upload to server ────────────────────────────────────────────────────

  /// Uploads [file] as multipart/form-data to POST /media/upload.
  /// Returns the CDN URL of the uploaded image.
  Future<String> uploadImage(File file) async {
    final token = await ApiClient.instance.getToken();
    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiClient.baseUrl}/media/upload'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        // Tell the server what kind of file this is
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Expect { "url": "https://cdn.vibe.app/..." }
      final body = response.body;
      final urlStart = body.indexOf('"url"') + 7;
      final urlEnd = body.indexOf('"', urlStart);
      return body.substring(urlStart, urlEnd);
    }

    throw Exception('Image upload failed: ${response.statusCode}');
  }
}
