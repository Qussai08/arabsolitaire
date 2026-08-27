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
            var hud = root.AddComponent<GameplayHud>();
            hud.safeAreaRoot = root.GetComponent<RectTransform>();

            hud.titleLabel = CreateLabel(root.transform, "TitleLabel", new Vector2(0.5f, 0.92f), "ألوان أساسية", 42);
            hud.movesLabel = CreateLabel(root.transform, "MovesLabel", new Vector2(0.15f, 0.92f), "الحركات: 30", 34);
            hud.streakLabel = CreateLabel(root.transform, "StreakLabel", new Vector2(0.85f, 0.92f), "سلسلة: —", 34);
            hud.statusLabel = CreateLabel(root.transform, "StatusLabel", new Vector2(0.5f, 0.85f), string.Empty, 30);

            hud.hintButton = CreateButton(root.transform, "Hint", new Vector2(0.15f, 0.06f));
            hud.undoButton = CreateButton(root.transform, "Undo", new Vector2(0.35f, 0.06f));
            hud.pauseButton = CreateButton(root.transform, "Pause", new Vector2(0.55f, 0.06f));
            hud.exitButton = CreateButton(root.transform, "Exit", new Vector2(0.85f, 0.06f));
            hud.stockAdvanceButton = CreateButton(root.transform, "Stock+", new Vector2(0.15f, 0.12f));
            hud.stockRestoreButton = CreateButton(root.transform, "إرجاع", new Vector2(0.35f, 0.12f));
            hud.winDemoButton = CreateButton(root.transform, "Win", new Vector2(0.55f, 0.12f));
            hud.disconnectButton = CreateButton(root.transform, "Disc", new Vector2(0.7f, 0.12f));
            hud.reconnectButton = CreateButton(root.transform, "Rec", new Vector2(0.85f, 0.12f));

            hud.winOverlay = CreateOverlay(root.transform, "WinOverlay", "فوز!");
            hud.outOfMovesOverlay = CreateOverlay(root.transform, "OutOfMovesOverlay", "نفدت الحركات");
            hud.winOverlay.SetActive(false);
            hud.outOfMovesOverlay.SetActive(false);
            return hud;
        }

        private static TMP_Text CreateLabel(Transform parent, string name, Vector2 anchor, string text, float size)
        {
            var go = new GameObject(name, typeof(RectTransform));
            go.transform.SetParent(parent, false);
            var rt = go.GetComponent<RectTransform>();
            rt.anchorMin = anchor;
            rt.anchorMax = anchor;
            rt.sizeDelta = new Vector2(320f, 64f);
            var tmp = go.AddComponent<RTLTextMeshPro>();
            tmp.PreserveNumbers = true;
            tmp.Farsi = false;
            tmp.text = text;
            tmp.fontSize = size;
            tmp.alignment = TextAlignmentOptions.Center;
            ArabicTypography.ApplyTo(tmp);
            return tmp;
        }

        private static Button CreateButton(Transform parent, string label, Vector2 anchor)
        {
            var go = new GameObject(label + "Button", typeof(RectTransform), typeof(Image), typeof(Button));
            go.transform.SetParent(parent, false);
            var rt = go.GetComponent<RectTransform>();
            rt.anchorMin = anchor;
            rt.anchorMax = anchor;
            rt.sizeDelta = new Vector2(150f, 56f);
            var textGo = new GameObject("Label", typeof(RectTransform));
            textGo.transform.SetParent(go.transform, false);
            var tmp = textGo.AddComponent<RTLTextMeshPro>();
            tmp.PreserveNumbers = true;
            tmp.Farsi = false;
            tmp.text = label;
            tmp.alignment = TextAlignmentOptions.Center;
            tmp.fontSize = 24f;
            ArabicTypography.ApplyTo(tmp);
            return go.GetComponent<Button>();
        }

        private static GameObject CreateOverlay(Transform parent, string name, string text)
        {
            var go = new GameObject(name, typeof(RectTransform), typeof(Image));
            go.transform.SetParent(parent, false);
            var rt = go.GetComponent<RectTransform>();
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.offsetMin = Vector2.zero;
            rt.offsetMax = Vector2.zero;
            go.GetComponent<Image>().color = new Color(0f, 0f, 0f, 0.55f);
            var label = CreateLabel(go.transform, "Label", new Vector2(0.5f, 0.5f), text, 48);
            label.alignment = TextAlignmentOptions.Center;
            return go;
        }
    }
}
