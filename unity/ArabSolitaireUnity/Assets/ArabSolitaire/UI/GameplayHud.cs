using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Cards;
using ArabSolitaire.Gameplay;
using TMPro;
using RTLTMPro;
using UnityEngine;
using UnityEngine.UI;

namespace ArabSolitaire.UI
{
    public sealed class GameplayHud : MonoBehaviour
    {
        private static readonly Color HeaderColor = new Color(0.10f, 0.07f, 0.15f, 0.94f);
        private static readonly Color PrimaryPanelColor = new Color(0.16f, 0.10f, 0.18f, 0.96f);
        private static readonly Color DeveloperPanelColor = new Color(0.09f, 0.08f, 0.12f, 0.88f);
        private static readonly Color GoldColor = new Color(0.96f, 0.76f, 0.32f, 1f);
        private static readonly Color CreamColor = new Color(1f, 0.95f, 0.84f, 1f);
        private static readonly Color AccentColor = new Color(0.50f, 0.16f, 0.34f, 1f);
        private static readonly Color SecondaryButtonColor = new Color(0.25f, 0.18f, 0.31f, 1f);
        private static readonly Color DangerColor = new Color(0.48f, 0.15f, 0.18f, 1f);

        [SerializeField] private TMP_Text movesLabel;
        [SerializeField] private TMP_Text streakLabel;
        [SerializeField] private TMP_Text statusLabel;
        [SerializeField] private TMP_Text titleLabel;
        [SerializeField] private Button hintButton;
        [SerializeField] private Button undoButton;
        [SerializeField] private Button pauseButton;
        [SerializeField] private Button exitButton;
        [SerializeField] private Button stockAdvanceButton;
        [SerializeField] private Button stockRestoreButton;
        [SerializeField] private Button winDemoButton;
        [SerializeField] private Button disconnectButton;
        [SerializeField] private Button reconnectButton;
        [SerializeField] private GameObject winOverlay;
        [SerializeField] private GameObject outOfMovesOverlay;
        [SerializeField] private RectTransform safeAreaRoot;

        private GameplaySessionController _session;

        public int MovesRemaining { get; private set; } = 30;

        public void Bind(GameplaySessionController session, MockBridgeTransport transport = null)
        {
            _session = session;
            ApplySafeArea();
            SetMovesRemaining(MovesRemaining);
            SetStreak(0);
            if (titleLabel != null)
            {
                titleLabel.text = "ألوان أساسية";
                ArabicTypography.ApplyTo(titleLabel);
            }

            WireButtons();
        }

        public void SetMovesRemaining(int value)
        {
            MovesRemaining = value;
            if (movesLabel != null)
            {
                movesLabel.text = $"الحركات: {MovesRemaining}";
                ArabicTypography.ApplyTo(movesLabel);
            }
        }

        public void SetStreak(int value)
        {
            if (streakLabel != null)
            {
                streakLabel.text = value > 0 ? $"سلسلة: {value}" : "سلسلة: —";
                ArabicTypography.ApplyTo(streakLabel);
            }
        }

        public void SetBridgeWait(bool waiting)
        {
            if (statusLabel != null)
            {
                statusLabel.text = waiting ? "… انتظار" : string.Empty;
                ArabicTypography.ApplyTo(statusLabel);
            }
        }

        public void ShowConnectionError(bool visible)
        {
            if (statusLabel != null)
            {
                statusLabel.text = visible ? "انقطع الاتصال" : string.Empty;
                ArabicTypography.ApplyTo(statusLabel);
            }
        }

        public void ShowRejectFeedback(string reason)
        {
            if (statusLabel != null)
            {
                statusLabel.text = string.IsNullOrEmpty(reason) ? "حركة مرفوضة" : $"مرفوض: {reason}";
                ArabicTypography.ApplyTo(statusLabel);
            }
        }

        public void ShowHintFeedback()
        {
            if (statusLabel != null)
            {
                statusLabel.text = "تلميح";
                ArabicTypography.ApplyTo(statusLabel);
            }
        }

        public void ShowWinOverlay(bool visible)
        {
            if (winOverlay != null)
            {
                winOverlay.SetActive(visible);
            }
        }

        public void ShowOutOfMovesOverlay(bool visible)
        {
            if (outOfMovesOverlay != null)
            {
                outOfMovesOverlay.SetActive(visible);
            }
        }

        private void WireButtons()
        {
            hintButton?.onClick.RemoveAllListeners();
            undoButton?.onClick.RemoveAllListeners();
            pauseButton?.onClick.RemoveAllListeners();
            exitButton?.onClick.RemoveAllListeners();
            stockAdvanceButton?.onClick.RemoveAllListeners();
            stockRestoreButton?.onClick.RemoveAllListeners();
            winDemoButton?.onClick.RemoveAllListeners();
            disconnectButton?.onClick.RemoveAllListeners();
            reconnectButton?.onClick.RemoveAllListeners();

            hintButton?.onClick.AddListener(() => _session?.RequestHintMock());
            undoButton?.onClick.AddListener(() => _session?.RequestRejectMove());
            pauseButton?.onClick.AddListener(() => SetBridgeWait(true));
            exitButton?.onClick.AddListener(() => _session?.RequestExit());
            stockAdvanceButton?.onClick.AddListener(() => _session?.RequestStockAdvance());
            stockRestoreButton?.onClick.AddListener(() => _session?.RequestStockRestore());
            winDemoButton?.onClick.AddListener(() => _session?.RequestWinDemo());
            disconnectButton?.onClick.AddListener(() => _session?.SimulateDisconnect());
            reconnectButton?.onClick.AddListener(() => _session?.SimulateReconnect());
        }

        private void ApplySafeArea()
        {
            if (safeAreaRoot == null)
            {
                return;
            }

            var safe = Screen.safeArea;
            var min = safe.position;
            var max = min + safe.size;
            min.x /= Screen.width;
            min.y /= Screen.height;
            max.x /= Screen.width;
            max.y /= Screen.height;
            safeAreaRoot.anchorMin = min;
            safeAreaRoot.anchorMax = max;
        }

        public static GameplayHud Create(Canvas canvas)
        {
            var root = new GameObject("GameplayHud", typeof(RectTransform));
            root.transform.SetParent(canvas.transform, false);
            var rootRect = root.GetComponent<RectTransform>();
            Stretch(rootRect);

            var hud = root.AddComponent<GameplayHud>();
            hud.safeAreaRoot = rootRect;

            var header = CreatePanel(
                root.transform,
                "HeaderPanel",
                new Vector2(0.025f, 0.855f),
                new Vector2(0.975f, 0.985f),
                HeaderColor);

            hud.titleLabel = CreateLabel(header.transform, "TitleLabel", new Vector2(0.5f, 0.67f), "ألوان أساسية", 42f, GoldColor, new Vector2(520f, 68f));
            hud.movesLabel = CreateLabel(header.transform, "MovesLabel", new Vector2(0.22f, 0.22f), "الحركات: 30", 28f, CreamColor, new Vector2(360f, 54f));
            hud.streakLabel = CreateLabel(header.transform, "StreakLabel", new Vector2(0.78f, 0.22f), "سلسلة: —", 28f, CreamColor, new Vector2(360f, 54f));
            hud.statusLabel = CreateLabel(root.transform, "StatusLabel", new Vector2(0.5f, 0.81f), string.Empty, 28f, GoldColor, new Vector2(640f, 56f));

            var developerPanel = CreatePanel(
                root.transform,
                "DeveloperControlsPanel",
                new Vector2(0.025f, 0.115f),
                new Vector2(0.975f, 0.185f),
                DeveloperPanelColor);

            hud.stockAdvanceButton = CreateButton(developerPanel.transform, "Stock+", "سحب", new Vector2(0.10f, 0.5f), new Vector2(150f, 50f), SecondaryButtonColor, 22f);
            hud.stockRestoreButton = CreateButton(developerPanel.transform, "إرجاع", "إرجاع", new Vector2(0.30f, 0.5f), new Vector2(150f, 50f), SecondaryButtonColor, 22f);
            hud.winDemoButton = CreateButton(developerPanel.transform, "Win", "فوز", new Vector2(0.50f, 0.5f), new Vector2(150f, 50f), SecondaryButtonColor, 22f);
            hud.disconnectButton = CreateButton(developerPanel.transform, "Disc", "فصل", new Vector2(0.70f, 0.5f), new Vector2(150f, 50f), DangerColor, 22f);
            hud.reconnectButton = CreateButton(developerPanel.transform, "Rec", "اتصال", new Vector2(0.90f, 0.5f), new Vector2(150f, 50f), SecondaryButtonColor, 22f);

            var primaryPanel = CreatePanel(
                root.transform,
                "PrimaryControlsPanel",
                new Vector2(0.025f, 0.015f),
                new Vector2(0.975f, 0.105f),
                PrimaryPanelColor);

            hud.hintButton = CreateButton(primaryPanel.transform, "Hint", "تلميح", new Vector2(0.14f, 0.5f), new Vector2(190f, 64f), AccentColor, 26f);
            hud.undoButton = CreateButton(primaryPanel.transform, "Undo", "تراجع", new Vector2(0.38f, 0.5f), new Vector2(190f, 64f), SecondaryButtonColor, 26f);
            hud.pauseButton = CreateButton(primaryPanel.transform, "Pause", "إيقاف", new Vector2(0.62f, 0.5f), new Vector2(190f, 64f), SecondaryButtonColor, 26f);
            hud.exitButton = CreateButton(primaryPanel.transform, "Exit", "خروج", new Vector2(0.86f, 0.5f), new Vector2(190f, 64f), DangerColor, 26f);

            hud.winOverlay = CreateOverlay(root.transform, "WinOverlay", "فوز!");
            hud.outOfMovesOverlay = CreateOverlay(root.transform, "OutOfMovesOverlay", "نفدت الحركات");
            hud.winOverlay.SetActive(false);
            hud.outOfMovesOverlay.SetActive(false);
            return hud;
        }

        private static GameObject CreatePanel(Transform parent, string name, Vector2 anchorMin, Vector2 anchorMax, Color color)
        {
            var panel = new GameObject(name, typeof(RectTransform), typeof(Image));
            panel.transform.SetParent(parent, false);
            var rect = panel.GetComponent<RectTransform>();
            rect.anchorMin = anchorMin;
            rect.anchorMax = anchorMax;
            rect.offsetMin = Vector2.zero;
            rect.offsetMax = Vector2.zero;

            var image = panel.GetComponent<Image>();
            image.color = color;
            image.raycastTarget = false;
            return panel;
        }

        private static TMP_Text CreateLabel(
            Transform parent,
            string name,
            Vector2 anchor,
            string text,
            float size,
            Color color,
            Vector2 dimensions)
        {
            var go = new GameObject(name, typeof(RectTransform));
            go.transform.SetParent(parent, false);
            var rect = go.GetComponent<RectTransform>();
            rect.anchorMin = anchor;
            rect.anchorMax = anchor;
            rect.sizeDelta = dimensions;

            var tmp = go.AddComponent<RTLTextMeshPro>();
            tmp.PreserveNumbers = true;
            tmp.Farsi = false;
            tmp.text = text;
            tmp.fontSize = size;
            tmp.color = color;
            tmp.alignment = TextAlignmentOptions.Center;
            tmp.raycastTarget = false;
            ArabicTypography.ApplyTo(tmp);
            return tmp;
        }

        private static Button CreateButton(
            Transform parent,
            string objectName,
            string label,
            Vector2 anchor,
            Vector2 dimensions,
            Color color,
            float fontSize)
        {
            var go = new GameObject(objectName + "Button", typeof(RectTransform), typeof(Image), typeof(Button));
            go.transform.SetParent(parent, false);
            var rect = go.GetComponent<RectTransform>();
            rect.anchorMin = anchor;
            rect.anchorMax = anchor;
            rect.sizeDelta = dimensions;

            var image = go.GetComponent<Image>();
            image.color = Color.white;

            var button = go.GetComponent<Button>();
            var colors = button.colors;
            colors.normalColor = color;
            colors.highlightedColor = Lighten(color, 0.10f);
            colors.selectedColor = Lighten(color, 0.06f);
            colors.pressedColor = Darken(color, 0.18f);
            colors.disabledColor = new Color(color.r, color.g, color.b, 0.35f);
            colors.colorMultiplier = 1f;
            colors.fadeDuration = 0.08f;
            button.colors = colors;
            button.targetGraphic = image;

            var textGo = new GameObject("Label", typeof(RectTransform));
            textGo.transform.SetParent(go.transform, false);
            var textRect = textGo.GetComponent<RectTransform>();
            Stretch(textRect);
            textRect.offsetMin = new Vector2(8f, 4f);
            textRect.offsetMax = new Vector2(-8f, -4f);

            var tmp = textGo.AddComponent<RTLTextMeshPro>();
            tmp.PreserveNumbers = true;
            tmp.Farsi = false;
            tmp.text = label;
            tmp.alignment = TextAlignmentOptions.Center;
            tmp.fontSize = fontSize;
            tmp.enableAutoSizing = true;
            tmp.fontSizeMin = 16f;
            tmp.fontSizeMax = fontSize;
            tmp.color = CreamColor;
            tmp.raycastTarget = false;
            ArabicTypography.ApplyTo(tmp);
            return button;
        }

        private static GameObject CreateOverlay(Transform parent, string name, string text)
        {
            var overlay = new GameObject(name, typeof(RectTransform), typeof(Image));
            overlay.transform.SetParent(parent, false);
            var rect = overlay.GetComponent<RectTransform>();
            Stretch(rect);
            overlay.GetComponent<Image>().color = new Color(0.04f, 0.02f, 0.07f, 0.82f);

            var card = CreatePanel(
                overlay.transform,
                "MessagePanel",
                new Vector2(0.16f, 0.38f),
                new Vector2(0.84f, 0.62f),
                HeaderColor);

            var label = CreateLabel(card.transform, "Label", new Vector2(0.5f, 0.5f), text, 52f, GoldColor, new Vector2(620f, 120f));
            label.alignment = TextAlignmentOptions.Center;
            return overlay;
        }

        private static void Stretch(RectTransform rect)
        {
            rect.anchorMin = Vector2.zero;
            rect.anchorMax = Vector2.one;
            rect.offsetMin = Vector2.zero;
            rect.offsetMax = Vector2.zero;
        }

        private static Color Lighten(Color color, float amount)
        {
            return new Color(
                Mathf.Clamp01(color.r + amount),
                Mathf.Clamp01(color.g + amount),
                Mathf.Clamp01(color.b + amount),
                color.a);
        }

        private static Color Darken(Color color, float amount)
        {
            return new Color(
                Mathf.Clamp01(color.r - amount),
                Mathf.Clamp01(color.g - amount),
                Mathf.Clamp01(color.b - amount),
                color.a);
        }
    }
}
