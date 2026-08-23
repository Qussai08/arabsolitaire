using System;
using ArabSolitaire.Bridge;
using ArabSolitaire.Cards;
using ArabSolitaire.Gameplay;
using Newtonsoft.Json.Linq;
using UnityEngine;
using UnityEngine.InputSystem;

namespace ArabSolitaire.Interaction
{
    public sealed class CardInteractionController : MonoBehaviour
    {
        [SerializeField] private TableauPresenter tableau;
        [SerializeField] private DropTargetResolver targetResolver;
        [SerializeField] private InputLockController inputLock;
        [SerializeField] private Camera gameplayCamera;
        [SerializeField] private float dragLift = 0.25f;
        [SerializeField] private float dragTilt = 8f;
        [SerializeField] private float touchOffsetY = 0.35f;

        private CardView _selected;
        private CardVisualIdentity _selectedIdentity;
        private Vector3 _origin;
        private DropTarget _hoverTarget;
        private Func<BridgeEnvelope, bool> _submitIntent;

        public event Action<BridgeEnvelope> OnIntentSubmitted;

        public void Configure(
            TableauPresenter tableauPresenter,
            DropTargetResolver resolver,
            InputLockController lockController,
            Camera camera,
            Func<BridgeEnvelope, bool> submitIntent)
        {
            tableau = tableauPresenter;
            targetResolver = resolver;
            inputLock = lockController;
            gameplayCamera = camera;
            _submitIntent = submitIntent;
        }

        public void CancelStaleInteraction(int revision)
        {
            if (_selectedIdentity != null && _selectedIdentity.Revision != revision)
            {
                RestoreSelected();
            }
        }

        private void Update()
        {
            if (inputLock != null && inputLock.IsLocked)
            {
                return;
            }

            var pointer = Pointer.current;
            if (pointer == null || gameplayCamera == null)
            {
                return;
            }

            if (pointer.press.wasPressedThisFrame)
            {
                HandlePress(pointer);
            }
            else if (pointer.press.isPressed && _selected != null)
            {
                HandleDrag(pointer);
            }
            else if (pointer.press.wasReleasedThisFrame)
            {
                HandleRelease(pointer);
            }
        }

        private void HandlePress(InputControl pointer)
        {
            var pos = ReadScreenPosition(pointer);
            if (!TryPickCard(pos, out var view, out var identity))
            {
                return;
            }

            if (!inputLock.TryAcquirePointer(0))
            {
                return;
            }

            _selected = view;
            _selectedIdentity = identity;
            _origin = view.transform.position;
            view.SetHighlighted(true);
            view.transform.position = _origin + Vector3.up * dragLift;
            view.transform.rotation = Quaternion.Euler(-dragTilt, 0f, 0f);
        }

        private void HandleDrag(InputControl pointer)
        {
            var world = ScreenToBoard(ReadScreenPosition(pointer));
            world.y = _origin.y + dragLift;
            world.z = _origin.z;
            _selected.transform.position = world + Vector3.up * touchOffsetY;
            _hoverTarget = targetResolver.Resolve(world);
        }

        private void HandleRelease(InputControl pointer)
        {
            if (_selected == null)
            {
                inputLock?.ReleasePointer(0);
                return;
            }

            var target = _hoverTarget.IsValid
                ? _hoverTarget
                : targetResolver.Resolve(ScreenToBoard(ReadScreenPosition(pointer)));

            if (target.IsValid && _selectedIdentity != null)
            {
                var intent = BuildIntent(_selectedIdentity, target);
                var accepted = _submitIntent?.Invoke(intent) ?? false;
                OnIntentSubmitted?.Invoke(intent);
                if (!accepted)
                {
                    RestoreSelected();
                }
            }
            else
            {
                RestoreSelected();
            }

            _selected.SetHighlighted(false);
            _selected = null;
            _selectedIdentity = null;
            _hoverTarget = default;
            inputLock?.ReleasePointer(0);
        }

        private void RestoreSelected()
        {
            if (_selected == null)
            {
                return;
            }

            _selected.transform.position = _origin;
            _selected.transform.rotation = Quaternion.identity;
            _selected.SetHighlighted(false);
        }

        private bool TryPickCard(Vector2 screenPos, out CardView view, out CardVisualIdentity identity)
        {
            view = null;
            identity = null;
            if (tableau == null)
            {
                return false;
            }

            var ray = gameplayCamera.ScreenPointToRay(screenPos);
            if (!Physics.Raycast(ray, out var hit, 100f))
            {
                return false;
            }

            view = hit.collider.GetComponentInParent<CardView>();
            if (view == null || !view.Identity.Interactable)
            {
                view = null;
                return false;
            }

            identity = view.Identity;
            return true;
        }

        private Vector3 ScreenToBoard(Vector2 screenPos)
        {
            var ray = gameplayCamera.ScreenPointToRay(screenPos);
            var plane = new Plane(Vector3.up, Vector3.zero);
            return plane.Raycast(ray, out var enter) ? ray.GetPoint(enter) : Vector3.zero;
        }

        private static Vector2 ReadScreenPosition(InputControl pointer) =>
            Pointer.current != null ? Pointer.current.position.ReadValue() : Vector2.zero;

        private BridgeEnvelope BuildIntent(CardVisualIdentity identity, DropTarget target)
        {
            var action = new JObject();
            if (target.Zone == "tableau")
            {
                action["type"] = "moveTableauToTableau";
                action["fromColumn"] = identity.SourceIndex;
                action["toColumn"] = target.Index;
            }
            else if (target.Zone == "stock")
            {
                action["type"] = "advanceStock";
            }
            else
            {
                action["type"] = "moveTableauToTableau";
                action["fromColumn"] = identity.SourceIndex;
                action["toColumn"] = target.Index;
            }

            return new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"intent-{Guid.NewGuid():N}",
                sessionId = "mock-session-cairo",
                attemptId = "محاولة-١",
                levelDefinitionId = "cairo_level_1",
                revision = identity.Revision,
                type = BridgeMessageType.ActionIntent.ToWireName(),
                requestId = Guid.NewGuid().ToString("N"),
                payload = new JObject { ["action"] = action },
            };
        }
    }
}
