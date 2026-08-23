using System.Collections;
using ArabSolitaire.Animation;
using ArabSolitaire.Bridge;
using ArabSolitaire.Bridge.Android;
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

        private MockBridgeTransport _mockTransport;
        private NativeBridgeTransport _nativeTransport;
        private BridgeMessageRouter _router;
        private BridgeSessionGuard _guard;
        private DomainEventAnimationMapper _eventMapper;
        private AnimationQueue _animationQueue;
        private InputLockController _inputLock;
        private CardInteractionController _interaction;
        private DropTargetResolver _targetResolver;
        private bool _readyForInput;
        private bool _productionMode;
        private bool _awaitingInitialSnapshot = true;

        public bool ReadyForInput => _readyForInput && (_guard?.IsReadyForInput ?? false);
        public MockBridgeTransport Transport => _mockTransport;
        public bool ProductionMode => _productionMode;

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
            _nativeTransport = NativeBridgeTransport.Instance;
            if (_nativeTransport != null)
            {
                StartProduction(_nativeTransport);
                return;
            }

            StartMock();
        }

        private void OnDestroy()
        {
            if (_mockTransport != null)
            {
                _mockTransport.OnOutboundMessage -= HandleOutbound;
            }

            if (_nativeTransport != null)
            {
                _nativeTransport.OnInboundMessage -= HandleProductionInbound;
            }
        }

        private void StartMock()
        {
            if (fixtureAsset == null || boardPresenter == null)
            {
                Debug.LogError("GameplaySessionController: missing fixture or board presenter.");
                return;
            }

            _mockTransport = MockBridgeTransport.CreateRuntime(fixtureAsset);
            _guard = new BridgeSessionGuard(_mockTransport.AuthoritativeRevision);
            _mockTransport.OnOutboundMessage += HandleOutbound;
            _router.OnTransitionResult += HandleTransitionResult;

            boardPresenter.PresentSnapshot(_mockTransport.CurrentSnapshot);
            hud?.Bind(this, _mockTransport);

            ConfigureInteraction();
            _readyForInput = true;
        }

        private void StartProduction(NativeBridgeTransport transport)
        {
            _productionMode = true;
            _nativeTransport = transport;
            _guard = new BridgeSessionGuard(0);
            transport.OnInboundMessage += HandleProductionInbound;
            _router.OnSnapshot += HandleProductionSnapshot;
            _router.OnTransitionResult += HandleTransitionResult;
            _router.OnHintResult += HandleHintResult;
            _router.OnFatalError += HandleFatalError;

            hud?.Bind(this, null);
            ConfigureInteraction();
            _readyForInput = false;
            _awaitingInitialSnapshot = true;
            transport.EmitUnityReady();
        }

        public void ConfigureSessionFromAndroid(string sessionId, string attemptId, string levelDefinitionId)
        {
            _nativeTransport?.ConfigureSession(sessionId, attemptId, levelDefinitionId);
        }

        private void ConfigureInteraction()
        {
            var cam = Camera.main;
            _targetResolver.Configure(boardPresenter.Tableau, boardPresenter.Stock, boardPresenter.Slots);
            _interaction.Configure(
                boardPresenter.Tableau,
                _targetResolver,
                _inputLock,
                cam,
                SubmitIntent);
        }

        public void RequestAcceptMove() => LockAndRun(() => SubmitIntent(BuildMoveIntent(0, 2, $"req-accept-{Time.frameCount}")));

        public void RequestRejectMove() => LockAndRun(() => SubmitIntent(BuildMoveIntent(2, 0, $"req-reject-{Time.frameCount}")));

        public void RequestStockAdvance()
        {
            LockAndRun(() =>
            {
                if (_productionMode)
                {
                    SubmitIntent(BuildActionIntent("advanceStock", $"advance-{Time.frameCount}"));
                    return;
                }

                _mockTransport?.HandleStockAdvanceDemo();
            });
        }

        public void RequestStockRestore()
        {
            LockAndRun(() =>
            {
                if (_productionMode)
                {
                    SubmitIntent(BuildActionIntent("restoreStock", $"restore-{Time.frameCount}"));
                    return;
                }

                _mockTransport?.HandleStockRestoreDemo();
            });
        }

        public void RequestHintMock()
        {
            if (_productionMode)
            {
                _nativeTransport?.EmitRequestHint();
                return;
            }

            _mockTransport?.HandleHintRequest();
            shiboubPresenter?.PlayPoint();
            hud?.ShowHintFeedback();
        }

        public void RequestWinDemo()
        {
            LockAndRun(() =>
            {
                if (_productionMode)
                {
                    SubmitIntent(BuildActionIntent("win", $"win-{Time.frameCount}"));
                    return;
                }

                _mockTransport?.HandleWinDemo();
            });
        }

        public void RequestExit()
        {
            if (_productionMode)
            {
                _nativeTransport?.EmitRequestExit();
                return;
            }

            Debug.Log("Exit requested.");
        }

        public void SimulateDisconnect()
        {
            if (_productionMode)
            {
                _nativeTransport?.SimulateDisconnect();
            }
            else
            {
                _mockTransport?.SimulateDisconnect();
            }

            hud?.ShowConnectionError(true);
        }

        public void SimulateReconnect()
        {
            if (_productionMode)
            {
                _nativeTransport?.SimulateReconnect();
            }
            else
            {
                _mockTransport?.SimulateReconnect();
                if (_mockTransport?.CurrentSnapshot != null)
                {
                    boardPresenter.ReconcileTo(_mockTransport.CurrentSnapshot);
                    _guard.RestoreRevision(_mockTransport.AuthoritativeRevision);
                    _interaction.CancelStaleInteraction(_mockTransport.AuthoritativeRevision);
                }
            }

            hud?.ShowConnectionError(false);
        }

        private bool SubmitIntent(BridgeEnvelope intent)
        {
            if (!ReadyForInput && !_productionMode)
            {
                Debug.LogWarning("Bridge not ready for input.");
                return false;
            }

            if (_productionMode)
            {
                if (_nativeTransport == null || !_nativeTransport.IsConnected || _awaitingInitialSnapshot)
                {
                    Debug.LogWarning("Production bridge awaiting authoritative snapshot.");
                    return false;
                }

                intent.revision = _nativeTransport.AuthoritativeRevision;
                intent.sessionId = _nativeTransport.SessionId;
                intent.attemptId = _nativeTransport.AttemptId;
                intent.levelDefinitionId = _nativeTransport.LevelDefinitionId;
                _guard.LockInput();
                _readyForInput = false;
                hud?.SetBridgeWait(true);
                _nativeTransport.EmitActionIntent(intent);
                return true;
            }

            if (_mockTransport == null || !_mockTransport.IsConnected)
            {
                Debug.LogWarning("Bridge not ready for input.");
                return false;
            }

            intent.revision = _mockTransport.AuthoritativeRevision;
            intent.sessionId = _mockTransport.CurrentSnapshot.sessionId;
            intent.attemptId = _mockTransport.CurrentSnapshot.attemptId;
            intent.levelDefinitionId = _mockTransport.CurrentSnapshot.levelDefinitionId;

            _guard.LockInput();
            _readyForInput = false;
            hud?.SetBridgeWait(true);
            _mockTransport.HandleActionIntent(intent);
            return true;
        }

        private void LockAndRun(System.Action action)
        {
            if (!ReadyForInput && !_productionMode)
            {
                return;
            }

            _guard.LockInput();
            _readyForInput = false;
            hud?.SetBridgeWait(true);
            action();
        }

        private void HandleOutbound(BridgeEnvelope envelope) => _router.Route(envelope);

        private void HandleProductionInbound(BridgeEnvelope envelope) => _router.Route(envelope);

        private void HandleProductionSnapshot(BridgeEnvelope snapshot)
        {
            _awaitingInitialSnapshot = false;
            _guard.RestoreRevision(snapshot.revision);
            boardPresenter.PresentSnapshot(snapshot);
            _interaction.CancelStaleInteraction(snapshot.revision);
            _readyForInput = true;
            _guard.UnlockInput();
            hud?.SetBridgeWait(false);
        }

        private void HandleHintResult(BridgeEnvelope envelope)
        {
            shiboubPresenter?.PlayPoint();
            hud?.ShowHintFeedback();
        }

        private void HandleFatalError(BridgeEnvelope envelope)
        {
            hud?.ShowRejectFeedback(envelope.payload?["message"]?.Value<string>());
            CompletePresentation();
        }

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

            if (_productionMode && _nativeTransport?.CurrentSnapshot != null)
            {
                boardPresenter.ReconcileTo(_nativeTransport.CurrentSnapshot);
            }
            else if (_mockTransport?.CurrentSnapshot != null)
            {
                boardPresenter.ReconcileTo(_mockTransport.CurrentSnapshot);
            }
            else if (payload.nextState != null)
            {
                boardPresenter.ReconcileTo(payload.nextState, payload.newRevision);
            }

            CompletePresentation();
        }

        private void CompletePresentation()
        {
            _guard.UnlockInput();
            _readyForInput = true;
            hud?.SetBridgeWait(false);
            if (_productionMode)
            {
                _nativeTransport?.EmitPresentationCompleted(_nativeTransport.AuthoritativeRevision);
            }
            else
            {
                _mockTransport?.EmitPresentationCompleted(_mockTransport.AuthoritativeRevision);
            }
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
                sessionId = ActiveSessionId(),
                attemptId = ActiveAttemptId(),
                levelDefinitionId = ActiveLevelDefinitionId(),
                revision = ActiveRevision(),
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

        private BridgeEnvelope BuildActionIntent(string actionType, string requestId)
        {
            return new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"intent-{requestId}",
                sessionId = ActiveSessionId(),
                attemptId = ActiveAttemptId(),
                levelDefinitionId = ActiveLevelDefinitionId(),
                revision = ActiveRevision(),
                type = BridgeMessageType.ActionIntent.ToWireName(),
                requestId = requestId,
                payload = new JObject
                {
                    ["action"] = new JObject { ["type"] = actionType },
                },
            };
        }

        private string ActiveSessionId() =>
            _productionMode ? _nativeTransport?.SessionId ?? string.Empty : _mockTransport?.CurrentSnapshot.sessionId ?? string.Empty;

        private string ActiveAttemptId() =>
            _productionMode ? _nativeTransport?.AttemptId ?? string.Empty : _mockTransport?.CurrentSnapshot.attemptId ?? string.Empty;

        private string ActiveLevelDefinitionId() =>
            _productionMode
                ? _nativeTransport?.LevelDefinitionId ?? string.Empty
                : _mockTransport?.CurrentSnapshot.levelDefinitionId ?? string.Empty;

        private int ActiveRevision() =>
            _productionMode ? _nativeTransport?.AuthoritativeRevision ?? 0 : _mockTransport?.AuthoritativeRevision ?? 0;
    }
}
