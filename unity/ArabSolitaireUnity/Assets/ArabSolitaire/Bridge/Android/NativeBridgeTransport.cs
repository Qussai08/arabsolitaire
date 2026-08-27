using System;
using ArabSolitaire.Bridge;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace ArabSolitaire.Bridge.Android
{
    public sealed class NativeBridgeTransport : MonoBehaviour
    {
        public const string ReceiverObjectName = "FlutterBridgeReceiver";
        public const string ReceiverMethodName = "OnFlutterMessage";

        private static NativeBridgeTransport _instance;

        public static NativeBridgeTransport Instance => _instance;

        public event Action<BridgeEnvelope> OnInboundMessage;

        public bool IsConnected { get; private set; } = true;
        public int AuthoritativeRevision { get; private set; }
        public string SessionId { get; private set; } = string.Empty;
        public string AttemptId { get; private set; } = string.Empty;
        public string LevelDefinitionId { get; private set; } = string.Empty;
        public BridgeEnvelope CurrentSnapshot { get; private set; }

        private void Awake()
        {
            if (_instance != null && _instance != this)
            {
                Destroy(gameObject);
                return;
            }

            _instance = this;
            DontDestroyOnLoad(gameObject);
        }

        private void OnDestroy()
        {
            if (_instance == this)
            {
                _instance = null;
            }
        }

        public void ConfigureSession(string sessionId, string attemptId, string levelDefinitionId)
        {
            SessionId = sessionId ?? string.Empty;
            AttemptId = attemptId ?? string.Empty;
            LevelDefinitionId = levelDefinitionId ?? string.Empty;
        }

        public void HandleInboundJson(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
            {
                Debug.LogWarning("NativeBridgeTransport: empty inbound payload.");
                return;
            }

            try
            {
                var envelope = BridgeEnvelope.FromJson(json);
                if (envelope.type == BridgeMessageType.StateSnapshot.ToWireName())
                {
                    AuthoritativeRevision = envelope.revision;
                    CurrentSnapshot = envelope;
                    SessionId = envelope.sessionId;
                    AttemptId = envelope.attemptId;
                    LevelDefinitionId = envelope.levelDefinitionId;
                }
                else if (envelope.type == BridgeMessageType.TransitionResult.ToWireName())
                {
                    AuthoritativeRevision = envelope.revision;
                }

                OnInboundMessage?.Invoke(envelope);
            }
            catch (Exception ex)
            {
                Debug.LogError($"NativeBridgeTransport inbound parse failed: {ex.Message}");
                EmitClientError("malformed_message", ex.Message);
            }
        }

        public void Emit(BridgeEnvelope envelope)
        {
            if (!IsConnected)
            {
                Debug.LogWarning("NativeBridgeTransport: disconnected; drop outbound message.");
                return;
            }

            envelope.sessionId = string.IsNullOrWhiteSpace(envelope.sessionId) ? SessionId : envelope.sessionId;
            envelope.attemptId = string.IsNullOrWhiteSpace(envelope.attemptId) ? AttemptId : envelope.attemptId;
            envelope.levelDefinitionId = string.IsNullOrWhiteSpace(envelope.levelDefinitionId)
                ? LevelDefinitionId
                : envelope.levelDefinitionId;

            try
            {
                var json = envelope.ToJson();
#if UNITY_ANDROID && !UNITY_EDITOR
                using var unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                using var activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
                activity?.Call("onUnityMessage", json);
#else
                Debug.Log($"[NativeBridgeTransport] Outbound (editor): {envelope.type}");
#endif
            }
            catch (Exception ex)
            {
                Debug.LogError($"NativeBridgeTransport outbound failed: {ex.Message}");
            }
        }

        public void EmitUnityReady()
        {
            Emit(new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"unity-ready-{Time.frameCount}",
                sessionId = SessionId,
                attemptId = AttemptId,
                levelDefinitionId = LevelDefinitionId,
                revision = AuthoritativeRevision,
                type = BridgeMessageType.UnityReady.ToWireName(),
                payload = new JObject { ["presentationMode"] = "unity3d" },
            });
        }

        public void EmitPresentationCompleted(int revision)
        {
            Emit(new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"presentation-{Time.frameCount}",
                sessionId = SessionId,
                attemptId = AttemptId,
                levelDefinitionId = LevelDefinitionId,
                revision = revision,
                type = BridgeMessageType.PresentationCompleted.ToWireName(),
                payload = new JObject { ["revision"] = revision },
            });
        }

        public void EmitActionIntent(BridgeEnvelope intent) => Emit(intent);

        public void EmitRequestHint()
        {
            Emit(new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"hint-{Time.frameCount}",
                sessionId = SessionId,
                attemptId = AttemptId,
                levelDefinitionId = LevelDefinitionId,
                revision = AuthoritativeRevision,
                type = BridgeMessageType.RequestHint.ToWireName(),
                payload = new JObject(),
            });
        }

        public void EmitRequestRestart()
        {
            Emit(new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"restart-{Time.frameCount}",
                sessionId = SessionId,
                attemptId = AttemptId,
                levelDefinitionId = LevelDefinitionId,
                revision = AuthoritativeRevision,
                type = BridgeMessageType.RequestRestart.ToWireName(),
                payload = new JObject(),
            });
        }

        public void EmitRequestExit()
        {
            Emit(new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"exit-{Time.frameCount}",
                sessionId = SessionId,
                attemptId = AttemptId,
                levelDefinitionId = LevelDefinitionId,
                revision = AuthoritativeRevision,
                type = BridgeMessageType.RequestExit.ToWireName(),
                payload = new JObject(),
            });
        }

        public void SimulateDisconnect() => IsConnected = false;

        public void SimulateReconnect() => IsConnected = true;

        private void EmitClientError(string code, string message)
        {
            Emit(new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"client-error-{Time.frameCount}",
                sessionId = SessionId,
                attemptId = AttemptId,
                levelDefinitionId = LevelDefinitionId,
                revision = AuthoritativeRevision,
                type = BridgeMessageType.ClientError.ToWireName(),
                payload = new JObject
                {
                    ["code"] = code,
                    ["message"] = message,
                },
            });
        }

        public static NativeBridgeTransport CreateRuntime()
        {
            if (_instance != null)
            {
                return _instance;
            }

            var go = new GameObject("NativeBridgeTransport");
            return go.AddComponent<NativeBridgeTransport>();
        }
    }
}
