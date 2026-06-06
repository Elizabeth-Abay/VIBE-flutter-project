import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/profile_notifier.dart';
import '../../interests/presentation/widgets/interest_selector.dart';
import '../../interests/presentation/providers/interests_notifier.dart';
import './profile_view_screen.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  Timer? _debounceTimer;
  ProviderSubscription? _profileSubscription;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();

    // Listen to profile changes from outside this screen
    _profileSubscription = ref.listenManual(profileProvider, (previous, next) {
      final profile = next.value;
      if (profile == null) return;

      // Only sync if the name is different (prevents fighting user input)
      if (_nameController.text.trim() != (profile.name ?? '')) {
        _nameController.text = profile.name ?? '';
      }
    }, fireImmediately: true);
  }

  void _onFieldsChanged() {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      if (!mounted) return;

      final nameText = _nameController.text.trim();
      final currentProfile = ref.read(profileProvider).value;

      // Avoid unnecessary API calls
      if (nameText == currentProfile?.name) return;

      await ref.read(profileProvider.notifier).updateProfile(name: nameText);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile details auto-saved!'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();

    // Final save if user leaves before debounce fires
    final pendingName = _nameController.text.trim();
    final currentName = ref.read(profileProvider).value?.name?.trim();

    if (pendingName.isNotEmpty && pendingName != currentName) {
      ref.read(profileProvider.notifier).updateProfile(name: pendingName);
    }

    _profileSubscription?.close();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final profile = profileAsync.value;
    final isSaving = ref.watch(interestsSavingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1424),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Profile Photo
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        profile?.profileUrl != null &&
                            profile!.profileUrl!.isNotEmpty
                        ? NetworkImage(profile.profileUrl!)
                        : null,
                    child:
                        profile?.profileUrl == null ||
                            profile!.profileUrl!.isEmpty
                        ? const Icon(Icons.person, size: 45, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.pinkAccent,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Tap to edit profile photo',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Name Field
            const Text(
              'Name',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF22283A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => _onFieldsChanged(),
            ),

            const SizedBox(height: 25),

            // Interests Section
            const InterestSelectionBox(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
