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
                ApplyAcceptedDelta(nextState, intent, key);
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

        public BridgeEnvelope HandleHintRequest()
        {
            var mock = _fixture.mockResponses["hint"] as JObject
                ?? throw new InvalidOperationException("Missing mock response: hint");
            var envelope = BuildOutbound(
                BridgeMessageType.HintResult,
                new JObject
                {
                    ["highlightColumn"] = 2,
                    ["events"] = mock["events"],
                },
                null,
                AuthoritativeRevision);
            Emit(envelope);
            return envelope;
        }

        public BridgeEnvelope HandleWinDemo() => HandleMockAction("win", "win");

        public BridgeEnvelope HandleStockAdvanceDemo() =>
            HandleMockAction("advanceStock", $"advance_stock_{++_messageCounter}");

        public BridgeEnvelope HandleStockRestoreDemo() =>
            HandleMockAction("restoreStock", $"restore_stock_{++_messageCounter}");

        private BridgeEnvelope HandleMockAction(string actionType, string requestId)
        {
            var intent = new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"mock-{requestId}",
                sessionId = _fixture.sessionId,
                attemptId = _fixture.attemptId,
                levelDefinitionId = _fixture.levelDefinitionId,
                revision = AuthoritativeRevision,
                type = BridgeMessageType.ActionIntent.ToWireName(),
                requestId = requestId,
                payload = new JObject { ["action"] = new JObject { ["type"] = actionType } },
            };
            return HandleActionIntent(intent);
        }

        private static string ResolveResponseKey(BridgeEnvelope intent)
        {
            var action = intent.payload["action"] as JObject;
            if (action == null)
            {
                return "reject_move_2_to_0";
            }

            var type = action.Value<string>("type");
            if (type == "advanceStock" || type == "advance_stock")
            {
                return "advance_stock";
            }

            if (type == "restoreStock" || type == "restore_stock")
            {
                return "restore_stock";
            }

            if (type == "win")
            {
                return "win";
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

        private static void ApplyAcceptedDelta(JObject nextState, BridgeEnvelope intent, string key)
        {
            var action = intent.payload["action"] as JObject;
            if (key == "advance_stock")
            {
                AdvanceStock(nextState);
                return;
            }

            if (key == "restore_stock")
            {
                RestoreStock(nextState);
                return;
            }

            if (key == "win")
            {
                nextState["status"] = "won";
                return;
            }

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

        private static void AdvanceStock(JObject nextState)
        {
            var stock = nextState["stock"] as JObject;
            if (stock == null)
            {
                return;
            }

            var undealt = stock["undealt"] as JArray ?? new JArray();
            var waste = stock["waste"] as JArray ?? new JArray();
            if (undealt.Count == 0)
            {
                return;
            }

            var card = undealt[0];
            undealt.RemoveAt(0);
            waste.Add(card);
            stock["undealt"] = undealt;
            stock["waste"] = waste;
        }

        private static void RestoreStock(JObject nextState)
        {
            var stock = nextState["stock"] as JObject;
            if (stock == null)
            {
                return;
            }

            var undealt = stock["undealt"] as JArray ?? new JArray();
            var waste = stock["waste"] as JArray ?? new JArray();
            while (waste.Count > 0)
            {
                undealt.Add(waste[waste.Count - 1]);
                waste.RemoveAt(waste.Count - 1);
            }

            stock["undealt"] = undealt;
            stock["waste"] = waste;
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

        public void EmitPresentationCompleted(int revision)
        {
            Emit(BuildOutbound(
                BridgeMessageType.PresentationCompleted,
                new JObject { ["revision"] = revision },
                null,
                revision));
        }

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
