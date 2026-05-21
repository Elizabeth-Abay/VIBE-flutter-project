import 'package:flutter/material.dart';
import 'home_page.dart';
// Using your custom widget path

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final int _currentIndex = 0;

  // The pages for each tab. In Clean Architecture, these usually represent
  // different feature modules.
  final List<Widget> _pages = [
    const HomePage(),
    // and other pages
  ];

  // This handles the tab switching and is where you'll eventually
  // trigger backend requests via your Providers.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // IndexedStack is preferred over the simple list index to
      // preserve the state (like scroll position) of your pages.
      body: IndexedStack(index: _currentIndex, children: _pages),
    );
  }
}
