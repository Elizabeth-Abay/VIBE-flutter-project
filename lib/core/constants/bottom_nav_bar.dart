import 'package:flutter/material.dart';

class VibeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const VibeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFB0B0B0), // Grey background from image_9125ff.png
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home, // Solid version for active state
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: 'Chat',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          
          // The Center Plus Button usually stays the same
          GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),

          _NavBarItem(
            icon: Icons.cloud_done_outlined,
            activeIcon: Icons.cloud_done,
            label: 'Saved',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // We use a ternary operator to change the color based on selection
    final Color activeColor = Colors.black;
    final Color inactiveColor = Colors.black45;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon, // Swap icon shape
            color: isSelected ? activeColor : inactiveColor, // Swap color
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}