using System.Collections.Generic;
using ArabSolitaire.Animation;
using ArabSolitaire.Cards;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class StockPresenter : MonoBehaviour
    {
        [SerializeField] private Transform root;
        [SerializeField] private Vector3 stockAnchor = new(-2.8f, 0.68f, 0.95f);
        [SerializeField] private Vector3 wasteAnchor = new(-1.95f, 0.68f, 0.95f);
        [SerializeField] private Color cardTint = new(0.88f, 0.82f, 0.7f);
        [SerializeField] private float initialDealDuration = 0.18f;
        [SerializeField] private float initialDealStagger = 0.025f;

        private readonly List<CardView> _active = new();
        private CardViewPool _pool;
        private PresentationRuntimeConfig _runtimeConfig;

        public Vector3 StockAnchor => root.TransformPoint(stockAnchor);
        public Vector3 WasteAnchor => root.TransformPoint(wasteAnchor);

        public void ConfigurePresentation(PresentationRuntimeConfig runtimeConfig) =>
            _runtimeConfig = runtimeConfig;

        private void Awake()
        {
            root ??= transform;
            _pool = new CardViewPool(root);
        }

        public void Present(StackVisualIdentity stack, int revision)
        {
            Clear();
            var wasteIndex = 0;
            var enterDuration = revision == 0
                ? _runtimeConfig?.ScaleDuration(initialDealDuration) ?? initialDealDuration
                : 0f;
            for (var cardIndex = 0; cardIndex < stack.Cards.Count; cardIndex++)
            {
                var identity = stack.Cards[cardIndex];
                identity.Revision = revision;
                var view = _pool.Rent();
                view.BindIdentity(identity, cardTint);
                var position = identity.VisualState == CardVisualState.Waste
                    ? wasteAnchor + new Vector3(wasteIndex * 0.10f, wasteIndex * 0.035f, -wasteIndex++ * 0.012f)
                    : stockAnchor;
                var delay = enterDuration > 0f ? cardIndex * initialDealStagger : 0f;
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
