using System;
using ArabSolitaire.Bridge;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace ArabSolitaire.Bridge.Mock
{
    /// <summary>
    /// Development-only transport. Deterministic accept/reject from JSON fixtures.
    /// This is NOT a rules engine.
    /// </summary>
    public sealed class MockBridgeTransport : MonoBehaviour
    {
        [SerializeField] private TextAsset fixtureAsset;
        [SerializeField] private bool autoLoadOnStart = true;

        private MockFixture _fixture;
        private BridgeMessageValidator _validator;
        private BridgeEnvelope _currentSnapshot;
        private int _messageCounter;

        public event Action<BridgeEnvelope> OnOutboundMessage;

        public bool IsConnected { get; private set; } = true;
        public BridgeEnvelope CurrentSnapshot => _currentSnapshot;
        public int AuthoritativeRevision => _validator?.AuthoritativeRevision ?? 0;

        private void Start()
        {
            if (autoLoadOnStart)
            {
                LoadFixture();
            }
        }

        public void LoadFixture(TextAsset asset = null)
        {
            fixtureAsset = asset != null ? asset : fixtureAsset;
            if (fixtureAsset == null)
            {
                Debug.LogError("MockBridgeTransport: fixtureAsset missing.");
                return;
            }

            _fixture = JObject.Parse(fixtureAsset.text).ToObject<MockFixture>();
            _validator = new BridgeMessageValidator(_fixture.revision);
            _currentSnapshot = BridgeEnvelope.FromJObject(_fixture.initialSnapshot);
            _messageCounter = 0;
            IsConnected = true;
            Emit(BuildOutbound(
                BridgeMessageType.UnityReady,
                new JObject { ["presentationMode"] = "unity3d" },
                null,
                AuthoritativeRevision));
        }

        public void SimulateDisconnect() => IsConnected = false;

        public void SimulateReconnect()
        {
            IsConnected = true;
            Emit(_currentSnapshot);
        }

        public BridgeEnvelope HandleActionIntent(BridgeEnvelope intent)
        {
            if (!IsConnected)
            {
                throw new InvalidOperationException("Mock bridge disconnected.");
            }

            _validator.ValidateInboundIntent(intent);

            var key = ResolveResponseKey(intent);
            var mock = _fixture.mockResponses[key] as JObject
                ?? throw new InvalidOperationException($"Missing mock response: {key}");

            var nextState = CloneGameState();
            if (mock.Value<bool>("accepted"))
            {
                ApplyAcceptedDelta(nextState, intent);
            }

            var transition = new TransitionResultPayload
            {
                accepted = mock.Value<bool>("accepted"),
                nextState = nextState,
                moveCost = mock.Value<int>("moveCost"),
                events = mock["events"] as JArray ?? new JArray(),
                newRevision = mock.Value<int>("newRevision"),
                rejectionReason = mock.Value<string>("rejectionReason"),
            };

            _validator.AdvanceRevision(transition.newRevision);

            var envelope = BuildOutbound(
                BridgeMessageType.TransitionResult,
                JObject.FromObject(transition),
                intent.requestId,
                transition.newRevision);

            _currentSnapshot = BuildOutbound(
                BridgeMessageType.StateSnapshot,
                new JObject
                {
                    ["revision"] = transition.newRevision,
                    ["gameState"] = nextState,
                },
                null,
                transition.newRevision);

            Emit(envelope);
            return envelope;
        }

        private static string ResolveResponseKey(BridgeEnvelope intent)
        {
            var action = intent.payload["action"] as JObject;
            if (action == null)
            {
                return "reject_move_2_to_0";
            }

            if (action.Value<string>("type") == "moveTableauToTableau")
            {
                var from = action.Value<int>("fromColumn");
                var to = action.Value<int>("toColumn");
                if (from == 0 && to == 2)
                {
                    return "accept_move_0_to_2";
                }

                if (from == 2 && to == 0)
                {
                    return "reject_move_2_to_0";
                }
            }

            return "reject_move_2_to_0";
        }

        private JObject CloneGameState()
        {
            var gameState = _currentSnapshot.payload["gameState"] as JObject;
            return gameState != null ? (JObject)gameState.DeepClone() : new JObject();
        }

        private static void ApplyAcceptedDelta(JObject nextState, BridgeEnvelope intent)
        {
            var action = intent.payload["action"] as JObject;
            if (action == null || action.Value<string>("type") != "moveTableauToTableau")
            {
                return;
            }

            var from = action.Value<int>("fromColumn");
            var to = action.Value<int>("toColumn");
            var tableau = nextState["tableau"] as JArray;
            if (tableau == null || from >= tableau.Count || to >= tableau.Count)
            {
                return;
            }

            var fromCol = tableau[from] as JObject;
            var toCol = tableau[to] as JObject;
            var moving = fromCol?["exposedUnit"] as JObject;
            if (fromCol == null || toCol == null || moving == null)
            {
                return;
            }

            fromCol["exposedUnit"] = JValue.CreateNull();
            if (toCol["exposedUnit"] == null || toCol["exposedUnit"].Type == JTokenType.Null)
            {
                toCol["exposedUnit"] = moving;
            }
        }

        private BridgeEnvelope BuildOutbound(
            BridgeMessageType type,
            JObject payload,
            string requestId,
            int revision)
        {
            _messageCounter++;
            return new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"mock-{_messageCounter}",
                sessionId = _fixture.sessionId,
                attemptId = _fixture.attemptId,
                levelDefinitionId = _fixture.levelDefinitionId,
                revision = revision,
                type = type.ToWireName(),
                requestId = requestId,
                payload = payload,
            };
        }

        private void Emit(BridgeEnvelope envelope) => OnOutboundMessage?.Invoke(envelope);

        public static MockBridgeTransport CreateRuntime(TextAsset fixture)
        {
            var go = new GameObject("MockBridgeTransport");
            var transport = go.AddComponent<MockBridgeTransport>();
            transport.autoLoadOnStart = false;
            transport.LoadFixture(fixture);
            return transport;
        }

        [Serializable]
        private sealed class MockFixture
        {
            public int revision;
            public string sessionId = string.Empty;
            public string attemptId = string.Empty;
            public string levelDefinitionId = string.Empty;
            public JObject initialSnapshot = new();
            public JObject mockResponses = new();
        }
    }
}
