/// Arabic-Indic digits for UI copy (٠١٢٣٤٥٦٧٨٩).
///
/// The component spec asks for `Intl.NumberFormat('ar-EG')`. Dart's `intl`
/// data for `ar_EG` follows CLDR, which numbers Egypt in Latin digits.
/// This helper maps digits itself and uses U+066C as the thousands separator,
/// which is the Arabic-Indic result the spec describes
/// (`ar-EG-u-nu-arab`): `15000` → `١٥٬٠٠٠`.
abstract final class ArabicDigits {
  static const _glyphs = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  /// Thousands separator `٬` (U+066C).
  static const thousandsSeparator = '\u066C';

  /// Decimal separator `٫` (U+066B).
  static const decimalSeparator = '\u066B';

  static final RegExp _dotBesideDigits = RegExp(
    '[\\u0660-\\u0669]\\s*\u00B7|\u00B7\\s*[\\u0660-\\u0669]',
  );

  /// Formats [value] with Arabic-Indic digits.
  ///
  /// Whole numbers are grouped in thousands (`١٥٬٠٠٠`). A fractional value
  /// keeps its decimal part behind [decimalSeparator].
  static String format(num value) {
    final negative = value < 0;
    final absolute = value.abs();
    final body = _formatAbsolute(absolute);
    return negative ? '-$body' : body;
  }

  /// `current/total` as an isolated LTR run, e.g. `٢/٤`.
  ///
  /// Arabic-Indic digits are bidirectional class AN, so a first-strong
  /// isolate does not pin the slash. An explicit LTR isolate (U+2066 … U+2069)
  /// keeps the logical order from flipping inside RTL text.
  static String progress(int current, int total) {
    return isolateLtr('${format(current)}/${format(total)}');
  }

  static String isolateLtr(String value) => '\u2066$value\u2069';

  /// Joins fragments with ` — ` (em dash).
  ///
  /// Use this whenever a fragment contains Arabic-Indic digits.
  /// A middle dot directly beside ٠ is unreadable (`٣ · ٠`).
  static String dashJoin(List<String> parts) => parts.join(' — ');

  /// Joins Arabic words with a middle dot. Allowed only between words,
  /// never beside digits. See [hasMiddleDotBesideDigits].
  static String joinWords(List<String> words) => words.join(' · ');

  static bool hasMiddleDotBesideDigits(String input) {
    return _dotBesideDigits.hasMatch(input);
  }

  static String _formatAbsolute(num value) {
    if (value is int || value == value.roundToDouble()) {
      return _formatInt(value.round());
    }
    final raw = value.toString();
    if (raw.contains('e') || raw.contains('E')) {
      return _formatInt(value.round());
    }
    final pieces = raw.split('.');
    final head = _formatInt(int.parse(pieces[0]));
    if (pieces.length == 1 || pieces[1].isEmpty) {
      return head;
    }
    return '$head$decimalSeparator${_mapDigits(pieces[1])}';
  }

  static String _formatInt(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      if (i > 0 && remaining % 3 == 0) {
        buffer.write(thousandsSeparator);
      }
      buffer.write(_glyphs[digits.codeUnitAt(i) - 0x30]);
    }
    return buffer.toString();
  }

  static String _mapDigits(String asciiDigits) {
    final buffer = StringBuffer();
    for (final unit in asciiDigits.codeUnits) {
      buffer.write(_glyphs[unit - 0x30]);
    }
    return buffer.toString();
  }
}
