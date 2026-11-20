import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:url_launcher/url_launcher.dart';

enum _SoundSetting {
  music('الموسيقى', MosaicIconKind.play),
  soundEffects('المؤثرات الصوتية', MosaicIconKind.hint),
  vibration('الاهتزاز', MosaicIconKind.moves);

  const _SoundSetting(this.label, this.icon);

  final String label;
  final MosaicIconKind icon;

  String get storageKey => 'settings.sound.$name';
}

final _soundSettingProvider = StreamProvider.autoDispose
    .family<bool, _SoundSetting>((ref, setting) async* {
      final db = await ref.watch(appDatabaseProvider.future);
      yield* db
          .watchMetadata(setting.storageKey)
          .map((value) => value != 'false');
    });

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _privacyUrl = String.fromEnvironment('PRIVACY_POLICY_URL');
  static const _termsUrl = String.fromEnvironment('TERMS_OF_USE_URL');

  final _saving = <_SoundSetting>{};
  bool _resetting = false;

  @override
  Widget build(BuildContext context) {
    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );
    final text = MosaicTheme.of(context).text;
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
            Text('الصوت', style: text.labelM),
            const SizedBox(height: MosaicSpacing.s8),
            for (final setting in _SoundSetting.values) _soundRow(setting),
            const SizedBox(height: MosaicSpacing.s24),
            Text('معلومات', style: text.labelM),
            const SizedBox(height: MosaicSpacing.s8),
            _legalRow('سياسة الخصوصية', MosaicIconKind.archive, _privacyUrl),
            const SizedBox(height: MosaicSpacing.s8),
            _legalRow('شروط الاستخدام', MosaicIconKind.flag, _termsUrl),
            if (kDebugMode) ...[
              const SizedBox(height: MosaicSpacing.s24),
              Text('المطور (تطوير فقط)', style: text.labelM),
              const SizedBox(height: MosaicSpacing.s8),
              MosaicRow(
                title: 'إعادة ضبط التقدم المحلي',
                showSubtitle: false,
                icon: MosaicIconKind.restart,
                onPressed: _resetting ? null : _confirmReset,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _soundRow(_SoundSetting setting) {
    final value = ref.watch(_soundSettingProvider(setting));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MosaicRow(
        title: setting.label,
        subtitle: value.hasError ? 'تعذّر تحميل الإعداد' : null,
        icon: setting.icon,
        trailing: MosaicRowTrailing.toggle,
        toggleValue: value.valueOrNull ?? true,
        onToggle: value.hasValue && !_saving.contains(setting)
            ? (enabled) => _saveSetting(setting, enabled)
            : null,
      ),
    );
  }

  Future<void> _saveSetting(_SoundSetting setting, bool enabled) async {
    setState(() => _saving.add(setting));
    try {
      final db = await ref.read(appDatabaseProvider.future);
      await db.upsertMetadata(setting.storageKey, enabled.toString());
    } catch (_) {
      if (mounted) _showMessage('تعذّر حفظ الإعداد. حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _saving.remove(setting));
    }
  }

  Widget _legalRow(String title, MosaicIconKind icon, String url) {
    final uri = Uri.tryParse(url);
    final available =
        uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
    return MosaicRow(
      title: title,
      subtitle: available ? null : 'غير متاح حالياً',
      icon: icon,
      onPressed: available ? () => _openLegalLink(uri) : null,
    );
  }

  Future<void> _openLegalLink(Uri uri) async {
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } catch (_) {
      // Some devices cannot open external links.
    }
    if (mounted) _showMessage('تعذّر فتح الرابط.');
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MosaicColors.paper,
        title: const Text('تأكيد إعادة الضبط'),
        content: const Text(
          'سيُحذف تقدم الرحلة والحكاية والمحاولة الحالية على هذا الجهاز.',
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
    if (confirmed != true || !mounted || _resetting) return;
    setState(() => _resetting = true);
    try {
      await ref.read(journeyControllerProvider.notifier).resetLocalJourney();
      if (!mounted) return;
      ref.invalidate(gameplayControllerProvider);
      ref.invalidate(currentPlayingLevelProvider);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.tutorial, (_) => false);
    } catch (_) {
      if (mounted) _showMessage('تعذّرت إعادة ضبط التقدم.');
    } finally {
      if (mounted) setState(() => _resetting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
