import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Ensure this path matches your project structure
import 'core/routing/app_router.dart'; 
import 'features/onboarding/screens/start_screen.dart';

void main() {
  runApp(const VibeApp());
}

class VibeApp extends StatelessWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vibe',
      debugShowCheckedModeBanner: false,
      
      // Links to your central routing logic in the Core layer
      routerConfig: AppRouter.router, 
      
      theme: ThemeData(
        useMaterial3: true,
        // Matches the dark, moody aesthetic of your Vibe project
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A0B2E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A0B2E),
      ),
    );
  }
}