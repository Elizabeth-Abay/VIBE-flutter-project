import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/domain/entities/auth_state.dart';
import '../widgets/splash_screen.dart';
import 'auth_guard.dart';

final _rootNavKey = GlobalKey<NavigatorState>();
final _shellNavKey = GlobalKey<NavigatorState>();

class AppRouter {
  /// Creates a GoRouter wired to Riverpod auth state.
  /// Call this once inside a ConsumerWidget build method.
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/home',
      navigatorKey: _rootNavKey,

      // Re-evaluate redirect whenever auth state changes.
      refreshListenable: _AuthChangeNotifier(ref),

      redirect: (context, state) {
        final location = state.matchedLocation;
        return authRedirect(ref, location);
      },

      routes: [
        // ── Splash (shown while auth check runs) ─────────────────────────
        GoRoute(
          path: '/splash',
          builder: (_, __) => const SplashScreen(),
          redirect: (context, state) {
            final ready = ref.read(authReadyProvider);
            if (!ready) return null;
            final authState = ref.read(authNotifierProvider);
            return authState is AuthStateAuthenticated
                ? '/home'
                : '/start-screen';
          },
        ),

        // ── Auth flow ────────────────────────────────────────────────────
        GoRoute(
          path: '/signin',
          builder: (_, __) => const SignInScreen(),
        ),
        GoRoute(
          path: '/login-email',
          builder: (_, __) => const EmailEntryScreen(),
        ),
        GoRoute(
          path: '/verify',
          builder: (_, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return VerificationScreen(email: email);
          },
        ),
        GoRoute(
          path: '/signup',
          builder: (_, __) => const SignUpScreen(),
        ),

        // ── Main app shell (bottom nav) ──────────────────────────────────
        ShellRoute(
          navigatorKey: _shellNavKey,
          builder: (_, __, child) => MainLayout(child: child),
          routes: [
            GoRoute(
              path: '/start-screen',
              builder: (_, __) => const StartScreen(),
            ),
            GoRoute(
              path: '/welcome1',
              builder: (_, __) => const Welcome1Screen(),
            ),
            GoRoute(
              path: '/welcome2',
              builder: (_, __) => const Welcome2Screen(),
            ),
            GoRoute(
              path: '/welcome3',
              builder: (_, __) => const Welcome3Screen(),
            ),
            GoRoute(
              path: '/welcome4',
              builder: (_, __) => const Welcome4Screen(),
            ),
            GoRoute(
              path: '/interest-selection',
              builder: (_, __) => const InterestSelectionScreen(),
            ),
            GoRoute(
              path: '/home',
              builder: (_, __) => const MainNavigation(),
            ),
            GoRoute(
              path: '/chat',
              builder: (_, __) => const ChatListScreen(),
              routes: [
                GoRoute(
                  path: ':name',
                  builder: (_, state) {
                    final name = state.pathParameters['name'] ?? 'Chat';
                    return ChatDetailScreen(userName: name);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/connected',
              builder: (_, __) => const ConnectionsMainLayout(),
              routes: [
                GoRoute(
                  path: 'sent',
                  builder: (_, __) => const ConnectionsMainLayout(),
                ),
              ],
            ),
            GoRoute(
              path: '/notifications',
              builder: (_, __) =>
                  const NotificationScreen(activeTab: 'updates'),
              routes: [
                GoRoute(
                  path: 'requests',
                  builder: (_, __) =>
                      const NotificationScreen(activeTab: 'requests'),
                ),
              ],
            ),
            GoRoute(
              path: '/saved',
              builder: (_, __) => const SavedMessagesScreen(),
            ),
            GoRoute(
              path: '/blocked',
              builder: (_, __) => const BlockedUsersScreen(),
            ),
            GoRoute(
              path: '/post',
              builder: (_, __) => const CreatePostPage(),
            ),
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileViewScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (_, __) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'delete',
                  builder: (_, __) => const DeleteAccountScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ── Listenable that tells GoRouter to re-check redirects on auth change ───────

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}
