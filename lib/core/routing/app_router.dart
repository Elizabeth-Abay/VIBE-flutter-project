import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/profile_view_screen.dart';
import '../../features/auth/presentation/screens/edit_profile_screen.dart';
import '../../features/auth/presentation/screens/delete_account_screen.dart';
import '../../features/auth/presentation/screens/interest_selection_screen.dart';

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