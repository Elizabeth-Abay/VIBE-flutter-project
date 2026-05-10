import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    // Screens that handle their own custom headers
    final bool hideGlobalHeader = location.startsWith('/saved') || location.startsWith('/blocked') || (location.startsWith('/chat') && location.split('/').length > 2);
    
    // Hide bottom nav on Chat Detail
    final bool hideBottomNav = (location.startsWith('/chat') && location.split('/').length > 2);

    return Scaffold(
      backgroundColor: VibeColors.background,
      appBar: hideGlobalHeader ? null : _buildHeader(context),
      body: child,
      bottomNavigationBar: hideBottomNav ? null : _buildBottomNav(context, location),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      title: Image.asset(
        'assets/images/logo.png',
        height: 38,
        fit: BoxFit.contain,
      ),
      actions: const [
        Icon(Icons.notifications, color: Color(0xFFFFD700), size: 24),
        SizedBox(width: 14),
        Icon(Icons.person, color: Color(0xFF63ABFF), size: 24),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, String location) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFC0C0C0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _navItem(context, Icons.home_outlined, 'Home', location == '/home', '/home')),
          Expanded(child: _navItem(context, Icons.chat_bubble_outline, 'Chat', location == '/chat', '/chat')),
          Expanded(child: Center(child: _plusButton(context))),
          Expanded(child: _navItem(context, location == '/saved' ? Icons.check : Icons.cloud_outlined, 'Saved', location == '/saved', '/saved')),
          Expanded(child: _navItem(context, Icons.person_outline, 'Profile', location == '/profile', '/profile')),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isActive, String path) {
    return GestureDetector(
      onTap: () => context.go(path),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: isActive ? 30 : 26,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _plusButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/post'),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
