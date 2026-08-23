using UnityEngine;

namespace ArabSolitaire.Bridge.Android
{
    /// <summary>
    /// Fixed Android→Unity entry point. GameObject name must remain FlutterBridgeReceiver.
    /// </summary>
    public sealed class FlutterBridgeReceiver : MonoBehaviour
    {
        private void Awake()
        {
            gameObject.name = NativeBridgeTransport.ReceiverObjectName;
        }

        public void ConfigureSession(string payload)
        {
            if (string.IsNullOrWhiteSpace(payload))
            {
                return;
            }

            var parts = payload.Split('|');
            if (parts.Length < 3)
            {
                return;
            }

            NativeBridgeTransport.Instance?.ConfigureSession(parts[0], parts[1], parts[2]);
            var session = FindFirstObjectByType<Gameplay.GameplaySessionController>();
            session?.ConfigureSessionFromAndroid(parts[0], parts[1], parts[2]);
        }

        public void OnFlutterMessage(string json)
        {
            NativeBridgeTransport.Instance?.HandleInboundJson(json);
        }
    }
}
