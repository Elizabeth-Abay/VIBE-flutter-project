import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Unfocuses fields then navigates using a captured [GoRouter] so a disposed
/// [BuildContext] is never used after async delays.
void unfocusAndNavigate(
  BuildContext context,
  void Function(GoRouter router) action,
) {
  if (!context.mounted) return;
  FocusManager.instance.primaryFocus?.unfocus();
  final router = GoRouter.of(context);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future<void>.delayed(const Duration(milliseconds: 50), () {
      action(router);
    });
  });
}
