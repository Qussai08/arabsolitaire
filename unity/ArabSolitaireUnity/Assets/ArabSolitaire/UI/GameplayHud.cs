using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Gameplay;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace ArabSolitaire.UI
{
    public sealed class GameplayHud : MonoBehaviour
    {
        [SerializeField] private TMP_Text movesLabel;
        [SerializeField] private Button acceptButton;
        [SerializeField] private Button rejectButton;
        [SerializeField] private Button hintButton;
        [SerializeField] private Button exitButton;
        [SerializeField] private RectTransform safeAreaRoot;

        private GameplaySessionController _session;

        public int MovesRemaining { get; private set; } = 30;

        public void Bind(GameplaySessionController session, MockBridgeTransport transport)
        {
            _session = session;
            ApplySafeArea();
            SetMovesRemaining(MovesRemaining);
            WireButtons();
        }

        public void SetMovesRemaining(int value)
        {
            MovesRemaining = value;
            if (movesLabel != null)
            {
                movesLabel.text = $"Moves: {MovesRemaining}";
            }
        }

        private void WireButtons()
        {
            acceptButton?.onClick.RemoveAllListeners();
            rejectButton?.onClick.RemoveAllListeners();
            hintButton?.onClick.RemoveAllListeners();
            exitButton?.onClick.RemoveAllListeners();

            acceptButton?.onClick.AddListener(() => _session?.RequestAcceptMove());
            rejectButton?.onClick.AddListener(() => _session?.RequestRejectMove());
            hintButton?.onClick.AddListener(() => _session?.RequestHintMock());
            exitButton?.onClick.AddListener(() => _session?.RequestExit());
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

            hud.movesLabel = CreateLabel(root.transform, "MovesLabel", new Vector2(0.5f, 0.95f), "Moves: 30");
            hud.acceptButton = CreateButton(root.transform, "Accept", new Vector2(0.25f, 0.08f));
            hud.rejectButton = CreateButton(root.transform, "Reject", new Vector2(0.5f, 0.08f));
            hud.hintButton = CreateButton(root.transform, "Hint", new Vector2(0.75f, 0.08f));
            hud.exitButton = CreateButton(root.transform, "Exit", new Vector2(0.9f, 0.95f));
            return hud;
        }

        private static TMP_Text CreateLabel(Transform parent, string name, Vector2 anchor, string text)
        {
            var go = new GameObject(name, typeof(RectTransform));
            go.transform.SetParent(parent, false);
            var rt = go.GetComponent<RectTransform>();
            rt.anchorMin = anchor;
            rt.anchorMax = anchor;
            rt.sizeDelta = new Vector2(280f, 64f);
            var tmp = go.AddComponent<TextMeshProUGUI>();
            tmp.text = text;
            tmp.fontSize = 36f;
            tmp.alignment = TextAlignmentOptions.Center;
            return tmp;
        }

        private static Button CreateButton(Transform parent, string label, Vector2 anchor)
        {
            var go = new GameObject(label + "Button", typeof(RectTransform), typeof(Image), typeof(Button));
            go.transform.SetParent(parent, false);
            var rt = go.GetComponent<RectTransform>();
            rt.anchorMin = anchor;
            rt.anchorMax = anchor;
            rt.sizeDelta = new Vector2(180f, 72f);
            var textGo = new GameObject("Label", typeof(RectTransform));
            textGo.transform.SetParent(go.transform, false);
            var tmp = textGo.AddComponent<TextMeshProUGUI>();
            tmp.text = label;
            tmp.alignment = TextAlignmentOptions.Center;
            tmp.fontSize = 28f;
            return go.GetComponent<Button>();
        }
    }
}
