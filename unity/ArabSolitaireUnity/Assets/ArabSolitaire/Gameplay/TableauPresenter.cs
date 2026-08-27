using System.Collections.Generic;
using ArabSolitaire.Animation;
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
        [SerializeField] private float initialDealDuration = 0.18f;
        [SerializeField] private float initialDealStagger = 0.025f;

        private readonly Dictionary<string, CardView> _cardsById = new();
        private CardViewPool _pool;
        private PresentationRuntimeConfig _runtimeConfig;

        public IReadOnlyDictionary<string, CardView> CardsById => _cardsById;

        public void ConfigurePresentation(PresentationRuntimeConfig runtimeConfig) =>
            _runtimeConfig = runtimeConfig;

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
            var enterDuration = revision == 0
                ? _runtimeConfig?.ScaleDuration(initialDealDuration) ?? initialDealDuration
                : 0f;
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
                    var position = boardAnchor + new Vector3(x, i * stackRise, -i * depthStep);
                    var delay = enterDuration > 0f ? (column + i) * initialDealStagger : 0f;
                    view.PresentAt(position, delay, enterDuration);
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
