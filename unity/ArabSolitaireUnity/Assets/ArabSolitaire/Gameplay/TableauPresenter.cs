using System.Collections.Generic;
using ArabSolitaire.Bridge;
using ArabSolitaire.Cards;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class TableauPresenter : MonoBehaviour
    {
        [SerializeField] private Transform root;
        [SerializeField] private Color cardTint = new(0.93f, 0.86f, 0.68f);
        [SerializeField] private float columnSpacing = 0.88f;
        [SerializeField] private Vector3 boardAnchor = new(0f, 0.68f, -0.28f);
        [SerializeField] private float stackRise = 0.16f;
        [SerializeField] private float depthStep = 0.012f;

        private readonly Dictionary<string, CardView> _cardsById = new();
        private CardViewPool _pool;

        public IReadOnlyDictionary<string, CardView> CardsById => _cardsById;

        private void Awake()
        {
            if (root == null)
            {
                var go = new GameObject("TableauRoot");
                go.transform.SetParent(transform, false);
                root = go.transform;
            }

            _pool = new CardViewPool(root);
        }

        public void Present(IReadOnlyList<StackVisualIdentity> stacks, int revision)
        {
            Clear();
            for (var column = 0; column < stacks.Count; column++)
            {
                var stack = stacks[column];
                var x = (column - (stacks.Count - 1) * 0.5f) * columnSpacing;
                for (var i = 0; i < stack.Cards.Count; i++)
                {
                    var identity = stack.Cards[i];
                    identity.Revision = revision;
                    var view = _pool.Rent();
                    view.BindIdentity(identity, cardTint);
                    view.transform.localPosition = boardAnchor + new Vector3(x, i * stackRise, -i * depthStep);
#if UNITY_EDITOR || DEVELOPMENT_BUILD
                    view.LogVisibilityDiagnostic();
#endif
                    _cardsById[identity.CardId] = view;
                }
            }
        }

        public Vector3 GetColumnAnchor(int column, int columnCount) =>
            boardAnchor + new Vector3((column - (columnCount - 1) * 0.5f) * columnSpacing, 0f, 0f);

        public void Clear()
        {
            foreach (var view in _cardsById.Values)
            {
                _pool.Return(view);
            }

            _cardsById.Clear();
        }
    }
}
