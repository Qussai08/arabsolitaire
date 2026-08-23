using System.Collections.Generic;
using ArabSolitaire.Cards;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class AssociationSlotPresenter : MonoBehaviour
    {
        [SerializeField] private Transform root;
        [SerializeField] private Vector3 slotAnchor = new(2.6f, 0.05f, 1.1f);
        [SerializeField] private Color slotTint = new(0.75f, 0.62f, 0.35f);

        private readonly List<CardView> _active = new();
        private CardViewPool _pool;

        public Vector3 SlotAnchor => root.TransformPoint(slotAnchor);

        private void Awake()
        {
            root ??= transform;
            _pool = new CardViewPool(root);
        }

        public void Present(IReadOnlyList<StackVisualIdentity> slots, int revision)
        {
            Clear();
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
                view.transform.localPosition = slotAnchor + Vector3.up * (i * 0.15f);
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
