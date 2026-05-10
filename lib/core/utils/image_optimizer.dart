import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageOptimizer {
  static const int maxImageWidth = 400;
  static const int maxImageHeight = 300;
  static const int jpegQuality = 85;

  /// Optimizes an image from URL and returns a local file path
  static Future<String?> optimizeImageFromUrl(String imageUrl, {int? customWidth, int? customHeight}) async {
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return null;

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'optimized_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final optimizedPath = path.join(tempDir.path, fileName);

      // Decode and resize the image
      final originalImage = await decodeImageFromBytes(response.bodyBytes);
      if (originalImage == null) return null;

      final optimizedImage = await resizeImage(originalImage, customWidth ?? maxImageWidth, customHeight ?? maxImageHeight);
      
      // Save optimized image
      final optimizedFile = File(optimizedPath);
      await optimizedFile.writeAsBytes(optimizedImage);
      
      return optimizedPath;
    } catch (e) {
      debugPrint('Error optimizing image: $e');
      return null;
    }
  }

  /// Creates an optimized URL for external services like Unsplash
  static String getOptimizedUrl(String originalUrl, {int? width, int? height}) {
    if (originalUrl.contains('unsplash.com')) {
      // Unsplash supports dynamic resizing
      final w = width ?? maxImageWidth;
      final h = height ?? maxImageHeight;
      final quality = 'q=80'; // JPEG quality
      
      // Remove existing parameters and add new ones
      final uri = Uri.parse(originalUrl);
      final newQuery = Map<String, String>.from(uri.queryParameters);
      newQuery['w'] = w.toString();
      newQuery['h'] = h.toString();
      newQuery['fit'] = 'crop';
      newQuery[quality] = '';
      
      return Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: newQuery,
      ).toString();
    }
    
    // For other services, return original URL
    return originalUrl;
  }

  /// Resizes an image to specified dimensions
  static Future<Uint8List> resizeImage(Uint8List imageBytes, int targetWidth, int targetHeight) async {
    // This is a simplified version - in a real app you'd use image package
    // For now, we'll return the original bytes with a note to implement proper resizing
    debugPrint('Image resizing should be implemented with image package');
    return imageBytes;
  }

  /// Decodes image from bytes
  static Future<Uint8List?> decodeImageFromBytes(Uint8List bytes) async {
    try {
      // In a real implementation, you'd use the image package here
      // For now, return the original bytes
      return bytes;
    } catch (e) {
      debugPrint('Error decoding image: $e');
      return null;
    }
  }

  /// Checks if an image file needs optimization
  static bool needsOptimization(File imageFile) {
    final fileSize = imageFile.lengthSync();
    final maxSizeBytes = 500 * 1024; // 500KB threshold
    
    return fileSize > maxSizeBytes;
  }

  /// Gets file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
