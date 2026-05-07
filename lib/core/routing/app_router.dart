import 'package:go_router/go_router.dart';

// Use the package name found in your pubspec.yaml
import 'package:mobapp/features/auth/presentation/screens/email_entry_screen.dart';
import 'package:mobapp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:mobapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:mobapp/features/auth/presentation/screens/verification_screen.dart';

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
