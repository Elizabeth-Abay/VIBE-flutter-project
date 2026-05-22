import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';

void main() {
  runApp(
    // ProviderScope is the Riverpod container — must wrap the entire app.
    const ProviderScope(
      child: VibeApp(),
    ),
  );
}

/// Root widget — ConsumerWidget so it can pass [ref] to the router.
class VibeApp extends ConsumerWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // createRouter(ref) wires auth state to GoRouter's redirect logic.
    final router = AppRouter.createRouter(ref);

    return MaterialApp.router(
      title: 'Vibe',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A0B2E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A0B2E),
        // Chip theme for tag input
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF2A1F5E),
          labelStyle: const TextStyle(color: Colors.white),
          side: const BorderSide(color: Color(0xFF7B72EF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        // SnackBar theme
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
    );
  }
}
