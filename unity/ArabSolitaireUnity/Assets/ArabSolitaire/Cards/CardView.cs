using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace ArabSolitaire.Cards
{
    public sealed class CardView : MonoBehaviour
    {
        [SerializeField] private TMP_Text label;
        [SerializeField] private MeshRenderer faceRenderer;

        public string CardId { get; private set; } = string.Empty;

        public void Bind(string cardId, Color tint)
        {
            CardId = cardId;
            gameObject.SetActive(true);

            if (label != null)
            {
                label.text = cardId;
                label.isRightToLeftText = ContainsArabic(cardId);
            }

            if (faceRenderer != null)
            {
                faceRenderer.material.color = tint;
            }
        }

        public void Recycle()
        {
            CardId = string.Empty;
            gameObject.SetActive(false);
        }

        private static bool ContainsArabic(string value)
        {
            foreach (var c in value)
            {
                if (c is >= '\u0600' and <= '\u06FF')
                {
                    return true;
                }
            }

            return false;
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

            var view = go.AddComponent<CardView>();
            view.label = tmp;
            view.faceRenderer = go.GetComponent<MeshRenderer>();
            return view;
        }
    }

    public sealed class CardViewPool
    {
        private readonly Transform _root;
        private readonly Stack<CardView> _pool = new();

        public CardViewPool(Transform root) => _root = root;

        public CardView Rent() => _pool.Count > 0 ? _pool.Pop() : CardView.Create(_root);

        public void Return(CardView view)
        {
            view.Recycle();
            _pool.Push(view);
        }
    }
}
