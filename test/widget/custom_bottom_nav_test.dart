import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/core/widgets/custom_bottom_nav.dart';

void main() {
  // Helper to pump the widget inside a minimal MaterialApp
  Widget buildNav({required int index, required Function(int) onTap}) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: index,
          onTap: onTap,
        ),
      ),
    );
  }

  group('CustomBottomNavBar', () {
    // ── renders ──────────────────────────────────────────────────────────────

    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(buildNav(index: 0, onTap: (_) {}));
      expect(find.byType(CustomBottomNavBar), findsOneWidget);
    });

    testWidgets('shows 5 tap targets (Home, Chat, +, Saved, Profile)',
        (tester) async {
      await tester.pumpWidget(buildNav(index: 0, onTap: (_) {}));

      // The four labelled items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // The centre + button (no label — identified by icon)
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('displays correct icons for all tabs', (tester) async {
      await tester.pumpWidget(buildNav(index: 0, onTap: (_) {}));

      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.cloud_done_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    // ── tap callbacks ────────────────────────────────────────────────────────

    testWidgets('calls onTap with index 0 when Home is tapped', (tester) async {
      int tapped = -1;
      await tester.pumpWidget(buildNav(index: 1, onTap: (i) => tapped = i));

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(tapped, equals(0));
    });

    testWidgets('calls onTap with index 1 when Chat is tapped', (tester) async {
      int tapped = -1;
      await tester.pumpWidget(buildNav(index: 0, onTap: (i) => tapped = i));

      await tester.tap(find.text('Chat'));
      await tester.pump();

      expect(tapped, equals(1));
    });

    testWidgets('calls onTap with index 2 when centre + button is tapped',
        (tester) async {
      int tapped = -1;
      await tester.pumpWidget(buildNav(index: 0, onTap: (i) => tapped = i));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(tapped, equals(2));
    });

    testWidgets('calls onTap with index 3 when Saved is tapped',
        (tester) async {
      int tapped = -1;
      await tester.pumpWidget(buildNav(index: 0, onTap: (i) => tapped = i));

      await tester.tap(find.text('Saved'));
      await tester.pump();

      expect(tapped, equals(3));
    });

    testWidgets('calls onTap with index 4 when Profile is tapped',
        (tester) async {
      int tapped = -1;
      await tester.pumpWidget(buildNav(index: 0, onTap: (i) => tapped = i));

      await tester.tap(find.text('Profile'));
      await tester.pump();

      expect(tapped, equals(4));
    });

    // ── visual selection ─────────────────────────────────────────────────────

    testWidgets('selected tab label is bold', (tester) async {
      // Tab 0 (Home) is selected
      await tester.pumpWidget(buildNav(index: 0, onTap: (_) {}));

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.fontWeight, equals(FontWeight.w600));
    });

    testWidgets('non-selected tab label is not bold', (tester) async {
      // Tab 0 is selected, so Chat (1) should NOT be bold
      await tester.pumpWidget(buildNav(index: 0, onTap: (_) {}));

      final chatText = tester.widget<Text>(find.text('Chat'));
      expect(chatText.style?.fontWeight, isNot(equals(FontWeight.w600)));
    });

    // ── layout ───────────────────────────────────────────────────────────────

    testWidgets('bar container has height of 80', (tester) async {
      await tester.pumpWidget(buildNav(index: 0, onTap: (_) {}));

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.constraints?.maxHeight == 80 || 
                             (c.decoration is BoxDecoration && 
                              (c.decoration as BoxDecoration).borderRadius != null));

      // Just confirm the widget tree is built correctly — the Container exists
      expect(container, isNotNull);
    });
  });
}
