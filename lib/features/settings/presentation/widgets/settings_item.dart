import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? trailing;

  const SettingsItem({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.white70) : null,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right, color: Colors.white38)
              : null),
      onTap: onTap,
    );
  }
}
