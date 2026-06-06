import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/core/widgets/splash_screen.dart';
import 'package:vibe_app/core/theme/app_theme.dart';

void main() {
  group('SplashScreen', () {
    Widget buildSplash() {
      return const MaterialApp(home: SplashScreen());
    }

    // ── renders ──────────────────────────────────────────────────────────────

    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('displays the Vibe wordmark text', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.text('Vibe'), findsOneWidget);
    });

    testWidgets('shows a CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // ── scaffold background ──────────────────────────────────────────────────

    testWidgets('Scaffold uses VibeColors.background color', (tester) async {
      await tester.pumpWidget(buildSplash());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(VibeColors.background));
    });

    // ── layout structure ─────────────────────────────────────────────────────

    testWidgets('uses a Center widget at the root of the body', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('contains a Column for vertical stacking', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('ShaderMask wraps the Vibe text', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    // ── text style ───────────────────────────────────────────────────────────

    testWidgets('Vibe text has fontSize 56', (tester) async {
      await tester.pumpWidget(buildSplash());

      final text = tester.widget<Text>(find.text('Vibe'));
      expect(text.style?.fontSize, equals(56.0));
    });

    testWidgets('Vibe text is bold', (tester) async {
      await tester.pumpWidget(buildSplash());

      final text = tester.widget<Text>(find.text('Vibe'));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });

    // ── spinner ───────────────────────────────────────────────────────────────

    testWidgets('spinner strokeWidth is 2.5', (tester) async {
      await tester.pumpWidget(buildSplash());

      final spinner = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(spinner.strokeWidth, equals(2.5));
    });
  });
}
