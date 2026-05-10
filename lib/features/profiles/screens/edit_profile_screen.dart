import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // --- STATE VARIABLES ---

  // Key: Interest Title, Value: Selected Vibe label
  final Map<String, String> selectedVibes = {};

  // Controllers to hold and modify the input text
  late final TextEditingController nameController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    // Initialize with current values
    nameController = TextEditingController(text: "Salem Admasu");
    bioController = TextEditingController(
      text: "Passionate about robotics and programming, with a strong interest in building intelligent systems",
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      // We rely on the MainLayout Scaffold for the global AppBar and navigation.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30), // Extra space now that AppBar is gone

              // Profile Photo Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.purpleAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200'),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.pinkAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Tap to edit profile photo",
                  style: TextStyle(color: Colors.white60, fontFamily: 'Times New Roman'),
                ),
              ),
              const SizedBox(height: 30),

              // --- INPUT FIELDS ---

              _buildFieldLabel("Name"),
              _buildTextField(nameController),

              const SizedBox(height: 20),
              _buildFieldLabel("Bio"),
              _buildTextField(bioController, maxLines: 4),

              const SizedBox(height: 30),
              _buildFieldLabel("Interests"),
              const SizedBox(height: 10),

              // --- THE INTERACTIVE VIBE SELECTOR ---

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What's your vibe?",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Tell us how you feel about each interest.",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    // We pass the current selection for this interest
                    _buildVibeCard(Icons.music_note, "Music"),
                    const SizedBox(height: 15),
                    _buildVibeCard(Icons.sports_soccer, "Football"),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- GRADIENT UPDATE BUTTON ---

              Center(
                child: GestureDetector(
                  onTap: () {
                    // Logic to save name, bio, and vibes Map goes here
                    // Then go back to profile
                    context.pop();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE040FB), Color(0xFF448AFF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- BUILD HELPER WIDGETS ---

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Times New Roman',
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08), // Slightly darker for contrast
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller, // Now uses a controller
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _buildVibeCard(IconData icon, String title) {
    // Check if anything is currently selected for this interest
    String? currentSelection = selectedVibes[title];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Darker background
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Love", "Like", "Neutral", "Bothered", "Hate"].map((label) {
              return _vibeButton(
                label,
                isSelected: currentSelection == label, // True if active
                onTap: () {
                  setState(() {
                    selectedVibes[title] = label; // Update the state Map
                  });
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _vibeButton(String label, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Smooth fade animation
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          // Logic: Blue background if selected, dark navy if not
          color: isSelected ? const Color(0xFF448AFF) : const Color(0xFF1A1F3D),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            // Adds a fine border if selected
            color: isSelected ? Colors.white : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}