import 'package:flutter/material.dart';
import 'package:mobile/features/bootstrap/presentation/bootstrap_screen.dart';
import 'package:mobile/features/bootstrap/presentation/home_placeholder_screen.dart';

abstract final class AppRoutes {
  static const bootstrap = '/';
  static const home = '/home';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomePlaceholderScreen(),
        );
      case AppRoutes.bootstrap:
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const BootstrapScreen(),
        );
    }
  }
}
