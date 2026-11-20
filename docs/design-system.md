# فسيفساء المعاني — design system

Visual foundation for سوليتير العرب. Screens are not rebuilt here; this is the token and component layer they should be built from.

Figma: [فسيفساء المعاني](https://www.figma.com/design/7ScCtdjsqnZz7pyIHP2nUD)

Source export (do not edit by hand): [`apps/mobile/design/tokens.json`](../apps/mobile/design/tokens.json). Dart constants in `apps/mobile/lib/design_system/` are locked to that file by `apps/mobile/test/design_system/mosaic_tokens_test.dart`.

## Theme

`SolitaireAlArabApp` uses `MosaicThemeData.light()` as `ThemeData`.

The shell previously had no shared theme module. `MaterialApp` used a generic Material seed, and the journey and gameplay screens paint their own navy (`#0D1B2A`) and gold (`#D4A017`) with `fontFamily: 'Cairo'`. Cairo is not bundled. Those screens are left as they are so this change does not restyle the current product loop. New UI should use the mosaic widgets and `Theme.of(context)` instead of new hardcoded colors.

What the theme sets:

- `ColorScheme.primary` is terracotta (the primary CTA). Secondary is emerald. Surface and the scaffold are limestone.
- `textTheme` maps the eleven Figma styles. Display styles are Reem Kufi; everything else is Readex Pro.
- `Theme.of(context).extension<MosaicTheme>()` (or `MosaicTheme.of(context)`) exposes those styles by name: `text.cardWord`, `text.cardClue`, `text.numberHud`, and the rest.
- Radii, spacing, shadows, borders, and sizes stay on `MosaicRadii`, `MosaicSpacing`, `MosaicShadows`, `MosaicBorder`, and `MosaicSizes`. There is one Light mode in the export, so they are constants.

```dart
import 'package:mobile/design_system/design_system.dart';

final text = MosaicTheme.of(context).text;
Text('عنوان', style: text.displayL);
```

`MosaicSpacing.gutterForWidth` returns 16 (phone), 24 (width ≥ 768), or 12 (width ≤ 360).

## Fonts

Reem Kufi (700) and Readex Pro (400, 500, 600, 700) are bundled under `apps/mobile/assets/fonts/`. They are static instances of the Google Fonts variable files, licensed under the SIL Open Font License (see the `OFL-*.txt` files next to them).

They are not loaded with the `google_fonts` package. The main journey has to keep working offline, and widget tests need the families without a network fetch.

## Components

Import `package:mobile/design_system/design_system.dart`.

| Widget | States | Non-color cue |
|---|---|---|
| `MosaicCard` | face-down, word, clue, selected, valid target, invalid, completed, disabled | Pattern, the word, the «مجموعة» kicker plus count, or a badge glyph (star, +, ✕, ✓). Disabled is the word face at opacity 0.45. |
| `MosaicSlot` | empty, active, drop target, completed | Dashed outline and instruction, progress chip `٢/٤` plus pips, a thicker dashed outline with one extra pip, or the completed title. |
| `MosaicButton` | primary, secondary, reward, ghost, danger | Fill versus outline versus text-only, and the icon (forward, back, coin). |
| `MosaicHudChip` | coin, hint, flame | The icon identifies the stat. `MosaicHudChip.count` formats the number. |
| `MosaicToolButton` | enabled, disabled, badge | Label under the icon. A count badge, including `٠`, is the hint inventory. Disabled is opacity 0.45. |
| `MosaicShiboubBubble` | line | Speaker name «شيبوب» plus the portrait already inside the bubble. |
| `MosaicToast` | info, success, error, hint | Icon in the badge (restart, check, close, bulb). |
| `MosaicRow` | chevron, toggle, value | Chevron navigates. The toggle knob sits at the end when on and at the start when off. |
| `MosaicHeader` | back + title | Back pill on the start, with the back arrow and the label. |
| `MosaicMedallion` | emerald, saffron, terracotta, lapis, danger | Icon inside the dashed disc. |
| `MosaicLevelNode` | done, current, locked | Caption «✓ مكتمل» / «الحالي», or a lock with «مقفل». Current also draws the saffron ring and glow. |
| `MosaicIcon` / `MosaicIconButton` | line icons | Directional back/forward follow RTL. |

Cards are 72×96 on every window size. The badge sits on the **start** corner, which is the top-right in RTL, as in the component sheet. Pips fill from the right: pass `filled` / `total` and the first pips are the filled ones.

`MosaicButton` also implements the interaction states that are specified but not drawn: pressed scales to 0.97 and drops the shadow, disabled is opacity 0.45 with no shadow, and keyboard focus draws a 2px saffron ring, 2px outside the button. A null `onPressed` is disabled.

In RTL, a forward icon sits on the end (left, pointing left) and a back icon sits on the start (right, pointing right). The coin stays on the start.

`MosaicCard.countLabel` is display copy (`٤ كلمات`). The widget does not pluralize; pass the exact string.

Illustrations:

- `MosaicIllustrations.heroShiboub`
- `MosaicIllustrations.cairoChapter`
- `MosaicIllustrations.win`
- `MosaicIllustrations.dailyGift`
- `MosaicIllustrations.shiboubPortrait`

`MosaicArchImage` clips an illustration with a semicircular top and a 14px bottom radius.

Toast, row, header, tool button, Shiboub bubble, medallion, and level node live in the same module. Measurements follow page **01 · الهوية والمكوّنات**.

## RTL, digits, and the middle dot

The app shell is already `Directionality` RTL and `Locale('ar')`. Rows in these widgets are normal rows; do not reverse children again.

```dart
ArabicDigits.format(15000); // ١٥٬٠٠٠
ArabicDigits.progress(2, 4); // isolated ٢/٤
ArabicDigits.dashJoin(['اليوم ٤', '+٥٠']); // اليوم ٤ — +٥٠
ArabicDigits.joinWords(['بحر', 'موج']); // بحر · موج
```

`ArabicDigits.format` writes Arabic-Indic digits and uses `٬` (U+066C) for thousands. `progress` wraps the fraction in an LTR isolate so the slash does not flip.

Do not put `·` next to Arabic-Indic digits (`٣ · ٠` is unreadable because ٠ looks like a dot). Use `dashJoin` for counts and `joinWords` only between words. `ArabicDigits.hasMiddleDotBesideDigits` checks the rule.
