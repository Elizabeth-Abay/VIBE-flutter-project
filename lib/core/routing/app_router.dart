import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/onboarding/screens/start_screen.dart';
import '../../features/onboarding/screens/welcome1_screen.dart';
import '../../features/onboarding/screens/welcome2_screen.dart';
import '../../features/onboarding/screens/welcome3_screen.dart';
import '../../features/onboarding/screens/welcome4_screen.dart';
import '../../features/profiles/screens/profile_view_screen.dart';
import '../../features/profiles/screens/delete_account_screen.dart';
import '../../features/profiles/screens/edit_profile_screen.dart';
import '../../features/interests/presentation/screens/interest_selection_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/chat/presentation/screens/saved_messages_screen.dart';
import '../../features/settings/presentation/screens/blocked_users_screen.dart';
import '../../features/chat/presentation/widgets/main_layout.dart';
import '../../features/auth/presentation/screens/email_entry_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/verification_screen.dart';
import '../../features/connections/presentation/screens/connected_screen.dart';
import '../../features/connections/presentation/screens/main_navigation.dart';
import '../../features/connections/presentation/screens/sent_request.dart';
import '../../features/posts/presentation/screens/create_post.dart';
import '../../features/notification/presentation/screens/notification_screen.dart';
import '../../features/home/presentation/screens/main_navigation.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/start-screen',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // --- 1. AUTHENTICATION FLOW (Full Screen) ---
      GoRoute(
        path: '/login-email',
        builder: (context, state) => const EmailEntryScreen(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => const VerificationScreen(),
      ),

      // --- 2. MAIN APPLICATION FLOW (Inside ShellRoute with Bottom Nav) ---
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          // HOME / FEED FLOW
          GoRoute(
            path: '/start-screen',
            builder: (context, state) => const StartScreen(),
          ),
          GoRoute(
            path: '/interest-selection',
            builder: (context, state) => const InterestSelectionScreen(),
          ),

          // CHAT FEATURE FLOW
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatListScreen(),
            routes: [
              GoRoute(
                path: ':name',
                builder: (context, state) {
                  final name = state.pathParameters['name'] ?? 'Chat';
                  return ChatDetailScreen(userName: name);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/welcome1',
            builder: (context, state) => const Welcome1Screen(),
          ),

          GoRoute(
            path: '/welcome2',
            builder: (context, state) => const Welcome2Screen(),
          ),

          GoRoute(
            path: '/welcome3',
            builder: (context, state) => const Welcome3Screen(),
          ),

          GoRoute(
            path: '/welcome4',
            builder: (context, state) => const Welcome4Screen(),
          ),

          // SAVED CONTENT
          GoRoute(
            path: '/saved',
            builder: (context, state) => const SavedMessagesScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const MainNavigation(),
          ),
          GoRoute(
            path: '/blocked',
            builder: (context, state) => const BlockedUsersScreen(),
          ),
          GoRoute(
            path: '/post',
            builder: (context, state) => const CreatePostPage(),
          ),

          // PROFILE & SETTINGS FLOW
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileViewScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'delete',
                builder: (context, state) => const DeleteAccountScreen(),
              ),

              GoRoute(
                path: '/notifications',
                builder: (context, state) =>
                    const NotificationScreen(activeTab: 'updates'),
                routes: [
                  GoRoute(
                    path: 'requests', // Full path: /notifications/requests
                    builder: (context, state) =>
                        const NotificationScreen(activeTab: 'requests'),
                  ),
                ],
              ),

              // 2. Connections Feature
              // GoRoute(
              //   path: '/connections',
              //   builder: (context, state) =>
              //       const ConnectionsScreen(initialTab: 'connected'),
              //   routes: [
              //     GoRoute(
              //       path: 'sent', // This makes the URL /connections/sent
              //       builder: (context, state) =>
              //           const ConnectionsScreen(initialTab: 'sent'),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    ],
  );
}
