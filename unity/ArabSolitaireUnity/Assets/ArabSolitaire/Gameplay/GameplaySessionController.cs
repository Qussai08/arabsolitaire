using System.Collections;
using ArabSolitaire.Animation;
using ArabSolitaire.Bridge;
using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Cameras;
using ArabSolitaire.Characters;
using ArabSolitaire.Interaction;
using ArabSolitaire.UI;
using ArabSolitaire.Vfx;
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
        [SerializeField] private PresentationRuntimeConfig config;
        [SerializeField] private CameraDirector cameraDirector;
        [SerializeField] private MeaningThreadVfxPool meaningThreads;
        [SerializeField] private DistortionVfx distortionVfx;

        private MockBridgeTransport _transport;
        private BridgeMessageRouter _router;
        private BridgeSessionGuard _guard;
        private DomainEventAnimationMapper _eventMapper;
        private AnimationQueue _animationQueue;
        private InputLockController _inputLock;
        private CardInteractionController _interaction;
        private DropTargetResolver _targetResolver;
        private bool _readyForInput = true;

        public bool ReadyForInput => _readyForInput && (_guard?.IsReadyForInput ?? true);
        public MockBridgeTransport Transport => _transport;

        public void Configure(
            TextAsset fixture,
            BoardPresenter board,
            GameplayHud gameplayHud,
            ShiboubPresenter shiboub,
            PresentationRuntimeConfig runtimeConfig = null,
            CameraDirector camera = null,
            MeaningThreadVfxPool threads = null,
            DistortionVfx distortion = null)
        {
            fixtureAsset = fixture;
            boardPresenter = board;
            hud = gameplayHud;
            shiboubPresenter = shiboub;
            config = runtimeConfig;
            cameraDirector = camera;
            meaningThreads = threads;
            distortionVfx = distortion;
        }

        private void Awake()
        {
            _router = new BridgeMessageRouter();
            _eventMapper = new DomainEventAnimationMapper();
            _animationQueue = gameObject.AddComponent<AnimationQueue>();
            _inputLock = gameObject.AddComponent<InputLockController>();
            _targetResolver = gameObject.AddComponent<DropTargetResolver>();
            _interaction = gameObject.AddComponent<CardInteractionController>();
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
            _guard = new BridgeSessionGuard(_transport.AuthoritativeRevision);
            _transport.OnOutboundMessage += HandleOutbound;
            _router.OnTransitionResult += HandleTransitionResult;

            boardPresenter.PresentSnapshot(_transport.CurrentSnapshot);
            hud?.Bind(this, _transport);

            var cam = Camera.main;
            _targetResolver.Configure(boardPresenter.Tableau, boardPresenter.Stock, boardPresenter.Slots);
            _interaction.Configure(
                boardPresenter.Tableau,
                _targetResolver,
                _inputLock,
                cam,
                SubmitIntent);
            _readyForInput = true;
        }

        private void OnDestroy()
        {
            if (_transport != null)
            {
                _transport.OnOutboundMessage -= HandleOutbound;
            }
        }

        public void RequestAcceptMove() => LockAndRun(() => SubmitIntent(BuildMoveIntent(0, 2, $"req-accept-{Time.frameCount}")));

        public void RequestRejectMove() => LockAndRun(() => SubmitIntent(BuildMoveIntent(2, 0, $"req-reject-{Time.frameCount}")));

        public void RequestStockAdvance()
        {
            LockAndRun(() => _transport?.HandleStockAdvanceDemo());
        }

        public void RequestStockRestore()
        {
            LockAndRun(() => _transport?.HandleStockRestoreDemo());
        }

        public void RequestHintMock()
        {
            _transport?.HandleHintRequest();
            shiboubPresenter?.PlayPoint();
            hud?.ShowHintFeedback();
        }

        public void RequestWinDemo()
        {
            LockAndRun(() => _transport?.HandleWinDemo());
        }

        public void RequestExit() => Debug.Log("Exit requested.");

        public void SimulateDisconnect()
        {
            _transport?.SimulateDisconnect();
            hud?.ShowConnectionError(true);
        }

        public void SimulateReconnect()
        {
            _transport?.SimulateReconnect();
            if (_transport?.CurrentSnapshot != null)
            {
                boardPresenter.ReconcileTo(_transport.CurrentSnapshot);
                _guard.RestoreRevision(_transport.AuthoritativeRevision);
                _interaction.CancelStaleInteraction(_transport.AuthoritativeRevision);
            }

            hud?.ShowConnectionError(false);
        }

        private bool SubmitIntent(BridgeEnvelope intent)
        {
            if (_transport == null || !_transport.IsConnected || !ReadyForInput)
            {
                Debug.LogWarning("Bridge not ready for input.");
                return false;
            }

            intent.revision = _transport.AuthoritativeRevision;
            intent.sessionId = _transport.CurrentSnapshot.sessionId;
            intent.attemptId = _transport.CurrentSnapshot.attemptId;
            intent.levelDefinitionId = _transport.CurrentSnapshot.levelDefinitionId;

            _guard.LockInput();
            _readyForInput = false;
            hud?.SetBridgeWait(true);
            _transport.HandleActionIntent(intent);
            return true;
        }

        private void LockAndRun(System.Action action)
        {
            if (!ReadyForInput)
            {
                return;
            }

            _guard.LockInput();
            _readyForInput = false;
            hud?.SetBridgeWait(true);
            action();
        }

        private void HandleOutbound(BridgeEnvelope envelope) => _router.Route(envelope);

        private void HandleTransitionResult(BridgeEnvelope transitionEnvelope)
        {
            var payload = transitionEnvelope.payload.ToObject<TransitionResultPayload>();
            if (payload == null)
            {
                CompletePresentation();
                return;
            }

            _guard.AdvanceRevision(payload.newRevision);
            var steps = _eventMapper.Map(payload.events, payload.accepted);
            _animationQueue.Enqueue(PlayTransition(payload, steps));
        }

        private IEnumerator PlayTransition(TransitionResultPayload payload, System.Collections.Generic.IReadOnlyList<DomainAnimationStep> steps)
        {
            var duration = config != null ? config.ScaleDuration(config.moveDuration) : 0.35f;
            if (!payload.accepted)
            {
                duration = config != null ? config.ScaleDuration(config.rejectDuration) : 0.25f;
                distortionVfx?.PlayAt(boardPresenter.Tableau.GetColumnAnchor(2, 3));
                cameraDirector?.PlayBeat(CameraBeat.Reject);
                shiboubPresenter?.PlayReject();
                hud?.ShowRejectFeedback(payload.rejectionReason);
            }
            else
            {
                cameraDirector?.PlayBeat(CameraBeat.Selection);
            }

            yield return new WaitForSeconds(duration);
            boardPresenter.PresentTransition(payload);

            foreach (var step in steps)
            {
                switch (step.Kind)
                {
                    case DomainAnimKind.AssociationCompleted:
                        meaningThreads?.Play(
                            boardPresenter.Tableau.GetColumnAnchor(2, 3),
                            boardPresenter.Slots.SlotAnchor,
                            1);
                        cameraDirector?.PlayBeat(CameraBeat.AssociationComplete);
                        shiboubPresenter?.PlayCelebrate();
                        break;
                    case DomainAnimKind.StockAdvanced:
                    case DomainAnimKind.StockRestored:
                        cameraDirector?.PlayBeat(CameraBeat.Gameplay);
                        break;
                    case DomainAnimKind.GameWon:
                        cameraDirector?.PlayBeat(CameraBeat.Win);
                        shiboubPresenter?.PlayCelebrate();
                        hud?.ShowWinOverlay(true);
                        break;
                    case DomainAnimKind.OutOfMovesReached:
                        shiboubPresenter?.PlayConcerned();
                        hud?.ShowOutOfMovesOverlay(true);
                        break;
                }
            }

            shiboubPresenter?.Play(_eventMapper.ToShiboubCommand(steps, payload.accepted));
            if (payload.accepted)
            {
                hud?.SetMovesRemaining(Mathf.Max(0, hud.MovesRemaining - payload.moveCost));
            }

            boardPresenter.ReconcileTo(_transport.CurrentSnapshot);
            CompletePresentation();
        }

        private void CompletePresentation()
        {
            _guard.UnlockInput();
            _readyForInput = true;
            hud?.SetBridgeWait(false);
            _transport?.EmitPresentationCompleted(_transport.AuthoritativeRevision);
        }

        private void ResolveReferences()
        {
            boardPresenter ??= FindFirstObjectByType<BoardPresenter>();
            hud ??= FindFirstObjectByType<GameplayHud>();
            shiboubPresenter ??= FindFirstObjectByType<ShiboubPresenter>();
            cameraDirector ??= FindFirstObjectByType<CameraDirector>();
            meaningThreads ??= FindFirstObjectByType<MeaningThreadVfxPool>();
            distortionVfx ??= FindFirstObjectByType<DistortionVfx>();
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
