import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  Widget build(AuthTextField widget) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: widget,
        ),
      ),
    );
  }

  group('AuthTextField', () {
    // ── renders ──────────────────────────────────────────────────────────────

    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(build(const AuthTextField(label: 'Email')));
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('displays the given label', (tester) async {
      await tester.pumpWidget(build(const AuthTextField(label: 'Email')));
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('displays hint text when provided', (tester) async {
      await tester.pumpWidget(build(
        const AuthTextField(label: 'Email', hintText: 'Enter your email'),
      ));
      expect(find.text('Enter your email'), findsOneWidget);
    });

    // ── error / success text ─────────────────────────────────────────────────

    testWidgets('shows error text in red when errorText is provided',
        (tester) async {
      await tester.pumpWidget(build(
        const AuthTextField(label: 'Email', errorText: 'Invalid email'),
      ));
      final errorWidget = tester.widget<Text>(find.text('Invalid email'));
      expect(errorWidget.style?.color, equals(Colors.red));
    });

    testWidgets('shows success text in green when successText is provided',
        (tester) async {
      await tester.pumpWidget(build(
        const AuthTextField(label: 'Email', successText: 'Email is available'),
      ));
      final successWidget =
          tester.widget<Text>(find.text('Email is available'));
      expect(successWidget.style?.color, equals(Colors.green));
    });

    testWidgets('does not show error text when errorText is null',
        (tester) async {
      await tester.pumpWidget(build(const AuthTextField(label: 'Email')));
      expect(find.text('Invalid email'), findsNothing);
    });

    // ── password field ───────────────────────────────────────────────────────

    testWidgets('password field shows visibility toggle icon', (tester) async {
      await tester.pumpWidget(
          build(const AuthTextField(label: 'Password', isPassword: true)));
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('tapping visibility icon toggles icon', (tester) async {
      await tester.pumpWidget(
          build(const AuthTextField(label: 'Password', isPassword: true)));

      // Initially shows visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // After tap shows visibility_off_outlined
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('non-password field has no visibility toggle', (tester) async {
      await tester.pumpWidget(build(const AuthTextField(label: 'Email')));
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    });

    // ── controller ───────────────────────────────────────────────────────────

    testWidgets('accepts typed text via controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(build(
        AuthTextField(label: 'Email', controller: controller),
      ));

      await tester.enterText(find.byType(TextField), 'yada@vibe.io');
      expect(controller.text, equals('yada@vibe.io'));
    });

    // ── readOnly ─────────────────────────────────────────────────────────────

    testWidgets('readOnly field does not allow input', (tester) async {
      final controller = TextEditingController(text: 'locked@vibe.io');
      await tester.pumpWidget(build(
        AuthTextField(
            label: 'Email', controller: controller, readOnly: true),
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    // ── label style ──────────────────────────────────────────────────────────

    testWidgets('label text is bold with fontSize 14', (tester) async {
      await tester.pumpWidget(build(const AuthTextField(label: 'Username')));

      final label = tester.widget<Text>(find.text('Username'));
      expect(label.style?.fontWeight, equals(FontWeight.bold));
      expect(label.style?.fontSize, equals(14.0));
    });
  });
}
