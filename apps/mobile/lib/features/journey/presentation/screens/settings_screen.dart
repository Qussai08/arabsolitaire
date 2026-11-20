import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );
    return Scaffold(
      backgroundColor: MosaicColors.limestone,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 24),
          children: [
            MosaicHeader(
              title: 'الإعدادات',
              showSubtitle: false,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Text('الصوت', style: MosaicTheme.of(context).text.labelM),
            const SizedBox(height: MosaicSpacing.s8),
            const _SwitchTile(label: 'الموسيقى', icon: MosaicIconKind.play),
            const _SwitchTile(
              label: 'المؤثرات الصوتية',
              icon: MosaicIconKind.hint,
            ),
            const _SwitchTile(label: 'الاهتزاز', icon: MosaicIconKind.moves),
            const SizedBox(height: MosaicSpacing.s24),
            Text('معلومات', style: MosaicTheme.of(context).text.labelM),
            const SizedBox(height: MosaicSpacing.s8),
            MosaicRow(
              title: 'سياسة الخصوصية',
              showSubtitle: false,
              icon: MosaicIconKind.archive,
              onPressed: () {},
            ),
            const SizedBox(height: MosaicSpacing.s8),
            MosaicRow(
              title: 'شروط الاستخدام',
              showSubtitle: false,
              icon: MosaicIconKind.flag,
              onPressed: () {},
            ),
            const SizedBox(height: MosaicSpacing.s24),
            Text(
              'المطور (تطوير فقط)',
              style: MosaicTheme.of(context).text.labelM,
            ),
            const SizedBox(height: MosaicSpacing.s8),
            MosaicRow(
              title: 'إعادة ضبط التقدم المحلي',
              showSubtitle: false,
              icon: MosaicIconKind.restart,
              onPressed: () => _confirmReset(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MosaicColors.paper,
        title: const Text('تأكيد إعادة الضبط'),
        content: const Text(
          'هل أنت متأكد؟ سيتم حذف جميع بيانات التقدم المحلية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'إعادة ضبط',
              style: TextStyle(color: MosaicColors.danger700),
            ),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      final journeyState = ref.read(journeyControllerProvider);
      if (journeyState is JourneyReady) {
        await ref.read(journeyControllerProvider.notifier).completeOnboarding();
      }
    }
  }
}

class _SwitchTile extends StatefulWidget {
  const _SwitchTile({required this.label, required this.icon});

  final String label;
  final MosaicIconKind icon;

  @override
  State<_SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<_SwitchTile> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MosaicRow(
        title: widget.label,
        showSubtitle: false,
        icon: widget.icon,
        trailing: MosaicRowTrailing.toggle,
        toggleValue: _value,
        onToggle: (value) => setState(() => _value = value),
      ),
    );
  }
}
