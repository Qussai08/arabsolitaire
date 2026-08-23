#if UNITY_EDITOR || DEVELOPMENT_BUILD
using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Gameplay;
using TMPro;
using UnityEngine;

namespace ArabSolitaire.UI
{
    public sealed class DevPerformanceOverlay : MonoBehaviour
    {
        [SerializeField] private TMP_Text label;
        [SerializeField] private BoardPresenter board;
        [SerializeField] private MockBridgeTransport transport;
        [SerializeField] private Animation.AnimationQueue animationQueue;

        private float _fps;

        private void Awake()
        {
            if (label == null)
            {
                var go = new GameObject("DevPerfOverlay");
                go.transform.SetParent(transform, false);
                label = go.AddComponent<TextMeshPro>();
                label.fontSize = 2.2f;
                label.alignment = TextAlignmentOptions.TopLeft;
                label.transform.localPosition = new Vector3(-3.2f, 2.5f, 0f);
            }
        }

        private void Update()
        {
            _fps = Mathf.Lerp(_fps, 1f / Mathf.Max(Time.unscaledDeltaTime, 0.0001f), 0.1f);
            if (label == null)
            {
                return;
            }

            label.text =
                $"FPS {_fps:0}\n" +
                $"Cards {board?.ActiveCardCount ?? 0}\n" +
                $"AnimQ {animationQueue?.QueuedCount ?? 0}\n" +
                $"Rev {transport?.AuthoritativeRevision ?? -1}\n" +
                $"Mode mock\n" +
                $"Scene {UnityEngine.SceneManagement.SceneManager.GetActiveScene().name}";
        }
    }
}
#endif
