import 'package:flutter/material.dart';
import 'package:mobile/core/localization/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/level_generator.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';

/// Placeholder Home after bootstrap — confirms package wiring + RTL shell.
class HomePlaceholderScreen extends ConsumerWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    final solver = PlaceholderSolver();
    final generator = PlaceholderLevelGenerator(solver: solver);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.appSubtitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              Text(l10n.bootstrapReady),
              const SizedBox(height: 8),
              Text(l10n.environmentLabel(config.environment.label)),
              const SizedBox(height: 24),
              const Text('game_engine: $gameEnginePackageVersion'),
              const Text('game_solver: $gameSolverPackageVersion'),
              const Text('level_generator: $levelGeneratorPackageVersion'),
              Text('solver↔engine: ${solver.enginePackageVersion}'),
              Text('generator↔engine: ${generator.enginePackageVersion}'),
            ],
          ),
        ),
      ),
    );
  }
}
