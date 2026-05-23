import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../../core/widgets/top_navigation_bar.dart';
import '../../../../core/utils/bottom_nav_handler.dart';
import 'home_page.dart';

/// Main shell that wraps HomePage with the top and bottom nav bars.
/// All mock data removed — navigation is wired to BottomNavHandler
/// which uses GoRouter to push routes.
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // ── Top nav bar ────────────────────────────────────────────────
          VibeTopNavBar(
            onNotificationTap: () => context.push('/notifications'),
            onConnectionsTap: () => context.push('/connected'),
          ),

          // ── Page content ───────────────────────────────────────────────
          const Expanded(child: HomePage()),
        ],
      ),

      // ── Bottom nav bar ─────────────────────────────────────────────────
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          BottomNavHandler.onTabTapped(context, index);
        },
      ),
    );
  }
}
