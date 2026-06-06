import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/profile_notifier.dart';
import './edit_profile_screen.dart';

class ProfileViewPage extends ConsumerWidget {
  const ProfileViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1424),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text(
                'No Profile Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Avatar
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pinkAccent, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage:
                          profile.profileUrl != null &&
                              profile.profileUrl!.isNotEmpty
                          ? NetworkImage(profile.profileUrl!)
                          : null,
                      child:
                          profile.profileUrl == null ||
                              profile.profileUrl!.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Bio Section Placeholders
                const SizedBox(height: 25),

                const SizedBox(height: 40),

                // Edit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF22283A,
                      ), // Made visible from transparent
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Delete Account
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
