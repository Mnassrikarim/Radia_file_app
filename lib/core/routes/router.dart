// lib/core/routes/router.dart

import 'package:app_v1/core/routes/routes.dart';
import 'package:app_v1/features/auth/presentation/pages/register_page.dart';
import 'package:app_v1/features/home/presentation/pages/home_page.dart';
import 'package:app_v1/features/auth/presentation/pages/login_page.dart';
import 'package:app_v1/features/home/presentation/pages/not_found_page.dart';
import 'package:app_v1/features/home/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  // Prevent instantiation
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) => NotFoundPage(routeName: settings.name),
        );
    }
  }
}
