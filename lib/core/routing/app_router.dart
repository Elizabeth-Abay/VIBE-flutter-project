import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/chat/presentation/screens/saved_messages_screen.dart';
import '../../features/settings/presentation/screens/blocked_users_screen.dart';
import '../../features/settings/presentation/screens/delete_account_screen.dart';
import '../../features/chat/presentation/widgets/main_layout.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/chat',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatListScreen(),
        ),
        GoRoute(
          path: '/saved',
          builder: (context, state) => const SavedMessagesScreen(),
        ),
        GoRoute(
          path: '/blocked',
          builder: (context, state) => const BlockedUsersScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const DeleteAccountScreen(),
        ),
        GoRoute(
          path: '/chat/:name',
          builder: (context, state) {
            final name = state.pathParameters['name'] ?? 'Chat';
            return ChatDetailScreen(userName: name);
          },
        ),
      ],
    ),
  ],
);
