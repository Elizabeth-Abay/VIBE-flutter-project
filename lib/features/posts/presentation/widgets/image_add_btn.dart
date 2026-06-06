import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './image_picker_sheet.dart';
import '../providers/image_provider.dart';

class ImageAddButton extends ConsumerWidget {
  final bool isUploading;

  const ImageAddButton({super.key, required this.isUploading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPicked = ref.watch(pickedImageProvider) != null;

    return GestureDetector(
      onTap: isUploading ? null : () => ImagePickerSheet.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasPicked
              ? const Color(0xFF2A1F5E)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasPicked ? const Color(0xFF7B72EF) : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE186FF),
                      ),
                    ),
                  )
                : Icon(
                    hasPicked
                        ? Icons.check_circle_outline
                        : Icons.add_photo_alternate_outlined,
                    color: hasPicked ? const Color(0xFF7B72EF) : Colors.white54,
                    size: 20,
                  ),
            const SizedBox(width: 8),
            Text(
              isUploading
                  ? 'Uploading...'
                  : hasPicked
                  ? 'Change Photo'
                  : 'Add Photo',
              style: TextStyle(
                color: hasPicked ? const Color(0xFF7B72EF) : Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
