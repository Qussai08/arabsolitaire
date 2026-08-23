using TMPro;
using UnityEngine;

namespace ArabSolitaire.Cards
{
    /// <summary>
    /// Arabic typography helper. TMP shapes isolated Arabic letters; connected shaping
    /// requires an approved shaping plugin for production — prototype uses RTL + Arabic font.
    /// </summary>
    public static class ArabicTypography
    {
        private static TMP_FontAsset _font;

        public static bool ContainsArabic(string value)
        {
            foreach (var c in value)
            {
                if (c is >= '\u0600' and <= '\u06FF')
                {
                    return true;
                }
            }

            return false;
        }

        public static void ApplyTo(TMP_Text text)
        {
            if (text == null)
            {
                return;
            }

            EnsureFontLoaded();
            if (_font != null)
            {
                text.font = _font;
            }

            if (ContainsArabic(text.text))
            {
                text.isRightToLeftText = true;
            }
        }

        private static void EnsureFontLoaded()
        {
            if (_font != null)
            {
                return;
            }

            _font = Resources.Load<TMP_FontAsset>("Arabic/NotoNaskhArabic SDF");
        }
    }
}
