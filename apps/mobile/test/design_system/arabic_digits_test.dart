import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/design_system/arabic_digits.dart';

void main() {
  test('formats Arabic-Indic digits and thousands', () {
    expect(ArabicDigits.format(0), '٠');
    expect(ArabicDigits.format(4), '٤');
    expect(ArabicDigits.format(30), '٣٠');
    expect(ArabicDigits.format(100), '١٠٠');
    expect(ArabicDigits.format(1000), '١٬٠٠٠');
    expect(ArabicDigits.format(15000), '١٥٬٠٠٠');
    expect(ArabicDigits.format(-3), '-٣');
    expect(ArabicDigits.format(1.5), '١٫٥');
  });

  test('progress is an isolated run and does not use a middle dot', () {
    final progress = ArabicDigits.progress(2, 4);
    expect(progress, '\u2066٢/٤\u2069');
    expect(ArabicDigits.hasMiddleDotBesideDigits(progress), isFalse);

    final line = ArabicDigits.dashJoin(['اليوم ٤', '+٥٠']);
    expect(line, 'اليوم ٤ — +٥٠');
    expect(ArabicDigits.hasMiddleDotBesideDigits(line), isFalse);
    expect(ArabicDigits.hasMiddleDotBesideDigits('٣ · ٠'), isTrue);
    expect(ArabicDigits.hasMiddleDotBesideDigits('بحر · موج'), isFalse);
    expect(ArabicDigits.joinWords(['بحر', 'موج']), 'بحر · موج');
  });
}
