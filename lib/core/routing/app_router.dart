import 'package:go_router/go_router.dart';
<<<<<<< HEAD
import '../../features/auth/presentation/screens/profile_view_screen.dart';
import '../../features/auth/presentation/screens/edit_profile_screen.dart';
import '../../features/auth/presentation/screens/delete_account_screen.dart';
import '../../features/auth/presentation/screens/interest_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/chat/presentation/screens/saved_messages_screen.dart';
import '../../features/settings/presentation/screens/blocked_users_screen.dart';
import '../../features/settings/presentation/screens/delete_account_screen.dart';
import '../../features/chat/presentation/widgets/main_layout.dart';
import 'package:mobapp/features/auth/presentation/screens/email_entry_screen.dart';
import 'package:mobapp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:mobapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:mobapp/features/auth/presentation/screens/verification_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/profile', 
    routes: [
      GoRoute(path: '/profile', builder: (context, state) => const ProfileViewScreen()),
      GoRoute(path: '/edit-profile', builder: (context, state) => const EditProfileScreen()),
      GoRoute(path: '/delete-account', builder: (context, state) => const DeleteAccountScreen()),
      GoRoute(path: '/interest-selection', builder: (context, state) => const InterestSelectionScreen()),
    ],
  );
}



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



// Use the package name found in your pubspec.yaml


final GoRouter router = GoRouter(
  initialLocation: '/login-email',
  routes: [
    GoRoute(
      path: '/login-email',
      builder: (context, state) => const EmailEntryScreen(),
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) => const VerificationScreen(),
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/signin', builder: (context, state) => const SignInScreen()),
  ],
);

=======

import '../../features/auth/presentation/screens/profile_view_screen.dart';
import '../../features/auth/presentation/screens/edit_profile_screen.dart';
import '../../features/auth/presentation/screens/delete_account_screen.dart';
import '../../features/auth/presentation/screens/interest_selection_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/profile',
    routes: [
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileViewScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/delete-account',
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: '/interest-selection',
        builder: (context, state) => const InterestSelectionScreen(),
      ),
    ],
  );
}
>>>>>>> 8c4de2a95dd9cfc37d044f3c30e9e7de3335d57a
