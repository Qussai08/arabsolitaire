using ArabSolitaire.Bridge.Android;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace ArabSolitaire.Core
{
    /// <summary>
    /// First scene entry. On Android embedded builds, wires the Flutter bridge and
    /// loads the Cairo greybox (GameplayCore is a thin placeholder scene).
    /// </summary>
    public sealed class BootstrapController : MonoBehaviour
    {
        [SerializeField] private string nextScene = "GameplayCore";
        [SerializeField] private string androidPresentationScene = "Chapter_Cairo_Greybox";

        private void Awake()
        {
#if UNITY_ANDROID && !UNITY_EDITOR
            EnsureAndroidBridge();
#endif
        }

        private void Start()
        {
#if UNITY_ANDROID && !UNITY_EDITOR
            if (!string.IsNullOrWhiteSpace(androidPresentationScene))
            {
                SceneManager.LoadScene(androidPresentationScene);
                return;
            }
#endif
            if (!string.IsNullOrWhiteSpace(nextScene))
            {
                SceneManager.LoadScene(nextScene);
            }
        }

        private static void EnsureAndroidBridge()
        {
            if (FindAnyObjectByType<FlutterBridgeReceiver>() == null)
            {
                var receiver = new GameObject(NativeBridgeTransport.ReceiverObjectName);
                receiver.AddComponent<FlutterBridgeReceiver>();
                DontDestroyOnLoad(receiver);
            }

            if (NativeBridgeTransport.Instance == null)
            {
                NativeBridgeTransport.CreateRuntime();
            }
        }
    }
}
