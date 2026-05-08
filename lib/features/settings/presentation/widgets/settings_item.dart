import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const SettingsItem({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.white70) : null,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      onTap: onTap,
    );
  }
}
