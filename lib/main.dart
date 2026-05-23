import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  // Ensure Flutter engine is ready before any plugin calls (e.g. sqflite).
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ProviderScope is the Riverpod container — must be the outermost widget.
    const ProviderScope(child: VibeApp()),
  );
}

/// Root widget — ConsumerWidget so it can pass [ref] into the router.
class VibeApp extends ConsumerWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // createRouter(ref) wires GoRouter's redirect to auth state changes.
    final router = AppRouter.createRouter(ref);

    return MaterialApp.router(
      title: 'Vibe',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // Use the project's own unified theme (VibeColors, AppTheme).
      theme: AppTheme.darkTheme,
    );
  }
}
