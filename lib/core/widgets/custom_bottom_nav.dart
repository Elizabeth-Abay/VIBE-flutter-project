import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin and decoration create the rounded "floating" footer look
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xFF8D8D8D), // The specific grey base color
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        children: [
          _buildGridItem(Icons.home_outlined, "Home", 0),
          _buildGridItem(Icons.chat_bubble_outline, "Chat", 1),
          
          // The prominent black center button
          Expanded(
            child: Center(
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
          
          _buildGridItem(Icons.cloud_download_outlined, "Saved", 3),
          _buildGridItem(Icons.person_outline, "Profile", 4),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, int index) {
    bool isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          // Vertical lines to create the grid effect from the image
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.black12, width: 0.5),
              left: BorderSide(color: Colors.black12, width: 0.5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.black : Colors.black87,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.black87,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Times New Roman', // Consistent academic style
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}