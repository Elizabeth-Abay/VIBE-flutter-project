import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/theme/vibe_theme.dart';

void main() {
  runApp(const VibeApp());
}

class VibeApp extends StatelessWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vibe Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: VibeColors.background,
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
