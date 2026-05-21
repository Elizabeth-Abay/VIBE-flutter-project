import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/domain/entities/auth_state.dart';

/// Routes that anyone can visit without being logged in.
const publicRoutes = {
  '/start-screen',
  '/welcome1',
  '/welcome2',
  '/welcome3',
  '/welcome4',
  '/signin',
  '/signup',
  '/login-email',
  '/verify',
};

/// Routes only visited BEFORE auth is confirmed (onboarding).
const onboardingRoutes = {
  '/start-screen',
  '/welcome1',
  '/welcome2',
  '/welcome3',
  '/welcome4',
};

/// Reads auth state and returns the redirect path, or null if no redirect needed.
/// Called by GoRouter on every navigation event.
String? authRedirect(WidgetRef ref, String location) {
  final authState = ref.read(authNotifierProvider);

  // Still determining auth state — don't redirect yet, avoid flicker.
  if (authState is AuthStateInitial || authState is AuthStateLoading) {
    return null;
  }

  final isAuthenticated = authState is AuthStateAuthenticated;
  final isPublic = publicRoutes.contains(location);
  final isOnboarding = onboardingRoutes.contains(location);

  // Not logged in trying to access a protected route → send to sign in.
  if (!isAuthenticated && !isPublic) {
    return '/signin';
  }

  // Logged in and trying to visit an auth screen (not onboarding) → send home.
  if (isAuthenticated && isPublic && !isOnboarding) {
    return '/home';
  }

  return null; // No redirect needed.
}

/// Provider that exposes whether the app has finished its initial auth check.
/// Use this to show a splash/loading screen instead of a blank flash.
final authReadyProvider = Provider<bool>((ref) {
  final state = ref.watch(authNotifierProvider);
  return state is! AuthStateInitial && state is! AuthStateLoading;
});
