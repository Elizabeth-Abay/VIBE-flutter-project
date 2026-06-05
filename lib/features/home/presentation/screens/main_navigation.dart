import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../../core/widgets/top_navigation_bar.dart';
import '../../../chat/presentation/screens/chat_list_screen.dart';
import '../../../chat/presentation/screens/saved_messages_screen.dart';
import '../../../profiles/screens/profile_view_screen.dart';
import 'home_page.dart';

class MainNavigation extends ConsumerStatefulWidget {
  final int initialTab;

  const MainNavigation({super.key, this.initialTab = 0});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  void didUpdateWidget(MainNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _currentIndex = widget.initialTab;
    }
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      context.push('/post');
      return;
    }
    const routes = ['/home', '/chat', '', '/saved', '/profile'];
    if (index >= routes.length || routes[index].isEmpty) return;
    setState(() => _currentIndex = index);
    context.go(routes[index]);
  }

  Widget _tabBody() {
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ChatListScreen();
      case 3:
        // return const SavedMessagesScreen(embedded: true);
      case 4:
        return const ProfileViewScreen(embedded: true);
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            VibeTopNavBar(
              onNotificationTap: () => context.push('/notifications'),
              onConnectionsTap: () => context.push('/connected'),
            ),
            Expanded(child: _tabBody()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
