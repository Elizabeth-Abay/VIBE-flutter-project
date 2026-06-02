import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/domain/entities/auth_state.dart';

/// Routes anyone can visit without being logged in.
const _publicRoutes = {
  '/splash',
  '/start-screen',
  '/welcome1',
  '/welcome2',
  '/welcome3',
  '/welcome4',
  '/sign-in',
  '/enter-user-info-first',
  '/sign-up-email-enter',
  '/verify',
};

/// Onboarding routes: logged-in users are NOT bounced off these
/// (they might visit welcome screens before reaching /home).
const _onboardingRoutes = {
  '/splash',
  '/start-screen',
  '/welcome1',
  '/welcome2',
  '/welcome3',
  '/welcome4',
  '/interest-selection',
};

/// Returns a redirect path, or null if no redirect is needed.
/// Called by GoRouter on every navigation event.
String? authRedirect(WidgetRef ref, String location) {
  final authState = ref.read(authNotifierProvider);

  // Still checking token → don't redirect (avoids splash flicker).
  if (authState is AuthStateInitial || authState is AuthStateLoading) {
    return null;
  }

  final isAuthenticated = authState is AuthStateAuthenticated;
  final isPublic = _publicRoutes.contains(location);
  final isOnboarding = _onboardingRoutes.contains(location);

  // Not logged in and trying to reach a protected screen.
  if (!isAuthenticated && !isPublic) return '/sign-in';

  // Logged in but on a pure-auth screen (not onboarding).
  if (isAuthenticated && isPublic && !isOnboarding) return '/home';

  return null;
}

/// True once the initial auth check (token lookup) has finished.
/// Use this in the splash route to decide where to redirect.
final authReadyProvider = Provider<bool>((ref) {
  final state = ref.watch(authNotifierProvider);
  return state is! AuthStateInitial && state is! AuthStateLoading;
});
