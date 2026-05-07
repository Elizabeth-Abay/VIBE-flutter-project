import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/notification_part/presentation/screens/notification_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/notifications',
  routes: [
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
  ],
);
