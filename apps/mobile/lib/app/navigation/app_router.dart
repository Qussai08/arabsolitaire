import 'package:flutter/material.dart';
import 'package:mobile/features/bootstrap/presentation/bootstrap_screen.dart';
import 'package:mobile/features/gameplay/presentation/screens/gameplay_screen.dart';
import 'package:mobile/features/journey/presentation/screens/home_screen.dart';
import 'package:mobile/features/journey/presentation/screens/journey_screen.dart';
import 'package:mobile/features/journey/presentation/screens/settings_screen.dart';
import 'package:mobile/features/journey/presentation/screens/story_archive_screen.dart';
import 'package:mobile/features/journey/presentation/screens/tutorial_screen.dart';

abstract final class AppRoutes {
  static const bootstrap = '/';
  static const home = '/home';
  static const journey = '/journey';
  static const gameplay = '/gameplay';
  static const tutorial = '/tutorial';
  static const settings = '/settings';
  static const storyArchive = '/story-archive';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.gameplay:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const GameplayScreen(),
        );
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case AppRoutes.journey:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const JourneyScreen(),
        );
      case AppRoutes.tutorial:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const TutorialScreen(),
        );
      case AppRoutes.settings:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SettingsScreen(),
        );
      case AppRoutes.storyArchive:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const StoryArchiveScreen(),
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
