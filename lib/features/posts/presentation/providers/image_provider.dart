import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── 1. Holds the Selected Image File ────────────────────────────────────────
final pickedImageProvider = NotifierProvider<PickedImageNotifier, File?>(
  PickedImageNotifier.new,
);

class PickedImageNotifier extends Notifier<File?> {
  @override
  File? build() => null; // Initially, no image is selected

  void setImage(File file) => state = file;
  void clearImage() => state = null;
}

// ─── 2. Tracks the Image Compression/Upload Status ───────────────────────────
final imageUploadingProvider = NotifierProvider<ImageUploadingNotifier, bool>(
  ImageUploadingNotifier.new,
);

class ImageUploadingNotifier extends Notifier<bool> {
  @override
  bool build() => false; // Initially not uploading

  void setUploading(bool value) => state = value;
}
