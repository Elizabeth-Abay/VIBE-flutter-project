import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/image_provider.dart'; 

/// Bottom sheet that lets the user choose between gallery and camera.
/// Call [ImagePickerSheet.show] from any widget.
class ImagePickerSheet extends ConsumerWidget {
  const ImagePickerSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ImagePickerSheet(),
    );
  }

  // ── Helper Function to execute the physical system pick ───────────────────
  Future<void> _handleImagePick(WidgetRef ref, BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    
    try {
      // ⏳ 1. Trigger the uploading spinner state layout guard
      ref.read(imageUploadingProvider.notifier).setUploading(true);
      
      // Dismiss the bottom sheet window overlay quickly
      if (context.mounted) Navigator.pop(context);

      // 📸 2. Fire the underlying native camera/gallery hardware module
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80, // Compress slightly to optimize network transit payloads
      );

      if (pickedFile != null) {
        // 💾 3. Save the native reference path straight into your global provider storage
        ref.read(pickedImageProvider.notifier).setImage(File(pickedFile.path));
      }
    } catch (e) {
      debugPrint("Media Picker Failure: $e");
    } finally {
      // 🛑 4. Turn off your uploading loader configurations smoothly
      ref.read(imageUploadingProvider.notifier).setUploading(false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Add Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ── Gallery ──────────────────────────────────────────────────
            _OptionTile(
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () => _handleImagePick(ref, context, ImageSource.gallery),
            ),
            const SizedBox(height: 12),

            // ── Camera ───────────────────────────────────────────────────
            _OptionTile(
              icon: Icons.camera_alt_outlined,
              label: 'Take a Photo',
              onTap: () => _handleImagePick(ref, context, ImageSource.camera),
            ),
            const SizedBox(height: 12),

            // ── Cancel ───────────────────────────────────────────────────
            _OptionTile(
              icon: Icons.close,
              label: 'Cancel',
              isDestructive: true,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.redAccent : const Color(0xFFE186FF),
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}