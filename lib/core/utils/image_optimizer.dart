class ImageOptimizer {
  static const int maxImageWidth = 400;
  static const int maxImageHeight = 300;

  /// Creates an optimized URL for external services like Unsplash
  static String getOptimizedUrl(String originalUrl, {int? width, int? height}) {
    if (originalUrl.contains('unsplash.com')) {
      // Unsplash supports dynamic resizing
      final w = width ?? maxImageWidth;
      final h = height ?? maxImageHeight;
      
      // Parse the original URL
      final uri = Uri.parse(originalUrl);
      
      // Create new query parameters
      final newQuery = <String, String>{
        'w': w.toString(),
        'h': h.toString(),
        'fit': 'crop',
        'q': '80', // JPEG quality
      };
      
      // Add existing parameters if any
      if (uri.queryParameters.isNotEmpty) {
        newQuery.addAll(uri.queryParameters);
      }
      
      // Build the optimized URL
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

  /// Gets file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
