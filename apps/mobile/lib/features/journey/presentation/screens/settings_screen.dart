import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _SectionHeader(label: 'الصوت'),
          _SwitchTile(label: 'الموسيقى', value: true, onChanged: (_) {}),
          _SwitchTile(
            label: 'المؤثرات الصوتية',
            value: true,
            onChanged: (_) {},
          ),
          _SwitchTile(label: 'الاهتزاز', value: true, onChanged: (_) {}),
          const SizedBox(height: 24),
          const _SectionHeader(label: 'معلومات'),
          _InfoTile(label: 'سياسة الخصوصية', onTap: () {}),
          _InfoTile(label: 'شروط الاستخدام', onTap: () {}),
          const SizedBox(height: 24),
          const _SectionHeader(label: 'المطور (تطوير فقط)'),
          _DangerTile(
            label: 'إعادة ضبط التقدم المحلي',
            onTap: () => _confirmReset(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162033),
        title: const Text(
          'تأكيد إعادة الضبط',
          style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
        content: const Text(
          'هل أنت متأكد؟ سيتم حذف جميع بيانات التقدم المحلية.',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Color(0xFFD4A017), fontFamily: 'Cairo'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'إعادة ضبط',
              style: TextStyle(color: Colors.redAccent, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && context.mounted) {
      // Reset journey state
      final journeyState = ref.read(journeyControllerProvider);
      if (journeyState is JourneyReady) {
        await ref.read(journeyControllerProvider.notifier).completeOnboarding();
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontFamily: 'Cairo',
          fontSize: 13,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SwitchTile extends StatefulWidget {
  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<_SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<_SwitchTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF162033),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(
          widget.label,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
        value: _value,
        activeThumbColor: const Color(0xFFD4A017),
        onChanged: (v) {
          setState(() => _value = v);
          widget.onChanged(v);
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF162033),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          label,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
        trailing: const Icon(Icons.chevron_left, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }
}

class _DangerTile extends StatelessWidget {
  const _DangerTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        title: Text(
          label,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.redAccent, fontFamily: 'Cairo'),
        ),
        trailing: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.redAccent,
        ),
        onTap: onTap,
      ),
    );
  }
}
