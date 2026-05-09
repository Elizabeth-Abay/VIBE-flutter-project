import 'package:flutter/material.dart';

class VibeSelector extends StatefulWidget {
  final String title;
  final IconData icon;

  const VibeSelector({super.key, required this.title, required this.icon});

  @override
  State<VibeSelector> createState() => _VibeSelectorState();
}

class _VibeSelectorState extends State<VibeSelector> {
  String selectedVibe = 'Neutral';
  final List<String> options = ['Love', 'Like', 'Neutral', 'Bothered', 'Hate'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(widget.icon, color: Colors.white70),
          title: Text(widget.title, style: const TextStyle(color: Colors.white, fontFamily: 'Times New Roman')),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((vibe) {
              bool isSelected = selectedVibe == vibe;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(vibe, style: TextStyle(color: isSelected ? Colors.white : Colors.white54)),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple,
                  backgroundColor: Colors.white10,
                  onSelected: (bool selected) {
                    setState(() { selectedVibe = vibe; });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}