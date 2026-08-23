using ArabSolitaire.Bridge.Android;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace ArabSolitaire.Core
{
    /// <summary>
    /// Production Android / embedded entry: no Cairo JSON fixture.
    /// </summary>
    public sealed class ProductionGameplayBootstrap : MonoBehaviour
    {
        [SerializeField] private string gameplayScene = "GameplayCore";
        [SerializeField] private string cairoScene = "Chapter_Cairo_Greybox";

        private void Awake()
        {
            EnsureBridgeReceiver();
            NativeBridgeTransport.CreateRuntime();
        }

        private void Start()
        {
            if (!string.IsNullOrWhiteSpace(gameplayScene))
            {
                SceneManager.LoadScene(gameplayScene);
            }
        }

        public void LoadCairoPresentation()
        {
            if (!string.IsNullOrWhiteSpace(cairoScene))
            {
                SceneManager.LoadScene(cairoScene);
            }
        }

        private static void EnsureBridgeReceiver()
        {
            if (FindAnyObjectByType<FlutterBridgeReceiver>() != null)
            {
                return;
            }

            var go = new GameObject(NativeBridgeTransport.ReceiverObjectName);
            go.AddComponent<FlutterBridgeReceiver>();
            DontDestroyOnLoad(go);
        }
    }
}
