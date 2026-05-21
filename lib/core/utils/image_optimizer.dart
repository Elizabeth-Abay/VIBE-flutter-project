class ImageOptimizer {
  static const int maxImageWidth = 400;
  static const int maxImageHeight = 300;

  /// Creates an optimized URL for external services like Unsplash
  static String getOptimizedUrl(String originalUrl, {int? width, int? height}) {
    // Basic validation
    if (originalUrl.isEmpty) return originalUrl;

    if (originalUrl.contains('unsplash.com')) {
      final w = width ?? maxImageWidth;
      final h = height ?? maxImageHeight;

      final uri = Uri.parse(originalUrl);

      // Start with the existing parameters so we don't lose the image ID/token
      final Map<String, String> updatedQuery = Map<String, String>.from(
        uri.queryParameters,
      );

      // Add or overwrite optimization parameters
      updatedQuery['w'] = w.toString();
      updatedQuery['h'] = h.toString();
      updatedQuery['fit'] = 'crop';
      updatedQuery['q'] = '80';
      updatedQuery['auto'] =
          'format'; // Extra tip: forces modern formats like WebP if supported

      // Rebuild the URI properly
      return uri.replace(queryParameters: updatedQuery).toString();
    }

    return originalUrl;
  }

  /// Gets file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';

    // For anything bigger than 1MB
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
