import 'package:flutter/material.dart';
import 'package:mobile/core/localization/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/app/bootstrap/bootstrap_controller.dart';
import 'package:mobile/app/navigation/app_router.dart';

/// Technical startup shell — Arabic-first, no gameplay.
class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    final bootstrap = ref.watch(bootstrapControllerProvider);

    ref.listen(bootstrapControllerProvider, (previous, next) {
      next.whenData((state) {
        if (state.status == BootstrapStatus.ready) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.appSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.environmentLabel(config.environment.label),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              bootstrap.when(
                data: (state) => switch (state.status) {
                  BootstrapStatus.initializing => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  BootstrapStatus.ready => Text(
                    l10n.bootstrapReady,
                    textAlign: TextAlign.center,
                  ),
                  BootstrapStatus.recoverableError ||
                  BootstrapStatus.fatalError => Text(
                    l10n.bootstrapError,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text(
                  l10n.bootstrapError,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
