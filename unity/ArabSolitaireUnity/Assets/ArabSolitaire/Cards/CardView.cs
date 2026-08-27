using System.Collections.Generic;
using ArabSolitaire.Gameplay;
using ArabSolitaire.Rendering;
using TMPro;
using RTLTMPro;
using UnityEngine;

namespace ArabSolitaire.Cards
{
    public sealed class CardView : MonoBehaviour
    {
        private static readonly Color BorderColor = new(0.76f, 0.54f, 0.20f, 1f);
        private static readonly Color HiddenColor = new(0.12f, 0.08f, 0.20f, 1f);
        private static readonly Color CompletedColor = new(0.62f, 0.40f, 0.12f, 1f);
        private static readonly Color InkColor = new(0.16f, 0.09f, 0.07f, 1f);
        private static readonly Color CreamColor = new(1f, 0.94f, 0.79f, 1f);

        [SerializeField] private TMP_Text label;
        [SerializeField] private MeshRenderer faceRenderer;
        [SerializeField] private MeshRenderer borderRenderer;
        [SerializeField] private Collider pickCollider;

        private Color _baseFaceColor;

        public CardVisualIdentity Identity { get; private set; } = new();
        public string CardId => Identity.CardId;

        public void BindIdentity(CardVisualIdentity identity, Color tint)
        {
            Identity = identity;
            gameObject.SetActive(true);
            gameObject.name = $"Card_{identity.CardId}";

            var concealed = identity.VisualState is CardVisualState.Hidden or CardVisualState.Stock;
            var completed = identity.VisualState == CardVisualState.CompletedSlot;
            _baseFaceColor = concealed ? HiddenColor : completed ? CompletedColor : tint;

            if (label != null)
            {
                label.text = concealed ? "دار الروابط" : identity.DisplayText;
                label.isRightToLeftText = concealed || ArabicTypography.ContainsArabic(identity.DisplayText);
                label.color = concealed || completed ? CreamColor : InkColor;
                ArabicTypography.ApplyTo(label);
            }

            if (faceRenderer != null)
            {
                PrototypeMaterial.Tint(faceRenderer, _baseFaceColor);
            }

            if (borderRenderer != null)
            {
                PrototypeMaterial.Tint(borderRenderer, completed ? CreamColor : BorderColor);
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

            PrototypeMaterial.Tint(faceRenderer, enabled ? Lighten(_baseFaceColor, 0.16f) : _baseFaceColor);
            transform.localScale = enabled ? new Vector3(1.06f, 1.06f, 1f) : Vector3.one;
        }

        public void Recycle()
        {
            Identity = new CardVisualIdentity();
            transform.localScale = Vector3.one;
            gameObject.SetActive(false);
        }

        public static CardView Create(Transform parent)
        {
            var root = new GameObject("CardView", typeof(BoxCollider));
            root.transform.SetParent(parent, false);

            var shadow = CreateLayer(
                root.transform,
                "Shadow",
                new Vector3(0.055f, -0.055f, 0.045f),
                new Vector3(0.78f, 1.08f, 1f),
                new Color(0.02f, 0.01f, 0.02f, 0.55f));

            var border = CreateLayer(
                root.transform,
                "GoldBorder",
                new Vector3(0f, 0f, 0.02f),
                new Vector3(0.78f, 1.08f, 1f),
                BorderColor);

            var face = CreateLayer(
                root.transform,
                "CardFace",
                new Vector3(0f, 0f, -0.015f),
                new Vector3(0.70f, 1f, 1f),
                new Color(0.93f, 0.86f, 0.68f));

            var inset = CreateLayer(
                root.transform,
                "InnerFrame",
                new Vector3(0f, 0f, -0.026f),
                new Vector3(0.61f, 0.84f, 1f),
                new Color(0.82f, 0.68f, 0.42f, 0.28f));

            shadow.GetComponent<Collider>().enabled = false;
            border.GetComponent<Collider>().enabled = false;
            face.GetComponent<Collider>().enabled = false;
            inset.GetComponent<Collider>().enabled = false;

            var labelGo = new GameObject("Label");
            labelGo.transform.SetParent(root.transform, false);
            labelGo.transform.localPosition = new Vector3(0f, 0f, -0.045f);
            var tmp = labelGo.AddComponent<RTLTextMeshPro3D>();
            tmp.PreserveNumbers = true;
            tmp.Farsi = false;
            tmp.fontSize = 2.5f;
            tmp.enableAutoSizing = true;
            tmp.fontSizeMin = 1.4f;
            tmp.fontSizeMax = 2.5f;
            tmp.alignment = TextAlignmentOptions.Center;
            tmp.color = InkColor;
            tmp.rectTransform.sizeDelta = new Vector2(0.58f, 0.78f);
            ArabicTypography.ApplyTo(tmp);

            var box = root.GetComponent<BoxCollider>();
            box.size = new Vector3(0.78f, 1.08f, 0.08f);
            box.center = Vector3.zero;

            var view = root.AddComponent<CardView>();
            view.label = tmp;
            view.faceRenderer = face.GetComponent<MeshRenderer>();
            view.borderRenderer = border.GetComponent<MeshRenderer>();
            view.pickCollider = box;
            return view;
        }

        private static GameObject CreateLayer(
            Transform parent,
            string name,
            Vector3 localPosition,
            Vector3 localScale,
            Color color)
        {
            var layer = GameObject.CreatePrimitive(PrimitiveType.Cube);
            layer.name = name;
            layer.transform.SetParent(parent, false);
            layer.transform.localPosition = localPosition;
            layer.transform.localScale = new Vector3(localScale.x, localScale.y, 0.018f);
            PrototypeMaterial.Apply(layer.GetComponent<Renderer>(), color);
            return layer;
        }

        private static Color Lighten(Color color, float amount)
        {
            return new Color(
                Mathf.Clamp01(color.r + amount),
                Mathf.Clamp01(color.g + amount),
                Mathf.Clamp01(color.b + amount),
                color.a);
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
