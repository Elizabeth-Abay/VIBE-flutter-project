import 'package:flutter/material.dart';

class VibeColors {
  static const Color background = Color(0xFF0A0B1E);
  static const Color card = Color(0xFF161A33);
  static const Color primary = Color(0xFFAC5AF7);
  static const Color secondary = Color(0xFF3B82F6);
  static const Color text = Colors.white;
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color danger = Color(0xFFB91C1C);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient messageGradient = LinearGradient(
    colors: [Color(0xFFAC5AF7), Color(0xFF6366F1), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
