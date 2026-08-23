using ArabSolitaire.Animation;
using ArabSolitaire.Bridge;
using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Characters;
using ArabSolitaire.UI;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class GameplaySessionController : MonoBehaviour
    {
        [SerializeField] private TextAsset fixtureAsset;
        [SerializeField] private BoardPresenter boardPresenter;
        [SerializeField] private GameplayHud hud;
        [SerializeField] private ShiboubPresenter shiboubPresenter;

        private MockBridgeTransport _transport;
        private EventAnimationMapper _animationMapper;

        public void Configure(
            TextAsset fixture,
            BoardPresenter board,
            GameplayHud gameplayHud,
            ShiboubPresenter shiboub)
        {
            fixtureAsset = fixture;
            boardPresenter = board;
            hud = gameplayHud;
            shiboubPresenter = shiboub;
        }

        private void Awake()
        {
            _animationMapper = new EventAnimationMapper();
            ResolveReferences();
        }

        private void Start()
        {
            ResolveReferences();
            if (fixtureAsset == null || boardPresenter == null)
            {
                Debug.LogError("GameplaySessionController: missing fixture or board presenter.");
                return;
            }

            _transport = MockBridgeTransport.CreateRuntime(fixtureAsset);
            _transport.OnOutboundMessage += HandleOutbound;
            boardPresenter.PresentSnapshot(_transport.CurrentSnapshot);
            hud?.Bind(this, _transport);
        }

        private void OnDestroy()
        {
            if (_transport != null)
            {
                _transport.OnOutboundMessage -= HandleOutbound;
            }
        }

        public void RequestAcceptMove() => SendIntent(BuildMoveIntent(0, 2, "req-accept"));

        public void RequestRejectMove() => SendIntent(BuildMoveIntent(2, 0, "req-reject"));

        public void RequestHintMock() => shiboubPresenter?.PlayPoint();

        public void RequestExit() => Debug.Log("Exit requested.");

        public void SimulateDisconnect() => _transport?.SimulateDisconnect();

        public void SimulateReconnect()
        {
            _transport?.SimulateReconnect();
            if (_transport?.CurrentSnapshot != null)
            {
                boardPresenter.PresentSnapshot(_transport.CurrentSnapshot);
            }
        }

        private void SendIntent(BridgeEnvelope intent)
        {
            if (_transport == null || !_transport.IsConnected)
            {
                Debug.LogWarning("Bridge disconnected.");
                return;
            }

            var result = _transport.HandleActionIntent(intent);
            ApplyTransition(result);
        }

        private void HandleOutbound(BridgeEnvelope envelope)
        {
            if (envelope.type == BridgeMessageType.StateSnapshot.ToWireName())
            {
                boardPresenter.PresentSnapshot(envelope);
            }
        }

        private void ApplyTransition(BridgeEnvelope transitionEnvelope)
        {
            var payload = transitionEnvelope.payload.ToObject<TransitionResultPayload>();
            if (payload == null)
            {
                return;
            }

            boardPresenter.PresentTransition(payload);
            var command = _animationMapper.Map(payload.events, payload.accepted);
            shiboubPresenter?.Play(command);
            if (payload.accepted)
            {
                hud?.SetMovesRemaining(Mathf.Max(0, hud.MovesRemaining - payload.moveCost));
            }
        }

        private void ResolveReferences()
        {
            boardPresenter ??= FindFirstObjectByType<BoardPresenter>();
            hud ??= FindFirstObjectByType<GameplayHud>();
            shiboubPresenter ??= FindFirstObjectByType<ShiboubPresenter>();
        }

        private BridgeEnvelope BuildMoveIntent(int from, int to, string requestId)
        {
            return new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"intent-{requestId}",
                sessionId = _transport.CurrentSnapshot.sessionId,
                attemptId = _transport.CurrentSnapshot.attemptId,
                levelDefinitionId = _transport.CurrentSnapshot.levelDefinitionId,
                revision = _transport.AuthoritativeRevision,
                type = BridgeMessageType.ActionIntent.ToWireName(),
                requestId = requestId,
                payload = new JObject
                {
                    ["action"] = new JObject
                    {
                        ["type"] = "moveTableauToTableau",
                        ["fromColumn"] = from,
                        ["toColumn"] = to,
                    },
                },
            };
        }
    }
}
