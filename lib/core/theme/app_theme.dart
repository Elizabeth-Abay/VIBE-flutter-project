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

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: VibeColors.background,
      cardColor: VibeColors.card,
      // Your chosen academic font
      fontFamily: 'Times New Roman',

      // Primary color mapping for buttons and highlights
      primaryColor: VibeColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: VibeColors.primary,
        secondary: VibeColors.secondary,
        surface: VibeColors.card,
        error: VibeColors.danger,
      ),

      // Integrated AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: VibeColors.text,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Times New Roman',
        ),
      ),

      // Integrated Text Theme using your color constants
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: VibeColors.text,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: VibeColors.text,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: VibeColors.text),
        bodyMedium: TextStyle(color: VibeColors.textMuted),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: VibeColors.primary,
        foregroundColor: Colors.white,
      ),

      // Custom Gradients Extension
      extensions: [
        VibeGradients(
          primaryGradient: VibeColors.primaryGradient,
          messageGradient: VibeColors.messageGradient,
        ),
      ],
    );
  }
}

// Extension to allow access to gradients via Theme.of(context)
class VibeGradients extends ThemeExtension<VibeGradients> {
  final LinearGradient? primaryGradient;
  final LinearGradient? messageGradient;

  VibeGradients({required this.primaryGradient, required this.messageGradient});

  @override
  VibeGradients copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? messageGradient,
  }) {
    return VibeGradients(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      messageGradient: messageGradient ?? this.messageGradient,
    );
  }

  @override
  VibeGradients lerp(ThemeExtension<VibeGradients>? other, double t) {
    if (other is! VibeGradients) return this;
    return VibeGradients(
      primaryGradient: LinearGradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      ),
      messageGradient: LinearGradient.lerp(
        messageGradient,
        other.messageGradient,
        t,
      ),
    );
  }
}
