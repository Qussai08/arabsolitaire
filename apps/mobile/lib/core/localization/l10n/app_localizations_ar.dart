// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سوليتير العرب';

  @override
  String get appSubtitle => 'أسطورة المعاني';

  @override
  String get bootstrapReady => 'جاهز للتطوير';

  @override
  String get bootstrapError => 'تعذر إكمال التهيئة';

  @override
  String environmentLabel(String env) {
    return 'البيئة: $env';
  }
}
