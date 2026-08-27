using System.Collections.Generic;
using ArabSolitaire.Animation;
using ArabSolitaire.Cards;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class AssociationSlotPresenter : MonoBehaviour
    {
        [SerializeField] private Transform root;
        [SerializeField] private Vector3 slotAnchor = new(2.55f, 0.68f, 0.95f);
        [SerializeField] private Color slotTint = new(0.75f, 0.62f, 0.35f);
        [SerializeField] private float initialDealDuration = 0.18f;
        [SerializeField] private float initialDealStagger = 0.025f;

        private readonly List<CardView> _active = new();
        private CardViewPool _pool;
        private PresentationRuntimeConfig _runtimeConfig;

        public Vector3 SlotAnchor => root.TransformPoint(slotAnchor);

        public void ConfigurePresentation(PresentationRuntimeConfig runtimeConfig) =>
            _runtimeConfig = runtimeConfig;

        private void Awake()
        {
            root ??= transform;
            _pool = new CardViewPool(root);
        }

        public void Present(IReadOnlyList<StackVisualIdentity> slots, int revision)
        {
            Clear();
            var enterDuration = revision == 0
                ? _runtimeConfig?.ScaleDuration(initialDealDuration) ?? initialDealDuration
                : 0f;
            for (var i = 0; i < slots.Count; i++)
            {
                var stack = slots[i];
                if (stack.Cards.Count == 0)
                {
                    continue;
                }

                var identity = stack.Cards[0];
                identity.Revision = revision;
                var view = _pool.Rent();
                view.BindIdentity(identity, slotTint);
                var position = slotAnchor + new Vector3(0f, i * 0.16f, -i * 0.012f);
                var delay = enterDuration > 0f ? i * initialDealStagger : 0f;
                view.PresentAt(position, delay, enterDuration);
                _active.Add(view);
            }
        }

        public void Clear()
        {
            foreach (var view in _active)
            {
                _pool.Return(view);
            }

            _active.Clear();
        }
    }
}
