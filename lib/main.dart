import 'package:flutter/material.dart';
import 'package:edit_profile/core/routing/app_router.dart';
import 'package:edit_profile/core/theme/app_theme.dart';

void main() {
  // Ensuring Flutter is initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use MaterialApp.router to integrate your GoRouter configuration
    return MaterialApp.router(
      title: 'Vibe Edit Profile',
      debugShowCheckedModeBanner: false,
      
      // Points to your core/theme/ folder for that fancy academic look
      theme: AppTheme.darkTheme, 
      
      // Points to your core/routing/ folder to handle screen switching
      routerConfig: AppRouter.router, 
    );
  }
}