import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';

/// Support / diagnostics screen — shows non-sensitive version info.
///
/// Accessible from Settings. Safe to show in all environments.
/// Never exposes auth tokens, wallet balance, or personal data.
class DiagnosticsScreen extends ConsumerWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('معلومات التطبيق')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _DiagnosticsTile(label: 'الإصدار', value: config.appVersion),
            _DiagnosticsTile(label: 'رقم البناء', value: config.buildNumber),
            _DiagnosticsTile(
              label: 'البيئة',
              value: config.environment.label,
            ),
            _DiagnosticsTile(
              label: 'إصدار قواعد اللعبة',
              value: config.rulesVersion.toString(),
            ),
            _DiagnosticsTile(
              label: 'إصدار المحلّل',
              value: config.solverVersion,
            ),
            _DiagnosticsTile(
              label: 'إصدار المولّد',
              value: config.generatorVersion,
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagnosticsTile extends StatelessWidget {
  const _DiagnosticsTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
