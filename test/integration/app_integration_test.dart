// Integration tests exercise the full widget tree with Riverpod wired in.
// We use ProviderScope overrides to avoid real network/DB calls.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Core app pieces
import 'package:vibe_app/core/widgets/splash_screen.dart';
import 'package:vibe_app/core/widgets/custom_bottom_nav.dart';
import 'package:vibe_app/core/theme/app_theme.dart';

// Auth providers & state
import 'package:vibe_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:vibe_app/features/auth/domain/entities/auth_state.dart';

// Posts providers
import 'package:vibe_app/features/posts/presentation/providers/post_provider.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

/// A fake AuthNotifier that starts in a known state and never calls storage.
class _FakeAuthNotifier extends AuthNotifier {
  final AuthState _initial;
  _FakeAuthNotifier(this._initial);

  @override
  AuthState build() => _initial;
}

ProviderContainer _makeContainer({AuthState? authState}) {
  return ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(
        () => _FakeAuthNotifier(
          authState ?? const AuthStateUnauthenticated(),
        ),
      ),
    ],
  );
}

// Wrap any widget with ProviderScope using our container
Widget _wrap(Widget child, {ProviderContainer? container}) {
  return UncontrolledProviderScope(
    container: container ?? _makeContainer(),
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: child,
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('Integration — SplashScreen + AuthState', () {
    testWidgets('SplashScreen renders inside ProviderScope', (tester) async {
      await tester.pumpWidget(_wrap(const SplashScreen()));
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('Vibe'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'Container with AuthStateUnauthenticated reports isAuthenticated = false',
        (tester) async {
      final container = _makeContainer(authState: const AuthStateUnauthenticated());
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      expect(notifier.isAuthenticated, isFalse);
    });

    testWidgets(
        'Container with AuthStateAuthenticated reports isAuthenticated = true',
        (tester) async {
      // We build a container that starts authenticated
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(
            () => _FakeAuthNotifier(const AuthStateAuthenticated()),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      expect(notifier.isAuthenticated, isTrue);
    });
  });

  group('Integration — CustomBottomNavBar inside ProviderScope', () {
    testWidgets('nav bar renders all 5 tabs within provider scope',
        (tester) async {
      int selectedTab = 0;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: const SizedBox.shrink(),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: selectedTab,
                onTap: (i) => setState(() => selectedTab = i),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('tapping a nav tab updates the selected index', (tester) async {
      int selectedTab = 0;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: const SizedBox.shrink(),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: selectedTab,
                onTap: (i) => setState(() => selectedTab = i),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Profile'));
      await tester.pump();

      expect(selectedTab, equals(4));
    });
  });

  group('Integration — Riverpod category + UI', () {
    testWidgets('CategoryNotifier default is "books" inside ProviderScope',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(selectedCategoryProvider), equals('books'));
    });

    testWidgets(
        'Updating category inside ProviderScope triggers listener in widget',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      String? latestCategory;
      container.listen<String>(
        selectedCategoryProvider,
        (_, next) => latestCategory = next,
      );

      container
          .read(selectedCategoryProvider.notifier)
          .updateCategory('music');

      expect(latestCategory, equals('music'));
    });
  });

  group('Integration — Theme applied correctly', () {
    testWidgets('app uses dark theme background color', (tester) async {
      await tester.pumpWidget(_wrap(const SplashScreen()));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(VibeColors.background));
    });
  });

  group('Integration — AuthState sealed coverage', () {
    test('all 5 AuthState variants are reachable', () {
      final states = <AuthState>[
        const AuthStateInitial(),
        const AuthStateLoading(),
        const AuthStateAuthenticated(),
        const AuthStateUnauthenticated(),
        const AuthStateError('test error'),
      ];

      expect(states.length, equals(5));

      for (final s in states) {
        final label = switch (s) {
          AuthStateInitial() => 'initial',
          AuthStateLoading() => 'loading',
          AuthStateAuthenticated() => 'auth',
          AuthStateUnauthenticated() => 'unauth',
          AuthStateError(:final message) => 'error:$message',
        };
        expect(label, isNotEmpty);
      }
    });
  });
}
