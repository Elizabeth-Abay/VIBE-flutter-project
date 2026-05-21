import 'package:flutter/material.dart';

class ConnectionsToggle extends StatefulWidget {
  final Function(int) onToggle;

  const ConnectionsToggle({super.key, required this.onToggle});

  @override
  State<ConnectionsToggle> createState() => _ConnectionsToggleState();
}

class _ConnectionsToggleState extends State<ConnectionsToggle> {
  int selectedIndex = 0; // 0 for Connected, 1 for Sent-Requests

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onToggle(index); // Notify the parent page to swap the list data
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E), // Darker background from image
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Connected Tab
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleTap(0),
                  child: Center(
                    child: Text(
                      'Connected',
                      style: TextStyle(
                        color: selectedIndex == 0 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Sent-Requests Tab
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleTap(1),
                  child: Center(
                    child: Text(
                      'Sent-Requests',
                      style: TextStyle(
                        color: selectedIndex == 1 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // The Animated Purple Indicator Line
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              // Transparent track
              Container(height: 3, color: Colors.transparent),
              // Moving indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: selectedIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5, // Line covers half the width
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBB86FC), // Purple color from image
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
