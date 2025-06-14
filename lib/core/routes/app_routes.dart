import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplet/presentation/screens/auth/login_screen.dart';
import 'package:zaplet/presentation/screens/auth/register_screen.dart';
import 'package:zaplet/presentation/screens/base_screen.dart';
import 'package:zaplet/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:zaplet/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String base = '/base';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: base,
        builder: (context, state) => const BaseScreen(),
      ),
    ],
  );
} 