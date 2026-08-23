using System.Collections.Generic;
using ArabSolitaire.Cards;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class StockPresenter : MonoBehaviour
    {
        [SerializeField] private Transform root;
        [SerializeField] private Vector3 stockAnchor = new(-2.8f, 0.05f, 1.2f);
        [SerializeField] private Vector3 wasteAnchor = new(-2.1f, 0.05f, 1.2f);
        [SerializeField] private Color cardTint = new(0.88f, 0.82f, 0.7f);

        private readonly List<CardView> _active = new();
        private CardViewPool _pool;

        public Vector3 StockAnchor => root.TransformPoint(stockAnchor);
        public Vector3 WasteAnchor => root.TransformPoint(wasteAnchor);

        private void Awake()
        {
            root ??= transform;
            _pool = new CardViewPool(root);
        }

        public void Present(StackVisualIdentity stack, int revision)
        {
            Clear();
            var wasteIndex = 0;
            foreach (var identity in stack.Cards)
            {
                identity.Revision = revision;
                var view = _pool.Rent();
                view.BindIdentity(identity, cardTint);
                view.transform.localPosition = identity.VisualState == CardVisualState.Waste
                    ? wasteAnchor + Vector3.right * (wasteIndex++ * 0.12f)
                    : stockAnchor;
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
