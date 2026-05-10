import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavHandler {
  static void onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/chat');
        break;
      case 2:
        context.go('/post');
        break;
      case 3:
        context.go('/saved');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
