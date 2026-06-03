import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/image_provider.dart'; 
import '../providers/post_provider.dart'; 


/// Shows the picked image preview + upload status.
/// Shows nothing if no image is picked.
class ImagePreviewWidget extends ConsumerWidget {
  const ImagePreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 Hooked up securely to your clean architectural state variables
    final pickedFile = ref.watch(pickedImageProvider);
    final isUploading = ref.watch(imageUploadingProvider);
    
    // Monitors post state to know if processing completed successfully
    final postState = ref.watch(createPostNotifierProvider);
    final isPostSuccess = postState.value == true;

    // Nothing picked — render nothing
    if (pickedFile == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          // ── Image thumbnail ──────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              pickedFile,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

          // ── Upload progress overlay ──────────────────────────────────────
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE186FF),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Uploading image...',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

          // ── Upload success tick ──────────────────────────────────────────
          // 🎯 Renders when the media file is loaded locally and hasn't failed
          if (!isUploading && !isPostSuccess)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Ready',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

          // ── Remove button ────────────────────────────────────────────────
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              // 🎯 Clear action directly updates the provider state to collapse this card container
              onTap: () => ref.read(pickedImageProvider.notifier).clearImage(),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}