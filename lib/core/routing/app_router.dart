import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── Onboarding ─────────────────────────────────────────────
import '../../features/onboarding/screens/start_screen.dart';
import '../../features/onboarding/screens/welcome1_screen.dart';
import '../../features/onboarding/screens/welcome2_screen.dart';
import '../../features/onboarding/screens/welcome3_screen.dart';
import '../../features/onboarding/screens/welcome4_screen.dart';

// ── Auth ───────────────────────────────────────────────────
import '../../features/auth/presentation/screens/email_entry_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/verification_screen.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/domain/entities/auth_state.dart';

// ── Home (FIXED) ───────────────────────────────────────────
import '../../features/home/presentation/screens/home_page.dart' as home_nav;

// ── Interests ──────────────────────────────────────────────
import '../../features/interests/presentation/screens/interest_selection_screen.dart';

// ── Chat ────────────────────────────────────────────────────
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/chat/presentation/screens/saved_messages_screen.dart';

// ── Connections (FIXED) ────────────────────────────────────
import '../../features/connections/presentation/screens/main_navigation.dart'
    as conn_nav;

// ── Notifications ──────────────────────────────────────────
import '../../features/notification/presentation/screens/notification_screen.dart';

// ── Posts ──────────────────────────────────────────────────
import '../../features/posts/presentation/screens/create_post.dart';

// ── Profile ────────────────────────────────────────────────
import '../../features/profiles/screens/profile_view_screen.dart';
import '../../features/profiles/screens/edit_profile_screen.dart';
import '../../features/profiles/screens/delete_account_screen.dart';

// ── Settings ───────────────────────────────────────────────
import '../../features/settings/presentation/screens/blocked_users_screen.dart';

// ── Core ───────────────────────────────────────────────────
import '../widgets/splash_screen.dart';
import 'auth_guard.dart';

// ───────────────────────────────────────────────────────────

final _rootNavKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      navigatorKey: _rootNavKey,
      initialLocation: '/splash',
      debugLogDiagnostics: false,

      refreshListenable: _AuthChangeNotifier(ref),

      redirect: (context, state) => authRedirect(ref, state.matchedLocation),

      routes: [
        // ── Splash ───────────────────────────────────────────
        GoRoute(
          path: '/splash',
          builder: (_, __) => const SplashScreen(),
          redirect: (_, __) {
            final ready = ref.read(authReadyProvider);
            if (!ready) return null;

            final auth = ref.read(authNotifierProvider);
            return auth is AuthStateAuthenticated ? '/home' : '/start-screen';
          },
        ),

        // ── Onboarding ───────────────────────────────────────
        GoRoute(path: '/start-screen', builder: (_, __) => const StartScreen()),
        GoRoute(path: '/welcome1', builder: (_, __) => const Welcome1Screen()),
        GoRoute(path: '/welcome2', builder: (_, __) => const Welcome2Screen()),
        GoRoute(path: '/welcome3', builder: (_, __) => const Welcome3Screen()),
        GoRoute(path: '/welcome4', builder: (_, __) => const Welcome4Screen()),

        // ── Auth ─────────────────────────────────────────────
        GoRoute(path: '/signin', builder: (_, __) => const SignInScreen()),
        GoRoute(
          path: '/login-email',
          builder: (_, __) => const EmailEntryScreen(),
        ),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
        GoRoute(
          path: '/verify',
          builder: (_, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return VerificationScreen(email: email);
          },
        ),

        // ── Interests ───────────────────────────────────────
        GoRoute(
          path: '/interest-selection',
          builder: (_, __) => const InterestSelectionScreen(),
        ),

        // ── HOME (FIXED) ────────────────────────────────────
        GoRoute(path: '/home', builder: (_, __) => const home_nav.HomePage()),

        // ── Chat ─────────────────────────────────────────────
        GoRoute(
          path: '/chat',
          builder: (_, __) => const ChatListScreen(),
          routes: [
            GoRoute(
              path: ':name',
              builder: (_, state) => ChatDetailScreen(
                userName: state.pathParameters['name'] ?? 'Chat',
              ),
            ),
          ],
        ),

        GoRoute(
          path: '/saved',
          builder: (_, __) => const SavedMessagesScreen(),
        ),

        // ── Connections (FIXED) ─────────────────────────────
        GoRoute(
          path: '/connected',
          builder: (_, __) => const conn_nav.ConnectionsMainLayout(),
        ),

        // ── Notifications ───────────────────────────────────
        GoRoute(
          path: '/notifications',
          builder: (_, __) => const NotificationScreen(activeTab: 'updates'),
          routes: [
            GoRoute(
              path: 'requests',
              builder: (_, __) =>
                  const NotificationScreen(activeTab: 'requests'),
            ),
          ],
        ),

        // ── Posts ───────────────────────────────────────────
        GoRoute(path: '/post', builder: (_, __) => const CreatePostPage()),

        // ── Profile ─────────────────────────────────────────
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

        // ── Settings ────────────────────────────────────────
        GoRoute(
          path: '/blocked',
          builder: (_, __) => const BlockedUsersScreen(),
        ),
      ],
    );
  }
}

// ── Auth listener ───────────────────────────────────────────

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}
