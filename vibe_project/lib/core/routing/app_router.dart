import 'package:flutter/material.dart';
import 'package:vibe_project/features/home/presentation/screens/home_page.dart';
import '../../features/home/presentation/screens/main_navigation.dart';
// also import the chats the profile.. here

class GenerateRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainNavigation());
      case '/chat':
      case '/profile':
      case '/saved':
      default:
        // the default page wld be the homepage
        return MaterialPageRoute(builder: (_) => MainNavigation());
    }
  }
}
