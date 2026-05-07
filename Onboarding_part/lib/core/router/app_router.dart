import 'package:go_router/go_router.dart';
// Use relative imports consistently to avoid "Ambiguous Import" errors
import '../../features/onboarding/screens/start_screen.dart';
import '../../features/onboarding/screens/welcome1_screen.dart';
import '../../features/onboarding/screens/welcome2_screen.dart';
import '../../features/onboarding/screens/welcome3_screen.dart';
import '../../features/onboarding/screens/welcome4_screen.dart';
import '../../features/notification/presentation/screens/notification_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const StartScreen(), // Added const and ()
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/welcome1',
      builder: (context, state) => const Welcome1Screen(), // Added const and ()
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
  ],
);
