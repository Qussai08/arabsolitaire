// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Solitaire Al-Arab';

  @override
  String get appSubtitle => 'The Legend of Meanings';

  @override
  String get bootstrapReady => 'Ready for development';

  @override
  String get bootstrapError => 'Bootstrap could not complete';

  @override
  String environmentLabel(String env) {
    return 'Environment: $env';
  }
}
