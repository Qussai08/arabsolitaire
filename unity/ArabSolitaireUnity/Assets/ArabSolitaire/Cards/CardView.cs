using System;
using System.Collections;
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
        private static readonly Color AssociationColor = new(0.42f, 0.13f, 0.18f, 1f);
        private static readonly Color AssociationRibbonColor = new(0.68f, 0.29f, 0.22f, 1f);
        private static readonly Color MemberRibbonColor = new(0.13f, 0.39f, 0.34f, 1f);
        private static readonly Color BackAccentColor = new(0.82f, 0.61f, 0.24f, 1f);
        private static readonly Color InkColor = new(0.16f, 0.09f, 0.07f, 1f);
        private static readonly Color CreamColor = new(1f, 0.94f, 0.79f, 1f);

        [SerializeField] private TMP_Text label;
        [SerializeField] private MeshRenderer faceRenderer;
        [SerializeField] private MeshRenderer borderRenderer;
        [SerializeField] private MeshRenderer insetRenderer;
        [SerializeField] private GameObject roleBadge;
        [SerializeField] private MeshRenderer roleRenderer;
        [SerializeField] private TMP_Text roleLabel;
        [SerializeField] private GameObject backArtwork;
        [SerializeField] private Collider pickCollider;

        private Color _baseFaceColor;
        private Coroutine _entranceRoutine;
        private Coroutine _highlightRoutine;
        private Vector3 _presentationTarget;

        public CardVisualIdentity Identity { get; private set; } = new();
        public string CardId => Identity.CardId;

        public void BindIdentity(CardVisualIdentity identity, Color tint)
        {
            Identity = identity;
            gameObject.SetActive(true);
            gameObject.name = $"Card_{identity.CardId}";

            var concealed = identity.VisualState is CardVisualState.Hidden or CardVisualState.Stock;
            var completed = identity.VisualState == CardVisualState.CompletedSlot;
            var association = string.Equals(identity.CardType, "association", StringComparison.OrdinalIgnoreCase);
            _baseFaceColor = concealed
                ? HiddenColor
                : completed
                    ? CompletedColor
                    : association
                        ? AssociationColor
                        : tint;

            if (label != null)
            {
                label.text = concealed ? "دار الروابط" : identity.DisplayText;
                label.isRightToLeftText = concealed || ArabicTypography.ContainsArabic(identity.DisplayText);
                label.color = concealed || completed ? CreamColor : InkColor;
                ArabicTypography.ApplyTo(label);
            }

            if (roleBadge != null)
            {
                roleBadge.SetActive(!concealed);
            }

            if (roleLabel != null)
            {
                roleLabel.text = completed ? "مكتملة" : association ? "رابطة" : "كلمة";
                roleLabel.isRightToLeftText = true;
                roleLabel.color = CreamColor;
                ArabicTypography.ApplyTo(roleLabel);
            }

            if (backArtwork != null)
            {
                backArtwork.SetActive(concealed);
            }

            if (faceRenderer != null)
            {
                PrototypeMaterial.Tint(faceRenderer, _baseFaceColor);
            }

            if (borderRenderer != null)
            {
                PrototypeMaterial.Tint(borderRenderer, completed ? CreamColor : BorderColor);
            }

            if (insetRenderer != null)
            {
                PrototypeMaterial.Tint(
                    insetRenderer,
                    concealed ? BackAccentColor : association ? AssociationRibbonColor : MemberRibbonColor);
            }

            if (roleRenderer != null)
            {
                PrototypeMaterial.Tint(
                    roleRenderer,
                    completed ? CompletedColor : association ? AssociationRibbonColor : MemberRibbonColor);
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

            if (enabled && _entranceRoutine != null)
            {
                StopCoroutine(_entranceRoutine);
                _entranceRoutine = null;
                transform.localPosition = _presentationTarget;
                transform.localRotation = Quaternion.identity;
            }

            PrototypeMaterial.Tint(faceRenderer, enabled ? Lighten(_baseFaceColor, 0.16f) : _baseFaceColor);
            if (_highlightRoutine != null)
            {
                StopCoroutine(_highlightRoutine);
            }

            var targetScale = enabled ? new Vector3(1.055f, 1.055f, 1f) : Vector3.one;
            if (!isActiveAndEnabled)
            {
                transform.localScale = targetScale;
                return;
            }

            _highlightRoutine = StartCoroutine(AnimateScale(targetScale, 0.09f));
        }

        public void PresentAt(Vector3 localPosition, float delay, float duration)
        {
            _presentationTarget = localPosition;
            if (_entranceRoutine != null)
            {
                StopCoroutine(_entranceRoutine);
                _entranceRoutine = null;
            }

            transform.localRotation = Quaternion.identity;
            if (duration <= 0f || !gameObject.activeInHierarchy)
            {
                transform.localPosition = localPosition;
                return;
            }

            _entranceRoutine = StartCoroutine(AnimateEntrance(localPosition, delay, duration));
        }

        public void Recycle()
        {
            StopAllCoroutines();
            _entranceRoutine = null;
            _highlightRoutine = null;
            Identity = new CardVisualIdentity();
            transform.localScale = Vector3.one;
            transform.localRotation = Quaternion.identity;
            gameObject.SetActive(false);
        }

        public static CardView Create(Transform parent)
        {
            var root = new GameObject("CardView", typeof(BoxCollider));
            root.transform.SetParent(parent, false);

            CreateLayer(
                root.transform,
                "Shadow",
                new Vector3(0.045f, -0.045f, 0.045f),
                new Vector3(0.72f, 1.00f, 1f),
                new Color(0.02f, 0.01f, 0.02f, 0.55f));

            var border = CreateLayer(
                root.transform,
                "GoldBorder",
                new Vector3(0f, 0f, 0.02f),
                new Vector3(0.70f, 0.98f, 1f),
                BorderColor);

            var face = CreateLayer(
                root.transform,
                "CardFace",
                new Vector3(0f, 0f, -0.015f),
                new Vector3(0.65f, 0.92f, 1f),
                new Color(0.93f, 0.86f, 0.68f));

            var inset = CreateLayer(
                root.transform,
                "InnerFrame",
                new Vector3(0f, 0f, -0.026f),
                new Vector3(0.57f, 0.78f, 1f),
                new Color(0.82f, 0.68f, 0.42f, 0.28f));

            var roleRoot = new GameObject("RoleBadge");
            roleRoot.transform.SetParent(root.transform, false);
            var roleRibbon = CreateLayer(
                roleRoot.transform,
                "Ribbon",
                new Vector3(0f, 0.34f, -0.038f),
                new Vector3(0.45f, 0.13f, 1f),
                MemberRibbonColor);

            var roleLabelGo = new GameObject("TypeLabel");
            roleLabelGo.transform.SetParent(roleRoot.transform, false);
            roleLabelGo.transform.localPosition = new Vector3(0f, 0.34f, -0.058f);
            var roleTmp = roleLabelGo.AddComponent<RTLTextMeshPro3D>();
            roleTmp.PreserveNumbers = true;
            roleTmp.Farsi = false;
            roleTmp.text = "كلمة";
            roleTmp.fontSize = 0.85f;
            roleTmp.enableAutoSizing = true;
            roleTmp.fontSizeMin = 0.48f;
            roleTmp.fontSizeMax = 0.85f;
            roleTmp.alignment = TextAlignmentOptions.Center;
            roleTmp.color = CreamColor;
            roleTmp.rectTransform.sizeDelta = new Vector2(0.40f, 0.10f);
            ArabicTypography.ApplyTo(roleTmp);

            var backRoot = new GameObject("BackArtwork");
            backRoot.transform.SetParent(root.transform, false);
            CreateLayer(
                backRoot.transform,
                "VerticalBand",
                new Vector3(0f, 0f, -0.038f),
                new Vector3(0.13f, 0.72f, 1f),
                BackAccentColor);
            CreateMedallion(backRoot.transform);

            var labelGo = new GameObject("Label");
            labelGo.transform.SetParent(root.transform, false);
            labelGo.transform.localPosition = new Vector3(0f, -0.035f, -0.068f);
            var tmp = labelGo.AddComponent<RTLTextMeshPro3D>();
            tmp.PreserveNumbers = true;
            tmp.Farsi = false;
            tmp.fontSize = 2.2f;
            tmp.enableAutoSizing = true;
            tmp.fontSizeMin = 1.2f;
            tmp.fontSizeMax = 2.2f;
            tmp.alignment = TextAlignmentOptions.Center;
            tmp.color = InkColor;
            tmp.rectTransform.sizeDelta = new Vector2(0.54f, 0.55f);
            ArabicTypography.ApplyTo(tmp);

            var box = root.GetComponent<BoxCollider>();
            box.size = new Vector3(0.72f, 0.98f, 0.08f);
            box.center = Vector3.zero;

            var view = root.AddComponent<CardView>();
            view.label = tmp;
            view.faceRenderer = face.GetComponent<MeshRenderer>();
            view.borderRenderer = border.GetComponent<MeshRenderer>();
            view.insetRenderer = inset.GetComponent<MeshRenderer>();
            view.roleBadge = roleRoot;
            view.roleRenderer = roleRibbon.GetComponent<MeshRenderer>();
            view.roleLabel = roleTmp;
            view.backArtwork = backRoot;
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
            var collider = layer.GetComponent<Collider>();
            if (collider != null)
            {
                collider.enabled = false;
            }

            return layer;
        }

        private static void CreateMedallion(Transform parent)
        {
            var medallion = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
            medallion.name = "MeaningMedallion";
            medallion.transform.SetParent(parent, false);
            medallion.transform.localPosition = new Vector3(0f, 0f, -0.052f);
            medallion.transform.localRotation = Quaternion.Euler(90f, 0f, 0f);
            medallion.transform.localScale = new Vector3(0.26f, 0.012f, 0.26f);
            PrototypeMaterial.Apply(medallion.GetComponent<Renderer>(), CreamColor);
            var collider = medallion.GetComponent<Collider>();
            if (collider != null)
            {
                collider.enabled = false;
            }
        }

        private IEnumerator AnimateEntrance(Vector3 targetPosition, float delay, float duration)
        {
            transform.localPosition = targetPosition + new Vector3(0f, 0.18f, -0.08f);
            transform.localRotation = Quaternion.Euler(0f, 0f, -4f);
            if (delay > 0f)
            {
                yield return new WaitForSecondsRealtime(delay);
            }

            var startPosition = transform.localPosition;
            var startRotation = transform.localRotation;
            var elapsed = 0f;
            while (elapsed < duration)
            {
                elapsed += Time.unscaledDeltaTime;
                var t = Mathf.SmoothStep(0f, 1f, Mathf.Clamp01(elapsed / duration));
                transform.localPosition = Vector3.LerpUnclamped(startPosition, targetPosition, t);
                transform.localRotation = Quaternion.SlerpUnclamped(startRotation, Quaternion.identity, t);
                yield return null;
            }

            transform.localPosition = targetPosition;
            transform.localRotation = Quaternion.identity;
            _entranceRoutine = null;
        }

        private IEnumerator AnimateScale(Vector3 targetScale, float duration)
        {
            var startScale = transform.localScale;
            var elapsed = 0f;
            while (elapsed < duration)
            {
                elapsed += Time.unscaledDeltaTime;
                var t = Mathf.SmoothStep(0f, 1f, Mathf.Clamp01(elapsed / duration));
                transform.localScale = Vector3.LerpUnclamped(startScale, targetScale, t);
                yield return null;
            }

            transform.localScale = targetScale;
            _highlightRoutine = null;
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
