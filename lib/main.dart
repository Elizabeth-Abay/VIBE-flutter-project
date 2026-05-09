<<<<<<< HEAD
<<<<<<< HEAD
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
=======
import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/theme/vibe_theme.dart';
=======
import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
>>>>>>> ae2bc717ffebef3b73439a13f6d3cc89ea3a7420

void main() {
  runApp(const VibeApp());
}

class VibeApp extends StatelessWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
<<<<<<< HEAD
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
>>>>>>> 1e1053074115c640e52ef23161077718c0e197cf
=======
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D1F),
      ),
    );
  }
}
>>>>>>> ae2bc717ffebef3b73439a13f6d3cc89ea3a7420
