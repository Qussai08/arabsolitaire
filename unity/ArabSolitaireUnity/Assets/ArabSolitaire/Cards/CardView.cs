using System.Collections.Generic;
using ArabSolitaire.Gameplay;
using TMPro;
using UnityEngine;

namespace ArabSolitaire.Cards
{
    public sealed class CardView : MonoBehaviour
    {
        [SerializeField] private TMP_Text label;
        [SerializeField] private MeshRenderer faceRenderer;
        [SerializeField] private Collider pickCollider;

        public CardVisualIdentity Identity { get; private set; } = new();
        public string CardId => Identity.CardId;

        public void BindIdentity(CardVisualIdentity identity, Color tint)
        {
            Identity = identity;
            gameObject.SetActive(true);
            gameObject.name = $"Card_{identity.CardId}";

            if (label != null)
            {
                label.text = identity.DisplayText;
                label.isRightToLeftText = ArabicTypography.ContainsArabic(identity.DisplayText);
            }

            if (faceRenderer != null)
            {
                faceRenderer.material.color = tint;
            }

            pickCollider ??= GetComponent<Collider>();
            if (pickCollider != null)
            {
                pickCollider.enabled = identity.Interactable;
            }
        }

        public void Bind(string cardId, Color tint) =>
            BindIdentity(new CardVisualIdentity
            {
                CardId = cardId,
                DisplayText = cardId,
                Interactable = true,
            }, tint);

        public void SetHighlighted(bool enabled)
        {
            if (faceRenderer == null)
            {
                return;
            }

            var c = faceRenderer.material.color;
            faceRenderer.material.color = enabled ? c * 1.15f : c;
        }

        public void Recycle()
        {
            Identity = new CardVisualIdentity();
            gameObject.SetActive(false);
        }

        public static CardView Create(Transform parent)
        {
            var go = GameObject.CreatePrimitive(PrimitiveType.Quad);
            go.name = "CardView";
            go.transform.SetParent(parent, false);
            go.transform.localScale = new Vector3(0.7f, 1f, 1f);

            var labelGo = new GameObject("Label");
            labelGo.transform.SetParent(go.transform, false);
            labelGo.transform.localPosition = new Vector3(0f, 0f, -0.02f);
            var tmp = labelGo.AddComponent<TextMeshPro>();
            tmp.fontSize = 3f;
            tmp.alignment = TextAlignmentOptions.Center;
            ArabicTypography.ApplyTo(tmp);

            var view = go.AddComponent<CardView>();
            view.label = tmp;
            view.faceRenderer = go.GetComponent<MeshRenderer>();
            view.pickCollider = go.GetComponent<Collider>();
            return view;
        }
    }

    public sealed class CardViewPool
    {
        private readonly Transform _root;
        private readonly Stack<CardView> _pool = new();

        public CardViewPool(Transform root) => _root = root;

        public int PooledCount => _pool.Count;

        public CardView Rent() => _pool.Count > 0 ? _pool.Pop() : CardView.Create(_root);

        public void Return(CardView view)
        {
            view.Recycle();
            _pool.Push(view);
        }
    }
}
